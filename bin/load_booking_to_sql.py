# coding: utf-8
from __future__ import print_function
from extract_bookings_single_attachment import extract_booking
from md5_for_file import md5_for_file
from sqlalchemy import create_engine
from sqlalchemy.exc import IntegrityError
import os, sys, logging
HOME = os.environ['HOME']

log_dir = HOME + '/scripts/lvmpd_emails/logs/'
db_log_file_name = log_dir + 'bookings_errs.log'
logging.basicConfig(filename=db_log_file_name, level=logging.WARN, format='%(asctime)s %(message)s')
logging.getLogger('sqlalchemy.engine').setLevel(logging.WARN)

conn = "postgresql://acohen:" + os.environ['PGPASSWORD'] + "@" + os.environ['ENDPOINT'] + ":5432/lvmetro"

try:
    booking_file = sys.argv[1]
    booking = extract_booking(booking_file)
    booking['filemd5'] = md5_for_file(booking_file)
    engine = create_engine(conn, echo=False)
    booking.to_sql('bookings',engine, if_exists='append',index_label='row_id')
except IntegrityError:
    print('Error loading',booking_file)
    logging.error('IntegrityError loading %s',booking_file)
except Exception as e:
    print('Error loading',booking_file,e)
    logging.error('Error loading %s',booking_file + ', ' + str(e))

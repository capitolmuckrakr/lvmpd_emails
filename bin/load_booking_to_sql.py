# coding: utf-8
from extract_bookings_single_attachment import extract_booking
from sqlalchemy import create_engine
import os, sys
booking_file = sys.argv[1]
conn = "postgresql://acohen:" + os.environ['PGPASSWORD'] + "@" + os.environ['ENDPOINT'] + ":5432/lvmetro"
engine = create_engine(conn)
booking = extract_booking(booking_file)
booking.to_sql('bookings',engine, if_exists='append',index_label='row_id')

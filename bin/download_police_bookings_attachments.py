# coding: utf-8
from __future__ import print_function
import imaplib, email, os, logging

home_dir = os.path.expanduser('~')
log_dir = home_dir + '/scripts/lvmpd_emails/logs/'
db_log_file_name = log_dir + 'bookings_errs.log'
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger('download_police_bookings_attachments')
handler = logging.FileHandler(db_log_file_name)
handler.setLevel(logging.WARN)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)
previous_messages_count_log_name = log_dir + 'previous_messages_count.log'
previous_messages_count = 0
try:
    with open(previous_messages_count_log_name) as oldcount:
        previous_messages_count = oldcount.read().strip()
except Exception, e:
    logger.warn('Problem fetching previous message count,', exc_info=True)
if 'RJGMAILDATADIR' in os.environ:
    data_dir = os.environ['RJGMAILDATADIR']
else:
    data_dir = home_dir + '/data/LVMPD/BOOKINGS'

ORG_EMAIL = "@reviewjournal.com"
FROM_EMAIL = os.environ['RJGMAILUSERNAME'] + ORG_EMAIL
FROM_PWD = os.environ['RJGMAILPASSWORD']
SMTP_SERVER = "imap.gmail.com"
SMTP_PORT   = 993
if 'RJGMAILFOLDER' in os.environ:
    FOLDER = os.environ['RJGMAILFOLDER']
else:
    FOLDER = "Police/lvmpd_bookings_log"
mail = imaplib.IMAP4_SSL(SMTP_SERVER)
try:
    mail.login(FROM_EMAIL,FROM_PWD)
    resp, count = mail.select(FOLDER)
    logger.info('Found %s messages in folder. Downloading attachments and saving them to %s',count[0],data_dir)
    if int(count[0]) <= int(previous_messages_count):
        logger.warn('Current message count of %s should be greater than old message count of %s. Bookings may be missing.',count[0],previous_messages_count)
    else:
        with open(previous_messages_count_log_name,'w') as oldcount:
            oldcount.write(count[0])
    resp, data = mail.uid('search',None, 'ALL')
    id_list = data[0].split()
    
    for id in id_list:
        resp, data = mail.fetch(int(id), '(RFC822)' )
        email_body = data[0][1]
        m = email.message_from_string(email_body)
        if m.get_content_maintype() != 'multipart':
            continue
        for part in m.walk():
            if part.get_content_maintype() == 'multipart':
                continue
            filename=part.get_filename()
            if filename is not None:
                path = os.path.join(data_dir, filename)
                if not os.path.isfile(path):
                    with open(path, 'wb') as fp:
                        fp.write(part.get_payload(decode=True))
except Exception, e:
    logger.error('Problem downloading attachments,', exc_info=True)
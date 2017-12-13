# coding: utf-8
from __future__ import print_function
import imaplib, email, os

home_dir = os.path.expanduser('~')
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
mail.login(FROM_EMAIL,FROM_PWD)
resp, count = mail.select(FOLDER)
print('Found',count[0],'messages in folder. Downloading attachments and saving them to',data_dir)
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
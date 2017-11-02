# coding: utf-8
import imaplib, email, os

home_dir = os.path.expanduser('~')

data_dir = home_dir + '/data/LVMPD/COM_CENTER_STATS'

ORG_EMAIL = "@reviewjournal.com"
FROM_EMAIL = "acohen" + ORG_EMAIL
FROM_PWD = "Current.Biology"
SMTP_SERVER = "imap.gmail.com"
SMTP_PORT   = 993
mail = imaplib.IMAP4_SSL(SMTP_SERVER)
mail.login(FROM_EMAIL,FROM_PWD)
resp, count = mail.select("Police/lvmpd_stats")
resp, data = mail.search(None, 'ALL')
mail_ids = data[0]
id_list = mail_ids.split()

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
            prefix = ''
            if int(id) < 100000:
                prefix = '0'
                if int(id) < 10000:
                    prefix = '00'
                    if int(id) < 1000:
                        prefix = '000'
                        if int(id) < 100:
                            prefix = '0000'
                            if int(id) < 10:
                                prefix = '00000'
            filename = prefix + id + '_' + filename
            path = os.path.join(data_dir, filename)
            if not os.path.isfile(path):
                with open(path, 'wb') as fp:
                    fp.write(part.get_payload(decode=True))

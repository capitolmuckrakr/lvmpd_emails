# coding: utf-8
from __future__ import print_function
import imaplib, email, os, logging

home_dir = os.path.expanduser('~')
log_dir = home_dir + '/scripts/lvmpd_emails/logs/'
db_log_file_name = log_dir + 'stats_errs.log'
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger('download_police_stat_attachments')
handler = logging.FileHandler(db_log_file_name)
handler.setLevel(logging.WARN)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)
previous_messages_count_log_name = log_dir + 'previous_stat_count.log'
previous_messages_count = 0
try:
    with open(previous_messages_count_log_name) as oldcount:
        previous_messages_count = oldcount.read().strip()
except Exception, e:
    logger.warn('Problem fetching previous stat count,', exc_info=True)

data_dir = home_dir + '/data/LVMPD/COM_CENTER_STATS'

ORG_EMAIL = "@reviewjournal.com"
FROM_EMAIL = os.environ['RJGMAILUSERNAME'] + ORG_EMAIL
FROM_PWD = os.environ['RJGMAILPASSWORD']
SMTP_SERVER = "imap.gmail.com"
SMTP_PORT   = 993
mail = imaplib.IMAP4_SSL(SMTP_SERVER)
mail.login(FROM_EMAIL,FROM_PWD)
try:
    resp, count = mail.select("Police/lvmpd_stats")
    logger.info('Found %s messages in folder. Downloading attachments and saving them to %s',count[0],data_dir)
    if int(count[0]) <= int(previous_messages_count):
        logger.warn('Current message count of %s should be greater than old message count of %s. Stat files may be missing.',count[0],previous_messages_count)
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
except Exception, e:
    logger.error('Problem downloading attachments,', exc_info=True)

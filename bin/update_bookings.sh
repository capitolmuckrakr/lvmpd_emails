#!/bin/bash
ipython download_police_bookings_attachments.py 2>>../logs/bookings_errs.log
./load_new_bookings_to_sql.sh

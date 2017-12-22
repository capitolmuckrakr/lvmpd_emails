#!/bin/bash
ipython download_police_bookings_attachments.py
./load_new_bookings_to_sql.sh

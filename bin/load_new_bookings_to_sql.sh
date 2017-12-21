#!/bin/bash

export SQL_DIR="${HOME}/scripts/lvmpd_emails/bin/sql/"
export last_booking=$(psql --host=${ENDPOINT} --port=5432 --username=acohen --dbname=lvmetro -f ${SQL_DIR}latest_loaded_booking.sql | head -n3 | tail -n1 | cut -d ',' -f 1)
export bookings_count=$(ls ~/data/LVMPD/BOOKINGS/*ITAG*ALL*.htm | wc -l)
export bookings_loaded_count=$(ls ~/data/LVMPD/BOOKINGS/*ITAG*ALL*.htm | grep -n $last_booking | cut -d ':' -f 1)
export bookings_unloaded_count=$(python -c 'import os; print int(os.environ["bookings_count"])-int(os.environ["bookings_loaded_count"])')
OLDIFS=$IFS
IFS=$'\n'
for booking in $(ls ~/data/LVMPD/BOOKINGS/*ITAG*ALL*.htm | tail -n $bookings_unloaded_count)
do
echo 'loading' $booking
ipython load_booking_to_sql.py $booking
done
IFS=OLDIFS

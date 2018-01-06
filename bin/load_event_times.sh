#!/bin/bash
CSV_PATH=$1
cat $CSV_PATH | psql --host=${ENDPOINT} --port=5432 --username=acohen --dbname=lvmetro -c "\copy event_times (filename,filedate,filetime,eventdate,starttime,endtime) FROM '$CSV_PATH' WITH DELIMITER '|' NULL '' CSV HEADER "

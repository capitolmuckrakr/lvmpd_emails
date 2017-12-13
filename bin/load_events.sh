#!/bin/bash
CSV_PATH=$1
cat $CSV_PATH | psql --host=${ENDPOINT} --port=5432 --username=acohen --dbname=lvmetro -c "\copy events (filename,type,description,event_num,disposition,event_time,address) FROM '$CSV_PATH' WITH NULL '' CSV HEADER "

#!/bin/bash
PATH="${HOME}/data/LVMPD/police_codes.txt"
cat $PATH | psql --host=${ENDPOINT} --port=5432 --username=acohen --dbname=lvmetro -c "\copy lk_dispositioncodes (code,definition) FROM '$PATH' WITH HEADER "

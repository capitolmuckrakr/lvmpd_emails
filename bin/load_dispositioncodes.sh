#!/bin/bash
DATAPATH="${HOME}/data/LVMPD/police_codes.txt"
cat $DATAPATHDATAPATH | psql --host=${ENDPOINT} --port=5432 --username=acohen --dbname=lvmetro -c "\copy lk_dispositioncodes (code,definition) FROM '$DATAPATH' "

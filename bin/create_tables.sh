#!/bin/bash
export SQL_DIR="${HOME}/scripts/lvmpd_emails/bin/sql/"
psql --host=${ENDPOINT} --port=5432 --username=acohen --dbname=lvmetro -f ${SQL_DIR}bookings.sql
psql --host=${ENDPOINT} --port=5432 --username=acohen --dbname=lvmetro -f ${SQL_DIR}events.sql
psql --host=${ENDPOINT} --port=5432 --username=acohen --dbname=lvmetro -f ${SQL_DIR}event_times.sql
#psql --host=${ENDPOINT} --port=5432 --username=acohen --dbname=lvmetro -f ${SQL_DIR}bookings_eventid_lookup.sql
#psql --host=${ENDPOINT} --port=5432 --username=acohen --dbname=lvmetro -f ${SQL_DIR}stats_eventid_lookup.sql

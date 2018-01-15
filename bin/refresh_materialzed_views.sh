#!/bin/bash
export SQL_DIR="${HOME}/scripts/lvmpd_emails/bin/sql/"
psql --host=${ENDPOINT} --port=5432 --username=acohen --dbname=lvmetro -f ${SQL_DIR}refresh_bookings_view.sql
psql --host=${ENDPOINT} --port=5432 --username=acohen --dbname=lvmetro -f ${SQL_DIR}refresh_calls_view.sql
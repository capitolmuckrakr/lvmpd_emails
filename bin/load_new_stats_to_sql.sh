#!/bin/bash
export SQL_DIR="${HOME}/scripts/lvmpd_emails/bin/sql/"
export last_stat=$(psql --host=${ENDPOINT} --port=5432 --username=acohen --dbname=lvmetro -f ${SQL_DIR}latest_loaded_stat.sql | head -n3 | tail -n1 | cut -d ',' -f 1)
export stats_count=$(ls ~/data/LVMPD/COM_CENTER_STATS/*.TXT | wc -l)
export stats_loaded_count=$(ls ~/data/LVMPD/COM_CENTER_STATS/*.TXT | grep -n $last_stat | cut -d ':' -f 1)
export stats_unloaded_count=$(python -c 'import os; print int(os.environ["stats_count"])-int(os.environ["stats_loaded_count"])')
OLDIFS=$IFS
IFS=$'\n'
for stat in $(ls ~/data/LVMPD/COM_CENTER_STATS/*.TXT | tail -n $stats_unloaded_count)
do
./extract_stat_single_attachment_date_time.sh $stat >~/data/LVMPD/COM_CENTER_STATS/loaded/stat_dates_times_new.txt
./extract_stat_single_attachment_events.sh $stat >~/data/LVMPD/COM_CENTER_STATS/loaded/stat_events_new.txt
./load_event_times.sh ~/data/LVMPD/COM_CENTER_STATS/loaded/stat_dates_times_new.txt
./load_events.sh ~/data/LVMPD/COM_CENTER_STATS/loaded/stat_events_new.txt
done
IFS=OLDIFS

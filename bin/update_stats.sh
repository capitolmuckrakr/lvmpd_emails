#!/bin/bash
ipython download_police_stat_attachments.py
./load_new_stats_to_sql.sh

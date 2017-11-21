DIR_PATH=$1
cd $DIR_PATH
echo "filename|type|description|event_no|disp|time|address"
for file in *.TXT
    do
    /Users/acohen/scripts/lvmpd_emails/extract_stat_single_attachment_events.sh $file | grep -v filename
done

DIR_PATH=$1
cd $DIR_PATH
echo "filename|filedate|filetime|eventdate|starttime|endtime"
for filename in *.TXT
    do
    filedate=$(head -1 $filename | cut -d ':' -f 3 | sed -e 's/^[ ]*//g' | sed -e 's/ /\|/g' | cut -d '|' -f 1)
    filetime=$(head -1 $filename | cut -d ':' -f 4,5 | sed -e 's/^[ ]*//g' | sed -e 's/ /\|/g' | cut -d '|' -f 1)
    eventdatetime=$(head -3 $filename | tail -1 | sed -e 's/^[ ]*//g' | awk '{gsub(/ +/," ")} {print $0}')
    export eventdate=$(echo $eventdatetime | sed -e 's/ /\|/g' | cut -d '|' -f 2,3,4 | sed -e 's/|/ /g')
    export eventdate=$(python -c 'import datetime, os; string_date = os.environ["eventdate"]; fmt = "%B %d, %Y"; print(datetime.datetime.strptime(string_date, fmt).strftime("%m/%d/%Y"))')
    starttime=$(echo $eventdatetime | sed -e 's/ /\|/g' | cut -d '|' -f 5)
    endtime=$(echo $eventdatetime | sed -e 's/ /\|/g' | cut -d '|' -f 7)
    echo $filename"|"$filedate"|"$filetime"|"$eventdate"|"$starttime"|"$endtime
done

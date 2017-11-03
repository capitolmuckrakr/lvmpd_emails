file=$1
noheader=$2
if [[ $noheader != '--no-header' ]]
then
    echo "filename|type|description|event_no|disp|time|address"
fi

filename=$(echo $file | rev | cut -d '/' -f 1 | rev)
OLDIFS=$IFS
IFS=$'\n'
for line in $(egrep -a '^\d' $file)
    do
    line_1=$(echo $line | awk '{sub(/ +/,"|")} {print $0}' | awk '{gsub(/  +/,"|")} {print $0}')
    line_a=$(echo $line_1 | cut -d '|' -f 3 | awk '{sub(/ +/,"|")} {print $0}')
    line_b=$(echo $line_1 | cut -d '|' -f 4 | awk '{sub(/ +/,"|")} {print $0}')
    line_c=$(echo $line_1 | cut -d '|' -f 1,2)
    echo $filename"|"$line_c"|"$line_a"|"$line_b | sed 's/\r//g' | cut -d '|' -f 1,2,3,4,5,6,7
done
IFS=OLDIFS

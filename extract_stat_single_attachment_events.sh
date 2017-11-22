file=$1
n=1
noheader=$2
if [[ $noheader == '--no-header' ]]
then
    n=2
fi
schema=$HOME'/data/LVMPD/COM_CENTER_STATS/schema.csv'
filename=$(echo $file | rev | cut -d '/' -f 1 | rev)
OLDIFS=$IFS
IFS=$'\n'

for line in $(egrep -a '^[0-9]' $file | in2csv -H -f fixed -s $schema)
    do
    if [[ $n == 1 ]]
    then
        echo 'filename,'$line | csvcut -c 1-7
    else
        echo $filename,$line | csvcut -c 1-7 | grep -v 'event_no'
    fi
    n=$((n + 1))
done
IFS=$OLDIFS

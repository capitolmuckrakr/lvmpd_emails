file=$1
noheader=$2
if [[ $noheader != '--no-header' ]]
then
    echo "filename|filedate|filetime|starttime|endtime"
fi

filename=$(echo $file | rev | cut -d '/' -f 1 | rev)
filedate=$(head -1 $file | cut -d ':' -f 3 | sed -e 's/^[ ]*//g' | sed -e 's/ /\|/g' | cut -d '|' -f 1)
filetime=$(head -1 $file | cut -d ':' -f 4,5 | sed -e 's/^[ ]*//g' | sed -e 's/ /\|/g' | cut -d '|' -f 1)
starttime=$(head -3 $file | tail -1 | sed -e 's/^[ ]*//g' | awk '{gsub(/ +/," ")} {print $0}' | sed -e 's/ /\|/g' | cut -d '|' -f 5)
endtime=$(head -3 $file | tail -1 | sed -e 's/^[ ]*//g' | awk '{gsub(/ +/," ")} {print $0}' | sed -e 's/ /\|/g' | cut -d '|' -f 7)
echo $filename"|"$filedate"|"$filetime"|"$starttime"|"$endtime

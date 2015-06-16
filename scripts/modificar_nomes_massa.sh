
ls -lC1 * | while read line
do
	new1=`echo "$line"|sed 's/ /_/g'`
	mv "$line" "$new1"
	new2=`echo "$line"|sed 's/_-_/-/g'`
	mv "$line" "$new2"
	new3=`echo "$line"|tr [A-Z] [a-z]`
	mv "$line" "$new3"
done

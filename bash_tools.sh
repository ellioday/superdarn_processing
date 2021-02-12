#function to remove leading zeros from varable (unless variable is zero)
strip_zero(){
	value=$1
	if [[ $value == "00" ]]
	then
		retval=0
	else
		retval=$(echo $value | sed 's/^0*//')
	fi
}

#strip zero test
#array=("00" "01" "02")
#for val in "${array[@]}"
#do
#	echo "val = $val"
#	strip_zero $val
#	echo $retval
#done
#
#test=$(strip_zero "08" && echo $retval)
#echo "testing is $test"

#function to check if one date is less than another
date_compare() {
	#date1 = date to check
	#date2 = reference date (e.g. start/end date)
	date1=$1
	date2=$2
	
	#get individual Year (YY), month(MM), day(DD), hour(hh), min(mm) & sec(ss)
	#and remove leading zeros
	YY1=${date1:0:4}
	MM1=$(strip_zero ${date1:5:2} && echo $retval)
	DD1=$(strip_zero ${date1:8:2} && echo $retval)
	hh1=$(strip_zero ${date1:11:2} && echo $retval)
	mm1=$(strip_zero ${date1:14:2} && echo $retval)
	ss1=$(strip_zero ${date1:17:2} && echo $retval)

	YY2=${date2:0:4}
	MM2=$(strip_zero ${date2:5:2} && echo $retval)
	DD2=$(strip_zero ${date2:8:2} && echo $retval)
	hh2=$(strip_zero ${date2:11:2} && echo $retval)
	mm2=$(strip_zero ${date2:14:2} && echo $retval)
	ss2=$(strip_zero ${date2:17:2} && echo $retval)

	if [[ $MM1 -gt $MM2 ]]
	then
		retval=">"
	elif [[ $MM1 -lt $MM2 ]]
	then
		retval="<"
	#otherwise monhts are equal
	else
		if [[ $DD1 -lt $DD2 ]]
		then
			retval="<"
		elif [[ $DD1 -gt $DD2 ]]
		then
			retval=">"
		#otherwise days are equal so...
		elif [[ $hh1 -lt $hh2 ]]
		then
			retval="<"
		elif [[ $hh1 -gt $hh2 ]]
		then
			retval=">"
		#otherwise hours are equal so...
		elif [[ $mm1 -lt $mm2 ]]
		then
			retval="<"
		elif [[ $mm1 -gt $mm2 ]]
		then
			retval=">"
		#otherwise minutes are equal so...
		elif [[ $ss1 -lt $ss2 ]]
		then
			retval="<"
		elif [[ $ss1 -ge $ss2 ]]
		then
			retval=">"
		fi
	fi
}

#test date_compare function
#all less than scenarios (month -> day -> hour -> minute -> second)
#echo "less than tests:"
#date_compare "2013/09/02_00:00:00" "2013/10/02_00:00:00"
#date_compare "2013/10/01_00:00:00" "2013/10/02_00:00:00"
#date_compare "2013/10/02_00:00:00" "2013/10/02_10:10:10"
#date_compare "2013/10/02_10:00:00" "2013/10/02_10:10:10"
#date_compare "2013/10/02_10:10:00" "2013/10/02_10:10:10"
#test greater than scenarios (month -> day -> hour -> minute -> second)
#echo "greater than tests:"
#date_compare "2013/11/02_00:00:00" "2013/10/02_00:00:00"
#date_compare "2013/10/03_00:00:00" "2013/10/02_00:00:00"
#date_compare "2013/10/02_10:00:00" "2013/10/02_00:00:00"
#date_compare "2013/10/02_10:10:00" "2013/10/02_10:00:00"
#date_compare "2013/10/02_10:10:10" "2013/10/02_10:10:00"

#first check if year is a leap year
isleap() {
	in_year=$1
	(( !(in_year % 4) && ( in_year % 100 || !(in_year % 400) ) )) &&
		leapyear=true || leapyear=false
}

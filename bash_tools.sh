#set the path to the file containing the path to the luna drive
luna_path=$(</home/elliott/Documents/python_analysis/luna_path.txt)

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

#first check if year is a leap year
isleap() {
	in_year=$1
	(( !(in_year % 4) && ( in_year % 100 || !(in_year % 400) ) )) &&
		leapyear=true || leapyear=false
}

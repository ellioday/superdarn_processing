#Load path to luna data
luna_path=$(</home/elliott/Documents/python_analysis/superdarn_data_path.txt)
#get stations where data is requested
stations=("fhe" "bks")
start_date="2013/10/02_00:00:00"
end_date="2013/10/02_23:59:59"

fitacf_path="${luna_path}/fitacf/${start_date:0:4}"

#function to check if one date is less than another
date_compare() {
	#date1 = date to check
	#date2 = reference date (e.g. start/end date)
	date1=$1
	date2=$2

	YY1=${date1:0:4}
	MM1=$(echo ${date1:5:2} | sed 's/^0*//')
	DD1=$(echo ${date1:8:2} | sed 's/^0*//')
	hh1=$(echo ${date1:11:2} | sed 's/^0*//')
	mm1=$(echo ${date1:14:2} | sed 's/^0*//')
	ss1=$(echo ${date1:17:2} | sed 's/^0*//')

	YY2=$(echo ${date2:0:4} | sed 's/^0*//')
	MM2=$(echo ${date2:5:2} | sed 's/^0*//')
	DD2=$(echo ${date2:8:2} | sed 's/^0*//')
	hh2=$(echo ${date2:11:2} | sed 's/^0*//')
	mm2=$(echo ${date2:14:2} | sed 's/^0*//')
	ss2=$(echo ${date2:17:2} | sed 's/^0*//')

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

	echo "$date1 $retval $date2"
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

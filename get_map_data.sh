#Load path to luna data
luna_path=$(</home/elliott/Documents/python_analysis/superdarn_data_path.txt)
fitacf_path="${luna_path}/fitacf/"

#get stations where data is requested
stations=("fhe" "bks")
start_date="2013/10/02_00:00:00"
end_date="2013/10/02_23:59:59"

#function to check if one date is less than another
date_compare() {
	#date1 = date to check
	#date2 = reference date (e.g. start/end date)
	date1=$1
	date2=$2

	YY1=${date1:0:4}
	MM1=${date1:5:2}
	DD1=${date1:8:2}
	hh1=${date1:11:2}
	mm1=${date1:14:2}
	ss1=${date1:17:2}

	YY2=${date2:0:4}
	MM2=${date2:5:2}
	DD2=${date2:8:2}
	hh2=${date2:11:2}
	mm2=${date2:14:2}
	ss2=${date2:17:2}

	if [[ $MM1 -gt $MM2 ]]
	then
		retval=">"
	elif [[ $MM1 -lt $MM2 ]]
	then
		retval="<"
	#otherwise monhts are equal
	else
		if [[ $DD1 -lt $DD1 ]]
		then
			retval="<"
		elif [[ $DD1 -gt $DD1 ]]
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

date_compare $start_date $end_date

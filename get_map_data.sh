#Load path to luna data
luna_path=$(</home/elliott/Documents/python_analysis/luna_path.txt)
#get stations where data is requested
stations=("fhe" "bks")
rad="fhe"
start_date="2013/10/02_00:00:00"
end_date="2013/10/02_23:59:59"
year=${start_date:0:4}

fitacf_path="${luna_path}data/superdarn/fitacf/"

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

#get all filenames in directory
#fitacf_fnames=$(ls "$fitacf_path$(echo ${stations[0]})/$year/")

#check if year is a leap year
isleap() {
	in_year=$1
	(( !(in_year % 4) && ( in_year % 100 || !(in_year % 400) ) )) &&
		leapyear=true || leapyear=false
}

#get number of days in each month for this year
isleap $year
if [[ $leapyear ]];
then
	days=(31 28 31 30 31 30 31 31 30 31 30 31)
else
	days=(31 29 31 30 31 30 31 31 30 31 30 31)
fi

#convert each day's worth of fitacf into grid files
for ((month = 1 ; month<=12 ; month++)) do
	month_02d=$(printf %02d $month)
	for ((day = 1 ; day<=${days[$i]} ; day++)) do
		day_02d=$(printf %02d $day)
		make_grid -vb -tl 60 -xtd -c $year$month_02d$day_02d.*.*.$rad.fitacf > ${luna_path}users/daye1/Superdarn/Data/grid/$year$month_02d$day_02d.$rad.grd
	done
done

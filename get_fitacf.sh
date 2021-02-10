#gets all fitacf data between two dates for one station off of luna drive (and un bz2 zips them)

#Load path to luna data
luna_path=$(</home/elliott/Documents/python_analysis/luna_path.txt)
rad="fhe"
year="2013"
fitacf_path="${luna_path}data/superdarn/fitacf/"
start_date="2013/10/02_00:00:00"
end_date="2013/10/02_23:59:59"

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

#get all filenames in directory
echo "loading file list..."
fpath="${fitacf_path}${rad}/${year}/"
#use nullglob in case there are no matching files
shopt -s nullglob
#fitacf_fnames=$(ls $fpath)
fitacf_fnames=(${fpath}*)
echo "file list loaded"
num_files=$(ls | wc -l)
bound_start=false
bound_end=false
i=0
while [[ !bound_end ]] || [[ $i -le $num_files ]]
do

	#file is the full path to the file
	path_to_file=${fitacf_fnames[i]}
	#get just the name of the file
	file=${path_to_file##*/}

	echo "file name $i is $file"

	#get time of file
	YY=${file:0:4}
	MM=${file:4:2}
	DD=${file:6:2}
	hh=${file:9:2}
	mm=${file:11:2}
	ss=${file:14:2}
	time="$YY/$MM/${DD}_$hh:$mm:$ss"
	
	#find if file time is between start/end times
	date_compare $time $start_date
	start_con=$retval
	date_compare $time $end_date
	end_con=$retval

	#echo "$start_date $start_con $time $end_con $end_date"

	#check if file time is after start time
	if [[ !bound_start ]]
	then
		if [[ $start_con == ">" ]]
		then
			echo "start file found"
			bound_start=true
		else
			i=$((i+1))
			continue
		fi
	fi

	#copy and unzip file
	if [[ bound_start ]] && [[ !bound_end ]]
	then
		echo "entered bounds..."
		fpath_from="$fpath$file"
		fpath_to="${luna_path}users/daye1/Superdarn/Data/fitacf/$rad/$year/$MM/"
		staging_area="staging_area/"
		echo "copying to directoy..."
		#unable to unzip on network drive, so copy to a local staging area
		mkdir -p $staging_area && cp $fpath_from $staging_area
		#unzip here
		echo "unzipping..."
		bzip2 -d "$staging_area$file"
		#move unzipped file to network drive
		echo "moving unzipped file"
		mkdir -p "$staging_area" && mv "$staging_area${file%.bz2}" "$fpath_to"
		echo "done"
	fi

	#check if file time is after end time
	if [[ bound_start ]]
	then
		if [[ $end_con == ">" ]]
		then
			bound_end=true
			break
		fi
	fi


	i=$((i+1))

done

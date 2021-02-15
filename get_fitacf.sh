help(){

	echo "This scipt retrieves all fitacf data between two dates for one station off of the luna drive (and un bz2 zips them)"

	echo
	echo "inputs:"
	echo "3-letter station code (AAA)"
	echo "start_date (YYYY/MM/DD_hh/mm/ss)"
	echo "end_date (YYY/MM/DD_hh/mm/ss)"
	echo "verbose level (0/1/2)"
}

#load functions
source bash_tools.sh

#Load path to luna data
luna_path=$(</home/elliott/Documents/python_analysis/luna_path.txt)
fitacf_path="${luna_path}data/superdarn/fitacf/"

#get input parameters
rad=$1
echo "rad = $rad"
start_date=$2
end_date=$3
verbose=${4:-0}
year=${start_date:0:4}

fpath="${fitacf_path}${rad}/${year}/"
echo $fpath
#use nullglob in case there are no matching files
shopt -s nullglob
fitacf_fnames=(${fpath}*)
if [[ $verbose -gt 0 ]]
then
	echo "file list loaded"
fi

#get number of days in each month for this year
isleap $year
if [[ $leapyear ]];
then
	days=(31 28 31 30 31 30 31 31 30 31 30 31)
else
	days=(31 29 31 30 31 30 31 31 30 31 30 31)
fi

if [[ $verbose -gt 0 ]]
then
	echo "skipping to start date"
fi

#sum up how many days until the month of the start date
start_month=$(strip_zero ${start_date:5:2} && echo $retval)
start_day=$(strip_zero ${start_day:8:2} && echo $retval)
num_days=0
i=0
while [[ $i -lt $((start_month-1)) ]]
do
	days_in_month=${days[i]}
	num_days=$((num_days+$days_in_month))
	i=$((i+1))
done

#set start conditions
num_files=${#fitacf_fnames[@]}
bound_start="false"
bound_end="false"
i=$(($num_days*12)) # based on 12 files per day from each file ~ 2 hours

while ! $bound_end || [[ $i -le $num_files ]]
do

	#file is the full path to the file
	path_to_file=${fitacf_fnames[i]}
	#get just the name of the file
	file=${path_to_file##*/}

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

	if [[ $verbose -gt 1 ]]
	then
		echo "$start_date $start_con $time $end_con $end_date"
		echo "file name $i is $file in bound_start=$bound_start bound_end=$bound_end"
	fi

	#echo "$start_date $start_con $time $end_con $end_date"

	#check if file time is after start time
	if ! $bound_start
	then
		if [[ $start_con == ">" ]] && [[ $end_con == "<" ]]
		then
			if [[ $verbose -gt 0 ]]
			then
				echo "start file found"
			fi
			bound_start="true"
		#if our skipping has brought us to a month >= the start date then go back
		#a month so we can work our way up to the start date
		elif [[ $start_con == ">" ]] && [[ $end_con == ">" ]]
		then
			i=$((i-(16*12)))
			continue
		fi
	fi

	echo "bound start checked"

	#check if file time is after end time
	if $bound_start
	then
		if [[ $end_con == ">" ]]
		then
			if [[ $verbose -gt 0 ]]
			then
				echo "all files within dates found"
			fi
			bound_end=true
			break
		fi
	fi

	#copy and unzip file
	if $bound_start && ! $bound_end
	then
		if [[ verbose -gt 0 ]]
		then
			echo "entered bounds..."
		fi
		fpath_from="$fpath$file"
		fpath_to="${luna_path}users/daye1/Superdarn/Data/fitacf/$rad/$year/$MM/"
		staging_area="staging_area/"
		if [[ $verbose -gt 0 ]]
		then
			echo "copying to staging area..."
		fi
		#unable to unzip on network drive, so copy to a local staging area
		mkdir -p $staging_area && cp $fpath_from $staging_area
		#unzip here
		if [[ $verbose -gt 0 ]]
		then
			echo "unzipping..."
		fi
		bzip2 -d "$staging_area$file"
		#move unzipped file to network drive
		if [[ $verbose -gt 0 ]]
		then
			echo "copying unzipped file to directory..."
		fi
		mkdir -p "$fpath_to" && cp "$staging_area${file%.bz2}" "$fpath_to"
		if [[ $verbose -gt 0 ]]
		then
			echo "removing file from staging area..."
		fi
		rm "$staging_area${file%.bz2}"
		if [[ $verbose -gt 0 ]] 
		then
			echo "done"
		fi
	fi

	i=$((i+1))

done

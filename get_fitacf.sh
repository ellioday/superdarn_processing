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
echo $fitacf_fnames

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
echo "num_files = $num_files"
if [[ $num_files -eq 0 ]]
then
	echo "no files found"
	exit 1
fi
#since bool doesnt work in bask use 0=false, 1=true
bound_start=false
bound_end=false
does_time_preceed=false
i=$(($num_days*12)) # based on 12 files per day from each file ~ 2 hours

#if i is greater than the number of files we need to move i to the end
if [[ $i -gt $num_files ]]
then
	i=$((num_files-1))
fi

while ! $bound_end && [[ $i -le $num_files ]]
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
		#when files have gone back such that the time preceeds the start time
		#we can expect to encounter the start time (if it is there)
		if [[ $start_con == "<" ]]
		then
			does_time_preceed=true
		fi

		if [[ $start_con == ">" ]] && [[ $end_con == "<" ]]
		then
			if [[ $verbose -gt 0 ]]
			then
				echo "start file found"
			fi
			bound_start=true
		#if our skipping has brought us to a month >= the start date then go back
		#a month so we can work our way up to the start date
		elif [[ $start_con == ">" ]] && [[ $end_con == ">" ]]
		then
			#if we haven't already gone back before the start date keep going back
			if ! $does_time_preceed
			then
				i=$((i-(16*12)))
				continue
			#else if we have already gone before the start date then there are no
			#files within the requested times
			else
				bound_end=true
			fi
		fi
	fi

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
		fi
	fi

	#copy and unzip file
	if $bound_start && ! $bound_end
	then
		if [[ verbose -gt 0 ]]

		then
			echo "entered bounds..."
		fi
		if [[ $verbose -eq 1 ]]
		then
			echo "file name $i is $file"
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
		
		#remove bz2 from filename		
		savename=${file%.bz2}
		#some files have extra bits after the seconds metadata that we dont want in
		#their name e.g.(YYYYMMDD.hhmm.ss.a.rad.fitacf <- we don't want the ".a")
		echo "${savename:21:3} ${rad}"
		if [[ "${savename:21:3}" != "fit" ]]
		then
			echo "savename was $savename"
			savename=${savename:0:21}${savename:23:6}
			echo "savename is $savename"
		fi

		#move unzipped file to network drive
		if [[ $verbose -gt 0 ]]
		then
			echo "copying ${savename} to directory..."
		fi
		mkdir -p "$fpath_to" && cp "$staging_area${file%.bz2}" "${fpath_to}/${savename}"

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

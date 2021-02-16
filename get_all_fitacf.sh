#array of all superdarn stations
stations=("ade" "adw" "bks" "cly" "cve" "cvw" "fhe" "fhw" "gbr" "han" "hkw" "hok" "inv" "kap" "kod" "ksr" "lyr" "pgr" "pyk" "rkn" "sas" "sto" "wal")
#get requested date (must be in format "YYYY/MM/DD hh:mm:ss")
start_date=$1
end_date=$2
verbose=${3:-0} #set verbose mode either 0 (none) 1(some) 2(all)
start_rad=${4:-0} #set which radar to start from (0=ade)

skip_count=0
for rad in "${stations[@]}"
do
	#skip number of specified stations
	if [[ $skip_count -lt start_rad ]]
	then
		skip_count=$((skip_count+1))
		continue
	fi

	echo "$i = $rad"
	./get_fitacf.sh "$rad" "$start_date" "$end_date" "$verbose"
done

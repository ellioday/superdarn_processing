#array of all superdarn stations
stations=("ade" "adw" "bks" "cly" "cve" "cvw" "fhe" "fhw" "gbr" "han" "hkw" "hok" "inv" "kap" "kod" "ksr" "lyr" "pgr" "pyk" "rkn" "sas" "sto" "wal")
#get requested date (must be in format "YYYY/MM/DD hh:mm:ss")
start_date=$1
end_date=$2
verbose=${3:-0}

for rad in "${stations[@]}"
do
	echo "$rad"
	source get_fitacf.sh "$rad" "$start_date" "$end_date" "$verbose"
done

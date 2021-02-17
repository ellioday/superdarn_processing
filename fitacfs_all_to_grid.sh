help(){

	echo "This scipt creates day long .grd file from all stations"

	echo
	echo "inputs:"
	echo "date (YYY/MM/DD)"
	echo "number of initial stations to skip retrieval (default 0)"
}

#array of all superdarn stations
stations=("ade" "adw" "bks" "cly" "cve" "cvw" "fhe" "fhw" "gbr" "han" "hkw" "hok" "inv" "kap" "kod" "ksr" "lyr" "pgr" "pyk" "rkn" "sas" "sto" "wal")
#get requested date (must be in format "YYYY/MM/DD hh:mm:ss")
date=$1
start_rad=${2:-0} #set which radar to start from (0=ade)

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
	./fitacfs_to_grid.sh "$rad" "$date"
done

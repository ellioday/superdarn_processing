help(){

	echo "This scipt merges .grd files from all radars into one .grd file"

	echo
	echo "inputs:"
	echo "date (YYYY/MM/DD_hh/mm/ss)"
	echo "number of initial stations to skip retrieval (default 0)"
}

source bash_tools.sh

#array of all superdarn stations
stations=("ade" "adw" "bks" "cly" "cve" "cvw" "fhe" "fhw" "gbr" "han" "hkw" "hok" "inv" "kap" "kod" "ksr" "lyr" "pgr" "pyk" "rkn" "sas" "sto" "wal")

#get requested date (must be in format "YYYY/MM/DD")
date=$1
start_rad=${2:-0} #set which radar to start from (0=ade)

year=${date:0:4}
month=${date:5:2}
day=${date:8:2}

#get location where individual .grd files are stored
to_path="${luna_path}users/daye1/Superdarn/Data/grid/all/$year/$month/"
mkdir -p $to_path

skip_count=0
#copy all grid files from individual station folders into a single golder
for rad in "${stations[@]}"
do
	#skip number of specified stations
	if [[ $skip_count -lt start_rad ]]
	then
		skip_count=$((skip_count+1))
		continue
	fi

	echo "$i = $rad"
	
	rad_path="${luna_path}users/daye1/Superdarn/Data/grid/$rad/$year/$month/"
	fname="${year}${month}${day}.${rad}.grd"
	echo "$rad_path$fname"

	cp $rad_path$fname $to_path

done

echo "$year $month $day"

#merge all grid files to one
combine_grid -vb ${to_path}${year}${month}${day}.*.grd > ${to_path}${year}${month}${day}.north.grd

#delete individual .grds
for rad in "${stations[@]}"
do
	rm ${to_path}${year}${month}${day}.${rad}.grd
done

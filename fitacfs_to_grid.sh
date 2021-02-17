help(){

	echo "This merges all .fitacf files for one date for a single radar and converts it into a .grd file"

	echo
	echo "inputs:"
	echo "3-letter station code (AAA)"
	echo "date (YYYY/MM/DD)"
}

source bash_tools.sh

#get inputs
rad=$1
date=$2
year=${date:0:4}
month=${date:5:2}
day=${date:8:2}

echo "${year} ${month} ${day}"

#get path to .fitacf files
fitacfs_path="${luna_path}users/daye1/Superdarn/Data/fitacf/$rad/$year/$month/"
fitacf_name="${year}${month}${day}.*.${rad}.fitacf"
echo "$fitacfs_path$fitacf_name"
#get path to store .grd file
grd_path="${luna_path}users/daye1/Superdarn/Data/grid/$rad/$year/$month/"
grd_name="${year}${month}${day}.${rad}.grd"
echo "$grd_path$grd_name"

#merge and convert .fitacf files into .grd
echo "creating .grd file"
mkdir -p "$grd_path" && make_grid -vb -tl 60 -xtd -c $fitacfs_path$year$month${day}.*.${rad}.fitacf > "$grd_path$grd_name" 

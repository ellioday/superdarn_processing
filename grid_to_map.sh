help(){

	echo "This scipt converts a grid file containing all radar data into a convection map"

	echo
	echo "inputs:"
	echo "date (YYYY/MM/DD_hh/mm/ss)"
	echo "verbose level (0/1/2 default 0)"
	echo "number of initial stations to skip retrieval (default 0)"
}

source bash_tools.sh

#get requested date (must be in format "YYYY/MM/DD hh:mm:ss")
date=$1
verbose=${2:-0} #set verbose mode either 0 (none) 1(some) 2(all)

#get time
year=${date:0:4}
month=${date:5:2}
day=${date:8:2}

#get path to .grid file
grid_path="${luna_path}users/daye1/Superdarn/Data/grid/all/$year/$month/"
grid_name="${year}${month}${day}.north.grd"

#get path to save .map file
map_path="${luna_path}users/daye1/Superdarn/Data/map/$year/$month/"
mkdir -p $map_path

#reformat grid to map
echo "reformatting .grid into .map..."
map_grd ${grid_path}${grid_name} > ${map_path}${year}${month}${day}.empty.map
#add heppner-maynard boundary
echo "adding heppner-maynard boundary..."
map_addhmb ${map_path}${year}${month}${day}.empty.map > ${map_path}${year}${month}${day}.hmb.map
#add IMF data
echo "adding IMF data..."
map_addimf -bx 1.5 -by -1.2 -bz 0.4 ${map_path}${year}${month}${day}.hmb.map > ${map_path}${year}${month}${day}.imf.map
#calculate statistical model
echo "calculating statitical model..."
map_addmodel -o 8 -d l ${map_path}${year}${month}${day}.imf.map > ${map_path}${year}${month}${day}.model.map
#perform spherical harmonic fitting
echo "performing spherical harmonic fitting..."
map_fit ${map_path}${year}${month}${day}.model.map > ${map_path}${year}${month}${day}.north.map
echo "done."

# These are a series of bash scripts to automate converting formats between superdarn data files

# Fitacf retreival #

get_fitacf.sh: 
- retrieves fitacf files of a particular radar from the shared luna drive and stores them to personal directory.

get_all_fitacf.sh:
- retrieves fitacf files for all (northern hemisphere) radars from the shared luna drive and stores them to personal directory.

# Fitacf -> grid #

fitacfs_to_grid.sh:
- converts all fitacf files for one day for a single radar into a .grd file and stores it to personal directory

fitacfs_all_to_grid.sh:
- runs fitacfs_to_grid for all radars for one day, outputting .grd files for each radar (in northern hemisphere) and saves to directories

# grids -> grid #

grids_to_grid.sh:
- gets .grd files from all radars for one day and merges them all into a single .grd file for northern hemisphere

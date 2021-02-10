#Load path to luna data
luna_path=$(</home/elliott/Documents/python_analysis/luna_path.txt)
#array of all superdarn stations
stations=("ade" "adw" "bks" "cly" "cve" "cvw" "fhe" "fhw" "gbr" "han" "hkw" "hok" "inv" "kap" "kod" "ksr" "lyr" "pgr" "pyk" "rkn" "sas" "sto" "wal")
#get requested date (must be in format "YYYY/MM/DD hh:mm:ss")
date=$1

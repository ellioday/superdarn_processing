source bash_tools.sh

#test date_compare function
#all less than scenarios (month -> day -> hour -> minute -> second)
echo
echo "testing date_compare"
echo "--------------------"
echo "less than tests:"
date_compare "2013/09/02_00:00:00" "2013/10/02_00:00:00" && echo $retval
date_compare "2013/10/01_00:00:00" "2013/10/02_00:00:00" && echo $retval
date_compare "2013/10/02_00:00:00" "2013/10/02_10:10:10" && echo $retval
date_compare "2013/10/02_10:00:00" "2013/10/02_10:10:10" && echo $retval
date_compare "2013/10/02_10:10:00" "2013/10/02_10:10:10" && echo $retval
#test greater than scenarios (month -> day -> hour -> minute -> second)
echo "greater than tests:"
date_compare "2013/11/02_00:00:00" "2013/10/02_00:00:00" && echo $retval
date_compare "2013/10/03_00:00:00" "2013/10/02_00:00:00" && echo $retval
date_compare "2013/10/02_10:00:00" "2013/10/02_00:00:00" && echo $retval
date_compare "2013/10/02_10:10:00" "2013/10/02_10:00:00" && echo $retval
date_compare "2013/10/02_10:10:10" "2013/10/02_10:10:00" && echo $retval

#strip zero test
echo
echo "testing zero strip function"
echo "---------------------------"
array=("00" "01" "02" "03" "04" "05" "06" "007" "0008" "0000000009")
for val in "${array[@]}"
do
	strip_zero $val
	echo "val = $val -> $retval"
done

test=$(strip_zero "08" && echo $retval)
echo "testing is $test"

function is_username() {
read -p "enter username:" username

if [[ $username == "$1" ]];
then
	echo " correct username"
else
          
        echo " username not correct"
fi
}
	

# this is function call

is_username "minakshi"


read -p "Enter the ip of the server: " ip
flag=0
if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        echo "" 
else
    echo "Invalid ip"
    flag=1
fi


if [[ $(timeout 5 nc -zvn $ip 22 2>/dev/null ; echo $?) == 0 ]]; then
    echo "The server is up and running"
else
    echo "Something went wrong"
    flag=1
fi

if [ $flag == 0 ]; then
    echo "Connect to the ssh:"
    if [ -f infos.txt ]; then
        username=$(grep username infos.txt | cut -d " " -f2)
        key=$(grep key infos.txt | cut -d " " -f2)
        echo "Username: $username"
        echo "Key: $key"
        ssh -i $key $username@$ip
    else
        read -p "Enter the username: " username
        read -p "Enter the key: " key
        echo "username: $username" >> infos.txt
        echo "key: $key" >> infos.txt
        ssh -i $key $username@$ip
    fi
else
    exit 1
fi

#!/bin/bash

decrypt(){
	if [ "$nowords" -eq "1" ] ;
		then
        crunchAttack        
    elif [ "$nowords" -eq "0" ] ;
        then
        dictionaryAttack
    fi        
}

crunchAttack(){
    # TODO: specify the crunch commands to passed
    echo ""
}

dictionaryAttack(){

    # Reads in the wordlist and passes each line as an argument
    # to openssl.
    # "grep -c" checks the output of oepnssl for "bad decrypt" and
    # if no error message exists, we assume a successful decryption
    # occured.

    while read -r line
    do
        sslOutput="$(openssl enc -d -aes-256-cbc -a \
            -in $input \
            -out $output \
            -pass pass:$line 2>&1)" 

        if [ "$(echo $sslOutput | grep -c 'bad decrypt')" -eq "0" ] ;
            then
            echo "Decrypt : congratulations! The password is $line"
            exit
        fi

    done < "$wordlist"
}

# begin main

input=$1
output=$2
wordlist=$3
nowords="-1"
log="openssllog.txt"

if [ "$#" -ne "2" ] && [ "$#" -ne "3" ] ;
	then
	echo "Decrypt : invalid input. Exiting..."
	exit
elif [ "$#" -eq "2" ] ;
	then
	if [ ! -f "$input" ] ;
		then
		echo "Decrypt : $input does not exist. Exiting..."
		exit
	fi
	# flag nowords
	nowords="1"
elif [ "$#" -eq "3" ] ;
	then
	if [ ! -f "$input" ] || [ ! -f "$wordlist" ] ;
		then
		echo "Decyrpt : $input or $wordlist does not exist. Exiting..."
		exit
	fi
	# flag nowords
	nowords="0"
fi

decrypt

exit

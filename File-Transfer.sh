#!/bin/bash
#Connect To Source Server
mkdir $$
touch $$/email.txt
source ./$1
echo "Subject: Delivery Notification" >>$$/email.txt
if [ $state == "Full" ] || [ $state == "Pull" ]; then
    decrypted=$(echo $source_password | openssl enc -aes-256-cbc -a -d -salt -pass pass:"$salt")
    decoded=$(echo $decrypted | base64 --decode)
    export SSHPASS=$decoded
    # Get Directory
    if [ $object_type == "Dir" ]; then
        sshpass -e sftp -q $source_user@$source_host <<!
            lcd $$
            get -R $remote_object_name 
            bye
!
    for file in $$/$remote_object_name*; do 
        if [[ $file == *".gpg"* ]]; then
            gpg --yes --always-trust --batch -q --output ${file%.gpg} --passphrase="$decryption_password" --decrypt $file
        fi
    done
        echo "Completed Directory Collection"
    # Get Plaintext File
    elif [ $object_type == "File" ] || [ $object_type == "Zip" ]; then
        sshpass -e sftp -q $source_user@$source_host <<!
            lcd $$
            get $remote_object_name 
            bye
!
        echo "Completed Single Object Collection"
    # Get Encrypted File
    elif [ $object_type == "EncF" ]; then
        sshpass -e sftp -q $source_user@$source_host <<!
            lcd $$
            get $remote_object_name 
            bye
!
        for file in $$/*;do
            if [[ $file == *$local_object_name.gpg ]]; then
                gpg --yes --always-trust --batch -q --output ${file%.gpg} --passphrase="$decryption_password" --decrypt $file
                rm $file
            fi
        done
        echo "Completed Encrypted File Collection"
    fi  
fi

# Connect To Destination Server
if [ $state == "Full" ] || [ $state == "Push" ]; then
    ## Document Removal of mkdir
    decrypted=$(echo $target_password | openssl enc -aes-256-cbc -a -d -salt -pass pass:"$salt")
    decoded=$(echo $decrypted | base64 --decode)
    export SSHPASS=$decoded
    if [ $remote_object_name != $local_object_name ] && [[ $local_object_name != *".gpg"* ]] && [[ $remote_object_name != *".gpg"* ]]; then
        mv $$/$remote_object_name $$/$local_object_name # Renaming
    fi
    # Send Directory
    if [ $object_type == "Dir" ]; then
        if [ $send_encrypted == "true" ]; then
            for nested_file in $$/$local_object_name/*; do
                gpg --yes --always-trust --batch -q --output ${nested_file}.gpg --recipient="$recipient" --encrypt $nested_file
            done
        fi
        sshpass -e sftp -q $target_user@$target_host <<!
        put -r $$/$local_object_name
        bye
!
        echo "Completed Directory Transfer"
        echo "Successfully Delivered $local_object_name" >>$$/email.txt
    # Send Plaintext File
    elif [ $object_type == "File" ]; then
        if [ $send_encrypted == "true" ]; then
            for file in $$/*;do
                if [[ $file == *$local_object_name ]]; then
                    gpg --yes --always-trust --batch -q --output $file.gpg --recipient="$recipient" --encrypt $file
                fi
            done
            local_object_name=$local_object_name.gpg
        fi
        sshpass -e sftp -q $target_user@$target_host <<!
        put -r $$/$local_object_name
        bye
!
        echo "Completed Plaintext File Transfer"
        echo "Successfully Delivered $local_object_name" >>$$/email.txt
    # Send Encrypted File
    elif [ $object_type == "EncF" ]; then
        if [ $send_encrypted == "true" ]; then
            for file in $$/*;do
                if [[ $file == *$local_object_name ]]; then
                    gpg --yes --always-trust --batch -q --output $file.gpg --recipient="$recipient" --encrypt $file
                fi
            done
            local_object_name=$local_object_name.gpg
        fi
        sshpass -e sftp -q $target_user@$target_host <<!
            put $$/$local_object_name
            bye
!
        echo "Completed Encrypted File Transfer"
        echo "Successfully Delivered $local_object_name" >>$$/email.txt
    elif [ $object_type == "Zip" ]; then
        if [[ $$/$remote_object_name == *".gpg"* ]]; then
            gpg --yes --always-trust --batch -q --output $$/${local_object_name%.gpg} --passphrase="$decryption_password" --decrypt $$/$remote_object_name
        fi
        unzip $$/$local_object_name -d $$/
        if [ $send_encrypted == "true" ]; then
            for nested_file in $$/${local_object_name%.zip}/*; do
                gpg --yes --always-trust --batch -q --recipient="$recipient" --encrypt $nested_file
            done
        fi
        sshpass -e sftp -q $target_user@$target_host <<!
            put -r $$/${local_object_name%.zip}
            bye
!
        echo "Completed Zip Archive Transfer"
        echo "Successfully Delivered $local_object_name" >>$$/email.txt
    fi
    rm -rf $$
fi

#!/bin/bash
#Connect To Source Server
mkdir $$
if [ ${12} == "Full" ] || [ ${12} == "Pull" ]; then
    source_user="$1"
    source_host="$2"
    source_password="$3"
    remote_object_name="$4"
    decryption_password="$5"
    decrypted=`echo $source_password | openssl enc -aes-256-cbc -a -d -salt -pass pass:"ntSQ8gHt)-DXX9u\!"`
    decoded=`echo $decrypted | base64 --decode`

    export SSHPASS=$decoded
    # Get Directory
    if [ ${11} == "Dir" ]; then 
        sshpass -e sftp -q $source_user@$source_host << ! 
            lcd $$
            get -R $remote_object_name 
            bye
!
        echo "Completed Directory Collection" 
    # Get Plaintext File
    elif [ ${11} == "File" ] || [ ${11} == "Zip" ]; then
        sshpass -e sftp -q $source_user@$source_host << ! 
            lcd $$
            get $remote_object_name 
            bye
!
        echo "Completed Single Object Collection" 
    # Get Encrypted File
    elif [ ${11} == "EncF" ]; then
        sshpass -e sftp -q $source_user@$source_host << ! 
            lcd $$
            get $remote_object_name 
            bye
!
        gpg --yes --batch -q --output $$/${remote_object_name%.gpg} --passphrase="$decryption_password" --decrypt $$/$remote_object_name
        echo "Completed Encrypted File Collection" 
    fi    
fi

# Connect To Destination Server
if [ ${12} == "Full" ] || [ ${12} == "Push" ]; then
    target_user="$6"
    target_host="$7"
    target_password="$8"
    local_object_name="$9"
    encryption_password="${10}"
    decrypted=`echo $target_password | openssl enc -aes-256-cbc -a -d -salt -pass pass:"ntSQ8gHt)-DXX9u\!"`
    decoded=`echo $decrypted | base64 --decode`
    export SSHPASS=$decoded
    # Send Directory
    if [ ${11} == "Dir" ]; then
        sshpass -e sftp -q $target_user@$target_host << ! 
        put -r $$/$local_object_name
        bye
!
        echo "Completed Directory Transfer" 
    # Send Plaintext File
    elif [ ${11} == "File" ]; then
        gpg --yes --batch -q --passphrase="$encryption_password" -c $$/$local_object_name
        sshpass -e sftp -q $target_user@$target_host << ! 
        put $$/${local_object_name}.gpg
        bye
!
        echo "Completed Plaintext File Transfer" 
    # Send Encrypted File
    
    elif [ ${11} == "EncF" ]; then 
        gpg --yes --batch -q --passphrase="$encryption_password" -c $$/$local_object_name
        mv $$/$local_object_name.gpg $$/$local_object_name # Rename .gpg.gpg To .gpg
        sshpass -e sftp -q $target_user@$target_host << ! 
            put $$/$local_object_name
            bye
!
        echo "Completed Encrypted File Transfer" 
    elif [ ${11} == "Zip" ]; then
        unzip $$/$local_object_name -d $$/
        sshpass -e sftp -q $target_user@$target_host << !
            put -r $$/${local_object_name%.zip}
            bye
!
        echo "Completed Zip Archive Transfer" 
    fi
fi
rm -rf $$
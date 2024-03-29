# Anything not used should be "."
# What was the salt used when generating the password (Required)
export salt=""
# Who do you PULL as? (Username for Source server)
export source_user=""  
# Where do you PULL to? (IP/url for Source server)
export source_host=""
# What is the password to do so? (AES-256 Encrypt the base64 version of the plaintext, using the salt in the Main script)
export source_password="" 
# What is the name of the file you are getting? (or the pattern of flie to grab)
export remote_object_name=""
# If encrypted, What is the password for it?
export decryption_password=""
# Who do you PUSH as? (Username for destination server)
export target_user=""
# Where do you PUSH to? (IP/url for Destination server)
export target_host=""
# What is the password to do so? (AES-256 Encrypt the base64 version of the plaintext, using the salt in the Main script)
export target_password=""
# What should the file pushed be called? (Used in renaming, and encrypted files (this should include ".gpg"))
export local_object_name=""
# Who to email when the action completes? (Emailed everytime... You were Warned)
export recipient=""
# What type of object is being moved? (Options: File, EncF, Dir, Zip)
export object_type=""
# Should the object being sent be encrypted at rest on the destination? (If not set to "true" send_encrypted is assumed false  )
export send_encrypted=""
# (WIP) Which Action Should be Completed? (Options: "Pull", "Push", "Full". where the latter does a complete transaction )
export state=""
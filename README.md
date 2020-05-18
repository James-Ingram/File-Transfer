# File-Transfer
Script To Transfer Files Between Two SFTP Servers 
## Running
`sh File-Transfer "scripts/conf.sh" >> logs/task.log`
## Package Requirements:
These can be automatically installed by copying the install script "initial-setup.sh" to the root user's home folder and running it.
Package | Reason
--- | --- 
SSHPass | Command Line SFTP Login
SSMTP | Email Notifications
Unzip | Archive Handling 

## String Encryption Commands
Encrypt Passwords
>  `echo "base64 phrase" | openssl enc -aes-256-cbc -a -salt -pass pass:<Insert Salt>`

Decrypt Passwords
> `echo "encodedPhrase" | openssl enc -aes-256-cbc -a -d -salt -pass pass:<Insert Salt>`

## Use Case Regression Testing
- Files: 
    - Tested Against: Implementation, TempFolder, Optional Encrypt, Local Clean Up, Script File
- Directories: 
    - Tested Against: Implementation, TempFolder, Nested File Decryption, Local Clean Up, Script File
- Encrypted Files: 
    - Tested Against: Implementation, TempFolder, Local Clean Up, Script File
- Zip Archives 
    - Tested Against: Implementation, TempFolder, Local Clean Up, Script File

## TODO 
Lower Numbers Are A Higher Priority

Item | Priority
--- | ---
Logging | 3 
Remote Delete | 2 
SSH Key Login | 1 

## Completed Features - Listed In "Rough" Order Of Completion:
(Move = Pull & Push Object)
- Connect To Server
- Login To Server
- Implement Base64 Encoding For Passwords
- Implement Second Layer Of Obsfuscation Using An AES-256 Bit Encryption With A Pre-Defined Salt
    - (As A Side-Effect) - Login Securely (Removing Plaintext Passwords From Command Line)
- Execute SFTP Commands
- Move A Plaintext File
- Move Plaintext Directories
- Move An Encrypted File
- Move A Directory With Encrypted Files
- Move A Directory With A Mixture (Edge Case)
- Pull A Zip
- Push A Directory That Was Once An Archive
- Inlcude Ability To Send Decompressed Archive Contents Encrypted ( Each Item Within The Newly Created Folder Is Encrypted And Sent)
- Removed 13 Argument Run Command, In Favour Of Config Script
    - (As A Side-Effect) - Command Only Takes One Argument, The Name Of The Config Script 
- Provided Example Script For The Novice User
- Match A Globbing Pattern On A Directory
- "Squish" Globbing Pattern Handling Into "File" Option
- Globbing Pattern On EncF Pull
- EncF Globbing Push Encryption 
- Decrypt An Encrypted Zip

Globbing Pattern Example: *LETTER_NOTIFICATION_DELIVERY_RESULT_[0-3][0-9]_[0-1][0-9]_[0-9]{4}[.]csv

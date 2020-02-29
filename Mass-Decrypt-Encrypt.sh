recipient=$1
home_location=~/Desktop/In/
for f in $home_location*.gpg; do
	gpg --batch --always-trust --output ${f%.gpg} --decrypt $f
done
for file in $home_location*; do
	if [[ $file != *".gpg"* ]]; then
		gpg --batch --always-trust --output ~/Desktop/Out/${file#$home_location}.gpg --recipient $recipient --encrypt $file
	fi
done
echo "Done."
sleep 20

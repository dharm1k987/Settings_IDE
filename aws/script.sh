home="/home/ubuntu"
files=("$home/.bashrc" "$home/.htaccess" "$home/.profile" "$home/.pythoncwd.py" "/mnt/hdd/a.py" "/mnt/hdd/d.sh" "/etc/apache2/apache2.conf" "/usr/bin/gdrive.sh")
for file in ${files[@]};
do
	if [[ -d "$file" ]]; then
		continue
	fi
	touch $(basename $file)
	cat "$file" > $(basename $file)

done

printf "Done, please commit."

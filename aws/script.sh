home="/home/ubuntu"
files=("$home/.bashrc" "$home/.htaccess" "$home/.profile" "$home/.pythoncwd.py" "/mnt/hdd/a.py" "/mnt/hdd/d.sh" "/etc/apache2/apache2.conf" "/usr/bin/gdrive.sh" "$home/.ssh/authorized_keys" "/etc/default/ddclient" "/etc/ddclient.conf")
for file in ${files[@]};
do
	if [[ -d "$file" ]]; then
		continue
	fi
	touch $(basename $file)
	sudo cat "$file" > $(basename $file)

done

printf "Done, please commit."

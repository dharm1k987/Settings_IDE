#!/bin/bash

if [ -z "$1" ]; then
	echo "./d.sh [folder]"
	exit;
fi

mkdir -p "$1"

#course="investing-in-stocks-the-complete-course-11-hour"
#course="mastering-data-structures-algorithms-using-c-andc"
course="the-ultimate-mysql-bootcamp-go-from-sql-beginner-to-expert"
domain="https://www.learningcrux.com"
main="$domain/course/$course"
play="$domain/play/$course"

sections=$(curl -s "$main")
readarray -t lines <<< "$(echo $sections | grep -oP "\K(Section \d+:.*?)(?=<\/h2)")"
#lines=("${lines[@]:5}")
printf -- "%s\n" "${lines[@]}"
len=${#lines[@]}
#len=2
read -p "Continue? (y/n): " cont
if [ "$cont" != "y" ]; then
	exit
fi

for (( i=2; i<${len}; i++ ));

do
	dir="${lines[$i]}"
	dir=$(echo $dir | sed 's/:/-/g')
	printf "\ndir is $dir"
	mkdir -p "$1/$dir"

	for j in {0..100}
	do
		url="$play/$i/$j/720"
		final=$(curl -w "%{url_effective}" -I -L -s -S "$url" -o /dev/null)
		gdrive=$(echo $final | grep -oP "\*\/\K(.+)(?=\?e=download)")
		if [ "$url" = "$final" ]; then
			printf "\nSkip onto next iteration\n---------------------\n"
			break
		fi

		if [[ ! -z "$gdrive" ]]
		then
			printf "\nSection $i , Part $j"
			/usr/bin/gdrive.sh "$gdrive" "$1/$dir" &
		else
			basename=$(basename -- "$final")
			escaped=$(echo $basename | sed 's@+@ @g;s@%@\\x@g' | xargs -0 printf "%b")
			printf "\nDownloading $escaped ..."
			curl -s -L "$final" -o "$1/$dir/$escaped" &
		fi
		printf "\n"

	done
	printf "waiting..."
	wait
done

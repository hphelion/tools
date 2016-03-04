#!/bin/bash


find  . -name "*.png" -o -name "*.jpg" -o -name "*.bmp" -o -name "*.gif" | sed 's|.*/||g' > temp.txt
cat temp.txt | sort | uniq > files.on.disk.txt

for i in `find . -name "*.dita"`;
do
        egrep '(png|jpg|bmp|gif)' $i | sed 's|.* href=".*/\([^"]*\)".*|\1|g' | sed 's|.*src=".*/\([^"]*\)".*|\1|g' | grep -v "<" ;
done > temp.txt

cat temp.txt | sort | uniq > files.in.dita.txt

curl -s https://raw.githubusercontent.com/hphelion/tools/master/jenkins/hipchat-notification.sh hipchat-notification.sh

if [[ $(diff files.in.dita.txt files.on.disk.txt  | grep ">" | sed 's|>||g') ]]
    then
		echo "================================================================================"
		echo "Graphics files that are not referenced by any ditafile in this branch and repo"
		for i in `diff files.in.dita.txt files.on.disk.txt  | grep ">" | sed 's|>||g'`
			do
				find . -name $i
			done
		echo "================================================================================"
		exit 1;                
    else
		echo "========================"
		echo "No unused graphics found"
		echo "========================"
	        ./hipchat-notification green  145  "No unused graphics found" 0	
		exit 0;
fi


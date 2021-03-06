#!/bin/bash

REPO_BRANCH_TO_CHECK=$1 
REPO=$2 
ROOM=$3


find  . -name "*.png" -o -name "*.jpg" -o -name "*.bmp" -o -name "*.gif" | sed 's|.*/||g' > temp.txt
cat temp.txt | sort | uniq > files.on.disk.txt

for i in `find . -type f`;
do
        egrep '(png|jpg|bmp|gif)' "$i" | sed 's|.* href=".*/\([^"]*\)".*|\1|g' | sed 's|.*src=".*/\([^"]*\)".*|\1|g' | grep -v "<" ;
done > temp.txt

cat temp.txt | sort | uniq > files.in.dita.txt


if [[ $(diff files.in.dita.txt files.on.disk.txt  | grep ">" | sed 's|>||g') ]]
    then
                echo "================================================================================"
                echo "Graphics files that are not referenced by any file in this branch and repo"
                for i in `diff files.in.dita.txt files.on.disk.txt  | grep ">" | sed 's|>||g'`
                        do
                                find . -name "$i"
                        done
                echo "================================================================================"
				./hipchat-notification.sh red  $ROOM  "Build $BUILD_NUMBER $STATUS - Unused graphics found in the $REPO_BRANCH_TO_CHECK branch of the $REPO repo. Details <a href='$BUILD_URL/console'>here</a>." 1
                exit 1;
    else
                echo "========================"
                echo "No unused graphics found"
                echo "========================"
                ./hipchat-notification.sh green  $ROOM  "Build $BUILD_NUMBER - No unused graphics found in the $REPO_BRANCH_TO_CHECK branch of the $REPO repo" 0
                exit 0;
fi

 

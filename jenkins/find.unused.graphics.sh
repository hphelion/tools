#!/bin/bash


find  . -name "*.png" -o -name "*.jpg" -o -name "*.bmp" -o -name "*.gif" | sed 's|.*/||g' > temp.txt
cat temp.txt | sort | uniq > files.on.disk.txt

for i in `find . -name "*.dita"`;
do
        egrep '(png|jpg|bmp|gif)' $i | sed 's|.* href=".*/\([^"]*\)".*|\1|g' | sed 's|.*src=".*/\([^"]*\)".*|\1|g' | grep -v "<" ;
done > temp.txt

cat temp.txt | sort | uniq > files.in.dita.txt


if [[ $(diff files.in.dita.txt files.on.disk.txt  | grep ">" | sed 's|>||g') ]]
    then
                echo "================================================================================"
                echo "Graphics files that are not referenced by any ditafile in this branch and repo"
                for i in `diff files.in.dita.txt files.on.disk.txt  | grep ">" | sed 's|>||g'`
                        do
                                find . -name $i
                        done
                echo "================================================================================"
				./hipchat-notification.sh red  145  "Build $BUILD_NUMBER $STATUS - Unused graphics found in the $REPO_BRANCH_TO_CHECK branch of the $REPO repo. Details <a href=\\"$BUILD\\">here</a>." 1
                exit 1;
    else
                echo "========================"
                echo "No unused graphics found"
                echo "========================"
                ./hipchat-notification.sh green  145  "Build $BUILD_NUMBER - No unused graphics found in the $REPO_BRANCH_TO_CHECK branch of the $REPO repo" 0
                exit 0;
fi

 
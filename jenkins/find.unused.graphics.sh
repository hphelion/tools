
find  . -name "*.png" -o -name "*.jpg" -o -name "*.bmp" -o -name "*.gif" | sed 's|.*/||g' > temp.txt

cat temp.txt | sort | uniq > files.on.disk.txt

for i in `find . -name "*.dita"`; 
do 
  egrep '(png|jpg|bmp|gif)' $i | sed 's|.* href=".*/\([^"]*\)".*|\1|g' | sed 's|.*src=".*/\([^"]*\)".*|\1|g' |\
  grep -v "<" ;  
done > temp.txt

cat temp.txt | sort | uniq > files.in.dita.txt



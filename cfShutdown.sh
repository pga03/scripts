#!/bin/bash

echo -e "\e[1;32mJohn's BlueMix App Shutdown Script!\e[0m"
if [ -d "cftemp" ]; then
	echo ":| cftemp exists, which is weird, but is probably not an issue"
	#echo ":| i guess I'll just get rid of it"
	#rm -r cftemp
	#echo ":) now back to our regularly scheduled program"
else
	mkdir cftemp
fi
cd cftemp

echo "Making applist..."
cf apps > applist

#remove escape chars from cf output
cat applist | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" > applistClean
mv applistClean applist

#remove first 4 lines of cf output
sed '1,4d' applist > applist2
mv applist2 applist

#take 1st word from each line of remaining applist
while read word _; do 
	echo -e  "\e[1;32m";
	cf stop $word
done < applist

echo "Cleaning up :)"
cd ..
rm -r cftemp

cf apps
exit

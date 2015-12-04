#!/bin/bash
#TODO: check if state is valid
echo -e "\e[1;32mJohn's BlueMix App Startup/Shutdown Script!\e[0m"
echo -e "\e[1mUsage: ./cfStartup.sh [org] [space] [start/stop] \e[0m"

org=$1
space=$2
state=$3

#Checking parameters
if [ -z "$org" ]; then
	echo -e "\e[1;31mNo Parameters!\e[0m"
	echo -e "\e[1mUsage: ./cfStartup.sh [org] [space] [start/stop] \e[0m"
	exit 1
fi
if [ -z "$space" ]; then
	echo -e "\e[1;31mpYou need to specify a space!\e[0m"
	echo -e "\e[1;31mFailure!\e[0m"
	exit 1
fi
if [ -z "$state" ]; then
	echo -e "\e[1;31mStartup or Shutdown?!\e[0m"
	echo -e "\e[1;31mFailure!\e[0m"
	exit 1
fi
#3rd param must ==start || ==stop
if [ "$state" != 'start' ] && [ "$state" != 'stop' ]; then
	echo -e "\e[1;31mState must be start or stop!\e[0m"
	echo -e "\e[1;31mYou wrote: "$state"\e[0m"
	echo -e "\e[1;31mFailure!\e[0m"
	exit 1
fi

#failing if called with too many params
if [ -n "$4" ]; then
	echo -e "\e[1;31mpToo many parameters!\e[0m"
	echo -e "\e[1;31mFailure!\e[0m"
	exit 1
fi

#Actual Work

if [ -d "cftemp" ]; then
	echo ":| cftemp exists, which is weird, but is probably not an issue"
else
	mkdir cftemp
fi
cd cftemp

cf target -o $org -s $space

echo "Making applist..."
cf apps > applist

#remove escape chars from cf output
cat applist | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" > applistClean
mv applistClean applist

#remove first 4 lines of cf output
sed '1,4d' applist > applist2
mv applist2 applist

#take 1st word from each line of remaining applist
while read appName _; do 
	#printf '%s\n' "$word"; 
	echo -e  "\e[1;32m"
	cf $state $appName
done < applist

echo ""
echo "Cleaning up :)"
echo ""
cd ..
rm -r cftemp

cf apps
exit

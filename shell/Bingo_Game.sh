#!/bin/sh
select_function(){
	while test $REQUEST -ne 6;
	do
		clear
		echo "\n\n\t\tFunction list....\n
			1.Play \n
			2.Play with display \n
			3.Rank List (Top 10) \n
			4.Search Rank (by user name) \n
			5.Sort (by time) \n
			6.Exit \n\n\n
	Please select what function do you want to execte ? Choose:\c\n\n"
	read REQUEST
	case $REQUEST in
		1)
		bingo.awk;;
		2)
		bingo.awk -d;;
		3)
		clear
		echo "================================GRADE======================="
		echo "==========NAME======TIME=======RANK========"
		cat score.txt|sort -t: -n -k 2|awk -F: '{if(NR<=10) printf("%3d %10s\t%8d\t%3d\n",NR,$1,$2,$3)}'
		echo;echo
		echo "Press enter key to continue......."
      	  	read temp
		;;
		4)
		clear
		echo "================================GRADE======================="
		echo "Please Input a name whom grade you want to search..NAME=\c"
		read USERNAME
		echo "==========NAME======TIME=======RANK========"
		grep $USERNAME score.txt|awk -F: '{if(NR<10) printf("%3d %10s\t%8d\t%3d\n",NR,$1,$2,$3)}'
		echo;echo
		echo "Press enter key to continue......."
      	  	read temp
		;;
		5)
		clear
		echo "================================GRADE======================="
		cat score.txt|sort -t: -n -k 2|awk -F: '{printf("%s:%d:%d\n",$1,$2,NR)}' >> tDFPSDF
		cat tDFPSDF > score.txt
		rm tDFPSDF
		echo "==========NAME======TIME=======RANK========"
		cat score.txt|awk -F: '{printf("%3d %10s\t%8d\t%3d\n",NR,$1,$2,$3)}'
		echo;echo
		echo "Press enter key to continue......."
      	  	read temp;;
		6)
		exit;;
	esac
	done;
}
REQUEST=0;
select_function;

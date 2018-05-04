#!/bin/sh
add(){
	REPEAT_YES=n
	CHECKREPEAT=`grep "^$USERNAME:" $ADDRESS_BOOK|wc|awk '{print$1}'`
	if test $CHECKREPEAT -gt 0;
		then
		echo "\nThe user name ($USERNAME) is already in this address book"
		echo "Do you want to continue??(y/n)[n]:\c"
		read REPEAT_YES
	case $REPEAT_YES in
		y)real_add;;
		*);;
	esac
	else
	real_add;
	fi
}
real_add(){
	echo "\t2.Real Name(first&&family name):\c"
	read REALNAME
	echo "\t3.Chinese Name(中文姓名):\t\c"
	read CHINESENAME
	echo "\t4.Company(department of school):\c"
	read COMPANY
	echo "\t5.Address(住址):\t\t\c"
	read ADDRESS
	echo "\t6.Phone Number(Zip code):\t\c"
	read TELEPHONE
	echo "\n\t$USERNAME:$REALNAME:$CHINESENAME:$COMPANY:$ADDRESS:$TELEPHONE"
	#echo "\nDo you want to add this person's infomation to you address book?(y/n):[y]\c"
	#read COMFIRM
	#if test $COMFIRM!=n;
	#	then
		echo "$USERNAME:$REALNAME:$CHINESENAME:$COMPANY:$ADDRESS:$TELEPHONE" >> $ADDRESS_BOOK;
	#fi;
	echo "\n\nAdd new user successful!!"
	echo "Press enter key to continue......."
	read temp;
}
book_delete(){
	CHECKREPEAT=`grep "^$USERNAME:" $ADDRESS_BOOK|wc|awk '{print$1}'`
	if test $CHECKREPEAT -eq 0;
		then
		echo "\nThe user name ($USERNAME) is not in this address book";
	else
		echo "\nDo you want to del this $CHECKREPEAT record??(y/n)[n]:\c"
		read REPEAT_YES
	case $REPEAT_YES in
		y)
	sed '/^'$USERNAME'/d' $ADDRESS_BOOK > ./FL23454O7K
	cat FL23454O7K > $ADDRESS_BOOK;rm -rf FL23454O7K
	echo "\n\nDel new user successful!!"
	echo "Press enter key to continue......."
	read temp;;
		*);;
	esac;
	fi
	
}
list(){
	clear
	echo "List all infomation which is in $ADDRESS_BOOK file."
	echo "=====================================================\n"
	cat $ADDRESS_BOOK|awk -F: '{printf("%2d: NAME:(%-12s)    REALNAME:(%-18s)    CHINESE:(%-10s)\n        COMPYNE:(%-24s)     TELEPHONE:(%-15s) \n            ADDRESS:(%-46s)\n",NR,$1,$2,$3,$4,$6,$5);}'
	echo "\n\nPress enter key to continue......."
	read temp;
}
book_sort(){
	clear
	echo "List all infomation which is in $ADDRESS_BOOK file order by\c"
	if test $LIST_FORMAT=1;
		then
		echo " username";
	else echo " telephone";
	fi
	echo "=====================================================\n"
	cat $ADDRESS_BOOK|sort -t : -k $LIST_FORMAT
	echo "\n\nPress enter key to continue......."
	read temp;
	
}
select_function(){
		while test $REQUEST -ne 5;
		do
			clear
			echo "\n\n\t\tFunction list....\n
				1.Add().\n
				2.Delete().\n
				3.List().\n
				4.Sort().\n
				5.Exit().\n\n\n
	Please select what function do you want to execte ? Choose:\c\n\n"
		read REQUEST
		case $REQUEST in
			1)
			clear
			echo "\nPlease input someone's infomation to add in address book file($ADDRESS_BOOK)\n"
			echo "\t1.User Name(nickname):\t\t\c"
			read USERNAME
			add;;
			2)
			clear
			echo "\nPlease input someone's username to del in address book file($ADDRESS_BOOK)\n"
			echo "\tUser Name(nickname):\t\t\c"
			read USERNAME
			book_delete;;
			3)list;;
			4)
			echo "\n\n\tDo you want to sort by use username(u) or phone number(n)??(u/n)[u]:\c"
			read LIST_SELECT
			if test $LIST_SELECT=n;
				then
				LIST_FORMAT=6;
			fi
			book_sort;;
		esac
		done;
}
	ADDRESS_BOOK=address.txt
	REQUEST=0
	LIST_FORMAT=1
	FLAG_A=0;FLAG_D=0;FLAG_L=0;FLAG_LISTALL=0;FLAG_S=0
	if test $# -eq 0 ;
	 then
		if [ ! -f $ADDRESS_BOOK ];
			then
			touch $ADDRESS_BOOK;
		fi
		select_function;
	else
		while( test $# -gt 0);
			do
				case $1 in
					-h)
					echo "\n\n Command: address_book.sh [[-h] [-f filename] [-[adls] username]]\n
    -h          : help\n
    -f filename : File name of Address Book (Default: address.txt)
    -a username : Add user
    -d username : Delete user
    -l username : List user's data (w/o username: List all users' information)
    -s username/telephone: Sort and save to Address Book

    * -a,-d,-l : Only one option can be used at one time
    * If there is no any option, then show the following menu\n\n";;
					-f)
						case $2 in
							-?*)echo "Error: -f $2 ===> You must input option like ' -f filename '."
						exit;;
						esac
						ADDRESS_BOOK=$2
						if [ ! -f $ADDRESS_BOOK ];
							then
							touch $ADDRESS_BOOK;
						fi;;
					-a)FLAG_A=1
						case $2 in
							-?*)echo "Error: -a $2 ===> You must input option like ' -a username '."
						exit;;
						esac;
						USERNAME=$2;;
					-d)FLAG_D=1
						case $2 in
							-?*)echo "Error: -d $2 ===> You must input option like ' -d username '."
						exit;;
						esac
						USERNAME=$2;;
					-l)FLAG_L=1
						case $2 in
							-?*)FLAG_LISTALL=1;;
						esac
						USERNAME=$2;;
					-s)FLAG_S=1
						case $2 in
							-?*)echo "Error: -l $2 ===> You must input option like ' -s username '."
						exit;;
							telephone)LIST_FORMAT=2;;
							username)LIST_FORMAT=1;;
							*)echo "Error: You input wrong options -s username|telephone"
						exit;;
						esac;;
					-?*) echo "Please type the command (address_book.sh -h) to list help! "
						exit;;
				esac
			shift;
		done;
		SUM=`echo $FLAG_D+$FLAG_L+$FLAG_A+$FLAG_LISTALL|bc`
		if test $SUM -gt 1;
			then
				echo "You input wrong options!!....-a,-d,-l : Only one option can be used at one time"
				exit;
		fi
		SUM=`echo $FLAG_D+$FLAG_L+$FLAG_A+$FLAG_LISTALL+$FLAG_S|bc`
		if test $SUM -eq 0;
			then
			select_function;
		fi
	if test $FLAG_A -eq 1;
		then
			clear
			echo "\nPlease input someone's infomation to add in address book file($ADDRESS_BOOK)\n"
			echo "\t1.User Name(nickname):\t\t$USERNAME"
			add;
	fi
	if test $FLAG_D -eq 1;
		then
			clear
			echo "\nPlease input someone's username to del in address book file($ADDRESS_BOOK)\n"
			echo "\tUser Name(nickname):\t\t$USERNAME"
			book_delete;
	fi
	if test $FLAG_L -eq 1;
		then
		clear
		echo "List $USERNAME's infomation which is in $ADDRESS_BOOK file."
		echo "=====================================================\n"
		CHECKREPEAT=`cat $ADDRESS_BOOK|grep "^$USERNAME:"|wc|awk '{print$1}'`
		if test $CHECKREPEAT -gt 0;
			then
			cat $ADDRESS_BOOK|grep "^$USERNAME:";
		else echo "The user $USERNAME is not in this address book!!\n";
		fi
		echo "Press enter key to continue......."
		read temp;
	fi
	if test $FLAG_S -eq 1;
		then
		book_sort;
	fi
		
	fi

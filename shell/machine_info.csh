#!/bin/csh -f
	onintr -
	set DO_HOST=127.0.0.1
	set ALLDO_HOST=127.0.0.1
	set GETMAILER=test
	set TEMPFILE=s9x4v%b3~s
	set REPORT_FILE=hosts.`/usr/bin/date +%Y%m%d`
	set RHOSTFILE=~/.rhosts
	@ O_FLAG=0;@ T_FLAG=0;@ L_FLAG=0;@ U_FLAG=0;@ D_FLAG=0;@ HELP_FLAG=1;@ M_FLAG=0;@ COUNT=0
	if(!(-e $RHOSTFILE))echo localhost > ~/.rhosts
	set RHOSTS=`more ~/.rhosts | grep ^localhost | wc | awk '{print $1+1}'`
	if($RHOSTS == 1)echo localhost >> ~/.rhosts
	if($#argv<1) @ HELP_FLAG=2
	while($#argv>0)
		switch($1)
		case -o:  
			@ O_FLAG=1
			breaksw
		case -t:       
			@ T_FLAG=1
			breaksw
		case -l:  
			@ L_FLAG=1
			breaksw
		case -u:
			@ U_FLAG=1
			breaksw
		case -d:
			@ D_FLAG=1
			breaksw
		case -m:
			@ M_FLAG=1
			set GETMAILER=$2
			switch($GETMAILER)
			case -?*: 
				echo "ERROR:-m '$GETMAILER'==> You must input options like '-m [USER]'."
				exit
				breaksw
			endsw
			
			breaksw
		case -a:
			@ O_FLAG=1;@ T_FLAG=1;@ L_FLAG=1;@ U_FLAG=1;@ D_FLAG=1
			breaksw
		case -h:
			set ALLDO_HOST=$2
			switch($ALLDO_HOST)
			case -?*: 
				echo "ERROR:-h '$ALLDO_HOST'==> You must input options like '-m RSH_MACHINE'."
				exit
				breaksw
			endsw
			breaksw
		case -hf:
			set MACHFILE=$2
			switch($MACHFILE)
			case -?*: 
				echo "ERROR:-hf '$ MACHFILE'==> You must input options like '-m FILENAME'."
				exit
				breaksw
			endsw
			set ALLDO_HOST = `awk '{print $1}' $MACHFILE`
			breaksw
		case -f:
			set REPORT_FILE=$2.`/usr/bin/date +%Y%m%d`;
			switch($REPORT_FILE)
			case -?*: 
				echo "ERROR:-f '$REPORT_FILE'==> You must input options like -m 'FILENAME'."
				exit
				breaksw
			endsw
			breaksw
		case -help: 
			@ HELP_FLAG=2
			breaksw
		endsw
        shift 
	end
	echo;
	if(-e $REPORT_FILE&&$HELP_FLAG == 1) echo "The old file '$REPORT_FILE' will be rewrited";echo " " > $REPORT_FILE;echo
	foreach DO_HOST ($ALLDO_HOST)
		(nslookup $DO_HOST | grep Name | cut -b10-;echo "=========================";)|tee $TEMPFILE
		cat $TEMPFILE >> $REPORT_FILE;

		if($O_FLAG)then
			(rsh $DO_HOST uname -a | awk '{print "OS: ",$1,"\tOS version(kernel version): ",$3,"\n";}'|tee $TEMPFILE;cat $TEMPFILE >> $REPORT_FILE)
		endif

		if($T_FLAG)then
			(rsh $DO_HOST uptime|awk '{print "Uptime: ",$3,$4,"and",$5,"\n";}'|cut -b1-29|tee $TEMPFILE;cat $TEMPFILE >> $REPORT_FILE)
		endif

		if($L_FLAG)then
			(rsh $DO_HOST uptime|awk 'BEGIN{print "load average: \t 1 minutes \t 5 minutes \t 15 minutes";}{print "\t\t    ",$10,"\t    ",$11,"\t      ",$12,"\n";}'|tee $TEMPFILE;cat $TEMPFILE >> $REPORT_FILE)
		endif

		if($U_FLAG)then
			(set U_COM = `rsh $DO_HOST w|sort|cut -b52-|awk '{if(NR>2) print $1;}'`;rsh $DO_HOST who|sort|awk 'BEGIN{u=0;print"\tUSER \t LOGIN TIME \t    FROM";}{printf("[%d] %8s\t%s %s %s\t%s\n",NR, $1,$3,$4,$5,$6);}'|tee $TEMPFILE;echo "" |tee $TEMPFILE;cat $TEMPFILE >> $REPORT_FILE)
#|tee $TEMPFILE;echo "" |tee $TEMPFILE;cat $TEMPFILE >> $REPORT_FILE) 

		endif

		if($D_FLAG)then
			(rsh $DO_HOST df -k|tee $TEMPFILE;cat $TEMPFILE >> $REPORT_FILE;rsh $DO_HOST  df -k|awk 'BEGIN{sum_all=sum_use=sum_free=0;}{if(NR>1){sum_all+=$2;sum_use+=$3;sum_free+=$4;} if(NR==NF-1) print "--------------------------------------------------------------------------\nUsed:",sum_use/1024,"MB(",int(sum_use/sum_all*100),"%)","     Free:",sum_free/1024,"MB(",int(sum_free/sum_all*100),"%)","     TOTAL:",sum_all/1024,"MB\n==========================================================================\n";}'|tee $TEMPFILE;cat $TEMPFILE >> $REPORT_FILE)
		endif

		if($HELP_FLAG == 2)then
(echo "    -o  : OS version \
    -t  : system alive time \
    -l  : system load \
    -u  : user list \
    -d  : summarize free disk space and used disk capacity \
    -m user : mail the report to user default user[test] \
    -a  : all of the above options \
    -h hosts: remote hosts need to be checked \
    -hf file: remote host file [contain all hosts need to be checked] \
    -f file : report file name [using date to be extension file name \
                    ex. file.20001130 	[Default] hosts.date ] \
    -help   : help [show usage] ";exit)
		endif

	end
		rm -rf $TEMPFILE
		mail $GETMAILER < $REPORT_FILE
		echo "Output report will be saved to '$REPORT_FILE', and mail to '$GETMAILER'."
	onintr

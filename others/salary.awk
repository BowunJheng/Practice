awk ' 
BEGIN{
	"date"|getline
	print $3"る羱挡衡" 
	print "=================="
	T1=0
	T2=0
	ARGV="-"
	}
	{
	FS="[\t:]+"
	getline < "salary.in"
	if($2<15){
		print $1"腹    秨﹍ㄨ " $2 ":" $3 "   挡ㄨ " $4 ":" $5
		if($4<$2)
			if($4<1){
				if($5>29)
				check_hr_add_30(((24*60)-($2*60+$3))/60,($5/60))
				else 
				check_hr_add(((24*60)-($2*60+$3))/60)
			}
			else
			check_hr_nal_add(((24*60)-($2*60+$3))/60,($4*60+$5)/60)
		else
			check_hr_add((($4*60+$5)-($2*60+$3))/60) 
		}
	else{
		print $1"腹    秨﹍ㄨ " $2 ":" $3 "   挡ㄨ " $4 ":" $5
		if($4<$2)
			if($4<1){
				if($5>29)
				check_hr_add_30(((24*60)-($2*60+$3))/60,($5/60))
				else 
				check_hr(((24*60)-($2*60+$3))/60)
			}
			else
			check_hr_nal_add(((24*60)-($2*60+$3))/60,($4*60+$5)/60)
		else
			check_hr((($4*60+$5)-($2*60+$3))/60)  	
		}
	}
function check_hr_add(hour){
	if (hour-int(hour)<0.5){
		print "			丁    0      痁  "int(hour) ""
	T2=T2+int(hour)
	print "			羆:		计" T1 " 痁计" T2 ""
		}
	else{
		print "			丁    0      痁  "int(hour)+0.5 ""
	T2=T2+int(hour)+0.5
	print "			羆:		计" T1 " 痁计" T2 ""
		}
	}
function check_hr(hour){
	if (hour-int(hour)<0.5){
		print "			丁  "int(hour) "      痁    0"
	T1=T1+int(hour)
	print "			羆:		计" T1 " 痁计" T2 ""
	}
	else{
		print "			丁  "int(hour)+0.5 "      痁    0"
	T1=T1+int(hour)+0.5
	print "			羆:		计" T1 " 痁计" T2 ""
	}
	}
function check_hr_nal_add(hour,hour2){
	if (hour-int(hour)<0.5&&hour2-int(hour2)<0.5){
		print "			丁  "int(hour) "      痁  "int(hour2) ""
	T1=T1+int(hour)
	T2=T2+int(hour2)
	print "			羆:		计" T1 " 痁计" T2 ""
	}
	else if(hour-int(hour)<0.5&&hour2-int(hour2)>0.5){
		print "			丁  "int(hour) "      痁  "int(hour2)+0.5 ""
	T1=T1+int(hour)
	T2=T2+int(hour2)+0.5
	print "			羆:		计" T1 " 痁计" T2 ""
	}
	else if(hour-int(hour)>0.5&&hour2-int(hour2)<0.5){
		print "			丁  "int(hour)+0.5 "      痁  "int(hour2) ""
	T1=T1+int(hour)+0.5
	T2=T2+int(hour2)
	print "			羆:		计" T1 " 痁计" T2 ""
	}
	else{
		print "			丁  "int(hour)+0.5 "      痁  "int(hour2)+0.5 ""
	T1=T1+int(hour)+0.5
	T2=T2+int(hour2)+0.5
	print "			羆:		计" T1 " 痁计" T2 ""
	}
	}
function check_hr_org_add(hour,hour2){
	if (hour-int(hour)<0.5&&hour2-int(hour2)<0.5){
		print "			丁  "0"      痁  " int(hour)+int(hour2) ""
	T2=T2+int(hour)+int(hour2)
	print "			羆:		计" T1 " 痁计" T2 ""
	}
	else if(hour-int(hour)<0.5&&hour2-int(hour2)>0.5){
		print "			丁  "0"      痁  " int(hour)+int(hour2)+0.5 ""
	T2=T2+int(hour)+int(hour2)+0.5
	print "			羆:		计" T1 " 痁计" T2 ""
	}
	else if(hour-int(hour)>0.5&&hour2-int(hour2)<0.5){
		print "			丁  "0"      痁  "int(hour)+int(hour2)+0.5 ""
	T2=T2+int(hour)+int(hour2)+0.5
	print "			羆:		计" T1 " 痁计" T2 ""
	}
	else{
		print "			丁  "0"      痁  "int(hour)+int(hour2)+1 ""
	T2=T2+int(hour)+int(hour2)+1
	print "			羆:		计" T1 " 痁计" T2 ""
	}
	}
function check_hr_add_30(hour,hour2){
	if (hour-int(hour)<0.5&&hour2-int(hour2)<0.5){
		print "			丁  "int(hour) "      痁    0"
	T1=T1+int(hour)
	print "			羆:		计" T1 " 痁计" T2 ""
	}
	else if (hour-int(hour)<0.5&&hour2-int(hour2)>0.5){
		print "			丁  "int(hour) "      痁    0.5"
	T1=T1+int(hour)
	T2=T2+0.5
	print "			羆:		计" T1 " 痁计" T2 ""
	}
	else if (hour-int(hour)>0.5&&hour2-int(hour2)<0.5){
		print "			丁  "int(hour)+0.5 "      痁    0"
	T1=T1+int(hour)+0.5
	print "			羆:		计" T1 " 痁计" T2 ""
	}
	else
	{
		print "			丁  "int(hour)+0.5 "      痁    0.5"
	T1=T1+int(hour)+0.5
	T2=T2+0.5
	print "			羆:		计" T1 " 痁计" T2 ""
	}
	}
END{}
'

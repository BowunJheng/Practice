awk ' 
BEGIN{
	"date"|getline
	print $3"���~�����" 
	print "=================="
	T1=0
	T2=0
	ARGV="-"
	}
	{
	FS="[\t:]+"
	getline < "salary.in"
	if($2<15){
		print $1"��    �}�l�ɨ� " $2 ":" $3 "   �����ɨ� " $4 ":" $5
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
		print $1"��    �}�l�ɨ� " $2 ":" $3 "   �����ɨ� " $4 ":" $5
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
		print "			�@��ɶ�    0�p��      �[�Z  "int(hour) "�p��"
	T2=T2+int(hour)
	print "			�`�X:		�@��ɼ�" T1 "�p�� �[�Z�ɼ�" T2 "�p��"
		}
	else{
		print "			�@��ɶ�    0�p��      �[�Z  "int(hour)+0.5 "�p��"
	T2=T2+int(hour)+0.5
	print "			�`�X:		�@��ɼ�" T1 "�p�� �[�Z�ɼ�" T2 "�p��"
		}
	}
function check_hr(hour){
	if (hour-int(hour)<0.5){
		print "			�@��ɶ�  "int(hour) "�p��      �[�Z    0�p��"
	T1=T1+int(hour)
	print "			�`�X:		�@��ɼ�" T1 "�p�� �[�Z�ɼ�" T2 "�p��"
	}
	else{
		print "			�@��ɶ�  "int(hour)+0.5 "�p��      �[�Z    0�p��"
	T1=T1+int(hour)+0.5
	print "			�`�X:		�@��ɼ�" T1 "�p�� �[�Z�ɼ�" T2 "�p��"
	}
	}
function check_hr_nal_add(hour,hour2){
	if (hour-int(hour)<0.5&&hour2-int(hour2)<0.5){
		print "			�@��ɶ�  "int(hour) "�p��      �[�Z  "int(hour2) "�p��"
	T1=T1+int(hour)
	T2=T2+int(hour2)
	print "			�`�X:		�@��ɼ�" T1 "�p�� �[�Z�ɼ�" T2 "�p��"
	}
	else if(hour-int(hour)<0.5&&hour2-int(hour2)>0.5){
		print "			�@��ɶ�  "int(hour) "�p��      �[�Z  "int(hour2)+0.5 "�p��"
	T1=T1+int(hour)
	T2=T2+int(hour2)+0.5
	print "			�`�X:		�@��ɼ�" T1 "�p�� �[�Z�ɼ�" T2 "�p��"
	}
	else if(hour-int(hour)>0.5&&hour2-int(hour2)<0.5){
		print "			�@��ɶ�  "int(hour)+0.5 "�p��      �[�Z  "int(hour2) "�p��"
	T1=T1+int(hour)+0.5
	T2=T2+int(hour2)
	print "			�`�X:		�@��ɼ�" T1 "�p�� �[�Z�ɼ�" T2 "�p��"
	}
	else{
		print "			�@��ɶ�  "int(hour)+0.5 "�p��      �[�Z  "int(hour2)+0.5 "�p��"
	T1=T1+int(hour)+0.5
	T2=T2+int(hour2)+0.5
	print "			�`�X:		�@��ɼ�" T1 "�p�� �[�Z�ɼ�" T2 "�p��"
	}
	}
function check_hr_org_add(hour,hour2){
	if (hour-int(hour)<0.5&&hour2-int(hour2)<0.5){
		print "			�@��ɶ�  "0"�p��      �[�Z  " int(hour)+int(hour2) "�p��"
	T2=T2+int(hour)+int(hour2)
	print "			�`�X:		�@��ɼ�" T1 "�p�� �[�Z�ɼ�" T2 "�p��"
	}
	else if(hour-int(hour)<0.5&&hour2-int(hour2)>0.5){
		print "			�@��ɶ�  "0"�p��      �[�Z  " int(hour)+int(hour2)+0.5 "�p��"
	T2=T2+int(hour)+int(hour2)+0.5
	print "			�`�X:		�@��ɼ�" T1 "�p�� �[�Z�ɼ�" T2 "�p��"
	}
	else if(hour-int(hour)>0.5&&hour2-int(hour2)<0.5){
		print "			�@��ɶ�  "0"�p��      �[�Z  "int(hour)+int(hour2)+0.5 "�p��"
	T2=T2+int(hour)+int(hour2)+0.5
	print "			�`�X:		�@��ɼ�" T1 "�p�� �[�Z�ɼ�" T2 "�p��"
	}
	else{
		print "			�@��ɶ�  "0"�p��      �[�Z  "int(hour)+int(hour2)+1 "�p��"
	T2=T2+int(hour)+int(hour2)+1
	print "			�`�X:		�@��ɼ�" T1 "�p�� �[�Z�ɼ�" T2 "�p��"
	}
	}
function check_hr_add_30(hour,hour2){
	if (hour-int(hour)<0.5&&hour2-int(hour2)<0.5){
		print "			�@��ɶ�  "int(hour) "�p��      �[�Z    0�p��"
	T1=T1+int(hour)
	print "			�`�X:		�@��ɼ�" T1 "�p�� �[�Z�ɼ�" T2 "�p��"
	}
	else if (hour-int(hour)<0.5&&hour2-int(hour2)>0.5){
		print "			�@��ɶ�  "int(hour) "�p��      �[�Z    0.5�p��"
	T1=T1+int(hour)
	T2=T2+0.5
	print "			�`�X:		�@��ɼ�" T1 "�p�� �[�Z�ɼ�" T2 "�p��"
	}
	else if (hour-int(hour)>0.5&&hour2-int(hour2)<0.5){
		print "			�@��ɶ�  "int(hour)+0.5 "�p��      �[�Z    0�p��"
	T1=T1+int(hour)+0.5
	print "			�`�X:		�@��ɼ�" T1 "�p�� �[�Z�ɼ�" T2 "�p��"
	}
	else
	{
		print "			�@��ɶ�  "int(hour)+0.5 "�p��      �[�Z    0.5�p��"
	T1=T1+int(hour)+0.5
	T2=T2+0.5
	print "			�`�X:		�@��ɼ�" T1 "�p�� �[�Z�ɼ�" T2 "�p��"
	}
	}
END{}
'

awk '
BEGIN{
	#"date"|getline
	#print "上站人數統計表(",$2,$3,$1,$6")">"login.html"
	#print "========================================">"login.html"
	#close("login.html")
	x=0
	}

	{
	FS="\n"
	RS=""
	"last"|getline
	print $1>"temp_login"
	print $2>"temp_lasttime"
	close("temp_login")
	close("temp_lasttime")
	FS="[\t:]+"
	RS="\n"
	getline<"temp_login"
	if($4~/Mon/) {
		printf("\n禮拜一\t") >>"login.html"
		while(x<24){
			printf("%d:00 ",x)>>"login.html"
			x++
			}
		Add_Hr_login($7)
		printf("\n\t%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d ",Hr24,Hr1,Hr2,Hr3,Hr4,Hr5,Hr6,Hr7,Hr8,Hr9,Hr10,Hr11,Hr12,Hr13,Hr14,Hr15,Hr16,Hr17,Hr18,Hr19,Hr20,Hr21,Hr22,Hr23)>>"login.html"
		}
	if($4~/Tue/) {
		printf("\n禮拜二\t")>>"login.html"
		while(x<24){
			printf("%d:00~%d59 ",x,x)>>"login.html"
			x++
			}
		Add_Hr_login($7)
		printf("\n\t%d %d %d	%d %d %d	%d %d %d	%d %d %d	%d %d %d	%d %d %d	%d %d %d	%d %d %d	",Hr24,Hr1	,Hr2,Hr3,Hr4,Hr5,Hr6,Hr7,Hr8,Hr9,Hr10,Hr11,Hr12,Hr13,Hr14,Hr15,Hr16,Hr17,Hr18,Hr19,Hr20,Hr21,Hr22,Hr23)>>"login.html"
		}
	if($4~/Wed/) {
		printf("\n禮拜三\t")>>"login.html"
		while(x<24){
			printf("%d:00~%d59 ",x,x)>>"login.html"
			x++
			}
		Add_Hr_login($7)
		printf("\n\t%d %d %d	%d %d %d	%d %d %d	%d %d %d	%d %d %d	%d %d %d	%d %d %d	%d %d %d	",Hr24,Hr1	,Hr2,Hr3,Hr4,Hr5,Hr6,Hr7,Hr8,Hr9,Hr10,Hr11,Hr12,Hr13,Hr14,Hr15,Hr16,Hr17,Hr18,Hr19,Hr20,Hr21,Hr22,Hr23)>>"login.html"
		}
	if($4~/Thu/) {
		printf("\n禮拜四\t")>>"login.html"
		while(x<24){
			printf("%d:00~%d59 ",x,x)>>"login.html"
			x++
			}
		Add_Hr_login($7)
		printf("\n\t%d %d %d	%d %d %d	%d %d %d	%d %d %d	%d %d %d	%d %d %d	%d %d %d	%d %d %d	",Hr24,Hr1	,Hr2,Hr3,Hr4,Hr5,Hr6,Hr7,Hr8,Hr9,Hr10,Hr11,Hr12,Hr13,Hr14,Hr15,Hr16,Hr17,Hr18,Hr19,Hr20,Hr21,Hr22,Hr23)>>"login.html"
		}
	if($4~/Fri/) {
		printf("\n禮拜五\t")>>"login.html"
		while(x<24){
			printf("%d:00~%d59 ",x,x)>>"login.html"
			x++
			}
		Add_Hr_login($7)
		printf("\n\t%d %d %d	%d %d %d	%d %d %d	%d %d %d	%d %d %d	%d %d %d	%d %d %d	%d %d %d	",Hr24,Hr1	,Hr2,Hr3,Hr4,Hr5,Hr6,Hr7,Hr8,Hr9,Hr10,Hr11,Hr12,Hr13,Hr14,Hr15,Hr16,Hr17,Hr18,Hr19,Hr20,Hr21,Hr22,Hr23)>>"login.html"
		}
	if($4~/Sat/) {
		printf("\n禮拜六\t")>>"login.html"
		while(x<24){
			printf("%d:00~%d59 ",x,x)>>"login.html"
			x++
			}
		Add_Hr_login($7)
		printf("\n\t%d %d %d	%d %d %d	%d %d %d	%d %d %d	%d %d %d	%d %d %d	%d %d %d	%d %d %d	",Hr24,Hr1	,Hr2,Hr3,Hr4,Hr5,Hr6,Hr7,Hr8,Hr9,Hr10,Hr11,Hr12,Hr13,Hr14,Hr15,Hr16,Hr17,Hr18,Hr19,Hr20,Hr21,Hr22,Hr23)>>"login.html"
		}
	if($4~/Sun/) {
		printf("\n禮拜日\t")>>"login.html"
		while(x<24){
			printf("%d:00~%d59 ",x,x)>>"login.html"
			x++
			}
		Add_Hr_login($7)
		printf("\n\t%d %d %d	%d %d %d	%d %d %d	%d %d %d	%d %d %d	%d %d %d	%d %d %d	%d %d %d	",Hr24,Hr1	,Hr2,Hr3,Hr4,Hr5,Hr6,Hr7,Hr8,Hr9,Hr10,Hr11,Hr12,Hr13,Hr14,Hr15,Hr16,Hr17,Hr18,Hr19,Hr20,Hr21,Hr22,Hr23)>>"login.html"
		}


	printf("\n請輸入你的名字:")
	name="-"
	printf("\n\t\t\t\t\t\t%s",name)>>"login.html"
	}

function Add_Hr_login(Hour){
	Hr1=Hr2=Hr3=Hr4=Hr5=Hr6=Hr7=Hr8=Hr9=Hr10=Hr11=Hr12=Hr13=Hr14=Hr15=Hr16=Hr17=Hr18=Hr19=Hr20=Hr21=Hr22=Hr23=Hr24=0
	if(Hour=0){
		Hr24++;
		}
	else if(Hour=1){
		Hr1++;
		}
	else if(Hour=2){
		Hr2++;
		}
	else if(Hour=3){
		Hr3++;
		}
	else if(Hour=4){
		Hr4++;
		}
	else if(Hour=5){
		Hr5++;
		}
	else if(Hour=6){
		Hr6++;
		}
	else if(Hour=7){
		Hr7++;
		}
	else if(Hour=8){
		Hr8++;
		}
	else if(Hour=9){
		Hr9++;
		}
	else if(Hour=10){
		Hr10++;
		}
	else if(Hour=11){
		Hr11++;
		}
	else if(Hour=12){
		Hr12++;
		}
	else if(Hour=13){
		Hr13++;
		}
	else if(Hour=14){
		Hr14++;
		}
	else if(Hour=15){
		Hr15++;
		}
	else if(Hour=16){
		Hr16++;
		}
	else if(Hour=17){
		Hr17++;
		}
	else if(Hour=18){
		Hr18++;
		}
	else if(Hour=19){
		Hr19++;
		}
	else if(Hour=20){
		Hr20++;
		}
	else if(Hour=21){
		Hr21++;
		}
	else if(Hour=22){
		Hr22++;
		}
	else{
		Hr23++;
		}
	}
'

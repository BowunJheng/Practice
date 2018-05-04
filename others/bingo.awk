nawk 'BEGIN{
ARGC=1
"date"|getline
clo=substr($4,1,2)
min=substr($4,4,2)
sec=substr($4,7,2)
start_time=tran2sec(clo,min,sec)
system("clear")
printf("==================BINGO GAME START AT %d:%dmin:%dsec==============",clo,min,sec)
}
{
srand()
i=0;
while(i<=3){
ran_num[i]=get_ran()
check_ran()
i++;
}
if(ARGV[1]=="-d")
printf("The answer is: %d%d%d%d\n",ran_num[0],ran_num[1],ran_num[2],ran_num[3])
g_times=1
while(guess_time(number)!=4){
}
if(number!="exit"){
"/usr/bin/date"|getline
clo_end=substr($4,1,2)
min=substr($4,4,5)
sec=substr($4,7,8)
end_time=tran2sec(clo,min,sec)
printf("\n========================== BINGO!!! %d:%dmin:%dsec===================\n",clo,min,sec)
printf("Please Input your name. NAME===>")
getline name
printf("%s:%d:\n",name,end_time-start_time) >> "score.txt"
}
system("Bingo_Game.sh")
exit
}
function tran2sec(clo,min,sec){
return clo*60*60+min*60+sec
}

function get_ran(){
number=int(rand()*9)+1
return number;
}
function check_ran(){
temp=0
while(temp<i){
	if(ran_num[i]==ran_num[temp]){
	i--;break}
	temp++;}
}
function guess_time(number){
temp_2=0
sep_4=0
guess_A=0
guess_B=0
printf("Please Input 4-bit number?? => ")
getline number < "-"
if(number=="bobo")
printf("%d%d%d%d\n",ran_num[0],ran_num[1],ran_num[2],ran_num[3])
if(number=="exit") exit
if(length(number)!=4||number !~/^[0-9][0-9][0-9][0-9]$/){
	do{
	printf("wrong 4-bit number, Please input again..==>")
	getline number < "-"
	if(number=="exit") exit
	}while(length(number)!=4||number !~/^[0-9][0-9][0-9][0-9]$/)
}

while(sep_4<4){
	input_num[sep_4]=substr(number,1,1)
	number=substr(number,2)
	temp=0
	while(temp<sep_4){
	if(input_num[sep_4]==input_num[temp]){
	return 0}
	temp++;}
	sep_4++
}
while(temp_2<4){
if(input_num[temp_2]==ran_num[temp_2])
	guess_A++
if(input_num[temp_2]==ran_num[(temp_2+1)%4])
	guess_B++
if(input_num[temp_2]==ran_num[(temp_2+2)%4])
	guess_B++
if(input_num[temp_2]==ran_num[(temp_2+3)%4])
	guess_B++
temp_2++
}
printf("\t\t\t\t\t[%d]You input number %d%d%d%d ==> %dA%dB\n",g_times,input_num[0],input_num[1],input_num[2],input_num[3],guess_A,guess_B)
g_times++
return guess_A
}' $*

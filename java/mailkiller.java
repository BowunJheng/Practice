import java.io.*;
import java.util.*;

class Mailkiller{
	public static void main(String args[]) throws Exception{
	Calendar calendar=Calendar.getInstance();
	int temp_sum=0,diff_month,count_step,day_count,write_flag=1,s=0,t=0,z=0;
	int first,temp,mailaddr_temp,liby_temp,month_temp,oneday_temp,time_temp;
	int a_flag=0,A_flag=0,w_flag=0,W_flag=0,y_flag=0,Y_flag=0,b_flag=0,save_p=0;
	int d_flag=0,D_flag=0,m_flag=0,M_flag=0,end_flag=0,log_disable=0,g_flag=0;
	String del_day=new String(),diff_del_day=new String();
	String del_liby=new String(),want_liby=new String();
	String del_month=new String(),want_month=new String();
	String del_ipaddr=new String(),want_ipaddr=new String();
	String del_year=new String(),want_year=new String();
	String User_id=new String(),del_group=new String();;
	String now_month,now_day,now_year,now_time;
	String Temp_line,Temp_line2,mailaddr,liby,month,oneday,time,now_alltime,year,sele_line;
	String months[]={"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
	String weeks[]={"Mon","Tue","Wed","Thu","Fri","Sat","Sun"};
	now_month=months[calendar.get(Calendar.MONTH)];
	now_day=Integer.toString(calendar.get(Calendar.DATE));
	now_time=calendar.get(Calendar.HOUR)+":"+calendar.get(Calendar.MINUTE)+":"+calendar.get(Calendar.SECOND);
	now_year=Integer.toString(calendar.get(Calendar.YEAR));
	int month_day[]={31,28,31,30,31,30,31,31,30,31,30,31};
	String Filename[]=new String[100],log_file=new String(),mail_file=new String();
	Filename[0]="/var/mail/"+System.getProperty("user.name");
	log_file="./"+calendar.get(Calendar.MONTH)+"_"+calendar.get(Calendar.DATE)+"_"+calendar.get(Calendar.YEAR)+"_Mailkiller.log";
	long want_size=0,add_size=0;

//!!To show the help menu if argc<1.

	if(args.length<1){
	}else{

//!!To check any property whom we want.

	while(s<args.length){
		if(args[s].charAt(0)=='-'){
			switch(args[s].charAt(1)){
				case 'a':
				a_flag=1;
				del_ipaddr=args[s+1];
				break;
				case 'A':
				A_flag=1;
				want_ipaddr=args[s+1];
				break;
				case 'b':
				b_flag=1;
				want_size=Long.parseLong(args[s+1]);
				break;
				case 'B':
				break;
				case 'd':
				d_flag=1;
				temp_sum=Integer.parseInt(now_day)-Integer.parseInt(args[s+1]);
				if(temp_sum>=0)
				del_day=Integer.toString(temp_sum);
				else{
				diff_month=calendar.get(Calendar.MONTH);
				while(temp_sum<0){
					diff_month-=1;
					temp_sum+=month_day[diff_month];
					}
				while(diff_month>=0){
				temp_sum+=month_day[diff_month];
				diff_month-=1;
				}diff_del_day=Integer.toString(temp_sum);
				}
				break;
				case 'D':
				D_flag=1;
				temp_sum=Integer.parseInt(now_day)-Integer.parseInt(args[s+1]);
				if(temp_sum>=0)
				del_day=Integer.toString(temp_sum);
				else{
				diff_month=calendar.get(Calendar.MONTH);
				while(temp_sum<0){
					diff_month-=1;
					temp_sum+=month_day[diff_month];
					}
				while(diff_month>=0){
				temp_sum+=month_day[diff_month];
				diff_month-=1;
				}diff_del_day=Integer.toString(temp_sum);
				}
				break;
				case 'e':
				break;
				case 'f':
				if(args[s+1].toLowerCase().equals("off")){
				log_disable=1;
				log_file="";
				}else{
				log_file="./"+args[s+1]+"_"+calendar.get(Calendar.MONTH)+"_"+calendar.get(Calendar.DATE)+"_"+calendar.get(Calendar.YEAR)+".log";
				}
				break;
				case 'g':
				g_flag=1;
				del_group=args[s+1];
				break;
				case 'w':
				w_flag=1;
				if(args[s+1].compareTo("8")>0||args[s+1].compareTo("0")<0){
				System.out.println("[error] no liby"+args[s+1]);
				break;
				}else{
				del_liby=weeks[Integer.parseInt(args[s+1])-1];
				}
				break;
				case 'W':
				W_flag=1;
				if(args[s+1].compareTo("8")>0||args[s+1].compareTo("0")<0){
				System.out.println("[error] no liby"+args[s+1]);
				break;
				}else{
				want_liby=weeks[Integer.parseInt(args[s+1])-1];
				}
				break;
				case 'o':
				break;
				case 'O':
				break;
				case 'm':
				del_month=months[Integer.parseInt(args[s+1])-1];
				break;
				case 'M':
				break;
				case 'p':
				Filename[0]= new String("/var/mail/"+args[s+1]);
				break;
				case 'P':
				break;
				case 't':
				break;
				case 'T':
				break;
				case 'y':
				y_flag=1;
				del_year=args[s+1];
				break;
				case 'Y':
				Y_flag=1;
				want_year=args[s+1];
				break;
			}
			
		}else{ 
			//System.out.println(args[s]);
		}
		s++;
	}
	if(g_flag==1&System.getProperty("user.name").equals("root")){
	FileReader group_temp = new FileReader("group_table");
	BufferedReader sel_group = new BufferedReader(group_temp);
	while((sele_line=sel_group.readLine())!=null){
		if(sele_line.equals("[/"+del_group+"]")) save_p=0;
		if(save_p==1) Filename[t++]="/var/mail/"+sele_line;
		if(sele_line.equals("["+del_group+"]")) save_p=1;
		}
	t--;
	sel_group.close();
	}
	
	//if(System.getProperty("user.name").equals("root")&&Filename.equals("/var/mail/root")) {
	//File mail_box=new File("/var/mail");
	//if(mail_box.isDirectory()){
	//	String mail_user[]=mail_box.list();
	//	int t=0;
	//	for(int i=0;i<mail_user.length;i++){
	//	File mail_check = new File("/var/mail"+mail_user[i]);
	//	if(mail_check.isFile()){ Filename= "/var/mail/"+mail_user[i];s++;System.out.println(Filename);}
	//	}
	//}}
	//int us=0;
	//while(Filename!=null){
	while(z<=t){
	mail_file=Filename[z++];
	byte buffer[];
	FileOutputStream fout= new FileOutputStream("temp.txt");
	ObjectOutputStream ofout=new ObjectOutputStream(fout);
	ofout.flush();
	FileOutputStream flogout= new FileOutputStream(log_file);
	ObjectOutputStream oflogout=new ObjectOutputStream(flogout);
	oflogout.flush();
	FileReader mail= new FileReader(mail_file);
	BufferedReader mail_buff= new BufferedReader(mail);
	while((Temp_line=mail_buff.readLine())!=null){
	add_size+=Temp_line.length();
	byte buf[]=Temp_line.getBytes();
	if(Temp_line.length()>4){
		String A_title= new String(Temp_line.substring(0,5));
		if(A_title.equals("From ")){
		try{
			first=Temp_line.indexOf(" ");
			mailaddr_temp=Temp_line.indexOf(" ",first+1);
			mailaddr=Temp_line.substring(first,mailaddr_temp);
			liby_temp=Temp_line.indexOf(" ",mailaddr_temp+1);
			liby=Temp_line.substring(mailaddr_temp,liby_temp);
			month_temp=Temp_line.indexOf(" ",liby_temp+1);
			month=Temp_line.substring(liby_temp,month_temp);
			oneday_temp=Temp_line.indexOf(" ",month_temp+1);
			oneday=Temp_line.substring(month_temp,oneday_temp);
			if(oneday.equals(" ")){
			temp=oneday_temp;
			oneday_temp=Temp_line.indexOf(" ",oneday_temp+1);
			oneday=Temp_line.substring(temp,oneday_temp);
			}

			time_temp=Temp_line.indexOf(" ",oneday_temp+1);
			time=Temp_line.substring(oneday_temp,time_temp);
			year=Temp_line.substring(time_temp,Temp_line.length());

				if(a_flag==1) if(mailaddr.trim().equals(del_ipaddr)){
				write_flag=0;
				if(log_file.equals(""))
				System.out.println("[D_address]"+mail_file+":"+Temp_line);
				else{
					oflogout.writeBytes("[D_address]");
					oflogout.writeBytes(mail_file);
					oflogout.writeBytes(":");
					oflogout.writeBytes(Temp_line);
                			oflogout.writeBytes("\n");
					}
				}
				else write_flag=1;

				if(A_flag==1) if(mailaddr.trim().equals(want_ipaddr))
				write_flag=1;
				else{
				write_flag=0;
				if(log_file.equals(""))
				System.out.println("[D_address]"+mail_file+":"+Temp_line);
				else{
					oflogout.writeBytes("[D_address]");
					oflogout.writeBytes(mail_file);
					oflogout.writeBytes(":");
					oflogout.writeBytes(Temp_line);
                			oflogout.writeBytes("\n");
					}
				}

				if(d_flag==1) if(oneday.trim().compareTo(del_day)>0 & month.trim().compareTo(now_month)==0 & year.trim().compareTo(now_year)==0 & !del_day.equals("")){
				write_flag=0;
				if(log_file.equals(""))
				System.out.println("[D_day]"+mail_file+":"+Temp_line);
				else{
					oflogout.writeBytes("[D_address]");
					oflogout.writeBytes(mail_file);
					oflogout.writeBytes(":");
					oflogout.writeBytes(Temp_line);
                			oflogout.writeBytes("\n");
					}
				}
				else write_flag=1;

				if(D_flag==1) if(oneday.trim().compareTo(del_day)>0 & month.trim().compareTo(now_month)==0 & year.trim().compareTo(now_year)==0 & !del_day.equals(""))
				write_flag=1;
				else{ write_flag=1;
				if(log_file.equals(""))
				System.out.println("[D_day]"+mail_file+":"+Temp_line);
				else{
					oflogout.writeBytes("[D_address]");
					oflogout.writeBytes(mail_file);
					oflogout.writeBytes(":");
					oflogout.writeBytes(Temp_line);
                			oflogout.writeBytes("\n");
					}
				}

				if(d_flag==1||D_flag==1) if(!diff_del_day.equals("")){
				day_count=Integer.parseInt(oneday.trim());
				switch(month.charAt(1)){
				case 'J':
				if(month.charAt(2)=='a'){
 				day_count+=month_day[0];
				}else if(month.charAt(3)=='n'){
				count_step=5;
				while(count_step>=0){
        			day_count+=month_day[count_step];
				count_step-=1;
				}}else{
				count_step=6;
				while(count_step>=0){
        			day_count+=month_day[count_step];
				count_step-=1;}
				}
 				break;
 				case 'F':
				count_step=1;
				while(count_step>=0){
        			day_count+=month_day[count_step];
				count_step-=1;
				}
 				break;
 				case 'M':
				if(month.charAt(3)=='r'){
				count_step=2;
				while(count_step>=0){
        			day_count+=month_day[count_step];
				count_step-=1;}}else{
				count_step=4;
				while(count_step>=0){
        			day_count+=month_day[count_step];
				count_step-=1;}
				}
        			break;
        			case 'A':
				if(month.charAt(2)=='p'){
				count_step=3;
				while(count_step>=0){
        			day_count+=month_day[count_step];
				count_step-=1;}}else{
				count_step=7;
				while(count_step>=0){
        			day_count+=month_day[count_step];
				count_step-=1;}
				}
        			break;
        			case 'S':
				count_step=8;
				while(count_step>=0){
        			day_count+=month_day[count_step];
				count_step-=1;
				}
        			break;
        			case 'O':
				count_step=9;
				while(count_step>=0){
        			day_count+=month_day[count_step];
				count_step-=1;
				}
        			break;
        			case 'N':
				count_step=10;
				while(count_step>=0){
        			day_count+=month_day[count_step];
				count_step-=1;
				}
        			break;
        			case 'D':
				count_step=11;
				while(count_step>=0){
        			day_count+=month_day[count_step];
				count_step-=1;
				}
        			break;
                			}
				if(d_flag==1) if(day_count>temp_sum){
				write_flag=0;
				if(log_file.equals(""))
				System.out.println("[D_after_day]"+mail_file+":"+Temp_line);
				else{
					oflogout.writeBytes("[D_address]");
					oflogout.writeBytes(mail_file);
					oflogout.writeBytes(":");
					oflogout.writeBytes(Temp_line);
                			oflogout.writeBytes("\n");
					}
				}else write_flag=1;

				if(D_flag==1) if(day_count<temp_sum){
				write_flag=0;
				if(log_file.equals(""))
				System.out.println("[D_after_day]"+mail_file+":"+Temp_line);
				else{
					oflogout.writeBytes("[D_address]");
					oflogout.writeBytes(mail_file);
					oflogout.writeBytes(":");
					oflogout.writeBytes(Temp_line);
                			oflogout.writeBytes("\n");
					}
				}else write_flag=1;
				}	

				if(w_flag==1) if(liby.trim().equals(del_liby)){
				write_flag=0;
				if(log_file.equals(""))
				System.out.println("[D_week]"+mail_file+":"+Temp_line);
				else{
					oflogout.writeBytes("[D_address]");
					oflogout.writeBytes(mail_file);
					oflogout.writeBytes(":");
					oflogout.writeBytes(Temp_line);
                			oflogout.writeBytes("\n");
					}
				}
				else write_flag=1;

				if(W_flag==1) if(liby.trim().equals(want_liby))
				write_flag=1;
				else{
				write_flag=0;
				if(log_file.equals(""))
				System.out.println("[D_week]"+mail_file+":"+Temp_line);
				else{
					oflogout.writeBytes("[D_address]");
					oflogout.writeBytes(mail_file);
					oflogout.writeBytes(":");
					oflogout.writeBytes(Temp_line);
                			oflogout.writeBytes("\n");
					}
				}

				if(m_flag==1) if(month.trim().equals(del_month)){
				write_flag=0;
				if(log_file.equals(""))
				System.out.println("[D_month]"+mail_file+":"+Temp_line);
				else{
					oflogout.writeBytes("[D_address]");
					oflogout.writeBytes(mail_file);
					oflogout.writeBytes(":");
					oflogout.writeBytes(Temp_line);
                			oflogout.writeBytes("\n");
					}
				}
				else write_flag=1;

				if(y_flag==1) if(year.trim().compareTo(del_year)>=0){
				write_flag=0;
				if(log_file.equals(""))
				System.out.println("[D_year]"+mail_file+":"+Temp_line);
				else{
					oflogout.writeBytes("[D_address]");
					oflogout.writeBytes(mail_file);
					oflogout.writeBytes(":");
					oflogout.writeBytes(Temp_line);
                			oflogout.writeBytes("\n");
					}
				}
				else write_flag=1;

				if(Y_flag==1) if(year.trim().compareTo(want_year)>=0)
				write_flag=0;
				else{
				write_flag=1;
				if(log_file.equals(""))
				System.out.println("[D_year]"+mail_file+":"+Temp_line);
				else{
					oflogout.writeBytes("[D_address]");
					oflogout.writeBytes(mail_file);
					oflogout.writeBytes(":");
					oflogout.writeBytes(Temp_line);
                			oflogout.writeBytes("\n");
					}
				}

				if(b_flag==1){ 
					if(add_size<=want_size) write_flag=1;
						else{
						write_flag=0;
						oflogout.writeBytes("[D_size]");
						oflogout.writeBytes(mail_file);
						oflogout.writeBytes(":");
						oflogout.writeBytes(Temp_line);
                				oflogout.writeBytes("\n");
						}
				}


		}catch(StringIndexOutOfBoundsException e)
			{
			if(log_file.equals(""))
		        System.out.println("Some illigal word in this mailbox:"+mail_file);
				else{
					oflogout.writeBytes("[D_address]");
					oflogout.writeBytes(mail_file);
					oflogout.writeBytes(":");
					oflogout.writeBytes(Temp_line);
                			oflogout.writeBytes("\n");
					}
			}
			//DO ALL TARGET MAIL LINE....
			}
		}
		if(write_flag==1)
		{
		ofout.write(buf);
		ofout.writeBytes("\n");
		}else{
		}
	}
oflogout.flush();
oflogout.close();
ofout.flush();
ofout.close();
mail.close();
FileOutputStream fout2= new FileOutputStream(mail_file);
ObjectOutputStream ofout2=new ObjectOutputStream(fout2);
fout2.flush();
FileReader mail2= new FileReader("temp.txt");
BufferedReader mail_buff2= new BufferedReader(mail2);
	while((Temp_line=mail_buff2.readLine())!=null){
	byte writeout_s[]=Temp_line.getBytes();
	ofout2.write(writeout_s);
	ofout2.writeBytes("\n");
	}
	fout2.flush();
	fout2.close();
	mail2.close();
//us++;
}
try{
Runtime f=Runtime.getRuntime();
Process j=null;
	j=f.exec("rm ./temp.txt ");
	j.waitFor();
	}catch(Exception e){
	System.out.println("[Error] error to delete temp.txt!");
	}

//}
 }
}
}

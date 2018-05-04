import java.io.*;
import java.util.*;
import java.net.*;

class HttpPort{
	public static void main(String args[]) throws Exception{
		String temp_data;
		Socket my_socket=new Socket("mrtg.cc.nsysu.edu.tw", 80);
		int top_rank;
		if(args.length>0)
			top_rank=Integer.parseInt(args[0]);
		else top_rank=100;
		Calendar calendar=Calendar.getInstance();
		top_rank=(top_rank==0)?100:top_rank;
		String form_data="year="+calendar.get(Calendar.YEAR)+"&month="+(calendar.get(Calendar.MONTH)+1)+"&day="+calendar.get(Calendar.DATE)+"&rank="+top_rank+"&query=¬d¸ß\r\n";
		System.out.println(form_data);
		DataOutputStream send_data=new DataOutputStream(my_socket.getOutputStream());
		DataInputStream read_data=new DataInputStream(my_socket.getInputStream());
		send_data.writeBytes("POST /top100/test2_1.php HTTP/1.0\r\n");
		send_data.writeBytes("Content-type: application/x-www-form-urlencoded\r\n");
		send_data.writeBytes("Content-length: "+form_data.length()+"\r\n\r\n");
		send_data.writeBytes(form_data);
		while((temp_data=read_data.readLine())!= null)
			System.out.println(temp_data);
		my_socket.close();
	}
}

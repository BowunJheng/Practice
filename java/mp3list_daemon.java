import java.net.*;
import java.io.*;
import java.util.*;


class Mp3_deamon{
static String OPENFILE=new String("~/www/icecast/nobody/default.txt");
static int PORT=4558;
	public static void main(String args[]) throws Exception{
		String showline=new String("");
		ServerSocket listenin;
		Socket oneconnect;
		Date starttime=new Date();
		FileInputStream openfile;
		try{
			openfile=new FileInputStream(OPENFILE);
			BufferedReader content=new BufferedReader(new InputStreamReader(openfile));
			try{
				String read_line;
				while((read_line=content.readLine())!=null){
					showline+=read_line+"\n";
				}
			}catch(Exception e){
				System.err.println(e);
				System.exit(1);
			}
		}catch(Exception e){
		}
		try{
			listenin=new ServerSocket(PORT);
			System.out.println(starttime+": Server Listen !! (port:"+PORT+")");
			while(true){
				Date nowtime=new Date();
				oneconnect=listenin.accept();
				PrintStream listsend=new PrintStream(oneconnect.getOutputStream());
				System.out.println("The Client "+oneconnect.getInetAddress()+" Connect at "+nowtime+" .");
				listsend.println(showline);
				oneconnect.close();
			}
		}catch(IOException e){
			System.out.println("hihi");
		}
	}
}

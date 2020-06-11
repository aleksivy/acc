import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;

import com.calyon.crypto.cmsencryption.CMSEncryption;


public class Trigger {
	private static final Logger logger = Logger.getLogger("Trigger");
	
	public static void main(String[] args) {
		try{
			PropertyConfigurator.configure("log4j.properties");
			logger.info("Trigger;begin");		
			processing(args[0],args[1]);
			logger.info("Trigger;end");
		}catch(Exception e){
			logger.error("Trigger;exception;"+e+";cause;"+e.getCause(),e);
		}
	}
	static public void processing(String filename, String pathWriteTo) throws IOException {
		FileReader in = null;
		BufferedReader br = null;
		
		in = new FileReader(new File("parameters.properties"));
		br = new BufferedReader(in);
		String row = null;
		ArrayList al = new ArrayList();
		while ((row = br.readLine()) != null) {
			if (row.length() == 0 || row.startsWith("#"))
				continue;
			al.add(row.trim());
		}
		br.close();
		String para[] = new String[al.size() + 4];
		int i = 0;
		for (; i < al.size(); i++) {
			para[i] = al.get(i).toString();
		}
		para[i++] = "-i";
		para[i++] = filename;
		para[i++] = "-o";
		para[i++] = pathWriteTo;			
		CreateSMime.main(para);

	}

}

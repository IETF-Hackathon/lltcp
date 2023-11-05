import java.io.*;
import java.net.*;

/*
 * simple DNS client for creating Long Lasting TCP sessions
 * tested on Java 1.7
 * created for IETF 118 hackathon LLTCP
 * https://github.com/IETF-Hackathon/lltcp-dns
 *
 * example : java -classpath . LLCDnsClient "199.9.14.201" 5 5
 */
public class LLCDnsClient {

  /* args :
   *   dns server IP or name
   *   number of requests to perform on the same TCP connection
   *   sleep time between requests (in seconds)
   */
  public static void main(String[] args)    {

    if(args.length != 3) {
      System.out.println("3 args required : dns server , max requests number, sleeping time");
      Runtime.getRuntime().exit(666);
    }

    String dnsServer = args[0];
    int maxRequests = new Integer(args[1]).intValue();
    int sleepTime = new Integer(args[2]).intValue();

    /* hex dump from a simple dns query exported from any capture and put it here like this */
    byte[] request = hexStringToByteArray("0021634a01000001000000000000016309676f2d6d70756c7365036e65740000010001");

    /* send the very same DNS request multiple times until a network error (socket disconnection) */
    try {

      /* */
      Socket daSocket = new Socket("199.9.14.201", 53);
      //Socket daSocket = new Socket(dnsServer , 53);
      OutputStream outputS = new BufferedOutputStream(daSocket.getOutputStream(), 1024);
      InputStream in = daSocket.getInputStream();

      int nbRequests = 0;
      while(nbRequests<maxRequests) {

        // SEND DNS QUERY
        outputS.write( request );
        outputS.flush();

        // DON'T EVEN READ ANSWER
        /* int inBufferSize = 4096;
        byte[] buf = new byte[inBufferSize];
        int intTmp = 0;
        while( (intTmp = in.read(buf)) != -1 ) {
        }*/

        // wait for some seconds between requests
        Thread.sleep(sleepTime*1000);

        if(maxRequests != 0)
          nbRequests++;
      }
    }
    catch(UnknownHostException uhe) { }
    catch(IOException ie) { }
    catch(InterruptedException ie) { }

  } // end main

  /* Convert hexadecimal string to byte array */
  public static byte[] hexStringToByteArray(String s) {
    int len = s.length();
    byte[] data = new byte[len / 2];
    for (int i = 0; i < len; i += 2) {
        data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4)
                             + Character.digit(s.charAt(i+1), 16));
    }
    return data;
  }

}

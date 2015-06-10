import org.apache.commons.io.FileUtils;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Iterator;

/**
 * Created by Catalin on 6/7/2015.
 */
public class GhettoAmazonWebpageParser {

    public static void main(String[] args) throws IOException, SAXException, ParserConfigurationException {
//        String url = getDocument("B003AI2VGA");
//        url = getDocument("B00006HAXW");
//        url = getDocument("B000063W1R");
//        url = getDocument("B0071AD95K");
//        url = getDocument("B0078V2LCY");
//        url = getDocument("B00004CQT3");

        enhanceCSV("1998-Filtered");
        enhanceCSV("2000-Filtered");
    }

    public static void enhanceCSV(String year) throws IOException {
        final File original = new File("D:\\Backup\\Depaul\\YEAR.csv".replaceAll("YEAR", year));
        final File outfile = new File("D:\\Backup\\Depaul\\YEAR-Titles.csv".replaceAll("YEAR", year));

        final Iterator<String> lines = FileUtils.lineIterator(original);
        final ArrayList<String> lineArray = new ArrayList<>(10_000_000);

        System.setProperty("java.util.concurrent.ForkJoinPool.common.parallelism", "20");
        FileUtils.readLines(original).parallelStream().forEach(line -> {
            String inputLine = line;
            String asin = inputLine.replaceAll("\"","");
            asin = asin.substring(asin.indexOf(',') + 1, asin.length());
            System.out.println(asin);
            String outputLine = buildString(inputLine, asin);
            int x = 0;
            while (outputLine == null && x < 50) {
                if(x > 25)
                    System.out.println("Having Trouble Downloading Movie name for ... " + line);

                outputLine = buildString(inputLine, asin);
                x++;
            }
            lineArray.add(outputLine);
            System.out.println(lineArray.size());
        });

        FileUtils.writeLines(outfile, lineArray);
    }

    public static String buildString(String inputLine, String asin){
        try {
            return inputLine + ",\"" + getDocument(asin) + "\"";
        } catch (IOException e) {
            return null;
        } catch (SAXException e) {
            return null;
        } catch (ParserConfigurationException e) {
            return null;
        }
    }

    public static String getDocument(String asin) throws IOException, SAXException, ParserConfigurationException {
        String urlPath = "http://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=AMAZON_ASIN_ID&rh=i%3Aaps%2Ck%3AMAZON_ASIN_ID";
        urlPath = urlPath.replaceAll("AMAZON_ASIN_ID", asin);
        URL url = new URL(urlPath);
        DataInputStream dis = new DataInputStream(new BufferedInputStream(url.openStream()));
        String s;
        while ((s = dis.readLine()) != null) {
            if(s.contains(asin) && s.contains("http://www.amazon.com/") && s.contains("#customerReviews\"")) {
                s = s.replaceAll("<a class=\"a-size-small a-link-normal a-text-normal\" href=\"","");
                s = s.substring(0,s.indexOf("#customerReviews\">"));
                System.out.println(s);
                s = s.replaceAll("http://www.amazon.com/","");
                s = s.substring(0,s.indexOf('/'));
                System.out.println(s);
                return s;
            }
        }

        return null;
    }
}

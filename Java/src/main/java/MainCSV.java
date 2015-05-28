import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;

/**
 * Created by Catalin on 5/26/2015.
 */
public class MainCSV {
    public static void main(final String[] args) throws IOException {
        final File original = new File("D:\\Backup\\Depaul\\movies.txt");
        final File outfile = new File("D:\\Backup\\Depaul\\movies.min.csv");

        final Iterator<String> lines = FileUtils.lineIterator(original);
        final ArrayList<String> lineArray = new ArrayList<>(10_000_000);

        StringBuffer buffer = new StringBuffer(400);
        buffer.append("product/productId,review/userId,review/helpfulness,review/score,review/time");
        while(lines.hasNext()) {
            String line = lines.next();
            if(!line.isEmpty() && line.trim().length() != 0){
                if (!(line.startsWith("review/summary:") || line.startsWith("review/text:") || line.startsWith("review/profileName: "))) {
                    line = line.replaceAll(",",";");
                    if(line.startsWith("product/productId: ")) {
                        lineArray.add(buffer.toString());
                        buffer = new StringBuffer(400);
                        line = line.replaceFirst("product/productId: ","");
                    }
                    line = line.replaceFirst("review/userId: ", ",");
                    line = line.replaceFirst("review/helpfulness: ", ",");
                    line = line.replaceFirst("review/score: ", ",");
                    line = line.replaceFirst("review/time: ", ",");
                    buffer.append(line);
                }
            }
        }
        FileUtils.writeLines(outfile, lineArray);
    }
}

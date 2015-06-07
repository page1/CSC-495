import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;

/**
 * Created by Catalin on 5/26/2015.
 */
public class Main {

    public static void main(final String[] args) throws IOException {
        final File original = new File("D:\\Backup\\Depaul\\movies.txt");
        final File outfile = new File("D:\\Backup\\Depaul\\movies.min.txt");

        final Iterator<String> lines = FileUtils.lineIterator(original);
        final ArrayList<String> lineArray = new ArrayList<>(10_000_000);

        lines.forEachRemaining(line -> {
            if(!(line.startsWith("review/summary:") || line.startsWith("review/text:"))){
                line = line.replaceFirst("product/productId: ", "PID: ");
                line = line.replaceFirst("review/userId: ", "UID: ");
                line = line.replaceFirst("review/profileName: ", "NAME: ");
                line = line.replaceFirst("review/helpfulness: ", "HELP: ");
                line = line.replaceFirst("review/score: ", "SCORE: ");
                line = line.replaceFirst("review/time: ", "TMS: ");
                lineArray.add(line);
            }
        });

        FileUtils.writeLines(outfile, lineArray);
    }
}

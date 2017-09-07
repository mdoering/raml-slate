package de.mdoering.raml;

import org.junit.Ignore;
import org.junit.Test;

/**
 *
 */
public class HtmlGeneratorTest {

    @Test
    public void run() throws Exception {
        HtmlGenerator.main(new String[] {"-raml", "src/test/resources/apispecs-test/apispecs.raml"} );
    }

    @Test
    @Ignore
    public void runLocal() throws Exception {
        HtmlGenerator.main(new String[] {"-raml", "/Users/markus/code/col+/colplus/docs/api/staging.raml", "-out", "/Users/markus/Desktop/nomen", "-logo", "/Users/markus/code/col+/colplus/logo/col-logo-trans.png", "-excludeType", "DatasetObject", "-excludeType", "ResultSet"} );
    }
}
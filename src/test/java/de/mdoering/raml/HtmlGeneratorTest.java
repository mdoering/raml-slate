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
        HtmlGenerator.main(new String[] {"-raml", "/Users/markus/Desktop/nomenclator.raml", "-out", "/Users/markus/Desktop/nomen", "-logo", "src/test/resources/col-logo.png", "-excludedTypes", "Versioned", "-excludedTypes", "Created", "-excludedTypes", "ResultSet"} );
    }
}
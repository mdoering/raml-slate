package de.mdoering.raml;

import org.junit.Test;

/**
 *
 */
public class HtmlGeneratorTest {

    @Test
    public void run() throws Exception {
        HtmlGenerator.main(new String[] {"-raml", "./src/test/resources/nomenclator.raml", "-logo", "src/test/resources/col-logo.png", "-excludedTypes", "Versioned", "-excludedTypes", "Created", "-excludedTypes", "ResultSet"} );
    }

}
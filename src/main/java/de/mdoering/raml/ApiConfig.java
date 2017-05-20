package de.mdoering.raml;

import com.beust.jcommander.Parameter;
import com.google.common.collect.Sets;

import java.io.File;
import java.net.URI;
import java.util.Locale;
import java.util.Set;

/**
 * API html rendering configurations
 */
public class ApiConfig {

    @Parameter(names = { "-f", "-raml" }, description = "RAML file to render")
    public File raml;

    @Parameter(names = { "-o", "-out" }, description = "Output folder for generated static files")
    public File out = new File("out");

    @Parameter(names = { "-t", "-excludedTypes" }, description = "List of global type declarations that should be ignored. Useful for exluding \"abstract\" base types")
    public Set<String> excludedTypes = Sets.newHashSet("Versioned", "Created", "ResultSet");

    @Parameter(names = { "-logo"}, description = "Logo URL")
    public URI logo = URI.create("col-logo.png");

    @Parameter(names = { "-locale" }, description = "Locale to be used for rendering")
    public Locale locale = Locale.getDefault();

    @Parameter(names = { "-css" }, description = "css style from highlightjs to render examples")
    public String highlightCss = "gruvbox-dark";


    public ApiConfig() {
    }

    public Set<String> getExcludedTypes() {
        return excludedTypes;
    }

    public boolean isTypeExcluded(String type) {
        return excludedTypes.contains(type);
    }

    public URI getLogo() {
        return logo;
    }

}

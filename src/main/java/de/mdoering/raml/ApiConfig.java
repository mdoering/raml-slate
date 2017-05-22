package de.mdoering.raml;

import com.beust.jcommander.Parameter;
import com.google.common.collect.Lists;

import java.io.File;
import java.util.List;
import java.util.Locale;

/**
 * API html rendering configurations
 */
public class ApiConfig {

    @Parameter(names = { "-f", "-raml" }, description = "RAML file to render")
    public File raml;

    @Parameter(names = { "-o", "-out" }, description = "Output folder for generated static files")
    public File out = new File("out");

    @Parameter(names = { "-t", "-excludedTypes" }, description = "List of global type declarations that should be ignored. Useful for exluding \"abstract\" base types")
    public List<String> excludedTypes = Lists.newArrayList();

    @Parameter(names = { "-logo"}, description = "Logo URL")
    public File logo;

    @Parameter(names = { "-locale" }, description = "Locale to be used for rendering")
    public Locale locale = Locale.getDefault();

    @Parameter(names = { "-css" }, description = "css style from highlightjs to render examples")
    public String highlightCss = "gruvbox-dark";

    @Parameter(names = { "-copy-raml" }, description = "if true copies the RAML source file into the output folder")
    public boolean copyRamlFile = false;

    public ApiConfig() {
    }

    public List<String> getExcludedTypes() {
        return excludedTypes;
    }

    public boolean isTypeExcluded(String type) {
        return excludedTypes.contains(type);
    }

    public String getLogoFileName() {
        return logo == null ? null : logo.getName();
    }

    public String getRamlFilename() {
        return raml.getName();
    }
}

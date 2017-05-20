package de.mdoering.raml;

import com.beust.jcommander.JCommander;
import com.google.common.collect.ImmutableList;
import de.mdoering.raml.freemarker.RamlObjectWrapper;
import freemarker.cache.ClassTemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.nio.charset.StandardCharsets;

/**
 * Main class to generate html from a RAML file using commandline args
 */
public class HtmlGenerator {
    private static final Logger LOG = LoggerFactory.getLogger(HtmlGenerator.class);
    private static final String CHARSET = "UTF-8";
    private static final ImmutableList<String> assets = ImmutableList.of(
            "screen.css",
            "screen.css.map",
            "print.css",
            "print.css.map",
            "slate.ttf",
            "slate.woff",
            "slate.woff2",
            "navbar.png",
            "col-logo.png",
            "slate.js",
            "highlight.pack.js"
    );
    private final Configuration freemarker = new Configuration(Configuration.getVersion());
    private ApiConfig cfg;

    public HtmlGenerator(ApiConfig cfg) {
        this.cfg = cfg;
    }

    public void run() throws Exception {
        // verify output folder
        if (cfg.out.exists()) {
            if (!cfg.out.isDirectory()) {
                throw new IllegalArgumentException("Given output folder "+cfg.out.getAbsoluteFile()+" is not a directory.");
            }
        } else {
            if (!cfg.out.mkdirs()) {
                throw new IllegalArgumentException("Failed to create output folder "+cfg.out.getAbsoluteFile());
            }
        }
        // setup freemarker
        freemarker.setObjectWrapper(new RamlObjectWrapper());
        freemarker.loadBuiltInEncodingMap();
        freemarker.setDefaultEncoding(StandardCharsets.UTF_8.name());
        freemarker.setTemplateLoader(new ClassTemplateLoader(HtmlGenerator.class, "/templates"));
        freemarker.setNumberFormat("0.##");

        // render html from RAML
        render();

        // copy assets
        exportAssets();
    }

    private void render() throws IOException, RamlValidationException, TemplateException {
        final String ramlName = FilenameUtils.removeExtension(cfg.raml.getName());

        ApiView view = ApiView.create(cfg);
        final Template template = freemarker.getTemplate("api.ftl", cfg.locale, CHARSET);

        File html = new File(cfg.out, ramlName+".html");
        try (Writer out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(html), CHARSET))){
            template.process(view, out);
        }

        // copy RAML file
        FileUtils.copyFile(cfg.raml, new File(cfg.out, ramlName+".raml"));
    }

    private void exportAssets() throws Exception {
        // copy highlightCss
        for (String ass : assets) {
            exportAsset(ass, ass);
        }
        // copy highlight asset
        exportAsset("highlight/" + cfg.highlightCss+".css", "highlight.css");

    }

    /**
     * Export a resource embedded into a Jar file to the local file path.
     *
     * @param asset ie.: "/SmartLibrary.dll"
     * @return The path to the exported resource
     * @throws Exception
     */
    private void exportAsset(String asset, String finalName) throws Exception {
        File af = new File(cfg.out, finalName);
        if (!af.getParentFile().exists()) {
            af.getParentFile().mkdirs();
        }
        try (OutputStream out = new FileOutputStream(af);
             InputStream in = HtmlGenerator.class.getResourceAsStream("/assets/"+asset)
        ){
            if (in == null) {
                throw new Exception("Cannot get asset \"" + asset + "\" from Jar file.");
            }
            LOG.debug("Exporting asset {}", af.getAbsoluteFile());
            IOUtils.copy(in, out);
        }
    }

    public static void main(String[] args) throws Exception {
        ApiConfig cfg = new ApiConfig();
        JCommander command = new JCommander(cfg);
        command.parse(args);
        HtmlGenerator generator = new HtmlGenerator(cfg);
        generator.run();
    }
}

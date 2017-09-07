package de.mdoering.raml.freemarker;

import com.vladsch.flexmark.ast.Node;
import com.vladsch.flexmark.ext.abbreviation.AbbreviationExtension;
import com.vladsch.flexmark.ext.autolink.AutolinkExtension;
import com.vladsch.flexmark.ext.definition.DefinitionExtension;
import com.vladsch.flexmark.ext.footnotes.FootnoteExtension;
import com.vladsch.flexmark.ext.gfm.strikethrough.StrikethroughExtension;
import com.vladsch.flexmark.ext.tables.TablesExtension;
import com.vladsch.flexmark.ext.typographic.TypographicExtension;
import com.vladsch.flexmark.html.HtmlRenderer;
import com.vladsch.flexmark.parser.Parser;
import com.vladsch.flexmark.parser.ParserEmulationProfile;
import com.vladsch.flexmark.util.options.MutableDataSet;
import org.apache.commons.lang3.StringUtils;

import java.util.Arrays;

/**
 *
 */
public class MarkdownRenderer {
    private final Parser parser;
    private final HtmlRenderer renderer;

    public MarkdownRenderer() {
        MutableDataSet options = new MutableDataSet();
        options.setFrom(ParserEmulationProfile.GITHUB_DOC);
        options.set(Parser.EXTENSIONS, Arrays.asList(
                AbbreviationExtension.create(),
                DefinitionExtension.create(),
                FootnoteExtension.create(),
                TablesExtension.create(),
                TypographicExtension.create(),
                AutolinkExtension.create(),
                StrikethroughExtension.create()
        ));
        // uncomment to convert soft-breaks to hard breaks
        //options.set(HtmlRenderer.SOFT_BREAK, "<br />\n");
        parser = Parser.builder(options).build();
        renderer = HtmlRenderer.builder(options).build();
    }

    public void render(String markdown, Appendable out) {
        Node document = parser.parse(markdown);
        renderer.render(document, out);
    }

    public String render(String markdown) {
      if (!StringUtils.isBlank(markdown)) {
        Node document = parser.parse(markdown);
        return renderer.render(document);
      }
      return "";
    }
}

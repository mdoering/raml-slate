package de.mdoering.raml.freemarker;

import freemarker.template.TemplateModelException;
import freemarker.template.TemplateScalarModel;
import org.raml.v2.api.model.v10.system.types.MarkdownString;

/**
 *
 */
public class MarkdownTemplateModel implements TemplateScalarModel {
    private static final MarkdownRenderer RENDERER = new MarkdownRenderer();
    private String markdown;

    public MarkdownTemplateModel(MarkdownString md) {
        this.markdown=md==null? null : md.value();
    }

    @Override
    public String getAsString() throws TemplateModelException {
        return RENDERER.render(markdown);
    }
}


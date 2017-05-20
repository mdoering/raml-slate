package de.mdoering.raml.freemarker;

import freemarker.template.TemplateModelException;
import freemarker.template.TemplateScalarModel;
import org.raml.v2.api.model.v10.system.types.FullUriTemplateString;

/**
 *
 */
public class BaseUriTypeTemplateModel implements TemplateScalarModel {
    private final String uri;

    public BaseUriTypeTemplateModel(FullUriTemplateString obj) {
        this.uri = obj == null ? null : obj.value().replaceAll("/$", "");
    }

    @Override
    public String getAsString() throws TemplateModelException {
        return uri;
    }
}

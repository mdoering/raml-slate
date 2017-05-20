package de.mdoering.raml.freemarker;

import freemarker.template.TemplateModelException;
import freemarker.template.TemplateScalarModel;
import org.raml.v2.api.model.v10.system.types.StringType;

/**
 *
 */
public class StringTypeTemplateModel implements TemplateScalarModel {
    private StringType obj;

    public StringTypeTemplateModel(StringType obj) {
        this.obj=obj;
    }

    @Override
    public String getAsString() throws TemplateModelException {
        return obj == null ? null : obj.value();
    }
}

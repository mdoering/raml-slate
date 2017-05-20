package de.mdoering.raml.freemarker;

import freemarker.template.TemplateModelException;
import freemarker.template.TemplateScalarModel;
import org.raml.v2.api.model.v10.system.types.AnnotableStringType;

/**
 *
 */
public class AnnotableStringTemplateModel implements TemplateScalarModel {
    private AnnotableStringType obj;

    public AnnotableStringTemplateModel(AnnotableStringType obj) {
        this.obj=obj;
    }

    @Override
    public String getAsString() throws TemplateModelException {
        return obj == null ? null : obj.value();
    }
}

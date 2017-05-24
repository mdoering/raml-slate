package de.mdoering.raml;

import com.google.common.collect.Maps;
import org.raml.v2.api.RamlModelBuilder;
import org.raml.v2.api.RamlModelResult;
import org.raml.v2.api.loader.FileResourceLoader;
import org.raml.v2.api.model.v10.api.Api;
import org.raml.v2.api.model.v10.datamodel.TypeDeclaration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.core.Response.Status;
import java.io.FileNotFoundException;
import java.net.URI;
import java.util.Map;

public class ApiView {
    private static final Logger LOG = LoggerFactory.getLogger(ApiView.class);
    private final Api model;
    private final Map<String, TypeDeclaration> types = Maps.newHashMap();
    private final ApiConfig cfg;
    private final URI baseUri;

    public static ApiView create(ApiConfig cfg) throws RamlValidationException, FileNotFoundException {
        if (!cfg.raml.exists()) {
            throw new FileNotFoundException(cfg.raml.getAbsolutePath());
        }
        LOG.info("Render RAML file {}", cfg.raml.getAbsoluteFile());
        RamlModelResult result = new RamlModelBuilder(new FileResourceLoader(".")).buildApi(cfg.raml);

        if (result.hasErrors())
            throw new RamlValidationException("RAML specification is invalid.", result.getValidationResults());

        return new ApiView(result.getApiV10(), cfg);
    };

    private ApiView(Api model, ApiConfig configuration) {
        this.cfg = configuration;
        this.model = model;
        for (TypeDeclaration t : model.types()) {
            types.put(t.name(), t);
        }
        baseUri = URI.create(model.baseUri().value());
    }

    public ApiConfig getCfg() {
        return cfg;
    }

    public Api getModel() {
        return model;
    }

    public URI getBaseUri() {
        return baseUri;
    }

    public boolean hasType(String name) {
        return types.containsKey(name);
    }

    public TypeDeclaration getType(String name) {
        return types.get(name);
    }

    public String headerCode(String code) {
        Status status = Status.fromStatusCode(Integer.parseInt(code.trim()));
        return String.format("%03d %s",status.getStatusCode(), status.getReasonPhrase());
    }
}

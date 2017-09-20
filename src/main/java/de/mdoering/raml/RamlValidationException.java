package de.mdoering.raml;

import org.raml.v2.api.model.common.ValidationResult;

import java.util.List;
import java.util.stream.Collectors;

public class RamlValidationException extends Exception {
  private final List<ValidationResult> errors;

  public RamlValidationException(List<ValidationResult> errors) {
    super(errors.stream()
        .map(e -> "Path: " + e.getPath() + "\n" + e.getMessage())
        .collect(Collectors.joining("\n\n"))
    );
    this.errors = errors;
  }

  public List<ValidationResult> getErrors() {
    return errors;
  }
}

/// **Librería:** `validations` · **Funcionalidad:** código estable de una regla de negocio (por
/// ejemplo `VALUE_BLANK`). Quien llama decide por el código y la interfaz traduce por código,
/// nunca por el texto del mensaje.
class RuleCode {
  /// Crea un código a partir de su texto.
  const RuleCode(this.value);

  /// Texto del código.
  final String value;

  @override
  bool operator ==(Object other) => other is RuleCode && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

/// **Librería:** `validations` · **Funcionalidad:** único error de negocio. Equivale a
/// `BusinessRuleException` de la librería Java, con el agregado de `code` (reaccionar sin leer
/// el texto) y `details` (datos de contexto como pares clave-valor).
class BusinessRuleException implements Exception {
  /// Crea la excepción.
  const BusinessRuleException(this.code, this.message, [this.details = const []]);

  /// Código estable de la regla violada.
  final RuleCode code;

  /// Mensaje legible para desarrolladores (no para el usuario final).
  final String message;

  /// Datos de contexto de la violación.
  final List<(String, String)> details;

  /// Devuelve una copia con un detalle más.
  BusinessRuleException withDetail(String key, String value) =>
      BusinessRuleException(code, message, [...details, (key, value)]);

  /// Busca un detalle por clave; `null` si no existe.
  String? detail(String key) {
    for (final entry in details) {
      if (entry.$1 == key) return entry.$2;
    }
    return null;
  }

  @override
  String toString() => '[${code.value}] $message';
}

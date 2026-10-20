import 'business_logic_validation.dart';
import 'business_rule_exception.dart';

/// **Librería:** `validations` · **Funcionalidad:** exige que un texto no esté vacío ni tenga
/// solo espacios en blanco.
class NotBlankValidation implements BusinessLogicValidation<String> {
  /// Crea la validación.
  const NotBlankValidation({required this.order, required this.code});

  /// Orden de ejecución.
  final int order;

  /// Código con el que falla.
  final RuleCode code;

  @override
  int get executionOrder => order;

  @override
  void validate(String toValidate) {
    if (toValidate.trim().isEmpty) {
      throw BusinessRuleException(code, 'el valor no puede estar vacío');
    }
  }
}

/// **Librería:** `validations` · **Funcionalidad:** exige que la cantidad de caracteres de un
/// texto esté entre `min` y `max` (inclusive); cuenta caracteres Unicode, no unidades UTF-16.
class LengthBetweenValidation implements BusinessLogicValidation<String> {
  /// Crea la validación.
  const LengthBetweenValidation({required this.order, required this.min, required this.max, required this.code});

  /// Orden de ejecución.
  final int order;

  /// Mínimo de caracteres.
  final int min;

  /// Máximo de caracteres.
  final int max;

  /// Código con el que falla (por ejemplo `VALUE_TOO_LONG`).
  final RuleCode code;

  @override
  int get executionOrder => order;

  @override
  void validate(String toValidate) {
    final length = toValidate.runes.length;
    if (length < min || length > max) {
      throw BusinessRuleException(code, 'longitud $length fuera de [$min, $max]').withDetail('length', '$length');
    }
  }
}

/// **Librería:** `validations` · **Funcionalidad:** exige que un valor ordenable esté entre `min`
/// y `max` (inclusive). La cota es `Comparable<Object?>` y no `Comparable<T>` porque `int`
/// implementa `Comparable<num>` y no `Comparable<int>`.
class RangeValidation<T extends Comparable<Object?>> implements BusinessLogicValidation<T> {
  /// Crea la validación.
  const RangeValidation({required this.order, required this.min, required this.max, required this.code});

  /// Orden de ejecución.
  final int order;

  /// Cota inferior.
  final T min;

  /// Cota superior.
  final T max;

  /// Código con el que falla (por ejemplo `VALUE_OUT_OF_RANGE`).
  final RuleCode code;

  @override
  int get executionOrder => order;

  @override
  void validate(T toValidate) {
    if (toValidate.compareTo(min) < 0 || toValidate.compareTo(max) > 0) {
      throw BusinessRuleException(code, '$toValidate fuera de [$min, $max]');
    }
  }
}

/// **Librería:** `validations` · **Funcionalidad:** validación definida por un predicado: falla con
/// `code` y `message` cuando el predicado devuelve `false`.
class PredicateValidation<T> implements BusinessLogicValidation<T> {
  /// Crea la validación.
  const PredicateValidation({required this.order, required this.code, required this.message, required this.predicate});

  /// Orden de ejecución.
  final int order;

  /// Código con el que falla.
  final RuleCode code;

  /// Mensaje del error.
  final String message;

  /// Predicado: `true` si el objeto cumple la regla.
  final bool Function(T value) predicate;

  @override
  int get executionOrder => order;

  @override
  void validate(T toValidate) {
    if (!predicate(toValidate)) {
      throw BusinessRuleException(code, message);
    }
  }
}

import 'business_logic_validation.dart';
import 'business_rule_exception.dart';

/// **Librería:** `validations` · **Funcionalidad:** misma interfaz que [BusinessLogicValidation]
/// pero con `validate` asíncrono, para reglas que necesitan leer un puerto (existencia,
/// autorización). Equivale a `AsyncBusinessLogicValidation` de `validations-rs`.
abstract interface class AsyncBusinessLogicValidation<T> {
  /// Orden de ejecución: de menor a mayor.
  int get executionOrder;

  /// Valida el objeto; lanza [BusinessRuleException] si la regla se viola.
  Future<void> validate(T toValidate);
}

/// **Librería:** `validations` · **Funcionalidad:** ejecuta validaciones asíncronas en orden
/// ascendente y corta en la primera que falla (misma semántica que [startValidations]).
Future<void> startValidationsAsync<T>(List<AsyncBusinessLogicValidation<T>> validations, T toValidate) async {
  for (final validation in orderedByExecution(validations, (v) => v.executionOrder)) {
    await validation.validate(toValidate);
  }
}

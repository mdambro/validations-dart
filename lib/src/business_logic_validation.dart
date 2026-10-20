import 'business_rule_exception.dart';

/// **Librería:** `validations` · **Funcionalidad:** una regla de negocio sobre un objeto `T`.
/// Equivale a `BusinessLogicValidation<T>` de Java. Una validación, una regla, un código; sin
/// estado, sin I/O y sin modificar el objeto validado. `validate` lanza [BusinessRuleException].
abstract interface class BusinessLogicValidation<T> {
  /// Orden de ejecución: de menor a mayor.
  int get executionOrder;

  /// Valida el objeto; lanza [BusinessRuleException] si la regla se viola.
  void validate(T toValidate);
}

/// Ordena por `executionOrder` conservando el orden de la lista en los empates (estable).
List<V> orderedByExecution<V>(List<V> items, int Function(V item) orderOf) {
  // `List.sort` no es estable: el índice original desempata.
  final indexed = [for (var i = 0; i < items.length; i++) (i, items[i])];
  indexed.sort((a, b) {
    final byOrder = orderOf(a.$2).compareTo(orderOf(b.$2));
    return byOrder != 0 ? byOrder : a.$1.compareTo(b.$1);
  });
  return [for (final entry in indexed) entry.$2];
}

/// **Librería:** `validations` · **Funcionalidad:** ejecuta una lista de validaciones en orden
/// ascendente de `executionOrder` (empate: orden de la lista) y corta en la primera que falla.
/// Equivale a `BusinessLogicValidationUtils.startValidations`.
void startValidations<T>(List<BusinessLogicValidation<T>> validations, T toValidate) {
  for (final validation in orderedByExecution(validations, (v) => v.executionOrder)) {
    validation.validate(toValidate);
  }
}

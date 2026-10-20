/// Port a Dart de la librería Java `mdambro/validations`: una interfaz genérica de validación
/// con orden de ejecución, un ejecutor que las corre en orden cortando en el primer error y un
/// único error de negocio con código estable.
library;

export 'src/async_business_logic_validation.dart';
export 'src/business_logic_validation.dart';
export 'src/business_rule_exception.dart';
export 'src/generic_validations.dart';

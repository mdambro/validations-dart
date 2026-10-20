# validations-dart

Port a Dart de [`mdambro/validations`](https://github.com/mdambro/validations) (Java): validaciones de
negocio genéricas y ordenadas.

- `BusinessLogicValidation<T>` (síncrona) y `AsyncBusinessLogicValidation<T>`: una regla
  (`executionOrder` + `validate`).
- `startValidations` / `startValidationsAsync`: corren la lista en orden ascendente (empate: orden
  de la lista) y cortan en la primera falla.
- `BusinessRuleException`: único error de negocio, con `RuleCode` estable y `details`.
- Validaciones genéricas: `NotBlankValidation`, `LengthBetweenValidation`, `RangeValidation`,
  `PredicateValidation`.

Hermano en Rust: [`validations-rs`](https://github.com/mdambro/validations-rs) (mismos nombres y
semántica). Sin dependencias de runtime.

import 'package:test/test.dart';
import 'package:validations/validations.dart';

/// Validación de prueba que registra su paso y falla si [fail] es verdadero.
class Probe implements BusinessLogicValidation<void> {
  Probe(this.executionOrder, this.name, this.log, {this.fail = false});

  @override
  final int executionOrder;
  final String name;
  final bool fail;
  final List<String> log;

  @override
  void validate(void toValidate) {
    log.add(name);
    if (fail) throw BusinessRuleException(RuleCode(name), 'falla');
  }
}

class AsyncProbe implements AsyncBusinessLogicValidation<void> {
  AsyncProbe(this.executionOrder, this.name, this.log, {this.fail = false});

  @override
  final int executionOrder;
  final String name;
  final bool fail;
  final List<String> log;

  @override
  Future<void> validate(void toValidate) async {
    await Future<void>.delayed(Duration.zero);
    log.add(name);
    if (fail) throw BusinessRuleException(RuleCode(name), 'falla');
  }
}

void main() {
  test('corre en orden ascendente con empates estables', () {
    final log = <String>[];
    startValidations<void>([Probe(20, 'a', log), Probe(10, 'b', log), Probe(10, 'c', log)], null);
    expect(log, ['b', 'c', 'a']);
  });

  test('corta en la primera falla', () {
    final log = <String>[];
    expect(
      () => startValidations<void>(
        [Probe(30, 'c', log, fail: true), Probe(20, 'b', log, fail: true), Probe(10, 'a', log)],
        null,
      ),
      throwsA(isA<BusinessRuleException>().having((e) => e.code, 'code', const RuleCode('b'))),
    );
    expect(log, ['a', 'b']);
  });

  test('lista vacía pasa', () async {
    startValidations<void>([], null);
    await startValidationsAsync<void>([], null);
  });

  test('la variante asíncrona ordena y corta igual', () async {
    final log = <String>[];
    final run = startValidationsAsync<void>(
      [AsyncProbe(30, 'c', log, fail: true), AsyncProbe(20, 'b', log, fail: true), AsyncProbe(10, 'a', log)],
      null,
    );
    await expectLater(run, throwsA(isA<BusinessRuleException>().having((e) => e.code, 'code', const RuleCode('b'))));
    expect(log, ['a', 'b']);
  });

  test('validaciones genéricas', () {
    const blank = NotBlankValidation(order: 1, code: RuleCode('BLANK'));
    blank.validate('x');
    expect(() => blank.validate('   '), throwsA(isA<BusinessRuleException>()));

    const length = LengthBetweenValidation(order: 1, min: 2, max: 3, code: RuleCode('LEN'));
    length.validate('ab');
    length.validate('ñé'); // cuenta caracteres
    expect(() => length.validate('a'), throwsA(isA<BusinessRuleException>()));
    expect(() => length.validate('abcd'), throwsA(isA<BusinessRuleException>()));

    const range = RangeValidation<int>(order: 1, min: 0, max: 10, code: RuleCode('RNG'));
    range.validate(10);
    expect(() => range.validate(11), throwsA(isA<BusinessRuleException>()));

    final even = PredicateValidation<int>(order: 1, code: const RuleCode('EVEN'), message: 'par', predicate: (n) => n.isEven);
    even.validate(4);
    expect(() => even.validate(3), throwsA(isA<BusinessRuleException>().having((e) => e.code.value, 'code', 'EVEN')));
  });

  test('detalles del error', () {
    final e = const BusinessRuleException(RuleCode('X'), 'm').withDetail('k', 'v');
    expect(e.detail('k'), 'v');
    expect(e.detail('z'), isNull);
    expect(e.toString(), '[X] m');
  });
}

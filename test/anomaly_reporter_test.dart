import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:poljud/utils/anomaly_reporter.dart';

class MockAdd extends Mock {
  Future<void> call(Map<String, dynamic> data);
}

void main() {
  setUpAll(() {
    registerFallbackValue<Map<String, dynamic>>(<String, dynamic>{});
  });
  test('sendReport retourne true lorsque l\'envoi réussit', () async {
    final mockAdd = MockAdd();
    when(() => mockAdd(any<Map<String, dynamic>>()))
        .thenAnswer((_) async {});

    final result = await AnomalyReporter.sendReport('1', 'msg', add: mockAdd);

    expect(result, isTrue);
    verify(() => mockAdd(any<Map<String, dynamic>>())).called(1);
  });

  test('sendReport lève une exception lorsque l\'envoi échoue', () async {
    final mockAdd = MockAdd();
    when(() => mockAdd(any<Map<String, dynamic>>()))
        .thenThrow(Exception('fail'));

    expect(
      () => AnomalyReporter.sendReport('1', 'msg', add: mockAdd),
      throwsA(isA<Exception>()),
    );
    verify(() => mockAdd(any<Map<String, dynamic>>())).called(1);
  });
}

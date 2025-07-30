import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:droitpenalspecial/utils/quiz_progress_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    // ensure SharedPreferences instance is reloaded
    await SharedPreferences.getInstance();
  });

  test('enregistrement de reponses et recuperation des stats', () async {
    await QuizProgressManager.recordQuestion('cadre1', true);
    await QuizProgressManager.recordQuestion('cadre1', false);
    await QuizProgressManager.recordQuestion('cadre2', true);

    final stats = await QuizProgressManager.getStats();
    final cadre1 = stats['cadre1'];
    final cadre2 = stats['cadre2'];

    expect(cadre1?.answered, 2);
    expect(cadre1?.correct, 1);
    expect(cadre2?.answered, 1);
    expect(cadre2?.correct, 1);
  });

  test('increment du compteur global de quiz', () async {
    expect(await QuizProgressManager.getQuizCount(), 0);

    await QuizProgressManager.incrementQuizCount();
    await QuizProgressManager.incrementQuizCount();

    expect(await QuizProgressManager.getQuizCount(), 2);
  });
}

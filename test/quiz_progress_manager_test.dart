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
    await QuizProgressManager.recordQuestion('cadre1', true,
        quiz: QuizType.pp);
    await QuizProgressManager.recordQuestion('cadre1', false,
        quiz: QuizType.pp);
    await QuizProgressManager.recordQuestion('theme1', true,
        quiz: QuizType.dps);

    final stats = await QuizProgressManager.getStats();
    final cadre1 = stats[QuizType.pp]?['cadre1'];
    final theme1 = stats[QuizType.dps]?['theme1'];

    expect(cadre1?.answered, 2);
    expect(cadre1?.correct, 1);
    expect(theme1?.answered, 1);
    expect(theme1?.correct, 1);
  });

  test('increment du compteur global de quiz', () async {
    expect(await QuizProgressManager.getQuizCount(), 0);

    await QuizProgressManager.incrementQuizCount();
    await QuizProgressManager.incrementQuizCount();

    expect(await QuizProgressManager.getQuizCount(), 2);
  });
}

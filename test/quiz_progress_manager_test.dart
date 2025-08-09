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
    await QuizProgressManager.recordQuestion('PP', 'cadre1', true);
    await QuizProgressManager.recordQuestion('PP', 'cadre1', false);
    await QuizProgressManager.recordQuestion('DPS', 'theme1', true);

    final stats = await QuizProgressManager.getStats();
    final cadre1 = stats['PP']?['cadre1'];
    final theme1 = stats['DPS']?['theme1'];

    expect(cadre1?.answered, 2);
    expect(cadre1?.correct, 1);
    expect(theme1?.answered, 1);
    expect(theme1?.correct, 1);
  });

  test('increment du compteur de quiz par type', () async {
    expect(await QuizProgressManager.getQuizCount(), 0);

    await QuizProgressManager.incrementQuizCount('PP');
    await QuizProgressManager.incrementQuizCount('PP');
    await QuizProgressManager.incrementQuizCount('DPS');

    expect(await QuizProgressManager.getQuizCount(quizType: 'PP'), 2);
    expect(await QuizProgressManager.getQuizCount(quizType: 'DPS'), 1);
    expect(await QuizProgressManager.getQuizCount(), 3);
  });
}

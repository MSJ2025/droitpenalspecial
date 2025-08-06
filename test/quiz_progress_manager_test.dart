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
    await QuizProgressManager.recordQuestion('question1', true);
    await QuizProgressManager.recordQuestion('question1', false);
    await QuizProgressManager.recordQuestion('question2', true);

    final stats = await QuizProgressManager.getStats();
    final q1 = stats['question1'];
    final q2 = stats['question2'];

    expect(q1?.answered, 2);
    expect(q1?.correct, 1);
    expect(q2?.answered, 1);
    expect(q2?.correct, 1);
  });

  test('increment du compteur global de quiz', () async {
    expect(await QuizProgressManager.getQuizCount(), 0);

    await QuizProgressManager.incrementQuizCount();
    await QuizProgressManager.incrementQuizCount();

    expect(await QuizProgressManager.getQuizCount(), 2);
  });
}

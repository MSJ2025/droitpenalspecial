import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:droitpenalspecial/models/exercice_infraction.dart';
import 'package:droitpenalspecial/screens/recherche/recherche_infraction_quiz_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('affiche un champ vide au démarrage', (tester) async {
    final caseData = ExerciceInfraction(
      titre: '',
      contextualisation: '',
      histoireDetaillee: '',
      infractionsCiblees: const [],
      correction: const [],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: RechercheInfractionQuizScreen(caseData: caseData),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.controller?.text ?? '', isEmpty);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poljud/widgets/report_dialog.dart';

void main() {
  testWidgets('affiche un SnackBar en cas d\'échec d\'envoi', (tester) async {
    Future<void> failingAdd(Map<String, dynamic> _) async {
      throw Exception('fail');
    }

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => ReportDialog(ficheId: '1', add: failingAdd),
              );
            },
            child: const Text('open'),
          );
        },
      ),
    ));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'hello');
    await tester.tap(find.text('Envoyer'));
    await tester.pump();
    // SnackBar appears
    expect(find.byType(SnackBar), findsOneWidget);
    // Dialog is still present
    expect(find.byType(AlertDialog), findsOneWidget);
  });
}

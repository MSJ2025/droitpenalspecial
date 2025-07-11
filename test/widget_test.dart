// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:poljud/main.dart';

void main() {
  testWidgets("Affichage du titre de l'application", (WidgetTester tester) async {
    // Construction de l'application et déclenchement d'une frame.
    await tester.pumpWidget(const OPJFichesApp());

    // Vérifie que le titre de l'écran d'accueil est présent.
    expect(find.text('Fiches OPJ'), findsOneWidget);
  });
}

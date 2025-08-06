import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:droitpenalspecial/screens/cadre_enquete_list_screen.dart';
import 'package:droitpenalspecial/utils/ad_event_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('onCadreOpened est appelé à chaque navigation', (tester) async {
    AdEventManager.reset();
    await tester.pumpWidget(const MaterialApp(home: CadreEnqueteListScreen()));

    final item = find.text('Cadre 1');
    expect(item, findsOneWidget);

    await tester.tap(item);
    await tester.pumpAndSettle();
    expect(AdEventManager.eventCount, 1);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(item);
    await tester.pumpAndSettle();
    expect(AdEventManager.eventCount, 2);
  });
}

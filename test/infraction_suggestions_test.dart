import 'package:flutter_test/flutter_test.dart';
import 'package:droitpenalspecial/utils/infraction_suggestions.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('chargement des suggestions complètes', () async {
    final suggestions = await loadInfractionSuggestions();
    expect(suggestions, contains('Vol'));
    expect(suggestions, contains('Abus de confiance'));
    expect(suggestions.isNotEmpty, true);
  });
}

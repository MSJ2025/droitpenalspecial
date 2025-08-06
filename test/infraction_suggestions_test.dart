import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:droitpenalspecial/utils/infraction_suggestions.dart';
import 'package:droitpenalspecial/utils/json_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('chargement des suggestions complètes', () async {
    final suggestions = await loadInfractionSuggestions();
    expect(suggestions, contains('Vol'));
    expect(suggestions, contains('Abus de confiance'));
    expect(suggestions.isNotEmpty, true);
  });

  test('couvre toutes les infractions attendues dans les exercices', () async {
    final suggestions = await loadInfractionSuggestions();
    final data =
        await loadJsonWithComments('assets/data/exercice_infractions.json');
    final List<dynamic> raw = json.decode(data) as List<dynamic>;
    final expected = <String>{};

    for (final item in raw) {
      final infractions = (item as Map)['infractions_ciblees'] as List? ?? [];
      for (final inf in infractions) {
        final intitule = (inf as Map)['intitule'];
        if (intitule is String && intitule.trim().isNotEmpty) {
          expected.add(intitule);
        }
      }
    }

    for (final intitule in expected) {
      expect(suggestions, contains(intitule));
    }
  });
}

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:droitpenalspecial/models/exercice_infraction.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('chargement des cas depuis exercice_infractions.json', () async {
    final data = await rootBundle.loadString('assets/data/exercice_infractions.json');
    final List<dynamic> list = json.decode(data) as List<dynamic>;
    final exercices = list
        .map((e) => ExerciceInfraction.fromJson(e as Map<String, dynamic>))
        .toList();

    expect(exercices, isNotEmpty);
    for (final ex in exercices) {
      expect(ex.contextualisation, isNotEmpty);
      expect(ex.histoireDetaillee, isNotEmpty);
      expect(ex.infractionsCiblees, isNotEmpty);
    }
  });
}

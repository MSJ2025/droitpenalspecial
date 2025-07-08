import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:droitpenalspecial/models/infraction.dart';
import 'package:droitpenalspecial/utils/json_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('chargement de fiches.json et instanciation', () async {
    final jsonStr = await loadJsonWithComments('assets/data/fiches.json');
    final List<dynamic> data = jsonDecode(jsonStr);

    expect(() => data.map(FamilleInfractions.fromJson).toList(), returnsNormally);
  });

  test('presence des nouveaux champs', () async {
    final jsonStr = await loadJsonWithComments('assets/data/fiches.json');
    final List<dynamic> data = jsonDecode(jsonStr);
    final familles = data.map(FamilleInfractions.fromJson).toList();
    final infractions = familles.expand((f) => f.infractions);

    expect(infractions.any((i) => i.responsabilitePersonnesMorales != null), isTrue);
    expect(infractions.any((i) => i.territorialite != null), isTrue);
    expect(infractions.any((i) => i.causesExemptionDiminutionPeine != null), isTrue);
  });
}

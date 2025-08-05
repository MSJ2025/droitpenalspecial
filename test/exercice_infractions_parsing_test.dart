import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:droitpenalspecial/models/exercice_infraction.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('chargement des cas depuis exercice_infractions.json', () async {
    final data = await rootBundle.loadString('assets/data/exercice_infractions.json');
    final List<dynamic> list = json.decode(data) as List<dynamic>;
    expect(() => list.map((e) => ExerciceInfraction.fromJson(e)).toList(), returnsNormally);
  });
}


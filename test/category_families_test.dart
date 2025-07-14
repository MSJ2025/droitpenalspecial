import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:droitpenalspecial/models/category.dart';
import 'package:droitpenalspecial/utils/json_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('chaque famille du fichier fiches.json est dans categoryFamilies', () async {
    final jsonStr = await loadJsonWithComments('assets/data/fiches.json');
    final List<dynamic> fiches = json.decode(jsonStr) as List<dynamic>;
    final Set<String> familiesFromFile =
        fiches.map((e) => e['famille'] as String).toSet();

    final Set<String> familiesFromCategories =
        categoryFamilies.values.expand((e) => e).toSet();

    expect(familiesFromCategories.containsAll(familiesFromFile), isTrue,
        reason: 'Des familles sont manquantes dans categoryFamilies');
  });
}

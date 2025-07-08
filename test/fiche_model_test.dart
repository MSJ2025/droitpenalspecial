import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:droitpenalspecial/models/fiche.dart';

String loadJsonWithComments(String path) {
  final content = File(path).readAsStringSync();
  final noSingleLine = content.replaceAll(RegExp(r'//.*'), '');
  final noComments =
      noSingleLine.replaceAll(RegExp(r'/\*(.|[\r\n])*?\*/', multiLine: true), '');
  return noComments;
}

void main() {
  test('Fiche.fromJson accepte les cles manquantes', () {
    final jsonStr = loadJsonWithComments('test/fiche_missing_keys.jsonc');
    final Map<String, dynamic> data = jsonDecode(jsonStr);

    expect(() => Fiche.fromJson(data), returnsNormally);
    final fiche = Fiche.fromJson(data);
    expect(fiche.id, 'test1');
    expect(fiche.titre, 'Titre de test');
    expect(fiche.theme, 'Theme');
  });
}

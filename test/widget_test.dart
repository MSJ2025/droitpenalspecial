import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Charge un fichier JSON en ignorant les commentaires de type // ou /* */.
String loadJsonWithComments(String path) {
  final content = File(path).readAsStringSync();
  final noSingleLine = content.replaceAll(RegExp(r'//.*'), '');
  final noComments =
      noSingleLine.replaceAll(RegExp(r'/\*(.|[\r\n])*?\*/', multiLine: true), '');
  return noComments;
}

/// Modèle simple d'infraction pour les besoins du test.
class Infraction {
  final String type;
  final String? definition;

  Infraction({required this.type, this.definition});

  factory Infraction.fromJson(Map<String, dynamic> json) {
    return Infraction(
      type: json['type'] ?? '',
      definition: json['definition'],
    );
  }
}

void main() {
  test('loadJsonWithComments renvoie un JSON valide', () {
    final jsonStr = loadJsonWithComments('test/infractions.jsonc');
    expect(() => jsonDecode(jsonStr), returnsNormally);
  });

  test('Chaque infraction est correctement instanciée même avec des cles manquantes', () {
    final jsonStr = loadJsonWithComments('test/infractions.jsonc');
    final List<dynamic> data = jsonDecode(jsonStr);

    expect(() => data.map((e) => Infraction.fromJson(e)).toList(), returnsNormally);

    final infractions = data.map((e) => Infraction.fromJson(e)).toList();
    expect(infractions.length, 3);
    expect(infractions[0].type, 'Vol');
    expect(infractions[0].definition, "Prendre la chose d'autrui");
    expect(infractions[1].type, 'Escroquerie');
    expect(infractions[1].definition, isNull);
    expect(infractions[2].type, 'Harcèlement');
  });
}

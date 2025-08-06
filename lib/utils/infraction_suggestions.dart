import 'dart:convert';
import 'json_loader.dart';

/// Charge et renvoie la liste des intitulés d'infractions disponibles dans
/// l'application.
///
/// Les suggestions sont extraites des fichiers `fiches.json` et
/// `exercice_infractions.json` afin de couvrir intégralement les infractions
/// présentes dans les histoires.
Future<List<String>> loadInfractionSuggestions() async {
  final set = <String>{};

  // Suggestions provenant de fiches.json
  final fichesData = await loadJsonWithComments('assets/data/fiches.json');
  final List<dynamic> fichesRaw = json.decode(fichesData) as List<dynamic>;
  for (final inf in fichesRaw
      .map((fam) => (fam as Map)['infractions'] as List? ?? [])
      .expand((list) => list)) {
    final type = (inf as Map)['type'];
    if (type is String && type.trim().isNotEmpty) {
      set.add(type.trim());
    }
  }

  // Suggestions provenant des scénarios d'exercice d'infractions
  final exerciceData =
      await loadJsonWithComments('assets/data/exercice_infractions.json');
  final List<dynamic> exerciceRaw = json.decode(exerciceData) as List<dynamic>;
  for (final value in exerciceRaw.expand((item) {
    final map = item as Map;
    final corrections = map['correction'] as List? ?? [];
    final infractions = map['infractions_ciblees'] as List? ?? [];
    final quals = corrections
        .map((corr) => (corr as Map)['qualification'])
        .whereType<String>();
    final intitules = infractions
        .map((inf) => (inf as Map)['intitule'])
        .whereType<String>();
    return [...quals, ...intitules];
  })) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty) {
      set.add(trimmed);
    }
  }

  final list = set.toList()..sort();
  return list;
}


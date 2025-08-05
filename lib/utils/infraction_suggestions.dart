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
  for (final fam in fichesRaw) {
    final infractions = fam['infractions'] as List? ?? [];
    for (final inf in infractions) {
      final type = (inf as Map)['type'];
      if (type is String && type.trim().isNotEmpty) {
        set.add(type);
      }
    }
  }

  // Suggestions provenant des scénarios d'exercice d'infractions
  final exerciceData =
      await loadJsonWithComments('assets/data/exercice_infractions.json');
  final List<dynamic> exerciceRaw = json.decode(exerciceData) as List<dynamic>;
  for (final item in exerciceRaw) {
    final infractions = (item as Map)['infractions_ciblees'] as List? ?? [];
    for (final inf in infractions) {
      final intitule = (inf as Map)['intitule'];
      if (intitule is String && intitule.trim().isNotEmpty) {
        set.add(intitule);
      }
    }
  }

  final list = set.toList()..sort();
  return list;
}

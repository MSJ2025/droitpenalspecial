import 'dart:convert';
import 'package:flutter/services.dart';
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

  // Suggestions provenant des scénarios de recherche d'infractions
  final rechercheData =
      await loadJsonWithComments('assets/data/exercice_infractions.json');
  final List<dynamic> rechercheRaw = json.decode(rechercheData) as List<dynamic>;
  for (final item in rechercheRaw) {
    final corrections = (item as Map)['correction'] as List? ?? [];
    for (final corr in corrections) {
      final inf = (corr as Map)['infraction'] as Map? ?? {};
      final qual = inf['qualification'];
      if (qual is String && qual.trim().isNotEmpty) {
        set.add(qual);
      }
    }
  }

  final list = set.toList()..sort();
  return list;
}

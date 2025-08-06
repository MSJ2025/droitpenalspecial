import 'dart:convert';
import 'package:flutter/services.dart';
import 'json_loader.dart';

/// Charge et renvoie la liste des intitulés d'infractions disponibles dans
/// l'application.
///
/// Les suggestions sont extraites des fichiers `fiches.json`,
/// `recherche_infractions.json` et `exercice_infractions.json` afin de couvrir
/// intégralement les infractions présentes dans les histoires et les
/// exercices.
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
      await loadJsonWithComments('assets/data/recherche_infractions.json');
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

  // Suggestions provenant des exercices d'infractions
  final exercicesData =
      await loadJsonWithComments('assets/data/exercice_infractions.json');
  final List<dynamic> exercicesRaw =
      json.decode(exercicesData) as List<dynamic>;
  for (final item in exercicesRaw) {
    final ciblees = (item as Map)['infractions_ciblees'] as List? ?? [];
    for (final ciblee in ciblees) {
      final intitule = (ciblee as Map)['intitule'];
      if (intitule is String && intitule.trim().isNotEmpty) {
        set.add(intitule);
      }
    }
  }

  final list = set.toList()..sort();
  return list;
}

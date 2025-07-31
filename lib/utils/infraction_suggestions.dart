import 'dart:convert';
import 'package:flutter/services.dart';
import 'json_loader.dart';

/// Charge et renvoie la liste des intitulés d'infractions disponibles dans fiches.json.
Future<List<String>> loadInfractionSuggestions() async {
  final data = await loadJsonWithComments('assets/data/fiches.json');
  final List<dynamic> raw = json.decode(data) as List<dynamic>;
  final set = <String>{};
  for (final fam in raw) {
    final infractions = fam['infractions'] as List? ?? [];
    for (final inf in infractions) {
      final type = (inf as Map)['type'];
      if (type is String && type.trim().isNotEmpty) {
        set.add(type);
      }
    }
  }
  final list = set.toList()..sort();
  return list;
}

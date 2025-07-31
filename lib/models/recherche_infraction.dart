class RechercheInfraction {
  final String titre;
  final String histoire;
  final List<String> infractions;

  RechercheInfraction({
    required this.titre,
    required this.histoire,
    required this.infractions,
  });

  factory RechercheInfraction.fromJson(Map<String, dynamic> json) {
    final corrections = json['correction'] as List? ?? [];
    final infractions = corrections
        .map((e) => ((e as Map)['infraction'] as Map)['qualification'] as String?)
        .whereType<String>()
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    return RechercheInfraction(
      titre: json['titre'] ?? '',
      histoire: json['histoire'] ?? '',
      infractions: infractions,
    );
  }
}

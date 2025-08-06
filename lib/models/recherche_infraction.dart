class RechercheInfraction {
  final String titre;
  final String histoire;
  final List<String> intitulesAttendus;

  RechercheInfraction({
    required this.titre,
    required this.histoire,
    required this.intitulesAttendus,
  });

  factory RechercheInfraction.fromJson(Map<String, dynamic> json) {
    // Priorité aux intitulés ciblés si présents.
    final ciblees = (json['infractions_ciblees'] as List? ?? [])
        .map((e) => (e as Map)['intitule'] as String?)
        .whereType<String>()
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    List<String> attendus = ciblees;
    if (attendus.isEmpty) {
      // Compatibilité avec l'ancien format basé sur `correction`.
      final corrections = json['correction'] as List? ?? [];
      attendus = corrections
          .map((e) =>
              ((e as Map)['infraction'] as Map)['qualification'] as String?)
          .whereType<String>()
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }

    return RechercheInfraction(
      titre: json['titre'] ?? '',
      histoire: json['histoire'] ?? json['histoire_detaillee'] ?? '',
      intitulesAttendus: attendus,
    );
  }
}

class ExerciceInfraction {
  final String titre;
  final String contextualisation;
  final String histoireDetaillee;
  final List<String> infractionsCiblees;
  final List<Map<String, dynamic>> correction;

  ExerciceInfraction({
    required this.titre,
    required this.contextualisation,
    required this.histoireDetaillee,
    required this.infractionsCiblees,
    required this.correction,
  });

  factory ExerciceInfraction.fromJson(Map<String, dynamic> json) {
    final infractions = (json['infractions_ciblees'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .map((e) => (e['intitule'] ?? '').toString().trim())
            .where((s) => s.isNotEmpty)
            .toList() ??
        <String>[];
    final corrections = (json['correction'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .toList() ??
        <Map<String, dynamic>>[];
    return ExerciceInfraction(
      titre: json['titre'] ?? '',
      contextualisation: json['contextualisation'] ?? '',
      histoireDetaillee: json['histoire_detaillee'] ?? '',
      infractionsCiblees: infractions,
      correction: corrections,
    );
  }
}

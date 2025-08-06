class ExerciceInfraction {
  final String titre;
  final String contextualisation;
  final String histoireDetaillee;
  final List<InfractionCiblee> infractionsCiblees;

  ExerciceInfraction({
    required this.titre,
    required this.contextualisation,
    required this.histoireDetaillee,
    required this.infractionsCiblees,
  });

  factory ExerciceInfraction.fromJson(Map<String, dynamic> json) {
    return ExerciceInfraction(
      titre: json['titre'] ?? '',
      contextualisation: json['contextualisation'] ?? '',
      histoireDetaillee: json['histoire_detaillee'] ?? '',
      infractionsCiblees: (json['infractions_ciblees'] as List? ?? [])
          .map((e) => InfractionCiblee.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class InfractionCiblee {
  final String? intitule;
  final String? articles;

  InfractionCiblee({this.intitule, this.articles});

  factory InfractionCiblee.fromJson(Map<String, dynamic> json) {
    return InfractionCiblee(
      intitule: json['intitule'] as String?,
      articles: json['articles'] as String?,
    );
  }
}

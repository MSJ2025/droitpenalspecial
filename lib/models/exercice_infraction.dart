class ExerciceInfraction {
  final String titre;
  final String contextualisation;
  final String histoireDetaillee;
  final List<InfractionCiblee> infractionsCiblees;
  final List<CorrectionInfraction> correction;

  ExerciceInfraction({
    required this.titre,
    required this.contextualisation,
    required this.histoireDetaillee,
    required this.infractionsCiblees,
    required this.correction,
  });

  factory ExerciceInfraction.fromJson(Map<String, dynamic> json) {
    return ExerciceInfraction(
      titre: json['titre'] ?? '',
      contextualisation: json['contextualisation'] ?? '',
      histoireDetaillee: json['histoire_detaillee'] ?? '',
      infractionsCiblees: (json['infractions_ciblees'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => InfractionCiblee.fromJson(e))
          .toList(),
      correction: (json['correction'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => CorrectionInfraction.fromJson(e))
          .toList(),
    );
  }
}

class InfractionCiblee {
  final String intitule;
  final String articles;

  InfractionCiblee({required this.intitule, required this.articles});

  factory InfractionCiblee.fromJson(Map<String, dynamic> json) {
    return InfractionCiblee(
      intitule: json['intitule'] ?? '',
      articles: json['articles'] ?? '',
    );
  }
}

class CorrectionInfraction {
  final int infractionNumero;
  final String personneConcernee;
  final String qualification;
  final String articles;
  final ElementsConstitutifs elementsConstitutifs;
  final ElementsDePreuve elementsDePreuve;
  final int? points;

  CorrectionInfraction({
    required this.infractionNumero,
    required this.personneConcernee,
    required this.qualification,
    required this.articles,
    required this.elementsConstitutifs,
    required this.elementsDePreuve,
    this.points,
  });

  factory CorrectionInfraction.fromJson(Map<String, dynamic> json) {
    return CorrectionInfraction(
      infractionNumero: json['infraction_numero'] ?? 0,
      personneConcernee: json['personne_concernee'] ?? '',
      qualification: json['qualification'] ?? '',
      articles: json['articles'] ?? '',
      elementsConstitutifs: ElementsConstitutifs.fromJson(
          json['elements_constitutifs'] as Map<String, dynamic>? ?? {}),
      elementsDePreuve: ElementsDePreuve.fromJson(
          json['elements_de_preuve'] as Map<String, dynamic>? ?? {}),
      points: json['points'] as int?,
    );
  }
}

class ElementsConstitutifs {
  final String elementLegal;
  final List<String> elementMateriel;
  final String elementMoral;

  ElementsConstitutifs({
    required this.elementLegal,
    required this.elementMateriel,
    required this.elementMoral,
  });

  factory ElementsConstitutifs.fromJson(Map<String, dynamic> json) {
    return ElementsConstitutifs(
      elementLegal: json['element_legal'] ?? '',
      elementMateriel:
          (json['element_materiel'] as List? ?? []).whereType<String>().toList(),
      elementMoral: json['element_moral'] ?? '',
    );
  }
}

class ElementsDePreuve {
  final List<String> materielles;
  final List<String> medicales;
  final List<String> morales;

  ElementsDePreuve({
    required this.materielles,
    required this.medicales,
    required this.morales,
  });

  factory ElementsDePreuve.fromJson(Map<String, dynamic> json) {
    return ElementsDePreuve(
      materielles:
          (json['materielles'] as List? ?? []).whereType<String>().toList(),
      medicales:
          (json['medicales'] as List? ?? []).whereType<String>().toList(),
      morales: (json['morales'] as List? ?? []).whereType<String>().toList(),
    );
  }
}

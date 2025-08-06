class InfractionCorrection {
  final int infractionNumero;
  final String personneConcernee;
  final String qualification;
  final String articles;
  final List<String> elementMateriel;
  final String elementMoral;
  final List<String> preuvesMaterielles;
  final List<String> preuvesMedicales;
  final List<String> preuvesMorales;

  InfractionCorrection({
    required this.infractionNumero,
    required this.personneConcernee,
    required this.qualification,
    required this.articles,
    required this.elementMateriel,
    required this.elementMoral,
    required this.preuvesMaterielles,
    required this.preuvesMedicales,
    required this.preuvesMorales,
  });

  factory InfractionCorrection.fromJson(Map<String, dynamic> json) {
    final infraction = (json['infraction'] as Map?) ?? {};
    final elementsConst = (json['elements_constitutifs'] as Map?) ?? {};
    final elementsPreuve = (json['elements_de_preuve'] as Map?) ?? {};
    return InfractionCorrection(
      infractionNumero: json['infraction_numero'] as int? ?? 0,
      personneConcernee: json['personne_concernee'] as String? ?? '',
      qualification: infraction['qualification'] as String? ?? '',
      articles: elementsConst['element_legal'] as String? ?? '',
      elementMateriel: (elementsConst['element_materiel'] as List? ?? [])
          .whereType<String>()
          .toList(),
      elementMoral: elementsConst['element_moral'] as String? ?? '',
      preuvesMaterielles: (elementsPreuve['materielles'] as List? ?? [])
          .whereType<String>()
          .toList(),
      preuvesMedicales: (elementsPreuve['medicales'] as List? ?? [])
          .whereType<String>()
          .toList(),
      preuvesMorales: (elementsPreuve['morales'] as List? ?? [])
          .whereType<String>()
          .toList(),
    );
  }
}

class RechercheInfraction {
  final String titre;
  final String histoire;
  final List<String> infractions;
  final List<InfractionCorrection> corrections;

  RechercheInfraction({
    required this.titre,
    required this.histoire,
    required this.infractions,
    required this.corrections,
  });

  factory RechercheInfraction.fromJson(Map<String, dynamic> json) {
    final corrections = (json['correction'] as List? ?? [])
        .map((e) => InfractionCorrection.fromJson(e as Map<String, dynamic>))
        .toList();
    final infractions = corrections
        .map((e) => e.qualification)
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    return RechercheInfraction(
      titre: json['titre'] ?? '',
      histoire: json['histoire'] ?? '',
      infractions: infractions,
      corrections: corrections,
    );
  }
}

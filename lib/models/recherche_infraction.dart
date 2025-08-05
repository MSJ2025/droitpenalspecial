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
    final rawCorrections = json['correction'] as List? ?? [];
    final corrections = rawCorrections
        .whereType<Map<String, dynamic>>()
        .map(InfractionCorrection.fromJson)
        .toList();
    final infractions = corrections.map((c) => c.qualification).toList();
    return RechercheInfraction(
      titre: json['titre'] ?? '',
      histoire: json['histoire'] ?? '',
      infractions: infractions,
      corrections: corrections,
    );
  }
}

class InfractionCorrection {
  final String qualification;
  final String elementLegal;
  final List<String> elementMateriel;
  final String elementMoral;
  final List<String> preuvesMaterielles;
  final List<String> preuvesMedicales;
  final List<String> preuvesMorales;

  InfractionCorrection({
    required this.qualification,
    required this.elementLegal,
    required this.elementMateriel,
    required this.elementMoral,
    required this.preuvesMaterielles,
    required this.preuvesMedicales,
    required this.preuvesMorales,
  });

  factory InfractionCorrection.fromJson(Map<String, dynamic> json) {
    final inf = json['infraction'] as Map? ?? {};
    final elems = json['elements_constitutifs'] as Map? ?? {};
    final preuves = json['elements_de_preuve'] as Map? ?? {};
    return InfractionCorrection(
      qualification: (inf['qualification'] ?? '').toString(),
      elementLegal: (elems['element_legal'] ?? '').toString(),
      elementMateriel: (elems['element_materiel'] as List? ?? [])
          .whereType<String>()
          .toList(),
      elementMoral: (elems['element_moral'] ?? '').toString(),
      preuvesMaterielles: (preuves['materielles'] as List? ?? [])
          .whereType<String>()
          .toList(),
      preuvesMedicales: (preuves['medicales'] as List? ?? [])
          .whereType<String>()
          .toList(),
      preuvesMorales: (preuves['morales'] as List? ?? [])
          .whereType<String>()
          .toList(),
    );
  }
}

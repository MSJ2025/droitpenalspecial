// lib/models/fiche.dart



class ArticleRef {
  final String texte;
  final String lien;

  ArticleRef({required this.texte, required this.lien});

  factory ArticleRef.fromJson(Map<String, dynamic> json) => ArticleRef(
    texte: json['texte'],
    lien: json['lien'],
  );
}

class ElementsConstitutifs {
  final ArticleRef elementLegal;
  final ElementDetail elementMateriel;
  final ElementDetail elementMoral;

  ElementsConstitutifs({
    required this.elementLegal,
    required this.elementMateriel,
    required this.elementMoral,
  });

  factory ElementsConstitutifs.fromJson(Map<String, dynamic> json) => ElementsConstitutifs(
    elementLegal: ArticleRef.fromJson(json['element_legal']),
    elementMateriel: ElementDetail.fromJson(json['element_materiel']),
    elementMoral: ElementDetail.fromJson(json['element_moral']),
  );
}

class ElementDetail {
  final String texte;
  final List<String>? exemples;
  final String? remarque;

  ElementDetail({required this.texte, this.exemples, this.remarque});

  factory ElementDetail.fromJson(Map<String, dynamic> json) => ElementDetail(
    texte: json['texte'],
    exemples: json['exemples'] != null ? List<String>.from(json['exemples']) : null,
    remarque: json['remarque'],
  );
}

class CirconstanceAggravante {
  final String libelle;
  final ArticleRef article;
  final String peine;

  CirconstanceAggravante({
    required this.libelle,
    required this.article,
    required this.peine,
  });

  factory CirconstanceAggravante.fromJson(Map<String, dynamic> json) => CirconstanceAggravante(
    libelle: json['libelle'],
    article: ArticleRef.fromJson(json['article']),
    peine: json['peine'],
  );
}

class Tentative {
  final String regime;
  final String peine;

  Tentative({required this.regime, required this.peine});

  factory Tentative.fromJson(Map<String, dynamic> json) => Tentative(
    regime: json['regime'],
    peine: json['peine'],
  );
}

class Prescription {
  final String actionPublique;
  final String peine;

  Prescription({required this.actionPublique, required this.peine});

  factory Prescription.fromJson(Map<String, dynamic> json) => Prescription(
    actionPublique: json['action_publique'],
    peine: json['peine'],
  );
}

class JurisprudenceRef {
  final String reference;
  final String resume;
  final String? lien;

  JurisprudenceRef({required this.reference, required this.resume, this.lien});

  factory JurisprudenceRef.fromJson(Map<String, dynamic> json) => JurisprudenceRef(
    reference: json['reference'],
    resume: json['resume'],
    lien: json['lien'],
  );
}

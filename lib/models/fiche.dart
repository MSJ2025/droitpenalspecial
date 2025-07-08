// lib/models/fiche.dart

class Fiche {
  final String id;
  final String theme;
  final String titre;
  final String nature;
  final ArticleRef article;
  final ArticleRef prevuPar;
  final ArticleRef reprimePar;
  final String definition;
  final String qualificationLegale;
  final ElementsConstitutifs elementsConstitutifs;
  final String victime;
  final String auteursEtComplices;
  final String modeDePoursuite;
  final String regimeProcedure;
  final String peinePrincipale;
  final List<String> peinesComplementaires;
  final List<CirconstanceAggravante> circonstancesAggravantes;
  final Tentative tentative;
  final Prescription prescription;
  final List<JurisprudenceRef> jurisprudence;
  final List<String> pointsDeVigilance;
  final List<String> exemplesCasPratiques;
  final String notes;
  final List<String> tags;
  final String derniereMaj;

  Fiche({
    required this.id,
    required this.theme,
    required this.titre,
    required this.nature,
    required this.article,
    required this.prevuPar,
    required this.reprimePar,
    required this.definition,
    required this.qualificationLegale,
    required this.elementsConstitutifs,
    required this.victime,
    required this.auteursEtComplices,
    required this.modeDePoursuite,
    required this.regimeProcedure,
    required this.peinePrincipale,
    required this.peinesComplementaires,
    required this.circonstancesAggravantes,
    required this.tentative,
    required this.prescription,
    required this.jurisprudence,
    required this.pointsDeVigilance,
    required this.exemplesCasPratiques,
    required this.notes,
    required this.tags,
    required this.derniereMaj,
  });

  factory Fiche.fromJson(Map<String, dynamic> json) => Fiche(
        id: json['id'] ?? '',
        theme: json['theme'] ?? '',
        titre: json['titre'] ?? '',
        nature: json['nature'] ?? '',
        article: json['article'] != null
            ? ArticleRef.fromJson(json['article'])
            : ArticleRef(texte: '', lien: ''),
        prevuPar: json['prevu_par'] != null
            ? ArticleRef.fromJson(json['prevu_par'])
            : ArticleRef(texte: '', lien: ''),
        reprimePar: json['reprime_par'] != null
            ? ArticleRef.fromJson(json['reprime_par'])
            : ArticleRef(texte: '', lien: ''),
        definition: json['definition'] ?? '',
        qualificationLegale: json['qualification_legale'] ?? '',
        elementsConstitutifs: json['elements_constitutifs'] != null
            ? ElementsConstitutifs.fromJson(json['elements_constitutifs'])
            : ElementsConstitutifs(
                elementLegal: ArticleRef(texte: '', lien: ''),
                elementMateriel: ElementDetail(texte: ''),
                elementMoral: ElementDetail(texte: ''),
              ),
        victime: json['victime'] ?? '',
        auteursEtComplices: json['auteurs_et_complices'] ?? '',
        modeDePoursuite: json['mode_de_poursuite'] ?? '',
        regimeProcedure: json['regime_procedure'] ?? '',
        peinePrincipale: json['peine_principale'] ?? '',
        peinesComplementaires:
            List<String>.from(json['peines_complementaires'] ?? []),
        circonstancesAggravantes: (json['circonstances_aggravantes'] as List?)
                ?.map((x) => CirconstanceAggravante.fromJson(x))
                .toList() ??
            [],
        tentative: json['tentative'] != null
            ? Tentative.fromJson(json['tentative'])
            : Tentative(regime: '', peine: ''),
        prescription: json['prescription'] != null
            ? Prescription.fromJson(json['prescription'])
            : Prescription(actionPublique: '', peine: ''),
        jurisprudence: (json['jurisprudence'] as List?)
                ?.map((x) => JurisprudenceRef.fromJson(x))
                .toList() ??
            [],
        pointsDeVigilance:
            List<String>.from(json['points_de_vigilance'] ?? []),
        exemplesCasPratiques:
            List<String>.from(json['exemples_cas_pratiques'] ?? []),
        notes: json['notes'] ?? '',
        tags: List<String>.from(json['tags'] ?? []),
        derniereMaj: json['derniere_maj'] ?? '',
      );
}

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

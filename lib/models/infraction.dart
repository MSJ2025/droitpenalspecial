// lib/models/infraction.dart

import 'fiche.dart';

class InfractionArticle {
  final String? numero;
  final String? lien;

  InfractionArticle({this.numero, this.lien});

  factory InfractionArticle.fromJson(Map<String, dynamic> json) => InfractionArticle(
        numero: json['numero'],
        lien: json['lien'],
      );
}

class ElementsConstitutifsInfraction {
  final String? elementLegal;
  final String? elementMateriel;
  final String? elementMoral;

  ElementsConstitutifsInfraction({this.elementLegal, this.elementMateriel, this.elementMoral});

  factory ElementsConstitutifsInfraction.fromJson(Map<String, dynamic> json) => ElementsConstitutifsInfraction(
        elementLegal: json['element_legal'],
        elementMateriel: json['element_materiel'],
        elementMoral: json['element_moral'],
      );
}

class Penalites {
  final String? qualification;
  final List<String>? peines;

  Penalites({this.qualification, this.peines});

  factory Penalites.fromJson(Map<String, dynamic> json) => Penalites(
        qualification: json['qualification'],
        peines: (json['peines'] as List?)?.map((e) => e as String).toList(),
      );
}

class TentativeInfraction {
  final bool? punissable;
  final String? precision;
  final InfractionArticle? article;

  TentativeInfraction({this.punissable, this.precision, this.article});

  factory TentativeInfraction.fromJson(Map<String, dynamic> json) => TentativeInfraction(
        punissable: json['punissable'],
        precision: json['precision'],
        article: json['article'] != null ? InfractionArticle.fromJson(json['article']) : null,
      );
}

class CirconstanceAggravanteInfraction {
  final String? intitule;
  final List<InfractionArticle>? articles;
  final String? description;
  final String? peine;

  CirconstanceAggravanteInfraction({this.intitule, this.articles, this.description, this.peine});

  factory CirconstanceAggravanteInfraction.fromJson(Map<String, dynamic> json) => CirconstanceAggravanteInfraction(
        intitule: json['intitule'],
        articles: (json['articles'] as List?)?.map((e) => InfractionArticle.fromJson(e)).toList(),
        description: json['description'],
        peine: json['peine'],
      );
}

class InfractionsParticulieres {
  final String? intitule;
  final List<InfractionArticle>? articles;
  final String? description;

  InfractionsParticulieres({this.intitule, this.articles, this.description});

  factory InfractionsParticulieres.fromJson(Map<String, dynamic> json) =>
      InfractionsParticulieres(
        intitule: json['intitule'],
        articles: (json['articles'] as List?)
            ?.map((e) => InfractionArticle.fromJson(e))
            .toList(),
        description: json['description'],
      );
}

class Infraction {
  final String id;
  final String? type;
  final String? definition;
  final List<InfractionArticle>? articles;
  final ElementsConstitutifsInfraction? elementsConstitutifs;
  final Penalites? penalites;
  final TentativeInfraction? tentative;
  final List<String>? peinesComplementaires;
  final List<CirconstanceAggravanteInfraction>? circonstancesAggravantes;
  final List<JurisprudenceRef>? jurisprudence;
  final dynamic particularites;
  final String? responsabilitePersonnesMorales;
  final String? territorialite;
  final String? causesExemptionDiminutionPeine;
  final List<InfractionsParticulieres>? infractionsParticulieres;

  Infraction({
    required this.id,
    this.type,
    this.definition,
    this.articles,
    this.elementsConstitutifs,
    this.penalites,
    this.tentative,
    this.peinesComplementaires,
    this.circonstancesAggravantes,
    this.jurisprudence,
    this.particularites,
    this.responsabilitePersonnesMorales,
    this.territorialite,
    this.causesExemptionDiminutionPeine,
    this.infractionsParticulieres,
  });

  factory Infraction.fromJson(Map<String, dynamic> json, {required String id}) => Infraction(
        id: id,
        type: json['type'],
        definition: json['definition'],
        articles: (json['articles'] as List?)?.map((e) => InfractionArticle.fromJson(e)).toList(),
        elementsConstitutifs: json['elements_constitutifs'] != null
            ? ElementsConstitutifsInfraction.fromJson(json['elements_constitutifs'])
            : null,
        penalites: json['penalites'] != null ? Penalites.fromJson(json['penalites']) : null,
        tentative: json['tentative'] != null ? TentativeInfraction.fromJson(json['tentative']) : null,
        peinesComplementaires: (json['peines_complementaires'] as List?)?.map((e) => e as String).toList(),
        circonstancesAggravantes: (json['circonstances_aggravantes'] as List?)
            ?.map((e) => CirconstanceAggravanteInfraction.fromJson(e))
            .toList(),
        jurisprudence: (json['jurisprudence'] as List?)?.map((e) => JurisprudenceRef.fromJson(e)).toList(),
        particularites: json['particularites'],
        responsabilitePersonnesMorales: json['responsabilite_personnes_morales'],
        territorialite: json['territorialite'],
        causesExemptionDiminutionPeine: json['causes_exemption_diminution_peine'],
        infractionsParticulieres: (json['infractions_particulieres'] as List?)
            ?.map((e) => InfractionsParticulieres.fromJson(e))
            .toList(),
      );
}

class FamilleInfractions {
  final String? famille;
  final List<Infraction> infractions;

  FamilleInfractions({this.famille, required this.infractions});

  factory FamilleInfractions.fromJson(Map<String, dynamic> json) {
    final famille = json['famille'] as String?;
    final list = json['infractions'] as List? ?? [];
    final infractions = <Infraction>[];
    for (var i = 0; i < list.length; i++) {
      infractions.add(
        Infraction.fromJson(list[i], id: '${famille ?? 'famille'}-$i'),
      );
    }
    return FamilleInfractions(famille: famille, infractions: infractions);
  }
}


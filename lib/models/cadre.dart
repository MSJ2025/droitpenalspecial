class CadreLegal {
  final String titre;
  final String articles;
  final List<String> commentaires;

  CadreLegal({required this.titre, required this.articles, required this.commentaires});

  factory CadreLegal.fromJson(Map<String, dynamic> json) {
    final comments = <String>[];
    for (var i = 1; i <= 6; i++) {
      final key = 'commentaire$i';
      final value = json[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        comments.add(value.toString());
      }
    }
    return CadreLegal(
      titre: json['titre'] ?? '',
      articles: json['articles'] ?? '',
      commentaires: comments,
    );
  }
}

class ActeCadre {
  final String acte;
  final String articles;
  final List<String> commentaires;

  ActeCadre({required this.acte, required this.articles, required this.commentaires});

  factory ActeCadre.fromJson(Map<String, dynamic> json) {
    final comments = <String>[];
    for (var i = 1; i <= 6; i++) {
      final key = 'commentaire$i';
      final value = json[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        comments.add(value.toString());
      }
    }
    return ActeCadre(
      acte: json['acte'] ?? '',
      articles: json['articles'] ?? '',
      commentaires: comments,
    );
  }
}

class Cadre {
  final String cadre;
  final CadreLegal cadreLegal;
  final List<ActeCadre> actes;

  Cadre({required this.cadre, required this.cadreLegal, required this.actes});

  factory Cadre.fromJson(Map<String, dynamic> json) => Cadre(
        cadre: json['cadre'] ?? '',
        cadreLegal: CadreLegal.fromJson(
            (json['cadre legal'] as Map?)?.cast<String, dynamic>() ?? {}),
        actes: (json['actes'] as List? ?? [])
            .whereType<Map>()
            .map((e) => ActeCadre.fromJson(e.cast<String, dynamic>()))
            .toList(),
      );
}

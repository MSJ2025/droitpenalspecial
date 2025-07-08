class Cadre {
  final String id;
  final String titre;
  final List<String> references;
  final String description;

  Cadre({
    required this.id,
    required this.titre,
    required this.references,
    required this.description,
  });

  factory Cadre.fromJson(Map<String, dynamic> json) => Cadre(
        id: json['id'],
        titre: json['titre'],
        references: List<String>.from(json['references']),
        description: json['description'],
      );
}

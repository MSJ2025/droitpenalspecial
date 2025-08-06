class Cadre {
  final String titre;
  final String details;

  Cadre({required this.titre, required this.details});

  factory Cadre.fromJson(Map<String, dynamic> json) {
    return Cadre(
      titre: json['titre'] as String? ?? '',
      details: json['details'] as String? ?? '',
    );
  }
}

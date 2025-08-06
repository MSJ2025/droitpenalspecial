class Cadre {
  final String title;
  final String description;

  Cadre({required this.title, required this.description});

  factory Cadre.fromJson(Map<String, dynamic> json) => Cadre(
        title: json['title'] ?? '',
        description: json['description'] ?? '',
      );
}

class Infraction {
  final String id;
  final String famille;
  final String type;
  final String definition;

  Infraction({
    required this.id,
    required this.famille,
    required this.type,
    required this.definition,
  });

  factory Infraction.fromJson(
      String famille, Map<String, dynamic> json, int index) {
    return Infraction(
      id: '${famille}_$index',
      famille: famille,
      type: json['type'] as String? ?? '',
      definition: json['definition'] as String? ?? '',
    );
  }
}

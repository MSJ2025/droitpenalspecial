import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:droitpenalspecial/models/cadre.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('chargement des cadres depuis cadres.json', () async {
    final data = await rootBundle.loadString('assets/data/cadres.json');
    final List<dynamic> list = json.decode(data) as List<dynamic>;
    expect(() => list.map((e) => Cadre.fromJson(e as Map<String, dynamic>)).toList(), returnsNormally);
  });
}

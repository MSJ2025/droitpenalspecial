import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poljud/utils/json_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('parse json with comments and comment-like strings', () async {
    final jsonStr = await loadJsonWithComments('assets/data/loader_test.json');
    final data = json.decode(jsonStr) as Map<String, dynamic>;
    expect(data['message'], "Bonjour // ceci n'est pas un commentaire");
    expect(data['description'], "Un texte avec /* des caractères */ dans la valeur");
  });
}

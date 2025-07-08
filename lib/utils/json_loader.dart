import 'package:flutter/services.dart' show rootBundle;

/// Charge un fichier JSON contenant éventuellement des commentaires.
/// Les commentaires de type `// ...` et `/* ... */` sont supprimés avant
/// de renvoyer la chaîne.
Future<String> loadJsonWithComments(String path) async {
  final data = await rootBundle.loadString(path);
  final withoutBlock = data.replaceAll(
    RegExp(r'/\*.*?\*/', dotAll: true),
    '',
  );
  final withoutLine = withoutBlock.replaceAll(
    RegExp(r'^\s*//.*\$', multiLine: true),
    '',
  );
  return withoutLine;
}

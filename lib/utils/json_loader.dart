import 'package:flutter/services.dart' show rootBundle;

/// Charge un fichier JSON contenant éventuellement des commentaires.
/// Les commentaires de type `// ...` et `/* ... */` sont supprimés avant
/// de renvoyer la chaîne.
Future<String> loadJsonWithComments(String path) async {
  final data = await rootBundle.loadString(path);
  final buffer = StringBuffer();
  var inString = false;
  var escaping = false;

  for (var i = 0; i < data.length; i++) {
    final char = data[i];

    if (inString) {
      buffer.write(char);
      if (escaping) {
        escaping = false;
      } else if (char == '\\') {
        escaping = true;
      } else if (char == '"') {
        inString = false;
      }
      continue;
    }

    if (char == '"') {
      inString = true;
      buffer.write(char);
      continue;
    }

    if (char == '/' && i + 1 < data.length) {
      final next = data[i + 1];
      // Skip line comments
      if (next == '/') {
        i += 1;
        while (i + 1 < data.length && data[i + 1] != '\n') {
          i++;
        }
        continue;
      }
      // Skip block comments
      if (next == '*') {
        i += 1;
        while (i + 1 < data.length) {
          if (data[i + 1] == '*' && i + 2 < data.length && data[i + 2] == '/') {
            i += 2;
            break;
          }
          i++;
        }
        continue;
      }
    }

    buffer.write(char);
  }

  return buffer.toString();
}

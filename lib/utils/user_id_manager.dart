import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class UserIdManager {
  static const _key = 'user_id';

  /// Retourne l'identifiant unique de l'utilisateur. Si aucun identifiant
  /// n'est encore sauvegardé, il est généré aléatoirement puis stocké dans
  /// les [SharedPreferences].
  static Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(_key);
    if (id == null) {
      id = _generateId();
      await prefs.setString(_key, id);
    }
    return id;
  }

  static String _generateId() {
    final random = Random.secure();
    return List.generate(16, (_) => random.nextInt(36).toRadixString(36)).join();
  }
}

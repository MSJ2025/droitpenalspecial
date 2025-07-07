import 'package:shared_preferences/shared_preferences.dart';

class FavoritesManager {
  static const String _key = 'favorite_fiches';

  static Future<Set<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key)?.toSet() ?? <String>{};
  }

  static Future<bool> isFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.contains(id);
  }

  static Future<void> toggleFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key)?.toSet() ?? <String>{};
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    await prefs.setStringList(_key, favorites.toList());
  }
}

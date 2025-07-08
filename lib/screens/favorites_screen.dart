import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/infraction.dart';
import '../widgets/fiche_card.dart';
import '../utils/favorites_manager.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Infraction> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final ids = await FavoritesManager.getFavorites();
    final data = await rootBundle.loadString('assets/data/fiches.json');
    final cleaned = data.replaceAll(RegExp(r'(?<!:)//.*', multiLine: true), '');
    final List<dynamic> families = json.decode(cleaned);
    final List<Infraction> all = [];
    for (final fam in families) {
      final String famille = fam['famille'];
      final List<dynamic> infs = fam['infractions'];
      for (var i = 0; i < infs.length; i++) {
        all.add(Infraction.fromJson(famille, infs[i], i));
      }
    }
    setState(() {
      favorites = all.where((f) => ids.contains(f.id)).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoris')),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : favorites.isEmpty
                ? const Center(child: Text('Aucun favori'))
                : ListView.builder(
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final fiche = favorites[index];
                      return FicheCard(
                        fiche: fiche,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text(fiche.type),
                              content: Text(fiche.definition),
                            ),
                          ).then((_) => loadFavorites());
                        },
                      );
                    },
                  ),
      ),
    );
  }
}

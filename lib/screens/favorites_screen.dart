import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils/json_loader.dart';
import '../models/fiche.dart';
import '../widgets/fiche_card.dart';
import '../utils/favorites_manager.dart';
import 'fiche_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Fiche> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final ids = await FavoritesManager.getFavorites();
    final data = await loadJsonWithComments('assets/data/fiches.json');
    final List<dynamic> ficheList = json.decode(data);
    final allFiches = ficheList.map((e) => Fiche.fromJson(e)).toList();
    setState(() {
      favorites = allFiches.where((f) => ids.contains(f.id)).toList();
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
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (_, animation, __) => FadeTransition(
                                opacity: animation,
                                child:
                                    AnimatedFicheDetailScreen(fiche: fiche),
                              ),
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

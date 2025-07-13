import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils/json_loader.dart';
import '../models/infraction.dart';
import '../widgets/infraction_card.dart';
import '../utils/favorites_manager.dart';
import 'infraction_detail_screen.dart';
import '../widgets/adaptive_appbar_title.dart';

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
    final data = await loadJsonWithComments('assets/data/fiches.json');
    final List<dynamic> rawFamilies = json.decode(data);
    final families = rawFamilies
        .map((e) => FamilleInfractions.fromJson(e as Map<String, dynamic>))
        .toList();
    final allInfractions = families.expand((f) => f.infractions).toList();
    setState(() {
      favorites = allInfractions.where((inf) => ids.contains(inf.id)).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AdaptiveAppBarTitle(
          'Favoris',
          maxLines: 1,
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : favorites.isEmpty
                ? const Center(child: Text('Aucun favori'))
                : ListView.builder(
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final infraction = favorites[index];
                      return InfractionCard(
                        infraction: infraction,
                        onTap: () {
                          Navigator.of(context)
                              .push(
                                PageRouteBuilder(
                                  pageBuilder: (_, animation, __) =>
                                      FadeTransition(
                                    opacity: animation,
                                    child: InfractionDetailScreen(
                                        infraction: infraction),
                                  ),
                                ),
                              )
                              .then((_) => loadFavorites());
                        },
                      );
                    },
                  ),
      ),
    );
  }
}

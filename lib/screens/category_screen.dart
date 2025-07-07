import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/fiche.dart';
import 'fiche_list_screen.dart';

class Category {
  final String title;
  final List<String> themes;
  const Category(this.title, this.themes);
}

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final List<Category> categories = const [
    Category('Infractions contre les personnes', [
      'Atteintes volontaires à la vie',
      'Atteintes involontaires à la vie',
      'Violences',
      'Infractions sexuelles',
    ]),
    Category('Infractions contre les biens', [
      'Vol',
      'Extorsion',
      'Escroquerie',
      'Recel',
    ]),
    Category('Infractions contre la Nation', [
      'Terrorisme',
      'Trahison',
    ]),
  ];

  late Future<Set<String>> _availableThemes;

  @override
  void initState() {
    super.initState();
    _availableThemes = _loadThemes();
  }

  Future<Set<String>> _loadThemes() async {
    final data = await rootBundle.loadString('assets/data/fiches.json');
    final List<dynamic> ficheList = json.decode(data);
    final fiches = ficheList.map((e) => Fiche.fromJson(e)).toList();
    return fiches.map((f) => f.theme).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catégories')),
      body: FutureBuilder<Set<String>>(
        future: _availableThemes,
        builder: (context, snapshot) {
          final availableThemes = snapshot.data ?? <String>{};
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final filteredThemes =
                  category.themes.where((t) => availableThemes.contains(t)).toList();
              if (filteredThemes.isEmpty) return const SizedBox();
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ExpansionTile(
                  title: Text(category.title),
                  children: [
                    for (final theme in filteredThemes)
                      ListTile(
                        title: Text(theme),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (_, animation, __) => FadeTransition(
                                opacity: animation,
                                child: FicheListScreen(filterThemes: [theme]),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

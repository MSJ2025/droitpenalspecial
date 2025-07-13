import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils/json_loader.dart';
import '../models/infraction.dart';
import '../models/theme_category.dart';
import 'fiche_list_screen.dart';
import '../widgets/adaptive_appbar_title.dart';

class CategoryScreen extends StatefulWidget {
  final ThemeCategory? category;

  const CategoryScreen({super.key, this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<FamilleInfractions>> _families;

  @override
  void initState() {
    super.initState();
    _families = _loadFamilies();
  }

  Future<List<FamilleInfractions>> _loadFamilies() async {
    debugPrint(
        'Chargement des familles à partir de assets/data/fiches.json');
    try {
      final data = await loadJsonWithComments('assets/data/fiches.json');
      debugPrint('Données chargées: '
          '${data.length > 100 ? data.substring(0, 100) + '...' : data}');
      final List<dynamic> list = json.decode(data);
      var families = list.map((e) {
        if (e is Map && e.containsKey('famille')) {
          debugPrint('Famille trouvée: ${e['famille']}');
        }
        return FamilleInfractions.fromJson(e);
      }).toList();
      if (widget.category != null) {
        final keywords = widget.category!.keywords
            .map((k) => k.toLowerCase())
            .toList();
        families = families
            .where((f) {
              final name = (f.famille ?? '').toLowerCase();
              return keywords.any((k) => name.contains(k));
            })
            .toList();
      }
      families.sort(
        (a, b) => (a.famille ?? '').toLowerCase().compareTo(
          (b.famille ?? '').toLowerCase(),
        ),
      );
      return families;
    } catch (e, stack) {
      debugPrint('Erreur lors du chargement des familles: $e');
      debugPrint(stack.toString());
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AdaptiveAppBarTitle(
          widget.category?.title ?? 'Catégories',
          maxLines: 1,
        ),
      ),
      body: FutureBuilder<List<FamilleInfractions>>(
        future: _families,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Erreur lors du chargement des familles'),
            );
          }

          final families = snapshot.data ?? <FamilleInfractions>[];
          return ListView.builder(
            itemCount: families.length,
            itemBuilder: (context, index) {
              final famille = families[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    famille.famille ?? 'Sans famille',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (_, animation, __) => FadeTransition(
                          opacity: animation,
                          child: FicheListScreen(famille: famille),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils/json_loader.dart';
import '../models/infraction.dart';
import 'fiche_list_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

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

      // Collecte et affichage de toutes les clés présentes dans le JSON
      final Set<String> keys = <String>{};
      void extractKeys(dynamic item) {
        if (item is Map) {
          item.forEach((k, v) {
            keys.add(k.toString());
            extractKeys(v);
          });
        } else if (item is List) {
          for (final v in item) {
            extractKeys(v);
          }
        }
      }

      extractKeys(list);
      final sortedKeys = keys.toList()..sort();
      debugPrint('Clés détectées (${sortedKeys.length}): $sortedKeys');

      return list.map((e) {
        if (e is Map && e.containsKey('famille')) {
          debugPrint('Famille trouvée: ${e['famille']}');
        }
        return FamilleInfractions.fromJson(e);
      }).toList();
    } catch (e, stack) {
      debugPrint('Erreur lors du chargement des familles: $e');
      debugPrint(stack.toString());
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catégories')),
      body: FutureBuilder<List<FamilleInfractions>>(
        future: _families,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Erreur lors du chargement des catégories'),
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
                  title: Text(famille.famille ?? 'Sans famille'),
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

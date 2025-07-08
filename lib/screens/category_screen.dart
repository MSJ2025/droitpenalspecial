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
    final data = await loadJsonWithComments('assets/data/fiches.json');
    final List<dynamic> list = json.decode(data);
    return list.map((e) => FamilleInfractions.fromJson(e)).toList();
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

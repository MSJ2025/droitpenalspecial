import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/infraction.dart';
import 'fiche_list_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<String>> _families;

  @override
  void initState() {
    super.initState();
    _families = _loadFamilies();
  }

  Future<List<String>> _loadFamilies() async {
    final data = await rootBundle.loadString('assets/data/fiches.json');
    final cleaned = data.replaceAll(RegExp(r'(?<!:)//.*', multiLine: true), '');
    final List<dynamic> list = json.decode(cleaned);
    return list.map<String>((e) => e['famille'] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catégories')),
      body: FutureBuilder<List<String>>( 
        future: _families,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final families = snapshot.data!;
          return ListView.builder(
            itemCount: families.length,
            itemBuilder: (context, index) {
              final family = families[index];
              return ListTile(
                title: Text(family),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (_, animation, __) => FadeTransition(
                        opacity: animation,
                        child: FicheListScreen(filterThemes: [family]),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';

import '../../models/exercice_infraction.dart';
import '../../utils/json_loader.dart';
import 'recherche_infraction_detail_screen.dart';

class RechercheInfractionListScreen extends StatefulWidget {
  const RechercheInfractionListScreen({super.key});

  @override
  State<RechercheInfractionListScreen> createState() => _RechercheInfractionListScreenState();
}

class _RechercheInfractionListScreenState
    extends State<RechercheInfractionListScreen> {
  late Future<List<ExerciceInfraction>> _cases;

  @override
  void initState() {
    super.initState();
    _cases = _loadCases();
  }


  Future<List<ExerciceInfraction>> _loadCases() async {
    final data = await loadJsonWithComments('assets/data/exercice_infractions.json');
    final List<dynamic> raw = json.decode(data) as List<dynamic>;
    return raw
        .whereType<Map<String, dynamic>>()
        .map((e) => ExerciceInfraction.fromJson(e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recherche d\'infractions')),
      body: FutureBuilder<List<ExerciceInfraction>>(
        future: _cases,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = snapshot.data ?? [];
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(item.titre),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            RechercheInfractionDetailScreen(caseData: item),
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

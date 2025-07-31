import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/recherche_infraction.dart';
import '../../utils/json_loader.dart';
import 'recherche_infraction_detail_screen.dart';

class RechercheInfractionListScreen extends StatefulWidget {
  const RechercheInfractionListScreen({super.key});

  @override
  State<RechercheInfractionListScreen> createState() => _RechercheInfractionListScreenState();
}

class _RechercheInfractionListScreenState extends State<RechercheInfractionListScreen> {
  late Future<List<RechercheInfraction>> _cases;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _cases = _loadCases();
  }

  Future<List<RechercheInfraction>> _loadCases() async {
    final data = await loadJsonWithComments('assets/data/recherche_infractions.json');
    final List<dynamic> raw = json.decode(data) as List<dynamic>;
    return raw
        .whereType<Map<String, dynamic>>()
        .map((e) => RechercheInfraction.fromJson(e))
        .toList();
  }

  TextStyle _randomStyle() {
    const fonts = [null, 'serif', 'monospace'];
    return TextStyle(
      fontFamily: fonts[_random.nextInt(fonts.length)],
      fontStyle: _random.nextBool() ? FontStyle.italic : FontStyle.normal,
      fontWeight: _random.nextBool() ? FontWeight.bold : FontWeight.normal,
      color: Colors.black87,
    );
  }

  Color _randomCardColor() {
    const colors = [
      Color(0xFFFFF3E0),
      Color(0xFFE3F2FD),
      Color(0xFFE8F5E9),
      Color(0xFFFCE4EC),
      Color(0xFFFFF8E1),
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recherche d\'infractions')),
      body: FutureBuilder<List<RechercheInfraction>>(
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
              final style = _randomStyle();
              return Card(
                color: _randomCardColor(),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(item.titre, style: style),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RechercheInfractionDetailScreen(caseData: item),
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

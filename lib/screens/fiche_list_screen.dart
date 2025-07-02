import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/fiche.dart';
import '../widgets/fiche_card.dart';
import '../widgets/search_bar.dart';
import 'fiche_detail_screen.dart';
import 'package:flutter/services.dart' show rootBundle;

class FicheListScreen extends StatefulWidget {
  const FicheListScreen({Key? key}) : super(key: key);

  @override
  State<FicheListScreen> createState() => _FicheListScreenState();
}

class _FicheListScreenState extends State<FicheListScreen> {
  List<Fiche> fiches = [];
  List<Fiche> filteredFiches = [];

  @override
  void initState() {
    super.initState();
    loadFiches();
  }

  Future<void> loadFiches() async {
    final String data = await rootBundle.loadString('assets/data/fiches.json');
    final List<dynamic> ficheList = json.decode(data);
    setState(() {
      fiches = ficheList.map((e) => Fiche.fromJson(e)).toList();
      filteredFiches = fiches;
    });
  }

  void onSearch(String query) {
    setState(() {
      filteredFiches = fiches
          .where((fiche) =>
      fiche.titre.toLowerCase().contains(query.toLowerCase()) ||
          fiche.theme.toLowerCase().contains(query.toLowerCase()) ||
          fiche.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase())))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des fiches'),
      ),
      body: Column(
        children: [
          SearchBar(
            hintText: 'Rechercher une fiche…',
            onChanged: onSearch,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFiches.length,
              itemBuilder: (context, index) {
                final fiche = filteredFiches[index];
                return FicheCard(
                  fiche: fiche,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AnimatedFicheDetailScreen(fiche: fiche),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
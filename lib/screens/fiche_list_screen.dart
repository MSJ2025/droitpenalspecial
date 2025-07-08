import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/infraction.dart';
import '../widgets/fiche_card.dart';
import '../widgets/search_bar.dart';
import 'package:flutter/services.dart' show rootBundle;

class FicheListScreen extends StatefulWidget {
  final List<String>? filterThemes;

  const FicheListScreen({Key? key, this.filterThemes}) : super(key: key);

  @override
  State<FicheListScreen> createState() => _FicheListScreenState();
}

class _FicheListScreenState extends State<FicheListScreen> {
  List<Infraction> fiches = [];
  List<Infraction> categoryFiches = [];
  List<Infraction> filteredFiches = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFiches();
  }

  Future<void> loadFiches() async {
    final String data = await rootBundle.loadString('assets/data/fiches.json');
    final cleaned = data.replaceAll(RegExp(r'(?<!:)//.*', multiLine: true), '');
    final List<dynamic> families = json.decode(cleaned);
    fiches = [];
    for (final fam in families) {
      final String famille = fam['famille'];
      final List<dynamic> infs = fam['infractions'];
      for (var i = 0; i < infs.length; i++) {
        fiches.add(Infraction.fromJson(famille, infs[i], i));
      }
    }
    categoryFiches = widget.filterThemes == null || widget.filterThemes!.isEmpty
        ? fiches
        : fiches
            .where((f) => widget.filterThemes!.contains(f.famille))
            .toList();
    setState(() {
      filteredFiches = categoryFiches;
      isLoading = false;
    });
  }

  void onSearch(String query) {
    setState(() {
      filteredFiches = categoryFiches
          .where((fiche) =>
              fiche.type.toLowerCase().contains(query.toLowerCase()) ||
              fiche.famille.toLowerCase().contains(query.toLowerCase()))
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
          CustomSearchBar(
            hintText: 'Rechercher une fiche…',
            onChanged: onSearch,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      key: const ValueKey('list'),
                      itemCount: filteredFiches.length,
                      itemBuilder: (context, index) {
                        final fiche = filteredFiches[index];
                        return FicheCard(
                          fiche: fiche,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(fiche.type),
                                content: Text(fiche.definition),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

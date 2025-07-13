import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/infraction.dart';
import '../utils/json_loader.dart';
import '../widgets/infraction_card.dart';
import '../widgets/search_bar.dart';
import 'infraction_detail_screen.dart';
import '../widgets/adaptive_appbar_title.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Infraction> _allInfractions = [];
  List<Infraction> _filteredInfractions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInfractions();
  }

  Future<void> _loadInfractions() async {
    final data = await loadJsonWithComments('assets/data/fiches.json');
    final List<dynamic> rawFamilies = json.decode(data);
    final families = rawFamilies
        .map((e) => FamilleInfractions.fromJson(e as Map<String, dynamic>))
        .toList();
    _allInfractions = families.expand((f) => f.infractions).toList()
      ..sort(
        (a, b) => (a.type ?? '').toLowerCase().compareTo(
              (b.type ?? '').toLowerCase(),
            ),
      );
    setState(() {
      _filteredInfractions = _allInfractions;
      _isLoading = false;
    });
  }

  void _onSearch(String query) {
    final lower = query.toLowerCase();
    setState(() {
      _filteredInfractions = _allInfractions
          .where((inf) => (inf.type ?? '').toLowerCase().contains(lower) ||
              (inf.definition ?? '').toLowerCase().contains(lower))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AdaptiveAppBarTitle(
          'Recherche',
          maxLines: 1,
        ),
      ),
      body: Column(
        children: [
          CustomSearchBar(
            hintText: 'Rechercher une infraction…',
            onChanged: _onSearch,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      key: const ValueKey('searchList'),
                      itemCount: _filteredInfractions.length,
                      itemBuilder: (context, index) {
                        final infraction = _filteredInfractions[index];
                        return InfractionCard(
                          infraction: infraction,
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (_, animation, __) => FadeTransition(
                                  opacity: animation,
                                  child: InfractionDetailScreen(
                                      infraction: infraction),
                                ),
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

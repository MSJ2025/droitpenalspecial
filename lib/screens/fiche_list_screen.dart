import 'package:flutter/material.dart';
import '../models/infraction.dart';
import '../widgets/infraction_card.dart';
import '../widgets/search_bar.dart';
import 'infraction_detail_screen.dart';
import '../widgets/adaptive_appbar_title.dart';
import '../utils/ad_event_manager.dart';

class FicheListScreen extends StatefulWidget {
  final FamilleInfractions famille;

  const FicheListScreen({Key? key, required this.famille}) : super(key: key);

  @override
  State<FicheListScreen> createState() => _FicheListScreenState();
}

class _FicheListScreenState extends State<FicheListScreen> {
  late List<Infraction> infractions;
  late List<Infraction> filteredInfractions;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    infractions = [
      ...widget.famille.infractions
    ]
      ..sort(
        (a, b) => (a.type ?? '').toLowerCase().compareTo(
              (b.type ?? '').toLowerCase(),
            ),
      );
    filteredInfractions = infractions;
    isLoading = false;
  }

  void onSearch(String query) {
    setState(() {
      filteredInfractions = infractions
          .where((inf) =>
              (inf.type ?? '').toLowerCase().contains(query.toLowerCase()) ||
              (inf.definition ?? '').toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AdaptiveAppBarTitle(
          widget.famille.famille ?? 'Infractions',
          maxLines: 1,
        ),
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
                      itemCount: filteredInfractions.length,
                      itemBuilder: (context, index) {
                        final infraction = filteredInfractions[index];
                        return InfractionCard(
                          infraction: infraction,
                          onTap: () {
                            AdEventManager.onInfractionViewed();
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (_, animation, __) => FadeTransition(
                                  opacity: animation,
                                  child: InfractionDetailScreen(infraction: infraction),
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

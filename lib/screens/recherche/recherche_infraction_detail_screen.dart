import 'package:flutter/material.dart';
import 'dart:ui';

import '../../models/exercice_infraction.dart';
import '../../widgets/ad_banner.dart';
import '../../widgets/report_dialog.dart';
import 'recherche_infraction_quiz_screen.dart';

class RechercheInfractionDetailScreen extends StatefulWidget {
  final ExerciceInfraction caseData;
  const RechercheInfractionDetailScreen({super.key, required this.caseData});

  @override
  State<RechercheInfractionDetailScreen> createState() => _RechercheInfractionDetailScreenState();
}

class _RechercheInfractionDetailScreenState extends State<RechercheInfractionDetailScreen> {
  bool _showContext = false;

  @override
  Widget build(BuildContext context) {
    final sentences = widget.caseData.contextualisation
        .split(RegExp(r'(?<=[.!?])\s+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    return Scaffold(
      appBar: AppBar(title: Text(widget.caseData.titre)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () => setState(() => _showContext = !_showContext),
                  icon: Icon(
                    _showContext ? Icons.expand_less : Icons.expand_more,
                    size: 0,
                  ),
                  label: Text(
                    _showContext ? 'Masquer contexte' : 'Afficher contexte',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (context) => ReportDialog(
                        ficheId: widget.caseData.titre,
                        fiche: widget.caseData,
                      ),
                    );
                    if (result == true && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Merci pour votre signalement !'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.flag),
                  label: Text(
                    '',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: SizedBox.shrink(),
              secondChild: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.9),
                        Colors.grey.shade200.withOpacity(0.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 2,
                    alignment: WrapAlignment.center,
                    children: sentences.map((sentence) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.primary.withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        child: Text(
                          sentence,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              crossFadeState: _showContext ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 300),
            ),
            const SizedBox(height: 2),
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primary.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    child: Text(
                      widget.caseData.histoireDetaillee
                          .replaceAll(RegExp(r'(?<=\.)\s+'), '\n'),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white, height: 1.5),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RechercheInfractionQuizScreen(caseData: widget.caseData),
                    ),
                  );
                },
                child: const Text('Trouver les infractions'),
              ),
            ),
            const SizedBox(height: 8),
            const Center(child: AdBanner()),
          ],
        ),
      ),
    );
  }
}

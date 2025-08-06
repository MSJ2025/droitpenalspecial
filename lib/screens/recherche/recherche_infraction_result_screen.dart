import 'package:flutter/material.dart';

import '../../models/exercice_infraction.dart';
import 'recherche_infraction_correction_screen.dart';

class RechercheInfractionResultScreen extends StatelessWidget {
  final ExerciceInfraction caseData;
  final List<String> correct;
  final List<String> incorrect;

  const RechercheInfractionResultScreen({
    super.key,
    required this.caseData,
    required this.correct,
    required this.incorrect,
  });

  Widget _buildSection(String title, List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final item in items) Text('• ' + item),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Résultat')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('Correctes', correct),
            _buildSection('Incorrectes', incorrect),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RechercheInfractionCorrectionScreen(caseData: caseData),
                    ),
                  );
                },
                child: const Text('Voir la correction'),
              ),
            )
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';

import '../../models/exercice_infraction.dart';
import 'recherche_infraction_correction_screen.dart';

class RechercheInfractionResultScreen extends StatelessWidget {
  final ExerciceInfraction caseData;
  final int correct;
  final int incorrect;
  final int manquantes;
  final bool success;

  const RechercheInfractionResultScreen({
    super.key,
    required this.caseData,
    required this.correct,
    required this.incorrect,
    required this.manquantes,
    required this.success,
  });

  @override
  Widget build(BuildContext context) {
    final colors = success
        ? [Colors.greenAccent, Colors.green]
        : [Colors.redAccent, Colors.orange];
    return Scaffold(
      appBar: AppBar(title: const Text('Résultat')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: colors),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      success ? 'Bravo !' : 'Raté…',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text('Correctes : $correct'),
                    Text('Incorrectes : $incorrect'),
                    Text('Manquantes : $manquantes'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        RechercheInfractionCorrectionScreen(caseData: caseData),
                  ),
                );
              },
              child: const Text('Voir la correction'),
            )
          ],
        ),
      ),
    );
  }
}

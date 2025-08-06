import 'package:flutter/material.dart';

import '../../models/exercice_infraction.dart';
import '../theme_screen.dart';

class RechercheInfractionCorrectionScreen extends StatelessWidget {
  final ExerciceInfraction caseData;
  const RechercheInfractionCorrectionScreen({super.key, required this.caseData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Correction')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final corr in caseData.correction) _buildCard(context, corr),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ThemeScreen()),
                );
              },
              child: const Text('Retour aux thèmes'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> data) {
    final numero = data['infraction_numero'];
    final personne = data['personne_concernee'];
    final qualification = data['infraction']?['qualification'];
    final articles = data['elements_constitutifs']?['element_legal'];
    final elementMateriel = data['elements_constitutifs']?['element_materiel'];
    final elementMoral = data['elements_constitutifs']?['element_moral'];
    final preuves = data['elements_de_preuve'] ?? <String, dynamic>{};
    final preuvesMaterielles = (preuves['materielles'] as List?)?.whereType<String>() ?? [];
    final preuvesMedicales = (preuves['medicales'] as List?)?.whereType<String>() ?? [];
    final preuvesMorales = (preuves['morales'] as List?)?.whereType<String>() ?? [];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Infraction n°$numero', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Personne concernée : $personne'),
            const SizedBox(height: 8),
            if (qualification != null) ...[
              Text('Qualification : $qualification'),
              const SizedBox(height: 8),
            ],
            if (articles != null) ...[
              Text('Articles : $articles'),
              const SizedBox(height: 8),
            ],
            if (elementMateriel != null || elementMoral != null) ...[
              const Text('Éléments constitutifs :'),
              if (elementMateriel is List)
                for (final e in elementMateriel) Text('- $e')
              else if (elementMateriel != null)
                Text('- $elementMateriel'),
              if (elementMoral != null) Text('- $elementMoral'),
              const SizedBox(height: 8),
            ],
            if (preuvesMaterielles.isNotEmpty || preuvesMedicales.isNotEmpty || preuvesMorales.isNotEmpty) ...[
              const Text('Éléments de preuve :'),
              if (preuvesMaterielles.isNotEmpty) ...[
                const Text('Matérielles :'),
                for (final p in preuvesMaterielles) Text('- $p'),
              ],
              if (preuvesMedicales.isNotEmpty) ...[
                const Text('Médicales :'),
                for (final p in preuvesMedicales) Text('- $p'),
              ],
              if (preuvesMorales.isNotEmpty) ...[
                const Text('Morales :'),
                for (final p in preuvesMorales) Text('- $p'),
              ],
            ],
          ],
        ),
      ),
    );
  }
}


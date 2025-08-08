import 'package:flutter/material.dart';

import '../../models/exercice_infraction.dart';
import '../theme_screen.dart';
import '../../widgets/ad_banner.dart';

class RechercheInfractionCorrectionScreen extends StatelessWidget {
  final ExerciceInfraction caseData;
  const RechercheInfractionCorrectionScreen({super.key, required this.caseData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Correction')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
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
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: AdBanner(),
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

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Infraction n°$numero',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Wrap each detail in its own translucent card
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Personne concernée : $personne',
                textAlign: TextAlign.center,
              ),
            ),
            if (qualification != null) ...[
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Qualification : $qualification',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            if (articles != null) ...[
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Articles : $articles',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            if (elementMateriel != null || elementMoral != null) ...[
              const SizedBox(height: 8),
              const Text(
                'Éléments constitutifs :',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (elementMateriel is List)
                for (final e in elementMateriel)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '- $e',
                      textAlign: TextAlign.center,
                    ),
                  )
              else if (elementMateriel != null)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '- $elementMateriel',
                    textAlign: TextAlign.center,
                  ),
                ),
              if (elementMoral != null)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '- $elementMoral',
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
            if (preuvesMaterielles.isNotEmpty ||
                preuvesMedicales.isNotEmpty ||
                preuvesMorales.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Éléments de preuve :',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (preuvesMaterielles.isNotEmpty) ...[
                const SizedBox(height: 4),
                for (final p in preuvesMaterielles)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Matérielles : $p',
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
              if (preuvesMedicales.isNotEmpty) ...[
                const SizedBox(height: 4),
                for (final p in preuvesMedicales)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Médicales : $p',
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
              if (preuvesMorales.isNotEmpty) ...[
                const SizedBox(height: 4),
                for (final p in preuvesMorales)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Morales : $p',
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}


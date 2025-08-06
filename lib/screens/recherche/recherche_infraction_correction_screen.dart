import 'package:flutter/material.dart';

import '../../models/exercice_infraction.dart';

class RechercheInfractionCorrectionScreen extends StatelessWidget {
  final ExerciceInfraction caseData;
  const RechercheInfractionCorrectionScreen({super.key, required this.caseData});

  Widget _buildBulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [for (final item in items) Text('• ' + item)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Correction')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: caseData.correction.length,
        itemBuilder: (context, index) {
          final corr = caseData.correction[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(corr.qualification, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Articles : ' + corr.articles),
                const SizedBox(height: 8),
                Text('Éléments constitutifs', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Élément légal : ' + corr.elementsConstitutifs.elementLegal),
                if (corr.elementsConstitutifs.elementMateriel.isNotEmpty) _buildBulletList(corr.elementsConstitutifs.elementMateriel),
                Text('Élément moral : ' + corr.elementsConstitutifs.elementMoral),
                const SizedBox(height: 8),
                Text('Éléments de preuve', style: const TextStyle(fontWeight: FontWeight.bold)),
                if (corr.elementsDePreuve.materielles.isNotEmpty) ...[
                  const Text('Matérielles :'),
                  _buildBulletList(corr.elementsDePreuve.materielles),
                ],
                if (corr.elementsDePreuve.medicales.isNotEmpty) ...[
                  const Text('Médicales :'),
                  _buildBulletList(corr.elementsDePreuve.medicales),
                ],
                if (corr.elementsDePreuve.morales.isNotEmpty) ...[
                  const Text('Morales :'),
                  _buildBulletList(corr.elementsDePreuve.morales),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}


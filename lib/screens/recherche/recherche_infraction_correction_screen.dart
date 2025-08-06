import 'package:flutter/material.dart';

import '../../models/exercice_infraction.dart';

class RechercheInfractionCorrectionScreen extends StatelessWidget {
  final ExerciceInfraction caseData;
  const RechercheInfractionCorrectionScreen({super.key, required this.caseData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Correction')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: caseData.correction.length,
        itemBuilder: (context, index) {
          final corr = caseData.correction[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Infraction ${corr.infractionNumero}: ${corr.qualification}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text('Personne concernée : ${corr.personneConcernee}'),
                  Text('Articles : ${corr.articles}'),
                  const SizedBox(height: 8),
                  Text('Élément légal : ${corr.elementsConstitutifs.elementLegal}'),
                  ...corr.elementsConstitutifs.elementMateriel.map((e) => Text('- $e')),
                  Text('Élément moral : ${corr.elementsConstitutifs.elementMoral}'),
                  const SizedBox(height: 8),
                  if (corr.elementsDePreuve.materielles.isNotEmpty) ...[
                    const Text('Preuves matérielles :'),
                    ...corr.elementsDePreuve.materielles.map((e) => Text('- $e')),
                    const SizedBox(height: 4),
                  ],
                  if (corr.elementsDePreuve.medicales.isNotEmpty) ...[
                    const Text('Preuves médicales :'),
                    ...corr.elementsDePreuve.medicales.map((e) => Text('- $e')),
                    const SizedBox(height: 4),
                  ],
                  if (corr.elementsDePreuve.morales.isNotEmpty) ...[
                    const Text('Preuves morales :'),
                    ...corr.elementsDePreuve.morales.map((e) => Text('- $e')),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

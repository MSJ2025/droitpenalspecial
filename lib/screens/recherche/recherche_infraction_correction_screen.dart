import 'package:flutter/material.dart';
import '../../models/recherche_infraction.dart';

class CorrectionScreen extends StatelessWidget {
  final List<InfractionCorrection> corrections;
  const CorrectionScreen({super.key, required this.corrections});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Correction')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: corrections.length,
        itemBuilder: (context, index) {
          final c = corrections[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Infraction ${c.infractionNumero} - ${c.personneConcernee}',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Qualification : ${c.qualification}'),
                  if (c.articles.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('Articles : ${c.articles}'),
                  ],
                  const SizedBox(height: 8),
                  if (c.elementMateriel.isNotEmpty || c.elementMoral.isNotEmpty) ...[
                    const Text('Éléments constitutifs :'),
                    if (c.elementMateriel.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      const Text('• Élément matériel :'),
                      ...c.elementMateriel.map((e) => Text('  - $e')),
                    ],
                    if (c.elementMoral.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text('• Élément moral : ${c.elementMoral}'),
                    ],
                  ],
                  const SizedBox(height: 8),
                  const Text('Éléments de preuve :'),
                  if (c.preuvesMaterielles.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    const Text('• Matérielles :'),
                    ...c.preuvesMaterielles.map((e) => Text('  - $e')),
                  ],
                  if (c.preuvesMedicales.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    const Text('• Médicales :'),
                    ...c.preuvesMedicales.map((e) => Text('  - $e')),
                  ],
                  if (c.preuvesMorales.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    const Text('• Morales :'),
                    ...c.preuvesMorales.map((e) => Text('  - $e')),
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

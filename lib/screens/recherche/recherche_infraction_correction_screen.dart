import 'package:flutter/material.dart';

import '../../models/recherche_infraction.dart';
import 'recherche_infraction_list_screen.dart';

class RechercheInfractionCorrectionScreen extends StatelessWidget {
  final RechercheInfraction caseData;
  const RechercheInfractionCorrectionScreen({super.key, required this.caseData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Correction')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: caseData.corrections.length,
                itemBuilder: (context, index) {
                  final c = caseData.corrections[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.qualification,
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text('Éléments constitutifs',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          if (c.elementLegal.isNotEmpty)
                            Text('Élément légal : ${c.elementLegal}'),
                          if (c.elementMateriel.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            const Text('Élément matériel :'),
                            ...c.elementMateriel.map((e) => Text('- $e')),
                          ],
                          if (c.elementMoral.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text('Élément moral : ${c.elementMoral}'),
                          ],
                          const SizedBox(height: 8),
                          Text('Éléments de preuve',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          if (c.preuvesMaterielles.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            const Text('Matérielles :'),
                            ...c.preuvesMaterielles.map((e) => Text('- $e')),
                          ],
                          if (c.preuvesMedicales.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            const Text('Médicales :'),
                            ...c.preuvesMedicales.map((e) => Text('- $e')),
                          ],
                          if (c.preuvesMorales.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            const Text('Morales :'),
                            ...c.preuvesMorales.map((e) => Text('- $e')),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (_) => const RechercheInfractionListScreen()),
                    (route) => route.isFirst,
                  );
                },
                child: const Text('Retour à la liste des exercices'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


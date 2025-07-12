import 'package:flutter/material.dart';
import '../models/cadre.dart';

class CadreDetailScreen extends StatelessWidget {
  final Cadre cadre;
  const CadreDetailScreen({super.key, required this.cadre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cadre.cadre)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(cadre.cadreLegal.titre,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            if (cadre.cadreLegal.articles.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(cadre.cadreLegal.articles),
              ),
            ...cadre.cadreLegal.commentaires
                .map((c) => Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(c),
                    ))
                .toList(),
            const SizedBox(height: 12),
            if (cadre.actes.isNotEmpty)
              const Text('Actes',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ...cadre.actes.map(
              (a) => Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a.acte,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    if (a.articles.isNotEmpty) Text(a.articles),
                    ...a.commentaires
                        .map((c) => Text('• $c'))
                        .toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

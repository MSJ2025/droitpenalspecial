import 'package:flutter/material.dart';
import '../models/cadre.dart';
import '../widgets/gradient_expansion_tile.dart';

class CadreDetailScreen extends StatelessWidget {
  final Cadre cadre;
  const CadreDetailScreen({super.key, required this.cadre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: 'cadreTitle-${cadre.cadre}',
          child: Material(
            color: Colors.transparent,
            child: Text(cadre.cadre),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: GradientExpansionTile(
              initiallyExpanded: true,
              title: Text(cadre.cadreLegal.titre),
              children: [
                if (cadre.cadreLegal.articles.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Text(cadre.cadreLegal.articles),
                  ),
                ...cadre.cadreLegal.commentaires.map(
                  (c) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 2),
                    child: Text(c),
                  ),
                ),
              ],
            ),
          ),
          ...cadre.actes.map(
            (a) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                title: Text(a.acte),
                children: [
                  if (a.articles.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Text(a.articles),
                    ),
                  ...a.commentaires.map(
                    (c) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 2),
                      child: Text('• $c'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

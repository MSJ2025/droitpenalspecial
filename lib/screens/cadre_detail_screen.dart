import 'package:flutter/material.dart';
import '../models/cadre.dart';
import '../widgets/gradient_expansion_tile.dart';
import '../widgets/adaptive_appbar_title.dart';
import '../widgets/report_dialog.dart';

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
            child: AdaptiveAppBarTitle(
              cadre.cadre,
              maxLines: 1,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) =>
                    ReportDialog(ficheId: cadre.cadre, fiche: cadre),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: Color(0xFF122046),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white, width: 1.3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  '16 à 19 (OPJ),',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  '20 et 21-1 (APJ),',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  '20-1 (Réserviste ancien OPJ ou APJ),',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  '21 et 21-1 (APJA)',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
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
                      child: Text(c),
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

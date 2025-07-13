import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/infraction.dart';
import '../widgets/gradient_expansion_tile.dart';
import '../widgets/adaptive_appbar_title.dart';
import '../widgets/report_dialog.dart';

class InfractionDetailScreen extends StatelessWidget {
  final Infraction infraction;
  const InfractionDetailScreen({super.key, required this.infraction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AdaptiveAppBarTitle(
          infraction.type ?? 'Infraction',
          maxLines: 1,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => ReportDialog(ficheId: infraction.id),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (infraction.definition != null)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                initiallyExpanded: true,
                title: const Text('Définition'),
                children: [Text(infraction.definition!)],
              ),
            ),
          if (infraction.articles != null && infraction.articles!.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                title: const Text('Articles'),
                children: [
                  ...infraction.articles!.map(
                    (a) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(_formatArticle(a)),
                    ),
                  ),
                ],
              ),
            ),
          if (infraction.elementsConstitutifs != null)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                title: const Text('Éléments constitutifs'),
                children: [
                  Table(
                    columnWidths: const {0: IntrinsicColumnWidth()},
                    defaultVerticalAlignment: TableCellVerticalAlignment.top,
                    children: [
                      if (infraction.elementsConstitutifs!.elementLegal != null) ...[
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 8, bottom: 4),
                              child: Text('Élément légal'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(infraction.elementsConstitutifs!.elementLegal!),
                            ),
                          ],
                        ),
                        const TableRow(children: [
                          TableCell(child: Divider()),
                          TableCell(child: Divider()),
                        ]),
                      ],
                      if (infraction.elementsConstitutifs!.elementMateriel != null) ...[
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 8, bottom: 4),
                              child: Text('Élément matériel'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(infraction.elementsConstitutifs!.elementMateriel!),
                            ),
                          ],
                        ),
                        const TableRow(children: [
                          TableCell(child: Divider()),
                          TableCell(child: Divider()),
                        ]),
                      ],
                      if (infraction.elementsConstitutifs!.elementMoral != null)
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 8, bottom: 4),
                              child: Text('Élément moral'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(infraction.elementsConstitutifs!.elementMoral!),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          if (infraction.penalites?.peines != null &&
              infraction.penalites!.peines!.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                title: const Text('Peines'),
                children: [
                  if (infraction.penalites!.qualification != null)
                    Text(infraction.penalites!.qualification!),
                  ...infraction.penalites!.peines!.map((p) => Text(p)),
                ],
              ),
            ),
          if (infraction.peinesComplementaires != null &&
              infraction.peinesComplementaires!.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                title: const Text('Peines complémentaires'),
                children:
                    infraction.peinesComplementaires!.map((p) => Text(p)).toList(),
              ),
            ),
          if (infraction.circonstancesAggravantes != null &&
              infraction.circonstancesAggravantes!.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                title: const Text('Circonstances aggravantes'),
                children: [
                  ...infraction.circonstancesAggravantes!.map(
                    (ca) => Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (ca.intitule != null)
                            Text(ca.intitule!,
                                style:
                                    const TextStyle(fontWeight: FontWeight.w600)),
                          if (ca.description != null) Text(ca.description!),
                          if (ca.peine != null) Text('Peine : ${ca.peine!}'),
                          if (ca.articles != null && ca.articles!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: ca.articles!
                                  .map(
                                    (a) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2),
                                      child: Text(_formatArticle(a)),
                                    ),
                                  )
                                  .toList(),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (infraction.tentative != null)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                title: const Text('Tentative'),
                children: [
                  if (infraction.tentative!.punissable != null)
                    Text(
                      'Punissable : ${_formatPunissable(infraction.tentative!.punissable!)}',
                    ),
                  if (infraction.tentative!.precision != null)
                    Text(infraction.tentative!.precision!),
                  if (infraction.tentative!.article != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child:
                          Text(_formatArticle(infraction.tentative!.article!)),
                    ),
                ],
              ),
            ),
          if (infraction.jurisprudence != null &&
              infraction.jurisprudence!.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                title: const Text('Jurisprudence'),
                children: [
                  ...infraction.jurisprudence!.map(
                    (jp) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(jp.reference),
                      subtitle: Text(jp.resume),
                      trailing: jp.lien != null
                          ? const Icon(Icons.open_in_new, size: 16)
                          : null,
                      onTap: jp.lien != null ? () => _openUrl(jp.lien) : null,
                    ),
                  ),
                ],
              ),
            ),
          if (infraction.particularites != null)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                title: const Text('Particularités'),
                children: [
                  if (infraction.particularites is String)
                    Text(infraction.particularites as String)
                  else if (infraction.particularites is List)
                    ...List<String>.from(infraction.particularites as List)
                        .map((p) => Text(p)),
                ],
              ),
            ),
          if (infraction.responsabilitePersonnesMorales != null &&
              infraction.responsabilitePersonnesMorales!.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                title: const Text('Responsabilité des personnes morales'),
                children: [
                  Text(infraction.responsabilitePersonnesMorales!),
                ],
              ),
            ),
          if (infraction.territorialite != null &&
              infraction.territorialite!.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                title: const Text('Territorialité'),
                children: [Text(infraction.territorialite!)],
              ),
            ),
          if (infraction.causesExemptionDiminutionPeine != null &&
              infraction.causesExemptionDiminutionPeine!.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                title: const Text("Causes d'exemption ou de diminution de peine"),
                children: [Text(infraction.causesExemptionDiminutionPeine!)],
              ),
            ),
          if (infraction.infractionsParticulieres != null &&
              infraction.infractionsParticulieres!.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                title: const Text('Infractions particulières'),
                children: [
                  ...infraction.infractionsParticulieres!.map(
                    (ip) => Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (ip.intitule != null)
                            Text(ip.intitule!,
                                style:
                                    const TextStyle(fontWeight: FontWeight.w600)),
                          if (ip.description != null) Text(ip.description!),
                          if (ip.articles != null && ip.articles!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: ip.articles!
                                  .map(
                                    (a) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2),
                                      child: Text(_formatArticle(a)),
                                    ),
                                  )
                                  .toList(),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _openUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  String _formatPunissable(String value) {
    final lower = value.toLowerCase();
    if (lower == 'true') return 'Oui';
    if (lower == 'false') return 'Non';
    return value;
  }

  String _formatArticle(InfractionArticle article) {
    final num = article.numero?.trim() ?? '';
    if (num.isEmpty) return '';
    final lower = num.toLowerCase();
    if (lower.contains('code')) {
      return lower.startsWith('article') ? num : 'Article $num';
    }
    if (lower.contains('cp')) {
      var base = num.replaceAll(RegExp(r'cp', caseSensitive: false), '').trim();
      if (base.toLowerCase().startsWith('article')) {
        base = base.substring('article'.length).trim();
      }
      return 'Article $base du Code pénal';
    }
    return 'Article $num du Code pénal';
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/infraction.dart';
import '../widgets/gradient_expansion_tile.dart';
import '../widgets/adaptive_appbar_title.dart';
import '../widgets/report_dialog.dart';
import '../widgets/ad_banner.dart';
import '../utils/favorites_manager.dart';

class InfractionDetailScreen extends StatefulWidget {
  final Infraction infraction;
  const InfractionDetailScreen({super.key, required this.infraction});

  @override
  State<InfractionDetailScreen> createState() => _InfractionDetailScreenState();
}

class _InfractionDetailScreenState extends State<InfractionDetailScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  Future<void> _loadFavorite() async {
    final fav = await FavoritesManager.isFavorite(widget.infraction.id);
    if (mounted) {
      setState(() {
        _isFavorite = fav;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    await FavoritesManager.toggleFavorite(widget.infraction.id);
    setState(() {
      _isFavorite = !_isFavorite;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isFavorite ? 'Ajouté aux favoris' : 'Retiré des favoris',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AdaptiveAppBarTitle(
          widget.infraction.type ?? 'Infraction',
          maxLines: 1,
        ),
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.star : Icons.star_border),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.flag),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (context) =>
                    ReportDialog(ficheId: widget.infraction.id, fiche: widget.infraction),
              );
              if (ok == true && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Merci, votre signalement a été envoyé.')),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
          if (widget.infraction.definition != null)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                initiallyExpanded: true,
                title: const Text('Définition'),
                children: [Text(widget.infraction.definition!)],
              ),
            ),
          if (widget.infraction.articles != null && widget.infraction.articles!.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                title: const Text('Articles'),
                children: [
                  ...widget.infraction.articles!.map(
                    (a) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(_formatArticle(a)),
                    ),
                  ),
                ],
              ),
            ),
          if (widget.infraction.elementsConstitutifs != null)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                title: const Text('Éléments constitutifs'),
                children: [
                  Table(
                    columnWidths: const {0: IntrinsicColumnWidth()},
                    defaultVerticalAlignment: TableCellVerticalAlignment.top,
                    children: [
                      if (widget.infraction.elementsConstitutifs!.elementLegal != null) ...[
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 8, bottom: 4),
                              child: Text('Élément légal'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(widget.infraction.elementsConstitutifs!.elementLegal!),
                            ),
                          ],
                        ),
                        const TableRow(children: [
                          TableCell(child: Divider()),
                          TableCell(child: Divider()),
                        ]),
                      ],
                      if (widget.infraction.elementsConstitutifs!.elementMateriel != null) ...[
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 8, bottom: 4),
                              child: Text('Élément matériel'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(widget.infraction.elementsConstitutifs!.elementMateriel!),
                            ),
                          ],
                        ),
                        const TableRow(children: [
                          TableCell(child: Divider()),
                          TableCell(child: Divider()),
                        ]),
                      ],
                      if (widget.infraction.elementsConstitutifs!.elementMoral != null)
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 8, bottom: 4),
                              child: Text('Élément moral'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(widget.infraction.elementsConstitutifs!.elementMoral!),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          if (widget.infraction.penalites?.peines != null &&
              widget.infraction.penalites!.peines!.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                title: const Text('Peines'),
                children: [
                  if (widget.infraction.penalites!.qualification != null)
                    Text(widget.infraction.penalites!.qualification!),
                  ...widget.infraction.penalites!.peines!.map((p) => Text(p)),
                ],
              ),
            ),
          if (widget.infraction.peinesComplementaires != null &&
              widget.infraction.peinesComplementaires!.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                title: const Text('Peines complémentaires'),
                children:
                    widget.infraction.peinesComplementaires!.map((p) => Text(p)).toList(),
              ),
            ),
          if (widget.infraction.circonstancesAggravantes != null &&
              widget.infraction.circonstancesAggravantes!.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                title: const Text('Circonstances aggravantes'),
                children: [
                  ...widget.infraction.circonstancesAggravantes!.map(
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
          if (widget.infraction.tentative != null)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                title: const Text('Tentative'),
                children: [
                  if (widget.infraction.tentative!.punissable != null)
                    Text(
                      'Punissable : ${_formatPunissable(widget.infraction.tentative!.punissable!)}',
                    ),
                  if (widget.infraction.tentative!.precision != null)
                    Text(widget.infraction.tentative!.precision!),
                  if (widget.infraction.tentative!.article != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child:
                          Text(_formatArticle(widget.infraction.tentative!.article!)),
                    ),
                ],
              ),
            ),
          if (widget.infraction.jurisprudence != null &&
              widget.infraction.jurisprudence!.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                title: const Text('Jurisprudence'),
                children: [
                  ...widget.infraction.jurisprudence!.map(
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
          if (widget.infraction.particularites != null)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                title: const Text('Particularités'),
                children: [
                  if (widget.infraction.particularites is String)
                    Text(widget.infraction.particularites as String)
                  else if (widget.infraction.particularites is List)
                    ...List<String>.from(widget.infraction.particularites as List)
                        .map((p) => Text(p)),
                ],
              ),
            ),
          if (widget.infraction.responsabilitePersonnesMorales != null &&
              widget.infraction.responsabilitePersonnesMorales!.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                title: const Text('Responsabilité des personnes morales'),
                children: [
                  Text(widget.infraction.responsabilitePersonnesMorales!),
                ],
              ),
            ),
          if (widget.infraction.territorialite != null &&
              widget.infraction.territorialite!.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                title: const Text('Territorialité'),
                children: [Text(widget.infraction.territorialite!)],
              ),
            ),
          if (widget.infraction.causesExemptionDiminutionPeine != null &&
              widget.infraction.causesExemptionDiminutionPeine!.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                title: const Text("Causes d'exemption ou de diminution de peine"),
                children: [Text(widget.infraction.causesExemptionDiminutionPeine!)],
              ),
            ),
          if (widget.infraction.infractionsParticulieres != null &&
              widget.infraction.infractionsParticulieres!.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: GradientExpansionTile(
                title: const Text('Infractions particulières'),
                children: [
                  ...widget.infraction.infractionsParticulieres!.map(
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
          const SizedBox(height: 16),
          ],
        ),
      ),
      const AdBanner(),
    ],
  ));
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

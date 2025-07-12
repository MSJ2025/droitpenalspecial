import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/infraction.dart';

class InfractionDetailScreen extends StatelessWidget {
  final Infraction infraction;
  const InfractionDetailScreen({super.key, required this.infraction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(infraction.type ?? 'Infraction')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (infraction.definition != null)
              Text(infraction.definition!, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            if (infraction.articles != null && infraction.articles!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Articles', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...infraction.articles!.map(
                    (a) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(_formatArticle(a)),
                    ),
                  ),
                ],
              ),
            if (infraction.elementsConstitutifs != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Text('Éléments constitutifs',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  if (infraction.elementsConstitutifs!.elementLegal != null)
                    Text('Élément légal : '
                        '${infraction.elementsConstitutifs!.elementLegal!}'),
                  if (infraction.elementsConstitutifs!.elementMateriel != null)
                    Text('Élément matériel : '
                        '${infraction.elementsConstitutifs!.elementMateriel!}'),
                  if (infraction.elementsConstitutifs!.elementMoral != null)
                    Text('Élément moral : '
                        '${infraction.elementsConstitutifs!.elementMoral!}'),
                ],
              ),
            if (infraction.penalites?.peines != null && infraction.penalites!.peines!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Text('Peines', style: TextStyle(fontWeight: FontWeight.bold)),
                  if (infraction.penalites!.qualification != null)
                    Text(infraction.penalites!.qualification!),
                  ...infraction.penalites!.peines!.map((p) => Text('• $p')),
                ],
              ),
            if (infraction.peinesComplementaires != null &&
                infraction.peinesComplementaires!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Text('Peines complémentaires',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...infraction.peinesComplementaires!
                      .map((p) => Text('• $p')),
                ],
              ),
            if (infraction.circonstancesAggravantes != null &&
                infraction.circonstancesAggravantes!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Text('Circonstances aggravantes',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...infraction.circonstancesAggravantes!.map(
                    (ca) => Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (ca.intitule != null)
                            Text(ca.intitule!,
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                          if (ca.description != null) Text(ca.description!),
                          if (ca.peine != null)
                            Text('Peine : ${ca.peine!}'),
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
            if (infraction.tentative != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Text('Tentative',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  if (infraction.tentative!.punissable != null)
                    Text('Punissable : ${infraction.tentative!.punissable}'),
                  if (infraction.tentative!.precision != null)
                    Text(infraction.tentative!.precision!),
                  if (infraction.tentative!.article != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(_formatArticle(infraction.tentative!.article!)),
                    ),
                ],
              ),
            if (infraction.jurisprudence != null && infraction.jurisprudence!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Text('Jurisprudence',
                      style: TextStyle(fontWeight: FontWeight.bold)),
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
            if (infraction.particularites != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Text('Particularités',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  if (infraction.particularites is String)
                    Text(infraction.particularites as String)
                  else if (infraction.particularites is List)
                    ...List<String>.from(infraction.particularites as List)
                        .map((p) => Text('• $p')),
                ],
              ),
            if (infraction.responsabilitePersonnesMorales != null &&
                infraction.responsabilitePersonnesMorales!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Text('Responsabilité des personnes morales',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(infraction.responsabilitePersonnesMorales!),
                ],
              ),
            if (infraction.territorialite != null && infraction.territorialite!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Text('Territorialité',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(infraction.territorialite!),
                ],
              ),
            if (infraction.causesExemptionDiminutionPeine != null &&
                infraction.causesExemptionDiminutionPeine!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Text('Causes d\'exemption ou de diminution de peine',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(infraction.causesExemptionDiminutionPeine!),
                ],
              ),
            if (infraction.infractionsParticulieres != null &&
                infraction.infractionsParticulieres!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Text('Infractions particulières',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...infraction.infractionsParticulieres!.map(
                    (ip) => Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (ip.intitule != null)
                            Text(ip.intitule!,
                                style: const TextStyle(fontWeight: FontWeight.w600)),
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
          ],
        ),
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

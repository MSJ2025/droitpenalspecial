import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/fiche.dart';
import '../utils/favorites_manager.dart';

class AnimatedFicheDetailScreen extends StatefulWidget {
  final Fiche fiche;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  const AnimatedFicheDetailScreen({super.key, required this.fiche, this.onNext, this.onPrevious});

  @override
  State<AnimatedFicheDetailScreen> createState() => _AnimatedFicheDetailScreenState();
}

class _AnimatedFicheDetailScreenState extends State<AnimatedFicheDetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isFavorite = false;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700)
    )..forward();
    FavoritesManager.isFavorite(widget.fiche.id).then((value) {
      if (mounted) {
        setState(() {
          _isFavorite = value;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Impossible d\'ouvrir le lien'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final fiche = widget.fiche;
    final gradient = LinearGradient(
      colors: [Colors.blue.shade800, Colors.blue.shade400, Colors.teal.shade200],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: Stack(
            children: [
              // Retour et navigation swipe
              Positioned(
                left: 10,
                top: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              if (widget.onPrevious != null)
                Positioned(
                  left: 10,
                  top: MediaQuery.of(context).size.height / 2,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_left, color: Colors.white, size: 32),
                    onPressed: widget.onPrevious,
                  ),
                ),
              if (widget.onNext != null)
                Positioned(
                  right: 10,
                  top: MediaQuery.of(context).size.height / 2,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_right, color: Colors.white, size: 32),
                    onPressed: widget.onNext,
                  ),
                ),
              // Carte principale animée
              Center(
                child: ScaleTransition(
                  scale: CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
                  child: Card(
                    elevation: 16,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Hero(
                                tag: 'fiche_${fiche.id}',
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: Text(fiche.titre, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: Icon(
                                  _isFavorite ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                ),
                                onPressed: () async {
                                  await FavoritesManager.toggleFavorite(fiche.id);
                                  final newStatus = await FavoritesManager.isFavorite(fiche.id);
                                  if (mounted) {
                                    setState(() {
                                      _isFavorite = newStatus;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 600),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Chip(
                                  label: Text(fiche.theme, style: const TextStyle(color: Colors.white)),
                                  backgroundColor: Colors.blue.shade700,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  fiche.definition,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                ),
                                const Divider(),
                                // Articles cliquables avec animation d’apparition
                                _buildArticleSection(context, "Article", fiche.article),
                                _buildArticleSection(context, "Prévu par", fiche.prevuPar),
                                _buildArticleSection(context, "Réprimé par", fiche.reprimePar),
                                const SizedBox(height: 10),
                                _animatedSection("Qualification légale", fiche.qualificationLegale),
                                _animatedSection("Éléments constitutifs", ""),
                                ListTile(
                                  leading: const Icon(Icons.gavel),
                                  title: GestureDetector(
                                    onTap: () => _openUrl(context, fiche.elementsConstitutifs.elementLegal.lien),
                                    child: Text(
                                      fiche.elementsConstitutifs.elementLegal.texte,
                                      style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.event_note),
                                  title: Text(fiche.elementsConstitutifs.elementMateriel.texte),
                                ),
                                if (fiche.elementsConstitutifs.elementMateriel.exemples != null)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18, bottom: 6),
                                    child: Wrap(
                                      spacing: 4,
                                      children: fiche.elementsConstitutifs.elementMateriel.exemples!
                                          .map((e) => Chip(label: Text(e)))
                                          .toList(),
                                    ),
                                  ),
                                ListTile(
                                  leading: const Icon(Icons.psychology),
                                  title: Text(fiche.elementsConstitutifs.elementMoral.texte),
                                  subtitle: fiche.elementsConstitutifs.elementMoral.remarque != null
                                      ? Text(fiche.elementsConstitutifs.elementMoral.remarque!)
                                      : null,
                                ),
                                const Divider(),
                                _animatedSection("Victime", fiche.victime),
                                _animatedSection("Auteurs/Complices", fiche.auteursEtComplices),
                                _animatedSection("Mode de poursuite", fiche.modeDePoursuite),
                                _animatedSection("Régime de procédure", fiche.regimeProcedure),
                                const Divider(),
                                _animatedSection("Peine principale", fiche.peinePrincipale),
                                ...fiche.peinesComplementaires.map((e) => _animatedSection("Peine complémentaire", e)),
                                const Divider(),
                                _animatedSection("Circonstances aggravantes", ""),
                                ...fiche.circonstancesAggravantes.map((ca) => ListTile(
                                  title: Text(ca.libelle),
                                  subtitle: GestureDetector(
                                    onTap: () => _openUrl(context, ca.article.lien),
                                    child: Text(
                                      ca.article.texte,
                                      style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                                    ),
                                  ),
                                  trailing: Text(ca.peine),
                                )),
                                const Divider(),
                                _animatedSection("Tentative", "${fiche.tentative.regime} (${fiche.tentative.peine})"),
                                _animatedSection(
                                    "Prescription", "Action publique : ${fiche.prescription.actionPublique}, Peine : ${fiche.prescription.peine}"),
                                const Divider(),
                                _animatedSection("Jurisprudence", ""),
                                ...fiche.jurisprudence.map((jp) => ListTile(
                                  title: Text(jp.reference),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(jp.resume),
                                      if (jp.lien != null)
                                        GestureDetector(
                                          onTap: () => _openUrl(context, jp.lien!),
                                          child: const Text(
                                            "Voir décision",
                                            style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                                          ),
                                        ),
                                    ],
                                  ),
                                )),
                                const Divider(),
                                _animatedSection("Points de vigilance", fiche.pointsDeVigilance.join("\n")),
                                const Divider(),
                                _animatedSection("Cas pratiques", fiche.exemplesCasPratiques.join("\n")),
                                const Divider(),
                                if (fiche.notes.isNotEmpty) _animatedSection("Notes", fiche.notes),
                                const Divider(),
                                Wrap(
                                  spacing: 8,
                                  children: fiche.tags.map((tag) => Chip(label: Text(tag))).toList(),
                                ),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Text('MàJ : ${fiche.derniereMaj}',
                                        style: const TextStyle(fontSize: 12, color: Colors.grey))),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleSection(BuildContext context, String label, ArticleRef article) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: GestureDetector(
        onTap: () => _openUrl(context, article.lien),
        child: Row(
          children: [
            Text('$label : ', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              article.texte,
              style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.open_in_new, size: 16, color: Colors.blueAccent),
          ],
        ),
      ),
    );
  }

  Widget _animatedSection(String title, String text) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 400),
      child: text.isEmpty
          ? const SizedBox()
          : Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 2),
            Text(text, style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
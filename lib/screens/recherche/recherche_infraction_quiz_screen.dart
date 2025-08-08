import 'package:flutter/material.dart';
import '../../models/exercice_infraction.dart';
import '../../utils/infraction_suggestions.dart';
import '../../widgets/ad_banner.dart';
import 'recherche_infraction_correction_screen.dart';

class RechercheInfractionQuizScreen extends StatefulWidget {
  final ExerciceInfraction caseData;
  const RechercheInfractionQuizScreen({super.key, required this.caseData});

  @override
  State<RechercheInfractionQuizScreen> createState() => _RechercheInfractionQuizScreenState();
}

class _RechercheInfractionQuizScreenState extends State<RechercheInfractionQuizScreen> {
  final List<TextEditingController?> _controllers = [];
  late Future<List<String>> _suggestions;

  @override
  void initState() {
    super.initState();
    _suggestions = loadInfractionSuggestions();
    _addField();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c?.dispose();
    }
    super.dispose();
  }

  void _addField() {
    setState(() {
      _controllers.add(null);
    });
  }

  LinearGradient _pageBgGradient() => const LinearGradient(
        colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  LinearGradient _appBarGradient() => const LinearGradient(
        colors: [Colors.blue, Colors.black],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  LinearGradient _dialogGradient(bool success) => LinearGradient(
        colors: success
            ? [const Color(0xFF2E7D32), const Color(0xFF66BB6A)]
            : [const Color(0xFFB71C1C), const Color(0xFFEF5350)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  Future<void> _showResultSummary({
    required bool success,
    required Set<String> correct,
    required Set<String> incorrect,
    required Set<String> manquantes,
  }) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: _dialogGradient(success),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(blurRadius: 24, color: Colors.black26, offset: Offset(0, 12)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(success ? Icons.emoji_events : Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      success ? 'Bravo !' : 'Raté…',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildResultCard('Infractions correctes', correct, Colors.green),
                      _buildResultCard('Infractions incorrectes', incorrect, Colors.red),
                      _buildResultCard('Infractions manquantes', manquantes, Colors.orange),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(
    String title,
    Set<String> items,
    Color color,
  ) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.85), color.withOpacity(0.45)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$title (${items.length})',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            for (final item in items) ...[
              Card(
                color: Colors.white.withOpacity(0.18),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  child: Center(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _validate() async {
    final expectedLower =
        widget.caseData.infractionsCiblees.map((e) => e.toLowerCase()).toSet();
    final providedControllers = _controllers.whereType<TextEditingController>();
    final providedOriginal = providedControllers
        .map((c) => c.text.trim())
        .where((e) => e.isNotEmpty)
        .toSet();
    final providedLower =
        providedOriginal.map((e) => e.toLowerCase()).toSet();

    final correctLower = expectedLower.intersection(providedLower);
    final incorrectLower = providedLower.difference(expectedLower);
    final manquantesLower = expectedLower.difference(providedLower);

    final correct = widget.caseData.infractionsCiblees
        .where((e) => correctLower.contains(e.toLowerCase()))
        .toSet();
    final manquantes = widget.caseData.infractionsCiblees
        .where((e) => manquantesLower.contains(e.toLowerCase()))
        .toSet();
    final incorrect = providedOriginal
        .where((e) => incorrectLower.contains(e.toLowerCase()))
        .toSet();

    final success =
        correct.length == expectedLower.length && incorrect.isEmpty && manquantes.isEmpty;
    await _showResultSummary(
      success: success,
      correct: correct,
      incorrect: incorrect,
      manquantes: manquantes,
    );
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RechercheInfractionCorrectionScreen(caseData: widget.caseData),
      ),
    );
  }

  Widget _buildField(int index, List<String> suggestions) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Card(
        elevation: 0,
        color: Colors.white.withOpacity(0.06),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Autocomplete<String>(
            optionsBuilder: (text) {
              if (text.text.isEmpty) return const Iterable<String>.empty();
              return suggestions.where((s) => s.toLowerCase().contains(text.text.toLowerCase()));
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(12),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 240, maxWidth: 600),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shrinkWrap: true,
                      itemCount: options.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final opt = options.elementAt(i);
                        return ListTile(
                          dense: true,
                          leading: const Icon(Icons.gavel_outlined),
                          title: Text(opt),
                          onTap: () => onSelected(opt),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
            fieldViewBuilder: (_, controller, focusNode, onFieldSubmitted) {
              if (_controllers[index] == null) {
                _controllers[index] = controller;
              } else {
                controller = _controllers[index]!;
              }
              return TextField(
                controller: controller,
                focusNode: focusNode,
                onSubmitted: (_) => onFieldSubmitted(),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Saisir une infraction…',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.06),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white, width: 1.2),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trouver les infractions'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(decoration: BoxDecoration(gradient: _appBarGradient())),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: _pageBgGradient()),
        child: FutureBuilder<List<String>>(
          future: _suggestions,
          builder: (context, snapshot) {
            final suggestions = snapshot.data ?? const <String>[];
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _controllers.length,
                        itemBuilder: (context, index) => _buildField(index, suggestions),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _addField,
                            icon: const Icon(Icons.add_circle_outline),
                            label: const Text('Ajouter'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Colors.white.withOpacity(0.6)),
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _validate,
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Valider'),
                            style: FilledButton.styleFrom(
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const AdBanner(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../models/recherche_infraction.dart';
import '../../utils/infraction_suggestions.dart';

class RechercheInfractionQuizScreen extends StatefulWidget {
  final RechercheInfraction caseData;
  const RechercheInfractionQuizScreen({super.key, required this.caseData});

  @override
  State<RechercheInfractionQuizScreen> createState() => _RechercheInfractionQuizScreenState();
}

class _RechercheInfractionQuizScreenState extends State<RechercheInfractionQuizScreen> {
  final List<TextEditingController> _controllers = [TextEditingController()];
  late Future<List<String>> _suggestions;

  @override
  void initState() {
    super.initState();
    _suggestions = loadInfractionSuggestions();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addField() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  Future<void> _validate() async {
    final expected = widget.caseData.infractions.map((e) => e.toLowerCase()).toSet();
    final provided = _controllers
        .map((c) => c.text.trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toSet();
    final success = provided.length == expected.length && provided.containsAll(expected);
    if (mounted) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(success ? 'Bravo !' : 'Raté…'),
          content: Text(success
              ? 'Toutes les infractions ont été trouvées.'
              : 'Certaines infractions manquent ou sont incorrectes.'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
        ),
      );
    }
  }

  Widget _buildField(int index, List<String> suggestions) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Autocomplete<String>(
        optionsBuilder: (text) {
          if (text.text.isEmpty) return const Iterable<String>.empty();
          return suggestions.where((s) => s.toLowerCase().contains(text.text.toLowerCase()));
        },
        fieldViewBuilder: (_, controller, focusNode, onFieldSubmitted) {
          _controllers[index] = controller;
          return TextField(controller: controller, focusNode: focusNode, onSubmitted: (_) => onFieldSubmitted());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trouver les infractions')),
      body: FutureBuilder<List<String>>(
        future: _suggestions,
        builder: (context, snapshot) {
          final suggestions = snapshot.data ?? const <String>[];
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _controllers.length,
                    itemBuilder: (context, index) => _buildField(index, suggestions),
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(onPressed: _addField, child: const Text('Ajouter')),
                    const SizedBox(width: 16),
                    ElevatedButton(onPressed: _validate, child: const Text('Valider')),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../models/recherche_infraction.dart';
import 'recherche_infraction_quiz_screen.dart';

class RechercheInfractionDetailScreen extends StatelessWidget {
  final RechercheInfraction caseData;
  const RechercheInfractionDetailScreen({super.key, required this.caseData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(caseData.titre)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(child: Text(caseData.histoire)),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RechercheInfractionQuizScreen(caseData: caseData),
                    ),
                  );
                },
                child: const Text('Trouve la qualification pour tous les infractions'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

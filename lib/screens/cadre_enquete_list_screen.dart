import 'package:flutter/material.dart';

import '../models/cadre.dart';
import 'cadre_detail_screen.dart';

class CadreEnqueteListScreen extends StatelessWidget {
  const CadreEnqueteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cadres = const [
      Cadre(title: 'Cadre 1', description: 'Description du cadre 1'),
      Cadre(title: 'Cadre 2', description: 'Description du cadre 2'),
      Cadre(title: 'Cadre 3', description: 'Description du cadre 3'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadres d\'enquête'),
      ),
      body: ListView.builder(
        itemCount: cadres.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(cadres[index].title),
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (_, animation, __) => FadeTransition(
                  opacity: animation,
                  child: CadreDetailScreen(cadre: cadres[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


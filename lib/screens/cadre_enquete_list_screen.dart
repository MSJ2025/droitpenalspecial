import 'package:flutter/material.dart';

class CadreEnqueteListScreen extends StatelessWidget {
  const CadreEnqueteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cadres = const [
      'Cadre 1',
      'Cadre 2',
      'Cadre 3',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadres d\'enquête'),
      ),
      body: ListView.builder(
        itemCount: cadres.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(cadres[index]),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';

class CadreDetailScreen extends StatelessWidget {
  final String cadre;
  const CadreDetailScreen({super.key, required this.cadre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cadre),
      ),
      body: Center(
        child: Text('Détails pour ' + cadre),
      ),
    );
  }
}

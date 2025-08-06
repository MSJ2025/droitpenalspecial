import 'package:flutter/material.dart';
import '../models/cadre.dart';

class CadreDetailScreen extends StatelessWidget {
  final Cadre cadre;

  const CadreDetailScreen({super.key, required this.cadre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cadre.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(cadre.description),
      ),
    );
  }
}

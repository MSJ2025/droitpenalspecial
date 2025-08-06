import 'package:flutter/material.dart';
import '../widgets/adaptive_appbar_title.dart';

class CadreListScreen extends StatelessWidget {
  const CadreListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AdaptiveAppBarTitle(
          'Cadres d\'enquête',
          maxLines: 1,
        ),
      ),
      body: const Center(
        child: Text('À implémenter'),
      ),
    );
  }
}

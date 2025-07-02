import 'package:flutter/material.dart';
import 'fiche_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fiches OPJ'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Accéder aux fiches de droit pénal spécial'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const FicheListScreen()),
            );
          },
        ),
      ),
    );
  }
}
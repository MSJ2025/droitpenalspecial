import 'package:flutter/material.dart';
import '../models/fiche.dart';

class FicheCard extends StatelessWidget {
  final Fiche fiche;
  final VoidCallback onTap;

  const FicheCard({super.key, required this.fiche, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'fiche_${fiche.id}',
      child: Card(
        elevation: 7,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        color: Colors.white.withOpacity(0.92),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Text(fiche.titre.characters.first, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
          ),
          title: Text(fiche.titre, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(fiche.theme, style: const TextStyle(color: Colors.blueGrey)),
          trailing: const Icon(Icons.chevron_right_rounded, color: Colors.blueAccent),
          onTap: onTap,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../models/infraction.dart';

class FicheCard extends StatelessWidget {
  final Infraction fiche;
  final VoidCallback onTap;

  const FicheCard({super.key, required this.fiche, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'fiche_${fiche.id}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Card(
            elevation: 7,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            color: Colors.white.withOpacity(0.92),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  fiche.type.characters.first,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                ),
              ),
              title: Text(
                fiche.type,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                fiche.famille,
                style: const TextStyle(color: Colors.blueGrey),
              ),
              trailing: const Icon(Icons.chevron_right_rounded, color: Colors.blueAccent),
            ),
          ),
        ),
      ),
    );
  }
}

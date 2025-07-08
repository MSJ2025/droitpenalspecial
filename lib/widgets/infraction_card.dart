import 'package:flutter/material.dart';
import '../models/infraction.dart';

class InfractionCard extends StatelessWidget {
  final Infraction infraction;
  final VoidCallback onTap;

  const InfractionCard({super.key, required this.infraction, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Text(
            (infraction.type ?? '?').characters.first,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
          ),
        ),
        title: Text(
          infraction.type ?? '',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.blueAccent),
      ),
    );
  }
}

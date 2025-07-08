import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/infraction.dart';

class InfractionDetailScreen extends StatelessWidget {
  final Infraction infraction;
  const InfractionDetailScreen({super.key, required this.infraction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(infraction.type ?? 'Infraction')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (infraction.definition != null)
              Text(infraction.definition!, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            if (infraction.articles != null && infraction.articles!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Articles', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...infraction.articles!.map((a) => InkWell(
                        onTap: () => _openUrl(a.lien),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(a.numero ?? '', style: const TextStyle(color: Colors.blue)),
                        ),
                      )),
                ],
              ),
            if (infraction.penalites?.peines != null && infraction.penalites!.peines!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Text('Peines', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...infraction.penalites!.peines!.map((p) => Text('• $p')),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

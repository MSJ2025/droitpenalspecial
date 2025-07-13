import 'package:flutter/material.dart';
import '../models/infraction.dart';
import '../models/cadre.dart';
import '../utils/anomaly_reporter.dart';

class ReportDialog extends StatefulWidget {
  final String ficheId;
  final dynamic fiche;
  const ReportDialog({super.key, required this.ficheId, required this.fiche});

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _sending = false;

  Map<String, dynamic> _buildSummary() {
    final fiche = widget.fiche;
    if (fiche is Infraction) {
      return {
        'id': fiche.id,
        'type': fiche.type,
        'definition': fiche.definition,
      }..removeWhere((key, value) => value == null);
    } else if (fiche is Cadre) {
      return {
        'cadre': fiche.cadre,
        'actesCount': fiche.actes.length,
      };
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Signaler une erreur'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            maxLines: 3,
            enabled: !_sending,
            decoration: const InputDecoration(
              hintText: 'Décrivez le problème...',
            ),
          ),
          if (_sending)
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _sending ? null : () => Navigator.of(context).pop(false),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: _sending
              ? null
              : () async {
                  final message = _controller.text.trim();
                  if (message.isEmpty) return;
                  setState(() => _sending = true);

                  await AnomalyReporter.sendReport(
                    widget.ficheId,
                    message,
                    ficheSummary: _buildSummary(),
                  );
                  if (mounted) Navigator.of(context).pop(true);

                },
          child: const Text('Envoyer'),
        ),
      ],
    );
  }
}

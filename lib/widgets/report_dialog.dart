import 'package:flutter/material.dart';
import '../utils/anomaly_reporter.dart';

class ReportDialog extends StatefulWidget {
  final String ficheId;
  const ReportDialog({super.key, required this.ficheId});

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _sending = false;

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
          onPressed: _sending
              ? null
              : () async {
                  final message = _controller.text.trim();
                  if (message.isEmpty) return;
                  setState(() => _sending = true);
                  await AnomalyReporter.sendReport(widget.ficheId, message);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Merci pour votre retour.'),
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                },
          child: const Text('Envoyer'),
        ),
      ],
    );
  }
}

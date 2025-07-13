import 'package:flutter/material.dart';
import '../utils/anomaly_reporter.dart';

class ReportDialog extends StatefulWidget {
  final String ficheId;
  final Future<void> Function(Map<String, dynamic> data)? add;
  const ReportDialog({super.key, required this.ficheId, this.add});

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
      content: TextField(
        controller: _controller,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: 'Décrivez le problème...',
        ),
      ),
      actions: [
        TextButton(
          onPressed: _sending
              ? null
              : () async {
                  final message = _controller.text.trim();
                  if (message.isEmpty) return;
                  setState(() => _sending = true);
                  try {
                    await AnomalyReporter.sendReport(
                      widget.ficheId,
                      message,
                      add: widget.add,
                    );
                    if (mounted) Navigator.of(context).pop();
                  } catch (_) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Échec de l\'envoi du rapport'),
                        ),
                      );
                      setState(() => _sending = false);
                    }
                  }
                },
          child: const Text('Envoyer'),
        ),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class AnomalyReporter {
  /// Envoie un rapport d'anomalie.
  ///
  /// [add] permet d'injecter une fonction personnalisée lors des tests.
  /// Retourne `true` en cas de succès et lève une exception en cas d'échec.
  static Future<bool> sendReport(
    String ficheId,
    String message, {
    Future<void> Function(Map<String, dynamic> data)? add,
  }) async {
    try {
      final send = add ??
          FirebaseFirestore.instance.collection('reports').add;
      await send({
        'ficheId': ficheId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      throw Exception('Failed to send report: $e');
    }
  }
}

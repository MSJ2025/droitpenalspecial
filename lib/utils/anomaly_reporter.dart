import 'package:cloud_firestore/cloud_firestore.dart';

class AnomalyReporter {
  static Future<void> sendReport(String ficheId, String message) {
    return FirebaseFirestore.instance.collection('reports').add({
      'ficheId': ficheId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

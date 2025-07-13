import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'user_id_manager.dart';

class AnomalyReporter {
  /// Envoie un rapport d'anomalie.
  ///
  /// [ficheId] identifiant de la fiche concernée.
  /// [message] message de l'utilisateur.
  /// [ficheSummary] informations résumées sur la fiche (titre, type, ...).
  static Future<void> sendReport(
    String ficheId,
    String message, {
    required Map<String, dynamic> ficheSummary,
  }) async {
    final userId = await UserIdManager.getUserId();
    final packageInfo = await PackageInfo.fromPlatform();

    final deviceInfo = DeviceInfoPlugin();
    Map<String, dynamic> deviceData;
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      deviceData = {
        'platform': 'android',
        'model': info.model,
        'manufacturer': info.manufacturer,
        'version': info.version.release,
      };
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      deviceData = {
        'platform': 'ios',
        'model': info.utsname.machine,
        'systemName': info.systemName,
        'systemVersion': info.systemVersion,
      };
    } else {
      deviceData = {'platform': Platform.operatingSystem};
    }

    await FirebaseFirestore.instance.collection('reports').add({
      'ficheId': ficheId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'userId': userId,
      'appVersion': '${packageInfo.version}+${packageInfo.buildNumber}',
      'device': deviceData,
      'fiche': ficheSummary,
    });
  }
}

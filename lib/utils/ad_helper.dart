import 'dart:io';
import 'package:flutter/foundation.dart';

/// Utilitaire renvoyant les identifiants AdMob selon la plateforme.
class AdHelper {
  /// ID de l'application AdMob, différent en mode debug pour utiliser
  /// les identifiants de test recommandés par Google.
  static String get appId {
    if (Platform.isAndroid) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544~3347511713'
          : 'ca-app-pub-4176691748354941~1821840757';
    } else if (Platform.isIOS) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544~1458002511'
          : 'ca-app-pub-4176691748354941~1821840757';
    }
    throw UnsupportedError('Platform not supported');
  }

  /// Identifiant de la bannière d'accueil.
  /// Utilise les unités de test en mode debug.
  static String get bannerHome {
    if (Platform.isAndroid) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-4176691748354941/5507635012';
    } else if (Platform.isIOS) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/2934735716'
          : 'ca-app-pub-4176691748354941/5507635012';
    }
    throw UnsupportedError('Platform not supported');
  }

  /// Identifiant de l'interstitiel affiché dans les écrans de détail.
  /// Utilise les unités de test en mode debug.
  static String get interstitialDetail {
    if (Platform.isAndroid) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-4176691748354941/2302887173';
    } else if (Platform.isIOS) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/4411468910'
          : 'ca-app-pub-4176691748354941/2302887173';
    }
    throw UnsupportedError('Platform not supported');
  }

  /// Identifiant de l'interstitiel affiché au démarrage de l'application.
  static String get interstitialStart => interstitialDetail;

  /// Identifiant de l'interstitiel affiché après consultation de plusieurs fiches.
  static String get interstitialEvent {
    if (Platform.isAndroid) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-4176691748354941/6118843251';
    } else if (Platform.isIOS) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/4411468910'
          : 'ca-app-pub-4176691748354941/6118843251';
    }
    throw UnsupportedError('Platform not supported');
  }
}

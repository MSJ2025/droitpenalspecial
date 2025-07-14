import 'dart:io';

/// Utilitaire renvoyant les identifiants AdMob selon la plateforme.
class AdHelper {
  /// ID de l'application AdMob (identique pour Android et iOS ici).
  static const String appId = 'ca-app-pub-4176691748354941~1821840757';

  /// Identifiant de la bannière d'accueil.
  static String get bannerHome {
    if (Platform.isAndroid || Platform.isIOS) {
      return 'ca-app-pub-4176691748354941/5507635012';
    }
    throw UnsupportedError('Platform not supported');
  }

  /// Identifiant de l'interstitiel affiché dans les écrans de détail.
  static String get interstitialDetail {
    if (Platform.isAndroid || Platform.isIOS) {
      return 'ca-app-pub-4176691748354941/2302887173';
    }
    throw UnsupportedError('Platform not supported');
  }
}

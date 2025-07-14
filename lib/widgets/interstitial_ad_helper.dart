import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/ad_helper.dart';

/// Gestionnaire simple d'interstitiel.
class InterstitialAdHelper {
  InterstitialAdHelper._();
  static InterstitialAd? _ad;

  /// Charge l'interstitiel si nécessaire.
  static void load() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialDetail,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _ad = ad,
        onAdFailedToLoad: (_) => _ad = null,
      ),
    );
  }

  /// Affiche l'interstitiel s'il est prêt.
  static void show() {
    _ad?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _ad = null;
        load();
      },
    );
    _ad?.show();
  }
}

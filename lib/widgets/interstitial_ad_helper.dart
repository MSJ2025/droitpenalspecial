import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/ad_helper.dart';

/// Utilitaire minimaliste pour afficher un interstitiel à la demande.
class InterstitialAdHelper {
  InterstitialAdHelper._();

  /// Charge et affiche immédiatement un interstitiel.
  static void show({required String adUnitId}) {
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) => ad.dispose(),
          );
          ad.show();
        },
        onAdFailedToLoad: (_) {},
      ),
    );
  }
}

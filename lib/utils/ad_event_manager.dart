import '../widgets/interstitial_ad_helper.dart';
import 'ad_helper.dart';

/// Gère l'affichage conditionnel des interstitiels.
class AdEventManager {
  AdEventManager._();

  static int _infractionViews = 0;

  /// À appeler lorsqu'une fiche infraction est consultée.
  static void onInfractionViewed() {
    _infractionViews++;
    if (_infractionViews >= 3) {
      _infractionViews = 0;
      InterstitialAdHelper.show(adUnitId: AdHelper.interstitialEvent);
    }
  }

}

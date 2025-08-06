import 'package:flutter/foundation.dart';

import '../widgets/interstitial_ad_helper.dart';
import 'ad_helper.dart';

/// Gère l'affichage conditionnel des interstitiels.
class AdEventManager {
  AdEventManager._();

  static int _eventCount = 0;

  static void _recordEvent() {
    _eventCount++;
    if (_eventCount >= 3) {
      _eventCount = 0;
      InterstitialAdHelper.show(adUnitId: AdHelper.interstitialEvent);
    }
  }

  /// À appeler lorsqu'une fiche infraction est consultée.
  static void onInfractionViewed() => _recordEvent();

  /// À appeler lorsqu'un cadre d'enquête est ouvert.
  static void onCadreOpened() => _recordEvent();

  @visibleForTesting
  static int get eventCount => _eventCount;

  @visibleForTesting
  static void reset() => _eventCount = 0;
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:upgrader/upgrader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';
import 'utils/ad_helper.dart';
import 'widgets/interstitial_ad_helper.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Demande d'autorisation de suivi publicitaire (ATT).
  await AppTrackingTransparency.requestTrackingAuthorization();
  // Initialisation AdMob pour activer la pub.
  MobileAds.instance.initialize();
  await FirebaseAnalytics.instance.logAppOpen();
  runApp(const OPJFichesApp());
  // Interstitiel au démarrage.
  InterstitialAdHelper.show(adUnitId: AdHelper.interstitialStart);
}

class OPJFichesApp extends StatelessWidget {
  const OPJFichesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fiches OPJ',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: UpgradeAlert(
        child: const HomeScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

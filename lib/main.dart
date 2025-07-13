import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:upgrader/upgrader.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAnalytics.instance.logAppOpen();
  runApp(const OPJFichesApp());
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

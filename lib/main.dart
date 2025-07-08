import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _testLocalNetworkAccess();
  runApp(const OPJFichesApp());
}

Future<void> _testLocalNetworkAccess() async {
  try {
    final socket = await Socket.connect('192.168.1.1', 80, timeout: Duration(seconds: 2));
    socket.destroy();
  } catch (_) {
    // Erreur ignorée intentionnellement
  }
}

class OPJFichesApp extends StatelessWidget {
  const OPJFichesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fiches OPJ',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

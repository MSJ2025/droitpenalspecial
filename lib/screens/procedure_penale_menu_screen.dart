import 'package:flutter/material.dart';
import '../widgets/adaptive_appbar_title.dart';
import '../widgets/ad_banner.dart';


class ProcedurePenaleMenuScreen extends StatelessWidget {
  const ProcedurePenaleMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AdaptiveAppBarTitle(
          'Procédure Pénale',
          maxLines: 1,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF001F4D), Color(0xFF122046)],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 36, bottom: 32),
                        child: Image.asset(
                          'assets/images/logocreme.png',
                          width: 260,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const AdBanner(),
            ],
          ),
        ),
      ),
    );
  }
}



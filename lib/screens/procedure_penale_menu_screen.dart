import 'package:flutter/material.dart';
import '../widgets/modern_gradient_button.dart';
import 'cadre_list_screen.dart';

class ProcedurePenaleMenuScreen extends StatelessWidget {
  const ProcedurePenaleMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF001F4D), Color(0xFF122046)],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FractionallySizedBox(
                  widthFactor: 0.85,
                  child: ModernGradientButton(
                    icon: Icons.gavel,
                    label: "Cadres d'enquête",
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (_, animation, __) => FadeTransition(
                            opacity: animation,
                            child: const CadreListScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


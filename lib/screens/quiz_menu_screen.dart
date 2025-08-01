import 'package:flutter/material.dart';
import '../widgets/adaptive_appbar_title.dart';
import '../widgets/ad_banner.dart';
import '../widgets/modern_gradient_button.dart';
import 'quiz_cadre_screen.dart';
import 'quiz_stats_screen.dart';
import 'recherche/recherche_infraction_list_screen.dart';

class QuizMenuScreen extends StatelessWidget {
  const QuizMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AdaptiveAppBarTitle('Quiz', maxLines: 1),
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
                      FractionallySizedBox(
                        widthFactor: 0.85,
                        child: ModernGradientButton(
                          icon: Icons.gavel,
                          label: "Quiz cadres d'enquête",
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const QuizCadreScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      FractionallySizedBox(
                        widthFactor: 0.85,
                        child: ModernGradientButton(
                          icon: Icons.help_outline,
                          label: 'Quiz infractions',
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('À venir')),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      FractionallySizedBox(
                        widthFactor: 0.85,
                        child: ModernGradientButton(
                          icon: Icons.search,
                          label: 'Recherche d\u2019infractions',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    const RechercheInfractionListScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      FractionallySizedBox(
                        widthFactor: 0.85,
                        child: ModernGradientButton(
                          icon: Icons.bar_chart,
                          label: 'Statistiques',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const QuizStatsScreen(),
                              ),
                            );
                          },
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

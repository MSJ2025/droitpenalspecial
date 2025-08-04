import 'package:flutter/material.dart';
import 'theme_screen.dart';
import 'favorites_screen.dart';
import 'cadre_list_screen.dart';
import 'search_screen.dart';
import 'quiz_menu_screen.dart';
import '../widgets/ad_banner.dart';
import '../widgets/modern_gradient_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 36, bottom: 0),
                child: Image.asset(
                  'assets/images/logocreme.png',
                  width: 260,
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FractionallySizedBox(
                        widthFactor: 0.85,
                        child: ModernGradientButton(
                          icon: Icons.book,
                          label: 'Infractions par thèmes',
                  onPressed: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (_, animation, __) => FadeTransition(
                          opacity: animation,
                          child: const ThemeScreen(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              FractionallySizedBox(
                widthFactor: 0.85,
                child: ModernGradientButton(
                  icon: Icons.search,
                  label: "Rechercher une infraction",
                  onPressed: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (_, animation, __) => FadeTransition(
                          opacity: animation,
                          child: const SearchScreen(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              FractionallySizedBox(
                widthFactor: 0.85,
                child: ModernGradientButton(
                  icon: Icons.star,
                  label: 'Mes favoris',
                  onPressed: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (_, animation, __) => FadeTransition(
                          opacity: animation,
                          child: const FavoritesScreen(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              FractionallySizedBox(
                widthFactor: 0.85,
                child: ModernGradientButton(
                  icon: Icons.quiz,
                  label: 'S’entrainer',
                  onPressed: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (_, animation, __) => FadeTransition(
                          opacity: animation,
                          child: const QuizMenuScreen(),
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
              const SizedBox(height: 32),
              const AdBanner(),
            ],
          ),
        ),
      ),
    );
  }
}

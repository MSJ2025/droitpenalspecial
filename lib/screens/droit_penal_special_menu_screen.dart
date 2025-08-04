import 'package:flutter/material.dart';
import 'theme_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import '../widgets/adaptive_appbar_title.dart';
import '../widgets/modern_gradient_button.dart';

class DroitPenalSpecialMenuScreen extends StatelessWidget {
  const DroitPenalSpecialMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AdaptiveAppBarTitle(
          'Droit Pénal Spécial',
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
                    icon: Icons.search,
                    label: 'Rechercher une infraction',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}


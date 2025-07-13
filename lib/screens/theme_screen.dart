import 'package:flutter/material.dart';
import '../models/theme_category.dart';
import 'category_screen.dart';

const _categoryImages = {
  'personnes': 'assets/images/infractions_personnes.png',
  'biens': 'assets/images/infractions_biens.png',
  'nation': 'assets/images/infractions_nation.png',
  'autres': 'assets/images/infractions_autres.png',
};

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Th\u00e8mes')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: kThemeCategories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final cat = kThemeCategories[index];
          final image = _categoryImages[cat.id];
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (_, animation, __) => FadeTransition(
                    opacity: animation,
                    child: CategoryScreen(category: cat),
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 3 / 2,
                child: Image.asset(
                  image ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

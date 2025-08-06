import 'package:flutter/material.dart';

class ThemeCategory {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final List<String> keywords;

  const ThemeCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.keywords,
  });
}

const List<ThemeCategory> kThemeCategories = [
  ThemeCategory(
    id: 'personnes',
    title: 'Infractions contre les personnes',
    icon: Icons.person,
    color: Colors.red,
    keywords: [
      'personne',
      'mineur',
      'vie',
      'violence',
      'int\u00e9grit\u00e9',
      'dignit\u00e9',
      'danger',
    ],
  ),
  ThemeCategory(
    id: 'biens',
    title: 'Infractions contre les biens',
    icon: Icons.home,
    color: Colors.orange,
    keywords: [
      'domicile',
      'informatique',
      'propriet\u00e9',
      'logiciel',
    ],
  ),
  ThemeCategory(
    id: 'nation',
    title: 'Infractions contre la Nation, l\'\u00c9tat, la paix publique',
    icon: Icons.flag,
    color: Colors.blue,
    keywords: [
      'administration',
      'autorite',
      'justice',
      'ordre',
      'public',
      'paix',
    ],
  ),
  ThemeCategory(
    id: 'autres',
    title:
        'Autres crimes et d\u00e9lits (environnement, armes, drogues, sant\u00e9, etc.)',
    icon: Icons.category,
    color: Colors.teal,
    keywords: [
      'environnement',
      'arme',
      'explosif',
      'poudre',
      'stup',
      'drogue',
      'routi',
      'circulation',
      'sante',
    ],
  ),
];

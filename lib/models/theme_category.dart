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
    title: 'Atteintes aux personnes',
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
    id: 'administration',
    title: "Administration publique",
    icon: Icons.account_balance,
    color: Colors.blue,
    keywords: [
      'administration',
      'autorite',
      'justice',
      'public',
      'probite',
      'confiance',
    ],
  ),
  ThemeCategory(
    id: 'armes',
    title: 'Armes',
    icon: Icons.security,
    color: Colors.brown,
    keywords: ['arme', 'explosif', 'poudre'],
  ),
  ThemeCategory(
    id: 'stups',
    title: 'Stup\u00e9fiants',
    icon: Icons.healing,
    color: Colors.purple,
    keywords: ['stup\u00e9fiant'],
  ),
  ThemeCategory(
    id: 'routiere',
    title: 'Circulation routi\u00e8re',
    icon: Icons.directions_car,
    color: Colors.green,
    keywords: ['routi', 'circulation'],
  ),
];

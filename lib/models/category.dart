enum Category {
  personnes('Infractions contre les personnes'),
  biens('Infractions contre les biens'),
  nation('Infractions contre la Nation, l\'\u00c9tat, la paix publique'),
  autres('Autres crimes et d\u00e9lits (environnement, armes, drogues, sant\u00e9, etc.)');

  final String label;
  const Category(this.label);
}

const Map<Category, List<String>> categoryFamilies = {
  Category.personnes: [
    'Mise en p\u00e9ril des mineurs',
    'Violences',
    'Atteintes \u00e0 la personne humaine',
    'Atteintes \u00e0 l\'int\u00e9grit\u00e9 physique de la personne',
    'Risques caus\u00e9s \u00e0 autrui',
    'Atteintes \u00e0 la dignit\u00e9 et \u00e0 l\'int\u00e9grit\u00e9 morale - Prox\u00e9n\u00e9tisme et prostitution',
    'Atteintes volontaires \u00e0 la vie',
    'Atteintes \u00e0 la personne',
    'Atteintes involontaires \u00e0 la vie',
    'Exploitation de la personne',
    'Atteintes \u00e0 la libert\u00e9 individuelle',
    'Discriminations',
    'Mise en danger des personnes / Protection des mineurs',
    'Atteintes \u00e0 la vie priv\u00e9e',
    'Atteintes \u00e0 l\'honneur ou au respect',
    'Atteintes au respect d\u00fb aux morts',
    'Atteintes \u00e0 la filiation',
    'Atteintes au secret',
    'Atteintes au secret des correspondances par des personnes exer\u00e7ant une fonction publique',
    'Atteintes \u00e0 la repr\u00e9sentation de la personne',
    'Atteintes involontaires \u00e0 l\'int\u00e9grit\u00e9 de la personne',
    'Atteintes \u00e0 l\'exercice de l\'autorit\u00e9 parentale',
  ],
  Category.biens: [
    'Atteintes \u00e0 l\'inviolabilit\u00e9 du domicile',
    'Infractions informatiques et atteintes aux syst\u00e8mes de traitement automatis\u00e9 de donn\u00e9es',
    'Atteintes \u00e0 la propri\u00e9t\u00e9 intellectuelle et usages illicites de logiciels',
    'Atteintes aux droits de la personne par fichiers ou traitements informatiques',
  ],
  Category.nation: [
    'Atteintes \u00e0 l\'administration publique commises par les particuliers',
    'Autres manquements au devoir de probit\u00e9',
    'Atteintes \u00e0 la confiance publique',
    'Atteintes \u00e0 l\'administration publique',
    'Entraves \u00e0 la saisine de la justice',
    'Entraves \u00e0 l\'exercice de la justice',
    'Infractions contre l\'autorit\u00e9 judiciaire et l\'ordre public',
    'Infractions aux r\u00e8gles de d\u00e9claration et d\'utilisation des traitements informatis\u00e9s',
    'Atteintes \u00e0 l\'ordre public - Manifestations et r\u00e9unions publiques',
    'Infractions contre la paix publique',
  ],
  Category.autres: [
    'Stup\u00e9fiants',
    'Infractions commises par voie de presse ou tout autre moyen de publication portant atteinte \u00e0 l\'honneur ou \u00e0 la consid\u00e9ration',
    'Infractions d\u00e9lictuelles \u00e0 la circulation routi\u00e8re',
    'Infractions sp\u00e9cifiques et contraventions',
    'Infractions au r\u00e9gime des armes, poudres et explosifs',
  ],
};

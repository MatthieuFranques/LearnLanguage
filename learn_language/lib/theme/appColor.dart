import 'dart:ui';

class AppColors {
  // Palette principale
  static const primary = Color(0xFF4E617B);       // Header, bouton principal
  static const primaryLight = Color(0xFF607BAA);  // Survols, éléments interactifs
  static const primaryDark = Color(0xFF20365A);   // Texte principal
  static const primaryBright = Color(0xFFE6177F); // Accent / highlights

  // Couleur secondaire
  static const secondary = Color(0xFF607BAA);
  static const secondaryLight = Color(0xFF7BA7D9); // Optionnel, nuance claire
  static const secondaryDark = Color(0xFF4E617B);

  // Nouvelle couleur accent
  static const accentFuchsia = Color(0xFFE6177F);

  // Tons neutres
  static const background = Color(0xFFF5F5F5); // Fond général
  static const card = Color(0xFFCCC7A8);       // Cartes, encadrés
  static const border = Color(0xFF607BAA);     // Bordures
  static const shadow = Color(0xFF20365A);     // Ombres

  // Éléments interactifs
  static const highlight = Color(0xFFE6177F);      // Survols / accents
  static const button = Color(0xFF4E617B);         // Boutons principaux
  static const buttonHover = Color(0xFF607BAA);    // Boutons au survol
  static const buttonDisabled = Color(0xFFCCC7A8); // Boutons désactivés
  static const buttonText = Color(0xFFF5F5F5);     // Texte sur boutons foncés

  // Texte
  static const textPrimary = Color(0xFF20365A);   // Texte principal
  static const textSecondary = Color(0xFF607BAA); // Texte secondaire
  static const textTertiary = Color(0xFF4E617B);  // Texte moins important
  static const textDisabled = Color(0xFF7B8390);  // Texte désactivé
  static const textHint = Color(0xFFE6177F);      // Texte hint / accent
  static const textcolorBg = background;

  // États
  static const success = Color(0xFF7BBF6F); // Validation, succès
  static const error = Color(0xFFE6177F);   // Erreur / notification

  // Couleurs pour l'accueil / quiz
  // static const quiz1 = primary;
  // static const quiz2 = primaryLight;
  // static const quiz3 = primaryDark;
  // static const quiz4 = accentFuchsia;
  // static const quiz5 = success;

static const quiz1 = Color(0xFF607BAA); // bleu moyen
static const quiz2 = Color(0xFF4E617B); // bleu foncé
static const quiz3 = Color(0xFFE6177F); // fuchsia vif pour accent
static const quiz4 = Color(0xFF7BBF6F); // vert vif / succès
static const quiz5 = Color(0xFFF2A93B); // orange doux / énergie
}

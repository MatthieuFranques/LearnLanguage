import 'dart:ui';

class AppColors {
  // Palette principale
  static const primary = Color(0xFF4CE0D2); // Menthe principale
  static const primaryLight = Color(0xFF84CAE7); // Bleu doux
  static const primaryDark = Color(0xFF22AAA1); // Turquoise foncé

  // Tons très sombres (accents ou fond profond)
  static const dark = Color(0xFF136F63); // Vert très foncé
  static const darkest = Color(0xFF041B15); // Presque noir, profond

  // Couleurs complémentaires / UI
  static const background = Color(0xFFF9F6F1); // Crème / Ivoire
  static const card = Color(0xFFFFFFFF); // Blanc pur
  static const border = Color(0xFFB0B0B0); // Gris clair pour les bordures
  static const shadow = Color(0xFFE0E0E0); // Gris clair pour les ombres
  static const highlight =
      Color(0xFFFFB3A7); // Corail doux pour les éléments interactifs
  static const button = Color(0xFF4CE0D2); // Menthe pour les boutons
  static const buttonHover = Color(0xFF22AAA1); // Turquoise foncé pour hover
  static const buttonDisabled =
      Color(0xFFB0B0B0); // Gris clair pour les boutons désactivés
  static const buttonText =
      Color(0xFF041B15); // Texte des boutons (noir profond)

  // Texte
  static const textPrimary = Color(0xFF041B15); // Noir profond (de ta palette)
  static const textSecondary = Color(0xFF84CAE7); // Bleu clair pour accent
  static const textTertiary = Color(0xFF136F63); // Vert foncé pour les liens
  static const textDisabled =
      Color(0xFFB0B0B0); // Gris clair pour le texte désactivé
  static const textHint =
      Color.fromARGB(255, 241, 241, 241); // Gris clair pour les indices
  // États
  static const success = Color(0xFF22AAA1); // Utilise comme success color
  static const error = Color(0xFFFFB3A7); // Corail doux (garde ton ancienne)
  // Accent secondaire (optionnel)
  static const secondary = Color(0xFFFAD4D8); // Rose poudré
}

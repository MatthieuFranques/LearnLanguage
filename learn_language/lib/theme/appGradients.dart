import 'package:flutter/material.dart';
import 'package:learn_language/theme/appColor.dart';

class AppGradients {
  /// Dégradé principal 
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      AppColors.primaryDark,
      AppColors.primary,
      AppColors.primaryLight,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
static const LinearGradient primaryGradientTop = LinearGradient(

  colors: [
    AppColors.primaryBright, // Bleu plus lumineux
    AppColors.primary, // Bleu ardoise
    AppColors.primaryDark, // Bleu profond
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: [0.0, 0.5, 1.0], // Transitions progressives
);

  /// Dégradé secondaire 
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [
      AppColors.secondaryDark,
      AppColors.secondary,
      AppColors.secondaryLight,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dégradé highlight 
  static const LinearGradient highlightGradient = LinearGradient(
    colors: [
      AppColors.highlight,
      Color(0xFFFFE082), 
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dégradé succès 
  static const LinearGradient successGradient = LinearGradient(
    colors: [
      AppColors.secondaryLight,
      AppColors.success,
      AppColors.secondaryDark,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dégradé erreur 
  static const LinearGradient errorGradient = LinearGradient(
    colors: [
      AppColors.error,
      Color(0xFFB91C1C), 
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

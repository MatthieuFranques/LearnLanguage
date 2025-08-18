#!/bin/bash
# Installer Flutter
git clone https://github.com/flutter/flutter.git --depth 1
export PATH="$PWD/flutter/bin:$PATH"

# Aller dans le dossier de ton projet
cd learning_language

# Installer les dépendances Flutter
flutter pub get

# Construire le projet web
flutter build web --release

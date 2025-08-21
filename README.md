# 🌤️ Weather App - Formation Flutter YouTube

## 📚 **VIDEO 2 : Weather App (3-4h)**

Une application météo moderne construite avec Flutter qui couvre tous les concepts essentiels de votre formation.

## ✨ **Fonctionnalités**

- **🌍 APIs HTTP et JSON** - Intégration avec **Open-Meteo API** (100% gratuite)
- **🛡️ Gestion d'erreurs** - Gestion robuste des erreurs réseau et API
- **🎨 Interface météo moderne** - Design Material 3 avec gradients
- **🧭 Navigation complexe** - Gestion d'état avec Provider
- **📊 Prévisions étendues** - 168h horaires + 7 jours quotidiens
- **⚡ Performance optimisée** - Une seule requête API pour toutes les données
- **🚀 Sans limite** - Aucune clé API requise, requêtes illimitées

## 🚀 **Installation**

1. **Cloner le projet**
```bash
git clone <votre-repo>
cd weather_app
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Aucune configuration API requise !**
   - L'application utilise **Open-Meteo** qui est 100% gratuite
   - Aucune clé API nécessaire
   - Requêtes illimitées

4. **Lancer l'application**
```bash
flutter run
```

## 🏗️ **Architecture du projet**

```
lib/
├── models/           # Modèles de données avec JSON serialization
├── services/         # Services API et gestion d'erreurs
├── providers/        # Gestion d'état avec Provider
├── screens/          # Écrans de l'application
├── widgets/          # Widgets réutilisables
└── main.dart         # Point d'entrée de l'application
```

## 📱 **Écrans**

- **HomeScreen** - Écran principal avec météo actuelle
- **Prévisions horaires** - Scroll horizontal des prochaines 24h
- **Prévisions quotidiennes** - Vue sur 7 jours
- **Barre de recherche** - Recherche par nom de ville

## 🔧 **Technologies utilisées**

- **Flutter** - Framework UI
- **Provider** - Gestion d'état
- **HTTP** - Appels API
- **JSON Annotation** - Sérialisation des données
- **Intl** - Internationalisation
- **Open-Meteo API** - API météo 100% gratuite et performante
- **Geolocator** - Géolocalisation (préparé pour la suite)

## 🎯 **Concepts couverts dans la formation**

### 1. **APIs HTTP et JSON**
- Appels HTTP avec le package `http`
- Parsing JSON avec `json_annotation`
- Gestion des réponses API
- Structure des modèles de données

### 2. **Gestion d'erreurs**
- Try-catch pour les appels réseau
- Classes d'exception personnalisées
- Affichage des erreurs utilisateur
- Boutons de retry

### 3. **Interface météo moderne**
- Design Material 3
- Gradients et transparences
- Widgets personnalisés
- Responsive design

### 4. **Navigation complexe**
- Provider pour la gestion d'état
- Écrans multiples
- Gestion des états de chargement
- Actualisation des données

## 🌟 **Points forts de l'application**

- **Code propre et organisé** - Structure modulaire
- **Gestion d'état robuste** - Provider pattern
- **Interface utilisateur moderne** - Material Design 3
- **Gestion d'erreurs complète** - Expérience utilisateur optimale
- **Code prêt pour la production** - Bonnes pratiques Flutter

## 📖 **Prochaines étapes**

Cette application peut être étendue avec :
- Géolocalisation automatique
- Notifications météo
- Widgets d'accueil
- Mode sombre/clair
- Plus de langues

## 🎥 **Pour votre formation YouTube**

Cette application est parfaite pour démontrer :
- La gestion des APIs externes
- La gestion d'état avancée
- La création d'interfaces modernes
- Les bonnes pratiques Flutter

## 📝 **Notes de développement**

- L'application utilise l'API gratuite d'OpenWeatherMap
- Tous les widgets sont personnalisés et réutilisables
- Le code suit les conventions Flutter
- Prêt pour le déploiement sur iOS/Android

---

**Bon développement ! 🚀**

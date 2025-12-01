# Agence - App

Flutter app with social login, product catalog with lazy loading, and a location map.

## ⚡ Quick Start

```bash
git clone https://github.com/RolandoCutie/agenceTecnicalTest.git
cd agenceTecnicalTest
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

## 🎯 Implemented Features

- ✅ Login with Google/Facebook (Firebase Auth)
- ✅ 2-column product grid + lazy loading
- ✅ Drawer menu (Profile, My products, Settings, Logout)
- ✅ Detail page with map (OpenStreetMap) showing location
- ✅ Purchase modal with confirmation
- ✅ Clean Architecture + MobX

## 📦 Tech Stack

- Flutter 3.10+
- Firebase Auth (Google + Facebook)
- MobX (state management)
- flutter_map + geolocator (maps and location)
- Clean Architecture (domain/data/presentation)


## 📱 Structure

```
lib/features/
├── auth/         # Login with Firebase
├── products/     # List + detail with map
├── profile/      # Placeholder
└── settings/     # Placeholder
```

**Note:** I used OpenStreetMap instead of Google Maps to avoid paid API key setup. It works the same with no additional costs.

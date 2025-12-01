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

### Service Access Limitations (Google Maps / Facebook)

The original requirement requested Google Maps (Android/iOS) and real Facebook Login. Due to regional access restrictions (from Cuba) to:
- Google Cloud Console (API key provisioning for Maps)
- Meta Developers (Facebook App creation / credentials)

I implemented equivalent functionality using OpenStreetMap (`flutter_map`) + `geolocator` for user location and map rendering, and structured the authentication layer so Facebook can be fully enabled once valid App credentials are provided.

Current Map Features:
- User geolocation permission handling
- Centering on the user's position
- Marker + radius overlay

I can perform the migration immediately if provided valid API credentials.

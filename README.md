# WEBRTC-FLUTTER

[Description]

# Technical architecture components
- Clean Architecture
- State management: flutter_bloc
- Dependency injection: injectable, get_it
- Network: retrofit, dio

## Run
```
    flutter clean
    flutter pub get
    flutter packages pub run build_runner build --delete-conflicting-outputs
    flutter pub run easy_localization:generate -S "assets/translations" -O "lib/translations" -o "locale_keys.g.dart" -f keys 

    flutter run --flavor dev --dart-define=ENV_CONFIG=dev
    flutter run --flavor staging --dart-define=ENV_CONFIG=staging
    flutter run --flavor prod --dart-define=ENV_CONFIG=prod
```

### Overview
<img src="./architecture-proposal.png" style="display: block; margin-left: auto; margin-right: auto; width: 75%;"/>

### refer
1. Clean Architecture: https://github.com/ResoCoder/flutter-tdd-clean-architecture-course
2. Injectable: https://pub.dev/packages/injectable
3. Retrofit: https://pub.dev/packages/retrofit
4. Freezed: https://pub.dev/packages/freezed

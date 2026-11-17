# What The Banana

### Flutter SDK

Flutter stable 3.50.0을 사용합니다. FVM으로 프로젝트 SDK를 설치하고 실행하세요.

```zsh
fvm install
fvm flutter pub get
fvm flutter test
fvm flutter run
```

IDE의 Flutter SDK 경로는 `.fvm/flutter_sdk`로 설정하세요.


### build_runner commands
link: https://pub.dev/packages/build_runner
```zsh
fvm dart run build_runner build
```

### flutter_gen commands
link: https://pub.dev/packages/flutter_gen
```zsh
fluttergen -c pubspec.yaml
```

### easy_localization commands
link: https://pub.dev/packages/easy_localization
```zsh
fvm dart run easy_localization:generate --source-dir ./assets/translations
```

### oss_licenses commands
link: https://pub.dev/packages/flutter_oss_licenses
```zsh
fvm dart run flutter_oss_licenses:generate
```

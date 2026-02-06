# What The Banana (WTB) 프로젝트 분석 문서

## 프로젝트 개요

- **프로젝트명**: What The Banana (WTB)
- **현재 버전**: 1.0.15+15
- **SDK**: Flutter (Dart ^3.6.0)
- **설명**: 바나나 테마의 재미있는 멀티 기능 유틸리티 앱

## 기술 스택

### 프레임워크 및 코어 라이브러리
- **프레임워크**: Flutter with Material Design 3
- **상태 관리**: Flutter Riverpod (레거시 StateNotifier와 @riverpod 코드 생성 혼용)
- **라우팅**: GoRouter
- **로컬라이제이션**: easy_localization (EN, KO, JA, ZH 4개 언어 지원)
- **광고**: Google Mobile Ads (AdMob) - 배너, 전면, 네이티브, 오픈 앱 광고
- **백엔드**: Firebase (Firestore를 통한 피드백 저장)

### 코드 생성 도구
- build_runner
- riverpod_generator
- freezed
- flutter_gen
- json_serializable
- flutter_oss_licenses

### 린팅 및 품질 관리
- very_good_analysis

## 아키텍처

### 전체 구조
- 단일 모듈 Flutter 앱
- `lib/contents/` 하위에 기능 기반 디렉토리 구조
- StateNotifier 패턴을 통한 상태 관리 (레거시 Riverpod)
- 일부 프로바이더는 @riverpod 코드 생성 사용 (firestore_provider)
- routes.dart에서 GoRouter를 통한 중앙 집중식 라우트 정의

### 디렉토리 구조

```
lib/
├── main.dart              # 앱 진입점, 테마, 초기화
├── home_screen.dart       # 네비게이션 버튼이 있는 홈 스크린
├── routes.dart            # GoRouter 설정
├── consts.dart            # 상수 (개인정보 보호 정책 URL)
├── oss_licenses.dart      # 생성된 오픈소스 라이선스
├── common/                # 공유 유틸리티
│   ├── color_utils.dart   # 색상 조작 (getNegativeColor)
│   └── logger.dart        # 로깅 래퍼 (Log 클래스)
├── contents/              # 기능 모듈
│   ├── counter/           # 듀얼 카운터 기능
│   │   ├── counter_screen.dart
│   │   └── dual_counter_provider.dart
│   ├── ghost_leg/         # 사다리 타기 게임
│   │   ├── ghost_leg_screen.dart
│   │   ├── ghost_leg_state_provider.dart
│   │   ├── ghost_leg_result_view.dart
│   │   ├── ghost_leg_utils.dart
│   │   ├── ghost_leg_text_styles.dart
│   │   ├── input_number_view.dart
│   │   ├── input_text_view.dart
│   │   └── ladder_painter.dart
│   ├── pace_counter/      # 만보기 (숨김 기능)
│   │   ├── pace_counter_screen.dart
│   │   ├── pace_counter_service.dart
│   │   ├── pace_counter_state.dart
│   │   └── pace_counter_provider.dart
│   ├── pixel_art/         # 픽셀 아트 에디터
│   │   ├── pixel_art_screen.dart
│   │   ├── pixel_art_state.dart
│   │   ├── pixel_art_state_provider.dart
│   │   ├── pixel_canvas.dart
│   │   ├── pixel_painter.dart
│   │   └── crop_screen.dart
│   ├── qr_maker/          # QR 코드 생성기 (숨김 기능)
│   │   ├── qr_maker_screen.dart
│   │   ├── qr_state.dart
│   │   └── qr_state_provider.dart
│   └── roulette/          # 룰렛 스피너
│       ├── roulette_screen.dart
│       ├── roulette_state_provider.dart
│       ├── roulette_result_view.dart
│       ├── input_number_view.dart
│       └── input_text_view.dart
├── data/                  # 데이터 레이어
│   ├── firestore_provider.dart
│   └── firestore_provider.g.dart
├── etc/                   # 기타 스크린
│   ├── ads/               # 광고 스크린 (배너, 네이티브, 전면, 오픈 앱)
│   ├── creators_screen.dart
│   ├── donation/          # PayPal 후원
│   ├── feedback/          # Firebase 피드백
│   ├── introduction_screen.dart
│   ├── oss_licenses_view.dart
│   ├── select_language_screen.dart
│   └── updates_screen.dart
├── gen/                   # 생성된 코드 (flutter_gen)
│   ├── assets.gen.dart
│   ├── colors.gen.dart
│   └── fonts.gen.dart
├── generated/             # 생성된 코드 (easy_localization)
│   └── codegen_loader.g.dart
└── ui/                    # 공유 UI 컴포넌트
    ├── back_button.dart
    ├── banana_background.dart
    ├── marquee.dart
    ├── photo_hero.dart
    ├── rotate_image_painter.dart
    ├── single_rotating_banana.dart
    ├── single_rotating_image_painter.dart
    └── ui_utils.dart
```

## 주요 기능

### 1. 픽셀 아트 에디터
- 픽셀 아트 그리기
- 색상 선택기
- 이미지 공유
- 갤러리에서 이미지 가져오기
- 바나나 템플릿 제공

### 2. 룰렛
- 커스텀 항목으로 무작위 선택 휠
- 텍스트 입력 또는 숫자 범위 설정 가능

### 3. 사다리 타기
- 무작위 페어링을 위한 사다리 게임
- 커스텀 참가자 및 결과 입력
- 사다리 생성 및 애니메이션

### 4. 듀얼 카운터
- 양면 카운터
- 세로/가로 모드 지원
- 특별한 교회 모드 (예배 인원 카운트용)

### 5. QR 코드 생성기 (숨김 기능)
- QR 코드 생성 및 공유

### 6. 만보기 (숨김 기능)
- 걸음 수 카운터
- pedometer 패키지 사용

## 상태 관리 패턴

### 레거시 패턴
- `StateNotifier` + `StateNotifierProvider.autoDispose` 사용
- 적용 기능: counter, roulette, ghost_leg, pixel_art, qr_maker, pace_counter
- 수동 `copyWith()` 메서드 구현 (freezed 의존성이 있음에도 미사용)

### 모던 패턴
- `@riverpod` 코드 생성 사용
- 적용: firestore_provider
- 자동 생성된 프로바이더 코드

### 개선 사항 제안
- freezed를 활용한 불변 상태 클래스 생성 고려
- 레거시 StateNotifier를 @riverpod 코드 생성 방식으로 마이그레이션 고려

## 라우팅

### GoRouter 설정
- 모든 라우트가 Routes 클래스에 정적 상수로 정의됨
- 중첩 라우트 구조 사용
- 혼합된 네비게이션 방식: `context.go()`와 `Navigator.pop()`

### 주요 라우트
```dart
- /home                    # 홈 스크린
- /pixel-art              # 픽셀 아트 에디터
- /roulette               # 룰렛
- /ghost-leg              # 사다리 타기
- /counter                # 듀얼 카운터
- /qr-maker               # QR 생성기 (숨김)
- /pace-counter           # 만보기 (숨김)
- /creators               # 제작자 정보
- /donation               # 후원
- /feedback               # 피드백
- /introduction           # 소개
- /select-language        # 언어 선택
- /updates                # 업데이트 정보
- /oss-licenses           # 오픈소스 라이선스
```

## 로컬라이제이션

### 지원 언어
- 영어 (EN)
- 한국어 (KO)
- 일본어 (JA)
- 중국어 (ZH)

### 구현 방식
- easy_localization 패키지 사용
- JSON 번역 파일 위치: `assets/translations/`
- `.tr()` 확장 메서드를 통한 번역 접근
- 코드 생성을 통한 타입 안전성 확보

## 광고 통합

### AdMob 구현
- 다양한 광고 형식 지원:
  - 배너 광고
  - 전면 광고
  - 네이티브 광고
  - 오픈 앱 광고
- 플랫폼별 광고 유닛 ID 분리 (iOS/Android)
- 홈 스크린에 적응형 크기 배너 광고
- iOS App Tracking Transparency 권한 처리

### 광고 스크린
```
lib/etc/ads/
├── ad_banner_screen.dart           # 배너 광고 예제
├── ad_interstitial_screen.dart     # 전면 광고 예제
├── ad_native_screen.dart           # 네이티브 광고 예제
└── ad_open_app_screen.dart         # 오픈 앱 광고 예제
```

## 의존성

### 주요 의존성 (26개)
```yaml
flutter_riverpod: ^2.6.1          # 상태 관리
go_router: ^14.6.2                 # 라우팅
google_mobile_ads: ^6.0.0          # 광고
firebase_core: ^3.12.0             # Firebase 코어
cloud_firestore: ^5.6.0            # Firestore
easy_localization: ^3.0.7          # 로컬라이제이션
flutter_screenutil: ^5.9.3         # 반응형 UI
share_plus: ^10.1.3                # 공유 기능
image_picker: ^1.1.2               # 이미지 선택
crop_your_image: ^1.1.0            # 이미지 크롭
flutter_colorpicker: ^1.1.0        # 색상 선택
flutter_fortune_wheel: ^1.3.1      # 룰렛 휠
pedometer: ^4.0.2                  # 만보기
qr_flutter: ^4.1.0                 # QR 코드 생성
```

### 개발 의존성 (6개)
```yaml
build_runner: ^2.4.14              # 코드 생성 실행
riverpod_generator: ^3.0.2         # Riverpod 코드 생성
freezed: ^2.5.7                    # 불변 클래스 생성 (미사용)
flutter_gen_runner: ^5.8.0         # Asset 코드 생성
json_serializable: ^6.9.2          # JSON 직렬화
flutter_oss_licenses: ^3.0.3       # OSS 라이선스 생성
```

## Firebase 설정

### Firestore 사용
- 피드백 데이터 저장
- 프로바이더를 통한 접근: `firestoreProvider`
- 컬렉션: `feedbacks`

### 설정 파일
```
- firebase_options.dart            # 자동 생성된 Firebase 설정
- google-services.json             # Android Firebase 설정
- GoogleService-Info.plist         # iOS Firebase 설정
```

## UI/UX 특징

### 테마
- Material Design 3 사용
- 다크 모드 지원
- ColorScheme 기반 테마 시스템
- flutter_gen을 통한 타입 안전한 색상 접근

### 공통 UI 컴포넌트
```dart
- BananaBackground              # 바나나 배경 위젯
- SingleRotatingBanana          # 회전하는 바나나 애니메이션
- WTBMarquee                    # 흐르는 텍스트 효과
- WtbBackButton                 # 커스텀 뒤로가기 버튼
- PhotoHero                     # Hero 애니메이션 래퍼
```

### 반응형 디자인
- flutter_screenutil을 통한 화면 크기 대응
- 가로/세로 모드 지원 (특히 카운터 기능)

## 플랫폼별 설정

### iOS
- 최소 버전: iOS 13.0
- App Tracking Transparency 권한
- 카메라 및 사진 라이브러리 권한
- 동작 및 피트니스 권한 (만보기)

### Android
- 최소 SDK: 23 (Android 6.0)
- 타겟 SDK: 35 (Android 15)
- 컴파일 SDK: 35
- 인터넷, 카메라, 외부 저장소 권한
- 동작 인식 권한 (만보기)

## 빌드 및 배포

### 버전 관리
- 현재 버전: 1.0.15+15
- 버전 형식: `MAJOR.MINOR.PATCH+BUILD_NUMBER`

### 코드 생성 명령어
```bash
# Riverpod, Freezed, JSON Serializable 코드 생성
flutter pub run build_runner build --delete-conflicting-outputs

# Asset 코드 생성 (flutter_gen)
fluttergen

# OSS 라이선스 생성
flutter pub run flutter_oss_licenses:generate.dart
```

### 로컬라이제이션 코드 생성
```bash
flutter pub run easy_localization:generate -S assets/translations -f keys -o locale_keys.g.dart
```

## 개선 사항 및 기술 부채

### 상태 관리
1. **Freezed 미활용**: freezed 의존성이 있으나 실제로 사용하지 않음
   - 수동 `copyWith()` 구현 대신 @freezed 사용 고려
   - 불변성 보장 및 코드 간소화

2. **혼합된 Riverpod 패턴**: 레거시와 모던 패턴 혼재
   - 점진적으로 @riverpod 코드 생성 방식으로 마이그레이션 고려

### 라우팅
- 혼합된 네비게이션 방식 (`context.go()` vs `Navigator.pop()`)
- GoRouter의 일관된 사용 권장

### 코드 구조
- 일부 기능이 "숨김" 처리됨 (qr_maker, pace_counter)
- 사용하지 않는 기능은 제거 또는 명확한 이유 문서화 필요

### 테스트
- 현재 테스트 코드 없음
- 단위 테스트, 위젯 테스트 추가 권장

## 프로젝트 강점

1. **명확한 기능 분리**: contents/ 하위 기능별 모듈화
2. **다국어 지원**: 4개 언어 지원으로 글로벌 대응
3. **광고 수익화**: 다양한 AdMob 광고 형식 통합
4. **Firebase 연동**: 피드백 수집 인프라
5. **코드 생성 활용**: flutter_gen, riverpod_generator 등 활용
6. **린팅**: very_good_analysis를 통한 코드 품질 관리

## 향후 개선 방향

1. **상태 관리 현대화**
   - 모든 StateNotifier를 @riverpod 방식으로 마이그레이션
   - Freezed 적극 활용

2. **테스트 커버리지**
   - 단위 테스트 작성
   - 위젯 테스트 작성
   - 통합 테스트 고려

3. **라우팅 일관성**
   - GoRouter 패턴 통일
   - 딥링크 지원 고려

4. **성능 최적화**
   - 불필요한 리빌드 최소화
   - 이미지 캐싱 전략
   - 번들 크기 최적화

5. **접근성**
   - Semantics 위젯 추가
   - 스크린 리더 지원

6. **문서화**
   - 각 기능별 README 작성
   - API 문서 생성
   - 아키텍처 다이어그램

## 결론

What The Banana는 Flutter 기반의 잘 구조화된 멀티 기능 유틸리티 앱입니다. 명확한 기능 분리, 다국어 지원, 광고 수익화 전략이 잘 구현되어 있으며, 일부 기술 부채(Freezed 미활용, 혼합된 상태 관리 패턴)가 있으나 점진적 개선이 가능한 상태입니다. 테스트 커버리지 추가와 상태 관리 현대화를 통해 유지보수성을 더욱 향상시킬 수 있습니다.

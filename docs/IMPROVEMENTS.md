# What The Banana 개선 제안서

이 문서는 What The Banana 프로젝트의 코드베이스 분석을 통해 도출된 개선 사항들을 정리한 것입니다.

---

## 목차

1. [State Management Migration (상태 관리 마이그레이션)](#1-state-management-migration-상태-관리-마이그레이션)
2. [Freezed 활용 부재](#2-freezed-활용-부재)
3. [코드 중복](#3-코드-중복)
4. [PageController 라이프사이클 문제](#4-pagecontroller-라이프사이클-문제)
5. [테스트 부재](#5-테스트-부재)
6. [에러 핸들링 부족](#6-에러-핸들링-부족)
7. [.env 파일 보안](#7-env-파일-보안)
8. [위젯 메서드 대신 위젯 클래스 사용](#8-위젯-메서드-대신-위젯-클래스-사용)
9. [하드코딩된 문자열](#9-하드코딩된-문자열)
10. [네비게이션 혼용](#10-네비게이션-혼용)
11. [숨겨진 기능 정리](#11-숨겨진-기능-정리)
12. [분석 옵션 완화](#12-분석-옵션-완화)
13. [접근성](#13-접근성)

---

## 1. State Management Migration (상태 관리 마이그레이션)

**우선순위: 🔴 높음**

### 현재 상태
프로젝트가 `flutter_riverpod/legacy.dart`의 레거시 API를 사용하고 있습니다:
- `StateNotifier` + `StateNotifierProvider`
- 수동 provider 정의

### 문제점
- Legacy API는 향후 deprecated 예정
- 타입 안전성 부족
- 자동 dispose 미지원
- 보일러플레이트 코드 증가

### 영향 범위
- `lib/dual_counter/dual_counter_provider.dart`
- `lib/roulette/roulette_state_provider.dart`
- `lib/ghost_leg/ghost_leg_state_provider.dart`
- `lib/pixel_art/pixel_art_state_provider.dart`

### 제안 사항
이미 프로젝트에 `riverpod_annotation`과 `riverpod_generator`가 dev dependency로 설정되어 있으므로, codegen 방식으로 마이그레이션하세요.

**현재 코드 예시:**
```dart
// dual_counter_provider.dart
final dualCounterProvider = StateNotifierProvider<DualCounterNotifier, DualCounterState>(
  (ref) => DualCounterNotifier(),
);

class DualCounterNotifier extends StateNotifier<DualCounterState> {
  DualCounterNotifier() : super(DualCounterState.initial());

  void incrementFirst() {
    state = state.copyWith(firstCount: state.firstCount + 1);
  }
}
```

**개선된 코드:**
```dart
// dual_counter_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dual_counter_provider.g.dart';

@riverpod
class DualCounter extends _$DualCounter {
  @override
  DualCounterState build() => DualCounterState.initial();

  void incrementFirst() {
    state = state.copyWith(firstCount: state.firstCount + 1);
  }
}
```

### 마이그레이션 단계
1. 각 provider 파일에 `@riverpod` 어노테이션 추가
2. `build_runner` 실행: `flutter pub run build_runner build --delete-conflicting-outputs`
3. 사용처에서 `ref.watch(dualCounterProvider)` → `ref.watch(dualCounterProvider)` (자동 생성된 provider)
4. 모든 테스트 통과 확인

---

## 2. Freezed 활용 부재

**우선순위: 🟡 중간**

### 현재 상태
State 클래스들이 수동으로 `copyWith()` 메서드를 구현하고 있습니다:
- `PixelArtState`
- `DualCounterState`
- `RouletteState`
- `GhostLegState`

### 문제점
- 수동 `copyWith()` 구현의 보일러플레이트 코드
- 실수로 인한 버그 가능성 (필드 누락 등)
- `==` 연산자와 `hashCode` 누락으로 비교 불가능
- JSON serialization 수동 구현 필요

### 제안 사항
`freezed_annotation`이 이미 dependency에 있으므로 Freezed를 활용하세요.

**현재 코드 예시:**
```dart
class DualCounterState {
  final int firstCount;
  final int secondCount;
  final bool isFirstVertical;
  final bool isSecondVertical;

  DualCounterState({
    required this.firstCount,
    required this.secondCount,
    required this.isFirstVertical,
    required this.isSecondVertical,
  });

  DualCounterState copyWith({
    int? firstCount,
    int? secondCount,
    bool? isFirstVertical,
    bool? isSecondVertical,
  }) {
    return DualCounterState(
      firstCount: firstCount ?? this.firstCount,
      secondCount: secondCount ?? this.secondCount,
      isFirstVertical: isFirstVertical ?? this.isFirstVertical,
      isSecondVertical: isSecondVertical ?? this.isSecondVertical,
    );
  }
}
```

**개선된 코드:**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dual_counter_state.freezed.dart';
part 'dual_counter_state.g.dart';

@freezed
class DualCounterState with _$DualCounterState {
  const factory DualCounterState({
    required int firstCount,
    required int secondCount,
    required bool isFirstVertical,
    required bool isSecondVertical,
  }) = _DualCounterState;

  factory DualCounterState.fromJson(Map<String, dynamic> json) =>
      _$DualCounterStateFromJson(json);

  factory DualCounterState.initial() => const DualCounterState(
    firstCount: 0,
    secondCount: 0,
    isFirstVertical: false,
    isSecondVertical: false,
  );
}
```

### 이점
- 자동 `copyWith()` 생성
- 자동 `==`, `hashCode`, `toString()` 구현
- JSON serialization 지원
- Union types 지원 (로딩/성공/실패 상태 모델링)
- 타입 안전성 향상

---

## 3. 코드 중복

**우선순위: 🟡 중간**

### 3.1 Counter Screen의 중복

**파일:** `lib/dual_counter/counter_screen.dart`

**문제점:**
- `FirstCounter` / `SecondCounter` (각 ~250 라인)
- `FirstVerticalCounter` / `SecondVerticalCounter` (각 ~250 라인)
- 거의 동일한 로직과 UI 구조

**제안:**
공통 `CounterWidget` 추출

```dart
class CounterWidget extends StatelessWidget {
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onReset;
  final bool isVertical;
  final String label; // "First" or "Second"

  const CounterWidget({
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
    required this.onReset,
    required this.isVertical,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // 공통 UI 로직
  }
}

// 사용처
CounterWidget(
  count: state.firstCount,
  onIncrement: () => ref.read(dualCounterProvider.notifier).incrementFirst(),
  onDecrement: () => ref.read(dualCounterProvider.notifier).decrementFirst(),
  onReset: () => ref.read(dualCounterProvider.notifier).resetFirst(),
  isVertical: state.isFirstVertical,
  label: 'First',
)
```

### 3.2 Input Number View 중복

**파일:**
- `lib/ghost_leg/input_number_view.dart`
- `lib/roulette/input_number_view.dart`

**문제점:**
동일한 역할의 중복 위젯

**제안:**
공통 위젯을 `lib/common/widgets/` 디렉토리로 이동

```dart
// lib/common/widgets/input_number_view.dart
class InputNumberView extends StatelessWidget {
  final int currentNumber;
  final ValueChanged<int> onNumberChanged;
  final VoidCallback onNext;

  // ... 공통 구현
}
```

### 3.3 Input Text View 중복

**파일:**
- `lib/ghost_leg/input_text_view.dart`
- `lib/roulette/input_text_view.dart`

**제안:**
동일하게 공통 위젯으로 통합

---

## 4. PageController 라이프사이클 문제

**우선순위: 🔴 높음**

### 현재 상태
`RouletteState`와 `GhostLegState`에서 `PageController`가 state 클래스 내부에 정의되어 있습니다.

**문제 코드:**
```dart
class RouletteState {
  final PageController pageController = PageController();
  final int currentPage;
  // ...

  RouletteState copyWith({int? currentPage}) {
    return RouletteState(
      currentPage: currentPage ?? this.currentPage,
    ); // 새로운 PageController가 생성됨!
  }
}
```

### 문제점
1. **메모리 누수:** `copyWith()`로 새 state를 만들 때마다 새 `PageController` 생성
2. **애니메이션 끊김:** 이전 controller가 폐기되어 진행 중인 애니메이션이 중단됨
3. **dispose 누락:** 이전 controller가 dispose되지 않음

### 제안 사항

**옵션 1: Screen의 State에서 관리 (권장)**
```dart
class RouletteScreenState extends ConsumerStatefulWidget {
  @override
  ConsumerState<RouletteScreenState> createState() => _RouletteScreenState();
}

class _RouletteScreenState extends ConsumerState<RouletteScreenState> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rouletteStateProvider);

    return PageView(
      controller: _pageController,
      onPageChanged: (page) {
        ref.read(rouletteStateProvider.notifier).setPage(page);
      },
      // ...
    );
  }
}
```

**옵션 2: 별도 Provider로 관리**
```dart
@riverpod
class RoulettePageController extends _$RoulettePageController {
  @override
  PageController build() {
    final controller = PageController();
    ref.onDispose(controller.dispose);
    return controller;
  }
}

// 사용처
final pageController = ref.watch(roulettePageControllerProvider);
```

---

## 5. 테스트 부재

**우선순위: 🔴 높음**

### 현재 상태
- `test/widget_test.dart`에 기본 Flutter 템플릿 테스트만 존재
- 실제로는 동작하지 않음 (MyApp이 Firebase 초기화 필요)
- 0% 테스트 커버리지

### 제안 사항

### 5.1 Unit Tests

**State Notifier 테스트:**
```dart
// test/dual_counter/dual_counter_provider_test.dart
void main() {
  group('DualCounterNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is zero counts', () {
      final state = container.read(dualCounterProvider);
      expect(state.firstCount, 0);
      expect(state.secondCount, 0);
    });

    test('incrementFirst increases firstCount', () {
      container.read(dualCounterProvider.notifier).incrementFirst();
      final state = container.read(dualCounterProvider);
      expect(state.firstCount, 1);
      expect(state.secondCount, 0);
    });

    test('resetFirst sets firstCount to zero', () {
      container.read(dualCounterProvider.notifier)
        ..incrementFirst()
        ..incrementFirst()
        ..resetFirst();
      expect(container.read(dualCounterProvider).firstCount, 0);
    });
  });
}
```

**Utility 함수 테스트:**
```dart
// test/utils/color_utils_test.dart
void main() {
  group('ColorUtils', () {
    test('generateRandomColor returns valid color', () {
      final color = ColorUtils.generateRandomColor();
      expect(color.value, isNonNegative);
    });

    test('hexToColor converts hex string correctly', () {
      final color = ColorUtils.hexToColor('#FF5733');
      expect(color, const Color(0xFFFF5733));
    });
  });
}
```

### 5.2 Widget Tests

```dart
// test/dual_counter/counter_screen_test.dart
void main() {
  testWidgets('Counter increments when + button is pressed', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: CounterScreen(),
        ),
      ),
    );

    // Find increment button
    final incrementButton = find.byIcon(Icons.add);
    expect(incrementButton, findsWidgets);

    // Tap and verify
    await tester.tap(incrementButton.first);
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
  });
}
```

### 5.3 Integration Tests

```dart
// integration_test/app_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Navigate from home to counter screen', (tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    // Tap counter navigation button
    final counterButton = find.text('카운터');
    await tester.tap(counterButton);
    await tester.pumpAndSettle();

    // Verify navigation
    expect(find.byType(CounterScreen), findsOneWidget);
  });
}
```

### 테스트 실행 설정

**추가할 dev_dependencies:**
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  mockito: ^5.4.0
  build_runner: ^2.4.0
```

---

## 6. 에러 핸들링 부족

**우선순위: 🟡 중간**

### 6.1 Firestore Provider

**현재 코드:**
```dart
// lib/common/provider/firestore_provider.dart
try {
  // Firestore operations
} catch (e) {
  debugPrint('Error: $e');
  // 사용자에게 피드백 없음
}
```

**문제점:**
- Exception이 catch되지만 사용자에게 알림 없음
- 에러 상태 관리 부재

**제안:**
```dart
@riverpod
class FirestoreService extends _$FirestoreService {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> addFeedback(String feedback) async {
    state = const AsyncValue.loading();

    try {
      await firestore.collection('feedback').add({
        'content': feedback,
        'timestamp': FieldValue.serverTimestamp(),
      });
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow; // UI에서 처리할 수 있도록
    }
  }
}
```

### 6.2 Feedback Screen

**현재 코드:**
```dart
// lib/feedback/feedback_screen.dart
Future<void> sendFeedback() async {
  try {
    await firestoreService.addFeedback(feedbackText);
    // 성공 시 피드백 없음
  } catch (e) {
    // 실패 시 피드백 없음
  }
}
```

**제안:**
```dart
Future<void> sendFeedback() async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  try {
    await ref.read(firestoreServiceProvider.notifier).addFeedback(feedbackText);

    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text('피드백이 전송되었습니다. 감사합니다!'),
        backgroundColor: Colors.green,
      ),
    );

    if (mounted) Navigator.pop(context);
  } catch (e) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text('전송 실패: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
```

### 6.3 Pixel Art Provider

**현재 코드:**
```dart
Future<void> shareImage() async {
  // 에러 처리 없음
  final imageBytes = await controller.captureFromWidget(widget);
  await Share.shareXFiles([XFile.fromData(imageBytes)]);
}
```

**제안:**
```dart
Future<void> shareImage() async {
  try {
    state = state.copyWith(isLoading: true);
    final imageBytes = await controller.captureFromWidget(widget);
    await Share.shareXFiles([XFile.fromData(imageBytes)]);
  } on PlatformException catch (e) {
    // 플랫폼별 에러 처리
    debugPrint('Share failed: ${e.message}');
    rethrow;
  } catch (e) {
    debugPrint('Unexpected error: $e');
    rethrow;
  } finally {
    state = state.copyWith(isLoading: false);
  }
}
```

---

## 7. .env 파일 보안

**우선순위: 🔴 높음**

### 현재 상태
- `.env` 파일이 `assets/config/.env`에 위치
- `.gitignore`에 `.env`가 있지만 `assets/config/.env`는 추적될 수 있음
- 민감한 정보가 앱 번들에 포함됨

### 문제점
1. APK/IPA 디컴파일 시 환경 변수 노출 가능
2. 공개 저장소에 실수로 커밋될 위험
3. 빌드 환경별 설정 관리 어려움

### 제안 사항

**옵션 1: --dart-define 사용 (권장)**

**1단계:** `.env` 파일을 Git에서 제외
```bash
# .gitignore
assets/config/.env
.env
.env.*
```

**2단계:** `.env.example` 파일 생성
```bash
# assets/config/.env.example
ADMOB_ANDROID_APP_ID=ca-app-pub-XXXXXXXXXX~YYYYYYYYYY
ADMOB_IOS_APP_ID=ca-app-pub-XXXXXXXXXX~YYYYYYYYYY
```

**3단계:** 빌드 시 환경 변수 주입
```bash
# Build script
flutter build apk \
  --dart-define=ADMOB_ANDROID_APP_ID=ca-app-pub-xxx \
  --dart-define=ADMOB_IOS_APP_ID=ca-app-pub-yyy
```

**4단계:** 코드에서 사용
```dart
class Environment {
  static const admobAndroidAppId = String.fromEnvironment(
    'ADMOB_ANDROID_APP_ID',
    defaultValue: '',
  );

  static const admobIosAppId = String.fromEnvironment(
    'ADMOB_IOS_APP_ID',
    defaultValue: '',
  );
}
```

**옵션 2: Flutter Flavors**

개발/스테이징/프로덕션 환경 분리:
```dart
// lib/config/environment.dart
enum Flavor { dev, staging, prod }

class Environment {
  static Flavor? _flavor;

  static Flavor get flavor => _flavor ?? Flavor.dev;

  static String get admobAppId {
    switch (flavor) {
      case Flavor.dev:
        return 'ca-app-pub-3940256099942544~3347511713'; // Test ID
      case Flavor.staging:
        return const String.fromEnvironment('ADMOB_STAGING_ID');
      case Flavor.prod:
        return const String.fromEnvironment('ADMOB_PROD_ID');
    }
  }
}
```

---

## 8. 위젯 메서드 대신 위젯 클래스 사용

**우선순위: 🟡 중간**

### 현재 상태
여러 곳에서 메서드로 위젯을 반환하는 패턴 사용:

**문제 코드:**
```dart
class CounterScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        BottomAdView(),
        FirstCounter(),
      ],
    );
  }

  Widget BottomAdView() {
    return Container(
      // ... 광고 뷰
    );
  }

  Widget FirstCounter() {
    return Container(
      // ... 카운터 UI (250+ 라인)
    );
  }
}
```

### 문제점
1. **성능 이슈:** Flutter는 위젯 클래스 단위로 rebuild를 최적화하는데, 메서드는 이 혜택을 받지 못함
2. **Key 사용 불가:** 위젯 메서드는 key를 받을 수 없어 상태 보존 어려움
3. **Hot Reload 제한:** 클래스 위젯은 hot reload가 더 잘 작동
4. **디버깅 어려움:** DevTools의 위젯 트리에서 구분이 어려움

### 제안 사항

**개선된 코드:**
```dart
class CounterScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const BottomAdView(),
        FirstCounter(
          count: ref.watch(dualCounterProvider).firstCount,
          onIncrement: () => ref.read(dualCounterProvider.notifier).incrementFirst(),
        ),
      ],
    );
  }
}

class BottomAdView extends StatelessWidget {
  const BottomAdView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // ... 광고 뷰
    );
  }
}

class FirstCounter extends StatelessWidget {
  final int count;
  final VoidCallback onIncrement;

  const FirstCounter({
    required this.count,
    required this.onIncrement,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // ... 카운터 UI
    );
  }
}
```

### 적용 대상
- `lib/home/home_screen.dart`: `BottomAdView()`
- `lib/dual_counter/counter_screen.dart`: `FirstCounter()`, `SecondCounter()`, `FirstVerticalCounter()`, `SecondVerticalCounter()`

---

## 9. 하드코딩된 문자열

**우선순위: 🟠 낮음**

### 현재 상태
UI에 하드코딩된 한국어/영어 문자열이 다수 존재:

```dart
// counter_screen.dart
Text('아바드\n(27-)'),
Text('파카드\n(20-26)'),
Text('처음 왔어요'),
Text('평화교회 청년부 카운터'),

// home_screen.dart
Text('DOWN, DOWN'),
Text('HELLO'),
Text('GOOD LUCK'),
```

### 문제점
1. 다국어 지원 불가
2. 문자열 관리 어려움 (일괄 수정 불가)
3. 오타 검증 어려움

### 제안 사항

**1단계:** `flutter_localizations` 패키지 추가

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.0
```

**2단계:** ARB 파일 생성

```json
// lib/l10n/app_ko.arb
{
  "@@locale": "ko",
  "counterTitle": "평화교회 청년부 카운터",
  "abad": "아바드\n(27-)",
  "pacad": "파카드\n(20-26)",
  "firstTime": "처음 왔어요",
  "homeGreeting": "HELLO",
  "goodLuck": "GOOD LUCK"
}
```

```json
// lib/l10n/app_en.arb
{
  "@@locale": "en",
  "counterTitle": "Peace Church Youth Counter",
  "abad": "Abad\n(27-)",
  "pacad": "Pacad\n(20-26)",
  "firstTime": "First Time",
  "homeGreeting": "HELLO",
  "goodLuck": "GOOD LUCK"
}
```

**3단계:** 코드에서 사용

```dart
// Before
Text('평화교회 청년부 카운터'),

// After
Text(AppLocalizations.of(context)!.counterTitle),
```

**4단계:** `pubspec.yaml` 설정

```yaml
flutter:
  generate: true

# l10n.yaml 파일 생성
arb-dir: lib/l10n
template-arb-file: app_ko.arb
output-localization-file: app_localizations.dart
```

---

## 10. 네비게이션 혼용

**우선순위: 🟠 낮음**

### 현재 상태
GoRouter와 Navigator API가 혼용되고 있습니다:

```dart
// GoRouter 사용
context.go('/counter');
context.go('/roulette');

// Navigator 사용
Navigator.pop(context);
Navigator.push(context, MaterialPageRoute(...));
```

### 문제점
1. 일관성 부족
2. 딥링크/웹 URL 처리 시 예측 불가능
3. 라우팅 로직 파악 어려움

### 제안 사항

**GoRouter로 통일:**

```dart
// lib/common/router/app_router.dart
final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/counter',
      builder: (context, state) => const CounterScreen(),
    ),
    GoRoute(
      path: '/roulette',
      builder: (context, state) => const RouletteScreen(),
    ),
    // Dialog 라우트
    GoRoute(
      path: '/feedback',
      pageBuilder: (context, state) => DialogPage(
        builder: (_) => const FeedbackDialog(),
      ),
    ),
  ],
);

// 사용처
context.go('/counter');        // 페이지 이동
context.push('/feedback');     // 다이얼로그 열기
context.pop();                 // 뒤로가기 (통일된 API)
```

**Custom Transitions:**
```dart
GoRoute(
  path: '/pixel-art',
  pageBuilder: (context, state) => CustomTransitionPage(
    child: const PixelArtScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  ),
)
```

---

## 11. 숨겨진 기능 정리

**우선순위: 🟠 낮음**

### 현재 상태
`home_screen.dart`에서 QR Maker와 Pace Counter가 주석 처리로 숨겨져 있습니다:

```dart
// QR Maker
// MenuButton(
//   size: size,
//   image: 'qrMaker',
//   destination: () => context.go('/qr-maker'),
// ),

// Pace Counter
// MenuButton(
//   size: size,
//   image: 'pace_counter',
//   destination: () => context.go('/pace-counter'),
// ),
```

### 문제점
1. Dead code로 남아있어 혼란
2. 향후 활성화 여부 불명확
3. 관련 코드가 여전히 프로젝트에 존재

### 제안 사항

**옵션 1: Feature Flag 시스템**

```dart
// lib/config/feature_flags.dart
class FeatureFlags {
  static const bool enableQRMaker = bool.fromEnvironment(
    'ENABLE_QR_MAKER',
    defaultValue: false,
  );

  static const bool enablePaceCounter = bool.fromEnvironment(
    'ENABLE_PACE_COUNTER',
    defaultValue: false,
  );
}

// home_screen.dart
if (FeatureFlags.enableQRMaker)
  MenuButton(
    size: size,
    image: 'qrMaker',
    destination: () => context.go('/qr-maker'),
  ),
```

**빌드 시 활성화:**
```bash
flutter build apk --dart-define=ENABLE_QR_MAKER=true
```

**옵션 2: Remote Config (Firebase)**

```dart
// lib/config/remote_config.dart
class RemoteFeatureFlags {
  static final RemoteConfig _remoteConfig = RemoteConfig.instance;

  static Future<void> initialize() async {
    await _remoteConfig.setDefaults({
      'enable_qr_maker': false,
      'enable_pace_counter': false,
    });
    await _remoteConfig.fetchAndActivate();
  }

  static bool get enableQRMaker => _remoteConfig.getBool('enable_qr_maker');
  static bool get enablePaceCounter => _remoteConfig.getBool('enable_pace_counter');
}
```

**옵션 3: 완전 제거**

사용하지 않을 기능이라면:
1. 관련 스크린 파일 삭제
2. 라우트 정의 제거
3. 의존성 정리
4. 에셋 파일 삭제

---

## 12. 분석 옵션 완화

**우선순위: 🟠 낮음**

### 현재 상태
`analysis_options.yaml`에서 많은 lint rule이 비활성화되어 있습니다:

```yaml
linter:
  rules:
    avoid_print: false
    unawaited_futures: false
    lines_longer_than_80_chars: false
    prefer_const_constructors: false
    use_build_context_synchronously: false
```

### 문제점
1. 잠재적 버그를 놓칠 수 있음 (`unawaited_futures`)
2. 코드 품질 저하 (`prefer_const_constructors`)
3. 비동기 오류 가능성 (`use_build_context_synchronously`)

### 제안 사항

**점진적 개선 전략:**

**1단계: 위험한 rule 활성화**
```yaml
linter:
  rules:
    # 높은 우선순위
    unawaited_futures: true          # 미대기 Future 경고
    use_build_context_synchronously: true  # async 후 context 사용 경고

    # 중간 우선순위
    prefer_const_constructors: true  # 성능 개선
    avoid_print: true                # debugPrint 사용 권장

    # 낮은 우선순위
    lines_longer_than_80_chars: false  # 현대적 개발 환경에서는 선택적
```

**2단계: 코드 수정**

**unawaited_futures 수정:**
```dart
// Before (경고 없음)
void onButtonPressed() {
  someAsyncOperation(); // Fire and forget
}

// After
void onButtonPressed() {
  unawaited(someAsyncOperation()); // 명시적으로 의도 표현
  // 또는
  someAsyncOperation().ignore(); // ignore 사용
}
```

**use_build_context_synchronously 수정:**
```dart
// Before (위험)
Future<void> deleteItem() async {
  await deleteFromDatabase();
  Navigator.pop(context); // context가 여전히 유효한지 불명확
}

// After (안전)
Future<void> deleteItem() async {
  await deleteFromDatabase();
  if (mounted) {
    Navigator.pop(context);
  }
}
```

**prefer_const_constructors 수정:**
```dart
// Before
return Container(
  padding: EdgeInsets.all(16),
  child: Text('Hello'),
);

// After (rebuild 성능 향상)
return Container(
  padding: const EdgeInsets.all(16),
  child: const Text('Hello'),
);
```

**3단계: CI/CD 통합**
```yaml
# .github/workflows/flutter.yml
- name: Analyze code
  run: flutter analyze --fatal-infos
```

---

## 13. 접근성

**우선순위: 🟡 중간**

### 현재 상태
대부분의 인터랙티브 요소가 `GestureDetector`를 사용하고 Semantics 정보가 누락되어 있습니다.

### 문제점
1. 스크린 리더 사용자가 버튼 기능 파악 불가
2. TalkBack/VoiceOver 지원 부족
3. 접근성 테스트 실패 가능

### 영향 받는 위젯
- 카운터 증감 버튼
- 룰렛 회전 버튼
- 메뉴 버튼들

### 제안 사항

**Before:**
```dart
GestureDetector(
  onTap: () => increment(),
  child: Container(
    child: Icon(Icons.add),
  ),
)
```

**After - 옵션 1: Semantics 추가**
```dart
Semantics(
  label: '카운트 증가',
  button: true,
  enabled: true,
  onTap: () => increment(),
  child: GestureDetector(
    onTap: () => increment(),
    child: Container(
      child: const Icon(Icons.add),
    ),
  ),
)
```

**After - 옵션 2: Material 위젯 사용 (권장)**
```dart
IconButton(
  icon: const Icon(Icons.add),
  tooltip: '카운트 증가',
  onPressed: () => increment(),
)

// 또는
InkWell(
  onTap: () => increment(),
  child: Ink(
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: const Icon(Icons.add),
    ),
  ),
)
```

**After - 옵션 3: Custom Semantic Button**
```dart
// lib/common/widgets/semantic_button.dart
class SemanticButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Widget child;

  const SemanticButton({
    required this.label,
    required this.onTap,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      enabled: true,
      child: InkWell(
        onTap: onTap,
        child: child,
      ),
    );
  }
}
```

### 접근성 테스트

```dart
testWidgets('Counter buttons have proper semantics', (tester) async {
  await tester.pumpWidget(const CounterScreen());

  // Semantics가 제대로 설정되었는지 확인
  final semantics = tester.getSemantics(find.byType(IconButton).first);
  expect(semantics.label, '카운트 증가');
  expect(semantics.hasAction(SemanticsAction.tap), true);
});
```

### 추가 접근성 개선 사항

**1. 텍스트 대비율 확인:**
```dart
// 낮은 대비율 (피하기)
Text(
  'Counter',
  style: TextStyle(color: Colors.grey[400]),
)

// 높은 대비율 (권장: WCAG AA 기준 4.5:1)
Text(
  'Counter',
  style: TextStyle(color: Colors.grey[800]),
)
```

**2. 최소 터치 영역:**
```dart
// Material Design: 최소 48x48
SizedBox(
  width: 48,
  height: 48,
  child: IconButton(
    icon: const Icon(Icons.add),
    onPressed: () {},
  ),
)
```

**3. 스크린 리더 지원:**
```dart
Semantics(
  label: '현재 카운트: $count',
  readOnly: true,
  child: Text('$count'),
)
```

---

## 우선순위 요약

### 🔴 즉시 해결 필요 (높음)
1. **State Management Migration** - Legacy API 제거 예정
2. **PageController 라이프사이클** - 메모리 누수 위험
3. **테스트 부재** - 품질 보증 불가
4. **.env 파일 보안** - 보안 위험

### 🟡 계획적 개선 (중간)
5. **Freezed 활용** - 개발 생산성 향상
6. **코드 중복** - 유지보수성 개선
7. **에러 핸들링** - 사용자 경험 개선
8. **위젯 메서드 → 클래스** - 성능 최적화
9. **접근성** - 사용자 범위 확대

### 🟠 시간 여유 시 (낮음)
10. **하드코딩 문자열** - 다국어 준비
11. **네비게이션 통일** - 코드 일관성
12. **숨겨진 기능 정리** - 코드 정리
13. **분석 옵션** - 코드 품질 향상

---

## 다음 단계

1. **우선순위 높은 항목부터 시작**: State Management Migration과 PageController 문제부터 해결
2. **브랜치 전략 수립**: 각 개선 사항을 별도 브랜치에서 작업
3. **점진적 개선**: 한 번에 모든 것을 바꾸지 말고 단계적으로 적용
4. **테스트 작성**: 변경 사항마다 테스트 추가로 회귀 방지
5. **문서화**: 변경 사항을 `CHANGELOG.md`에 기록

---

**마지막 업데이트:** 2026-02-07
**작성자:** oh-my-claudecode executor
**버전:** 1.0.0

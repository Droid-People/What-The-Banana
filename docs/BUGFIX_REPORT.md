# What The Banana - 버그 수정 리포트

> 작성일: 2026-04-12

## 수정 완료된 버그 (1차 - 리소스 누수 & 디버그 코드)

### 1. CounterScreen TextEditingController 메모리 누수
- **파일:** `lib/contents/counter/counter_screen.dart`
- **문제:** `leftTextController`, `rightTextController` 2개의 TextEditingController가 `dispose()` 되지 않아 메모리 누수 발생
- **수정:** `dispose()` 메서드 추가하여 컨트롤러 해제

### 2. HomeScreen 리소스 누수
- **파일:** `lib/home_screen.dart`
- **문제:** `BannerAd`와 `ScrollController`가 `dispose()` 되지 않음
- **수정:** `dispose()` 메서드 추가하여 광고 객체 및 스크롤 컨트롤러 해제

### 3. pace_counter_service 로깅 불일치
- **파일:** `lib/contents/pace_counter/pace_counter_service.dart`
- **문제:** 프로젝트 전체가 `Log` 클래스를 사용하는데 이 파일만 `print()` 사용
- **수정:** `print()` → `Log.e()`로 변경하여 로깅 일관성 확보

### 4. admob_ids 불필요한 디버그 코드
- **파일:** `lib/etc/ads/admob_ids.dart`
- **문제:** `getInterstitialAdId()` iOS 디버그 분기에 불필요한 `print()` 잔재
- **수정:** 해당 `print()` 제거

## 수정 완료된 버그 (2차 - 잔존 이슈 일괄 수정)

### 5. UpdatesScreen JSON 파싱 에러 핸들링 부재
- **파일:** `lib/etc/updates_screen.dart`
- **문제:** `rootBundle.load()`, `jsonDecode()`에서 예외 발생 시 앱 크래시 가능
- **수정:** try-catch 에러 핸들링 추가, 개별 파일 실패 시 건너뛰기

### 6. Navigator.pop() / context.pop() 혼용
- **파일:** `updates_screen.dart`, `open_app_ad_screen.dart`, `native_ad_screen.dart`, `interstitial_ad_screen.dart`
- **문제:** GoRouter 프로젝트에서 `Navigator.of(context).pop()` 혼용
- **수정:** 화면 이동용 pop을 `context.pop()`으로 통일 (다이얼로그 dismiss는 Navigator.pop 유지)

### 7. FeedbackScreen 하드코딩 영어 문자열
- **파일:** `lib/etc/feedback/feedback_screen.dart`
- **문제:** SnackBar 메시지가 영어로 하드코딩 ('Please enter your feedback', 'Failed to send...')
- **수정:** 번역 키 `feedback_empty_error`, `feedback_send_error` 사용 (4개 언어 이미 번역 파일에 존재)

### 8. FeedbackScreen TextEditingController 메모리 누수
- **파일:** `lib/etc/feedback/feedback_screen.dart`
- **문제:** `_feedbackController`가 `dispose()` 되지 않음
- **수정:** `dispose()` 메서드 추가

### 9. NativeAdScreen dispose 순서 오류
- **파일:** `lib/etc/ads/native_ad_screen.dart`
- **문제:** `super.dispose()`가 `_nativeAd?.dispose()` 전에 호출됨
- **수정:** `super.dispose()`를 마지막으로 이동

---

## 미수정 잔존 이슈

### HIGH 우선순위

| 이슈 | 파일/위치 | 설명 |
|------|-----------|------|
| PayPal 키 git history 노출 | `.env` (현재 `.gitignore`에 포함) | `.gitignore`로 추적은 막혔지만 과거 커밋에 키가 남아있을 수 있음. **키 로테이션 권장** |
| dotenv 미사용 | `main.dart:18` | `dotenv.load()` 주석 처리. DonationScreen이 "Not ready" 상태이므로 현재 문제 없음 |

### MEDIUM 우선순위

| 이슈 | 파일/위치 | 설명 |
|------|-----------|------|
| StateNotifier 레거시 API | 대부분의 Provider 파일 | Riverpod v3에서 deprecated. `@riverpod` 코드 생성으로 마이그레이션 필요 |
| freezed 미사용 | State 클래스 전체 | 의존성에 있지만 실제 사용 안함. 적용 시 보일러플레이트 감소 |
| 하드코딩된 한국어 문자열 | `counter_screen.dart` | '평화교회 청년부', '처음 왔어요' 등 이스터에그 전용 문자열 (의도적일 수 있음) |
| PixelArtScreen 색상 팔레트 매 빌드 재생성 | `pixel_art_screen.dart` | 성능에 영향. 캐싱 필요 |

### LOW 우선순위

| 이슈 | 설명 |
|------|------|
| 테스트 커버리지 부족 | 70+ Dart 파일 중 5개만 테스트. UI/통합 테스트 없음 |
| Accessibility 미비 | 일부 버튼에 Semantics 라벨 누락 |
| 숨겨진 기능 접근성 | Pace Counter, QR Maker가 홈에서 직접 접근 불가 (숨겨진 기능) |

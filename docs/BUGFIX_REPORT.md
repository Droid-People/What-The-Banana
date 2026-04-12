# What The Banana - 버그 수정 리포트

> 작성일: 2026-04-12

## 수정 완료된 버그

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

---

## 미수정 잔존 이슈

### HIGH 우선순위

| 이슈 | 파일/위치 | 설명 |
|------|-----------|------|
| PayPal 키 git history 노출 | `.env` (현재 `.gitignore`에 포함) | `.gitignore`로 추적은 막혔지만 과거 커밋에 키가 남아있을 수 있음. **키 로테이션 권장** |
| dotenv 미사용 | `main.dart:18` | `dotenv.load()` 주석 처리. DonationScreen이 "Not ready" 상태이므로 현재 문제 없음 |
| UpdatesScreen JSON 파싱 에러 핸들링 없음 | `lib/etc/updates_screen.dart` | `rootBundle.load()`, `jsonDecode()` 에서 예외 발생 시 앱 크래시 가능 |

### MEDIUM 우선순위

| 이슈 | 파일/위치 | 설명 |
|------|-----------|------|
| StateNotifier 레거시 API | 대부분의 Provider 파일 | Riverpod v3에서 deprecated. `@riverpod` 코드 생성으로 마이그레이션 필요 |
| freezed 미사용 | State 클래스 전체 | 의존성에 있지만 실제 사용 안함. 적용 시 보일러플레이트 감소 |
| Navigator.pop() / context.pop() 혼용 | `updates_screen.dart` 등 | GoRouter 사용 시 `context.pop()` 통일 필요 |
| 하드코딩된 한국어 문자열 | `counter_screen.dart` | '평화교회 청년부', '처음 왔어요' 등 번역 파일에 넣어야 함 |
| PixelArtScreen 색상 팔레트 매 빌드 재생성 | `pixel_art_screen.dart` | 성능에 영향. 캐싱 필요 |

### LOW 우선순위

| 이슈 | 설명 |
|------|------|
| 테스트 커버리지 부족 | 70+ Dart 파일 중 5개만 테스트. UI/통합 테스트 없음 |
| Accessibility 미비 | 일부 버튼에 Semantics 라벨 누락 |
| 숨겨진 기능 접근성 | Pace Counter, QR Maker가 홈에서 직접 접근 불가 (숨겨진 기능) |

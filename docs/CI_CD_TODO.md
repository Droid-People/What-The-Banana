# CI/CD 설정 및 배포

## 구성

- Android 참고: `/Users/kangmin/dev/ac_project_app` (링크풀).
- iOS API 키 참고: `/Users/kangmin/dev/moabook-app/ios/fastlane` (사용자 지정).
- Flutter `3.50.0`, Ruby `3.4.1`, Fastlane `2.235.0`을 사용한다.
- `pubspec.lock`, `Gemfile.lock`, `ios/Podfile.lock`으로 의존성을 고정한다.

| 워크플로 | 실행 조건 | 수행 작업 |
| --- | --- | --- |
| `ci.yml` | `master` push, PR | 코드 생성 결과 검증, 정적 분석, 테스트 |
| `deploy-android.yml` | `android-vX.Y.Z` 태그 | 검증 및 서명된 AAB 빌드 → Play 내부 테스트 |
| `deploy-ios.yml` | `ios-vX.Y.Z` 태그 | 검증, iOS 빌드 및 서명 → TestFlight |

릴리스 태그는 `pubspec.yaml`의 `X.Y.Z`와 일치해야 한다. Android versionCode와 iOS build number는 `+N`을 사용하며 기존 업로드보다 증가시킨다. CI에서는 릴리스 버전을 자동으로 바꾸지 않는다.

## 확인한 계정 및 서명

- moabook의 API 키로 바나나 App Store Connect 앱 조회 성공: `6740320498`.
- 링크풀의 Play 서비스 계정 JSON으로 바나나의 트랙 조회 성공.
- 양쪽 기존 최신 빌드 번호는 `16`, 앱 버전은 `1.0.16`이었다.
- iOS bundle ID: `people.droid.whatTheBanana`, Apple Team: `T583WJWNAK`.
- Android applicationId: `people.droid.untitled`.
- Android는 바나나 기존 업로드 키와 Firebase 설정을 사용한다.
- iOS는 로컬 키체인에 개인 키가 있는 기존 Apple Distribution 인증서 `MJP77PJJ53`를 재사용한다. 인증서 만료일은 **2027-03-25**이다.
- 바나나 전용 App Store 프로파일 `What The Banana AppStore CI`를 생성했다.

## GitHub Actions Secrets

| 이름 | 용도 |
| --- | --- |
| `KEYSTORE_BASE64` | 바나나 기존 Android 업로드 키 |
| `KEYSTORE_PROPERTIES_BASE64` | Android 서명 정보, `storePath=keystore/release.keystore` |
| `GOOGLE_SERVICES_JSON_BASE64` | 바나나 Android Firebase 설정 |
| `GOOGLE_SERVICE_INFO_PLIST_BASE64` | 바나나 iOS Firebase 설정 |
| `PLAY_STORE_CONFIG_JSON` | 링크풀에서 확보한 Play 서비스 계정 JSON 원문 |
| `APP_STORE_API_KEY_BASE64` | moabook의 `AuthKey_35SHWLN842.p8` |
| `APP_STORE_KEY_ID` | 해당 API 키 ID |
| `APP_STORE_ISSUER_ID` | 해당 API 키 Issuer ID |
| `IOS_DISTRIBUTION_P12_BASE64` | 기존 iOS 배포 인증서와 개인 키를 암호화한 P12 |
| `IOS_DISTRIBUTION_P12_PASSWORD` | 위 P12 비밀번호 |
| `IOS_PROVISIONING_PROFILE_BASE64` | 바나나 전용 App Store 프로파일 |

CI는 임시 키체인에 인증서를 설치하고 전용 프로파일로 서명한다. 자격 증명은 환경 변수로 전달하고 로그에 출력하지 않으며 작업 종료 시 복원 파일과 임시 키체인을 제거한다.

`Droid-People/what-the-banana-ios-private` 저장소와 기존 `MATCH_PASSWORD` Secret은 현재 워크플로에서 사용하지 않는다. 조직에서 deploy key가 비활성화되어 있어, 조직 정책 변경 없이 GitHub Secrets로 서명을 구성했다. Match 저장소 동기화도 실행하지 않았다.

로컬 P12·비밀번호·프로파일은 `~/.config/what-the-banana/`에 권한 `600`으로 보관한다. 원본 API 키는 moabook 경로에 유지한다. 키 원본은 앱 저장소에 커밋하지 않는다.

## 배포 절차

1. 스토어에서 최신 빌드 번호를 확인하고 `pubspec.yaml`의 버전과 빌드 번호를 올린다.
2. 의존성을 변경했다면 lock 파일을 갱신한다.
3. 코드 생성, 정적 분석, 테스트와 플랫폼 릴리스 빌드를 검증한다.
4. 변경을 커밋하고 push한다.
5. 해당 커밋에 플랫폼별 태그를 생성하고 push한다. 예: `android-v1.0.17`, `ios-v1.0.17`.
6. Actions 결과와 Play 내부 테스트/TestFlight 처리 상태를 확인한다.

일반 사용자 대상 스토어 출시 및 심사 제출은 이 워크플로에 포함하지 않는다. 서명 인증서 만료 전에 인증서·프로파일과 관련 Secrets를 갱신한다.

## 첫 배포 검증

- 준비 버전: `1.0.17+17`.
- 테스트 98개 통과.
- 코드 생성 완료 및 추적된 생성 파일 변경 없음.
- 정적 분석 오류·경고 없음. 기존 info 항목은 `--no-fatal-infos`로 허용한다.
- Actions 워크플로 문법 검사 및 Fastlane lane 로딩 성공.
- 첫 GitHub Actions CI 실행 성공.
- Android 서명된 AAB 릴리스 빌드 성공 (70.3 MB).
- iOS 릴리스 앱 빌드 성공 (68.6 MB).
- 서명된 IPA 및 첫 업로드 결과는 확인 후 기록한다.

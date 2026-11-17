# CI/CD 도입 할 일

작성일: 2026-11-17

현재는 배포 자격 증명 확보 전까지 구현을 보류한다. 미완성 워크플로와 Fastlane 파일은 정리했으며, 실제 CI/CD 워크플로는 아직 적용하지 않았다. 배포 태그 생성·스토어 업로드는 하지 않았다.

## 목표 구성

참고 프로젝트: `/Users/kangmin/dev/moabook-app`

| 구분 | 실행 조건 | 수행 작업 |
| --- | --- | --- |
| CI | `master` push, PR | 의존성 설치, 코드 생성 검증, 정적 분석, 테스트 |
| Android 배포 | `android-vX.Y.Z` 태그 | 서명된 AAB 빌드 → Play Store 내부 테스트 |
| iOS 배포 | `ios-vX.Y.Z` 태그 | Fastlane Match 서명 → TestFlight 업로드 |

- Flutter는 현재 프로젝트에 적용한 stable `3.50.0`으로 고정한다.
- 배포 태그의 버전은 `pubspec.yaml`의 `version: X.Y.Z+N`과 일치해야 한다.
- Android versionCode와 iOS build number는 `+N`을 사용하고, 각 스토어에 업로드한 번호보다 증가시킨다.
- 수동 배포 실행을 추가한다면 브랜치에서 바로 배포하지 않고 릴리스 태그를 검증한다.

## 이미 수행한 외부 설정

- [x] iOS 서명용 private 저장소 생성: [Droid-People/what-the-banana-ios-private](https://github.com/Droid-People/what-the-banana-ios-private), 기본 브랜치 `main`.
- [x] 앱 저장소 [Droid-People/What-The-Banana](https://github.com/Droid-People/What-The-Banana)에 아래 Actions Secrets 등록.
- [ ] Match 인증서·프로비저닝 프로파일 생성 및 private 저장소 저장. 현재 저장소에는 초기 README만 있다.
- [ ] private 저장소를 읽을 CI 인증 수단 구성.

등록된 Secrets:

| 이름 | 내용 |
| --- | --- |
| `KEYSTORE_BASE64` | 이 앱의 기존 Android 업로드 키 |
| `KEYSTORE_PROPERTIES_BASE64` | 기존 키의 서명 정보. CI용 `storePath=keystore/release.keystore`로 정규화 |
| `GOOGLE_SERVICES_JSON_BASE64` | 이 앱의 Android Firebase 설정 |
| `GOOGLE_SERVICE_INFO_PLIST_BASE64` | 이 앱의 iOS Firebase 설정 |
| `MATCH_PASSWORD` | 새로 생성한 Match 암호화 비밀번호 |

Match 비밀번호의 로컬 백업은 `~/.config/what-the-banana/match-password`에 있으며 권한은 `600`이다. 문서·앱 저장소에 비밀번호 값을 넣지 않는다. 재개할 때 위 Secrets의 존재를 다시 확인한다.

## 다른 PC에서 가져올 항목

### iOS

- [ ] App Store Connect API 개인 키 `AuthKey_<KEY_ID>.p8`의 원본 파일.
- [ ] 해당 키의 Key ID와 Issuer ID.
- [ ] 키가 Apple 팀 `T583WJWNAK`에 속하고 인증서 관리 및 TestFlight 업로드에 필요한 권한이 있는지 확인.

`moabook-app`도 설정상 같은 Apple Team ID를 사용하므로, 적절한 권한의 기존 Team API Key를 재사용할 수 있다. 참고 프로젝트에 적힌 Key ID·Issuer ID는 가져온 파일의 실제 정보와 대조해야 한다.

확인 위치: App Store Connect → 사용자 및 액세스 → 통합 → App Store Connect API → Team Keys. 개인 키는 한 번만 다운로드할 수 있으므로 원본을 잃어버렸다면 새 키를 발급한다. [Apple 안내](https://developer.apple.com/help/app-store-connect/get-started/app-store-connect-api/)

이 PC에서는 배포용 `AuthKey_*.p8`를 찾지 못했다. 발견한 `roumo_ios/PushAppleLogin_7JTY56LRMB.p8`는 파일명상 다른 용도의 키로 보이며 배포용으로 확인되지 않았으므로 사용하지 않았다.

가져온 파일과 메타데이터를 다음 Secrets로 등록한다.

- `APP_STORE_API_KEY_BASE64`: `.p8` 파일의 Base64
- `APP_STORE_KEY_ID`: Key ID
- `APP_STORE_ISSUER_ID`: Issuer ID

### Android

- [ ] Play Console 배포 서비스 계정 JSON 원본 파일.
- [ ] 서비스 계정에 이 앱(`people.droid.untitled`)의 내부 테스트 트랙 배포 권한 부여.
- [ ] Google Play Android Developer API 활성화 확인.
- [ ] JSON을 `PLAY_STORE_CONFIG_JSON` Secret에 등록.

다른 프로젝트의 서비스 계정을 재사용하려면 이 앱에 대한 Play Console 접근 권한을 추가한다. JSON 원본을 잃어버렸다면 Google Cloud Console → IAM 및 관리자 → 서비스 계정 → 해당 계정 → 키 → 키 추가 → 새 키 만들기 → JSON에서 새 키를 발급한다. [Google 안내](https://developers.google.com/android-publisher/getting_started)

Android 키스토어는 다른 앱의 키로 교체하지 않는다. 이 앱의 기존 파일 `android/app/keystore/release.keystore`와 `keystore.properties`를 계속 사용한다. Firebase 설정도 이 앱 전용 파일을 사용한다.

GitHub Secrets는 등록 후 값을 다시 내려받을 수 없으므로 다른 PC의 원본 파일을 확보하거나 키를 재발급해야 한다.

## iOS 서명 저장소 접근 구성

Deploy key 등록 시 GitHub가 `Deploy keys are disabled for this repository`로 거절했다. 아직 CI용 SSH 키는 등록하지 않았고 `MATCH_GIT_PRIVATE_KEY` Secret도 없다.

- [ ] 다음 중 사용할 접근 방식을 결정하고 구성한다.
  - 조직에서 deploy key 사용을 허용한 뒤, 서명 저장소에 읽기 전용 deploy key를 등록하고 개인 키를 앱 저장소의 `MATCH_GIT_PRIVATE_KEY` Secret에 저장.
  - 또는 서명 저장소의 Contents 읽기 권한을 가진 fine-grained PAT/GitHub App으로 접근하도록 Fastlane 설정.
- [ ] 조직 설정 변경은 다른 저장소에도 영향을 주므로 별도로 확인 후 진행.

조직 설정 위치: Droid-People → Settings → Member privileges → Deploy keys. 이번 작업에서 조직 정책은 변경하지 않았다. [GitHub 안내](https://docs.github.com/en/enterprise-cloud@latest/organizations/managing-organization-settings/restricting-deploy-keys-in-your-organization)

앱 식별자 및 서명 기준:

| 항목 | 값 |
| --- | --- |
| iOS bundle identifier | `people.droid.whatTheBanana` |
| Apple Team ID | `T583WJWNAK` |
| Match 저장소 | `Droid-People/what-the-banana-ios-private`, `main` |
| Match 유형 | `appstore` |
| Android applicationId | `people.droid.untitled` |

- [ ] 로컬에서 Fastlane `sync_certs`를 실행해 인증서·프로파일을 생성/동기화하고 Match 저장소에 암호화해 저장.
- [ ] CI에서는 `setup_ci` 및 `match(readonly: true)`를 사용.
- [ ] 같은 팀의 기존 배포 인증서를 재사용할 경우 개인 키를 포함한 인증서가 필요하다. 다른 프로젝트의 프로비저닝 프로파일은 이 앱의 bundle ID에 맞는 프로파일로 대체해야 한다. [Fastlane 안내](https://docs.fastlane.tools/actions/match/)

## 재개 전 확인할 빌드 문제

- [x] Flutter 3.50.0에서 기존 단위 테스트 98개 통과.
- [x] 정적 분석 오류·경고 0개, info 311개 확인.
- [ ] Android Gradle 호환성 수정.

이번 로컬 `flutter build appbundle --release`는 다음 오류로 실패했다.

```text
Your project's Gradle version (8.14.3) is lower than Flutter's minimum supported version of 9.3.1.
```

`android/gradle/wrapper/gradle-wrapper.properties`의 Gradle을 최소 요구 버전 이상으로 올리고, AGP·Kotlin·Java의 호환 조합도 함께 확인한다. 현재 AGP는 `8.11.1`, Kotlin은 `2.2.20`이다. 검증 우회 옵션으로 덮지 말고 릴리스 빌드가 실제 통과한 뒤 워크플로를 확정한다.

## 구현 및 검증 순서

1. 위 API 키 파일과 메타데이터 확보 및 Secrets 등록.
2. Android 빌드 도구 호환성 수정, 서명된 AAB 로컬 빌드 검증.
3. Match 저장소 접근 인증 구성 및 최초 인증서·프로파일 동기화.
4. `.github/workflows/ci.yml`, `deploy-android.yml`, `deploy-ios.yml` 작성.
5. root `Gemfile`·`Gemfile.lock`, Android/iOS Fastlane 설정 추가.
6. CI에서 사용할 Flutter 버전 고정 파일을 정리. 현재는 FVM 2의 `.fvm/fvm_config.json`을 사용하며 `.fvmrc`는 아직 추가하지 않았다.
7. 재현 가능한 의존성 설치를 위해 현재 ignore된 `pubspec.lock`을 앱 저장소에서 추적하도록 변경.
8. 코드 생성 후 생성 파일 차이를 검증하고 `flutter analyze --no-fatal-infos`, `flutter test` 실행. 기존 info 항목 정리는 별도 작업으로 진행.
9. 워크플로 문법, Fastlane lane 로딩, 양쪽 플랫폼 릴리스 빌드 검증.
10. 코드 리뷰 및 적용 후, 스토어의 기존 빌드 번호와 중복되지 않는 버전으로 플랫폼별 태그를 만들어 첫 내부 테스트/TestFlight 배포 확인.

배포 파일 복원 시 Secrets를 환경 변수로 전달하고 로그에 값을 출력하지 않는다. CI용 임시 파일은 작업 종료 시 제거한다. 자격 증명, 키스토어, `.p8`·`.p12` 파일은 앱 저장소에 커밋하지 않는다.

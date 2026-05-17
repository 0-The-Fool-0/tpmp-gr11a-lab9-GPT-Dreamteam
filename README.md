# tpmp-gr11a-lab9-GPT-Dreamteam

Мобильное банковское приложение **BankApp** (iOS, SwiftUI + Core Data) — лабораторная работа 9.

## Соответствие заданию (п. 5–6)

| Требование | Реализация |
|------------|------------|
| План тестирования (Test Plan) | [`docs/TEST_PLAN.md`](docs/TEST_PLAN.md), Xcode Test Plan [`BankApp/BankApp.xctestplan`](BankApp/BankApp.xctestplan) |
| Unit-тесты | `BankApp/BankAppTests/` (Swift Testing) |
| UI-тесты | `BankApp/BankAppUITests/` (XCTest / XCUITest) |
| CI GitHub Actions | [`.github/workflows/ios-ci.yml`](.github/workflows/ios-ci.yml) |
| **Тесты до сборки** | Job `test` → job `build` (`needs: test`) |
| Покрытие ~90% | `BankApp/ci/check-coverage.sh` |

### CI/CD (по учебным материалам)

Настройка следует рекомендациям:

- [GitHub Actions for iOS projects](https://sarunw.com/posts/github-actions-for-ios-projects/) — `macos-latest`, `xcodebuild`, симулятор, кэш DerivedData  
- [iOS CI/CD with GitHub Actions](https://medium.com/thefork/ios-ci-cd-with-github-actions-e4504228c9d) — разделение test / build  
- [Apple-Actions/Example-iOS](https://github.com/Apple-Actions/Example-iOS) — checkout, выбор Xcode, scheme + test  
- [GitHub Actions CI for Swift](https://medium.com/rosberryapps/github-actions-ci-for-swift-projects-c129baceed1a) — `xcodebuild test` / `build`  
- [Building an Objective-C or Swift Project (Travis)](https://docs.travis-ci.com/user/languages/objective-c/) — аналогичная последовательность для Xcode-проектов  

## Структура

- `BankApp/` — Xcode-проект  
- `BankApp/BankAppTests/` — unit-тесты  
- `BankApp/BankAppUITests/` — UI-тесты  
- `docs/TEST_PLAN.md` — план тестирования  
- `.github/workflows/ios-ci.yml` — непрерывная интеграция  

## GitHub Actions (порядок шагов)

```
test (unit → coverage ≥90% → UI)  →  build (Release, только если test успешен)
```

Триггеры: `push` / `pull_request` в `main`/`master`, ручной запуск **Actions → iOS CI → Run workflow**.

## Локальный запуск (macOS + Xcode)

```bash
cd BankApp
./ci/build-and-test.sh
```

## Демо-учётная запись

| Логин | Пароль |
|-------|--------|
| `elena.kuznetsova` | `demo1234` |

## Покрытие

Цель — **≥ 90%** строк target `BankApp`. Отчёт в Xcode: **Report navigator → Coverage** после ⌘U.

# План тестирования (Test Plan) — BankApp

**Проект:** мобильное банковское приложение BankApp (iOS, SwiftUI)  
**Версия плана:** 1.0  
**Дата:** 2026-05-17  

## 1. Цели тестирования

- Проверить корректность бизнес-логики (авторизация, счета, курсы, отделения).
- Убедиться в работоспособности основных пользовательских сценариев (вход, главная, список счетов).
- Обеспечить регрессионный контроль через CI (GitHub Actions): **сначала тесты, затем сборка**.
- Достичь покрытия кода target `BankApp` **не менее 90%** (unit-тесты + code coverage).

## 2. Объект тестирования

| Компонент | Описание |
|-----------|----------|
| Сервисы | `AuthService`, `AccountService`, `ExchangeRateService`, `BranchService` |
| ViewModels | `LoginViewModel`, `HomeViewModel`, `AccountsViewModel`, `BranchesViewModel` |
| Модели / утилиты | `AccountItem`, `MoneyFormatting`, Core Data seed |
| UI | Login, Home, Accounts, Branches (карта), навигация |
| CI | Workflow `.github/workflows/ios-ci.yml`, Test Plan `BankApp.xctestplan` |

## 3. Типы тестов

### 3.1 Unit-тесты (`BankAppTests`, Swift Testing)

| ID | Область | Примеры проверок |
|----|---------|------------------|
| UT-01 | Авторизация | валидный/невалидный логин, trim полей |
| UT-02 | Счета | видимые счета, исключение closed, сумма доступных средств |
| UT-03 | Курсы / отделения | seed USD/EUR, 4 филиала |
| UT-04 | Форматирование | рубли, курс, время |
| UT-05 | ViewModels | приветствие по времени суток, reload |
| UT-06 | Core Data | однократный seed, in-memory store |
| UT-07 | UI hosting | рендер SwiftUI-экранов без краша |

### 3.2 UI-тесты (`BankAppUITests`, XCTest)

| ID | Сценарий | Ожидаемый результат |
|----|----------|---------------------|
| UI-01 | Запуск приложения | отображается экран входа |
| UI-02 | Неверный пароль | сообщение об ошибке |
| UI-03 | Успешный вход (`elena.kuznetsova` / `demo1234`) | главная, имя «Елена», сумма содержит «918» |
| UI-04 | Переход к счетам | список из 5 карточек счетов |
| UI-05 | Launch screenshot | скриншот экрана входа (launch test) |

**Окружение UI-тестов:** launch argument `-UITesting`, in-memory БД с демо-данными.

## 4. Критерии входа / выхода

**Вход в тестирование:** сборка проекта в Xcode без ошибок, наличие схемы `BankApp` и Test Plan.

**Выход (критерии приёмки):**

- Все unit- и UI-тесты проходят локально и в GitHub Actions.
- Покрытие строк `BankApp` ≥ 90%.
- Сборка Release для симулятора выполняется **только после** успешных тестов в CI.

## 5. Тестовые данные

| Поле | Значение |
|------|----------|
| Логин | `elena.kuznetsova` |
| Пароль | `demo1234` |
| Ожидаемая сумма на главной | 918 420 ₽ (активные счета) |
| Видимых счетов | 5 (без closed) |

## 6. Инструменты

- Xcode, `xcodebuild`, Test Plan `BankApp.xctestplan`
- Swift Testing (unit), XCTest / XCUITest (UI)
- GitHub Actions (`macos-latest`), скрипты `BankApp/ci/`

## 7. Интеграция с CI/CD

Порядок в GitHub Actions (см. [sarunw.com — GitHub Actions for iOS](https://sarunw.com/posts/github-actions-for-ios-projects/), [Apple-Actions/Example-iOS](https://github.com/Apple-Actions/Example-iOS)):

1. **Job `test`:** unit-тесты → проверка coverage → UI-тесты  
2. **Job `build`:** сборка приложения (`needs: test`) — только если тесты зелёные  

## 8. Риски и ограничения

- UI-тесты геолокации зависят от симулятора; основная логика покрыта unit-тестами.
- CI требует macOS runner (нельзя собирать iOS на `ubuntu-latest`).

## 9. Ответственность

 Андрей Борисовец, группа 11, роль тестировщик

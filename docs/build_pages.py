#!/usr/bin/env python3
"""Generate wiki HTML pages from content fragments."""

NAV = """        <h2>Wiki</h2>
        <ul>
          <li><a href="index.html"{home}>Home</a></li>
          <li><a href="glossary.html"{glossary}>Glossary</a></li>
          <li><a href="use-case-diagram.html"{uc}>1. Use Case Diagram</a></li>
          <li><a href="class-diagram.html"{cd}>2. Class Diagram</a></li>
          <li><a href="sequence-diagrams.html"{sd}>3. Sequence Diagrams</a></li>
          <li><a href="package-diagram.html"{pd}>4. Package Diagram</a></li>
          <li><a href="deployment-diagrams.html"{dd}>5. Deployment Diagrams</a></li>
          <li><a href="database-schema.html"{db}>6. Database Schema</a></li>
          <li><a href="requirements-and-planning.html"{rp}>7. Requirements and Planning</a></li>
        </ul>
        <h2>Проект</h2>
        <ul>
          <li><a href="test-plan.html"{tp}>Test Plan</a></li>
          <li><a href="https://github.com/0-The-Fool-0/tpmp-gr11a-lab9-GPT-Dreamteam">Репозиторий</a></li>
          <li><a href="https://github.com/0-The-Fool-0/tpmp-gr11a-lab9-GPT-Dreamteam/wiki">Wiki на GitHub</a></li>
        </ul>"""

KEYS = ["home", "glossary", "uc", "cd", "sd", "pd", "dd", "db", "rp", "tp"]


def nav(active: str) -> str:
    parts = {k: "" for k in KEYS}
    parts[active] = ' class="active"'
    return NAV.format(**parts)


def page(title: str, active: str, body: str) -> str:
    return f"""<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{title} — BankApp Wiki</title>
  <link rel="stylesheet" href="assets/wiki.css">
</head>
<body>
  <header class="wiki-header">
    <h1><a href="index.html">tpmp-gr11a-lab9-GPT-Dreamteam</a></h1>
    <p>Документация BankApp · <a href="https://github.com/0-The-Fool-0/tpmp-gr11a-lab9-GPT-Dreamteam">GitHub</a></p>
  </header>
  <div class="wiki-layout">
    <aside class="wiki-sidebar">
      <nav>
{nav(active)}
      </nav>
    </aside>
    <main class="wiki-content">
{body}
      <footer class="wiki-footer"><a href="index.html">← Home</a></footer>
    </main>
  </div>
</body>
</html>
"""


PAGES = {
    "class-diagram.html": ("2. Class Diagram", "cd", """
      <h1>2. Class Diagram</h1>
      <p>
        <a href="https://github.com/user-attachments/assets/c095c434-d01f-4fd5-856c-dc64822245e1">
          <img src="https://github.com/user-attachments/assets/c095c434-d01f-4fd5-856c-dc64822245e1" alt="Диаграмма классов">
        </a>
      </p>
      <table>
        <thead><tr><th>Группа</th><th>Классы</th><th>Ответственность</th></tr></thead>
        <tbody>
          <tr><td>Сервисы</td><td>AuthService, AccountService, ExchangeRateService, BranchService</td><td>Бизнес-логика, работа с Core Data</td></tr>
          <tr><td>ViewModel</td><td>HomeViewModel, AccountsViewModel, BranchesViewModel, LoginViewModel</td><td>Подготовка данных для UI, управление состоянием</td></tr>
          <tr><td>Core Data</td><td>User, Account, ExchangeRate, Branch</td><td>Хранение данных в SQLite</td></tr>
          <tr><td>Модели</td><td>UserSession, AccountItem, RateItem, BranchItem</td><td>Value-типы для передачи данных</td></tr>
          <tr><td>Enum</td><td>AccountType, CardSubtype, AccountStatus</td><td>Типы и статусы счетов</td></tr>
        </tbody>
      </table>
"""),
    "sequence-diagrams.html": ("3. Sequence Diagrams", "sd", """
      <h1>3. Sequence Diagrams</h1>
      <p><img src="https://github.com/user-attachments/assets/990328ba-1417-45cd-b938-d2e6b5e42fdb" alt="Диаграмма последовательности"></p>
      <h2>3.1 Аутентификация пользователя</h2>
      <p><strong>Назначение:</strong> пошаговый процесс входа пользователя в систему.</p>
      <ol>
        <li>Пользователь вводит логин/пароль и нажимает «Войти»</li>
        <li>LoginViewModel валидирует введённые данные</li>
        <li>AuthService выполняет поиск пользователя в Core Data</li>
        <li>При успехе — SessionStore сохраняет сессию, переход на главный экран</li>
        <li>При ошибке — сообщение об ошибке</li>
      </ol>
      <h2>3.2 Просмотр счетов</h2>
      <p><strong>Назначение:</strong> загрузка и отображение списка счетов пользователя.</p>
      <ol>
        <li>Пользователь переходит на экран счетов</li>
        <li>AccountsViewModel инициирует загрузку данных</li>
        <li>AccountService запрашивает Core Data с фильтром status != "closed"</li>
        <li>Данные сортируются по sortOrder</li>
        <li>Результат преобразуется в AccountItem и отображается в UI</li>
      </ol>
      <h2>3.3 Поиск ближайшего отделения</h2>
      <p><strong>Назначение:</strong> определение местоположения и поиск ближайшего филиала.</p>
      <ol>
        <li>Пользователь нажимает «Найти ближайшее отделение»</li>
        <li>BranchesViewModel запрашивает разрешение на геолокацию</li>
        <li>CLLocationManager получает координаты устройства</li>
        <li>Вычисляются расстояния до всех филиалов</li>
        <li>Выбирается ближайший и отображается в UI</li>
        <li>При отсутствии разрешения — предупреждение</li>
      </ol>
"""),
    "package-diagram.html": ("4. Package Diagram", "pd", """
      <h1>4. Package Diagram</h1>
      <p><img src="https://github.com/user-attachments/assets/de6c33fc-e0fe-4295-aba6-162e84bec11d" alt="Диаграмма пакетов"></p>
      <table>
        <thead><tr><th>Слой</th><th>Содержимое</th><th>Зависит от</th></tr></thead>
        <tbody>
          <tr><td>UI Layer</td><td>SwiftUI представления</td><td>ViewModel, Utilities</td></tr>
          <tr><td>ViewModel Layer</td><td>ViewModel классы</td><td>Service, Models</td></tr>
          <tr><td>Service Layer</td><td>Сервисы (Auth, Account, и т.д.)</td><td>Core Data, Models</td></tr>
          <tr><td>Core Data Layer</td><td>PersistenceController, NSManagedObject</td><td>—</td></tr>
          <tr><td>Models Layer</td><td>Value-типы (struct)</td><td>—</td></tr>
          <tr><td>Utilities Layer</td><td>Форматирование, расширения</td><td>—</td></tr>
        </tbody>
      </table>
      <p><strong>Ключевой принцип:</strong> зависимости направлены только сверху вниз (UI → ViewModel → Service → Core Data).</p>
"""),
    "deployment-diagrams.html": ("5. Deployment Diagrams", "dd", """
      <h1>5. Deployment Diagrams</h1>
      <p><img src="https://github.com/user-attachments/assets/31a72739-2103-4be1-b72c-50b9533d0f0f" alt="Диаграмма развертывания"></p>
      <table>
        <thead><tr><th>Узел / Компонент</th><th>Тип</th><th>Назначение</th></tr></thead>
        <tbody>
          <tr><td>iOS Device</td><td>Физическое устройство</td><td>Среда выполнения приложения</td></tr>
          <tr><td>BankApp.app</td><td>Исполняемый файл</td><td>Приложение (UI, ViewModel, Services)</td></tr>
          <tr><td>SQLite Database</td><td>База данных</td><td>Файл BankApp.sqlite с данными</td></tr>
          <tr><td>Core Data Stack</td><td>Прослойка</td><td>ORM между приложением и SQLite</td></tr>
          <tr><td>SwiftUI</td><td>Фреймворк iOS</td><td>Построение интерфейса</td></tr>
          <tr><td>MapKit</td><td>Фреймворк iOS</td><td>Отображение карты и аннотаций</td></tr>
          <tr><td>CoreLocation</td><td>Фреймворк iOS</td><td>Определение геопозиции</td></tr>
          <tr><td>UserDefaults</td><td>Хранилище</td><td>Настройки приложения (plist)</td></tr>
        </tbody>
      </table>
      <h2>Особенности</h2>
      <ul>
        <li>Приложение работает полностью офлайн</li>
        <li>SQLite инициализируется при первом запуске через DataSeedService</li>
      </ul>
"""),
    "database-schema.html": ("6. Database Schema", "db", """
      <h1>6. Database Schema</h1>
      <p>
        <a href="https://github.com/user-attachments/assets/fe28bc18-ea04-4b0f-b876-2e0759940226">
          <img src="https://github.com/user-attachments/assets/fe28bc18-ea04-4b0f-b876-2e0759940226" alt="База данных">
        </a>
      </p>
      <table>
        <thead><tr><th>Таблица</th><th>Описание</th><th>Основные поля</th></tr></thead>
        <tbody>
          <tr><td>ZUSER</td><td>Пользователи системы</td><td>ZID (UUID), ZLOGIN, ZPASSWORD, ZDISPLAYNAME</td></tr>
          <tr><td>ZACCOUNT</td><td>Банковские счета</td><td>ZACCOUNTNUMBER, ZTYPE, ZSTATUS, ZBALANCE, ZOVERDRAFTLIMIT, ZSORTORDER</td></tr>
          <tr><td>ZEXCHANGERATE</td><td>Курсы валют</td><td>ZCURRENCYCODE, ZBUYRATE, ZUPDATEDAT</td></tr>
          <tr><td>ZBRANCH</td><td>Филиалы банка</td><td>ZNAMEKEY, ZADDRESS, ZLATITUDE, ZLONGITUDE</td></tr>
        </tbody>
      </table>
      <p><strong>Связи:</strong> ZACCOUNT.ZUSER → ZUSER.Z_PK (внешний ключ)</p>
      <p><strong>Хранимые типы данных:</strong></p>
      <ul>
        <li>INTEGER — целые числа</li>
        <li>VARCHAR — строки</li>
        <li>DOUBLE — числа с плавающей точкой</li>
        <li>BLOB — бинарные данные</li>
        <li>TIMESTAMP — дата/время</li>
      </ul>
"""),
    "requirements-and-planning.html": ("7. Requirements and Planning", "rp", """
      <h1>7. Requirements and Planning</h1>
      <p>
        <a href="https://github.com/user-attachments/assets/39de9839-9b8c-4c3b-95e9-545fb9d21b2a">
          <img src="https://github.com/user-attachments/assets/39de9839-9b8c-4c3b-95e9-545fb9d21b2a" alt="Схема компонентов">
        </a>
      </p>
      <h2>Назначение раздела</h2>
      <p>Раздел определяет полный перечень функциональных и нефункциональных требований, а также план реализации с оценкой сроков, трудозатрат и рисков.</p>
      <h2>1. Функциональные требования (27)</h2>
      <table>
        <thead><tr><th>Категория</th><th>Ключевые требования</th></tr></thead>
        <tbody>
          <tr><td>Аутентификация</td><td>Вход по логину/паролю, проверка по БД, выход</td></tr>
          <tr><td>Просмотр счетов</td><td>Активные/заблокированные, 4 типа счетов, овердрафт для зарплатных карт</td></tr>
          <tr><td>Курсы валют</td><td>USD/EUR на главном экране</td></tr>
          <tr><td>Карта отделений</td><td>Интерактивная карта, поиск ближайшего через геолокацию</td></tr>
          <tr><td>Управление данными</td><td>SQLite, seed при первом запуске</td></tr>
        </tbody>
      </table>
      <h2>2. Нефункциональные требования (17)</h2>
      <table>
        <thead><tr><th>Категория</th><th>Целевые показатели</th></tr></thead>
        <tbody>
          <tr><td>Производительность</td><td>Запуск &lt; 3 сек, отклик UI &lt; 300 мс</td></tr>
          <tr><td>Надёжность</td><td>Нет crash при ошибках геолокации</td></tr>
          <tr><td>Платформа</td><td>iOS 16.0+, iPhone, тёмная/светлая тема</td></tr>
          <tr><td>Локализация</td><td>Русский язык</td></tr>
        </tbody>
      </table>
      <h2>3. План реализации (11 этапов)</h2>
      <table>
        <thead><tr><th>Этап</th><th>Длительность</th><th>Результат</th></tr></thead>
        <tbody>
          <tr><td>Настройка Core Data</td><td>1 день</td><td>Модели, PersistenceController</td></tr>
          <tr><td>Слой сервисов</td><td>1 день</td><td>AuthService, AccountService и др.</td></tr>
          <tr><td>ViewModel слой</td><td>1 день</td><td>4 ViewModel класса</td></tr>
          <tr><td>UI компоненты</td><td>1 день</td><td>Кастомные SwiftUI компоненты</td></tr>
          <tr><td>Аутентификация</td><td>1 день</td><td>LoginView + SessionStore</td></tr>
          <tr><td>Главный экран</td><td>0.5 дня</td><td>HomeView</td></tr>
          <tr><td>Список счетов</td><td>0.5 дня</td><td>AccountsListView</td></tr>
          <tr><td>Карта отделений</td><td>1.5 дня</td><td>BranchesMapView</td></tr>
          <tr><td>Навигация и DI</td><td>1 день</td><td>RootView, MainTabView</td></tr>
          <tr><td>Тестирование</td><td>0.5 дня</td><td>Модульное и UI-тестирование</td></tr>
          <tr><td>Документация</td><td>1 день</td><td>Техническая документация</td></tr>
        </tbody>
      </table>
      <h2>4. Приоритезация MoSCoW</h2>
      <table>
        <thead><tr><th>Приоритет</th><th>Количество</th><th>Примеры</th></tr></thead>
        <tbody>
          <tr><td>Must have</td><td>15</td><td>Вход, список счетов, Core Data</td></tr>
          <tr><td>Should have</td><td>8</td><td>Выход, овердрафт, геолокация</td></tr>
          <tr><td>Could have</td><td>6</td><td>Курсы валют, список филиалов</td></tr>
          <tr><td>Won't have</td><td>3</td><td>Хеширование паролей, шифрование сессии</td></tr>
        </tbody>
      </table>
      <h2>5. Риски и митигация</h2>
      <table>
        <thead><tr><th>Риск</th><th>Митигация</th></tr></thead>
        <tbody>
          <tr><td>Сложности с Core Location</td><td>Тестирование на реальном устройстве</td></tr>
          <tr><td>Требования к безопасности</td><td>Абстракция AuthService</td></tr>
          <tr><td>Нехватка времени</td><td>Параллельная документация</td></tr>
        </tbody>
      </table>
      <h2>6. Критерии приёмки</h2>
      <ul>
        <li>Вход с корректными данными → главный экран</li>
        <li>Только активные/заблокированные счета в списке</li>
        <li>Выделение ближайшего отделения на карте</li>
        <li>Автозаполнение БД при первом запуске</li>
        <li>Отсутствие crash при штатном использовании</li>
      </ul>
      <h2>Итоговая оценка</h2>
      <table>
        <thead><tr><th>Параметр</th><th>Значение</th></tr></thead>
        <tbody>
          <tr><td>Общая длительность</td><td>7 дней</td></tr>
          <tr><td>Трудозатраты</td><td>40 часов</td></tr>
          <tr><td>Оценочная стоимость</td><td>3 600 у.е.</td></tr>
          <tr><td>Всего требований</td><td>44 (27 + 17)</td></tr>
        </tbody>
      </table>
"""),
    "test-plan.html": ("Test Plan", "tp", """
      <h1>План тестирования (Test Plan) — BankApp</h1>
      <p><strong>Проект:</strong> мобильное банковское приложение BankApp (iOS, SwiftUI)<br>
      <strong>Версия плана:</strong> 1.0 · <strong>Дата:</strong> 2026-05-17</p>
      <h2>1. Цели тестирования</h2>
      <ul>
        <li>Проверить бизнес-логику (авторизация, счета, курсы, отделения)</li>
        <li>Убедиться в работоспособности основных сценариев</li>
        <li>Регрессия через CI: сначала тесты, затем сборка</li>
        <li>Покрытие кода target BankApp ≥ 90%</li>
      </ul>
      <h2>2. Объект тестирования</h2>
      <table>
        <thead><tr><th>Компонент</th><th>Описание</th></tr></thead>
        <tbody>
          <tr><td>Сервисы</td><td>AuthService, AccountService, ExchangeRateService, BranchService</td></tr>
          <tr><td>ViewModels</td><td>LoginViewModel, HomeViewModel, AccountsViewModel, BranchesViewModel</td></tr>
          <tr><td>Модели / утилиты</td><td>AccountItem, MoneyFormatting, Core Data seed</td></tr>
          <tr><td>UI</td><td>Login, Home, Accounts, Branches, навигация</td></tr>
          <tr><td>CI</td><td>ios-ci.yml, BankApp.xctestplan</td></tr>
        </tbody>
      </table>
      <h2>3. Unit-тесты</h2>
      <table>
        <thead><tr><th>ID</th><th>Область</th><th>Примеры</th></tr></thead>
        <tbody>
          <tr><td>UT-01</td><td>Авторизация</td><td>валидный/невалидный логин, trim</td></tr>
          <tr><td>UT-02</td><td>Счета</td><td>видимые счета, исключение closed, сумма</td></tr>
          <tr><td>UT-03</td><td>Курсы / отделения</td><td>seed USD/EUR, 4 филиала</td></tr>
          <tr><td>UT-04</td><td>Форматирование</td><td>рубли, курс, время</td></tr>
          <tr><td>UT-05</td><td>ViewModels</td><td>приветствие, reload</td></tr>
          <tr><td>UT-06</td><td>Core Data</td><td>однократный seed, in-memory</td></tr>
          <tr><td>UT-07</td><td>UI hosting</td><td>рендер SwiftUI без краша</td></tr>
        </tbody>
      </table>
      <h2>4. UI-тесты</h2>
      <table>
        <thead><tr><th>ID</th><th>Сценарий</th><th>Ожидание</th></tr></thead>
        <tbody>
          <tr><td>UI-01</td><td>Запуск</td><td>экран входа</td></tr>
          <tr><td>UI-02</td><td>Неверный пароль</td><td>ошибка</td></tr>
          <tr><td>UI-03</td><td>Успешный вход</td><td>главная, «Елена», сумма «918»</td></tr>
          <tr><td>UI-04</td><td>Счета</td><td>5 карточек</td></tr>
          <tr><td>UI-05</td><td>Launch screenshot</td><td>скриншот входа</td></tr>
        </tbody>
      </table>
      <p>Окружение UI-тестов: <code>-UITesting</code>, in-memory БД.</p>
      <h2>5. Критерии приёмки</h2>
      <ul>
        <li>Все тесты зелёные локально и в GitHub Actions</li>
        <li>Покрытие ≥ 90%</li>
        <li>Release-сборка только после успешных тестов</li>
      </ul>
      <h2>6. Тестовые данные</h2>
      <table>
        <thead><tr><th>Поле</th><th>Значение</th></tr></thead>
        <tbody>
          <tr><td>Логин</td><td><code>elena.kuznetsova</code></td></tr>
          <tr><td>Пароль</td><td><code>demo1234</code></td></tr>
          <tr><td>Сумма на главной</td><td>918 420 ₽</td></tr>
          <tr><td>Видимых счетов</td><td>5</td></tr>
        </tbody>
      </table>
      <p>Исходник: <a href="TEST_PLAN.md">TEST_PLAN.md</a></p>
      <p><strong>Ответственность:</strong> Андрей Борисовец, группа 11, тестировщик</p>
"""),
    "use-case-diagram.html": ("1. Use Case Diagram", "uc", """
      <h1>1. Use Case Diagram</h1>
      <p>
        <a href="https://github.com/user-attachments/assets/02f0bad7-3d08-4f5c-a618-b34104c1146a">
          <img src="https://github.com/user-attachments/assets/02f0bad7-3d08-4f5c-a618-b34104c1146a" alt="Use Case Diagram">
        </a>
      </p>
      <p><strong>Назначение:</strong> функциональные возможности с точки зрения клиента банка.</p>
      <h2>Основные элементы</h2>
      <p><strong>Актёр:</strong> Клиент</p>
      <ul>
        <li>Войти в систему</li>
        <li>Просмотреть счета</li>
        <li>Просмотреть курс валют</li>
        <li>Просмотреть карту отделений</li>
        <li>Найти ближайшее отделение</li>
        <li>Выйти из системы</li>
      </ul>
      <h2>Ключевые особенности</h2>
      <ul>
        <li>Закрытые счета не отображаются</li>
        <li>Поиск ближайшего отделения использует геолокацию</li>
      </ul>
"""),
}

if __name__ == "__main__":
    from pathlib import Path
    root = Path(__file__).parent
    for fname, (title, active, body) in PAGES.items():
        (root / fname).write_text(page(title, active, body), encoding="utf-8")
        print("wrote", fname)

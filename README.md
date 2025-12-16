# Отчет по практическому заданию № 8
## Наумов Ярослав Денисович, ЭФБО-10-23

### Цели:
- Подключить Flutter-приложение к Firebase через FlutterFire CLI.
-  Освоить инициализацию firebase_core и работу с Cloud Firestore (cloud_firestore).
-  Реализовать базовый CRUD (создание, чтение в реальном времени, обновление, удаление) для коллекции данных.
-  Настроить минимальные правила безопасности Firestore для учебной среды.
- Сформировать практические навыки диагностики и устранения типовых ошибок подключения.

## Контрольная точка 1
### Подготовка проекта Flutter
Проект компилируется и запускается на эмуляторе/устройстве

<img width="1242" height="864" alt="Снимок экрана 2025-10-30 210310" src="https://github.com/user-attachments/assets/d0f1dcb7-a54e-4abc-bc0d-eafe71aa0291" />

## Контрольная точка 2
### Создание проекта Firebase и привязка FlutterFire
В проекте есть firebase_options.dart, сборка проходит без ошибок.

<img width="1550" height="949" alt="Снимок экрана 2025-12-15 161227" src="https://github.com/user-attachments/assets/51936633-c59c-4f9a-a44d-b7cd5931e377" />

## Контрольная точка 3
Приложение запускается без ошибок и не падает на старте.

<img width="1535" height="889" alt="Снимок экрана 2025-12-15 162031" src="https://github.com/user-attachments/assets/616185ea-203e-4528-8eed-dc99b03323d1" />


## Контрольная точка 4
Вы можете создавать документы через консоль Firebase.

<img width="1262" height="847" alt="Снимок экрана 2025-12-15 162532" src="https://github.com/user-attachments/assets/eaa787a6-a047-49ed-8c75-5acae0d5a104" />
<img width="1470" height="744" alt="Снимок экрана 2025-12-15 163036" src="https://github.com/user-attachments/assets/326756d0-8b6c-44da-961c-ac05e58352d7" />


## Контрольная точка 5
Добавление заметки создаёт документ в notes

<img width="397" height="855" alt="Снимок экрана 2025-12-15 163844" src="https://github.com/user-attachments/assets/662f9a54-cb18-4ba0-b36f-75193d7a332a" />

Заметку можно редактировать

<img width="391" height="847" alt="Снимок экрана 2025-12-15 165238" src="https://github.com/user-attachments/assets/b747711a-fe62-460d-8516-3a2ac87bd8ea" />

Заметку можно удалить

<img width="380" height="835" alt="Снимок экрана 2025-12-15 165415" src="https://github.com/user-attachments/assets/e8720061-a0e6-47fc-9ea4-3b3719179655" />

## Дополнительное задание (по желанию, +1 балл)
Добавление аутентификации
```
# pubspec.yaml
firebase_auth: ^4.6.1
```
Способ подключения: FlutterFire CLI:
1. Установка CLI: dart pub global activate flutterfire_cli
2. Авторизация в Google: flutterfire configure
3. Выбор существующего проекта Firebase из консоли
4. Настройка платформ: Android
5. Автоматическая генерация файла lib/firebase_options.dart с конфигурацией

Используемые пакеты и инициализация Firebase: зависимости в pubspec.yaml и инициализация в lib/main.dart.

Структура документа:
 ```json
{
  "title": "string",        // Заголовок заметки
  "content": "string",      // Текст заметки
  "createdAt": "timestamp", // Дата создания
  "updatedAt": "timestamp"  // Дата последнего обновления
}
```

Почему установленные правила безопасности Firestore недостаточны для продакшена:
- Полный доступ для всех
- Отсутствие аутентификации
- Нет ограничений по данным
- Уязвимость к злоупотреблениям

# Отчет по практическому заданию № 11
## Наумов Ярослав Денисович, ЭФБО-10-23

### Цели:
- Понять базовые понятия HTTP/REST: методы, URL/эндпоинты, коды ответов, заголовки, тела запросов/ответов (JSON).
-  Освоить основы интеграции Flutter-приложения с внешним API: http/dio, сериализация JSON, обработка ошибок и таймаутов.
-  Научиться выстраивать слой данных с репозиторием и отделять его от UI (продолжаем архитектурную линию прошлых ПЗ).
-  Реализовать список сущностей из публичного API + экран деталей + форму создания/редактирования (с демонстрацией запросов).
-  Разобраться с пагинацией, фильтрацией, аутентификацией (Bearer), ретраями и UX при сетевых сбоях.

## Контрольная точка 1
### Cоздание нового ресурса в mockapi

<img width="1218" height="720" alt="image" src="https://github.com/user-attachments/assets/6ce68404-9d65-4094-b3bc-5d29d97241ff" />

<img width="1014" height="617" alt="image" src="https://github.com/user-attachments/assets/8b78e238-627b-4504-98a2-54deb6907ab3" />

## Контрольная точка 2
### Проект создан, собран и запускается

<img width="624" height="1067" alt="image" src="https://github.com/user-attachments/assets/9d115110-1a91-40de-8f60-b507c0682764" />

## Контрольная точка 3
### Код модели note

 ```dart
class Note {
  final String id;
  final String title;
  final String body;

  Note({required this.id, required this.title, required this.body});

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'] is String
        ? int.tryParse(json['id']) ?? 0
        : (json['id'] ?? 0),
    title: json['title'] ?? '',
    body: json['body'] ?? '',
  );

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'body': body};
}
```

## Контрольная точка 4
### Измененные эндпоинты репозитории

<img width="1099" height="900" alt="image" src="https://github.com/user-attachments/assets/2267da08-44c4-433d-b87e-e1c16a3d0c17" />

## Контрольная точка 5
### Проект создан, собран и запускается

<img width="607" height="1044" alt="image" src="https://github.com/user-attachments/assets/eaa3125e-00c2-4bfe-bf45-a89cd851eea3" />

## Контрольная точка 6
### Запись

<img width="604" height="319" alt="image" src="https://github.com/user-attachments/assets/c409e2d8-0704-4e52-af2a-3937f56003a5" />

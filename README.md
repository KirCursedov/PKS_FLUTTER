# Отчет по практическому заданию № 5
## Наумов Ярослав Денисович, ЭФБО-10-23

### Цели:
-	Научиться отображать коллекции данных с помощью ListView.builder.
-	Освоить базовую навигацию Navigator.push / Navigator.pop и передачу данных через конструктор.
-	Научиться добавлять, редактировать и удалять элементы списка без внешних пакетов и сложных архитектур.

## Контрольная точка 1
### Список заметок

Отображает список заметок с помощью ListView.builder. Каждая заметка показывается в карточке с заголовком и текстом
``` dart
: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        itemCount: _filteredNotes.length,
                        itemBuilder: (context, index) {
                          final note = _filteredNotes[index];
                          return Dismissible(
                            key: ValueKey(note.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (_) => _deleteNote(note),
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 2,
                              color: const Color.fromARGB(255, 255, 97, 97), // Фон карточек заметок
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                title: Text(
                                  note.title.isEmpty ? '(без названия)' : note.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: note.body.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          note.body,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : null,
                                onTap: () => _editNote(note),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      color: Colors.grey),
                                  onPressed: () => _deleteNote(note),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
```

<img width="518" height="955" alt="image" src="https://github.com/user-attachments/assets/7ace7240-97f5-4f19-b360-df2c9f897988" />

## Контрольная точка 2
### Добавление новой заметки

Открывает экран создания новой заметки
``` dart
  Future<void> _addNote() async {
    final newNote = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (_) => const EditNotePage()),
    );
    
    if (newNote != null && mounted) {
      setState(() => _notes.insert(0, newNote));
    }
  }
```


https://github.com/user-attachments/assets/d9a0d8ec-588f-4e02-9369-fe7d12561431


## Контрольная точка 3
### Редактирование заметки

Открывает экран редактирования существующей заметки
``` dart
Future<void> _editNote(Note note) async {
    final updatedNote = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (_) => EditNotePage(existing: note)),
    );
    
    if (updatedNote != null && mounted) {
      setState(() {
        final index = _notes.indexWhere((n) => n.id == updatedNote.id);
        if (index != -1) {
          _notes[index] = updatedNote;
        }
      });
    }
  }
```


https://github.com/user-attachments/assets/548844e7-53ba-4a6b-92b2-48097be4dcde



## Контрольная точка 4
### Удаление заметки с помощью свапа

Позволяет удалить заметку свайпом влево
``` dart
return Dismissible(
                            key: ValueKey(note.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (_) => _deleteNote(note),
```


https://github.com/user-attachments/assets/c3934af4-10f5-4018-87cc-fb09225b8a68



## Контрольная точка 5
### Удаление заметки с помощью кнопки

Кнопка корзины в правом углу каждой заметки
``` dart
void _deleteNote(Note note) {
    setState(() => _notes.removeWhere((n) => n.id == note.id));
```


https://github.com/user-attachments/assets/0f5fc48e-c387-4810-800f-abeb520ed1cc



Получилось сделать список заметок с помощью ListView.builder, а также научились добавлять, редактировать и удалять элементы списка без внешних пакетов.

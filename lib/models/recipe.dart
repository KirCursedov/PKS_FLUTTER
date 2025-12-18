class Recipe {
  String? id;
  String title;
  String description;
  String ingredients;
  String instructions;
  String? imageBase64;
  String userId;
  DateTime createdAt;

  Recipe({
    this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.instructions,
    this.imageBase64,
    required this.userId,
    required this.createdAt,
  });

  // Конвертация в Map для Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'ingredients': ingredients,
      'instructions': instructions,
      'imageBase64': imageBase64,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Создание из Firestore документа
  static Recipe fromMap(Map<String, dynamic> map, String id) {
    return Recipe(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      ingredients: map['ingredients'] ?? '',
      instructions: map['instructions'] ?? '',
      imageBase64: map['imageBase64'],
      userId: map['userId'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
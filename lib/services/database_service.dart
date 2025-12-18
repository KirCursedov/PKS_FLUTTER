import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookbook_app/models/recipe.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? userId;

  DatabaseService({this.userId});

  CollectionReference get recipesCollection => _firestore.collection('recipes');

  Future<void> addRecipe(Recipe recipe) async {
    try {
      await recipesCollection.add(recipe.toMap());
    } catch (e) {
      print("Ошибка добавления рецепта: $e");
      rethrow;
    }
  }

  // НОВЫЙ МЕТОД: Обновление рецепта
  Future<void> updateRecipe(Recipe recipe) async {
    try {
      if (recipe.id != null) {
        await recipesCollection.doc(recipe.id).update(recipe.toMap());
      }
    } catch (e) {
      print("Ошибка обновления рецепта: $e");
      rethrow;
    }
  }

  Stream<List<Recipe>> getRecipes() {
    if (userId == null) return const Stream.empty();
    
    return recipesCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Recipe.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> deleteRecipe(String recipeId) async {
    await recipesCollection.doc(recipeId).delete();
  }
}
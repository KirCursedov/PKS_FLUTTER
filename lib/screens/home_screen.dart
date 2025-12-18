import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cookbook_app/screens/recipe_detail_screen.dart';
import 'package:cookbook_app/widgets/recipe_card.dart';
import 'package:cookbook_app/models/recipe.dart';
import 'package:cookbook_app/screens/add_edit_recipe_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Моя кулинарная книга'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: RecipeList(userId: userId),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (userId.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                // ИСПРАВЛЕНО: AddRecipeScreen → AddEditRecipeScreen
                builder: (context) => AddEditRecipeScreen(userId: userId),
              ),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class RecipeList extends StatelessWidget {
  final String userId;

  const RecipeList({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    if (userId.isEmpty) {
      return const Center(
        child: Text('Пожалуйста, войдите в систему'),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('recipes')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          final error = snapshot.error.toString();
          if (error.contains('index')) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.sync, size: 50, color: Colors.blue),
                    const SizedBox(height: 16),
                    const Text(
                      'Идет создание индекса...',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Пожалуйста, подождите 1-2 минуты',
                      style: TextStyle(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        (context as Element).markNeedsBuild();
                      },
                      child: const Text('Обновить'),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(child: Text('Ошибка: ${snapshot.error}'));
        }

        final recipesDocs = snapshot.data?.docs ?? [];

        if (recipesDocs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu_book, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Нет рецептов',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Добавьте свой первый рецепт!',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: recipesDocs.length,
          itemBuilder: (context, index) {
            final recipeDoc = recipesDocs[index];
            final data = recipeDoc.data() as Map<String, dynamic>;
            
            final recipe = Recipe(
              id: recipeDoc.id,
              title: data['title'] ?? 'Без названия',
              description: data['description'] ?? '',
              ingredients: data['ingredients'] ?? '',
              instructions: data['instructions'] ?? '',
              imageBase64: data['imageBase64'],
              userId: data['userId'] ?? '',
              createdAt: data['createdAt'] is String 
                  ? DateTime.parse(data['createdAt']) 
                  : (data['createdAt'] as Timestamp).toDate(),
            );
            
            return RecipeCard(
              recipe: recipe,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailScreen(recipe: recipe),
                  ),
                );
              },
              // ИСПРАВЛЕНО: Добавлен параметр onEdit
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditRecipeScreen(
                      userId: userId,
                      recipeToEdit: recipe,
                    ),
                  ),
                );
              },
              onDelete: () {
                _showDeleteDialog(context, recipe);
              },
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, Recipe recipe) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить рецепт?'),
        content: Text('Вы уверены, что хотите удалить "${recipe.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              _deleteRecipe(context, recipe);
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteRecipe(BuildContext context, Recipe recipe) async {
    try {
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipe.id!)
          .delete();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Рецепт "${recipe.title}" удален'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при удалении: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
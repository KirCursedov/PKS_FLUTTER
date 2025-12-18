import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cookbook_app/models/recipe.dart';
import 'package:cookbook_app/screens/add_edit_recipe_screen.dart'; // НОВЫЙ ИМПОРТ

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isOwner = user?.uid == recipe.userId;

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        actions: isOwner
            ? [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditRecipeScreen(
                          userId: recipe.userId,
                          recipeToEdit: recipe,
                        ),
                      ),
                    );
                  },
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение
            if (recipe.imageBase64 != null && recipe.imageBase64!.isNotEmpty)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    base64Decode(recipe.imageBase64!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            
            // Описание
            Text(
              'Описание',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              recipe.description,
              style: const TextStyle(fontSize: 16),
            ),
            
            const SizedBox(height: 20),
            
            // Ингредиенты
            Text(
              'Ингредиенты',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              recipe.ingredients,
              style: const TextStyle(fontSize: 16),
              maxLines: null, // Многострочный текст
            ),
            
            const SizedBox(height: 20),
            
            // Инструкции
            Text(
              'Инструкции приготовления',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              recipe.instructions,
              style: const TextStyle(fontSize: 16),
              maxLines: null, // Многострочный текст
            ),
            
            const SizedBox(height: 20),
            
            // Дата создания
            Text(
              'Добавлено: ${recipe.createdAt.day}.${recipe.createdAt.month}.${recipe.createdAt.year}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
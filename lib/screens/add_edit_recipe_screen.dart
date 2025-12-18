import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cookbook_app/models/recipe.dart';
import 'package:cookbook_app/services/database_service.dart';

class AddEditRecipeScreen extends StatefulWidget {
  final String userId;
  final Recipe? recipeToEdit; // null = добавление, not null = редактирование

  const AddEditRecipeScreen({
    super.key,
    required this.userId,
    this.recipeToEdit,
  });

  @override
  _AddEditRecipeScreenState createState() => _AddEditRecipeScreenState();
}

class _AddEditRecipeScreenState extends State<AddEditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();
  String? _imageBase64;
  bool _isLoading = false;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.recipeToEdit != null;
    
    if (_isEditMode && widget.recipeToEdit != null) {
      // Заполняем поля данными из редактируемого рецепта
      _titleController.text = widget.recipeToEdit!.title;
      _descriptionController.text = widget.recipeToEdit!.description;
      _ingredientsController.text = widget.recipeToEdit!.ingredients;
      _instructionsController.text = widget.recipeToEdit!.instructions;
      _imageBase64 = widget.recipeToEdit!.imageBase64;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBase64 = base64Encode(bytes);
      });
    }
  }

  Future<void> _submitRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final recipe = Recipe(
      id: _isEditMode ? widget.recipeToEdit!.id : null,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      ingredients: _ingredientsController.text.trim(),
      instructions: _instructionsController.text.trim(),
      imageBase64: _imageBase64,
      userId: widget.userId,
      createdAt: _isEditMode 
          ? widget.recipeToEdit!.createdAt 
          : DateTime.now(),
    );

    try {
      final databaseService = DatabaseService(userId: widget.userId);
      
      if (_isEditMode) {
        await databaseService.updateRecipe(recipe);
      } else {
        await databaseService.addRecipe(recipe);
      }
      
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Редактировать рецепт' : 'Добавить рецепт'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _isLoading ? null : _submitRecipe,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Превью изображения
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: _imageBase64 != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(
                                  base64Decode(_imageBase64!),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate,
                                      size: 50, color: Colors.grey[600]),
                                  const SizedBox(height: 8),
                                  Text(
                                    _imageBase64 == null 
                                      ? 'Добавить фото' 
                                      : 'Изменить фото',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Название блюда',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите название';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Описание',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите описание';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _ingredientsController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Ингредиенты',
                        border: OutlineInputBorder(),
                        hintText: 'Каждый ингредиент с новой строки',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите ингредиенты';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _instructionsController,
                      maxLines: 8,
                      decoration: const InputDecoration(
                        labelText: 'Инструкция приготовления',
                        border: OutlineInputBorder(),
                        hintText: 'Пошаговая инструкция',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите инструкцию';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitRecipe,
                        child: Text(_isEditMode ? 'Сохранить изменения' : 'Сохранить рецепт'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
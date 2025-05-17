import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class AddRecipeScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddRecipe;

  const AddRecipeScreen({super.key, required this.onAddRecipe});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();
  final TextEditingController prepTimeController = TextEditingController();

  File? selectedImage;
  int selectedRating = 0;
  String difficulty = 'Easy'; // Προεπιλεγμένη δυσκολία

  String getDifficulty(int rating) {
    if (rating <= 2) {
      return 'Easy';
    } else if (rating <= 4) {
      return 'Medium';
    } else {
      return 'Hard';
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Recipe'),
        backgroundColor: Colors.deepOrange,
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: ingredientsController,
                decoration: const InputDecoration(labelText: 'Ingredients (separated by comma)'),
              ),
              TextField(
                controller: instructionsController,
                decoration: const InputDecoration(labelText: 'Instructions'),
              ),
              TextField(
                controller: prepTimeController,
                decoration: const InputDecoration(
                  labelText: 'Preparation Time',
                  hintText: 'e.g., 30',
                  suffixText: 'minutes',
                ),
                keyboardType: TextInputType.number, // Δέχεται μόνο αριθμούς
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Επιτρέπει μόνο ψηφία
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: pickImage,
                    child: const Text('Select Image'),
                  ),
                  const SizedBox(width: 10),
                  if (selectedImage != null)
                    Text(
                      'Image Selected',
                      style: const TextStyle(color: Colors.green),
                    )
                  else
                    const Text(
                      'No Image Selected',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Rating:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => IconButton(
                    icon: Icon(
                      index < selectedRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedRating = index + 1;
                        difficulty = getDifficulty(selectedRating); // Ενημέρωση δυσκολίας
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Difficulty: $difficulty', // Εμφάνιση της δυσκολίας
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final newRecipe = {
                    'title': titleController.text,
                    'content': contentController.text,
                    'ingredients': ingredientsController.text.split(','),
                    'instructions': instructionsController.text,
                    'image': selectedImage?.path ?? 'assets/images/food_icon.jpg',
                    'rating': selectedRating,
                    'prepTime': prepTimeController.text.isNotEmpty
                        ? prepTimeController.text
                        : 'Unknown',
                    'difficulty': difficulty,
                  };
                  widget.onAddRecipe(newRecipe);
                  Navigator.pop(context);
                },
                child: const Text('Add Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
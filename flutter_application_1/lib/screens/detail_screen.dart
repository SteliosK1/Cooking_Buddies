import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String title;
  final String content;
  final List<String> ingredients;
  final String instructions;
  final String image;
  final int rating;
  final String prepTime;
  final String difficulty;

  const DetailScreen({
    super.key,
    required this.title,
    required this.content,
    required this.ingredients,
    required this.instructions,
    required this.image,
    required this.rating,
    required this.prepTime,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: Colors.deepOrange,
                ),
                const SizedBox(width: 8),
                Text(
                  ' $prepTime',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.emoji_objects,
                  color: Colors.deepOrange,
                ),
                const SizedBox(width: 8),
                Text(
                  'Difficulty: $difficulty',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Ingredients:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...ingredients.map((ingredient) => Text('- $ingredient')),
            const SizedBox(height: 16),
            const Text(
              'Instructions:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(instructions),
          ],
        ),
      ),
    );
  }
}
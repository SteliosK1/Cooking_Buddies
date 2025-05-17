import 'package:flutter/material.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> favorites;
  final Function(Map<String, dynamic>) onRemoveFavorite;

  const FavoritesScreen({
    super.key,
    required this.favorites,
    required this.onRemoveFavorite,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<Map<String, dynamic>> favorites;

  @override
  void initState() {
    super.initState();
    favorites = List.from(widget.favorites); // Δημιουργία τοπικού αντιγράφου της λίστας
  }

  void _removeFavorite(Map<String, dynamic> recipe) {
    setState(() {
      favorites.remove(recipe); // Αφαίρεση από την τοπική λίστα
    });
    widget.onRemoveFavorite(recipe); // Ενημέρωση της αρχικής λίστας
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Recipes'),
        backgroundColor: Colors.deepOrange,
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                'No favorite recipes yet!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final recipe = favorites[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        recipe['image'],
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(recipe['title']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Difficulty: ${recipe['difficulty']}'),
                        Text(
                          recipe['content'], // Προσθήκη περιγραφής
                          maxLines: 1, // Περιορισμός σε μία γραμμή
                          overflow: TextOverflow.ellipsis, // Εμφάνιση "..." αν η περιγραφή είναι μεγάλη
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _removeFavorite(recipe);
                      },
                    ),
                    onTap: () {
                      // Navigate to DetailScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            title: recipe['title'],
                            content: recipe['content'],
                            ingredients: List<String>.from(recipe['ingredients']),
                            instructions: recipe['instructions'],
                            image: recipe['image'],
                            rating: recipe['rating'],
                            prepTime: recipe['prepTime'],
                            difficulty: recipe['difficulty'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
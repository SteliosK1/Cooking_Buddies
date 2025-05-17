import 'package:flutter/material.dart';
import 'favorites_screen.dart';
import 'add_recipe_screen.dart';
import 'detail_screen.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const HomePage({super.key, required this.onThemeToggle});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> items = [
    {
      'title': 'Caesar Salad',
      'content': 'A classic salad with chicken, croutons, and Caesar dressing.',
      'ingredients': ['Chicken', 'Lettuce', 'Croutons', 'Caesar Dressing'],
      'instructions': 'Mix all ingredients and add the dressing.',
      'image': 'assets/images/1.jpg',
      'rating': 2,
      'prepTime': '15 minutes',
      'difficulty': 'Medium',
    },
    {
      'title': 'Classic Pancakes',
      'content': 'Fluffy pancakes for breakfast.',
      'ingredients': ['Flour', 'Milk', 'Eggs', 'Sugar', 'Baking Powder'],
      'instructions': 'Mix the ingredients and fry on medium heat.',
      'image': 'assets/images/2.jpg',
      'rating': 5,
      'prepTime': '20 minutes',
      'difficulty': 'Easy',
    },
    {
      'title': 'Spaghetti Aglio',
      'content': 'A simple yet flavorful pasta with garlic and oil.',
      'ingredients': ['Spaghetti', 'Garlic', 'Olive Oil', 'Pepper'],
      'instructions': 'Boil the spaghetti and sauté the garlic in oil.',
      'image': 'assets/images/3.jpg',
      'rating': 3,
      'prepTime': '25 minutes',
      'difficulty': 'Hard',
    },
  ];

  final List<Map<String, dynamic>> favorites = [];

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sort By',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.star, color: Colors.amber),
                title: const Text('Rating'),
                onTap: () {
                  setState(() {
                    items.sort((a, b) => a['rating'].compareTo(b['rating']));
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.timer, color: Colors.deepOrange),
                title: const Text('Preparation Time'),
                onTap: () {
                  setState(() {
                    items.sort((a, b) {
                      final timeA = int.tryParse(a['prepTime']?.split(' ')[0] ?? '0') ?? 0;
                      final timeB = int.tryParse(b['prepTime']?.split(' ')[0] ?? '0') ?? 0;
                      return timeA.compareTo(timeB);
                    });
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.emoji_objects, color: Colors.green),
                title: const Text('Difficulty'),
                onTap: () {
                  setState(() {
                    const difficultyOrder = {'Easy': 1, 'Medium': 2, 'Hard': 3};
                    items.sort((a, b) {
                      final difficultyA = difficultyOrder[a['difficulty']] ?? 0;
                      final difficultyB = difficultyOrder[b['difficulty']] ?? 0;
                      return difficultyA.compareTo(difficultyB);
                    });
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cooking Buddies',
          style: TextStyle(
            color: Colors.deepOrange,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.favorite_border_outlined),
          color: Colors.deepOrange,
          iconSize: 25,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavoritesScreen(
                  favorites: favorites,
                  onRemoveFavorite: (recipe) {
                    setState(() {
                      favorites.remove(recipe);
                    });
                  },
                ),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode_outlined,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: widget.onThemeToggle,
          ),
          IconButton(
            icon: const Icon(
              Icons.sort,
              color: Colors.deepOrange,
            ),
            onPressed: () {
              _showSortOptions(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: Key(items[index]['title'] ?? 'unknown'),
              direction: DismissDirection.horizontal,
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  setState(() {
                    if (!favorites.contains(items[index])) {
                      favorites.add(items[index]);
                    }
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${items[index]['title']} added to favorites'),
                      duration: const Duration(seconds: 2),
                    ),
                  );

                  return false;
                } else if (direction == DismissDirection.endToStart) {
                  final removedItem = items[index];
                  setState(() {
                    items.removeAt(index);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${removedItem['title']} deleted'),
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          setState(() {
                            items.insert(index, removedItem);
                          });
                        },
                      ),
                    ),
                  );

                  return true;
                }
                return false;
              },
              background: Container(
                color: Colors.green,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        title: items[index]['title'] ?? 'No Title',
                        content: items[index]['content'] ?? 'No Content',
                        ingredients: List<String>.from(items[index]['ingredients'] ?? []),
                        instructions: items[index]['instructions'] ?? 'No Instructions',
                        image: items[index]['image'] ?? 'assets/images/default.jpg',
                        rating: items[index]['rating'] ?? 0,
                        prepTime: items[index]['prepTime'] ?? 'Unknown',
                        difficulty: items[index]['difficulty'] ?? 'Unknown',
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                items[index]['image'],
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  items[index]['title']!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Difficulty: ${items[index]['difficulty']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                  title: items[index]['title'] ?? 'No Title',
                                  content: items[index]['content'] ?? 'No Content',
                                  ingredients: List<String>.from(items[index]['ingredients'] ?? []),
                                  instructions: items[index]['instructions'] ?? 'No Instructions',
                                  image: items[index]['image'] ?? 'assets/images/default.jpg',
                                  rating: items[index]['rating'] ?? 0,
                                  prepTime: items[index]['prepTime'] ?? 'Unknown',
                                  difficulty: items[index]['difficulty'] ?? 'Unknown',
                                ),
                              ),
                            );
                          },
                          child: const Text('View Recipe'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddRecipeScreen(
                  onAddRecipe: (newRecipe) {
                    setState(() {
                      items.add(newRecipe);
                    });
                  },
                ),
              ),
            );
          },
          backgroundColor: Colors.deepOrange,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
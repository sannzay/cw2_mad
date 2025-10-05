import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'details_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Recipe> recipes;

  @override
  void initState() {
    super.initState();
    recipes = _initialRecipes();
  }

  List<Recipe> _initialRecipes() {
    return [
      Recipe(
        id: 1,
        title: 'Spaghetti Aglio e Olio',
        ingredients: [
          '200g spaghetti',
          '3 cloves garlic',
          '1/4 cup olive oil',
          'Red pepper flakes',
          'Parsley',
          'Salt'
        ],
        instructions:
            'Cook pasta until al dente. In a pan, gently sauté minced garlic in olive oil until golden, add red pepper flakes, toss pasta with oil and parsley. Serve hot.',
      ),
      Recipe(
        id: 2,
        title: 'Caprese Salad',
        ingredients: [
          'Tomatoes',
          'Fresh mozzarella',
          'Basil leaves',
          'Olive oil',
          'Balsamic glaze',
          'Salt & pepper'
        ],
        instructions:
            'Slice tomatoes and mozzarella. Arrange on plate, tuck basil leaves between slices. Drizzle olive oil and balsamic glaze. Season to taste.',
      ),
      Recipe(
        id: 3,
        title: 'Pancakes',
        ingredients: [
          '1 cup flour',
          '1 cup milk',
          '1 egg',
          '1 tbsp sugar',
          '1 tsp baking powder',
          'Pinch of salt'
        ],
        instructions:
            'Mix dry ingredients, whisk in milk and egg until smooth. Pour batter on hot griddle, flip when bubbles form, cook until golden.',
      ),
    ];
  }

  void _toggleFavorite(Recipe recipe) {
    setState(() {
      recipe.isFavorite = !recipe.isFavorite;
    });
  }

  void _openDetails(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(
          recipe: recipe,
          onToggleFavorite: _toggleFavorite,
        ),
      ),
    ).then((_) {
      // Returned when details screen popped - HomeScreen's state already updates via callback
      setState(() {}); // refresh list tiles (favorite icons)
    });
  }

  void _viewFavorites() {
    final favorites = recipes.where((r) => r.isFavorite).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritesScreen(
          favorites: favorites,
          onToggleFavorite: (recipe) {
            _toggleFavorite(recipe);
          },
        ),
      ),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Recipes'),
        actions: [
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,      // bright background
                foregroundColor: Colors.deepOrange, // text/icon color
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                ),
                ),
                onPressed: _viewFavorites,
                icon: const Icon(Icons.favorite),
                label: const Text('View Favorites'),
            ),
            ),
        ],
        ),
      body: ListView.separated(
        itemCount: recipes.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final r = recipes[index];
          return ListTile(
            leading: CircleAvatar(child: Text(r.title[0])),
            title: Text(r.title),
            subtitle: Text('${r.ingredients.length} ingredients'),
            trailing: Icon(
              r.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: r.isFavorite ? Colors.red : null,
            ),
            onTap: () => _openDetails(r),
          );
        },
      ),
    );
  }
}

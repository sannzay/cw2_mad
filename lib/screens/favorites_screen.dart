import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Recipe> favorites;
  final void Function(Recipe) onToggleFavorite;

  const FavoritesScreen({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<Recipe> localFavorites;

  @override
  void initState() {
    super.initState();
    // Make a local copy to show immediate UI updates here when user toggles.
    localFavorites = List<Recipe>.from(widget.favorites);
  }

  void _openDetails(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(
          recipe: recipe,
          onToggleFavorite: (r) {
            widget.onToggleFavorite(r);
            setState(() {
              localFavorites = localFavorites.where((x) => x.isFavorite).toList();
            });
          },
        ),
      ),
    ).then((_) {
      setState(() {
        localFavorites = localFavorites.where((x) => x.isFavorite).toList();
      });
    });
  }

  void _unfavorite(Recipe r) {
    widget.onToggleFavorite(r);
    setState(() {
      localFavorites.removeWhere((x) => x.id == r.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: localFavorites.isEmpty
          ? const Center(child: Text('No favorites yet.'))
          : ListView.separated(
              itemCount: localFavorites.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final r = localFavorites[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(r.title[0])),
                  title: Text(r.title),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _unfavorite(r),
                    tooltip: 'Remove from favorites',
                  ),
                  onTap: () => _openDetails(r),
                );
              },
            ),
    );
  }
}

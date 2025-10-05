import 'package:flutter/material.dart';
import '../models/recipe.dart';

class DetailsScreen extends StatefulWidget {
  final Recipe recipe;
  final void Function(Recipe) onToggleFavorite;

  const DetailsScreen({
    super.key,
    required this.recipe,
    required this.onToggleFavorite,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late bool isFav;

  @override
  void initState() {
    super.initState();
    isFav = widget.recipe.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      isFav = !isFav;
    });
    widget.onToggleFavorite(widget.recipe);
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.recipe;
    return Scaffold(
      appBar: AppBar(
        title: Text(r.title),
        actions: [
          IconButton(
            onPressed: _toggleFavorite,
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : null,
            ),
            tooltip: isFav ? 'Unmark Favorite' : 'Mark Favorite',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ingredients', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...r.ingredients.map((ing) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(children: [const Icon(Icons.check, size: 16), const SizedBox(width: 8), Expanded(child: Text(ing))]),
            )),
            const SizedBox(height: 16),
            const Text('Instructions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(r.instructions),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _toggleFavorite();
                  final snackMsg = isFav ? 'Marked as favorite' : 'Removed from favorites';
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snackMsg)));
                },
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                label: Text(isFav ? 'Unfavorite' : 'Favorite'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

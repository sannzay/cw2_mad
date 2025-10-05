class Recipe {
  final int id;
  final String title;
  final List<String> ingredients;
  final String instructions;
  bool isFavorite;

  Recipe({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    this.isFavorite = false,
  });
}

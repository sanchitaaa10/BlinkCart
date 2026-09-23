import 'product.dart';

class RecipeItem {
  final String id;
  final String title;
  final String subtitle;
  final String cookTime;
  final String difficulty;
  final int calories;
  final String imageUrl;
  final String description;
  final List<Product> requiredIngredients;
  final List<String> steps;

  const RecipeItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.cookTime,
    required this.difficulty,
    required this.calories,
    required this.imageUrl,
    required this.description,
    required this.requiredIngredients,
    required this.steps,
  });

  double get totalIngredientCost =>
      requiredIngredients.fold(0.0, (sum, p) => sum + p.price);
}

import '../models/recipe_item.dart';
import '../models/product.dart';
import 'mock_products.dart';

class MockRecipes {
  static List<RecipeItem> getRecipes() {
    Product getProduct(String id) =>
        MockProducts.products.firstWhere((p) => p.id == id,
            orElse: () => MockProducts.products.first);

    return [
      RecipeItem(
        id: 'recipe-paneer-butter',
        title: 'Paneer Butter Masala',
        subtitle: 'Velvety tomato gravy with soft paneer cubes',
        cookTime: '15 mins',
        difficulty: 'Easy',
        calories: 380,
        imageUrl: 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=600&q=80',
        description: 'Rich, mildly spiced North Indian curry made with fresh cottage cheese, ripened hybrid tomatoes, butter, and aromatic shahi garam masala.',
        requiredIngredients: [
          getProduct('db-05'), // Fresh Malai Paneer
          getProduct('fv-02'), // Fresh Hybrid Tomatoes
          getProduct('fv-03'), // Farm Fresh Onions
          getProduct('db-02'), // Amul Butter
          getProduct('stp-06'), // Everest Garam Masala
        ],
        steps: [
          'Chop fresh hybrid tomatoes and onions finely.',
          'Melt 2 tbsp Amul Butter in a hot pan and sauté onions until golden brown.',
          'Add tomato purée and simmer for 5 minutes with Garam Masala and salt.',
          'Cut Fresh Paneer into 1-inch cubes and gently stir into the simmering velvety gravy.',
          'Garnish with a dollop of fresh butter and serve piping hot with soft rotis or rice.',
        ],
      ),
      RecipeItem(
        id: 'recipe-avocado-toast',
        title: 'Avocado Toast with Poached Eggs',
        subtitle: 'Cafe-style wholesome high-protein breakfast',
        cookTime: '10 mins',
        difficulty: 'Quick',
        calories: 310,
        imageUrl: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?auto=format&fit=crop&w=600&q=80',
        description: 'Nutritious toasted whole wheat bread topped with creamy mashed Hass avocado, poached farm egg, and fresh cracked pepper.',
        requiredIngredients: [
          getProduct('fv-06'), // Hass Avocado
          getProduct('bk-01'), // Whole Wheat Bread
          getProduct('db-03'), // Farm Fresh Eggs
          getProduct('stp-08'), // Extra Virgin Olive Oil
        ],
        steps: [
          'Toast 2 slices of 100% Whole Wheat Bread until crispy and golden.',
          'Scoop out ripe Hass avocado flesh into a bowl, add a pinch of salt and lemon juice, and mash coarsely with a fork.',
          'Poach 2 farm-fresh eggs in simmering water for 3 minutes until yolk is gently runny.',
          'Spread generous mashed avocado onto the warm toast, top with poached eggs, and drizzle extra virgin olive oil.',
        ],
      ),
      RecipeItem(
        id: 'recipe-garlic-pasta',
        title: 'Creamy Garlic Mushroom Penne',
        subtitle: 'Al dente Italian pasta with sautéed button mushrooms',
        cookTime: '12 mins',
        difficulty: 'Easy',
        calories: 420,
        imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3d5d6281734?auto=format&fit=crop&w=600&q=80',
        description: 'Authentic Italian comfort food: al dente durum wheat penne tossed with garlic butter, sliced mushrooms, and extra virgin olive oil.',
        requiredIngredients: [
          getProduct('inf-07'), // Barilla Penne Pasta
          getProduct('fv-10'), // Button Mushrooms
          getProduct('db-02'), // Amul Butter
          getProduct('stp-08'), // Extra Virgin Olive Oil
        ],
        steps: [
          'Boil Barilla Penne in salted boiling water for 10 minutes until perfectly al dente.',
          'In a pan, heat olive oil and butter, then sauté sliced button mushrooms and minced garlic for 3 minutes.',
          'Transfer drained pasta directly into the sauté pan with 2 spoons of pasta water.',
          'Toss vigorously until sauce glazes the pasta and season with fresh cracked black pepper.',
        ],
      ),
      RecipeItem(
        id: 'recipe-detox-smoothie',
        title: 'Berry Detox Smoothie Bowl',
        subtitle: 'Refreshing antioxidant boost packed with Greek yogurt',
        cookTime: '5 mins',
        difficulty: 'Instant',
        calories: 240,
        imageUrl: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?auto=format&fit=crop&w=600&q=80',
        description: 'Vibrant chilled smoothie bowl made with wild blueberries, fresh bananas, high-protein Greek yogurt, and roasted almonds.',
        requiredIngredients: [
          getProduct('fv-05'), // Mahabaleshwar Strawberries
          getProduct('fv-01'), // Fresh Bananas
          getProduct('db-06'), // Epigamia Greek Yogurt
          getProduct('sn-08'), // Roasted California Almonds
        ],
        steps: [
          'Place fresh strawberries, half a banana, and blueberry Greek yogurt in a blender.',
          'Blend on high speed for 45 seconds until thick and velvety smooth.',
          'Pour into a chilled bowl and top with sliced bananas, strawberries, and crunchy roasted almonds.',
        ],
      ),
      RecipeItem(
        id: 'recipe-masala-maggi',
        title: 'Mumbai Street-Style Masala Maggi',
        subtitle: 'Loaded with crunchy veggies and melting butter',
        cookTime: '5 mins',
        difficulty: 'Quick',
        calories: 340,
        imageUrl: 'https://images.unsplash.com/photo-1612927601601-6638404737ce?auto=format&fit=crop&w=600&q=80',
        description: 'Classic 2-minute noodles upgraded with sautéed onions, tomatoes, green chilies, and a dollop of Amul butter.',
        requiredIngredients: [
          getProduct('inf-01'), // Maggi 4-Pack
          getProduct('fv-02'), // Hybrid Tomatoes
          getProduct('fv-03'), // Fresh Onions
          getProduct('db-02'), // Amul Butter
        ],
        steps: [
          'Finely dice 1 small onion and 1 tomato.',
          'In a saucepan, sauté the veggies in 1 tsp Amul Butter for 1 minute.',
          'Add 1.5 cups water and Maggi tastemaker seasoning packet; bring to a rolling boil.',
          'Break noodle cake into the pan and simmer for 2 minutes until cooked to street-style perfection.',
        ],
      ),
    ];
  }
}

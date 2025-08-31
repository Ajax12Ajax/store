import '../models/product.dart';

class UserPreferences {
  final Map<String, int> categoryVisits;
  final Map<String, int> colorPreferences;
  final Map<String, int> materialPreferences;
  final Map<String, int> fitPreferences;
  final Map<int, int> productClicks;

  UserPreferences({
    Map<String, int>? categoryVisits,
    Map<String, int>? colorPreferences,
    Map<String, int>? materialPreferences,
    Map<String, int>? fitPreferences,
    Map<int, int>? productClicks,
  }) : categoryVisits = categoryVisits ?? {},
       colorPreferences = colorPreferences ?? {},
       materialPreferences = materialPreferences ?? {},
       fitPreferences = fitPreferences ?? {},
       productClicks = productClicks ?? {};

  void trackProductInteraction(Product product) {
    productClicks[product.id] = (productClicks[product.id] ?? 0) + 1;
    categoryVisits[product.category] = (categoryVisits[product.category] ?? 0) + 1;
    colorPreferences[product.color] = (colorPreferences[product.color] ?? 0) + 1;
    fitPreferences[product.fit] = (fitPreferences[product.fit] ?? 0) + 1;
    for (var material in product.materials) {
      materialPreferences[material] = (materialPreferences[material] ?? 0) + 1;
    }
  }

  void trackCategoryVisit(String category) {
    categoryVisits[category] = (categoryVisits[category] ?? 0) + 1;
  }

  Map<String, dynamic> buildRequest() {
    return {
      'categoryVisits': categoryVisits,
      'colorPreferences': colorPreferences,
      'materialPreferences': materialPreferences,
      'fitPreferences': fitPreferences,
      'productClicks': productClicks.map((key, value) => MapEntry(key.toString(), value)),
    };
  }
}

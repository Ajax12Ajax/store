import '../models/item.dart';

class UserPreferences {
  final Map<String, int> categoryVisits;
  final Map<String, int> colorPreferences;
  final Map<String, int> materialPreferences;
  final Map<String, int> fitPreferences;
  final Map<String, int> itemClicks;

  UserPreferences({
    Map<String, int>? categoryVisits,
    Map<String, int>? colorPreferences,
    Map<String, int>? materialPreferences,
    Map<String, int>? fitPreferences,
    Map<String, int>? itemClicks,
  }) : categoryVisits = categoryVisits ?? {},
       colorPreferences = colorPreferences ?? {},
       materialPreferences = materialPreferences ?? {},
       fitPreferences = fitPreferences ?? {},
       itemClicks = itemClicks ?? {};

  void trackItemInteraction(Item item) {
    itemClicks[item.id] = (itemClicks[item.id] ?? 0) + 1;
    categoryVisits[item.category] = (categoryVisits[item.category] ?? 0) + 1;
    colorPreferences[item.color] = (colorPreferences[item.color] ?? 0) + 1;
    fitPreferences[item.fit] = (fitPreferences[item.fit] ?? 0) + 1;
    for (var material in item.materials) {
      materialPreferences[material] = (materialPreferences[material] ?? 0) + 1;
    }
  }

  void trackCategoryVisit(String category) {
    categoryVisits[category] = (categoryVisits[category] ?? 0) + 1;
  }
}

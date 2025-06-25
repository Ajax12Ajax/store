import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:store/services/user_preferences.dart';

import '../models/item.dart';

class ItemService {
  static final ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> isFiltering = ValueNotifier<bool>(false);

  static List<Item> items = [];
  static List<Item> filteredItems = [];

  static String searchQuery = '';
  static String? selectedCategory;

  static Future<List<Item>> loadItems() async {
    isLoading.value = true;
    try {
      final String response = await rootBundle.loadString('assets/items.json');
      final data = await json.decode(response) as List;
      return items = data.map((item) => Item.fromJson(item)).toList();
    } finally {
      isLoading.value = false;
    }
  }

  static Future<List<Item>> filterItems() async {
    isFiltering.value = true;
    try {
      if (selectedCategory == 'for_you') {
        return filteredItems = getRecommendedItems(false);
      } else {
        return filteredItems = items.where((item) {
          final matchesQuery = searchQuery.isEmpty ||
              item.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              item.brand.toLowerCase().contains(searchQuery.toLowerCase()) ||
              item.category.toLowerCase().contains(searchQuery.toLowerCase()) ||
              item.color.toLowerCase().contains(searchQuery.toLowerCase()) ||
              item.fit.toLowerCase().contains(searchQuery.toLowerCase()) ||
              item.materials
                  .any((material) => material.toLowerCase().contains(searchQuery.toLowerCase()));

          final matchesCategory = selectedCategory == null || item.category == selectedCategory;

          return matchesQuery && matchesCategory;
        }).toList();
      }
    } finally {
      isFiltering.value = false;
    }
  }

  static final UserPreferences userPrefs = UserPreferences();

  static List<Item> getRecommendedItems(bool thumbnail) {
    if (items.isEmpty) return [];
    final scoredItems = items.map((item) {
      double score = 0.0;
      score += userPrefs.categoryVisits[item.category] ?? 0;
      score += userPrefs.colorPreferences[item.color] ?? 0;
      for (var material in item.materials) {
        score += userPrefs.materialPreferences[material] ?? 0;
      }
      score += userPrefs.fitPreferences[item.fit] ?? 0;
      return MapEntry(item, score);
    }).toList();

    scoredItems.sort((a, b) => b.value.compareTo(a.value));
    if (thumbnail) {
      while (scoredItems[0].key.name.length >= 20) {
        scoredItems.removeAt(0);
      }
      while (scoredItems[1].key.name.length >= 19) {
        scoredItems.removeAt(1);
      }
      while (scoredItems[2].key.name.length >= 19) {
        scoredItems.removeAt(2);
      }
      return scoredItems.take(3).map((e) => e.key).toList();
    }
    return scoredItems.take(9 + Random().nextInt(3)).map((e) => e.key).toList();
  }

  static void trackItemClick(Item item) {
    userPrefs.trackItemInteraction(item);
  }

  static void trackCategoryView(String category) {
    userPrefs.trackCategoryVisit(category);
  }

  static List<Item> getSimilarItems(Item item) {
    if (items.isEmpty) return [];
    final scoredItems = items.where((i) => i.id != item.id).map((otherItem) {
      double score = 0.0;
      if (otherItem.category == item.category) {
        score += 4.0;
      }
      if (otherItem.color == item.color) {
        score += 2.0;
      }
      score += otherItem.materials.where((m) => item.materials.contains(m)).length * 1.5;
      if (otherItem.fit == item.fit) {
        score += 2.0;
      }
      score += (userPrefs.categoryVisits[otherItem.category] ?? 0) * 0.1;
      score += (userPrefs.colorPreferences[otherItem.color] ?? 0) * 0.1;
      return MapEntry(otherItem, score);
    }).toList();

    scoredItems.sort((a, b) => b.value.compareTo(a.value));
    return scoredItems.take(2).map((e) => e.key).toList();
  }
}

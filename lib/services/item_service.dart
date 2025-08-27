import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:store/models/category.dart';
import 'package:store/screens/home.dart';
import 'package:store/services/constants.dart';
import 'package:store/services/user_preferences.dart';

import '../models/item.dart';

class ItemService {
  static List<Category> categories = [];
  final ValueNotifier<ConnectionState> loadingState = ValueNotifier<ConnectionState>(
    ConnectionState.none,
  );
  static final UserPreferences userPrefs = UserPreferences();

  static Future loadCategories() async {
    try {
      final response = await http.get(Uri.parse('${Constants.BASE_URL}/categories'));
      if (response.statusCode == 200) {
        final data = await json.decode(response.body) as List;
        categories = data.map((category) => Category.fromJson(category)).toList();
      } else {
        print('Categories load error: ${response.statusCode}');
        return;
      }
    } catch (e) {
      print('Server error: $e');
      return;
    }
  }


  Future<List<Item>> getRecommendationsPreview() async {
    print('Fetching recommendations preview...');
    final response = await _loadItems(
      http.post(
        Uri.parse('${Constants.BASE_URL}/recommendations/preview'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userPrefs.buildRequest(3)),
      ),
    );
    print(
      'in item service For You Items: ${response.map((item) => '${item.name}: ${item.price}zł').toList()}',
    );
    return response;
  }

  Future<List<Item>> getFullRecommendations({int limit = 20}) async {
    return await _loadItems(
      http.post(
        Uri.parse('${Constants.BASE_URL}/recommendations/full'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userPrefs.buildRequest(limit)),
      ),
    );
  }

  Future<List<Item>> loadNewArrivalItems() {
    return _loadItems(
      http.get(
        Uri.parse(
          '${Constants.BASE_URL}/product/482193,927415,604238,150982,398712,120934,347829,238671,715093',
        ),
      ),
    );
  }

  Future<List<Item>> loadCategoryItems(int categoryId) {
    return _loadItems(http.get(Uri.parse('${Constants.BASE_URL}/category/$categoryId')));
  }

  Future<List<Item>> loadSearchQueryItems(String query) {
    return _loadItems(http.get(Uri.parse('${Constants.BASE_URL}/search?q=$query')));
  }

  Future<List<Item>> loadSimilarItems(int itemId) {
    return _loadItems(http.get(Uri.parse('${Constants.BASE_URL}/product/$itemId/similar')));
  }

  Future<List<Item>> _loadItems(final http) async {
    loadingState.value = ConnectionState.waiting;
    try {
      final response = await http;
      if (response.statusCode == 200) {
        final data = await json.decode(response.body) as List;
        final list = data.map((item) => Item.fromJson(item)).toList();
        loadingState.value = ConnectionState.done;
        return list;
      } else {
        loadingState.value = ConnectionState.none;
        print('Product load error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      loadingState.value = ConnectionState.none;
      print('Server error: $e');
      return [];
    }
  }

  /*
  static List<Item> getRecommendedItems(bool thumbnail) {
    isFiltering.value = true;
    try {
      selectedCategory = 'for_you';
      searchQuery = null;
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
      List<Item> list = scoredItems.take(9 + Random().nextInt(3)).map((e) => e.key).toList();
      return thumbnail ? list : (filteredItems = list);
    } finally {
      isFiltering.value = false;
    }
  }
   */

  static Future<void> updateRecommendations() async {
    HomeState.forYouItems = await HomeState.itemService.getRecommendationsPreview();
    // it can't use HomeState
  }

  static void trackItemClick(Item item) {
    //userPrefs.trackItemInteraction(item);
    //Future.microtask(() => updateRecommendations());
  }

  static void trackCategoryView(String category) {
    //userPrefs.trackCategoryVisit(category);
    //Future.microtask(() => updateRecommendations());
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:store/models/category.dart';
import 'package:store/services/constants.dart';
import 'package:store/services/user_preferences.dart';

import '../models/product.dart';

class ProductService {
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

  Future<List<Product>> loadRecommendationsPreviewProducts() async {
    return await _loadProducts(
      http.post(
        Uri.parse('${Constants.BASE_URL}/recommendations/preview'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userPrefs.buildRequest()),
      ),
    );
  }

  Future<List<Product>> loadRecommendationsProducts() async {
    return await _loadProducts(
      http.post(
        Uri.parse('${Constants.BASE_URL}/recommendations'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userPrefs.buildRequest()),
      ),
    );
  }

  Future<List<Product>> loadNewArrivalProducts() {
    return _loadProducts(
      http.get(
        Uri.parse(
          '${Constants.BASE_URL}/product/482193,927415,604238,150982,398712,120934,347829,238671,715093',
        ),
      ),
    );
  }

  Future<List<Product>> loadCategoryProducts(int categoryId) {
    return _loadProducts(http.get(Uri.parse('${Constants.BASE_URL}/category/$categoryId')));
  }

  Future<List<Product>> loadSearchQueryProducts(String query) {
    return _loadProducts(http.get(Uri.parse('${Constants.BASE_URL}/search?q=$query')));
  }

  Future<List<Product>> loadSimilarProducts(int productId) {
    return _loadProducts(http.get(Uri.parse('${Constants.BASE_URL}/product/$productId/similar')));
  }

  Future<List<Product>> _loadProducts(final http) async {
    loadingState.value = ConnectionState.waiting;
    try {
      final response = await http;
      if (response.statusCode == 200) {
        final data = await json.decode(response.body) as List;
        final list = data.map((product) => Product.fromJson(product)).toList();
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

  static Timer? _recommendationsDebounceTimer;
  static void Function()? onRecommendationsUpdate;

  static Future<void> updateRecommendations() async {
    if (_recommendationsDebounceTimer != null && _recommendationsDebounceTimer!.isActive) return;
    _recommendationsDebounceTimer?.cancel();
    _recommendationsDebounceTimer = Timer(const Duration(seconds: 5), () {
      onRecommendationsUpdate?.call();
    });
  }

  static Future<void> updateRecommendationsNow() async {
    if (_recommendationsDebounceTimer != null && _recommendationsDebounceTimer!.isActive) {
      _recommendationsDebounceTimer?.cancel();
      Future.microtask(() => onRecommendationsUpdate?.call());
    }
  }

  static void trackProductClick(Product product) {
    userPrefs.trackProductInteraction(product);
    Future.microtask(() => updateRecommendations());
  }

  static void trackCategoryView(String category) {
    userPrefs.trackCategoryVisit(category);
    Future.microtask(() => updateRecommendations());
  }
}

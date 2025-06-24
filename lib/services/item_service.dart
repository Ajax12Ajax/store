import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

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
    } finally {
      isFiltering.value = false;
    }
  }
}

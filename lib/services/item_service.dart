import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/item.dart';

class ItemService {
  static Future<List<Item>> loadItems() async {
    final String response = await rootBundle.loadString('assets/items.json');
    final data = await json.decode(response) as List;
    return data.map((item) => Item.fromJson(item)).toList();
  }

  static List<Item> filterItems(List<Item> items, String query, String? category) {
    return items.where((item) {
      final matchesQuery = query.isEmpty ||
          item.name.toLowerCase().contains(query.toLowerCase()) ||
          item.brand.toLowerCase().contains(query.toLowerCase()) ||
          item.category.toLowerCase().contains(query.toLowerCase()) ||
          item.color.toLowerCase().contains(query.toLowerCase()) ||
          item.fit.toLowerCase().contains(query.toLowerCase()) ||
          item.materials.any((material) => material.toLowerCase().contains(query.toLowerCase()));

      final matchesCategory = category == null || item.category == category;

      return matchesQuery && matchesCategory;
    }).toList();
  }
}

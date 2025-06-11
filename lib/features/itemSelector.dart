import 'dart:convert';
import 'package:flutter/services.dart';

class ItemSelector {
  static Future<List<Map<String, dynamic>>> getItemsByCategory(String category) async {
    final String jsonString = await rootBundle.loadString('assets/items.json');
    final List<dynamic> items = json.decode(jsonString);

    return items
        .where((item) => item['category'] == category)
        .cast<Map<String, dynamic>>()
        .toList();
  }

  static Future<Map<String, dynamic>?> getItemById(String id) async {
    final String jsonString = await rootBundle.loadString('assets/items.json');
    final List<dynamic> items = json.decode(jsonString);

    try {
      return items.firstWhere(
        (item) => item['id'] == id,
        orElse: () => null,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> filterItems({
    String? category,
    String? brand,
    String? color,
    String? fit,
    List<String>? materials,
  }) async {
    final String jsonString = await rootBundle.loadString('assets/items.json');
    final List<dynamic> items = json.decode(jsonString);

    return items.where((item) {
      bool matches = true;

      if (category != null) matches &= item['category'] == category;
      if (brand != null) matches &= item['brand'] == brand;
      if (color != null) matches &= item['color'] == color;
      if (fit != null) matches &= item['fit'] == fit;
      if (materials != null) {
        matches &= materials.every(
          (material) => (item['materials'] as List).contains(material)
        );
      }

      return matches;
    }).cast<Map<String, dynamic>>().toList();
  }
}
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:store/main.dart';
import 'package:store/models/item.dart';
import 'package:store/widgets/panel_pair_item.dart';
import 'package:store/widgets/panel_trio_item.dart';

import '../../services/item_service.dart';

class Catalog extends StatefulWidget {
  const Catalog({super.key});

  @override
  State<Catalog> createState() => CatalogState();
}

class CatalogState extends State<Catalog> {
  static late ItemService _itemService;
  static String _label = '';
  static List<Item> _catalogItems = [];


  void showCategoryItems(int id) async {
    String currentRoute = '';
    MyAppState.navigatorKey.currentState?.popUntil((route) {
      currentRoute = route.settings.name ?? '';
      return true;
    });
    final label = ItemService.categories.firstWhere((category) => category.id == id).category;
    if (_label != label || currentRoute != '/catalog') {
      _label = label;
      _itemService = ItemService();
      navigateToCatalog();
      _catalogItems = await _itemService.loadCategoryItems(id);
    }
    ItemService.trackCategoryView(_label);
  }

  void showSearchQueryItems(String query) async {
    _label = "\"$query\"";
    _itemService = ItemService();
    navigateToCatalog();
    _catalogItems = await _itemService.loadSearchQueryItems(query);
  }

  void navigateToCatalog() {
    MyAppState.navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/catalog',
      (route) => route.settings.name == '/',
    );
  }


  List<Widget> _buildItemList(List<Item> items) {
    List<Widget> widgets = [];
    int itemIndex = 0;
    int itemCount = items.length;

    double threeSpots = 0;
    double currentThreeSpots = 0;
    bool firstThreeSpots = true;
    if (itemCount % 2 == 0 && itemCount >= 12) {
      threeSpots += (2 * (itemCount / 12 - (itemCount / 12) % 1));
    } else if (itemCount % 2 == 1) {
      threeSpots++;
      if (itemCount >= 19) {
        threeSpots += (2 * (itemCount / 19 - (itemCount / 12) % 1));
      }
    }
    double spacing = ((itemCount - (threeSpots * 3)) / 2) / (threeSpots + 1);
    spacing -= spacing % 1;

    while (itemIndex < itemCount) {
      if ((itemCount == 3 || itemIndex + 3 <= itemCount) &&
          threeSpots > 0 &&
          (Random().nextBool() || currentThreeSpots >= spacing + 1) &&
          (currentThreeSpots >= spacing || firstThreeSpots) &&
          items[itemIndex].name.length < 20 &&
          items[itemIndex + 1].name.length < 19 &&
          items[itemIndex + 2].name.length < 19) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.5),
            child: DisplayThreeSpots(items: items.sublist(itemIndex, itemIndex + 3)),
          ),
        );
        itemIndex += 3;
        threeSpots--;
        currentThreeSpots = 0;
        firstThreeSpots = false;
      } else if (itemIndex + 2 <= itemCount) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.5),
            child: DisplayTwoSpots(items: items.sublist(itemIndex, itemIndex + 2)),
          ),
        );
        itemIndex += 2;
        currentThreeSpots++;
      } else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.5),
            child: DisplayTwoSpots(items: items.sublist(itemIndex, itemIndex + 1)),
          ),
        );
        itemIndex++;
        currentThreeSpots++;
      }
    }
    return widgets;
  }


  List<Widget> _itemList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: ValueListenableBuilder<ConnectionState>(
        valueListenable: _itemService.loadingState,
        builder: (context, loadingState, _) {
          if (loadingState == ConnectionState.done) {
            if (_itemList.isEmpty) _itemList = _buildItemList(_catalogItems);
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  child: Text(
                    _label,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Column(children: _itemList),
                    ),
                  ),
                ),
              ],
            );
          } else if (loadingState == ConnectionState.waiting) {
            _itemList = [];
            return const Center(child: CircularProgressIndicator(color: Color(0xFF000000)));
          }
          _itemList = [];
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Color(0xFF000000)),
                SizedBox(height: 16),
                Text(
                  'Failed to load products',
                  style: TextStyle(fontFamily: 'Outfit', fontSize: 16, color: Color(0xFF000000)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

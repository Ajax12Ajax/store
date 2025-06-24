import 'dart:math';

import 'package:flutter/material.dart';
import 'package:store/main.dart';
import 'package:store/widgets/panel_pair_item.dart';
import 'package:store/widgets/panel_trio_item.dart';

import '../../services/item_service.dart';

class Catalog extends StatefulWidget {
  const Catalog({super.key});

  @override
  State<Catalog> createState() => CatalogState();
}

class CatalogState extends State<Catalog> {
  static bool _isLoading = true;
  static List<Widget> _itemList = [];

  @override
  void initState() {
    super.initState();
    _initializeItems();
  }

  void _initializeItems() {
    if (!ItemService.isLoading.value) {
      _applyFilters();
    } else {
      ItemService.isLoading.addListener(() {
        if (!ItemService.isLoading.value) {
          _applyFilters();
          ItemService.isLoading.removeListener(_initializeItems);
        }
      });
    }
  }

  void _applyFilters() {
    ItemService.isFiltering.addListener(_onFilteringChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ItemService.filterItems();
    });
  }

  void _onFilteringChanged() {
    if (!ItemService.isFiltering.value && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _itemList = _buildItemList();
          _isLoading = false;
        });
      });
    }
  }

  static void changeCategory(String? searchQuery, String? category) {
    _isLoading = true;
    String currentRoute = '';
    MyAppState.navigatorKey.currentState?.popUntil((route) {
      currentRoute = route.settings.name ?? '';
      return true;
    });
    ItemService.selectedCategory = category;
    ItemService.searchQuery = searchQuery ?? '';
    if (currentRoute != '/catalog') {
      MyAppState.navigatorKey.currentState
          ?.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      MyAppState.navigatorKey.currentState?.pushNamed('/catalog');
    } else {
      if (!ItemService.isLoading.value) {
        ItemService.filterItems();
      } else {
        ItemService.isLoading.addListener(() => ItemService.filterItems());
      }
    }
  }

  static List<Widget> _buildItemList() {
    List<Widget> widgets = [];
    int itemIndex = 0;
    int itemCount = ItemService.filteredItems.length;

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
          ItemService.filteredItems[itemIndex].name.length < 20 &&
          ItemService.filteredItems[itemIndex + 1].name.length < 19 &&
          ItemService.filteredItems[itemIndex + 2].name.length < 19) {
        widgets.add(Padding(
          padding: EdgeInsets.symmetric(vertical: 5.5),
          child:
              DisplayThreeSpots(items: ItemService.filteredItems.sublist(itemIndex, itemIndex + 3)),
        ));
        itemIndex += 3;
        threeSpots--;
        currentThreeSpots = 0;
        firstThreeSpots = false;
      } else if (itemIndex + 2 <= itemCount) {
        widgets.add(Padding(
            padding: EdgeInsets.symmetric(vertical: 5.5),
            child: DisplayTwoSpots(
                items: ItemService.filteredItems.sublist(itemIndex, itemIndex + 2))));
        itemIndex += 2;
        currentThreeSpots++;
      } else {
        widgets.add(Padding(
          padding: EdgeInsets.symmetric(vertical: 5.5),
          child:
              DisplayTwoSpots(items: ItemService.filteredItems.sublist(itemIndex, itemIndex + 1)),
        ));
        itemIndex++;
        currentThreeSpots++;
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Text(
                ItemService.selectedCategory != null
                    ? ItemService.selectedCategory![0].toUpperCase() +
                        ItemService.selectedCategory!.substring(1)
                    : "\"${ItemService.searchQuery}\"",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF000000),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator(color: Color(0xFF000000)))
                  : SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13),
                        child: Column(
                          children: _itemList,
                        ),
                      ),
                    ),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    ItemService.isLoading.removeListener(_initializeItems);
    ItemService.isFiltering.removeListener(_onFilteringChanged);
    super.dispose();
  }
}

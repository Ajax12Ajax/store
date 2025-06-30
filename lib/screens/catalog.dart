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
  static final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(true);
  static List<Widget> _itemList = [];

  @override
  void initState() {
    super.initState();
    ItemService.isFiltering.addListener(_onFilteringChanged);
  }

  static void changeContent(String? searchQuery, String? selectedCategory) {
    _isLoading.value = true;

    String currentRoute = '';
    MyAppState.navigatorKey.currentState?.popUntil((route) {
      currentRoute = route.settings.name ?? '';
      return true;
    });

    if (currentRoute != '/catalog') {
      MyAppState.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/',
        (Route<dynamic> route) => false,
      );
      MyAppState.navigatorKey.currentState?.pushNamed('/catalog');
    }

    if (!ItemService.isLoading.value) {
      _initializeItems(searchQuery, selectedCategory);
    } else {
      ItemService.isLoading.addListener(() {
        _initializeItems(searchQuery, selectedCategory);
        ItemService.isLoading.removeListener(() {
          _initializeItems(searchQuery, selectedCategory);
        });
      });
    }

    if (ItemService.selectedCategory != 'for_you' && ItemService.selectedCategory != null) {
      ItemService.trackCategoryView(ItemService.selectedCategory!);
    }
  }

  static void _initializeItems(String? searchQuery, String? selectedCategory) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!ItemService.isLoading.value) {
        if (searchQuery != null) {
          ItemService.getItemsBySearchQuery(searchQuery);
        } else if (selectedCategory == 'for_you') {
          ItemService.getRecommendedItems(false);
        } else if (selectedCategory != null) {
          ItemService.getItemsByCategory(selectedCategory);
        }
      }
    });
  }

  void _onFilteringChanged() {
    if (!ItemService.isFiltering.value && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _itemList = _buildItemList();
          _isLoading.value = false;
        });
      });
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
        widgets.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.5),
            child: DisplayThreeSpots(
              items: ItemService.filteredItems.sublist(itemIndex, itemIndex + 3),
            ),
          ),
        );
        itemIndex += 3;
        threeSpots--;
        currentThreeSpots = 0;
        firstThreeSpots = false;
      } else if (itemIndex + 2 <= itemCount) {
        widgets.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.5),
            child: DisplayTwoSpots(
              items: ItemService.filteredItems.sublist(itemIndex, itemIndex + 2),
            ),
          ),
        );
        itemIndex += 2;
        currentThreeSpots++;
      } else {
        widgets.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.5),
            child: DisplayTwoSpots(
              items: ItemService.filteredItems.sublist(itemIndex, itemIndex + 1),
            ),
          ),
        );
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
                  ? ItemService.selectedCategory == 'for_you'
                        ? "For You"
                        : ItemService.selectedCategory![0].toUpperCase() +
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
            child: SingleChildScrollView(
              child: ValueListenableBuilder<bool>(
                valueListenable: _isLoading,
                builder: (context, isLoading, child) {
                  return isLoading
                      ? Center(child: CircularProgressIndicator(color: Color(0xFF000000)))
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 13),
                          child: Column(children: _itemList),
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    ItemService.isFiltering.removeListener(_onFilteringChanged);
    super.dispose();
  }
}

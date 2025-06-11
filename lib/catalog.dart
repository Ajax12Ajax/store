import 'dart:math';
import 'package:flutter/material.dart';
import 'package:store/widgets/displayThreeSpots.dart';
import 'package:store/widgets/displayTwoSpots.dart';
import '../models/item.dart';
import '../services/item_service.dart';

class Catalog extends StatefulWidget {
  static GlobalKey<CatalogState> catalogKey = GlobalKey<CatalogState>();

  const Catalog({super.key});

  @override
  State<Catalog> createState() => CatalogState();
}

class CatalogState extends State<Catalog> {
  List<Item> _items = [];
  List<Item> _filteredItems = [];
  bool _isLoading = true;

  static String searchQuery = '';
  static String? selectedCategory;

  List<Widget> _itemList = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() => _isLoading = true);
    final items = await ItemService.loadItems();
    setState(() {
      _items = items;
      _filteredItems = items;
      _isLoading = false;
      filterItems(searchQuery, selectedCategory);
    });
  }

  void filterItems(String searchQuery, String? selectedCategory) {
    CatalogState.searchQuery = searchQuery;
    CatalogState.selectedCategory = selectedCategory;
    _filteredItems = ItemService.filterItems(_items, searchQuery, selectedCategory);
    _itemList = _buildItemList();
  }

  List<Widget> _buildItemList() {
    List<Widget> widgets = [];
    int itemIndex = 0;

    double threeSpots = 0;
    double currentThreeSpots = 0;
    bool firstThreeSpots = true;
    if (_filteredItems.length % 2 == 0 && _filteredItems.length >= 12) {
      threeSpots += (2 * (_filteredItems.length / 12 - (_filteredItems.length / 12) % 1));
    } else if (_filteredItems.length % 2 == 1) {
      threeSpots++;
      if (_filteredItems.length >= 19) {
        threeSpots += (2 * (_filteredItems.length / 19 - (_filteredItems.length / 12) % 1));
      }
    }
    double spacing = ((_filteredItems.length - (threeSpots * 3)) / 2) / (threeSpots + 1);
    spacing -= spacing % 1;

    while (itemIndex < _filteredItems.length) {
      if ((_filteredItems.length == 3 || itemIndex + 3 <= _filteredItems.length) &&
          threeSpots > 0 &&
          (Random().nextBool() || currentThreeSpots >= spacing + 1) &&
          (currentThreeSpots >= spacing || firstThreeSpots) &&
          _filteredItems[itemIndex].name.length < 20 &&
          _filteredItems[itemIndex + 1].name.length < 19 &&
          _filteredItems[itemIndex + 2].name.length < 19) {
        widgets.add(Padding(
          padding: EdgeInsets.symmetric(vertical: 5.5),
          child: DisplayThreeSpots(items: _filteredItems.sublist(itemIndex, itemIndex + 3)),
        ));
        itemIndex += 3;
        threeSpots--;
        currentThreeSpots = 0;
        firstThreeSpots = false;
      } else if (itemIndex + 2 <= _filteredItems.length) {
        widgets.add(Padding(
            padding: EdgeInsets.symmetric(vertical: 5.5),
            child: DisplayTwoSpots(items: _filteredItems.sublist(itemIndex, itemIndex + 2))));
        itemIndex += 2;
        currentThreeSpots++;
      } else {
        widgets.add(Padding(
          padding: EdgeInsets.symmetric(vertical: 5.5),
          child: DisplayTwoSpots(items: _filteredItems.sublist(itemIndex, itemIndex + 1)),
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
                selectedCategory != null
                    ? selectedCategory![0].toUpperCase() + selectedCategory!.substring(1)
                    : "\"$searchQuery\"",
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
}

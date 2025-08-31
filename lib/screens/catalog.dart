import 'dart:math';

import 'package:flutter/material.dart';
import 'package:store/main.dart';
import 'package:store/models/product.dart';

import '../services/products_service.dart';
import '../widgets/dual_panel.dart';
import '../widgets/triple_panel.dart';

class Catalog extends StatefulWidget {
  const Catalog({super.key});

  @override
  State<Catalog> createState() => CatalogState();
}

class CatalogState extends State<Catalog> {
  static late ProductService _productService;
  static String _label = '';
  static List<Product> _catalogProducts = [];

  void showCategoryProducts(int id) async {
    String currentRoute = '';
    MyAppState.navigatorKey.currentState?.popUntil((route) {
      currentRoute = route.settings.name ?? '';
      return true;
    });
    final label = ProductService.categories.firstWhere((category) => category.id == id).category;
    if (_label != label || currentRoute != '/catalog') {
      _label = label;
      _productService = ProductService();
      navigateToCatalog();
      _catalogProducts = await _productService.loadCategoryProducts(id);
    }
    ProductService.trackCategoryView(_label);
  }

  void showSearchQueryProducts(String query) async {
    _label = "\"$query\"";
    _productService = ProductService();
    navigateToCatalog();
    _catalogProducts = await _productService.loadSearchQueryProducts(query);
  }

  void showForYouProducts() async {
    _label = "For You";
    _productService = ProductService();
    navigateToCatalog();
    _catalogProducts = await _productService.loadRecommendationsProducts();
  }

  void navigateToCatalog() {
    MyAppState.navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/catalog',
      (route) => route.settings.name == '/',
    );
  }

  List<Widget> _buildProductList(List<Product> products) {
    List<Widget> widgets = [];
    int productIndex = 0;
    int productCount = products.length;

    double threeSpots = 0;
    double currentThreeSpots = 0;
    bool firstThreeSpots = true;
    if (productCount % 2 == 0 && productCount >= 12) {
      threeSpots += (2 * (productCount / 12 - (productCount / 12) % 1));
    } else if (productCount % 2 == 1) {
      threeSpots++;
      if (productCount >= 19) {
        threeSpots += (2 * (productCount / 19 - (productCount / 12) % 1));
      }
    }
    double spacing = ((productCount - (threeSpots * 3)) / 2) / (threeSpots + 1);
    spacing -= spacing % 1;

    while (productIndex < productCount) {
      if ((productCount == 3 || productIndex + 3 <= productCount) &&
          threeSpots > 0 &&
          (Random().nextBool() || currentThreeSpots >= spacing + 1) &&
          (currentThreeSpots >= spacing || firstThreeSpots) &&
          products[productIndex].name.length < 20 &&
          products[productIndex + 1].name.length < 19 &&
          products[productIndex + 2].name.length < 19) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.5),
            child: DisplayThreeSpots(products: products.sublist(productIndex, productIndex + 3)),
          ),
        );
        productIndex += 3;
        threeSpots--;
        currentThreeSpots = 0;
        firstThreeSpots = false;
      } else if (productIndex + 2 <= productCount) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.5),
            child: DisplayTwoSpots(products: products.sublist(productIndex, productIndex + 2)),
          ),
        );
        productIndex += 2;
        currentThreeSpots++;
      } else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.5),
            child: DisplayTwoSpots(products: products.sublist(productIndex, productIndex + 1)),
          ),
        );
        productIndex++;
        currentThreeSpots++;
      }
    }
    return widgets;
  }

  List<Widget> _productList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: ValueListenableBuilder<ConnectionState>(
        valueListenable: _productService.loadingState,
        builder: (context, loadingState, _) {
          if (loadingState == ConnectionState.done) {
            if (_productList.isEmpty) _productList = _buildProductList(_catalogProducts);
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
                      child: Column(children: _productList),
                    ),
                  ),
                ),
              ],
            );
          } else if (loadingState == ConnectionState.waiting) {
            _productList = [];
            return const Center(child: CircularProgressIndicator(color: Color(0xFF000000)));
          }
          _productList = [];
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

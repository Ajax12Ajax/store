import 'package:flutter/material.dart';
import 'package:store/services/products_service.dart';
import 'package:store/widgets/menu_button.dart';

import '../screens/catalog.dart';

class CategoriesMenu extends StatefulWidget {
  const CategoriesMenu({super.key});

  @override
  CategoriesMenuState createState() => CategoriesMenuState();
}

class CategoriesMenuState extends State<CategoriesMenu> with SingleTickerProviderStateMixin {
  late CatalogState catalogState = catalogState;

  static late AnimationController controller;
  late Animation<double> _distanceAnimation;

  void _animationController() {
    controller = AnimationController(duration: const Duration(milliseconds: 50), vsync: this);
    _distanceAnimation = Tween<double>(
      begin: -216,
      end: 0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    catalogState = CatalogState();
    _animationController();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: 0,
      bottom: 0,
      right: _distanceAnimation.value,
      width: 216,
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 350),
      child: Container(
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.only(right: 8, top: 8, bottom: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 19, horizontal: 17),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Categories",
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF000000),
                  height: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 22, bottom: 12),
                child: PreferredSize(
                  preferredSize: const Size.fromHeight(0.1),
                  child: Container(
                    color: const Color(0xFF939393),
                    height: 1,
                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MenuButton(
                      text: "For You",
                      size: 19,
                      weight: FontWeight.w500,
                      onPressed: () {
                        controller.reverse();
                        catalogState.showForYouProducts();
                      },
                    ),
                    ...ProductService.categories.map(
                      (category) => MenuButton(
                        text: category.category,
                        size: 18,
                        weight: FontWeight.w400,
                        onPressed: () {
                          controller.reverse();
                          catalogState.showCategoryProducts(category.id);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

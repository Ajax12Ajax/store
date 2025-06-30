import 'package:flutter/material.dart';
import 'package:store/layout/cart.dart';
import 'package:store/layout/categories_menu.dart';
import 'package:store/layout/favorites.dart';
import 'package:store/main.dart';
import 'package:store/screens/store_locations_map.dart';

import '../screens/catalog.dart';
import '../widgets/icon_button.dart';

class HeaderBar extends StatefulWidget implements PreferredSizeWidget {
  const HeaderBar({super.key});

  @override
  HeaderBarState createState() => HeaderBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class HeaderBarState extends State<HeaderBar> with SingleTickerProviderStateMixin {
  late AnimationController _searchBarController;
  late Animation<double> _widthAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<bool> _isVisibleAnimation;

  void _animationController() {
    _searchBarController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _colorAnimation =
        ColorTween(begin: const Color(0x00ffffff), end: const Color(0xFFD9D9D9)).animate(
      CurvedAnimation(
        parent: _searchBarController,
        curve: const Interval(0.0, 0.43, curve: Curves.ease),
      ),
    );
    _widthAnimation = Tween<double>(begin: 42, end: 280).animate(
      CurvedAnimation(
        parent: _searchBarController,
        curve: const Interval(0.43, 0.96, curve: Curves.ease),
      ),
    );
    _isVisibleAnimation = Tween<bool>(begin: false, end: true).animate(
      CurvedAnimation(
        parent: _searchBarController,
        curve: const Threshold(0.95),
      ),
    );
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _searchBarController,
        curve: const Interval(0.95, 1.0, curve: Curves.ease),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFFFFFFFF),
      surfaceTintColor: Colors.transparent,
      flexibleSpace: SafeArea(
        child: Stack(children: [
          Padding(
              padding: EdgeInsets.only(left: 13, right: 10),
              child: Row(
                children: [
                  Row(
                    children: [
                      CustomIconButton(
                        iconPath: 'assets/icons/account.svg',
                        iconWidth: 25,
                        iconHeight: 28,
                        maxWidth: 32,
                        maxHeight: 46,
                        onPressed: () {},
                      ),
                      CustomIconButton(
                        iconPath: 'assets/icons/map.svg',
                        iconWidth: 26,
                        iconHeight: 32,
                        maxWidth: 37,
                        maxHeight: 46,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => StoreLocationsMap()));
                        },
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTapDown: (_) {},
                            onTapUp: (_) {
                              setState(() {
                                CategoriesMenuState.controller.reverse();
                                if (MyAppState.navigatorKey.currentState?.canPop() ?? false) {
                                  MyAppState.navigatorKey.currentState
                                      ?.pushNamedAndRemoveUntil('/', (route) => false);
                                }
                              });
                            },
                            onTapCancel: () {},
                            child: Text(
                              "Store",
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF000000),
                              ),
                            ),
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _searchBarController,
                          builder: (context, child) {
                            return LayoutBuilder(builder: (context, constraints) {
                              _widthAnimation =
                                  Tween<double>(begin: 42, end: constraints.maxWidth).animate(
                                CurvedAnimation(
                                  parent: _searchBarController,
                                  curve: const Interval(0.5, 0.96, curve: Curves.ease),
                                ),
                              );
                              return Container(
                                width: _widthAnimation.value,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: _colorAnimation.value,
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (_isVisibleAnimation.value)
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 13),
                                          child: AnimatedOpacity(
                                            opacity: _opacityAnimation.value,
                                            duration: Duration(milliseconds: 150),
                                            curve: Curves.easeInOut,
                                            child: TextField(
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(
                                                fontFamily: 'Outfit',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF000000),
                                              ),
                                              cursorColor: const Color(0xFF000000),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'Search...',
                                                hintStyle: TextStyle(
                                                  fontFamily: 'Outfit',
                                                  color: Color(0xFF6B7280),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  height: 1.6,
                                                ),
                                              ),
                                              onSubmitted: (value) {
                                                CatalogState.changeContent(value, null);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    CustomIconButton(
                                        iconPath: _searchBarController.isCompleted
                                            ? 'assets/icons/close.svg'
                                            : 'assets/icons/search.svg',
                                        iconWidth: _searchBarController.isCompleted ? 22 : 26,
                                        iconHeight: _searchBarController.isCompleted ? 22 : 26,
                                        maxWidth: 42,
                                        maxHeight: 46,
                                        onPressed: () {
                                          setState(() {
                                            FavoritesState.controller.reverse();
                                            CartState.controller.reverse();
                                            CategoriesMenuState.controller.reverse();
                                          });
                                          if (_searchBarController.isCompleted) {
                                            _searchBarController.reverse();
                                          } else if (_searchBarController.isDismissed) {
                                            _searchBarController.forward();
                                          } else {
                                            _searchBarController.stop();
                                            _searchBarController.isAnimating
                                                ? _searchBarController.reverse()
                                                : _searchBarController.forward();
                                          }
                                        }),
                                  ],
                                ),
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  CustomIconButton(
                      iconPath: CategoriesMenuState.controller.isCompleted
                          ? 'assets/icons/close.svg'
                          : 'assets/icons/menu.svg',
                      iconWidth: CategoriesMenuState.controller.isCompleted ? 24 : 25,
                      iconHeight: CategoriesMenuState.controller.isCompleted ? 24 : 22,
                      maxWidth: 39,
                      maxHeight: 46,
                      onPressed: () {
                        CategoriesMenuState.controller.isCompleted
                            ? CategoriesMenuState.controller.reverse()
                            : CategoriesMenuState.controller.forward();
                        FavoritesState.controller.reverse();
                        CartState.controller.reverse();
                        _searchBarController.stop();
                        _searchBarController.reverse();
                        setState(() {});
                      })
                ],
              )),
          Visibility(
            visible: CartState.controller.isForwardOrCompleted ||
                FavoritesState.controller.isForwardOrCompleted,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  CartState.controller.reverse();
                  FavoritesState.controller.reverse();
                });
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
        ]),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.1),
        child: Container(
          color: const Color(0x4D000000),
          height: 1,
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }
}

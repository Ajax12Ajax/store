import 'package:flutter/material.dart';
import 'package:store/layout/cart.dart';
import 'package:store/layout/categories_menu.dart';
import 'package:store/layout/favorites.dart';
import 'package:store/widgets/icon_button.dart';

class FloatingActionButtons extends StatefulWidget {
  const FloatingActionButtons({super.key});

  @override
  FloatingActionButtonsState createState() => FloatingActionButtonsState();
}

class FloatingActionButtonsState extends State<FloatingActionButtons> {
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _addAnimationListeners();
  }

  void _addAnimationListeners() {
    for (var controller in [
      CartState.controller,
      FavoritesState.controller,
      CategoriesMenuState.controller
    ]) {
      controller.addStatusListener(_handleAnimationStatus);
    }
  }

  void _handleAnimationStatus(AnimationStatus status) {
    setState(() {
      if (status == AnimationStatus.forward || status == AnimationStatus.completed) {
        _visible = false;
      } else if (status == AnimationStatus.dismissed) {
        _visible = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 100),
      opacity: _visible ? 1.0 : 0.0,
      child: IgnorePointer(
        ignoring: !_visible,
        child: Container(
          width: 131,
          height: 58,
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(1000),
          ),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconButton(
                  iconPath: 'assets/icons/favourite.svg',
                  iconWidth: 34,
                  iconHeight: 30,
                  maxWidth: 58,
                  maxHeight: 58,
                  onPressed: () {
                    setState(() {
                      FavoritesState.controller.forward();
                      CartState.controller.reverse();
                      CategoriesMenuState.controller.reverse();
                    });
                  },
                ),
                CustomIconButton(
                  iconPath: 'assets/icons/cart.svg',
                  iconWidth: 32,
                  iconHeight: 37,
                  maxWidth: 57,
                  maxHeight: 58,
                  onPressed: () {
                    setState(() {
                      CartState.controller.forward();
                      FavoritesState.controller.reverse();
                      CategoriesMenuState.controller.reverse();
                    });
                  },
                ),
              ]),
        ),
      ),
    );
  }
}

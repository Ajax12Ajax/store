import 'package:flutter/material.dart';

import '../layout/cart.dart';
import '../layout/categories_menu.dart';
import '../layout/favorites.dart';

class ExitOverlay extends StatelessWidget {
  final bool visible;

  const ExitOverlay({super.key, required this.visible});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: GestureDetector(
        onTap: () {
          for (var controller in [
            CategoriesMenuState.controller,
            FavoritesState.controller,
            CartState.controller,
          ]) {
            controller.reverse();
          }
        },
        child: const SizedBox.expand(
          child: ColoredBox(color: Colors.transparent),
        ),
      ),
    );
  }
}

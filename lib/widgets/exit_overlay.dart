import 'package:flutter/material.dart';

import '../layout/cart.dart';
import '../layout/categories_menu.dart';
import '../layout/favorites.dart';

class ExitOverlay extends StatefulWidget {

  const ExitOverlay({super.key});

  @override
  State<ExitOverlay> createState() => ExitOverlayState();
}

class ExitOverlayState extends State<ExitOverlay> {
  static final ValueNotifier<bool> visible = ValueNotifier<bool>(false);

  static void handleAnimationStatus(AnimationStatus status) {
      if (status == AnimationStatus.forward || status == AnimationStatus.completed) {
        visible.value = true;
      } else if (status == AnimationStatus.dismissed) {
        visible.value = false;
      }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: visible,
      builder: (context, visible, _) {
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
      },
    );
  }
}

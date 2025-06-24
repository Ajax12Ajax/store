import 'package:flutter/material.dart';
import 'package:store/layout/cart.dart';
import 'package:store/layout/categories_menu.dart';
import 'package:store/layout/favorites.dart';
import 'package:store/layout/header_bar.dart';
import 'package:store/screens/catalog.dart';
import 'package:store/screens/home.dart';
import 'package:store/screens/product.dart';
import 'package:store/services/item_service.dart';
import 'package:store/widgets/floating_action_buttons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

/*
zrobić porządek
loading screem
zrobić for you
zrobic podobne pod produktami
zrobić mapy
 */

class MyAppState extends State<MyApp> {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  bool _visible = false;

  @override
  void initState() {
    super.initState();
    ItemService.loadItems();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CartState.controller.addStatusListener(_handleAnimationStatus);
      FavoritesState.controller.addStatusListener(_handleAnimationStatus);
      CategoriesMenuState.controller.addStatusListener(_handleAnimationStatus);
    });
  }

  void _handleAnimationStatus(AnimationStatus status) {
    setState(() {
      if (status == AnimationStatus.forward || status == AnimationStatus.completed) {
        _visible = true;
      } else if (status == AnimationStatus.dismissed) {
        _visible = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: HeaderBar(),
        floatingActionButton: FloatingActionButtons(),
        body: Stack(children: [
          MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            initialRoute: '/',
            routes: {
              '/': (context) => Home(),
              '/product': (context) {
                final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
                return Product(item: args['item']);
              },
              '/catalog': (context) => Catalog(),
            },
          ),
          Visibility(
            visible: _visible,
            child: GestureDetector(
              onTap: () {
                CategoriesMenuState.controller.reverse();
                FavoritesState.controller.reverse();
                CartState.controller.reverse();
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
          CategoriesMenu(),
          Cart(),
          Favorites(),
        ]),
      ),
    );
  }
}

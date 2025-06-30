import 'package:flutter/material.dart';
import 'package:store/layout/cart.dart';
import 'package:store/layout/categories_menu.dart';
import 'package:store/layout/favorites.dart';
import 'package:store/layout/header_bar.dart';
import 'package:store/screens/catalog.dart';
import 'package:store/screens/home.dart';
import 'package:store/screens/loading.dart';
import 'package:store/screens/product.dart';
import 'package:store/widgets/exit_overlay.dart';
import 'package:store/widgets/floating_action_buttons.dart';

void main() {
  runApp(const Loading());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addAnimationListeners();
    });
  }

  void _addAnimationListeners() {
    final controllers = [
      CartState.controller,
      FavoritesState.controller,
      CategoriesMenuState.controller,
    ];
    for (var controller in controllers) {
      controller.addStatusListener(_handleAnimationStatus);
    }
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
        body: Stack(
          children: [
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
            ExitOverlay(visible: _visible),
            CategoriesMenu(),
            Cart(),
            Favorites(),
          ],
        ),
      ),
    );
  }
}

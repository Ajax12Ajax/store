import 'package:flutter/material.dart';
import 'package:store/layout/cart.dart';
import 'package:store/layout/categories_menu.dart';
import 'package:store/layout/favorites.dart';
import 'package:store/layout/header_bar.dart';
import 'package:store/screens/catalog.dart';
import 'package:store/screens/home.dart';
import 'package:store/screens/loading.dart';
import 'package:store/screens/details.dart';
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
      controller.addStatusListener(ExitOverlayState.handleAnimationStatus);
    }
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
              navigatorObservers: [HomeState.routeObserver],
              initialRoute: '/',
              routes: {
                '/': (context) => Home(),
                '/product': (context) {
                  final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
                  return Details(product: args['product']);
                },
                '/catalog': (context) => Catalog(),
              },
            ),
            ExitOverlay(),
            CategoriesMenu(),
            Cart(),
            Favorites(),
          ],
        ),
      ),
    );
  }
}

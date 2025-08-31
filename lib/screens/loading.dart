import 'package:flutter/material.dart';
import 'package:store/main.dart';
import 'package:store/screens/home.dart';
import 'package:store/services/products_service.dart';
import 'package:store/widgets/loading_animation.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initializeApp();
  }

  Future<void> _initializeApp() async {
    await ProductService.loadCategories();
    await HomeState.loadHomePage();
    await Future.delayed(const Duration(milliseconds: 1500));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              HomeState.productService.loadingState.value == ConnectionState.done) {
            return const MyApp();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: const Color(0xFFFFFFFF),
              body: Center(child: LoadingAnimation()),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              backgroundColor: const Color(0xFFFFFFFF),
              body: Center(
                child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
              ),
            );
          }
          return Scaffold(
            backgroundColor: const Color(0xFFFFFFFF),
            body: Center(
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
            ),
          );
        },
      ),
    );
  }
}

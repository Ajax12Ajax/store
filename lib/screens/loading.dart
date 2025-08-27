import 'package:flutter/material.dart';
import 'package:store/main.dart';
import 'package:store/screens/home.dart';
import 'package:store/services/item_service.dart';
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
    await ItemService.loadCategories();
    await HomeState.loadHomeData();
    await Future.delayed(const Duration(milliseconds: 1500));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
          return const MyApp();
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:store/main.dart';
import 'package:store/services/item_service.dart';
import 'package:store/widgets/loading_animation.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  Future<void> _initializeApp() async {
    await ItemService.loadItems();
    await Future.delayed(Duration(milliseconds: 1500));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _initializeApp(),
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

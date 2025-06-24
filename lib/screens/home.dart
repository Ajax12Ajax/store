import 'dart:math';

import 'package:flutter/material.dart';
import 'package:store/widgets/panel_pair_item.dart';
import 'package:store/widgets/panel_trio_item.dart';

import '../../services/item_service.dart';
import '../widgets/text_button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  int _firstItems = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (!ItemService.isLoading.value) {
      _onLoadingChanged();
    } else {
      ItemService.isLoading.addListener(_onLoadingChanged);
    }
  }

  Future<void> _onLoadingChanged() async {
    if (!ItemService.isLoading.value) {
      setState(() {
        _isLoading = true;
        while (ItemService.items[_firstItems].name.length >= 20 ||
            ItemService.items[_firstItems + 1].name.length >= 19 ||
            ItemService.items[_firstItems + 2].name.length >= 19) {
          _firstItems = Random().nextInt((ItemService.items.length - 3).clamp(0, 16));
        }
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 13),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "For You",
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF000000),
                            ),
                          ),
                          CustomTextButton(
                            text: "See All",
                            size: 14,
                            weight: FontWeight.w400,
                            fontColor: const Color(0xFF6B7280),
                            maxWidth: 43,
                            maxHeight: 16,
                            onPressed: () {
                              // Handle back button press
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14),
                    _isLoading
                        ? Center(child: CircularProgressIndicator(color: Color(0xFF000000)))
                        : DisplayThreeSpots(
                            items: ItemService.items.sublist(_firstItems, _firstItems + 3)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: LayoutBuilder(builder: (context, constraints) {
                  return AspectRatio(
                    aspectRatio: 1.79 / 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1D1D1),
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment(0.1, -1),
                          end: Alignment(0.9, 1.3),
                          stops: [0.1, 0.5, 0.9],
                          colors: [
                            const Color(0xCC232323),
                            const Color(0xFFD1D1D1),
                            const Color(0xCC232323),
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 42, right: 30),
                            alignment: Alignment.topRight,
                            child: Image(
                              image: AssetImage("assets/images/kosz.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 16, top: 15),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Summer Sale",
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFFFFFFFF),
                                        height: 1,
                                      )),
                                  SizedBox(height: 12),
                                  Text("Up to 50% off",
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFFFFFFFF),
                                        height: 1,
                                      )),
                                ]),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            padding: EdgeInsets.only(bottom: 18, right: 28),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF000000),
                                backgroundColor: const Color(0xFFFFFFFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {},
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text('More Info',
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF000000),
                                      height: 1,
                                    )),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 13),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "New Arrivals",
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF000000),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: ItemService.isLoading,
                      builder: (context, isLoading, child) {
                        return isLoading
                            ? Center(child: CircularProgressIndicator(color: Color(0xFF000000)))
                            : Column(children: [
                                SizedBox(height: 14),
                                DisplayTwoSpots(items: ItemService.items.sublist(0, 2)),
                                SizedBox(height: 11),
                                DisplayTwoSpots(items: ItemService.items.sublist(2, 4)),
                                SizedBox(height: 11),
                                DisplayThreeSpots(items: ItemService.items.sublist(15, 18)),
                                SizedBox(height: 11),
                                DisplayTwoSpots(items: ItemService.items.sublist(7, 9)),
                              ]);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    ItemService.isLoading.removeListener(_onLoadingChanged);
    super.dispose();
  }
}

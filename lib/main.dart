import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store/widget/cartElement.dart';
import 'package:store/widget/displayThreeSpots.dart';
import 'package:store/widget/displayTwoSpots.dart';
import 'widget/customIconButton.dart';
import 'widget/customTextButton.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<bool> _isVisibleAnimation;

  bool _isMenuOpen = false;
  bool _isCartOpen = false;

  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _colorAnimation =
        ColorTween(begin: const Color(0x00ffffff), end: const Color(0xFFD9D9D9))
            .animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.43, curve: Curves.ease),
      ),
    );
    _widthAnimation = Tween<double>(begin: 42, end: 280).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.43, 0.96, curve: Curves.ease),
      ),
    );
    _isVisibleAnimation = Tween<bool>(begin: false, end: true).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Threshold(0.95),
      ),
    );
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.95, 1.0, curve: Curves.ease),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else if (_controller.status == AnimationStatus.dismissed) {
      _controller.forward();
    } else {
      _controller.stop();
      _controller.status == AnimationStatus.forward
          ? _controller.reverse()
          : _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFFFFFFF),
          flexibleSpace: SafeArea(
            child: Padding(
                padding: EdgeInsets.only(left: 13, right: 10),
                child: Row(
                  children: [
                    Row(
                      children: [
                        CustomIconButton(
                          iconPath: 'assets/icons/account.svg',
                          iconWidth: 25,
                          iconHeight: 28,
                          maxWidth: 32,
                          maxHeight: 46,
                          onPressed: () {
                            // Handle back button press
                          },
                        ),
                        CustomIconButton(
                          iconPath: 'assets/icons/map.svg',
                          iconWidth: 26,
                          iconHeight: 32,
                          maxWidth: 37,
                          maxHeight: 46,
                          onPressed: () {
                            // Handle back button press
                          },
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Store",
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF000000),
                              ),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return LayoutBuilder(
                                  builder: (context, constraints) {
                                _widthAnimation = Tween<double>(
                                        begin: 42, end: constraints.maxWidth)
                                    .animate(
                                  CurvedAnimation(
                                    parent: _controller,
                                    curve: const Interval(0.5, 0.96,
                                        curve: Curves.ease),
                                  ),
                                );
                                return Container(
                                  width: _widthAnimation.value,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: _colorAnimation.value,
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (_isVisibleAnimation.value)
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 13),
                                            child: AnimatedOpacity(
                                              opacity: _opacityAnimation.value,
                                              duration:
                                                  Duration(milliseconds: 150),
                                              curve: Curves.easeInOut,
                                              child: TextField(
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  fontFamily: 'Outfit',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF000000),
                                                ),
                                                cursorColor:
                                                    const Color(0xFF000000),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Search...',
                                                  hintStyle: TextStyle(
                                                    fontFamily: 'Outfit',
                                                    color: Color(0xFF6B7280),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.6,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      CustomIconButton(
                                        iconPath: 'assets/icons/search.svg',
                                        iconWidth: 26,
                                        iconHeight: 26,
                                        maxWidth: 42,
                                        maxHeight: 46,
                                        onPressed: () {
                                          setState(() {
                                            _isMenuOpen = false;
                                          });
                                          _toggleAnimation();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Builder(
                      builder: (context) => GestureDetector(
                        onTapDown: (_) {
                          setState(() {
                            _opacity = 0.5;
                          });
                        },
                        onTapUp: (_) {
                          setState(() {
                            _opacity = 1.0;
                            _isMenuOpen = !_isMenuOpen;
                            _isCartOpen = false;
                          });
                        },
                        onTapCancel: () {
                          setState(() {
                            _opacity = 1.0;
                          });
                        },
                        child: AnimatedOpacity(
                          opacity: _opacity,
                          duration: Duration(milliseconds: 150),
                          curve: Curves.easeInOut,
                          child: Container(
                            color: Colors.transparent,
                            width: 39,
                            height: 46,
                            child: Center(
                              child: SvgPicture.asset(
                                _isMenuOpen
                                    ? 'assets/icons/close.svg'
                                    : 'assets/icons/menu.svg',
                                width: _isMenuOpen ? 24 : 25,
                                height: _isMenuOpen ? 24 : 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.1),
            child: Container(
              color: const Color(0x4D000000),
              height: 1,
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            ),
          ),
        ),
        floatingActionButton: AnimatedOpacity(
          duration: const Duration(milliseconds: 100),
          opacity: _isMenuOpen || _isCartOpen ? 0.0 : 1.0,
          child: IgnorePointer(
            ignoring: _isMenuOpen,
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
                        // Handle back button press
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
                          _isCartOpen = true;
                          _isMenuOpen = false;
                        });
                        // Handle back button press
                      },
                    ),
                  ]),
            ),
          ),
        ),
        body: Stack(children: [
          SingleChildScrollView(
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
                        DisplayThreeSpots()
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
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
                        SizedBox(height: 14),
                        DisplayTwoSpots(),
                        SizedBox(height: 11),
                        DisplayTwoSpots(),
                        SizedBox(height: 11),
                        DisplayThreeSpots(),
                        SizedBox(height: 11),
                        DisplayTwoSpots(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: _isMenuOpen || _isCartOpen,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isMenuOpen = false;
                  _isCartOpen = false;
                });
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
          AnimatedPositioned(
            top: 0,
            bottom: 0,
            right: _isMenuOpen ? 0 : -216,
            width: 216,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 350),
            child: Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(right: 8, top: 8, bottom: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 19, horizontal: 17),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Categories",
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF000000),
                          height: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 22, bottom: 12),
                        child: PreferredSize(
                          preferredSize: const Size.fromHeight(0.1),
                          child: Container(
                            color: const Color(0xFF939393),
                            height: 1,
                            margin: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextButton(
                              text: "For You",
                              size: 19,
                              weight: FontWeight.w500,
                              fontColor: const Color(0xFF000000),
                              maxWidth: 65,
                              maxHeight: 39,
                              onPressed: () {
                                // Handle back button press
                              },
                            ),
                            CustomTextButton(
                              text: "Shoes",
                              size: 18,
                              weight: FontWeight.w400,
                              fontColor: const Color(0xFF000000),
                              maxWidth: 49,
                              maxHeight: 39,
                              onPressed: () {
                                // Handle back button press
                              },
                            ),
                            CustomTextButton(
                              text: "Pants",
                              size: 18,
                              weight: FontWeight.w400,
                              fontColor: const Color(0xFF000000),
                              maxWidth: 47,
                              maxHeight: 39,
                              onPressed: () {
                                // Handle back button press
                              },
                            ),
                            CustomTextButton(
                              text: "T-shirts",
                              size: 18,
                              weight: FontWeight.w400,
                              fontColor: const Color(0xFF000000),
                              maxWidth: 64,
                              maxHeight: 39,
                              onPressed: () {
                                // Handle back button press
                              },
                            ),
                            CustomTextButton(
                              text: "Sweatshirts",
                              size: 18,
                              weight: FontWeight.w400,
                              fontColor: const Color(0xFF000000),
                              maxWidth: 96,
                              maxHeight: 39,
                              onPressed: () {
                                // Handle back button press
                              },
                            ),
                            CustomTextButton(
                              text: "Hats",
                              size: 18,
                              weight: FontWeight.w400,
                              fontColor: const Color(0xFF000000),
                              maxWidth: 39,
                              maxHeight: 39,
                              onPressed: () {
                                // Handle back button press
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          AnimatedPositioned(
            bottom: _isCartOpen ? 0 : -329,
            left: 0,
            right: 0,
            height: 329,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 350),
            child: Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(right: 8, left: 8, bottom: 21),
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                  padding:
                      EdgeInsets.only(left: 16, top: 7, bottom: 15, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Cart",
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF000000),
                                      height: 1,
                                    ),
                                  ),
                                  Builder(
                                    builder: (context) => GestureDetector(
                                      onTapDown: (_) {
                                        setState(() {
                                          _opacity = 0.5;
                                        });
                                      },
                                      onTapUp: (_) {
                                        setState(() {
                                          _opacity = 1.0;
                                          setState(() {
                                            _isCartOpen = !_isCartOpen;
                                          });
                                        });
                                      },
                                      onTapCancel: () {
                                        setState(() {
                                          _opacity = 1.0;
                                        });
                                      },
                                      child: AnimatedOpacity(
                                        opacity: _opacity,
                                        duration: Duration(milliseconds: 150),
                                        curve: Curves.easeInOut,
                                        child: Container(
                                          color: Colors.transparent,
                                          width: 40,
                                          height: 46,
                                          child: Center(
                                            child: SvgPicture.asset(
                                              'assets/icons/close.svg',
                                              width: 24,
                                              height: 24,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                            Padding(
                              padding: EdgeInsets.only(bottom: 19),
                              child: PreferredSize(
                                preferredSize: const Size.fromHeight(0.1),
                                child: Container(
                                  color: const Color(0xFF939393),
                                  height: 1,
                                  margin: EdgeInsets.only(right: 150),
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                height: 169,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CartElement(
                                        image: "assets/images/wat.jpg",
                                        name: "Smart Watch",
                                        brand: "Watched",
                                        price: "\$399.99",
                                      ),
                                      SizedBox(height: 10),
                                      CartElement(
                                        image: "assets/images/snk.jpg",
                                        name: "Modern Sneakers 677GH",
                                        brand: "Nike",
                                        price: "\$699.99",
                                      ),
                                      SizedBox(height: 10),
                                      CartElement(
                                        image: "assets/images/snk.jpg",
                                        name: "Modern Sneakers ",
                                        brand: "Nike",
                                        price: "\$699.99",
                                      ),
                                      SizedBox(height: 10),
                                      CartElement(
                                        image: "assets/images/snk.jpg",
                                        name: "Modern Sneakers",
                                        brand: "Nike",
                                        price: "\$699.99",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Total: \$454.65",
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF000000),
                                height: 1,
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF000000),
                                backgroundColor: const Color(0xFFA6A6A6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                              ),
                              onPressed: () {},
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text('Checkout',
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF000000),
                                      height: 1,
                                    )),
                              ),
                            ),
                          ]),
                    ],
                  )),
            ),
          ),
        ]),
      ),
    );
  }
}

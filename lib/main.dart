import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

  double widthTest = 51;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _colorAnimation =
        ColorTween(begin: const Color(0x00ffffff), end: const Color(0xFFD9D9D9))
            .animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.ease),
      ),
    );
    _widthAnimation = Tween<double>(begin: 42, end: 280).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.ease),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    //widthTest = context.size?.width;
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
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        Flexible(
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
                                  return Container(
                                    width: _widthAnimation.value,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: _colorAnimation.value,
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (_controller.status ==
                                            AnimationStatus.completed)
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 16),
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Search...',
                                                  hintStyle: TextStyle(
                                                    fontFamily: 'Outfit',
                                                    color: Color(0xFF6B7280),
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
                                            _toggleAnimation();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        CustomIconButton(
                          iconPath: 'assets/icons/menu.svg',
                          iconWidth: 25,
                          iconHeight: 22,
                          maxWidth: 39,
                          maxHeight: 46,
                          onPressed: () {
                            // Handle back button press
                          },
                        ),
                      ],
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
        floatingActionButton: Container(
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
                    // Handle back button press
                  },
                ),
              ]),
        ),
        body: Padding(
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
                    LayoutBuilder(builder: (context, constraints) {
                      return AspectRatio(
                          aspectRatio: 1.79 / 1,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 157,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF9FAFB),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(6),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image(
                                                image: AssetImage(
                                                    "assets/images/snk.jpg"),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                            Expanded(
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Modern Sneakers",
                                                      style: TextStyle(
                                                        fontFamily: 'Outfit',
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: const Color(
                                                            0xFF000000),
                                                        height: 1,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Nike",
                                                      style: TextStyle(
                                                        fontFamily: 'Outfit',
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: const Color(
                                                            0xFF6B7280),
                                                        height: 1.2,
                                                      ),
                                                    ),
                                                  ]),
                                            ),
                                            Text(
                                              "\$129.99",
                                              style: TextStyle(
                                                fontFamily: 'Outfit',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF000000),
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 11),
                              Expanded(
                                flex: 199,
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF9FAFB),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(6),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image(
                                                    image: AssetImage(
                                                        "assets/images/wat.jpg"),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                SizedBox(width: 6),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 11),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Smart Watch W889 PRO",
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Outfit',
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: const Color(
                                                                      0xFF000000),
                                                                  height: 1.1,
                                                                ),
                                                              ),
                                                              Text(
                                                                "Watched",
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Outfit',
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: const Color(
                                                                      0xFF6B7280),
                                                                  height: 1.1,
                                                                ),
                                                              ),
                                                            ]),
                                                        Text(
                                                          "\$399.99",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Outfit',
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: const Color(
                                                                0xFF000000),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 11),
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF9FAFB),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(6),
                                            child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Image(
                                                      image: AssetImage(
                                                          "assets/images/wat.jpg"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  SizedBox(width: 6),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 11),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Smart Watch",
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Outfit',
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: const Color(
                                                                        0xFF000000),
                                                                    height: 1.3,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "Watched",
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Outfit',
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: const Color(
                                                                        0xFF6B7280),
                                                                    height: 1.1,
                                                                  ),
                                                                ),
                                                              ]),
                                                          Text(
                                                            "\$399.99",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Outfit',
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: const Color(
                                                                  0xFF000000),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ));
                    }),
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
            ],
          ),
        ),
      ),
    );
  }
}

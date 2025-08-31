import 'package:flutter/material.dart';
import 'package:store/models/product.dart';
import 'package:store/screens/catalog.dart';
import 'package:store/widgets/dual_panel.dart';
import 'package:store/widgets/triple_panel.dart';

import '../../services/products_service.dart';
import '../widgets/text_button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

bool firstBuild = true;

class HomeState extends State<Home> with RouteAware {
  static final ProductService productService = ProductService();
  late final CatalogState catalogState;

  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  static late List<Product> forYouProducts;
  static late List<Product> _newArrivalProducts;

  @override
  void initState() {
    super.initState();
    catalogState = CatalogState();
    ProductService.onRecommendationsUpdate = () async {
      if (!mounted) return;
      forYouProducts = await productService.loadRecommendationsPreviewProducts();
    };
  }

  static Future loadHomePage() async {
    forYouProducts = await productService.loadRecommendationsPreviewProducts();
    _newArrivalProducts = await productService.loadNewArrivalProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Column(
            children: [_buildForYouSection(), _buildOffersSection(), _buildNewArrivalsSection()],
          ),
        ),
      ),
    );
  }

  Widget _buildForYouSection() {
    return Padding(
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
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF000000),
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
                    catalogState.showForYouProducts();
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 14),
          ValueListenableBuilder<ConnectionState>(
            valueListenable: productService.loadingState,
            builder: (context, loadingState, _) {
              if (loadingState == ConnectionState.done && forYouProducts.isNotEmpty) {
                return DisplayThreeSpots(products: forYouProducts);
              } else if (loadingState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF000000)));
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Color(0xFF000000)),
                    SizedBox(height: 16),
                    Text(
                      'Failed to load products',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOffersSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AspectRatio(
            aspectRatio: 1.79 / 1,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFD1D1D1),
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment(0.1, -1),
                  end: Alignment(0.9, 1.3),
                  stops: [0.1, 0.5, 0.9],
                  colors: [Color(0xCC232323), Color(0xFFD1D1D1), Color(0xCC232323)],
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 42, right: 30),
                    alignment: Alignment.topRight,
                    child: Image(image: AssetImage("assets/images/bag.png"), fit: BoxFit.cover),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 16, top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Summer Sale",
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFFFFFFF),
                            height: 1,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Up to 50% off",
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFFFFFFF),
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.only(bottom: 18, right: 28),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF000000),
                        backgroundColor: const Color(0xFFFFFFFF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'More Info',
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF000000),
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewArrivalsSection() {
    return Padding(
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
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(height: 14),
              DisplayTwoSpots(products: _newArrivalProducts.sublist(0, 2)),
              SizedBox(height: 11),
              DisplayTwoSpots(products: _newArrivalProducts.sublist(2, 4)),
              SizedBox(height: 11),
              DisplayThreeSpots(products: _newArrivalProducts.sublist(4, 7)),
              SizedBox(height: 11),
              DisplayTwoSpots(products: _newArrivalProducts.sublist(7, 9)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    ProductService.updateRecommendationsNow();
  }

  @override
  void didPush() {
    ProductService.updateRecommendationsNow();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}

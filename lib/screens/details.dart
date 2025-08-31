import 'package:flutter/material.dart';
import 'package:store/layout/cart.dart';
import 'package:store/services/products_service.dart';
import 'package:store/widgets/icon_button.dart';
import 'package:store/widgets/dual_panel.dart';
import 'package:store/widgets/product_image.dart';

import '../models/product.dart';

class Details extends StatefulWidget {
  final Product product;

  const Details({super.key, required this.product});

  @override
  State<Details> createState() => DetailsState();
}

class DetailsState extends State<Details> {
  late final ProductService productService;
  List<Product> _similarProducts = [];

  @override
  void initState() {
    super.initState();
    productService = ProductService();
    loadSimilarProducts();
    ProductService.trackProductClick(widget.product);
  }

  static void showProduct(BuildContext context, Product product) {
    Navigator.pushNamed(context, '/product', arguments: {'product': product});
  }

  Future<void> loadSimilarProducts() async {
    _similarProducts = await productService.loadSimilarProducts(widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          widget.product.name,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF000000),
                            height: 1,
                          ),
                        ),
                        SizedBox(height: 11),
                        Text(
                          widget.product.brand,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF6B7280),
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomIconButton(
                          iconPath: 'assets/icons/close.svg',
                          iconWidth: 24,
                          iconHeight: 24,
                          maxWidth: 36,
                          maxHeight: 59,
                          onPressed: () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 145 / 134,
                    child: ProductImage(widget.product.id, null, null, BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 3.5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: 0 == index ? const Color(0x61000000) : const Color(0x30000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return AspectRatio(
                        aspectRatio: 369 / 71,
                        child: Container(
                          height: 71,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xFFF0EFEF),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "\$${widget.product.price.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF000000),
                                    height: 1,
                                  ),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF000000),
                                    backgroundColor: const Color(0xFFB5B5B5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    CartState.addProduct(widget.product);
                                    ProductService.trackProductClick(widget.product);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
                                    child: Text(
                                      'Add to cart',
                                      style: const TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF000000),
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return AspectRatio(
                        aspectRatio: 369 / 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0EFEF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Center(
                                      child: Text(
                                        "Size: 43",
                                        style: const TextStyle(
                                          fontFamily: 'Outfit',
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF000000),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0EFEF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Center(
                                      child: Text(
                                        "Color: ${widget.product.color}",
                                        style: const TextStyle(
                                          fontFamily: 'Outfit',
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF000000),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    width: double.infinity,
                    child: Text(
                      "Category: ${widget.product.category}\n"
                      "Material: ${widget.product.materials}\n"
                      "Fit: ${widget.product.fit}\n"
                      "Width : ${widget.product.dimensions.width} cm\n"
                      "Height: ${widget.product.dimensions.height} cm\n"
                      "Length: ${widget.product.dimensions.length} cm\n"
                      "ID: ${widget.product.id}",
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF000000),
                        height: 1.27,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Similar",
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF000000),
                              height: 1.27,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        ValueListenableBuilder<ConnectionState>(
                          valueListenable: productService.loadingState,
                          builder: (context, loadingState, _) {
                            if (loadingState == ConnectionState.done && _similarProducts.isNotEmpty) {
                              return DisplayTwoSpots(products: _similarProducts);
                            } else if (loadingState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(color: Color(0xFF000000)),
                              );
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
                  ),
                  SizedBox(height: 25),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

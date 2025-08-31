import 'package:flutter/material.dart';
import 'package:store/models/list_product.dart';

import '../models/product.dart';
import '../widgets/icon_button.dart';
import '../widgets/list_element.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  CartState createState() => CartState();
}

class CartState extends State<Cart> with SingleTickerProviderStateMixin {
  static final ValueNotifier<List<ListProduct>> products = ValueNotifier<List<ListProduct>>([]);

  static void addProduct(Product product) {
    ListProduct listProduct = ListProduct(product: product, quantity: 1);
    if (products.value.any((element) => element.product.id == product.id)) {
      final existingProduct = products.value.firstWhere((element) => element.product.id == product.id);
      existingProduct.quantity++;
    } else {
      products.value = List.from(products.value)..add(listProduct);
    }
  }

  double _calculateTotalPrice() =>
      products.value.fold(0, (total, product) => total + product.product.price * product.quantity);

  static late AnimationController controller;
  late Animation<double> _heightAnimation;

  void _animationController() {
    controller = AnimationController(duration: const Duration(milliseconds: 50), vsync: this);
    _heightAnimation = Tween<double>(
      begin: -329,
      end: 0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      bottom: _heightAnimation.value,
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
          padding: const EdgeInsets.only(left: 16, top: 7, bottom: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Cart",
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF000000),
                          height: 1,
                        ),
                      ),
                      CustomIconButton(
                        iconPath: 'assets/icons/close.svg',
                        iconWidth: 24,
                        iconHeight: 24,
                        maxWidth: 40,
                        maxHeight: 46,
                        onPressed: () {
                          controller.reverse();
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 19),
                    child: PreferredSize(
                      preferredSize: const Size.fromHeight(0.1),
                      child: Container(
                        color: const Color(0xFF939393),
                        height: 1,
                        margin: const EdgeInsets.only(right: 150),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 169,
                      child: ValueListenableBuilder<List<ListProduct>>(
                        valueListenable: products,
                        builder: (context, product, child) {
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ...products.value.map(
                                  (product) => Column(
                                    children: [
                                      ListElement(listProduct: product),
                                      if (product != products.value.last) SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ValueListenableBuilder<List<ListProduct>>(
                    valueListenable: products,
                    builder: (context, product, child) {
                      return Text(
                        "Total: \$${_calculateTotalPrice().toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF000000),
                          height: 1,
                        ),
                      );
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF000000),
                      backgroundColor: const Color(0xFFA6A6A6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                    ),
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Checkout',
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF000000),
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

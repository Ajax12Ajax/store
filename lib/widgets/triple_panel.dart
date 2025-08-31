import 'package:flutter/material.dart';
import 'package:store/screens/details.dart';
import 'package:store/widgets/product_image.dart';

import '../models/product.dart';

class DisplayThreeSpots extends StatelessWidget {
  final List<Product> products;

  const DisplayThreeSpots({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AspectRatio(
          aspectRatio: 1.79 / 1,
          child: Row(
            children: [
              _buildLeftPanel(context, products[0]),
              SizedBox(width: 11),
              Expanded(
                flex: 199,
                child: Column(
                  children: [
                    _buildRightPanel(context, products[1]),
                    SizedBox(height: 11),
                    _buildRightPanel(context, products[2]),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLeftPanel(BuildContext context, Product product) {
    return Expanded(
      flex: 157,
      child: GestureDetector(
        onTap: () {
          DetailsState.showProduct(context, product);
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 145 / 134,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ProductImage(product.id, 145, 134, BoxFit.cover),
                  ),
                ),
                SizedBox(height: 6),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF000000),
                          height: 1,
                        ),
                      ),
                      Text(
                        product.brand,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF6B7280),
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "\$${product.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRightPanel(BuildContext context, Product product) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          DetailsState.showProduct(context, product);
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 81 / 85,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ProductImage(product.id, 81, 85, BoxFit.cover),
                  ),
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF000000),
                                height: 1.1,
                              ),
                            ),
                            Text(
                              product.brand,
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF6B7280),
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "\$${product.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

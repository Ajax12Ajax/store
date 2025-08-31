import 'package:flutter/material.dart';
import 'package:store/screens/details.dart';
import 'package:store/widgets/product_image.dart';

import '../models/product.dart';

class DisplayTwoSpots extends StatelessWidget {
  final List<Product> products;

  const DisplayTwoSpots({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AspectRatio(
          aspectRatio: 1.79 / 1,
          child: Row(
            children: [
              Expanded(flex: 1, child: _buildPanel(context, products[0])),
              SizedBox(width: 11),
              Expanded(
                flex: 1,
                child: products.length >= 2 ? _buildPanel(context, products[1]) : Container(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPanel(BuildContext context, Product product) {
    return GestureDetector(
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
                aspectRatio: 83 / 67,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ProductImage(product.id, null, null, BoxFit.fitWidth),
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
                        height: 1.2,
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
    );
  }
}

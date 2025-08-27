import 'package:flutter/material.dart';
import 'package:store/screens/product.dart';
import 'package:store/widgets/product_image.dart';

import '../models/item.dart';

class DisplayThreeSpots extends StatelessWidget {
  final List<Item> items;

  const DisplayThreeSpots({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AspectRatio(
          aspectRatio: 1.79 / 1,
          child: Row(
            children: [
              _buildRightPanel(context, items[0]),
              SizedBox(width: 11),
              Expanded(
                flex: 199,
                child: Column(
                  children: [
                    _buildLeftPanel(context, items[1]),
                    SizedBox(height: 11),
                    _buildLeftPanel(context, items[2]),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRightPanel(BuildContext context, Item item) {
    return Expanded(
      flex: 157,
      child: GestureDetector(
        onTap: () {
          ProductState.showProduct(context, item);
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
                    child: ProductImage(item.id, 134, 145, BoxFit.cover),
                  ),
                ),
                SizedBox(height: 6),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF000000),
                          height: 1,
                        ),
                      ),
                      Text(
                        item.brand,
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
                  "\$${item.price.toStringAsFixed(2)}",
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

  Widget _buildLeftPanel(BuildContext context, Item item) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          ProductState.showProduct(context, item);
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ProductImage(item.id, null, null, BoxFit.cover),
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
                              item.name,
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF000000),
                                height: 1.1,
                              ),
                            ),
                            Text(
                              item.brand,
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
                          "\$${item.price.toStringAsFixed(2)}",
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

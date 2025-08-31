import 'package:flutter/material.dart';
import 'package:store/layout/cart.dart';
import 'package:store/models/list_product.dart';
import 'package:store/widgets/icon_button.dart';
import 'package:store/widgets/product_image.dart';

class ListElement extends StatefulWidget {
  final ListProduct listProduct;

  const ListElement({super.key, required this.listProduct});

  @override
  ListElementState createState() => ListElementState();
}

class ListElementState extends State<ListElement> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 56,
                height: 56,
                child: ProductImage(widget.listProduct.product.id, 56, 56, BoxFit.cover),
              ),
            ),
            SizedBox(width: 9),
            Container(
              height: 53,
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.listProduct.product.name,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF000000),
                          height: 1,
                        ),
                      ),
                      Text(
                        widget.listProduct.product.brand,
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
                    '\$${widget.listProduct.product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF000000),
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 63,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1000),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomIconButton(
                      iconPath: 'assets/icons/remove.svg',
                      iconWidth: 11.67,
                      iconHeight: 1.67,
                      maxWidth: 20,
                      maxHeight: 20,
                      onPressed: () {
                        setState(() {
                          if (widget.listProduct.quantity > 1) {
                            widget.listProduct.quantity--;
                            CartState.products.value = List.from(CartState.products.value);
                          }
                        });
                      },
                    ),
                    Text(
                      widget.listProduct.quantity.toString(),
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF000000),
                        height: 1,
                      ),
                    ),
                    CustomIconButton(
                      iconPath: 'assets/icons/add.svg',
                      iconWidth: 11.67,
                      iconHeight: 11.67,
                      maxWidth: 20,
                      maxHeight: 20,
                      onPressed: () {
                        setState(() {
                          if (widget.listProduct.quantity < 99) {
                            widget.listProduct.quantity++;
                            CartState.products.value = List.from(CartState.products.value);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 13),
            CustomIconButton(
              iconPath: 'assets/icons/delete.svg',
              iconWidth: 16,
              iconHeight: 18,
              maxWidth: 24,
              maxHeight: 38,
              onPressed: () {
                CartState.products.value = List.from(CartState.products.value)
                  ..remove(widget.listProduct);
              },
            ),
          ],
        ),
      ],
    );
  }
}

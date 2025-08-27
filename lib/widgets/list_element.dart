import 'package:flutter/material.dart';
import 'package:store/layout/cart.dart';
import 'package:store/models/list_item.dart';
import 'package:store/widgets/icon_button.dart';

class ListElement extends StatefulWidget {
  final ListItem listItem;

  const ListElement({super.key, required this.listItem});

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
            Center(child: Icon(Icons.broken_image, size: 50)),
            /*
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image(
                image: AssetImage(widget.listItem.item.image),
                fit: BoxFit.cover,
                height: 56,
                width: 56,
              ),
            ),
             */
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
                        widget.listItem.item.name,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF000000),
                          height: 1,
                        ),
                      ),
                      Text(
                        widget.listItem.item.brand,
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
                    '\$${widget.listItem.item.price.toStringAsFixed(2)}',
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
                          if (widget.listItem.quantity > 1) {
                            widget.listItem.quantity--;
                            CartState.items.value = List.from(CartState.items.value);
                          }
                        });
                      },
                    ),
                    Text(
                      widget.listItem.quantity.toString(),
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
                          widget.listItem.quantity++;
                          CartState.items.value = List.from(CartState.items.value);
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
                CartState.items.value = List.from(CartState.items.value)..remove(widget.listItem);
              },
            ),
          ],
        ),
      ],
    );
  }
}

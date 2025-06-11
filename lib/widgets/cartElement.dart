import 'package:flutter/material.dart';
import 'package:store/widgets/customIconButton.dart';

class CartElement extends StatefulWidget {
  final String image;
  final String name;
  final String brand;
  final String price;

  const CartElement(
      {super.key,
      required this.image,
      required this.name,
      required this.brand,
      required this.price});

  @override
  CartElementState createState() => CartElementState();
}

class CartElementState extends State<CartElement> {
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
                  child: Image(
                    image: AssetImage(widget.image),
                    fit: BoxFit.cover,
                    height: 56,
                    width: 56,
                  ),
                ),
                SizedBox(width: 9),
                Container(
                  height: 53,
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF000000),
                                height: 1,
                              ),
                            ),
                            Text(
                              widget.brand,
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF6B7280),
                                height: 1.1,
                              ),
                            ),
                          ]),
                      Text(
                        widget.price,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF000000),
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
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
                  padding: EdgeInsets.symmetric(horizontal: 1),
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
                          setState(() {});
                          // Handle back button press
                        },
                      ),
                      Text('2',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF000000),
                            height: 1,
                          )), //stawski to gej
                      CustomIconButton(
                        iconPath: 'assets/icons/add.svg',
                        iconWidth: 11.67,
                        iconHeight: 11.67,
                        maxWidth: 20,
                        maxHeight: 20,
                        onPressed: () {
                          setState(() {});
                          // Handle back button press
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
                  setState(() {});
                  // Handle back button press
                },
              ),
            ],
          )
        ]);
  }
}

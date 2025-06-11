import 'package:flutter/material.dart';

import '../models/item.dart';

class DisplayThreeSpots extends StatefulWidget {
  final List<Item> items;

  const DisplayThreeSpots({super.key, required this.items});

  @override
  DisplayThreeSpotsState createState() => DisplayThreeSpotsState();
}

class DisplayThreeSpotsState extends State<DisplayThreeSpots> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return AspectRatio(
          aspectRatio: 1.79 / 1,
          child: Row(
            children: [
              Expanded(
                flex: 157,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/product', arguments: {'item': widget.items[0]});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AspectRatio(
                              aspectRatio: 145 / 134,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image(
                                  image: AssetImage(widget.items[0].image),
                                  fit: BoxFit.cover,
                                  height: 134,
                                  width: 145,
                                ),
                              ),
                            ),
                            SizedBox(height: 6),
                            Expanded(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.items[0].name,
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF000000),
                                        height: 1,
                                      ),
                                    ),
                                    Text(
                                      widget.items[0].brand,
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF6B7280),
                                        height: 1.1,
                                      ),
                                    ),
                                  ]),
                            ),
                            Text(
                              "\$${widget.items[0].price}9",
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
                        onTap: () {
                          Navigator.pushNamed(context, '/product', arguments: {'item': widget.items[1]});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image(
                                    image: AssetImage(widget.items[1].image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 11),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.items[1].name,
                                                style: TextStyle(
                                                  fontFamily: 'Outfit',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0xFF000000),
                                                  height: 1.1,
                                                ),
                                              ),
                                              Text(
                                                widget.items[1].brand,
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
                                          "\$${widget.items[1].price}",
                                          style: TextStyle(
                                            fontFamily: 'Outfit',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF000000),
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
                        onTap: () {
                          Navigator.pushNamed(context, '/product', arguments: {'item': widget.items[2]});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image(
                                      image:
                                          AssetImage(widget.items[2].image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 11),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.items[2].name,
                                                  style: TextStyle(
                                                    fontFamily: 'Outfit',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(0xFF000000),
                                                    height: 1.1,
                                                  ),
                                                ),
                                                Text(
                                                  widget.items[2].brand,
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
                                            "\$${widget.items[2].price}",
                                            style: TextStyle(
                                              fontFamily: 'Outfit',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF000000),
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
    });
  }
}

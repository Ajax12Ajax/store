import 'package:flutter/material.dart';
import 'package:store/layout/cart.dart';
import 'package:store/models/item.dart';
import 'package:store/services/item_service.dart';
import 'package:store/widgets/icon_button.dart';
import 'package:store/widgets/panel_pair_item.dart';

class Product extends StatefulWidget {
  final Item? item;

  const Product({super.key, this.item});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  @override
  void initState() {
    super.initState();
    ItemService.trackItemClick(widget.item!);
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
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(widget.item!.name,
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF000000),
                                height: 1,
                              )),
                          SizedBox(height: 11),
                          Text(widget.item!.brand,
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF6B7280),
                                height: 1,
                              )),
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
                            SizedBox(height: 15)
                          ]),
                    ],
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 145 / 134,
                    child: Image(
                      image: AssetImage(widget.item!.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(
                          5,
                          (index) => Container(
                                width: 8,
                                height: 8,
                                margin: EdgeInsets.symmetric(horizontal: 3.5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: 0 == index
                                      ? const Color(0x61000000)
                                      : const Color(0x30000000),
                                ),
                              )),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  LayoutBuilder(builder: (context, constraints) {
                    return AspectRatio(
                      aspectRatio: 369 / 71,
                      child: Container(
                        height: 71,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFFF0EFEF),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("\$${widget.item?.price.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF000000),
                                    height: 1,
                                  )),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF000000),
                                  backgroundColor: const Color(0xFFB5B5B5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  CartState.addItem(widget.item!);
                                  ItemService.trackItemClick(widget.item!);
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 6),
                                  child: Text('Add to cart',
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF000000),
                                        height: 1,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 10),
                  LayoutBuilder(builder: (context, constraints) {
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
                                    padding: EdgeInsets.all(6),
                                    child: Center(
                                      child: Text(
                                        "Size: 43",
                                        style: TextStyle(
                                          fontFamily: 'Outfit',
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF000000),
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
                                    padding: EdgeInsets.all(6),
                                    child: Center(
                                      child: Text(
                                        "Color: ${widget.item!.color}",
                                        style: TextStyle(
                                          fontFamily: 'Outfit',
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF000000),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ));
                  }),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    width: double.infinity,
                    child: Text(
                      "Category: ${widget.item!.category}\n"
                      "Material: ${widget.item!.materials}\n"
                      "Fit: ${widget.item!.fit}\n"
                      "Width : ${widget.item!.dimensions.width} cm\n"
                      "Height: ${widget.item!.dimensions.height} cm\n"
                      "Length: ${widget.item!.dimensions.length} cm\n"
                      "ID: ${widget.item!.id}",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF000000),
                        height: 1.27,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              "Similar",
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF000000),
                                height: 1.27,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          ValueListenableBuilder<bool>(
                            valueListenable: ItemService.isLoading,
                            builder: (context, isLoading, child) {
                              return isLoading
                                  ? Center(child: CircularProgressIndicator(color: Color(0xFF000000)))
                                  : DisplayTwoSpots(items: ItemService.getSimilarItems(widget.item!));
                            },
                          ),
                        ],
                      )),
                  SizedBox(height: 25),
                ],
              )
            ],
          ),
        )));
  }
}

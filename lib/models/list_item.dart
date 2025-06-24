import 'package:store/models/item.dart';

class ListItem {
  final Item item;
  int quantity;

  ListItem({
    required this.item,
    this.quantity = 1,
  });
}
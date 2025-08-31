import 'package:store/models/product.dart';

class ListProduct {
  final Product product;
  int quantity;

  ListProduct({required this.product, this.quantity = 1});
}

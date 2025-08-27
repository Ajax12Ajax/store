import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:store/services/constants.dart';

class ProductImage extends StatelessWidget {
  const ProductImage(this.productId, this.height, this.width, this.fit, {super.key});

  final int productId;
  final double? height;
  final double? width;
  final BoxFit fit;

  Future<Uint8List?> getImageBytes() async {
    try {
      Response response = await get(
        Uri.parse('${Constants.BASE_URL}/product/$productId/image'),
        headers: {
          'Cache-Control': 'no-cache, no-store, must-revalidate, private, max-age=0',
          'Pragma': 'no-cache',
        },
      );
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      return null;
    } catch (e) {
      print('Error fetching image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Icon(Icons.broken_image, size: 50));
    return FutureBuilder<Uint8List?>(
      future: getImageBytes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF000000)));
        }
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data != null) {
          return Image.memory(
            snapshot.data!,
            fit: fit,
            height: height,
            width: width,
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Icon(Icons.broken_image, size: 50));
            },
          );
        }
        return Center(child: Icon(Icons.broken_image, size: 50));
      },
    );
  }
}

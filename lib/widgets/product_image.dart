import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../services/images_service.dart';

class ProductImage extends StatefulWidget {
  const ProductImage(this.productId, this.width, this.height, this.fit, {super.key});

  final int productId;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  State<ProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  late final String _widgetId;

  @override
  void initState() {
    super.initState();
    _widgetId = '${widget.productId}_${widget.hashCode}_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Widget build(BuildContext context) {
    final cachedImage = ImageService().getCachedImage(widget.productId, _widgetId);
    if (cachedImage != null) {
      return Image.memory(
        cachedImage,
        fit: widget.fit,
        height: widget.height,
        width: widget.width,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.broken_image, size: 50));
        },
      );
    }
    return FutureBuilder<Uint8List?>(
      future: ImageService().loadImage(widget.productId, _widgetId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data != null) {
          return Image.memory(
            snapshot.data!,
            fit: widget.fit,
            height: widget.height,
            width: widget.width,
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Icon(Icons.broken_image, size: 50));
            },
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF000000)));
        }
        return Center(child: Icon(Icons.broken_image, size: 50));
      },
    );
  }

  @override
  void dispose() {
    ImageService().disposeWidget(widget.productId, _widgetId);
    super.dispose();
  }
}

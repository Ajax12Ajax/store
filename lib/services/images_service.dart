import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:store/services/constants.dart';

class ImageRequest {
  final int productId;
  final Completer<Uint8List?> completer;
  final DateTime requestTime;

  ImageRequest({required this.productId, required this.completer, required this.requestTime});
}

class CachedImage {
  final Uint8List? imageData;
  final Set<String> activeWidgets;
  final DateTime cacheTime;

  CachedImage({required this.imageData, required this.activeWidgets, required this.cacheTime});
}

class ImageService extends ChangeNotifier {
  static final Queue<ImageRequest> _imageQueue = Queue<ImageRequest>();
  static final Map<int, CachedImage> _imageCache = {};
  static const int _maxConcurrentDownloads = 1;
  static int _activeDownloads = 0;
  static bool _isProcessing = false;

  Future<Uint8List?> loadImage(int productId, String widgetId) async {
    if (_imageCache.containsKey(productId)) {
      _imageCache[productId]!.activeWidgets.add(widgetId);
      return _imageCache[productId]!.imageData;
    }
    for (var request in _imageQueue) {
      if (request.productId == productId) {
        final result = await request.completer.future;
        if (_imageCache.containsKey(productId)) {
          _imageCache[productId]!.activeWidgets.add(widgetId);
        }
        return result;
      }
    }
    final completer = Completer<Uint8List?>();
    final request = ImageRequest(
      productId: productId,
      completer: completer,
      requestTime: DateTime.now(),
    );
    _imageQueue.add(request);
    _processQueue();

    final result = await completer.future;
    if (_imageCache.containsKey(productId)) {
      _imageCache[productId]!.activeWidgets.add(widgetId);
    }
    return result;
  }

  void _processQueue() async {
    if (_isProcessing) return;
    _isProcessing = true;
    while (_imageQueue.isNotEmpty && _activeDownloads < _maxConcurrentDownloads) {
      final request = _imageQueue.removeFirst();
      _activeDownloads++;
      _downloadImage(request);
    }
    _isProcessing = false;
  }

  void _downloadImage(ImageRequest request) async {
    try {
      if (_imageCache.containsKey(request.productId)) {
        request.completer.complete(_imageCache[request.productId]!.imageData);
        _activeDownloads--;
        _processQueue();
        return;
      }

      final response = await http.get(
        Uri.parse('${Constants.BASE_URL}/product/${request.productId}/image'),
        headers: {
          'Cache-Control': 'no-cache, no-store, must-revalidate, private, max-age=0',
          'Pragma': 'no-cache',
        },
      );

      Uint8List? imageBytes;
      if (response.statusCode == 200) {
        imageBytes = response.bodyBytes;
      }

      _imageCache[request.productId] = CachedImage(
        imageData: imageBytes,
        activeWidgets: <String>{},
        cacheTime: DateTime.now(),
      );

      request.completer.complete(imageBytes);
    } catch (e) {
      print('Error fetching image for product ${request.productId}: $e');
      _imageCache[request.productId] = CachedImage(
        imageData: null,
        activeWidgets: <String>{},
        cacheTime: DateTime.now(),
      );
      request.completer.complete(null);
    } finally {
      _activeDownloads--;
      _processQueue();
    }
  }

  Uint8List? getCachedImage(int productId, String widgetId) {
    if (_imageCache.containsKey(productId)) _imageCache[productId]!.activeWidgets.add(widgetId);
    return _imageCache[productId]?.imageData;
  }

  void disposeWidget(int productId, String widgetId) {
    if (_imageCache.containsKey(productId)) {
      _imageCache[productId]!.activeWidgets.remove(widgetId);
      if (_imageCache[productId]!.activeWidgets.isEmpty) _imageCache.remove(productId);
    }
  }
}
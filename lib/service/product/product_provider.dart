import 'package:flutter/material.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/service/product/product_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProducts(
      int marketId, int categoryId, int standId, int page, int limit) async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await ProductService()
          .fetchProducts(marketId, categoryId, standId, page, limit);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}

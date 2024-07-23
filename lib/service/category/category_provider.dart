import 'package:flutter/material.dart';
import 'package:shopping_app/model/category.dart';
import 'package:shopping_app/service/category/category_service.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCategories(int marketId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await CategoryService().fetchCategories(marketId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}

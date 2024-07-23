import 'package:flutter/material.dart';
import 'package:shopping_app/model/stand.dart';
import 'package:shopping_app/service/stand/stand_service.dart';

class StandProvider with ChangeNotifier {
  List<Stand> _stands = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Stand> get stands => _stands;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchStands(int marketId, int categoryId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _stands = await StandService().fetchStands(marketId, categoryId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}

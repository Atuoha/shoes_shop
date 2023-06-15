import 'package:flutter/material.dart';

class CategoryData extends ChangeNotifier {
  String _currentCategory = '';

  void updateCategory(String category) {
    _currentCategory = category;
    notifyListeners();
    print('THE CURRENT CATEGORY: $_currentCategory');
  }

  get currentCategory => _currentCategory;
}

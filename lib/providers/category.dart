import 'package:flutter/foundation.dart';

class CategoryData extends ChangeNotifier {
  String _currentCategory = '';

  void updateCategory(String category) {
    _currentCategory = category;
    notifyListeners();
    if (kDebugMode) {
      print('THE CURRENT CATEGORY: $_currentCategory');
    }
  }

  get currentCategory => _currentCategory;
}

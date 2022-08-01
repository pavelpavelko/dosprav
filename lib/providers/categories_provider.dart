import 'package:flutter/material.dart';

import 'package:dosprav/models/category.dart';

class CategoriesProvider with ChangeNotifier {
  final List<Category> _items = [
    Category(
      id: UniqueKey().toString(),
      uid: "",
      name: "Study",
    ),
    Category(
      id: UniqueKey().toString(),
      uid: "",
      name: "Daily List",
    ),
    
  ];

  List<Category> get items {
    return [..._items];
  }

  void addCategoty(Category category){
    _items.add(category);
    notifyListeners();
  }

  void removeCategory(String id){
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Category getById(String id){
    return _items.firstWhere((element) => element.id == id);
  }
}

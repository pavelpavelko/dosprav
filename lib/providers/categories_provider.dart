import 'package:flutter/material.dart';

import 'package:dosprav/models/category.dart';

class CategoriesProvider with ChangeNotifier {
  static final String tempStudyCategoryId = UniqueKey().toString();
  static final String tempDailyCategoryId = UniqueKey().toString();
  static final String tempAppDevelopmentCategoryId = UniqueKey().toString();

  List<Category> _items = [
    Category(
      id: tempDailyCategoryId,
      uid: "",
      name: "Daily List",
      priorityOrder: 0,
    ),
    Category(
      id: tempAppDevelopmentCategoryId,
      uid: "",
      name: "App Development",
      priorityOrder: 1,
    ),
    Category(
      id: tempStudyCategoryId,
      uid: "",
      name: "Study",
      priorityOrder: 2,
    ),
  ];

  List<Category> get items {
    return [..._items];
  }

  List<Category> get itemsSorted {
    var items = [..._items];
    items.sort();
    return items;
  }

  void addCategoty(Category category) {
    _items.add(category);
    notifyListeners();
  }

  void removeCategory(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Category getById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void updateOrderIndex(int oldIndex, int newIndex) {
    var newItems = itemsSorted;
    final Category item = newItems.removeAt(oldIndex);
    newItems.insert(newIndex, item);

    for (int index = 0; index < newItems.length; index++) {
      newItems[index] =
          Category.fromCategory(origin: newItems[index], priorityOrder: index);
    }

    _items = newItems;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

import 'package:dosprav/models/category.dart';

class CategoriesProvider with ChangeNotifier {
  static final String tempStudyCategoryId = UniqueKey().toString();
  static final String tempDailyCategoryId = UniqueKey().toString();
  static final String tempAppDevelopmentCategoryId = UniqueKey().toString();
  static final String tempAtticCategoryId = UniqueKey().toString();

  List<Category> _items = [
    Category(
      id: tempDailyCategoryId,
      uid: "",
      name: "Daily List",
      priorityOrder: 0,
      isEditable: false,
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
    Category(
      id: tempAtticCategoryId,
      uid: "",
      name: "Attic",
      priorityOrder: 3,
      isEditable: false,
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

  void addCategory(Category category) {
    _items.add(category);
    _updatePriorityOrders();
  }

  void removeCategory(String id) {
    _items.removeWhere((element) => element.id == id);
    _updatePriorityOrders();
  }

  Category getById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void updateCategory(Category updatedCategory) {
    var index =
        _items.indexWhere((category) => category.id == updatedCategory.id);
    _items[index] = updatedCategory;
    _updatePriorityOrders();
  }

  void _updatePriorityOrders({List<Category>? itemsToUpdate}) {
    var newItems = itemsToUpdate ?? itemsSorted;
    for (int index = 0; index < newItems.length; index++) {
      newItems[index] = Category.fromCategory(
        origin: newItems[index],
        priorityOrder: index.toDouble(),
      );
    }
    _items = newItems;
    notifyListeners();
  }

  void updateOrderIndex(int oldIndex, int newIndex) {
    var newItems = itemsSorted;
    final Category item = newItems.removeAt(oldIndex);
    newItems.insert(newIndex, item);

    _updatePriorityOrders(itemsToUpdate: newItems);
  }
}

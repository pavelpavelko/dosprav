import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:dosprav/models/category.dart';

class CategoriesProvider with ChangeNotifier {
  static const String _categoriesFbUrl =
      "https://do-sprav-flutter-app-default-rtdb.firebaseio.com/categories.json";

  List<Category> _items = [];

  static const String _dailyListCategoryName = "Daily List";
  static const String _atticCategoryName = "Attic";

  final List<Category> _presetItems = [
    Category(
      name: _dailyListCategoryName,
      priorityOrder: 0,
      isEditable: false,
    ),
    Category(
      name: _atticCategoryName,
      priorityOrder: 1,
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

  Category get dailyListCategory {
   var index = _items.indexWhere((category) {
      return category.name == _dailyListCategoryName &&
          category.isEditable == false;
    });
    if(index >= 0){
      return _items[index];
    } else {
      return _presetItems[0];
    }
  }

  Category get atticCategory {
   var index = _items.indexWhere((category) {
      return category.name == _atticCategoryName &&
          category.isEditable == false;
    });
    if(index >= 0){
      return _items[index];
    } else {
      return _presetItems[1];
    }
  }

  Future<void> _addPresetCategories() async {
    for (var category in _presetItems) {
      await addCategory(Category.fromCategory(origin: category));
    }
  }

  Future<void> fetchCategories() async {
    try {
      final uri = Uri.parse(_categoriesFbUrl);
      final response = await http.get(uri);
      List<Category> fetchedCategoriesList = [];
      var decodedBody = json.decode(response.body);
      if (decodedBody is Map) {
        final extractedData = decodedBody as Map<String, dynamic>;
        extractedData.forEach((categoryId, categoryData) {
          fetchedCategoriesList.add(Category(
            id: categoryId,
            uid: categoryData["uid"],
            name: categoryData["name"],
            isEditable: categoryData["isEditable"],
            priorityOrder: categoryData["priorityOrder"],
          ));
        });

        _items = fetchedCategoriesList;
        notifyListeners();
      } else {
        await _addPresetCategories();
        notifyListeners();
      }
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> addCategory(Category category) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final uri = Uri.parse(_categoriesFbUrl);
      final response = await http.post(
        uri,
        body: json.encode({
          "uid": uid,
          "name": category.name,
          "priorityOrder": category.priorityOrder,
          "isEditable": category.isEditable,
        }),
      );
      final categoryId = json.decode(response.body)["name"];

      _items.add(Category.fromCategory(
        origin: category,
        id: categoryId,
        uid: uid,
      ));
      _updatePriorityOrders();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> removeCategory(String id) async {
    try {
      var uri = Uri.parse(
          "https://do-sprav-flutter-app-default-rtdb.firebaseio.com/categories/$id.json");
      var response = await http.delete(uri);
      if (response.statusCode >= 400) {
        throw "Cannot delete category. Please try again later.";
      }

      final indexToRemove = _items.indexWhere((element) => element.id == id);
      _items.removeAt(indexToRemove);
      _updatePriorityOrders();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Category getById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> updateCategory(Category updatedCategory) async {
    try {
      var index =
          _items.indexWhere((category) => category.id == updatedCategory.id);
      if (index >= 0) {
        var uri = Uri.parse(
            "https://do-sprav-flutter-app-default-rtdb.firebaseio.com/categories/${updatedCategory.id}.json");
        var response = await http.patch(uri,
            body: json.encode({
              "name": updatedCategory.name,
              "priorityOrder": updatedCategory.priorityOrder,
            }));

        if (response.statusCode >= 400) {
          throw "Somrthing went wrong on server side. Please try again later.";
        }

        _items[index] = updatedCategory;
        _updatePriorityOrders();
      } else {
        throw "Trying to edit unexisting category";
      }
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> _updatePriorityOrders({List<Category>? itemsToUpdate}) async {
    Map<String, Map<String, dynamic>> patchMap = {};

    var newItems = itemsToUpdate ?? itemsSorted;
    for (int index = 0; index < newItems.length; index++) {
      var updatedCategory = Category.fromCategory(
        origin: newItems[index],
        priorityOrder: index.toDouble(),
      );
      newItems[index] = updatedCategory;
      patchMap[updatedCategory.id] = {
        "id": updatedCategory.id,
        "uid": updatedCategory.uid,
        "name": updatedCategory.name,
        "isEditable": updatedCategory.isEditable,
        "priorityOrder": updatedCategory.priorityOrder,
      };
    }
    var uri = Uri.parse(_categoriesFbUrl);
    var response = await http.patch(uri, body: json.encode(patchMap));
    if (response.statusCode >= 400) {
      throw "Something went wrong on server side. Please try again later.";
    }

    _items = newItems;
    notifyListeners();
  }

  Future<void> updateOrderIndex(int oldIndex, int newIndex) async {
    final oldItems = itemsSorted;
    try {
      var newItems = itemsSorted;
      final Category item = newItems.removeAt(oldIndex);
      newItems.insert(newIndex, item);
      await _updatePriorityOrders(itemsToUpdate: newItems);
    } catch (error) {
      print(error);
      _items = oldItems;
      notifyListeners();
      rethrow;
    }
  }
}

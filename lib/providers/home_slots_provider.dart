import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:dosprav/models/home_slot.dart';
import 'package:dosprav/providers/categories_provider.dart';

class HomeSlotsProvider with ChangeNotifier {
  final int _maxSlots = 2;

  List<HomeSlot> _items = [
//    HomeSlot(slotType: SlotType.calendarView),
//    HomeSlot(slotType: SlotType.dailyList),
  ];

  List<HomeSlot> get items {
    return [..._items];
  }

  void clear() {
    _items = [];
    notifyListeners();
  }

  Future<void> fetchHomeSlots() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final uri = Uri.parse(
          "https://do-sprav-flutter-app-default-rtdb.firebaseio.com/homeSlots/$uid.json?auth=$token");
      final response = await http.get(uri);

      final decodedBody = json.decode(response.body);
      if (decodedBody is List) {
        List<HomeSlot> updatedItems = [];

        for (final slot in decodedBody) {
          if (slot is Map<String, dynamic>) {
            final id = slot["id"];
            final slotType = HomeSlot.getHomeSlotTypeByDescription(id);
            String? categoryId;
            if (slotType == SlotType.categoryView) {
              categoryId = slot["categoryId"];
            }
            updatedItems.add(
              HomeSlot(
                slotType: slotType,
                categoryId: categoryId,
              ),
            );
          }
        }

        _items = updatedItems;
        notifyListeners();
      }
    } catch (error, stackTrace) {
      print("${error.toString()}\n${stackTrace.toString()}");
      rethrow;
    }
  }

  Future<void> clearHome() async {
    try {
      _items = [];
      await updateHomeSlots();
      notifyListeners();
    } catch (error, stackTrace) {
      print("${error.toString()}\n${stackTrace.toString()}");
      rethrow;
    }
  }

  Future<void> updateHomeSlots() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final uri = Uri.parse(
          "https://do-sprav-flutter-app-default-rtdb.firebaseio.com/homeSlots/$uid.json?auth=$token");

      List<Map<String, dynamic>> itemsToUpload = [];
      for (final slot in _items) {
        Map<String, String> slotData = {};
        slotData["id"] = describeEnum(slot.slotType);
        if (slot.categoryId != null) {
          slotData["categoryId"] = slot.categoryId!;
        }
        itemsToUpload.add(slotData);
      }

      final response = await http.put(
        uri,
        body: json.encode(itemsToUpload),
      );
      if (response.statusCode >= 400) {
        throw "Server-side error. Error code: ${response.statusCode}";
      }
    } catch (error, stackTrace) {
      print("${error.toString()}\n${stackTrace.toString()}");
      rethrow;
    }
  }

  String getSnackBarMessage(
    BuildContext context,
    HomeSlot slot,
  ) {
    String result;
    if (_items.isNotEmpty && _items.first == slot) {
      result = "Already on the Home's top.";
    } else {
      switch (slot.slotType) {
        case SlotType.dailyList:
          result = "The Daily List view pushed on the Home's top.";
          break;
        case SlotType.categoriesTableView:
          result = "The Categories Table view pushed on the Home's top.";
          break;
        case SlotType.categoryView:
          var category = Provider.of<CategoriesProvider>(context, listen: false)
              .getById(slot.categoryId!);
          result =
              "The ${category.name} category view pushed on the Home's top.";
          break;
        case SlotType.calendarView:
          result = "The Calendar view pushed on the Home's top.";
          break;
      }
    }
    return result;
  }

  void pushOnTop(HomeSlot slotToPush) {
    var existingSlotIndex = _items.indexWhere((slot) => slot == slotToPush);
    if (existingSlotIndex != -1) {
      _items.removeAt(existingSlotIndex);
    }
    _items.insert(0, slotToPush);
    _items = _items.take(_maxSlots).toList();
    notifyListeners();
    updateHomeSlots();
  }

  void removeIfExist(String categoryId) {
    _items.removeWhere((slot) => categoryId == slot.categoryId);
    notifyListeners();
  }
}

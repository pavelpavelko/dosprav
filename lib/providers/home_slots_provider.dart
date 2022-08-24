import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/models/home_slot.dart';
import 'package:dosprav/providers/categories_provider.dart';

class HomeSlotsProvider with ChangeNotifier {
  final int _maxSlots = 2;

  List<HomeSlot> _items = [
    HomeSlot(slotType: SlotType.calendarView),
//    HomeSlot(slotType: SlotType.dailyList),
  ];

  List<HomeSlot> get items {
    return [..._items];
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
          var category = Provider.of<CategoriesProvider>(context, listen: false).getById(slot.categoryId!);
          result = "The ${category.name} category view pushed on the Home's top.";
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
  }

  void removeIfExist(String categoryId) {
    _items.removeWhere((slot) => categoryId == slot.categoryId);
    notifyListeners();
  }
}

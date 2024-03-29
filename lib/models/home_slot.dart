import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeSlot {
  final SlotType slotType;
  final String? categoryId;

  HomeSlot({required this.slotType, this.categoryId});

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! HomeSlot) {
      return false;
    }
    final HomeSlot typedOther = other;
    return slotType == typedOther.slotType &&
        categoryId == typedOther.categoryId;
  }

  @override
  int get hashCode => hashValues(slotType, categoryId);

  static SlotType getHomeSlotTypeByDescription(String description) {
    return SlotType.values.firstWhere((e) => describeEnum(e) == description);
  }
}

enum SlotType {
  dailyList,
  categoriesTableView,
  categoryView,
  calendarView,
}

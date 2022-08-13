import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/providers/home_slots_provider.dart';
import 'package:dosprav/models/home_slot.dart';

import 'package:dosprav/widgets/daily_view.dart';
import 'package:dosprav/widgets/categories_table_view.dart';
import 'package:dosprav/widgets/category_list_view.dart';

class HomeSlots extends StatefulWidget {
  const HomeSlots({Key? key}) : super(key: key);

  @override
  _HomeSlotsState createState() => _HomeSlotsState();
}

class _HomeSlotsState extends State<HomeSlots> {
  @override
  Widget build(BuildContext context) {
    var homeSlotsProvider =
        Provider.of<HomeSlotsProvider>(context, listen: true);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Column(
        children: homeSlotsProvider.items.map((slot) {
          return Expanded(child: _createViewBySlot(slot));
        }).toList(),
      ),
    );
  }

  Widget _createViewBySlot(HomeSlot slot) {
    var slots = Provider.of<HomeSlotsProvider>(context, listen: false).items;

    switch (slot.slotType) {
      case SlotType.dailyList:
        return DailyView(
          isShortMode: slots.length > 1,
        );
      case SlotType.categoriesTableView:
        return CategoriesTableView(
          isShortMode: slots.length > 1,
        );
      case SlotType.categoryView:
        assert(slot.categoryId != null);
        return CategoryListView(
          categoryId: slot.categoryId!,
          isShortMode: slots.length > 1,
        );
    }
  }
}

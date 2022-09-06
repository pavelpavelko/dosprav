import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:http/http.dart' as http;

import 'package:dosprav/widgets/daily_view_preview.dart';
import 'package:dosprav/models/view_model.dart';
import 'package:dosprav/screens/daily_view_screen.dart';
import 'package:dosprav/screens/categories_table_view_screen.dart';
import 'package:dosprav/widgets/categories_table_view_preview.dart';
import 'package:dosprav/screens/calendar_view_screen.dart';
import 'package:dosprav/widgets/calendar_view_preview.dart';

class ViewModelsProvider with ChangeNotifier {
  static final List<ViewModel> _initialItems = [
    ViewModel(
      id: "daily_list",
      name: "Daily List",
      imageAssetPath: "assets/images/daily_list_gallery_view_bg.jpeg",
      createViewPreview: () => DailyViewPreview(),
      viewScreenRouteName: DailyViewScreen.routeName,
    ),
    ViewModel(
      id: "categories_table",
      name: "Categories\nTable",
      imageAssetPath: "assets/images/categories_table_gallery_view_bg.jpeg",
      createViewPreview: () => CategoriesTableViewPreview(),
      viewScreenRouteName: CategoriesTableViewScreen.routeName,
    ),
    ViewModel(
      id: "calendar",
      name: "Calendar",
      imageAssetPath: "assets/images/calendar_gallery_view_bg.jpg",
      createViewPreview: () => CalendarViewPreview(),
      viewScreenRouteName: CalendarViewScreen.routeName,
    ),
  ];

  List<ViewModel> _items;

  ViewModelsProvider() : _items = [..._initialItems];

  void clear() {
    _items = [..._initialItems];
    notifyListeners();
  }

  List<ViewModel> get items {
    return [..._items];
  }

  Future<void> fetchViewModelStatuses() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final uri = Uri.parse(
          "https://do-sprav-flutter-app-default-rtdb.firebaseio.com/viewModelStatuses/$uid.json?auth=$token");
      final response = await http.get(uri);

      var decodedBody = json.decode(response.body);
      if (decodedBody is Map) {
        List<ViewModel> updatedItems = [];

        final extractedData = decodedBody as Map<String, dynamic>;
        for (var viewModel in _items) {
          updatedItems.add(
            ViewModel.fromViewModel(
              origin: viewModel,
              isActivated: extractedData[viewModel.id] ?? false,
            ),
          );
        }
        _items = updatedItems;
        notifyListeners();
      }
    } catch (error, stackTrace) {
      dev.log(error.toString(), stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> updateViewModelActiveStatus(
      String viewModelId, bool activeStatus) async {
    final index = _items.indexWhere((viewModel) => viewModel.id == viewModelId);
    final oldViewModel = _items[index];

    try {
      _items[index] = ViewModel.fromViewModel(
          origin: oldViewModel, isActivated: activeStatus);
      notifyListeners();

      final uid = FirebaseAuth.instance.currentUser?.uid;
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final uri = Uri.parse(
          "https://do-sprav-flutter-app-default-rtdb.firebaseio.com/viewModelStatuses/$uid/$viewModelId.json?auth=$token");
      final response = await http.put(
        uri,
        body: json.encode(activeStatus),
      );
      if (response.statusCode >= 400) {
        throw "Server-side error. Error code: ${response.statusCode}";
      }
    } catch (error, stackTrace) {
      dev.log(error.toString(), stackTrace: stackTrace);
      _items[index] = oldViewModel;
      notifyListeners();
      rethrow;
    }
  }
}

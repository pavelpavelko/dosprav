import 'dart:convert';

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
  List<ViewModel> _items = [
    ViewModel(
      id: "daily_list",
      name: "Daily List",
      imageUrl:
          "https://media.istockphoto.com/photos/notepad-open-with-white-blank-page-for-writing-idea-or-todo-list-a-picture-id867672394?k=20&m=867672394&s=612x612&w=0&h=tz9H4QDinsnwRrKMUv2fpBnLzrFS4aVbWUrmzmi1pCI=",
      createViewPreview: () => DailyViewPreview(),
      viewScreenRouteName: DailyViewScreen.routeName,
    ),
    ViewModel(
      id: "categories_table",
      name: "Categories\nTable",
      imageUrl:
          "https://i.pinimg.com/originals/1b/94/b5/1b94b5d0b0839b1a768050f8d4bcdfd0.jpg",
      createViewPreview: () => CategoriesTableViewPreview(),
      viewScreenRouteName: CategoriesTableViewScreen.routeName,
      //isActivated: true,
    ),
    ViewModel(
      id: "calendar",
      name: "Calendar",
      imageUrl:
          "https://res.cloudinary.com/softwarepundit/image/upload/c_lfill,dpr_1.0,f_auto,h_1600,q_auto,w_1600/v1/software/calendar-icon",
      createViewPreview: () => CalendarViewPreview(),
      viewScreenRouteName: CalendarViewScreen.routeName,
    ),
  ];

  List<ViewModel> get items {
    return [..._items];
  }

  Future<void> fetchViewModelStatuses() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      var viewModelStatusesFbUrl =
          "https://do-sprav-flutter-app-default-rtdb.firebaseio.com/viewModelStatuses/$uid.json";
      final uri = Uri.parse(viewModelStatusesFbUrl);
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
    } catch (error) {
      print(error);
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
      var viewModelStatusesFbUrl =
          "https://do-sprav-flutter-app-default-rtdb.firebaseio.com/viewModelStatuses/$uid/$viewModelId.json";
      final uri = Uri.parse(viewModelStatusesFbUrl);
      final response = await http.put(
        uri,
        body: json.encode(activeStatus),
      );
      if (response.statusCode >= 400) {
        throw "Server-side error. Error code: ${response.statusCode}";
      }
    } catch (error) {
      print(error);
      _items[index] = oldViewModel;
      notifyListeners();
      rethrow;
    }
  }
}

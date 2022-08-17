import 'package:dosprav/widgets/daily_view_preview.dart';
import 'package:flutter/material.dart';

import 'package:dosprav/models/view_model.dart';
import 'package:dosprav/screens/daily_view_screen.dart';
import 'package:dosprav/screens/categories_table_view_screen.dart';
import 'package:dosprav/widgets/categories_table_view_preview.dart';
import 'package:dosprav/screens/calendar_view_screen.dart';

class ViewModelsProvider with ChangeNotifier {
  final List<ViewModel> _items = [
    ViewModel(
      id: UniqueKey().toString(),
      uid: "",
      name: "Daily List",
      imageUrl:
          "https://media.istockphoto.com/photos/notepad-open-with-white-blank-page-for-writing-idea-or-todo-list-a-picture-id867672394?k=20&m=867672394&s=612x612&w=0&h=tz9H4QDinsnwRrKMUv2fpBnLzrFS4aVbWUrmzmi1pCI=",
      createViewPreview: () => DailyViewPreview(),
      viewScreenRouteName: DailyViewScreen.routeName,
    ),
    ViewModel(
      id: UniqueKey().toString(),
      uid: "",
      name: "Categories",
      imageUrl:
          "https://i.pinimg.com/originals/1b/94/b5/1b94b5d0b0839b1a768050f8d4bcdfd0.jpg",
      createViewPreview: () => CategoriesTableViewPreview(),
      viewScreenRouteName: CategoriesTableViewScreen.routeName,
      //isActivated: true,
    ),
    ViewModel(
      id: UniqueKey().toString(),
      uid: "",
      name: "Calendar",
      imageUrl:
          "https://res.cloudinary.com/softwarepundit/image/upload/c_lfill,dpr_1.0,f_auto,h_1600,q_auto,w_1600/v1/software/calendar-icon",
      createViewPreview: () => CategoriesTableViewPreview(),
      viewScreenRouteName: CalendarViewScreen.routeName,
      isActivated: true,
    ),
  ];

  List<ViewModel> get items {
    return [..._items];
  }

  void updateViewModel(ViewModel updatedViewModel) {
    var index =
        _items.indexWhere((viewModel) => viewModel.id == updatedViewModel.id);
    _items[index] = updatedViewModel;
    notifyListeners();
  }

  ViewModel getViewModelById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
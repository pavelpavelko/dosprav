import 'package:dosprav/widgets/daily_view_preview.dart';
import 'package:flutter/material.dart';

import 'package:dosprav/models/view_model.dart';

class ViewModelsProvider with ChangeNotifier {
  final List<ViewModel> _items = [
    ViewModel(
      id: UniqueKey().toString(),
      uid: "",
      name: "Daily List",
      imageUrl:
          "https://media.istockphoto.com/photos/notepad-open-with-white-blank-page-for-writing-idea-or-todo-list-a-picture-id867672394?k=20&m=867672394&s=612x612&w=0&h=tz9H4QDinsnwRrKMUv2fpBnLzrFS4aVbWUrmzmi1pCI=",
      description: "The Daily List widget is a tool that helps you manage your daily routine and recurrent tasks.\nYou do not need to keep all these in your mind anymore since do.sprav application and Daily List widget, in particular, will manage them all for you.\nPlease look at the Tutorial to better familiarize yourself with Daily List functionality.",
      createViewPreview: () => DailyViewPreview(),
    ),
    ViewModel(
      id: UniqueKey().toString(),
      uid: "",
      name: "Categories",
      imageUrl:
          "https://i.pinimg.com/originals/1b/94/b5/1b94b5d0b0839b1a768050f8d4bcdfd0.jpg",
      description: "TODO",
      createViewPreview: () => Center(child: Text("TODO"),),
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
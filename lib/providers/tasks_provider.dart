
import 'package:flutter/material.dart';

import '../models/task.dart';

class TasksProvider with ChangeNotifier {

  List<Task> _items = [];

  List<Task> get items => [..._items];


  void addTask(Task task) {
    _items.add(task);
    notifyListeners();
  }
  
}
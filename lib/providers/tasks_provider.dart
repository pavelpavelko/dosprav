import 'package:dosprav/providers/categories_provider.dart';
import 'package:flutter/material.dart';

import 'package:dosprav/models/task.dart';

class TasksProvider with ChangeNotifier {
  
  // ignore: prefer_final_fields
  List<Task> _items = [
    Task(
      id: UniqueKey().toString(),
      uid: "",
      name: "Sport workouts",
      description: "",
      categoryId: CategoriesProvider.tempDailyCategoryId,
      timestampCreated: DateTime.now().add(Duration(minutes: 1)),
      dueDate: DateTime.now().add(Duration(days: 2)),
      intervalDuration: Duration(days: 1),
    ),
    Task(
      id: UniqueKey().toString(),
      uid: "",
      name: "Buy ingredients for the soup",
      description: "",
      categoryId: CategoriesProvider.tempDailyCategoryId,
      timestampCreated: DateTime.now().add(Duration(minutes: 3)),
      dueDate: DateTime.now(),
      isComplete: true,
      intervalDuration: Duration(days: 0),
    ),
    Task(
      id: UniqueKey().toString(),
      uid: "",
      name: "Cook Borsch",
      description: "The ingredients:\n- Onion\n- Beetroot\n- Carrot\n- Tomato sause\n- Chiken\n- Beans\n- Potato\n- Cabbage",
      categoryId: CategoriesProvider.tempDailyCategoryId,
      timestampCreated: DateTime.now().add(Duration(minutes: 5)),
      dueDate: DateTime.now(),
      intervalDuration: Duration(days: 14),
    ),
    Task(
      id: UniqueKey().toString(),
      uid: "",
      name: "Read 100 years by Friedman",
      description: "",
      categoryId: CategoriesProvider.tempStudyCategoryId,
      timestampCreated: DateTime.now().add(Duration(minutes: 10)),
      dueDate: DateTime.now(),
      intervalDuration: Duration(days: 7),
    ),
   ];

  List<Task> get items => [..._items];

  void addTask(Task task) {
    _items.add(task);
    notifyListeners();
  }

  void removeTask(String id) {
    _items.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  Task getTaskById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void updateTask(Task updatedTask) {
    _updateTask(updatedTask);
    notifyListeners();
  }

  void _updateTask(Task updatedTask) {
    var index = _items.indexWhere((task) => task.id == updatedTask.id);
    _items[index] = updatedTask;
  }
  
  Map<String, List<Task>> get categorizedMap {
    Map<String, List<Task>> result = {};

    for (var task in _items) {
      var tasksCategoryList = result[task.categoryId];
      if(tasksCategoryList == null){
        tasksCategoryList = <Task>[];
        result[task.categoryId] = tasksCategoryList;
      }

      tasksCategoryList.add(task);
    }

    for (var categoryId in result.keys){
      result[categoryId]!.sort();
    }

    return result;
  }

  void updateCategorizedOrderIndex(String categoryId, int oldIndex, int newIndex){

    var newItems = categorizedMap[categoryId]!;

    final Task item = newItems.removeAt(oldIndex);
    newItems.insert(newIndex, item);

    for (int index = 0; index < newItems.length; index++) {
      _updateTask(Task.fromTask(origin: newItems[index], priorityOrder: index.toDouble()));
    }
    notifyListeners();
  }
}

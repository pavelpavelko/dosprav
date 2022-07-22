import 'package:flutter/material.dart';

import 'package:dosprav/models/task.dart';
import 'package:dosprav/models/category.dart';

class TasksProvider with ChangeNotifier {
  
  static final Category tempCat = Category(
    id: UniqueKey().toString(),
    uid: "",
    name: "Study",
  );

  // ignore: prefer_final_fields
  List<Task> _items = [
    Task(
      id: UniqueKey().toString(),
      uid: "",
      name: "Sport workouts",
      description: "",
      category: tempCat,
      timestampCreated: DateTime.now().add(Duration(minutes: 1)),
      dueDate: DateTime.now().add(Duration(days: 2)),
//      taskType: TaskType.disposable,
      intervalDuration: Duration(days: 1),
    ),
    Task(
      id: UniqueKey().toString(),
      uid: "",
      name: "Buy ingredients for the soup",
      description: "",
      category: tempCat,
      timestampCreated: DateTime.now().add(Duration(minutes: 3)),
      dueDate: DateTime.now(),
      isComplete: true,
//      taskType: TaskType.disposable,
      intervalDuration: Duration(days: 0),
    ),
    Task(
      id: UniqueKey().toString(),
      uid: "",
      name: "Cook Borsch",
      description: """The ingredients:
- Onion
- Beetroot
- Carrot
- Tomato sause
- Chiken
- Beans
- Potato
- Cabbage
""",
      category: tempCat,
      timestampCreated: DateTime.now().add(Duration(minutes: 5)),
      dueDate: DateTime.now(),
//      taskType: TaskType.disposable,
      intervalDuration: Duration(days: 14),
    ),
    Task(
      id: UniqueKey().toString(),
      uid: "",
      name: "Read 100 years by Friedman",
      description: "",
      category: tempCat,
      timestampCreated: DateTime.now().add(Duration(minutes: 10)),
      dueDate: DateTime.now(),
//      taskType: TaskType.disposable,
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
    var index = _items.indexWhere((task) => task.id == updatedTask.id);
    _items[index] = updatedTask;
    notifyListeners();
  }
}

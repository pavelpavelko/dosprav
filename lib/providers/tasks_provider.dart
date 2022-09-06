import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:dosprav/models/task.dart';

class TasksProvider with ChangeNotifier {
  List<Task> _items = [];

  List<Task> get items => [..._items];

  void clear() {
    _items = [];
    notifyListeners();
  }

  Future<void> fetchTasks() async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final uri = Uri.parse(
          "https://do-sprav-flutter-app-default-rtdb.firebaseio.com/tasks.json?auth=$token&orderBy=\"uid\"&equalTo=\"$uid\"");
      final response = await http.get(uri);
      List<Task> fetchedTasksList = [];
      var decodedBody = json.decode(response.body);
      if (decodedBody is Map) {
        final extractedData = decodedBody as Map<String, dynamic>;
        extractedData.forEach((taskId, taskData) {
          fetchedTasksList.add(Task(
            id: taskId,
            name: taskData["name"],
            description: taskData["description"],
            timestampCreated: DateTime.parse(taskData["timestampCreated"]),
            dueDate: DateTime.parse(taskData["dueDate"]),
            intervalDuration: Duration(days: taskData["intervalDuration"]),
            isComplete: taskData["isComplete"],
            categoryId: taskData["categoryId"],
            priorityOrder: taskData["priorityOrder"],
          ));
        });
        _items = fetchedTasksList;
        notifyListeners();
      }
    } catch (error, stackTrace) {
      dev.log(error.toString(), stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> addTask(Task task) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final uri = Uri.parse(
          "https://do-sprav-flutter-app-default-rtdb.firebaseio.com/tasks.json?auth=$token");
      final response = await http.post(
        uri,
        body: json.encode({
          "uid": uid,
          "name": task.name,
          "description": task.description,
          "timestampCreated": task.timestampCreated.toIso8601String(),
          "dueDate": task.dueDate.toIso8601String(),
          "intervalDuration": task.intervalDuration.inDays,
          "isComplete": task.isComplete,
          "categoryId": task.categoryId,
          "priorityOrder": task.priorityOrder,
        }),
      );
      final taskId = json.decode(response.body)["name"];

      _items.add(Task.fromTask(
        origin: task,
        id: taskId,
      ));
      notifyListeners();
    } catch (error, stackTrace) {
      dev.log(error.toString(), stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> removeTask(String id) async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      var uri = Uri.parse(
          "https://do-sprav-flutter-app-default-rtdb.firebaseio.com/tasks/$id.json?auth=$token");
      var response = await http.delete(uri);
      if (response.statusCode >= 400) {
        throw "Cannot delete task. Please try again later.";
      }

      final indexToRemove = _items.indexWhere((task) => task.id == id);
      _items.removeAt(indexToRemove);
      notifyListeners();
    } catch (error, stackTrace) {
      dev.log(error.toString(), stackTrace: stackTrace);
      rethrow;
    }
  }

  Task getTaskById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> updateTask(Task updatedTask, [bool shouldNotify = true]) async {
    try {
      var index = _items.indexWhere((task) => task.id == updatedTask.id);
      if (index >= 0) {
        final token = await FirebaseAuth.instance.currentUser?.getIdToken();
        var uri = Uri.parse(
            "https://do-sprav-flutter-app-default-rtdb.firebaseio.com/tasks/${updatedTask.id}.json?auth=$token");
        var response = await http.patch(uri,
            body: json.encode({
              "name": updatedTask.name,
              "description": updatedTask.description,
              "timestampCreated":
                  updatedTask.timestampCreated.toIso8601String(),
              "dueDate": updatedTask.dueDate.toIso8601String(),
              "intervalDuration": updatedTask.intervalDuration.inDays,
              "isComplete": updatedTask.isComplete,
              "categoryId": updatedTask.categoryId,
              "priorityOrder": updatedTask.priorityOrder,
            }));

        if (response.statusCode >= 400) {
          throw "Somrthing went wrong on server side. Please try again later.";
        }
        _items[index] = updatedTask;
        if (shouldNotify) {
          notifyListeners();
        }
      } else {
        throw "Trying to edit unexisting task";
      }
    } catch (error, stackTrace) {
      dev.log(error.toString(), stackTrace: stackTrace);
      rethrow;
    }
  }

  Map<String, List<Task>> get categorizedMap {
    Map<String, List<Task>> result = {};

    for (var task in _items) {
      var tasksCategoryList = result[task.categoryId];
      if (tasksCategoryList == null) {
        tasksCategoryList = <Task>[];
        result[task.categoryId] = tasksCategoryList;
      }

      tasksCategoryList.add(task);
    }

    for (var categoryId in result.keys) {
      result[categoryId]!.sort();
    }

    return result;
  }

  Future<void> updateCategorizedOrderIndex(
      String categoryId, int oldIndex, int newIndex) async {
    try {
      var newItems = categorizedMap[categoryId]!;

      final Task item = newItems.removeAt(oldIndex);
      newItems.insert(newIndex, item);

      for (int index = 0; index < newItems.length; index++) {
        var taskIndex =
            _items.indexWhere((task) => task.id == newItems[index].id);
        if (taskIndex >= 0) {
          final taskToUpdate = Task.fromTask(
            origin: newItems[index],
            priorityOrder: index.toDouble(),
          );
          await updateTask(taskToUpdate);
        } else {
          throw "Trying to reorder unexisting task.";
        }
      }
      notifyListeners();
    } catch (error, stackTrace) {
      dev.log(error.toString(), stackTrace: stackTrace);
      rethrow;
    }
  }
}

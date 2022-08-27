import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:dosprav/models/calendar_goal.dart';
import 'package:dosprav/models/calendar_goal_rule.dart';

class CalendarGoalsProvider with ChangeNotifier {
  static const maxGoalsNumber = 4;
  static const goalAssessmentDuration = Duration(days: 7);

  List<CalendarGoal> _items = [];

  List<CalendarGoal> get items {
    return [..._items];
  }

  void clear() {
    _items = [];
    notifyListeners();
  }

  Future<void> fetchCalendarGoals() async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final uri = Uri.parse(
          "https://do-sprav-flutter-app-default-rtdb.firebaseio.com/calendar_goals.json?auth=$token&orderBy=\"uid\"&equalTo=\"$uid\"");
      final response = await http.get(uri);
      List<CalendarGoal> fetchedCalendarGoalsList = [];
      var decodedBody = json.decode(response.body);
      if (decodedBody is Map) {
        final extractedData = decodedBody as Map<String, dynamic>;
        extractedData.forEach((calendarGoalId, calendarGoalData) {
          fetchedCalendarGoalsList.add(CalendarGoal(
            id: calendarGoalId,
            name: calendarGoalData["name"],
            desireTaskName: calendarGoalData["desireTaskName"],
            rule: CalendarGoalRule(
              type: GoalType.values[calendarGoalData["ruleType"]],
              numDaysForYellow: calendarGoalData["ruleNumDaysYellow"],
              numDaysForGreen: calendarGoalData["ruleNumDaysGreen"],
            ),
          ));
        });

        _items = fetchedCalendarGoalsList;
        notifyListeners();
      }
    } catch (error, stackTrace) {
      print("${error.toString()}\n${stackTrace.toString()}");
      rethrow;
    }
  }

  Future<void> addGoal(CalendarGoal newGoal) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final uri = Uri.parse(
          "https://do-sprav-flutter-app-default-rtdb.firebaseio.com/calendar_goals.json?auth=$token");
      final response = await http.post(
        uri,
        body: json.encode({
          "uid": uid,
          "name": newGoal.name,
          "desireTaskName": newGoal.desireTaskName ?? "",
          "ruleType": newGoal.rule.type.index,
          "ruleNumDaysYellow": newGoal.rule.numDaysForYellow,
          "ruleNumDaysGreen": newGoal.rule.numDaysForGreen,
        }),
      );
      final calendarGoalId = json.decode(response.body)["name"];
      _items.add(
        CalendarGoal.fromGoal(
          origin: newGoal,
          id: calendarGoalId,
        ),
      );
      notifyListeners();
    } catch (error, stackTrace) {
      print("${error.toString()}\n${stackTrace.toString()}");
      rethrow;
    }
  }

  CalendarGoal getById(String goalId) {
    return _items.firstWhere((goal) => goal.id == goalId);
  }

  Future<void> updateGoal(CalendarGoal goalToUpdate) async {
    try {
      var index = _items.indexWhere((goal) => goal.id == goalToUpdate.id);
      if (index >= 0) {
        final token = await FirebaseAuth.instance.currentUser?.getIdToken();
        var uri = Uri.parse(
            "https://do-sprav-flutter-app-default-rtdb.firebaseio.com/calendar_goals/${goalToUpdate.id}.json?auth=$token");
        var response = await http.patch(uri,
            body: json.encode({
              "name": goalToUpdate.name,
              "desireTaskName": goalToUpdate.desireTaskName ?? "",
              "ruleType": goalToUpdate.rule.type.index,
              "ruleNumDaysYellow": goalToUpdate.rule.numDaysForYellow,
              "ruleNumDaysGreen": goalToUpdate.rule.numDaysForGreen,
            }));

        if (response.statusCode >= 400) {
          throw "Somrthing went wrong on server side. Please try again later.";
        }

        _items[index] = goalToUpdate;
        notifyListeners();
      } else {
        throw "Trying to edit unexisting calendar goal.";
      }
    } catch (error, stackTrace) {
      print("${error.toString()}\n${stackTrace.toString()}");
      rethrow;
    }
  }

  Future<void> removeGoal(String goalId) async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      var uri = Uri.parse(
          "https://do-sprav-flutter-app-default-rtdb.firebaseio.com/calendar_goals/$goalId.json?auth=$token");
      var response = await http.delete(uri);
      if (response.statusCode >= 400) {
        throw "Cannot delete calendar goal. Please try again later.";
      }

      final indexToRemove =
          _items.indexWhere((element) => element.id == goalId);
      _items.removeAt(indexToRemove);
      notifyListeners();
    } catch (error, stackTrace) {
      print("${error.toString()}\n${stackTrace.toString()}");
      rethrow;
    }
  }
}

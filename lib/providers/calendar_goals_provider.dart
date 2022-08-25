import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:dosprav/models/calendar_goal.dart';
import 'package:dosprav/models/calendar_goal_rule.dart';

class CalendarGoalsProvider with ChangeNotifier {
  static const maxGoalsNumber = 4;
  static const goalAssessmentDuration = Duration(days: 7);

  static const String _calendarGoalsFbUrl =
      "https://do-sprav-flutter-app-default-rtdb.firebaseio.com/calendar_goals.json";

  List<CalendarGoal> _items = [];

  List<CalendarGoal> get items {
    return [..._items];
  }

  Future<void> fetchCalendarGoals() async {
    try {
      final uri = Uri.parse(_calendarGoalsFbUrl);
      final response = await http.get(uri);
      List<CalendarGoal> fetchedCalendarGoalsList = [];
      var decodedBody = json.decode(response.body);
      if (decodedBody is Map) {
        final extractedData = decodedBody as Map<String, dynamic>;
        extractedData.forEach((calendarGoalId, calendarGoalData) {
          fetchedCalendarGoalsList.add(CalendarGoal(
            id: calendarGoalId,
            uid: calendarGoalData["uid"],
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
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> addGoal(CalendarGoal newGoal) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final uri = Uri.parse(_calendarGoalsFbUrl);
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
          uid: uid,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
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
        var uri = Uri.parse(
            "https://do-sprav-flutter-app-default-rtdb.firebaseio.com/calendar_goals/${goalToUpdate.id}.json");
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
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> removeGoal(String goalId) async {
    try {
      var uri = Uri.parse(
          "https://do-sprav-flutter-app-default-rtdb.firebaseio.com/calendar_goals/$goalId.json");
      var response = await http.delete(uri);
      if (response.statusCode >= 400) {
        throw "Cannot delete calendar goal. Please try again later.";
      }

      final indexToRemove =
          _items.indexWhere((element) => element.id == goalId);
      _items.removeAt(indexToRemove);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}

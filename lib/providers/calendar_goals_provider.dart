import 'package:flutter/material.dart';

import 'package:dosprav/models/calendar_goal.dart';
import 'package:dosprav/models/calendar_goal_rule.dart';

class CalendarGoalsProvider with ChangeNotifier {
  static const maxGoalsNumber = 4;

  final List<CalendarGoal> _items = [
    CalendarGoal(
      id: UniqueKey().toString(),
      uid: "",
      name: "Sport",// ssf sdfs f sdfsd sdf sdf sfd sdf s",
      desireTaskName: "Sport Workout",
      rule: CalendarGoalRule(type: GoalType.desire),
    ),
    CalendarGoal(
      id: UniqueKey().toString(),
      uid: "",
      name: "Quit Smoking",
      rule: CalendarGoalRule(type: GoalType.avoid),
    ),
    CalendarGoal(
      id: UniqueKey().toString(),
      uid: "",
      name: "Walk",
      rule: CalendarGoalRule(type: GoalType.desire),
    ),
  ];

  List<CalendarGoal> get items {
    return [..._items];
  }

  void addGoal(CalendarGoal newGoal){
    _items.add(newGoal);
    notifyListeners();
  }

  CalendarGoal getById(String goalId){
     return _items.firstWhere((goal) => goal.id == goalId);
  }

  void updateGoal(CalendarGoal goalToUpdate) {
    var index =
        _items.indexWhere((goal) => goal.id == goalToUpdate.id);
    _items[index] = goalToUpdate;
    notifyListeners();
  }

  void removeGoal(String goalId) {
    _items.removeWhere((goal) => goal.id == goalId);
    notifyListeners();
  }

}

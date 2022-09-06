import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:dosprav/models/calendar_goal_rule.dart';
import 'package:dosprav/providers/calendar_goals_provider.dart';

class TaskHelper {
  static String formatDueDate(DateTime date) {
    if (compareDatesByDays(date, DateTime.now()) == 0) {
      return "Today";
    }
    final dateText = DateFormat.yMMMd().format(date);
    return dateText;
  }

  static int compareDatesByDays(DateTime first, DateTime second) {
    final cuttedFirst = DateTime(first.year, first.month, first.day);
    final cuttedSecond = DateTime(second.year, second.month, second.day);

    if (cuttedFirst == cuttedSecond) {
      return 0;
    }

    return cuttedFirst.isBefore(cuttedSecond) ? -1 : 1;
  }

  static Color getColorByGoalRule(CalendarGoalRule rule, int occurrenceNumber){
    var daysToCheck = CalendarGoalsProvider.goalAssessmentDuration.inDays;
    if (rule.type == GoalType.desire) {
      if (occurrenceNumber >= rule.numDaysForGreen) {
        return Colors.green;
      } else if(occurrenceNumber >= rule.numDaysForYellow){
        return Colors.yellow;
      } else {
        return Colors.red;
      }
    } else {
      if (occurrenceNumber <= daysToCheck - rule.numDaysForGreen) {
        return Colors.green;
      } else if(occurrenceNumber <= daysToCheck - rule.numDaysForYellow){
        return Colors.yellow;
      } else {
        return Colors.red;
      }
    }
  }

  static String getShortName(String name) {
    String shortName;
    List<String> nameWords = name.split(" ");
    if (nameWords.length == 1) {
      if (nameWords[0].length > 1) {
        shortName = nameWords[0].substring(0, 1).toUpperCase() +
            nameWords[0].substring(1, 2);
      } else {
        shortName = nameWords[0].substring(0, 1).toUpperCase();
      }
    } else {
      shortName = nameWords[0].substring(0, 1).toUpperCase() +
          nameWords[1].substring(0, 1).toUpperCase();
    }
    return shortName;
  }

  static Future<bool?> showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Are you sure?"),
        content: Text("Do you want to delete the task?"),
        actions: [
          TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(ctx).pop(false);
              }),
          TextButton(
            child: Text("Yes"),
            onPressed: () {
              Navigator.of(ctx).pop(true);
            },
          ),
        ],
      ),
    );
  }
}

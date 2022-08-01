import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  static String formatIntervalDuration(Duration interval) {
    return IntervalModel.getIntervalModelByDuration(interval).name;
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

class IntervalModel {
  const IntervalModel(this.name, this.interval);
  final String name;
  final Duration interval;

  @override
  String toString() => name;

  static const List<IntervalModel> intervals = <IntervalModel>[
    IntervalModel("Once", Duration(days: 0)),
    IntervalModel("Everyday", Duration(days: 1)),
    IntervalModel("Every 2 days", Duration(days: 2)),
    IntervalModel("Semiweekly", Duration(days: 3)),
    IntervalModel("Weekly", Duration(days: 7)),
    IntervalModel("Semimonthly", Duration(days: 14)),
    IntervalModel("Every 3 weeks", Duration(days: 21)),
    IntervalModel("Monthly", Duration(days: 30)),
  ];

  static IntervalModel getIntervalModelByDuration(Duration interval) {
    return intervals.firstWhere((element) => element.interval == interval);
  }
}

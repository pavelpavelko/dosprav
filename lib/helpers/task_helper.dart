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

import 'package:flutter/material.dart';

import 'package:dosprav/models/task.dart';
import 'package:dosprav/screens/task_detail_screen.dart';

class CategoriesTableItem extends StatelessWidget {
  const CategoriesTableItem({
    Key? key,
    required this.task,
    this.isShortMode = false,
  }) : super(key: key);

  final Task task;
  final bool isShortMode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          TaskDetailScreen.routeName,
          arguments: {
            "taskId": task.id,
          },
        );
      },
      child: Container(
        height: isShortMode ? 40 : 90,
        alignment: Alignment.center,
        color: Colors.transparent,
        padding: EdgeInsets.all(isShortMode ? 4 : 8),
        child: Text(
          task.name,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          maxLines: isShortMode ? 1 : 2,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.normal,
            decoration: task.isComplete ? TextDecoration.lineThrough : null,
          ),
        ),
      ),
    );
  }
}

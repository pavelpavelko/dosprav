import 'package:flutter/material.dart';

import 'package:dosprav/models/task.dart';
import 'package:dosprav/screens/task_detail_screen.dart';

class CategoriesTableItem extends StatelessWidget {
  const CategoriesTableItem({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      child: GestureDetector(
        child: Text(
          task.name,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.normal,
            decoration: task.isComplete ? TextDecoration.lineThrough : null,
          ),
        ),
        onTap: () {
          Navigator.of(context).pushNamed(
            TaskDetailScreen.routeName,
            arguments: {
              "taskId": task.id,
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/models/task.dart';
import 'package:dosprav/providers/tasks_provider.dart';
import 'package:dosprav/helpers/task_helper.dart';

class TaskDetail extends StatelessWidget {
  const TaskDetail({Key? key, required this.taskId}) : super(key: key);

  final String taskId;
  @override
  Widget build(BuildContext context) {
    final Task task =
        Provider.of<TasksProvider>(context, listen: false).getTaskById(taskId);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                child: task.isComplete
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                        size: 35,
                      )
                    : Text(
                        "\u2022",
                        style: TextStyle(
                          fontSize: 35,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Text(
                  task.name,
                  style: TextStyle(
                    fontSize: 20,
                    overflow: TextOverflow.visible,
                    decoration:
                        task.isComplete ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (task.description.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.description,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 13),
                    child: Text(
                      task.description,
                      style: TextStyle(
                        fontSize: 20,
                        overflow: TextOverflow.visible,
                        fontWeight: task.isComplete
                            ? FontWeight.w300
                            : FontWeight.normal,
                        decoration:
                            task.isComplete ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                alignment: Alignment.center,
                width: 50,
                height: 50,
                child: Icon(
                  Icons.date_range_sharp,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                TaskHelper.formatDueDate(task.dueDate),
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Expanded(child: SizedBox()),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text(
                  TaskHelper.formatIntervalDuration(task.intervalDuration),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 2,
          color: Theme.of(context).colorScheme.primary,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                alignment: Alignment.center,
                width: 50,
                height: 50,
                child: Icon(
                  Icons.category_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                  task.category.name,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/helpers/task_helper.dart';
import 'package:dosprav/models/task.dart';
import 'package:dosprav/providers/tasks_provider.dart';
import 'package:dosprav/screens/task_detail_screen.dart';

class DailyViewListItem extends StatelessWidget {
  const DailyViewListItem({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 30),
        child: Icon(
          Icons.check_outlined,
          color: Colors.white,
          size: 25,
        ),
      ),
      secondaryBackground: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 30),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 20,
        ),
      ),
      direction: task.isComplete
          ? DismissDirection.endToStart
          : DismissDirection.horizontal,
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          Provider.of<TasksProvider>(context, listen: false)
              .removeTask(task.id);
        } else {
          final updatedTask = Task.fromTask(origin: task, isComplete: true);
          Provider.of<TasksProvider>(context, listen: false)
              .updateTask(updatedTask);
        }
      },
      confirmDismiss: (direction) {
        if (direction == DismissDirection.startToEnd){
          return Future.value(true);
        } 
        return TaskHelper.showDeleteConfirmationDialog(context);
      },
        child: Container(
          height: 75,
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: ListTile(
            horizontalTitleGap: 5,
            leading: Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              child: task.isComplete
                  ? Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 35,
                    )
                  : Text(
                      "\u2022",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
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
            title: Text(
              task.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: task.isComplete ? FontWeight.w300 : FontWeight.bold,
                decoration: task.isComplete ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: task.description.isNotEmpty
                ? Text(
                    task.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      decoration:
                          task.isComplete ? TextDecoration.lineThrough : null,
                    ),
                  )
                : null,
          ),
        ),
    );
  }
}

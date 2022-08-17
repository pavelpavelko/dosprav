import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

import 'package:dosprav/helpers/task_helper.dart';
import 'package:dosprav/providers/tasks_provider.dart';
import 'package:dosprav/models/task.dart';
import 'package:dosprav/screens/task_detail_screen.dart';

class CalendarTableCell extends StatelessWidget {
  const CalendarTableCell({
    Key? key,
    required this.cellDate,
  }) : super(key: key);

  final DateTime cellDate;

  List<Task> _filterTodaysActiveTask(List<Task> tasks) {
    List<Task> filteredTasks = tasks.where((task) {
      return TaskHelper.compareDatesByDays(task.dueDate, cellDate) == 0 &&
          !task.isComplete;
    }).toList();

    return filteredTasks;
  }

  Widget createTasksWidget(BuildContext context, List<Task> tasks) {
    if (tasks.isNotEmpty) {
      var taskShortName = TaskHelper.getShortName(tasks[0].name);
      if (tasks.length > 1) {
        taskShortName += "/...";
      }
      List<FocusedMenuItem> menuItems = [];
      for (var task in tasks) {
        menuItems.add(
          FocusedMenuItem(
            title: Flexible(
              child: Text(
                task.name,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            onPressed: () {
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

      return Positioned.fill(
        child: FocusedMenuHolder(
          menuWidth: MediaQuery.of(context).size.width * 0.4,
          menuItemExtent: 40,
          animateMenuItems: false,
          blurBackgroundColor: Colors.grey,
          blurSize: 0,
          menuItems: menuItems,
          onPressed: () {},
          child: Container(
            padding: EdgeInsets.only(top: 15),
            alignment: Alignment.center,
            child: Text(
              taskShortName,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary.withAlpha(200),
                fontSize: 19,
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TasksProvider>(context);

    var isToday = TaskHelper.compareDatesByDays(cellDate, DateTime.now()) == 0;

    List<Task> todaysActiveTasks = _filterTodaysActiveTask(taskProvider.items);

    return GestureDetector(
      child: Container(
        color: Theme.of(context).colorScheme.secondaryContainer,
        height: 75,
        child: Stack(
          children: [
            createTasksWidget(context, todaysActiveTasks),
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    cellDate.day.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isToday
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.lightBlue,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

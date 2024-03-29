import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/helpers/task_helper.dart';
import 'package:dosprav/providers/tasks_provider.dart';
import 'package:dosprav/models/task.dart';
import 'package:dosprav/widgets/task_detail.dart';
import 'package:dosprav/screens/task_compose_screen.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({Key? key}) : super(key: key);

  static const String routeName = "/task-details";

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    final taskId = routeArgs["taskId"];
    assert(taskId != null);

    final tasksProvider = Provider.of<TasksProvider>(context, listen: false);
    final task = tasksProvider.getTaskById(taskId!);

    return Scaffold(
      appBar: AppBar(
        title: Text("Task Details"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: TaskDetail(
                taskId: taskId,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(0)),
                        backgroundColor: !task.isComplete
                            ? MaterialStateProperty.all(
                                Theme.of(context).colorScheme.secondary,
                              )
                            : null,
                      ),
                      onPressed: () {
                        final updatedTask = Task.fromTask(
                            origin: task, isComplete: !task.isComplete);
                        tasksProvider.updateTask(updatedTask);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        !task.isComplete ? "Complete" : "Undo",
                        style: TextStyle(
                          fontWeight: !task.isComplete
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: !task.isComplete
                              ? Theme.of(context).colorScheme.onSecondary
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
                if (!task.isComplete)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.all(0))),
                        onPressed: () {
                          final updatedTask = Task.fromTask(
                            origin: task,
                            dueDate: task.dueDate.add(
                              Duration(days: 7),
                            ),
                          );
                          tasksProvider.updateTask(updatedTask);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Postponing task for seven days.",
                              ),
                            ),
                          );
                        },
                        child: Text("Postpone"),
                      ),
                    ),
                  ),
                if (!task.isComplete)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.all(0))),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            TaskComposeScreen.routeName,
                            arguments: {
                              "taskId": task.id,
                            },
                          ).then((value) {
                            setState(() {});
                          });
                        },
                        child: Text("Edit"),
                      ),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(0))),
                      onPressed: () {
                        TaskHelper.showDeleteConfirmationDialog(context)
                            .then((shouldDelete) {
                          if (shouldDelete != null && shouldDelete) {
                            tasksProvider.removeTask(task.id);
                            Navigator.of(context).pop();
                          }
                        });
                      },
                      child: Text("Delete"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:dosprav/widgets/task_compose.dart';

class TaskComposeScreen extends StatefulWidget {
  const TaskComposeScreen({Key? key}) : super(key: key);

  static const String routeName = "/task-compose";

  @override
  State<TaskComposeScreen> createState() => _TaskComposeScreenState();
}

class _TaskComposeScreenState extends State<TaskComposeScreen> {
  final GlobalKey<TaskComposeState> _taskComposeState = GlobalKey();

  bool _taskChanged = false;

  bool _isSaving = false;

  void _updateTaskChanged(bool isChanged) {
    if (_taskChanged != isChanged) {
      setState(() {
        _taskChanged = isChanged;
      });
    }
  }

  Future showLeaveConfirmationDialog() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Are you sure?"),
        content:
            Text("There are unsaved changes. Are you sure you want leave?"),
        actions: [
          TextButton(
              child: Text(
                "Discard Changes",
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onPressed: () {
                Navigator.of(ctx).pop(true);
              }),
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _handleCancelOrBackPressed() {
    if (_taskChanged) {
      showLeaveConfirmationDialog().then((value) {
        if (value) {
          Navigator.of(context).pop();
        }
        FocusManager.instance.primaryFocus?.unfocus();
      });
    } else {
      Navigator.of(context).pop();
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    final taskId = routeArgs["taskId"];
    assert(taskId != null);

    return WillPopScope(
      onWillPop: _handleCancelOrBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edit Task"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              _handleCancelOrBackPressed();
            },
            icon: Icon(
              Icons.cancel,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          actions: [
            IconButton(
              onPressed: _taskChanged
                  ? () {
                      setState(() {
                        _isSaving = true;
                      });
                      if (_taskComposeState.currentState
                              ?.isComposeAvailable() ??
                          false) {
                        _taskComposeState.currentState
                            ?.tryCompose()
                            .then((value) {
                          Navigator.of(context).pop();
                          setState(() {
                            _isSaving = false;
                          });
                        });
                      }
                    }
                  : null,
              icon: Icon(Icons.save),
              color: Theme.of(context).colorScheme.primary,
            )
          ],
        ),
        body: _isSaving
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: TaskCompose(
                  key: _taskComposeState,
                  updateTaskChanged: _updateTaskChanged,
                  taskId: taskId,
                ),
              ),
      ),
    );
  }
}

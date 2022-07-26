import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/models/task.dart';
import 'package:dosprav/providers/tasks_provider.dart';
import 'package:dosprav/helpers/task_helper.dart';

import 'package:dosprav/widgets/interval_picker_dialog.dart';

class TaskCompose extends StatefulWidget {
  const TaskCompose({Key? key, this.taskId, this.updateTaskChanged})
      : super(key: key);

  final String? taskId;

  final void Function(
    bool isChanged,
  )? updateTaskChanged;

  @override
  TaskComposeState createState() => TaskComposeState();
}

class TaskComposeState extends State<TaskCompose> {
  Task? _taskToEdit;
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();

  TasksProvider? _tasksProvider;

  DateTime _dueDate = DateTime.now();
  Duration _intervalDuration = Duration(days: 0);

  bool _isNameLongEnought = true;

  @override
  void initState() {
    super.initState();

    _tasksProvider = Provider.of<TasksProvider>(context, listen: false);

    if (widget.taskId != null) {
      _taskToEdit = _tasksProvider!.getTaskById(widget.taskId!);
      _dueDate = _taskToEdit!.dueDate;
      _intervalDuration = _taskToEdit!.intervalDuration;
      _taskNameController.text = _taskToEdit!.name;
      _taskDescriptionController.text = _taskToEdit!.description;
    }
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }

  bool tryCompose() {
    if (_taskNameController.text.trim().length < 3) {
      setState(() {
        _isNameLongEnought = false;
      });
      return false;
    }

    Task newTask;
    if (_taskToEdit != null) {
      newTask = Task.fromTask(
          origin: _taskToEdit!,
          name: _taskNameController.text.trim(),
          description: _taskDescriptionController.text.trim(),
          dueDate: _dueDate,
          intervalDuration: _intervalDuration);
      _tasksProvider!.updateTask(newTask);
    } else {
      newTask = Task(
        id: UniqueKey().toString(),
        uid: "",
        name: _taskNameController.text.trim(),
        description: _taskDescriptionController.text.trim(),
        dueDate: _dueDate,
        intervalDuration: _intervalDuration,
        timestampCreated: DateTime.now(),
        category: TasksProvider.tempCat,
      );
      _tasksProvider!.addTask(newTask);
    }

    return true;
  }

  bool checkIsTaskChanged() {
    if (_taskToEdit == null) {
      return true;
    }

    if (_taskNameController.text != _taskToEdit!.name ||
        _taskDescriptionController.text != _taskToEdit!.description ||
        TaskHelper.compareDatesByDays(_dueDate, _taskToEdit!.dueDate) != 0 ||
        _intervalDuration != _taskToEdit!.intervalDuration) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {

    final FocusNode descriptionFocusNode = FocusNode();
    
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
                child: Text(
                  "\u2022",
                  style: TextStyle(
                    fontSize: 35,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: TextField(
                  controller: _taskNameController,
                  onChanged: (value) {
                    if (widget.updateTaskChanged != null) {
                      widget.updateTaskChanged!(checkIsTaskChanged());
                    }
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: "Name",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                    errorText: !_isNameLongEnought
                        ? 'Name should be three characterss at least'
                        : null,
                  ),
                  style: TextStyle(
                    fontSize: 20,
                    overflow: TextOverflow.visible,
                    fontWeight: FontWeight.normal,
                  ),
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(descriptionFocusNode);
                  },
                ),
              ),
            ],
          ),
        ),
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
                child: TextField(
                  focusNode: descriptionFocusNode,
                  keyboardType: _taskToEdit != null
                      ? TextInputType.multiline
                      : TextInputType.text,
                  maxLines: _taskToEdit != null ? null : 1,
                  controller: _taskDescriptionController,
                  onChanged: (value) {
                    if (widget.updateTaskChanged != null) {
                      widget.updateTaskChanged!(checkIsTaskChanged());
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Description",
                  ),
                  style: TextStyle(
                    fontSize: 20,
                    overflow: TextOverflow.visible,
                    fontWeight: FontWeight.normal,
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
              TextButton(
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: _dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  ).then(
                    (pickedDate) {
                      if (pickedDate != null) {
                        setState(() {
                          _dueDate = pickedDate;
                          if (widget.updateTaskChanged != null) {
                            widget.updateTaskChanged!(checkIsTaskChanged());
                          }
                        });
                      }
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  );
                },
                child: Text(
                  TaskHelper.formatDueDate(_dueDate),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Expanded(child: SizedBox()),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return IntervalPickerDialog(
                            selectedItem:
                                IntervalModel.getIntervalModelByDuration(
                                    _intervalDuration),
                            onCancel: () =>
                                FocusManager.instance.primaryFocus?.unfocus(),
                            onConfirm: (value) {
                              setState(() {
                                _intervalDuration = value.interval!;
                                if (widget.updateTaskChanged != null) {
                                  widget
                                      .updateTaskChanged!(checkIsTaskChanged());
                                }
                              });
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                          );
                        });
                  },
                  child: Text(
                    TaskHelper.formatIntervalDuration(_intervalDuration),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
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
              TextButton(
                onPressed: null,
                child: Text(
                  _taskToEdit != null ? _taskToEdit!.category.name : "TODO",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

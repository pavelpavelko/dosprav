import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dosprav/models/task.dart';
import 'package:dosprav/providers/tasks_provider.dart';
import 'package:dosprav/helpers/task_helper.dart';
import 'package:dosprav/widgets/picker_dialog.dart';
import 'package:dosprav/providers/categories_provider.dart';
import 'package:dosprav/models/category.dart';
import 'package:dosprav/screens/account_screen.dart';

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
  Category? _category;

  bool _isNameLongEnought = true;

  @override
  void initState() {
    super.initState();

    _tasksProvider = Provider.of<TasksProvider>(context, listen: false);

    var categoriesProvider =
        Provider.of<CategoriesProvider>(context, listen: false);

    String categoryId;
    if (widget.taskId != null) {
      _taskToEdit = _tasksProvider!.getTaskById(widget.taskId!);
      _dueDate = _taskToEdit!.dueDate;
      _intervalDuration = _taskToEdit!.intervalDuration;
      _taskNameController.text = _taskToEdit!.name;
      _taskDescriptionController.text = _taskToEdit!.description;
      categoryId = _taskToEdit!.categoryId;
    } else {
      categoryId = categoriesProvider.itemsSorted.first.id;
      SharedPreferences.getInstance().then((prefs) {
        final isDailyListAsDefault =
            prefs.getBool(AccountScreen.dailyListAsDefaultKey) ?? false;
        if (isDailyListAsDefault) {
          setState(() {
            _category = categoriesProvider.dailyListCategory;
          });
        }
      });
    }

    _category = categoriesProvider.getById(categoryId);
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }

  bool isComposeAvailable() {
    if (_taskNameController.text.trim().isEmpty) {
      setState(() {
        _isNameLongEnought = false;
      });
      return false;
    }
    return true;
  }

  Future<void> tryCompose() async {
    try {
      Task newTask;
      if (_taskToEdit != null) {
        newTask = Task.fromTask(
            origin: _taskToEdit!,
            name: _taskNameController.text.trim(),
            description: _taskDescriptionController.text.trim(),
            dueDate: _dueDate,
            intervalDuration: _intervalDuration,
            categoryId: _category!.id);
        await _tasksProvider!.updateTask(newTask);
      } else {
        newTask = Task(
          name: _taskNameController.text.trim(),
          description: _taskDescriptionController.text.trim(),
          dueDate: _dueDate,
          intervalDuration: _intervalDuration,
          timestampCreated: DateTime.now(),
          categoryId: _category!.id,
        );
        await _tasksProvider!.addTask(newTask);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Cannot save task. Please try again later.",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  bool checkIsTaskChanged() {
    if (_taskToEdit == null) {
      return true;
    }

    if (_taskNameController.text != _taskToEdit!.name ||
        _taskDescriptionController.text != _taskToEdit!.description ||
        TaskHelper.compareDatesByDays(_dueDate, _taskToEdit!.dueDate) != 0 ||
        _intervalDuration != _taskToEdit!.intervalDuration ||
        _category!.id != _taskToEdit!.categoryId) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final FocusNode descriptionFocusNode = FocusNode();

    final categoriesProvider =
        Provider.of<CategoriesProvider>(context, listen: false);

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
                        ? "Task name must not be empty."
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
                          return PickerDialog<IntervalModel>(
                            title: "Pick an interval for the task",
                            items: IntervalModel.intervals,
                            selectedItem: IntervalModel.getIntervalModel(
                                _intervalDuration),
                            onCancel: () =>
                                FocusManager.instance.primaryFocus?.unfocus(),
                            onConfirm: (dynamic value) {
                              setState(() {
                                _intervalDuration = value.interval;
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
                    IntervalModel.getIntervalModel(_intervalDuration).name,
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
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return PickerDialog<Category>(
                          title: "Pick a category of the task",
                          items: categoriesProvider.items,
                          selectedItem: _category!,
                          onCancel: () =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          onConfirm: (dynamic value) {
                            setState(() {
                              _category = value;
                              if (widget.updateTaskChanged != null) {
                                widget.updateTaskChanged!(checkIsTaskChanged());
                              }
                            });
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                        );
                      });
                },
                child: Text(
                  _category!.name,
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

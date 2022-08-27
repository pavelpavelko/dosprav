import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/providers/calendar_goals_provider.dart';
import 'package:dosprav/models/calendar_goal.dart';
import 'package:dosprav/models/calendar_goal_rule.dart';
import 'package:dosprav/models/task.dart';
import 'package:dosprav/providers/tasks_provider.dart';
import 'package:dosprav/providers/categories_provider.dart';

class CalendarGoalCompose extends StatefulWidget {
  const CalendarGoalCompose({
    Key? key,
    this.goalId,
  }) : super(key: key);

  final String? goalId;

  @override
  _CalendarGoalComposeState createState() => _CalendarGoalComposeState();
}

class _CalendarGoalComposeState extends State<CalendarGoalCompose> {
  CalendarGoal? _goalToEdit;
  late final CalendarGoalsProvider _goalsProvider;
  late final TextEditingController _goalNameController;
  late final TextEditingController _goalTaskNameController;

  String _goalName = "";
  bool _isNameErrorTextVisible = false;
  String _goalTaskName = "";
  bool _isTaskNameErrorTextVisible = false;

  int _numDaysForYellow = 2;
  int _numDaysForGreen = 5;

  late GoalType _goalType;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _goalsProvider = Provider.of<CalendarGoalsProvider>(context, listen: false);

    if (widget.goalId != null) {
      _goalToEdit = _goalsProvider.getById(widget.goalId!);
      _goalName = _goalToEdit!.name;
      _goalTaskName = _goalToEdit!.desireTaskName ?? "";
      _goalType = _goalToEdit!.rule.type;
      _numDaysForYellow = _goalToEdit!.rule.numDaysForYellow;
      _numDaysForGreen = _goalToEdit!.rule.numDaysForGreen;
    } else {
      _goalType = GoalType.desire;
    }

    _goalNameController = TextEditingController(
      text: _goalToEdit != null ? _goalToEdit!.name : "",
    );

    _goalTaskNameController = TextEditingController(
      text: _goalToEdit != null ? _goalToEdit!.desireTaskName : "",
    );
  }

  void _trySaveGoal() {
    var isNameValid = _goalName.trim().isNotEmpty;
    var isTaskNameValid = _goalTaskName.trim().isNotEmpty;
    setState(() {
      if (!isNameValid || (_goalType == GoalType.desire && !isTaskNameValid)) {
        _isNameErrorTextVisible = !isNameValid;
        _isTaskNameErrorTextVisible = !isTaskNameValid;
      } else {
        _saveGoal();
      }
    });
  }

  Future<void> _removeGoal() async {
    try {
      setState(() {
        _isSaving = true;
      });
      await _goalsProvider.removeGoal(_goalToEdit!.id);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Calendar goal deletion failed. Please try again later.",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _saveGoal() async {
    try {
      setState(() {
        _isSaving = true;
      });
      CalendarGoal newGoal;
      if (_goalToEdit != null) {
        newGoal = CalendarGoal.fromGoal(
          origin: _goalToEdit!,
          name: _goalName,
          desireTaskName: _goalTaskName,
          rule: CalendarGoalRule(
            type: _goalType,
            numDaysForYellow: _numDaysForYellow,
            numDaysForGreen: _numDaysForGreen,
          ),
        );
        await _goalsProvider.updateGoal(newGoal);
      } else {
        newGoal = CalendarGoal(
          name: _goalName,
          desireTaskName: _goalTaskName,
          rule: CalendarGoalRule(
            type: _goalType,
            numDaysForYellow: _numDaysForYellow,
            numDaysForGreen: _numDaysForGreen,
          ),
        );
        await _goalsProvider.addGoal(newGoal);
        if (newGoal.rule.type == GoalType.desire && mounted) {
          await Provider.of<TasksProvider>(context, listen: false).addTask(
            Task(
              name: newGoal.desireTaskName!,
              description: "",
              dueDate: DateTime.now(),
              intervalDuration: Duration(days: 1),
              timestampCreated: DateTime.now(),
              categoryId:
                  Provider.of<CategoriesProvider>(context, listen: false)
                      .dailyListCategory
                      .id,
            ),
          );
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Saving calendar goal failed. Please try again later.",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Text(
              _goalToEdit != null
                  ? "Edit Calendar Goal"
                  : "Create Calendar Goal",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 20,
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 0),
                    child: TextField(
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.name,
                      controller: _goalNameController,
                      onChanged: (value) {
                        setState(() {
                          _goalName = value;
                        });
                      },
                      onSubmitted: (value) => _trySaveGoal(),
                      decoration: InputDecoration(
                        labelText: "Goal Name",
                        errorText: _isNameErrorTextVisible
                            ? "Calendar Goal name must not be empty"
                            : null,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: double.infinity,
                    height: _goalType == GoalType.desire ? 70 : 0,
                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 5),
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 300),
                      opacity: _goalType == GoalType.desire ? 1 : 0,
                      child: TextField(
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.name,
                        enabled: _goalType == GoalType.desire,
                        controller: _goalTaskNameController,
                        onChanged: (value) {
                          setState(() {
                            _goalTaskName = value;
                          });
                        },
                        onSubmitted: (value) => _trySaveGoal(),
                        decoration: InputDecoration(
                          labelText: "\"Do\" Task Name",
                          errorText: _isTaskNameErrorTextVisible
                              ? "Calendar Goal's Task name must not be empty"
                              : null,
                        ),
                      ),
                    ),
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, top: 10),
                        child: RichText(
                          text: TextSpan(
                            text: "Goal Type (",
                            //style: TextStyle(fontSize: 20),
                            style: DefaultTextStyle.of(context)
                                .style
                                .copyWith(fontSize: 16),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Do ',
                                style: TextStyle(
                                  fontWeight: _goalType == GoalType.desire
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              TextSpan(text: '/ '),
                              TextSpan(
                                text: "Don't",
                                style: TextStyle(
                                  fontWeight: _goalType == GoalType.avoid
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              TextSpan(text: '):'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5, top: 10),
                      child: Switch(
                        value: _goalType == GoalType.desire,
                        onChanged: (bool value) {
                          setState(() {
                            _isTaskNameErrorTextVisible = false;
                            _goalType =
                                value ? GoalType.desire : GoalType.avoid;
                          });
                        },
                      ),
                    ),
                  ]),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Days per week for result color code",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.yellow,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              " - ",
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            DropdownButton<int>(
                              value: _numDaysForYellow,
                              icon: const Icon(
                                Icons.arrow_downward,
                                size: 15,
                              ),
                              elevation: 10,
                              style: const TextStyle(
                                  fontSize: 17, color: Colors.black),
                              underline: Container(
                                height: 1,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onChanged: (int? newValue) {
                                setState(() {
                                  _numDaysForYellow = newValue!;
                                });
                              },
                              items: <int>[1, 2, 3]
                                  .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text("$value"),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 35,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.green,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              " - ",
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            DropdownButton<int>(
                              value: _numDaysForGreen,
                              icon: const Icon(
                                Icons.arrow_downward,
                                size: 15,
                              ),
                              elevation: 10,
                              style: const TextStyle(
                                  fontSize: 17, color: Colors.black),
                              underline: Container(
                                height: 1,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onChanged: (int? newValue) {
                                setState(() {
                                  _numDaysForGreen = newValue!;
                                });
                              },
                              items: <int>[4, 5, 6, 7]
                                  .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text("$value"),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 10,
                    ),
                    child: Divider(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _isSaving
              ? Padding(
                  padding: EdgeInsets.all(6),
                  child: Center(child: CircularProgressIndicator()))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_goalToEdit != null)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text("Are you sure?"),
                                content: Text(
                                    "Do you want to delete the ${_goalToEdit!.name} goal?"),
                                actions: [
                                  TextButton(
                                      child: Text("NO"),
                                      onPressed: () {
                                        Navigator.of(ctx).pop(false);
                                      }),
                                  TextButton(
                                    child: Text("YES"),
                                    onPressed: () {
                                      Navigator.of(ctx).pop(true);
                                    },
                                  ),
                                ],
                              ),
                            ).then((value) {
                              if (value) {
                                _removeGoal();
                              }
                            });
                          },
                          child: Text(
                            "DELETE",
                            style: TextStyle(
                              color: Theme.of(context).errorColor,
                            ),
                          ),
                        ),
                      ),
                    Spacer(),
                    TextButton(
                      style: ButtonStyle(),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("CANCEL"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: TextButton(
                        onPressed: () {
                          _trySaveGoal();
                        },
                        child: Text("SAVE"),
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}

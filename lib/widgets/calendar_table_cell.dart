import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

import 'package:dosprav/helpers/task_helper.dart';
import 'package:dosprav/providers/tasks_provider.dart';
import 'package:dosprav/models/task.dart';
import 'package:dosprav/screens/task_detail_screen.dart';
import 'package:dosprav/widgets/calendar_goal_track_compose.dart';
import 'package:dosprav/models/calendar_goal_rule.dart';
import 'package:dosprav/models/calendar_goal_track.dart';
import 'package:dosprav/providers/calendar_goal_tracks_provider.dart';
import 'package:dosprav/providers/calendar_goals_provider.dart';
import 'package:dosprav/models/calendar_goal.dart';

class CalendarTableCell extends StatelessWidget {
  const CalendarTableCell({
    Key? key,
    required this.cellDate,
    required this.goalsSelectionMap,
    this.isShortMode = false,

  }) : super(key: key);

  final DateTime cellDate;
  final Map<String, bool> goalsSelectionMap;
  final bool isShortMode;

  List<Task> _filterTodaysActiveTask(List<Task> tasks) {
    List<Task> filteredTasks = tasks.where((task) {
      return TaskHelper.compareDatesByDays(task.dueDate, cellDate) == 0 &&
          !task.isComplete;
    }).toList();

    return filteredTasks;
  }

  Widget _createTasksWidget(BuildContext context, List<Task> tasks) {
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

  List<Widget> _createTrackWidget(BuildContext context) {
    List<Widget> result = [];

    if (TaskHelper.compareDatesByDays(cellDate, DateTime.now()) > 0) {
      return result;
    }

    var track = Provider.of<CalendarGoalTracksProvider>(context, listen: true)
        .getTrackByDate(cellDate);

    var goalProvider = Provider.of<CalendarGoalsProvider>(context);

    if (goalsSelectionMap.containsValue(true)) {
      for (var goalId in goalsSelectionMap.keys) {
        if (goalsSelectionMap[goalId] != null &&
            goalsSelectionMap[goalId] == true) {
          var selectedGoal = goalProvider.getById(goalId);
          var trackRow = _createTrackRowByGoal(
            context: context,
            goal: selectedGoal,
            track: track,
            isSelected: true,
          );
          result.add(trackRow);
          return result;
        }
      }
    }

    for (var goal in goalProvider.items) {
      var trackRow =
          _createTrackRowByGoal(context: context, goal: goal, track: track);
      result.add(trackRow);
    }

    return result;
  }

  Widget _createTrackRowByGoal(
      {required BuildContext context,
      required CalendarGoal goal,
      CalendarGoalTrack? track,
      bool isSelected = false}) {
    double trackIconSize = isSelected ? 27 : 12;
    double trackTextFontSize = 13;

    var shortName = TaskHelper.getShortName(goal.name);
    var goalTrackState =
        track?.trackStateMap[goal.id] ?? GoalTrackState.unknown;
    Icon goalTrackIcon;
    switch (goalTrackState) {
      case GoalTrackState.occurred:
        goalTrackIcon = Icon(
          Icons.check_circle_outline_rounded,
          size: trackIconSize,
          color: goal.rule.type == GoalType.desire
              ? Colors.green.withAlpha(150)
              : Colors.red.withAlpha(150),
        );
        break;
      case GoalTrackState.missed:
        goalTrackIcon = Icon(
          Icons.cancel_outlined,
          size: trackIconSize,
          color: goal.rule.type == GoalType.avoid
              ? Colors.green.withAlpha(150)
              : Colors.red.withAlpha(150),
        );
        break;
      case GoalTrackState.unknown:
        goalTrackIcon = Icon(
          Icons.question_mark_outlined,
          size: trackIconSize,
          color: Theme.of(context).colorScheme.primary.withAlpha(150),
        );
        break;
    }
    if (isSelected) {
      return Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: 15),
        child: goalTrackIcon);
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
            Text(
              "$shortName: ",
              style: TextStyle(
                height: 0.9,
                fontSize: trackTextFontSize,
                fontWeight: FontWeight.bold,
                color: track != null
                    ? Theme.of(context).colorScheme.primary.withAlpha(150)
                    : Colors.grey.withAlpha(150),
              ),
            ),
          goalTrackIcon,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TasksProvider>(context);

    var isToday = TaskHelper.compareDatesByDays(cellDate, DateTime.now()) == 0;

    List<Task> todaysActiveTasks = _filterTodaysActiveTask(taskProvider.items);

    List<Widget> trackRows = _createTrackWidget(context);

    return GestureDetector(
      onTap: () {
        if (TaskHelper.compareDatesByDays(cellDate, DateTime.now()) <= 0) {
          showDialog(
              context: context,
              builder: (ctx) {
                return CalendarGoalTrackCompose(trackDate: cellDate);
              });
        }
      },
      child: Container(
        color: Theme.of(context).colorScheme.secondaryContainer,
        height: isShortMode ? 70 : 75,
        child: Stack(
          children: [
            if (trackRows.isEmpty)
              _createTasksWidget(context, todaysActiveTasks),
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.topCenter,
                    child: Text(
                      cellDate.day.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 0.95,
                        color: isToday
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.lightBlue,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Spacer(),
                  ...trackRows,
                  SizedBox(
                    height: 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

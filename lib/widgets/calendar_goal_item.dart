import 'package:dosprav/helpers/task_helper.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/providers/calendar_goals_provider.dart';
import 'package:dosprav/widgets/calendar_goal_compose.dart';
import 'package:dosprav/models/calendar_goal.dart';

class CalendarGoalItem extends StatelessWidget {
  const CalendarGoalItem({
    Key? key,
    required this.goalId,
    this.isShortMode = false,
  }) : super(key: key);

  final String goalId;
  final bool isShortMode;

  @override
  Widget build(BuildContext context) {
    var goal = Provider.of<CalendarGoalsProvider>(context, listen: false)
        .getById(goalId);

    var shortName = TaskHelper.getShortName(goal.name);

    return Card(
      elevation: 3,
      color: Theme.of(context).colorScheme.secondary,
      child: GestureDetector(
        onLongPress: () {
          showDialog(
            context: context,
            builder: (ctx) {
              return CalendarGoalCompose(
                goalId: goalId,
              );
            },
          );
        },
        child: Container(
          height: isShortMode ? 25 : 30,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$shortName - ",
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Prompt",
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 3, left: 3),
                child: CircleAvatar(
                  radius: isShortMode ? 4 : 5,
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

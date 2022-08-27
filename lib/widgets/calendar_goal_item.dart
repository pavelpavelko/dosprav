import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/providers/calendar_goals_provider.dart';
import 'package:dosprav/widgets/calendar_goal_compose.dart';
import 'package:dosprav/helpers/task_helper.dart';
import 'package:dosprav/models/calendar_goal_track.dart';
import 'package:dosprav/providers/calendar_goal_tracks_provider.dart';
import 'package:dosprav/models/calendar_goal.dart';
import 'package:dosprav/models/calendar_goal_rule.dart';

class CalendarGoalItem extends StatelessWidget {
  const CalendarGoalItem({
    Key? key,
    required this.goalId,
    required this.onTap,
    required this.onLongPress,
    this.isShortMode = false,
    this.isSelected = false,
  }) : super(key: key);

  final String goalId;
  final bool isShortMode;
  final bool isSelected;
  final void Function(String goalId) onTap;
  final void Function(String goalId) onLongPress;


  Color _calculateColor(BuildContext context, CalendarGoal goal) {
    var tracksProvider = Provider.of<CalendarGoalTracksProvider>(context);

    var daysToCheck = CalendarGoalsProvider.goalAssessmentDuration.inDays;
    var occurrenceNumber = goal.rule.type == GoalType.desire ? 0 : daysToCheck;
    var now = DateTime.now();
    for (int dayIndex = 0;
        dayIndex < daysToCheck;
        dayIndex++) {
      var date = now.subtract(Duration(days: dayIndex));
      var track = tracksProvider.getTrackByDate(date);
      if(goal.rule.type == GoalType.desire){
        if(track != null && track.trackStateMap[goalId] != null && track.trackStateMap[goalId] == GoalTrackState.occurred.index){
          occurrenceNumber++;
        }
      } else {
        if(track != null && track.trackStateMap[goalId] != null && track.trackStateMap[goalId] == GoalTrackState.missed.index){
          occurrenceNumber--;
        }
      }
    }
    if (goal.rule.type == GoalType.desire) {
      if (occurrenceNumber >= goal.rule.numDaysForGreen) {
        return Colors.green;
      } else if(occurrenceNumber >= goal.rule.numDaysForYellow){
        return Colors.yellow;
      } else {
        return Colors.red;
      }
    } else {
      if (occurrenceNumber <= daysToCheck - goal.rule.numDaysForGreen) {
        return Colors.green;
      } else if(occurrenceNumber <= daysToCheck - goal.rule.numDaysForYellow){
        return Colors.yellow;
      } else {
        return Colors.red;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var goal = Provider.of<CalendarGoalsProvider>(context, listen: false)
        .getById(goalId);

    var shortName = TaskHelper.getShortName(goal.name);
    
    return Card(
      elevation: isSelected ? 0 : 5,
      color: isSelected ? Theme.of(context).colorScheme.secondary.withGreen(200) : Theme.of(context).colorScheme.secondary,
      child: GestureDetector(
        onLongPress: () {
          onLongPress(goalId);
          showDialog(
            context: context,
            builder: (ctx) {
              return CalendarGoalCompose(
                goalId: goalId,
              );
            },
          ).then((isDeleted) {
            if(isDeleted != null && isDeleted == true){
            }
          });
        },
        onTap: () {
          onTap(goalId);
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
                  radius: isShortMode ? 5 : 6,
                  backgroundColor: _calculateColor(context, goal),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

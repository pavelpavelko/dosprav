import 'package:flutter/material.dart';

import 'package:toggle_switch/toggle_switch.dart';

import 'package:provider/provider.dart';
import 'package:dosprav/providers/calendar_goal_tracks_provider.dart';
import 'package:dosprav/models/calendar_goal_track.dart';
import 'package:dosprav/providers/calendar_goals_provider.dart';
import 'package:dosprav/models/calendar_goal_rule.dart';
import 'package:dosprav/helpers/task_helper.dart';

class CalendarGoalTrackCompose extends StatefulWidget {
  const CalendarGoalTrackCompose({
    Key? key,
    required this.trackDate,
  }) : super(key: key);

  final DateTime trackDate;

  @override
  _CalendarGoalTrackComposeState createState() =>
      _CalendarGoalTrackComposeState();
}

class _CalendarGoalTrackComposeState extends State<CalendarGoalTrackCompose> {
  final Map<String, GoalTrackState> _trackStateMap = {};

  late final CalendarGoalTracksProvider _tracksProvider;

  CalendarGoalTrack? _existingTrack;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _tracksProvider =
        Provider.of<CalendarGoalTracksProvider>(context, listen: false);
    _existingTrack = _tracksProvider.getTrackByDate(widget.trackDate);
    initIsSelectedMap();
  }

  void initIsSelectedMap() {
    var goals =
        Provider.of<CalendarGoalsProvider>(context, listen: false).items;
    for (var goal in goals) {
      var trackState = GoalTrackState.unknown;
      if (_existingTrack != null) {
        var goalTrackStateIndex = _existingTrack?.trackStateMap[goal.id] ??
            GoalTrackState.unknown.index;
        trackState = GoalTrackState.values[goalTrackStateIndex];
      }
      _trackStateMap[goal.id] = trackState;
    }
  }

  List<Widget> _createGoalsRows() {
    List<Widget> result = [];
    var goalsProvider =
        Provider.of<CalendarGoalsProvider>(context, listen: false);
    var goals = goalsProvider.items;

    for (var goal in goals) {
      result.add(
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                "${goal.name}:",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ToggleSwitch(
              minWidth: 40.0,
              initialLabelIndex: _trackStateMap[goal.id]!.index,
              cornerRadius: 15.0,
              inactiveBgColor: Theme.of(context).colorScheme.secondaryContainer,
              totalSwitches: 3,
              customIcons: const [
                Icon(Icons.check_circle_outline_rounded,
                    size: 20, color: Colors.white),
                Icon(Icons.question_mark_outlined,
                    size: 20, color: Colors.white),
                Icon(Icons.cancel_outlined, size: 20, color: Colors.white),
              ],
              activeBgColors: [
                [
                  goal.rule.type == GoalType.desire
                      ? Colors.green.withAlpha(150)
                      : Colors.red.withAlpha(150)
                ],
                [Theme.of(context).colorScheme.primary.withAlpha(150)],
                [
                  goal.rule.type == GoalType.avoid
                      ? Colors.green.withAlpha(150)
                      : Colors.red.withAlpha(150)
                ]
              ],
              onToggle: (index) {
                setState(() {
                  _trackStateMap[goal.id] = GoalTrackState.values[index!];
                });
              },
            ),
          ],
        ),
      );

      result.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Divider(
            height: 1,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    return result;
  }

  Future<void> _saveTrack() async {
    try {
      setState(() {
        _isSaving = true;
      });

      Map<String, int> transformedMap = {};
      for (var goalId in _trackStateMap.keys) {
        transformedMap[goalId] =
            _trackStateMap[goalId]?.index ?? GoalTrackState.unknown.index;
      }

      CalendarGoalTrack newTrack;
      if (_existingTrack != null) {
        newTrack = CalendarGoalTrack.fromTrack(
          origin: _existingTrack!,
          trackStateMap: transformedMap,
        );
        await _tracksProvider.updateGoalTrack(newTrack);
      } else {
        newTrack = CalendarGoalTrack(
          date: widget.trackDate,
          trackStateMap: transformedMap,
        );
        await _tracksProvider.addGoalTrack(newTrack);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Saving calendar goal track failed. Please try again later.",
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
              "Track progress for ${TaskHelper.formatDueDate(widget.trackDate)}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 20,
              ),
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _createGoalsRows(),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          _isSaving
              ? Padding(
                  padding: EdgeInsets.all(6),
                  child: Center(child: CircularProgressIndicator()))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
                          _saveTrack();
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

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/providers/calendar_goals_provider.dart';
import 'package:dosprav/widgets/calendar_goal_item.dart';
import 'package:dosprav/widgets/calendar_goal_compose.dart';
import 'package:dosprav/widgets/calendar_table.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({
    Key? key,
    this.isShortMode = false,
  }) : super(key: key);

  final bool isShortMode;

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  final Map<String, bool> _goalsSelectionMap = {};

  List<Widget> _createGoalsTopPanel(CalendarGoalsProvider goalsProvider) {
    List<Widget> result = [];
    var goals = goalsProvider.items;

    for (var goal in goals) {
      result.add(
        CalendarGoalItem(
          goalId: goal.id,
          onTap: _onGoalItemTap,
          isShortMode: widget.isShortMode,
          isSelected: _goalsSelectionMap[goal.id] ?? false,
        ),
      );
    }
    result.add(Spacer());
    return result;
  }

  void _onGoalItemTap(String goalId) {
    setState(() {
      var goalSelection = _goalsSelectionMap[goalId] ?? false;
      _goalsSelectionMap[goalId] = !goalSelection;
      for (var key in _goalsSelectionMap.keys) {
        if(key != goalId){
        _goalsSelectionMap[key] = key == goalId;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var topPanelContainerSize = widget.isShortMode ? 28.0 : 35.0;
    var topPanelIzonSize = widget.isShortMode ? 20.0 : 25.0;

    var goalsProvider = Provider.of<CalendarGoalsProvider>(context, listen: true);
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: 10, vertical: widget.isShortMode ? 5 : 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withAlpha(160),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.all(widget.isShortMode ? 3 : 5),
            child: Row(
              children: [
                ..._createGoalsTopPanel(goalsProvider),
                Container(
                  margin: EdgeInsets.all(2),
                  width: topPanelContainerSize,
                  height: topPanelContainerSize,
                  alignment: Alignment.center,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: topPanelIzonSize,
                    icon: Icon(
                      Icons.add_circle_outlined,
                      color: goalsProvider.items.length <
                              CalendarGoalsProvider.maxGoalsNumber
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.grey,
                    ),
                    onPressed: goalsProvider.items.length <
                            CalendarGoalsProvider.maxGoalsNumber
                        ? () {
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                return CalendarGoalCompose();
                              },
                            );
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: CalendarTable(goalsSelectionMap: _goalsSelectionMap),
            ),
          ),
        ],
      ),
    );
  }
}

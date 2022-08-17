import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/providers/calendar_goals_provider.dart';
import 'package:dosprav/widgets/calendar_goal_item.dart';
import 'package:dosprav/widgets/calendar_goal_compose.dart';

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
  List<Widget> _createGoalsTopPanel() {
    List<Widget> result = [];
    var goals =
        Provider.of<CalendarGoalsProvider>(context, listen: false).items;

    for (var goal in goals) {
      result.add(
        CalendarGoalItem(
          goalId: goal.id,
          isShortMode: widget.isShortMode,
        ),
      );
    }
    result.add(Spacer());
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var goalsProvider =
        Provider.of<CalendarGoalsProvider>(context, listen: true);

    var topPanelContainerSize = widget.isShortMode ? 28.0 : 35.0;
    var topPanelIzonSize = widget.isShortMode ? 20.0 : 25.0;

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
                  ..._createGoalsTopPanel(),
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
              child: Center(
                child: Text(
                  "TBD",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

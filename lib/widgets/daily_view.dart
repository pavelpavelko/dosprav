import 'dart:math';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/helpers/task_helper.dart';
import 'package:dosprav/providers/tasks_provider.dart';
import 'package:dosprav/models/task.dart';
import 'package:dosprav/widgets/daily_view_list_item.dart';
import 'package:dosprav/models/category.dart';
import 'package:dosprav/providers/categories_provider.dart';

class DailyView extends StatefulWidget {
  const DailyView({
    Key? key,
    this.isCompleteVisible = false,
    this.isNextWeekVisible = false,
    this.isSuggestedVisible = false,
    this.demoItems,
    this.isShortMode = false,
  }) : super(key: key);

  final bool isCompleteVisible;
  final bool isNextWeekVisible;
  final bool isSuggestedVisible;

  final List<Task>? demoItems;

  final bool isShortMode;

  @override
  _DailyViewState createState() => _DailyViewState();
}

class _DailyViewState extends State<DailyView> {
  bool _isCompletedVisible = false;
  bool _isNextWeekVisible = false;
  bool _isSuggestedVisible = false;

  @override
  void initState() {
    super.initState();
    _isCompletedVisible = widget.isCompleteVisible;
    _isNextWeekVisible = widget.isNextWeekVisible;
    _isSuggestedVisible = widget.isSuggestedVisible;
  }

  @override
  Widget build(BuildContext context) {
    Category dailyCategory =
        Provider.of<CategoriesProvider>(context, listen: false)
            .getById(CategoriesProvider.tempDailyCategoryId);
    List<Task> items = widget.demoItems ??
        Provider.of<TasksProvider>(context).categorizedMap[dailyCategory.id]!;

    var topPanelContainerSize = widget.isShortMode ? 28.0 : 35.0;
    var topPanelIzonSize = widget.isShortMode ? 20.0 : 25.0;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: widget.isShortMode ? 5 : 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
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
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(2),
                    child: Container(
                      width: topPanelContainerSize,
                      height: topPanelContainerSize,
                      alignment: Alignment.center,
                      decoration: _isCompletedVisible
                          ? BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            )
                          : null,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: topPanelIzonSize,
                        icon: Icon(
                          _isCompletedVisible
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _isCompletedVisible = !_isCompletedVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(2),
                    child: Container(
                      width: topPanelContainerSize,
                      height: topPanelContainerSize,
                      alignment: Alignment.center,
                      decoration: _isNextWeekVisible
                          ? BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            )
                          : null,
                      child: IconButton(
                        iconSize: topPanelIzonSize,
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          _isNextWeekVisible
                              ? Icons.next_plan_rounded
                              : Icons.next_plan_outlined,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _isNextWeekVisible = !_isNextWeekVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                if (!widget.isShortMode)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(2),
                      child: Transform.rotate(
                        angle: pi,
                        child: Container(
                          width: topPanelContainerSize,
                          height: topPanelContainerSize,
                          alignment: Alignment.center,
                          decoration: _isSuggestedVisible
                              ? BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle,
                                )
                              : null,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: topPanelIzonSize,
                            icon: Icon(
                              _isSuggestedVisible
                                  ? Icons.wb_incandescent_rounded
                                  : Icons.wb_incandescent_outlined,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            onPressed: () {
                              setState(() {
                                _isSuggestedVisible = !_isSuggestedVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: ListTile.divideTiles(
                color: Theme.of(context).colorScheme.primary,
                tiles: items
                    .where((task) => !task.isComplete || _isCompletedVisible)
                    .where((task) {
                  var durationDiff = _isNextWeekVisible
                      ? Duration(days: 6)
                      : Duration(days: 0);
                  return TaskHelper.compareDatesByDays(
                          task.dueDate, DateTime.now().add(durationDiff)) <=
                      0;
                }).map(
                  (task) => DailyViewListItem(
                    task: task,
                    isShortMode: widget.isShortMode,
                  ),
                ),
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

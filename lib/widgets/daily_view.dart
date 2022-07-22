import 'dart:math';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/helpers/task_helper.dart';
import 'package:dosprav/providers/tasks_provider.dart';
import 'package:dosprav/models/task.dart';
import 'package:dosprav/widgets/daily_view_list_item.dart';

class DailyView extends StatefulWidget {
  const DailyView({Key? key}) : super(key: key);

  @override
  _DailyViewState createState() => _DailyViewState();
}

class _DailyViewState extends State<DailyView> {
  bool _isCompletedVisible = false;
  bool _isNextWeekVisible = false;
  bool _isSuggestedVisible = false;

  @override
  Widget build(BuildContext context) {
    List<Task> items = Provider.of<TasksProvider>(context).items;
    items.sort();

    return Card(
      margin: EdgeInsets.all(10),
      color: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        margin: EdgeInsets.all(7),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white60,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(2),
                      child: Container(
                        decoration: _isCompletedVisible
                            ? BoxDecoration(
                                color: Colors.blueGrey[700],
                                shape: BoxShape.circle,
                              )
                            : null,
                        child: IconButton(
                          iconSize: 35,
                          icon: Icon(
                            _isCompletedVisible
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: Colors.orange,
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
                        decoration: _isNextWeekVisible
                            ? BoxDecoration(
                                color: Colors.blueGrey[700],
                                shape: BoxShape.circle,
                              )
                            : null,
                        child: IconButton(
                          iconSize: 35,
                          icon: Icon(
                            _isNextWeekVisible
                                ? Icons.next_plan_rounded
                                : Icons.next_plan_outlined,
                            color: Colors.orange,
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
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(2),
                      child: Transform.rotate(
                        angle: pi,
                        child: Container(
                          decoration: _isSuggestedVisible
                              ? BoxDecoration(
                                  color: Colors.blueGrey[700],
                                  shape: BoxShape.circle,
                                )
                              : null,
                          child: IconButton(
                            iconSize: 35,
                            icon: Icon(
                              _isSuggestedVisible
                                  ? Icons.wb_incandescent_rounded
                                  : Icons.wb_incandescent_outlined,
                              color: Colors.orange,
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
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                "Your tasks for today:",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 5),
                children: ListTile.divideTiles(
                    color: Colors.blueGrey, 
                    tiles: items
                        .where(
                            (task) => !task.isComplete || _isCompletedVisible)
                            .where((task) {
                              var durationDiff = _isNextWeekVisible ? Duration(days: 6) : Duration(days: 0);
                              return TaskHelper.compareDatesByDays(task.dueDate, DateTime.now().add(durationDiff)) <= 0;
                            } )
                        .map((task) => DailyViewListItem(task: task))).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

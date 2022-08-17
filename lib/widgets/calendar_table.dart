import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:dosprav/providers/calendar_goals_provider.dart';
import 'package:dosprav/widgets/calendar_table_cell.dart';

class CalendarTable extends StatelessWidget {
  const CalendarTable({
    Key? key,
    this.showWeekDaysHeader = true,
  }) : super(key: key);

  final bool showWeekDaysHeader;

  static const int _numWeeks = 3;

  List<TableRow> _createTableRows(DateTime startDate) {
    List<TableRow> result = [];

    if (showWeekDaysHeader) {
      List<Widget> row = [];
      for (int weekDayIndex = 0; weekDayIndex < 7; weekDayIndex++) {
        var weekDay = DateFormat("E").format(
          startDate.add(Duration(days: weekDayIndex)),
        );
        row.add(
          Center(
            child: Text(
              weekDay,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        );
      }
      result.add(TableRow(children: row));
    }

    for (int weekIndex = 0; weekIndex < _numWeeks; weekIndex++) {
      List<Widget> row = [];
      for (int weekDayIndex = 0; weekDayIndex < 7; weekDayIndex++) {
        var daysFromStartDate = (7 * weekIndex) + weekDayIndex;
        var cellDate = startDate.add(
          Duration(days: daysFromStartDate),
        );
        row.add(
          CalendarTableCell(cellDate: cellDate),
        );
      }
      result.add(TableRow(children: row));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    var today = DateTime.now();
    var durationToSubstract = Duration(
      days: CalendarGoalsProvider.goalAssessmentDuration.inDays +
          today.weekday -
          1,
    );
    var startDate = today.subtract(durationToSubstract);
    var tableRows = _createTableRows(startDate);

    return Table(
      border: TableBorder.all(color: Theme.of(context).colorScheme.primary),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: tableRows,
    );
  }
}

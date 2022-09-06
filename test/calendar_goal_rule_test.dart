import 'package:flutter/material.dart';

import 'package:test/test.dart';

import 'package:dosprav/models/calendar_goal_rule.dart';
import 'package:dosprav/helpers/task_helper.dart';

void main() {
  group("CalendarGoalRule", () {
    test("Occurrence number enough for Colors.red color", () {
      CalendarGoalRule rule = CalendarGoalRule(
        type: GoalType.desire,
        numDaysForYellow: 2,
        numDaysForGreen: 5,
      );
      int occurrenceNumberInWeek = 1;
      expect(
        TaskHelper.getColorByGoalRule(rule, occurrenceNumberInWeek),
        Colors.red,
      );
    });
    test("Occurrence number enough for Colors.yellow color", () {
      CalendarGoalRule rule = CalendarGoalRule(
        type: GoalType.avoid,
        numDaysForYellow: 2,
        numDaysForGreen: 4,
      );
      int occurrenceNumberInWeek = 5;
      expect(
        TaskHelper.getColorByGoalRule(rule, occurrenceNumberInWeek),
        Colors.yellow,
      );
    });
    test("Occurrence number enough for Colors.green color", () {
      CalendarGoalRule rule = CalendarGoalRule(
        type: GoalType.desire,
        numDaysForYellow: 3,
        numDaysForGreen: 6,
      );
      int occurrenceNumberInWeek = 7;
      expect(
        TaskHelper.getColorByGoalRule(rule, occurrenceNumberInWeek),
        Colors.green,
      );
    });
  });
}

import 'package:dosprav/models/calendar_goal_rule.dart';

class CalendarGoal {
  CalendarGoal({
    this.id = "",
    required this.name,
    this.desireTaskName,
    required this.rule,
  });

  final String id;
  final String name;
  final String? desireTaskName;
  final CalendarGoalRule rule;

  CalendarGoal.fromGoal({
    required CalendarGoal origin,
    String? id,
    String? name,
    String? desireTaskName,
    CalendarGoalRule? rule,
  })  : id = id ?? origin.id,
        name = name ?? origin.name,
        desireTaskName = desireTaskName ?? origin.desireTaskName,
        rule = rule ?? origin.rule;
}

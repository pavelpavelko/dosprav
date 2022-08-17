import 'package:dosprav/models/calendar_goal_rule.dart';

class CalendarGoal {
  CalendarGoal({
    required this.id,
    required this.uid,
    required this.name,
    this.desireTaskName,
    required this.rule,
  });

  final String id;
  final String uid;
  final String name;
  final String? desireTaskName;
  final CalendarGoalRule rule;

  CalendarGoal.fromGoal({
    required CalendarGoal origin,
    String? name,
    String? desireTaskName,
    CalendarGoalRule? rule,
  })  : id = origin.id,
        uid = origin.uid,
        name = name ?? origin.name,
        desireTaskName = desireTaskName ?? origin.desireTaskName,
        rule = rule ?? origin.rule;
}

class CalendarGoalRule {
  CalendarGoalRule({
    required this.type,
    this.numDaysForYellow = 2,
    this.numDaysForGreen = 5,
  });

  final GoalType type;
  final int numDaysForYellow;
  final int numDaysForGreen;
}

enum GoalType {
  desire,
  avoid,
}

class CalendarGoalTrack {
  CalendarGoalTrack({
    this.id = "",
    required this.date,
    required this.trackStateMap,
  });

  CalendarGoalTrack.fromTrack({
    required CalendarGoalTrack origin,
    String? id,
    DateTime? date,
    Map<String, int>? trackStateMap,
  })  : id = id ?? origin.id,
        date = date ?? origin.date,
        trackStateMap = trackStateMap ?? origin.trackStateMap;

  final String id;
  final DateTime date;
  final Map<String, int> trackStateMap;
}

enum GoalTrackState {
  occurred,
  unknown,
  missed,
}

class CalendarGoalTrack {
  CalendarGoalTrack({
    required this.id,
    required this.uid,
    required this.date,
    required this.trackStateMap,
  });

  CalendarGoalTrack.fromTrack({
    required CalendarGoalTrack origin,
    DateTime? date,
    Map<String, GoalTrackState>? trackStateMap,
  })  : id = origin.id,
        uid = origin.uid,
        date = date ?? origin.date,
        trackStateMap = trackStateMap ?? origin.trackStateMap;

  final String id;
  final String uid;
  final DateTime date;
  final Map<String, GoalTrackState> trackStateMap;
}

enum GoalTrackState {
  occurred,
  unknown,
  missed,
}

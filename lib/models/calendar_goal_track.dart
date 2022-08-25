class CalendarGoalTrack {
  CalendarGoalTrack({
    this.id = "",
    this.uid = "",
    required this.date,
    required this.trackStateMap,
  });

  CalendarGoalTrack.fromTrack({
    required CalendarGoalTrack origin,
    String? id,
    String? uid,
    DateTime? date,
    Map<String, int>? trackStateMap,
  })  : id = id ?? origin.id,
        uid = uid ?? origin.uid,
        date = date ?? origin.date,
        trackStateMap = trackStateMap ?? origin.trackStateMap;

  final String id;
  final String uid;
  final DateTime date;
  final Map<String, int> trackStateMap;
}

enum GoalTrackState {
  occurred,
  unknown,
  missed,
}

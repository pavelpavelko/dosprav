import 'package:flutter/material.dart';

import 'package:dosprav/models/calendar_goal_track.dart';
import 'package:dosprav/helpers/task_helper.dart';

class CalendarGoalTracksProvider with ChangeNotifier {
  final List<CalendarGoalTrack> _items = [];

  List<CalendarGoalTrack> get items {
    return [..._items];
  }

  void addGoalTrack(CalendarGoalTrack newTrack) {
    _items.add(newTrack);
    notifyListeners();
  }

  void updateGoalTrack(CalendarGoalTrack trackToUpdate) {
    var index =
        _items.indexWhere((track) => track.id == trackToUpdate.id);
    _items[index] = trackToUpdate;
    notifyListeners();
  }

  CalendarGoalTrack? getTrackByDate(DateTime date) {
    var index = _items.indexWhere(
      (track) => TaskHelper.compareDatesByDays(track.date, date) == 0,
    );
    return index != -1 ? _items[index] : null;
  }
}

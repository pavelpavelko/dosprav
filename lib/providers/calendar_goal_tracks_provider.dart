import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:dosprav/models/calendar_goal_track.dart';
import 'package:dosprav/helpers/task_helper.dart';

class CalendarGoalTracksProvider with ChangeNotifier {
  List<CalendarGoalTrack> _items = [];

  static const String _calendarGoalTracksFbUrl =
      "https://do-sprav-flutter-app-default-rtdb.firebaseio.com/calendar_goal_tracks.json";

  List<CalendarGoalTrack> get items {
    return [..._items];
  }

  Future<void> fetchCalendarGoalTracks() async {
    try {
      final uri = Uri.parse(_calendarGoalTracksFbUrl);
      final response = await http.get(uri);
      List<CalendarGoalTrack> fetchedCalendarGoalTracksList = [];
      var decodedBody = json.decode(response.body);
      if (decodedBody is Map) {
        final extractedData = decodedBody as Map<String, dynamic>;
        extractedData.forEach((calendarGoalTrackId, calendarGoalTrackData) {
          fetchedCalendarGoalTracksList.add(CalendarGoalTrack(
            id: calendarGoalTrackId,
            uid: calendarGoalTrackData["uid"],
            date: DateTime.parse(calendarGoalTrackData["date"]),
            trackStateMap: Map<String, int>.from(json.decode(calendarGoalTrackData["trackStateMap"])),
          ));
        });
        _items = fetchedCalendarGoalTracksList;
        notifyListeners();
      }
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> addGoalTrack(CalendarGoalTrack newTrack) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final uri = Uri.parse(_calendarGoalTracksFbUrl);
      final response = await http.post(
        uri,
        body: json.encode({
          "uid": uid,
          "date": newTrack.date.toIso8601String(),
          "trackStateMap": json.encode(newTrack.trackStateMap),
        }),
      );
      final calendarGoalTrackId = json.decode(response.body)["name"];
      _items.add(
        CalendarGoalTrack.fromTrack(
          origin: newTrack,
          id: calendarGoalTrackId,
          uid: uid,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> updateGoalTrack(CalendarGoalTrack trackToUpdate) async {
    try {
      var index =
          _items.indexWhere((goalsTrack) => goalsTrack.id == trackToUpdate.id);
      if (index >= 0) {
        var uri = Uri.parse(
            "https://do-sprav-flutter-app-default-rtdb.firebaseio.com/calendar_goal_tracks/${trackToUpdate.id}.json");
        var response = await http.patch(uri,
            body: json.encode({
              "trackStateMap": json.encode(trackToUpdate.trackStateMap),
            }));

        if (response.statusCode >= 400) {
          throw "Somehing went wrong on server side. Please try again later.";
        }

        _items[index] = trackToUpdate;
        notifyListeners();
      } else {
        throw "Trying to edit unexisting calendar goal track.";
      }
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  CalendarGoalTrack? getTrackByDate(DateTime date) {
    var index = _items.indexWhere(
      (track) => TaskHelper.compareDatesByDays(track.date, date) == 0,
    );
    return index != -1 ? _items[index] : null;
  }
}

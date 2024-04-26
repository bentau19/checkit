import 'dart:ui';

import 'package:checkit/eventToolFunctions.dart';

class Event {
  Color color;
  String title;
  double duration;
  int startTime;
  int endTime;

  Event({
    required this.color,
    required this.title,
    required this.endTime,
    required this.startTime,
    this.duration = 76,
  }) {
    // ignore: unnecessary_this
    this.duration = ((endTime - startTime).toDouble() / 6) * 7.6;
  }

  String getStringTimeStart() {
    return Tools().fromNumToStringTime(startTime);
  }

  String getStringTimeEnd() {
    return Tools().fromNumToStringTime(endTime);
  }

  double getSpace() {
    return Tools().durationMaker(startTime);
  }
}

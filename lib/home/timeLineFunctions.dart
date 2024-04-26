import 'dart:math';

import 'package:flutter/material.dart';

import '../models/eventClass.dart';

List<dynamic> colors = [
  Colors.white,
  Colors.amberAccent,
  Colors.redAccent,
  Colors.blueAccent,
  Colors.green,
  Colors.deepOrange,
  Colors.purpleAccent,
  Colors.tealAccent,
  Colors.lime,
  Colors.indigoAccent,
  Colors.grey,
  Colors.lightGreenAccent
];
int setRandomColor() {
  int rnd = Random().nextInt(9);
  return rnd;
}

List<dynamic> stringToEvents(String input) {
  try {
    List<dynamic> output = [];
    List<String> events = input.split('#');
    for (int i = 1; i < events.length; i++) {
      if (getEvent(events[i]) != null) output.add(getEvent(events[i]));
    }
    return output;
  } catch (e) {
    return [];
  }
}

Event? getEvent(String eventString) {
  try {
    List<String> temp = eventString.split("-");
    String before = temp[0];
    String after = temp[1];
    if (getTime(before) == -1) return null;
    int startTime = getTime(before);
    if (getTime(after) == -1) return null;
    int endTime = getTime(after);
    String title = before.substring(0, temp[0].length - 6);
    return Event(
        color: colors[setRandomColor()],
        title: title,
        startTime: startTime,
        endTime: endTime);
  } catch (e) {
    return null;
  }
}

int getTime(String time) {
  try {
    List<String> timeSup = time.split(":");
    String minStarting = timeSup[1].substring(0, 2);
    String hourStarting =
        timeSup[0].substring(timeSup[0].length - 2, timeSup[0].length);
    int min = timeStringToNum(minStarting);
    int hour = timeStringToNum(hourStarting);
    return hour * 60 + min;
  } catch (e) {
    return -1;
  }
}

int timeStringToNum(String time) {
  int sum = 0;
  try {
    sum = int.parse(time[0]) * 10;
  } catch (d) {
    //print("error");
  }
  try {
    sum += int.parse(time[1]);
  } catch (s) {
    //print("error");
  }
  return sum;
}

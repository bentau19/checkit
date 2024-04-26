import 'package:flutter/material.dart';
import 'package:checkit/home/timeLineFunctions.dart';
import 'package:checkit/eventToolFunctions.dart';
import '../models/eventClass.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

String currentTitle = "";

addEventScreen(dynamic context, List<Event> events) {
  int startTime = DateTime.now().hour * 60 + DateTime.now().minute;
  int endtime = startTime + 60;
  int duration = 60;
  bool isEndTime = true;
  Widget durationView(int duration) {
    return Align(
        alignment: Alignment.topLeft,
        child: Column(children: [
          SizedBox(
            height: 20,
          ),
          Row(children: [
            RichText(
                text: TextSpan(
              text: "Duration:",
              style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  fontSize: 20),
            )),
            SizedBox(
              width: 35,
            ),
            RichText(
                text: TextSpan(
                    text: Tools().fromNumToStringTime(duration),
                    style: TextStyle(color: Colors.white, fontSize: 26)))
          ])
        ]));
  }

  Widget timePicker(DateTime time, String title, dynamic setState) {
    return Row(children: [
      Column(children: [
        SizedBox(
          height: 13,
        ),
        RichText(
            text: TextSpan(
          text: title + ":",
          style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.underline,
              fontSize: 20),
        ))
      ]),
      Container(
          height: 60,
          width: 100,
          child: TimePickerSpinner(
            normalTextStyle:
                TextStyle(color: Colors.white, letterSpacing: 0, fontSize: 26),
            time: time,
            is24HourMode: true,
            spacing: 0,
            itemHeight: 80,
            isForce2Digits: true,
            onTimeChange: (dateTime) {
              if (title == "Start Time") {
                setState(() {
                  startTime = dateTimeToInt(dateTime);
                });
              } else {
                setState(() {
                  endtime = dateTimeToInt(dateTime);
                });
              }
            },
          ))
    ]);
  }

  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade900,
            scrollable: true,
            title: Center(
                child: RichText(
                    text: TextSpan(
                        text: ("Add New Event"),
                        style: TextStyle(fontSize: 20)))),
            content: Stack(children: [
              Padding(
                  padding: EdgeInsets.only(top: 345, left: 200),
                  child: IconButton(
                      onPressed: ()=>isEndTime=!isEndTime, icon: Icon(Icons.swap_vert))),
              Container(
                  margin: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      eventsView(events, setState),
                      currentTitle == ""
                          ? TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'title',
                              ),
                            )
                          : SizedBox(),
                      timePicker(DateTime.now(), "Start Time", setState),
                      isEndTime?Column(
                        children: [
                          timePicker(
                              DateTime.now().subtract(Duration(hours: -1)),
                              "End Time",
                              setState),
                          durationView(endtime - startTime)
                        ],
                      ):
                      Column(
                        children: [
                          durationView(endtime - startTime),
                            timePicker(DateTime.now().subtract(Duration(hours: -1)),
                              "End Time",
                              setState),
                        ],)
                    ],
                  ))
            ]),
            actions: <Widget>[
              navigationButton(
                  "Back", Colors.redAccent, () => Navigator.of(context).pop()),
              navigationButton("Save", Colors.blueAccent, () => null)
            ],
          );
        });
      });
}

int dateTimeToInt(DateTime dateTime) {
  return dateTime.hour * 60 + dateTime.minute;
}

Widget eventsView(List<Event> events, dynamic setState) {
  return Container(
      height: 170,
      width: 300,
      child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: events.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                onTap: () {
                  setState(() {
                    if (events[index].title == currentTitle)
                      currentTitle = "";
                    else
                      currentTitle = events[index].title;
                  });
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: events[index].title == currentTitle
                          ? Colors.black
                          : Colors.grey.shade900,
                      border: Border.all(color: Colors.white)),
                  child: Center(
                      child:
                          RichText(text: TextSpan(text: events[index].title))),
                ));
          }));
}

Widget navigationButton(String title, Color color, Function() function) {
  return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
      child: GestureDetector(
          onTap: function,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                ),
                BoxShadow(
                  color: Colors.white,
                  spreadRadius: -12.0,
                  blurRadius: 12.0,
                ),
              ],
            ),
            //color: color,
            padding: EdgeInsets.all(16.0),
            child: RichText(
                text: TextSpan(
              text: (title),
              style: TextStyle(fontSize: 25),
            )),
          )));
}

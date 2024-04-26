import 'dart:async';
import 'package:checkit/home/timeLineFunctions.dart';
import 'package:flutter/material.dart';
import '../db/events_db.dart';
import '../models/datesClass.dart';
import '../models/eventClass.dart';
import '../eventToolFunctions.dart';

class TimeLine extends StatefulWidget {
  //final String data;
  const TimeLine({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  List<String> time = ["12 pm"];
  List<dynamic> events = [];
  // [
  //   Event(color: Colors.green, title: "test", startTime: 60, endTime: 160),
  //   Event(
  //       color: Colors.blueAccent, title: "test", startTime: 160, endTime: 240),
  //   Event(color: Colors.blueAccent, title: "test", startTime: 800, endTime: 860)
  // ];
  Date currentDate = Date(
    date: "",
  );
  DateTime today = DateTime.now();
  int currentTime = 350;
  double leftTimeLineSpace = 5;
  double sizeSpace = 40;
  @override
  void initState() {
    super.initState();
    currentDate.date = "${today.year}/${today.month}/${today.day}";
    currentTime = today.minute + today.hour * 60;
    refreshTasks();
    timeSetter();
  }

  Future refreshTasks() async {
    setState(() => isLoading = true);
    if (await EventsDatabase.instance.isDateExist(currentDate.date)) {
      currentDate = await EventsDatabase.instance.readDate(currentDate.date);
    }
    setState(() {
      events = stringToEvents(currentDate.events);
      isLoading = false;
    });
  }

  timeSetter() {
    for (int i = 1; i <= 12; i++) {
      time.add("$i am");
    }
    for (int i = 1; i <= 11; i++) {
      time.add("$i pm");
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToPoint());
    return isLoading
        ? CircularProgressIndicator()
        : SingleChildScrollView(
            controller: scrollController,
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: [timeBuilder(), eventsBuilder(), nowLineBuilder()],
                )));
  }

  Widget nowLineBuilder() {
    return Column(
      children: [
        SizedBox(height: Tools().durationMaker(currentTime)),
        lineTime()
      ],
    );
  }

  Widget lineTime() {
    double timeHeight = 18;
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: timeHeight / 2),
          height: 1.5,
          width: MediaQuery.of(context).size.width,
          color: Colors.amber,
        ),
        Container(
            margin: EdgeInsets.only(left: leftTimeLineSpace),
            height: timeHeight,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            width: 44,
            decoration: const BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: RichText(
                text: TextSpan(
              text: Tools().fromNumToStringTime(currentTime),
              style: const TextStyle(fontSize: 14, color: Colors.black),
            )))
      ],
    );
  }

  void _scrollToPoint() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
          Tools().durationMaker(currentTime > 150 ? currentTime - 150 : 0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.elasticOut);
    } else {
      Timer(const Duration(milliseconds: 400), () => _scrollToPoint());
    }
  }

  Widget timeBuilder() {
    return Row(
      children: [
        SizedBox(
          width: leftTimeLineSpace,
        ),
        Column(
          children: <Widget>[
            ...time.map((item) {
              return Column(
                children: [
                  RichText(
                      text: TextSpan(
                    text: item,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  )),
                  const SizedBox(
                    height: 60,
                  ),
                ],
              );
            }).toList(),
            SizedBox(
              height: 360,
            )
          ],
        )
      ],
    );
  }

  Widget eventsBuilder() {
    return Column(children: [
      const SizedBox(
        height: 9,
      ),
      Stack(children: <Widget>[
        ...events.map((item) {
          return Column(children: [
            SizedBox(
              height: item.getSpace(),
            ),
            taskCard(item)
          ]);
        }).toList(),
      ])
    ]);
  }

  Widget taskCard(Event event) {
    double totalsizeSpace = sizeSpace + leftTimeLineSpace * 2;
    return Row(
      children: [
        SizedBox(
          width: totalsizeSpace,
        ),
        Container(
            width: MediaQuery.of(context).size.width - totalsizeSpace,
            height: event.duration,
            decoration: BoxDecoration(
                color: event.color.withOpacity(0.2),
                border: Border(
                  left: BorderSide(color: event.color.withOpacity(1), width: 4),
                )),
            child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(
                      text: event.title,
                      style: TextStyle(
                          fontSize: 20, color: Colors.white.withOpacity(0.8)),
                    )),
                    RichText(
                        text: TextSpan(
                      text:
                          "${event.getStringTimeStart()}-${event.getStringTimeEnd()}",
                      style: TextStyle(
                          fontSize: 16, color: Colors.grey.withOpacity(0.8)),
                    )),
                  ],
                )))
      ],
    );
  }
}

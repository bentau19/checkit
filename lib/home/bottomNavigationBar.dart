import 'dart:ui';
import 'package:checkit/globalVariable.dart';
import 'package:flutter/material.dart';

import '../models/eventClass.dart';
import 'addEventScreen.dart';
import 'home.dart';

class ButtonNavigatiorBar extends StatefulWidget {
  final Function() notifyParent;
  const ButtonNavigatiorBar({super.key, required this.notifyParent});
  @override
  State<ButtonNavigatiorBar> createState() => _ButtonNavigatiorBarState();
}

class _ButtonNavigatiorBarState extends State<ButtonNavigatiorBar> {
  // static String selectedView = "DAY";
  // static String selectedtype = "comfort";
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      //Container(width: MediaQuery.of(context).size.width,height: ,)
      buttonShader(),
      Align(
        alignment: Alignment.bottomCenter,
        child: ClipRect(
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  height: 60.0,
                  decoration:
                      BoxDecoration(color: Colors.white60.withOpacity(0.07)),
                  child: Stack(
                    children: [
                      addButton(
                          () => addEventScreen(context, [
                                Event(
                                    color: Colors.green,
                                    title: "test",
                                    startTime: 60,
                                    endTime: 160),
                                Event(
                                    color: Colors.blueAccent,
                                    title: "test1",
                                    startTime: 160,
                                    endTime: 240),
                                Event(
                                    color: Colors.blueAccent,
                                    title: "test2",
                                    startTime: 800,
                                    endTime: 860)
                              ]),
                          Alignment.bottomRight),
                      changeViewLine(),
                      toggleButton(),
                    ],
                  ),
                ))),
      )
    ]);
  }

  Widget changeViewLine() {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [viewButton("DAY"), viewButton("WEEK"), viewButton("MONTH")],
      ),
    );
  }

  Widget viewButton(String title) {
    return GestureDetector(
        onTap: () {
          setState(() {
            GlobVariable.selectedView = title;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 7.5, vertical: 4.5),
          decoration: BoxDecoration(
              border: Border.all(
                width: 0.2,
                color: GlobVariable.selectedView == title
                    ? Colors.white
                    : Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(15)),
          child: RichText(
            text: TextSpan(
                text: title,
                style: TextStyle(
                    fontSize: 12,
                    color: GlobVariable.selectedView == title
                        ? Colors.white
                        : Colors.grey)),
          ),
        ));
  }

  Widget buttonShader() {
    return Align(
        alignment: Alignment.bottomRight,
        child: Padding(
            padding: EdgeInsets.only(right: 11, bottom: 5),
            child: Container(
                width: 35.0,
                height: 35.0,
                decoration: BoxDecoration(
                  color: Colors.yellow.withOpacity(0.7),
                  shape: BoxShape.circle,
                ))));
  }

  Widget toggleButton() {
    double size = 54;
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Container(
              width: 54,
              //color: Colors.green,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  iconToggle("written", size),
                  iconToggle("comfort", size)
                ],
              ),
            )));
  }

  Widget iconToggle(String type, double size) {
    return GestureDetector(
        onTap: () {
          setState(() {
            GlobVariable.selectedtype = type;
          });
          widget.notifyParent();
        },
        child: Container(
          width: size / 2,
          height: size / 2,
          decoration: BoxDecoration(
            color: type == GlobVariable.selectedtype
                ? Colors.white.withOpacity(0.15)
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            type == "comfort"
                ? Icons.calendar_today_rounded
                : Icons.format_list_bulleted_rounded,
            color:
                type == GlobVariable.selectedtype ? Colors.yellow : Colors.grey,
            size: 15,
          ),
        ));
  }
}

Widget addButton(Function() function, Alignment alignment) {
  return Align(
      alignment: alignment,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(45, 45),
              shape: const CircleBorder(),
              backgroundColor: Colors.yellow,
              foregroundColor: Colors.black,
            ),
            onPressed: function,
            child: const Icon(
              Icons.add,
              color: Colors.black,
              size: 30,
            ),
          )));
}

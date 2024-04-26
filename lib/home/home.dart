import 'package:checkit/constants/colors.dart';
import 'package:checkit/home/bottomNavigationBar.dart';
import 'package:checkit/home/timeLine.dart';
import 'package:checkit/home/writtenTimeLine.dart';
import 'package:checkit/todo/todo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../db/events_db.dart';
import '../db/notes_db.dart';
import '../globalVariable.dart';
import '../models/datesClass.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  // ignore: library_private_types_in_public_api
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  DateTime today = DateTime.now();
  List<DateTime> thisWeek = [];
  DateTime selectedDate = DateTime.now();
  String hebrewD = "loading";
  String entrance = "load";
  String exit = "ng";
  //   List<Event> events = [
  //   Event(color: Colors.green, title: "test", startTime: 60, endTime: 160),
  //   Event(
  //       color: Colors.blueAccent, title: "test", startTime: 160, endTime: 240),
  //   Event(color: Colors.blueAccent, title: "test", startTime: 800, endTime: 860)
  // ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    thisWeek = getWeekDays(today);
    hebrewDate();
    if (today.weekday == 5) shabatEnter();
  }

  Future hebrewDate() async {
    /////////hebrew date getter function
    http.Response response;
    response = await http
        .get(Uri.parse("https://www.hebcal.com/converter/?cfg=xml&gy="));
    // response = await http.get("https://www.hebcal.com/etc/hdate-he.js");
    if (response.statusCode == 200) {
      try {
        List<String> temp = response.body.split('str="');
        temp = temp[1].split('" />');
        setState(() {
          hebrewD = temp[0];
        });
      } catch (e) {
        print(e);
        hebrewD = "there is a problem that will fix soon!!!";
      }
    } else {
      hebrewD = "failed";
    }
  }

  Future shabatEnter() async {
    ///// get when shabat enter
    http.Response response;
    response = await http.get(
        Uri.parse("https://www.maariv.co.il/jewishism/shabat-times/Nahariyya"));

    if (response.statusCode == 200) {
      try {
        List<String> temp =
            response.body.split("Details-city-shabbat-light-candle");
        temp = temp[1].split("Details-city-parasha");
        temp = temp[0].split(":");
        setState(() {
          entrance = twoLastAndBeginCombine(temp, 1);
          exit = twoLastAndBeginCombine(temp, 3);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  String twoLastAndBeginCombine(List<String> temp, int idx) {
    int stringLen = temp[idx].length;
    String Final = temp[idx].substring(stringLen - 2, stringLen) + ":";
    Final = Final + temp[idx + 1].substring(0, 2);
    return Final;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: buildAppBar(
          Icon(Icons.assignment),
          hebrewD,
          () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ToDo()),
            );
          },
        ),
        body: Stack(children: [
          Column(
            children: [
              title("monday, 5th April 2021"),
              Expanded(
                  child: GlobVariable.selectedtype == "comfort"
                      ? TimeLine()
                      : WrittenTimeLine())
            ],
          ),
          ButtonNavigatiorBar(notifyParent: refresh)
        ]));
  }

  refresh() {
    setState(() {});
  }

  Widget title(String date) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          color: kpurple,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(35))),
      child: Column(children: [
        RichText(
            text: TextSpan(
          text: date,
          style: TextStyle(color: Kpink, fontSize: 24),
        )),
        Center(child: today.weekday == 5 ? shabbatTemplate() : SizedBox()),
        const SizedBox(
          height: 15,
        ),
        daysLineletters(),
        SizedBox(
          height: 5,
        ),
        daysLineNumbers(thisWeek),
      ]),
    );
  }

  shabbatTemplate() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/candle-holder.png'),
            width: 35,
            height: 25,
          ),
          RichText(
              text: TextSpan(
            text: "$entrance : $exit",
            style: TextStyle(color: Kpink, fontSize: 20),
          )),
          Image(
            image: AssetImage('assets/candle-holder.png'),
            width: 35,
            height: 25,
          ),
        ],
      ),
    );
  }

  Widget daysLineletters() {
    List<String> daysLetters = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return daysLineTemplate((item) {
      return RichText(
          text: TextSpan(
        style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.7)),
        text: item,
      ));
    }, daysLetters);
  }

  Widget daysLineNumbers(List<DateTime> weekDates) {
    return daysLineTemplate((item) {
      return GestureDetector(
          onTap: () => setState(() {
                selectedDate = item;
              }),
          child: Container(
              width: MediaQuery.of(context).size.width / 8,
              height: MediaQuery.of(context).size.width / 11,
              decoration: BoxDecoration(
                  color:
                      selectedDate.day == item.day ? Kpink : Colors.transparent,
                  shape: BoxShape.circle),
              child: Center(
                  child: RichText(
                      text: TextSpan(
                style: TextStyle(
                  fontSize: 18,
                  color: selectedDate.day == item.day
                      ? Colors.black
                      : Colors.white,
                ),
                text: item.day.toString(),
              )))));
    }, weekDates);
  }

  Widget daysLineTemplate(
      Widget Function(dynamic item) function, List<dynamic> items) {
    return Center(
        child: Row(
      children: <Widget>[
        ...items.map((item) {
          return Container(
              width: MediaQuery.of(context).size.width / 8,
              child: Center(child: function(item)));
        }).toList(),
      ],
    ));
  }

  List<DateTime> _setWeekDays(DateTime sundayDate) {
    List<DateTime> weekDates = [sundayDate];
    for (int i = 1; i < 7; i++) {
      weekDates.add(sundayDate.add(Duration(days: i)));
    }
    return weekDates;
  }

  List<DateTime> getWeekDays(DateTime current) {
    List<DateTime> result = [];
    if (current.weekday == 7) {
      result = _setWeekDays(current);
    } else {
      result = _setWeekDays(current.subtract(Duration(days: current.weekday)));
    }
    return result;
  }
}

AppBar buildAppBar(Icon midIcon, String date, Function() midFunction) {
  return AppBar(
    backgroundColor: kpurple,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () {},
    ),
    centerTitle: true,
    title: RichText(
        text: TextSpan(
      style: TextStyle(color: Colors.white.withOpacity(0.9)),
      text: date,
    )),
    actions: [
      IconButton(icon: midIcon, onPressed: midFunction),
      IconButton(
        icon: const Icon(Icons.account_circle_rounded),
        onPressed: () {},
      ),
    ],
  );
}

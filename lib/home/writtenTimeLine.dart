import 'package:checkit/db/events_db.dart';
import 'package:checkit/models/datesClass.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class WrittenTimeLine extends StatefulWidget {
  const WrittenTimeLine({super.key});
  @override
  State<WrittenTimeLine> createState() => _WrittenTimeLineState();
}

class _WrittenTimeLineState extends State<WrittenTimeLine> {
  DateTime date = DateTime.now();

  Date currentDate = Date(
    date: "",
  );
  bool isLoading = false;
  @override
  void initState() {
    currentDate.date = "${date.year}/${date.month}/${date.day}";
    refreshTasks();
  }

  Future refreshTasks() async {
    setState(() => isLoading = true);
    if (await EventsDatabase.instance.isDateExist(currentDate.date)) {
      currentDate = await EventsDatabase.instance.readDate(currentDate.date);
      //print(currentDate.events);
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator()
        : TextFormField(
            keyboardType: TextInputType.multiline,
            initialValue: currentDate.events,
            onChanged: (value) async {
              currentDate.events = value;
              if (await EventsDatabase.instance.isDateExist(currentDate.date)) {
                // print("update!!");
                await EventsDatabase.instance.update(currentDate);
              } else {
                await EventsDatabase.instance.create(currentDate);
                currentDate =
                    await EventsDatabase.instance.readDate(currentDate.date);
                // print("creating");
              }
            },
            maxLines: null,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          );
  }
}

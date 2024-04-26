import 'package:checkit/todo/todo.dart';
import 'package:flutter/material.dart';

import '../db/notes_db.dart';
import '../models/TaskClass.dart';

class AddTaskScreen extends StatefulWidget {
  final dynamic editNum;
  final String title;
  final String content;
  final bool isEvent;
  const AddTaskScreen(
      {super.key,
      required this.editNum,
      required this.title,
      required this.content,
      required this.isEvent});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  bool isEvent = false;
  String title = "";
  String content = "";
  List<String> folders = ["main", "folder1"];
  String dropdownValue = "main";
  @override
  void initState() {
    // TODO: implement initState
    isEvent = widget.isEvent;
    title = widget.title;
    content = widget.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [addTaskAppbar(context), contentTextField()],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {},
        child: Icon(Icons.save),
      ),
    );
  }

  Widget addTaskAppbar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
              bottom: BorderSide(
            color: Colors.grey,
          ))),
      child: Row(
        children: [
          iconButton(() async {
            if (title != "") {
              if (widget.editNum.runtimeType == 1.runtimeType) {
                final note = Task(
                    title: title,
                    content: content,
                    isEvent: isEvent,
                    id: widget.editNum);
                await NotesDatabase.instance.update(note);
              } else {
                final note =
                    Task(title: title, content: content, isEvent: isEvent);
                await NotesDatabase.instance.create(note);
              }
            }
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ToDo()),
            );
          }, Icon(Icons.arrow_back), 50),
          selectButton(),
          folderSelector(),
          titleTextField(),
        ],
      ),
    );
  }

  Widget selectButton() {
    return Tooltip(
        message: "Is Event?",
        triggerMode: TooltipTriggerMode.longPress,
        child: GestureDetector(
            onTap: (() => setState(() => isEvent = !isEvent)),
            child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: isEvent ? Colors.yellow : Colors.black,
                    shape: BoxShape.circle),
                child: Center(
                    child: RichText(
                        text: TextSpan(
                  style: TextStyle(
                    fontSize: 18,
                    color: isEvent ? Colors.black : Colors.white,
                  ),
                  text: "E",
                ))))));
  }

  Widget folderSelector() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButton<String>(
          iconSize: 20,
          value: dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.white),
          underline: Container(
            height: 2,
            color: Colors.white,
          ),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              dropdownValue = value!;
            });
          },
          items: folders.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: RichText(text: TextSpan(text: value)),
            );
          }).toList(),
        ));
  }

  Widget titleTextField() {
    return Flexible(
        child: TextFormField(
      onChanged: (value) {
        setState(() {
          title = value;
        });
      },
      initialValue: title,
      maxLines: 1,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'title',
      ),
    ));
  }

  Widget contentTextField() {
    return Expanded(
        child: TextFormField(
      onChanged: (value) {
        setState(() {
          content = value;
        });
      },
      initialValue: content,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
    ));
  }
}

Widget iconButton(Function() onPressed, Icon icon, double size) {
  return GestureDetector(
      onTap: onPressed,
      child: Container(width: size, height: size, child: Center(child: icon)));
}

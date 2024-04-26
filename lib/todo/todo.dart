import 'package:checkit/home/home.dart';
import '../constants/colors.dart';
import '../db/notes_db.dart';
import '../models/TaskClass.dart';
import '../home/bottomNavigationBar.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'addTaskScreen.dart';

class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  late List<Task> tasks;
  bool isLoading = false;
  // List<Task> tasks = [
  //   Task(title: "test", isEvent: false),
  //   Task(title: "test", isEvent: true),
  //   Task(title: "test", content: "hello every one ", isEvent: false),
  // ];
  bool isSelectedMood = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshTasks();
  }

  @override
  void dispose() {
    //NotesDatabase.instance.close();
    super.dispose();
  }

  Future refreshTasks() async {
    setState(() => isLoading = true);
    this.tasks = await NotesDatabase.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  List<int> getIds() {
    List<int> ids = [];
    if (!isLoading)
      for (int i = 0; i < tasks.length; i++) {
        if (tasks[i].isSelected && tasks[i].id != null) ids.add(tasks[i].id);
      }
    return ids;
  }

  AppBar buildAppBar(Icon midIcon, String date, Function() midFunction,
      {List<int> ids = const []}) {
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
        isSelectedMood
            ? IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                onPressed: () {
                  for (int i = 0; i < ids.length; i++) {
                    NotesDatabase.instance.delete(ids[i]);
                  }
                  setState(() {
                    isSelectedMood = false;
                  });

                  refreshTasks();
                },
              )
            : SizedBox(),
        IconButton(icon: midIcon, onPressed: midFunction),
        IconButton(
          icon: const Icon(Icons.account_circle_rounded),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        Icon(Icons.view_timeline),
        "",
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        ),
        ids: getIds(),
      ),
      body: isLoading
          ? CircularProgressIndicator()
          : Stack(
              children: [
                GridView(
                  padding: EdgeInsets.all(15),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        MediaQuery.of(context).size.height,
                  ),
                  children: [
                    ...tasks.map((item) {
                      return GestureDetector(
                          onLongPress: () {
                            setState(() {
                              item.isSelected = !item.isSelected;
                              isSelectedMood = true;
                            });
                          },
                          onTap: () {
                            setState(() {
                              if (isSelectedMood) {
                                item.isSelected = !item.isSelected;
                                isSelectedMood = selectedMoodCheck(tasks);
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddTaskScreen(
                                            editNum: item.id,
                                            title: item.title,
                                            content: item.content,
                                            isEvent: item.isEvent,
                                          )),
                                );
                              }
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(15),
                              color: item.isSelected
                                  ? Colors.blueAccent.shade700.withOpacity(0.35)
                                  : Colors.grey.shade900,
                              height: 555200,
                              width: 15555,
                              child: Column(
                                children: [
                                  Center(
                                    child: RichText(
                                        text: TextSpan(
                                      text: item.title,
                                      style: TextStyle(
                                        fontSize: 24,
                                        //color: Kpink,
                                        decoration: TextDecoration.underline,
                                      ),
                                    )),
                                  ),
                                  Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                          height: 255,
                                          child: RichText(
                                              text: TextSpan(
                                                  text: item.content)))),
                                ],
                              )));
                    }).toList(),
                  ],
                ),
                addButton(() {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddTaskScreen(
                              editNum: null,
                              title: "",
                              content: "",
                              isEvent: false,
                            )),
                  );
                }, Alignment.bottomCenter)
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNote();
          refreshTasks();
        },
      ),
    );
  }

  bool selectedMoodCheck(List<Task> data) {
    for (int i = 0; i < data.length; i++) if (data[i].isSelected) return true;
    return false;
  }

  Future addNote() async {
    final note = Task(title: "test", isEvent: true);
    await NotesDatabase.instance.create(note);
  }
}

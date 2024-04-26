import 'package:checkit/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive,
        overlays: [SystemUiOverlay.top]);
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: kpurple,
        accentColor: Colors.white,
        scaffoldBackgroundColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      title: 'CheckIt',
      home: Stack(alignment: AlignmentDirectional.topEnd, children: [
        Home(),
        Container(
            child: Text('בס"ד',
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.6), fontSize: 10)))
      ]),
    );
  }
}

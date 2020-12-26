import 'package:covid19/HomeScreen.dart';
import 'package:covid19/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Covid 19',
        theme: ThemeData(
            scaffoldBackgroundColor: kBackgroundColor,
            fontFamily: "Prompt",
            textTheme: TextTheme(bodyText1: TextStyle(color: kBodyTextColor))),
        home: HomeScreen());
  }
}


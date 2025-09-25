import 'package:doodle_note/pages/home.dart';
import 'package:doodle_note/pages/page.dart';
import 'package:doodle_note/pages/edit.dart';
import 'package:doodle_note/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    var logger = Logger();
    logger.d("empezo");

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'DoodleNote'),
      //home: NotePageScreen(),
      //home: EditPage()
      //home: SearchPage(),
    );
  }
}

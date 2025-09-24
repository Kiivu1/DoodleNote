import 'package:DoodleNote/pages/home.dart';
import 'package:DoodleNote/pages/page.dart';
import 'package:DoodleNote/pages/edit.dart';
import 'package:DoodleNote/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(const MyApp());
}


/*
  //ARREGLAR NAVEGACION

  NAVEGACION
  

  PAGINAS POR HACER

  HOME

  PAGE
  - Ttile card
  - Tag List

  (_25%) SEARCH
  (__0%) OPTIONS

  PAGE:
  - Lista de Tags
    - Usar chips dentro de un tag
  - Mejorar presentacion

*/


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

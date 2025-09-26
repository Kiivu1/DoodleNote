import 'package:doodle_note/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(const MyApp());
}


/*
  Tareas:


  - README (HECHO)
  - Icono y splashscreen      (HECHO)
  - Contextualizar textos (HECHOS)
  - Hacer mas imagenes de placeholder (HECHO)

  - IMPORTANTE SUBIR CAMBIOS A GITHUB
    git status
    git add .
    git status <- Confirmar si es que se agrego
    git commit -m 'Avance en la Aplicacion #3' <- ESTOY EN LA 3 VERSION
    git push origin main

  - Hacer el Video
    - Subtarea 1: crear presentacion
      - Subtarea 1-1: definir el problema
      - Subtarea 1-2: presentar la app
      - Subtarea 1-3: inspiraciones detras de esta
      - Subtarea 1-4: mostrar la app en accion (NOTA: NO MOSTRAR EL CODIGO)
    - Subtarea 2: grabar la pantalla, debido a que es la presentacion + pantalla
    - Subtarea 3: editar video para que este dentro del tiempo de 5 minutos
    - Subtarea 4: subir video a youtube

*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    var logger = Logger();
    logger.d("build compiladp");

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

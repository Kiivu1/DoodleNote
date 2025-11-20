import 'package:doodle_note/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:doodle_note/providers/config_data.dart'; 
import 'package:provider/provider.dart';
import 'package:doodle_note/services/preferences.dart'; 

void main() {
  runApp(const MyApp());
}

/*
  Tareas:

  - LOGIN
  - REGISTER


  - TRADUCCION:
    - español
    - ingles
  - CLOUD STORAGE:
  - subit notas(json) a la nube.
  - Pantalla de cloud storage
    - Acceder datos personales
    - guardar json en la nube
    - poder eliminar nota
    - acceder copia de json
  - 
*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var logger = Logger();
    logger.d("build compilado");

    return ChangeNotifierProvider(
      create: (context) => ConfigurationData(SharedPreferencesService()),
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'DoodleNote',
        home: MyHomePage(title: 'DoodleNote'),
      ),
    );

  }
}

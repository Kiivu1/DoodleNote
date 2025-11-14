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
  - Configuracion: Modo Oscuro (no importante, descartable)
  - Modo OScuro: usar Material (no importante, descartable)

  - HOME: Tomar todas las notas locales en el archivo.                                      (COMPLETADO)

  - Modificar PAGE: Hacer que todo sea un SliverList, incluyendo el encabezado (AppBar)     (COMPLETADO)
  - Modificar PAGE: Que funcione en base a la configuracion                                 (COMPLETADO)
  - Modificar PAGE: Que funcione en base a la Nota escogida                                 (COMPLETADO)
  - Modificar PAGE: Que elimine la nota                                                     (COMPLETADO)
  - Modificar PAGE: Que permite compartir la nota


  - Notas: Formato Json                           (COMPLETADO)
  - Imagenes: Usar camara y Album                 (COMPLETADO)
    - Guardar imagenes en carpeta local           (COMPLETADO)
    - Asociar imagenes a notas                    (COMPLETADO)

  Guardado Local:
  - creacion de una carpeta en el dispositivo     (COMPLETADO)
  - guardar notas en formatio json/ base de datos (COMPLETADO)
  - guardar imagenes tomadas del dispositivo      (COMPLETADO)
  - Leer datos y usarlos                          (COMPLETADO)

  - Modificar Search: Modo de busqueda funcional, que busque las notas
  - Modificar Search: que funcione en base a las notas guardadas

  - Modificar Edit: crear metodo que permite guardar datos en un formato                                  (COMPLETADO)
  - Modificar Edit: presentacion es muy grande, tal vez usar otra cosa que no sea floating actoin button  (COMPLETADO)

  - About: Crear pagina
  - About: hacer que cargue json con las preguntas prehechas
  - About: hacer que se permite enviar por correo las respuestas
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

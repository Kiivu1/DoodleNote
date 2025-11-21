import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:doodle_note/pages/home.dart';
import 'package:doodle_note/providers/config_data.dart'; 
import 'package:doodle_note/services/preferences.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'package:doodle_note/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:doodle_note/l10n/app_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
  } catch (e) {
      print("Firebase ya inicializado o error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var logger = Logger();
    logger.d("build compilado");

    return ChangeNotifierProvider(
      create: (context) => ConfigurationData(SharedPreferencesService()),
      
      // USAMOS CONSUMER PARA ESCUCHAR CAMBIOS DE IDIOMA
      child: Consumer<ConfigurationData>(
        builder: (context, config, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'DoodleNote',
            
            // --- CONFIGURACIÓN DE IDIOMA ---
            locale: config.appLocale, // Aquí se inyecta el idioma seleccionado (o null para auto)
            
            localizationsDelegates: const [
              AppLocalizations.delegate, // Tu archivo generado
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            
            supportedLocales: const [
              Locale('en'), // Inglés
              Locale('es'), // Español
            ],
            // -------------------------------

            home: const MyHomePage(title: 'DoodleNote'),
          );
        },
      ),
    );
  }
}
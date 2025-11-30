import 'dart:async'; 
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
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<InternetStatus> _internetListener;

  @override
  void initState() {
    super.initState();
    _startInternetListener();
  }

  @override
  void dispose() {
    _internetListener.cancel(); 
    super.dispose();
  }

  void _startInternetListener() {
    _internetListener = InternetConnection().onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          rootScaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          rootScaffoldMessengerKey.currentState?.showSnackBar(
            const SnackBar(
              content: Text("¡De nuevo en línea!"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            )
          );
          break;
        case InternetStatus.disconnected:
          rootScaffoldMessengerKey.currentState?.showSnackBar(
            const SnackBar(
              content: Text("Sin conexión a internet "),
              backgroundColor: Colors.redAccent,
              duration: Duration(days: 365), 
            )
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var logger = Logger();
    logger.d("build compilado");

    return ChangeNotifierProvider(
      create: (context) => ConfigurationData(SharedPreferencesService()),
      
      child: Consumer<ConfigurationData>(
        builder: (context, config, child) {
          return MaterialApp(
            scaffoldMessengerKey: rootScaffoldMessengerKey,

            debugShowCheckedModeBanner: false,
            title: 'DoodleNote',
            
            locale: config.appLocale, 
            
            localizationsDelegates: const [
              AppLocalizations.delegate, 
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
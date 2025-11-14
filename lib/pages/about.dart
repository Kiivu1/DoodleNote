import 'dart:convert';
import 'package:flutter/material.dart';
// Asegúrate de que las importaciones de provider y config_data sean correctas en tu proyecto
import 'package:provider/provider.dart';
import 'package:doodle_note/providers/config_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart' show rootBundle;

// *** Nota: He añadido un Mock de ConfigurationData y _devEmail para que el código sea ejecutable 
// si no tienes tu provider y email definidos, pero asumo que en tu proyecto sí existen. ***

const String _devEmail = 'ivanobandoa@gmail.com'; 
// -----------------------------------------------------------------------------------------
class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutCreator();
}

class _AboutCreator extends State<AboutPage> {
  // Configuración. Estos deben estar correctos y el Provider disponible
  double get fontTitleSize => context.watch<ConfigurationData>().sizeFontTitle.toDouble();
  double get fontTextSize => context.watch<ConfigurationData>().sizeFont.toDouble();
  String get fontFamilyText => context.watch<ConfigurationData>().FontFamily ?? '';

  final _formKey = GlobalKey<FormState>();
  String _userName = '';
  String _userEmail = '';

  Map<String, dynamic>? _feedbackData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  Future<void> _loadJsonData() async {
    setState((){
      _isLoading = true;
      _errorMessage = null;
      _feedbackData = null;
    });

    try {
      final String jsonString = await rootBundle.loadString('assets/preguntas.json');
      final Map<String, dynamic> decodedData = jsonDecode(jsonString);

      // Conversión de 'value' a double para el Slider
      if (decodedData.containsKey('uso')) {
        for (var question in decodedData['uso']) { 
          // Se asegura que 'value' sea un double para el Slider
          question['value'] = (question['value'] is int ? question['value'].toDouble() : question['value']); 
        }
      }
      // Inicialización de 'respuesta' en las otras secciones
      if (decodedData.containsKey('opinion')) {
        for (var question in decodedData['opinion']) { question['respuesta'] = ''; }
      }
      if (decodedData.containsKey('veredicto')) { 
        for (var question in decodedData['veredicto']) { question['respuesta'] = ''; }
      }

      setState(() {
        _feedbackData = decodedData;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar o parsear preguntas.json: $e'); 
      setState(() {
        _isLoading = false; 
        _errorMessage = 'No se pudo recargar el formulario, INtente de nuevo';
      });
    }
  }

  Future<void> _sendEmail() async {
    if (_feedbackData == null) { return; }

    // si se puede enviar
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String emailBody = 'Feedback de DoodleNote de: ${_userName.isEmpty ? 'Anónimo' : _userName} ($_userEmail)\n\n';      
      emailBody += '--- Seccion de Uso (Calificaciones) ---\n';
      
      //Formateo de datos
      if (_feedbackData!['uso'] is List) {
        for (var question in _feedbackData!['uso']) {
          emailBody += 'P: ${question['pregunta']}\n -> Calificación: ${question['value'].round()}\n';
        }
      }
      
      emailBody += '\n\n--- Seccion de Opinión (Textual) ---\n';
      if (_feedbackData!['opinion'] is List) {
        for (var question in _feedbackData!['opinion']) {
          emailBody += 'P: ${question['pregunta']}\n -> Respuesta: ${question['respuesta'].isEmpty ? 'No respondida' : question['respuesta']}\n';
        }
      }
      
      emailBody += '\n\n--- Veredicto Final ---\n';
      if (_feedbackData!['veredicto'] is List) {
        for (var question in _feedbackData!['veredicto']) {
          emailBody += 'P: ${question['pregunta']}\n -> Respuesta: ${question['respuesta'].isEmpty ? 'No respondida' : question['respuesta']}\n';
        }
      }
      
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: _devEmail,
        query: encodeQueryParameters(<String, String>{
          'subject': 'Feedback de Usuario - DoodleNote',
          'body': emailBody,
        }),
      );

      //enviar el email
      final bool launched = await launchUrl(emailLaunchUri, mode: LaunchMode.platformDefault);
      
      //si no se puede enviar, tirar mensaje de error
      if (!launched) {
         if (context.mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('No se pudo abrir la aplicación de correo. Copia el email: $_devEmail')),
           );
         }
      }
    }
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 10),
            Text(
              'Error al cargar el formulario de feedback.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTitleSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              _errorMessage ?? 'Error desconocido.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTextSize - 2, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadJsonData,
              icon: const Icon(Icons.refresh),
              label: const Text('Recargar Formulario'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor, 
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper para codificar los parámetros de la URL
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries.map((e) => 
      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
  }

  Widget _buildAboutContent(String title, String text){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text( title, style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTitleSize, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor), ),
          const Divider(),
          Text( text, style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTextSize), ),
        ],
      ),
    );
  }

  Widget _buildFeedbackForm() {
    if (_isLoading) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(30.0),
        child: CircularProgressIndicator(),
      ));
    }

    if (_errorMessage != null || _feedbackData == null) {
      return _buildErrorState();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.deepPurple[200], 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column( 
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Encuesta de Satisfacción y Feedback', textAlign: TextAlign.center, style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTitleSize + 4, fontWeight: FontWeight.bold), ),
                const Divider(height: 30, thickness: 2),

                Text( '0. Datos de Contacto', style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTitleSize, fontWeight: FontWeight.bold),),
                const SizedBox(height: 15),
                _buildContactFields(), 
                
                const Divider(height: 40),
                Text('1. Uso y Calificación',style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTitleSize, fontWeight: FontWeight.bold),),
                const SizedBox(height: 15),
                ..._feedbackData!['uso'].map<Widget>((question) { return _buildUsageSlider(question); }).toList(),

                const Divider(height: 40),
                Text( '2. Opiniones', style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTitleSize, fontWeight: FontWeight.bold), ),
                const SizedBox(height: 15),
                ..._feedbackData!['opinion'].map<Widget>((question) { return _buildTextInput(question, 3); }).toList(),
                Text( '3. Opinión final', style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTitleSize, fontWeight: FontWeight.bold), ),
                ..._feedbackData!['veredicto'].map<Widget>((question) { return _buildTextInput(question, 4); }).toList(),

                ElevatedButton.icon(
                  onPressed: _sendEmail,
                  icon: const Icon(Icons.send),
                  label: const Text('Enviar Feedback por Email'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Theme.of(context).primaryColor, 
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 40),
                OutlinedButton.icon(
                  onPressed: _loadJsonData,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Recargar Formulario'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                    foregroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 10),
                Text( 'Al presionar, se abrirá tu aplicación de correo para enviar los resultados a $_devEmail.', textAlign: TextAlign.center, style: TextStyle(fontSize: fontTextSize - 2, color: Colors.black54), ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactFields() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Tu Nombre (Opcional)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          onSaved: (value) => _userName = value ?? 'Anónimo',
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Tu Email',
            hintText: 'ejemplo@correo.com',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
          validator: (value) {
            if (value == null || value.isEmpty || !value.contains('@')) {
              return 'Por favor, ingresa un email válido.';
            }
            return null;
          },
          onSaved: (value) => _userEmail = value ?? 'No Proporcionado',
        ),
      ],
    );
  }
  
  // Widget para simplificar cada pregunta con Slider ('uso')
  Widget _buildUsageSlider(Map<String, dynamic> question) {
    String minDescription = question['min'].toString().split(':').last.trim();
    String maxDescription = question['max'].toString().split(':').last.trim();

    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text( 
            question['pregunta'],
            softWrap: true, 
            style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTextSize + 2, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          Slider(
            value: question['value'],
            min: 1,
            max: 5,
            divisions: 4,
            label: '${question['value'].round()}',
            onChanged: (double newValue) {
              setState(() {
                question['value'] = newValue;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Text(
                    minDescription, 
                    textAlign: TextAlign.left,
                    softWrap: true,
                    style: TextStyle(fontSize: fontTextSize - 2, color: Colors.black54),
                  ),
                ),
              ),
              
              Text(
                '${question['value'].round()}',
                style: TextStyle(fontSize: fontTextSize + 4, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    maxDescription, 
                    textAlign: TextAlign.right,
                    softWrap: true,
                    style: TextStyle(fontSize: fontTextSize - 2, color: Colors.black54),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextInput(Map<String, dynamic> question, int maxLines) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          Text(question['pregunta'], style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTextSize + 2, fontWeight: FontWeight.w600)),
          TextFormField(
            maxLines: maxLines, 
            decoration: InputDecoration(
              alignLabelWithHint: true,
              border: const OutlineInputBorder(),
              floatingLabelBehavior: FloatingLabelBehavior.always, 
            ),
            onChanged: (value) {
              question['respuesta'] = value;
            },
          )
        ],
      ), 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Acerca de y Feedback', style: TextStyle(color: Colors.white, fontFamily: fontFamilyText, fontSize: fontTitleSize), ),
      ),
      body: CustomScrollView(
        
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildAboutContent('Acerca de DoodleNote', 'DoodleNote es una aplicación de notas, móvil, la cual tiene como objetivo el poder facilitar la organización y la personalización de estas.' ),
                _buildAboutContent('Acerca del Desarrollador', 'Ivan Eduardo Obando Alcayaga, es un estudiante de la Carrera de videojuegos de la universidad de Talca.\nSu misión con esta app es el poder ayudar a la hora de creación de notas con un sistema que es más atractivo visualmente, además de poder ser personalizable.', ),
                const Divider(height: 20, thickness: 5, indent: 16, endIndent: 16),
                _buildFeedbackForm(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
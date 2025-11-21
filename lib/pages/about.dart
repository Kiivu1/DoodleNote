import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doodle_note/providers/config_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart' show rootBundle;
// Importamos localizaciones
import 'package:doodle_note/l10n/app_localizations.dart';

const String _devEmail = 'ivanobandoa@gmail.com'; 

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutCreator();
}

class _AboutCreator extends State<AboutPage> {
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

      if (decodedData.containsKey('uso')) {
        for (var question in decodedData['uso']) { 
          question['value'] = (question['value'] is int ? question['value'].toDouble() : question['value']); 
        }
      }
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
      print('Error al cargar preguntas.json: $e'); 
      setState(() {
        _isLoading = false; 
        // El mensaje se traduce en el build, aquí solo marcamos error
        _errorMessage = 'ERROR'; 
      });
    }
  }

  Future<void> _sendEmail() async {
    if (_feedbackData == null) return;
    
    // Obtenemos textos traducidos para el cuerpo del correo
    final l10n = AppLocalizations.of(context)!;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final String finalName = _userName.isEmpty ? l10n.anonymous : _userName;
      
      String emailBody = '${l10n.emailBodyHeader} $finalName ($_userEmail)\n\n';      
      
      emailBody += '${l10n.sectionUsageHeader}\n';
      if (_feedbackData!['uso'] is List) {
        for (var question in _feedbackData!['uso']) {
          emailBody += '${l10n.qLabel} ${question['pregunta']}\n -> ${l10n.rateLabel} ${question['value'].round()}\n';
        }
      }
      
      emailBody += '\n\n${l10n.sectionOpinionHeader}\n';
      if (_feedbackData!['opinion'] is List) {
        for (var question in _feedbackData!['opinion']) {
          emailBody += '${l10n.qLabel} ${question['pregunta']}\n -> ${l10n.aLabel} ${question['respuesta'].isEmpty ? l10n.notAnswered : question['respuesta']}\n';
        }
      }
      
      emailBody += '\n\n${l10n.sectionVerdictHeader}\n';
      if (_feedbackData!['veredicto'] is List) {
        for (var question in _feedbackData!['veredicto']) {
          emailBody += '${l10n.qLabel} ${question['pregunta']}\n -> ${l10n.aLabel} ${question['respuesta'].isEmpty ? l10n.notAnswered : question['respuesta']}\n';
        }
      }
      
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: _devEmail,
        query: encodeQueryParameters(<String, String>{
          'subject': l10n.emailSubject,
          'body': emailBody,
        }),
      );

      final bool launched = await launchUrl(emailLaunchUri, mode: LaunchMode.platformDefault);
      
      if (!launched) {
         if (context.mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(l10n.errorEmailOpen(_devEmail))),
           );
         }
      }
    }
  }

  Widget _buildErrorState() {
    final l10n = AppLocalizations.of(context)!;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 10),
            Text(
              l10n.errorLoading, // TRADUCIDO
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTitleSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              _errorMessage == 'ERROR' ? l10n.errorLoading : (_errorMessage ?? l10n.errorUnknown),
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTextSize - 2, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadJsonData,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.reloadForm), // TRADUCIDO
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
    final l10n = AppLocalizations.of(context)!; // Variable idiomas

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
                Text(l10n.feedbackTitle, textAlign: TextAlign.center, style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTitleSize + 4, fontWeight: FontWeight.bold), ),
                const Divider(height: 30, thickness: 2),

                Text(l10n.contactSection, style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTitleSize, fontWeight: FontWeight.bold),),
                const SizedBox(height: 15),
                _buildContactFields(), 
                
                const Divider(height: 40),
                Text(l10n.usageSection, style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTitleSize, fontWeight: FontWeight.bold),),
                const SizedBox(height: 15),
                ..._feedbackData!['uso'].map<Widget>((question) { return _buildUsageSlider(question); }).toList(),

                const Divider(height: 40),
                Text(l10n.opinionSection, style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTitleSize, fontWeight: FontWeight.bold), ),
                const SizedBox(height: 15),
                ..._feedbackData!['opinion'].map<Widget>((question) { return _buildTextInput(question, 3); }).toList(),
                Text(l10n.verdictSection, style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTitleSize, fontWeight: FontWeight.bold), ),
                ..._feedbackData!['veredicto'].map<Widget>((question) { return _buildTextInput(question, 4); }).toList(),

                ElevatedButton.icon(
                  onPressed: _sendEmail,
                  icon: const Icon(Icons.send),
                  label: Text(l10n.sendEmailBtn),
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
                  label: Text(l10n.reloadForm),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                    foregroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 10),
                // Usamos texto traducido con parámetro
                Text( l10n.emailDisclaimer(_devEmail), textAlign: TextAlign.center, style: TextStyle(fontSize: fontTextSize - 2, color: Colors.black54), ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactFields() {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: l10n.nameLabel, // TRADUCIDO
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.person),
          ),
          onSaved: (value) => _userName = value ?? l10n.anonymous,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: l10n.emailLabel, // TRADUCIDO
            hintText: l10n.emailHint,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.email),
          ),
          validator: (value) {
            if (value == null || value.isEmpty || !value.contains('@')) {
              return l10n.emailError; // TRADUCIDO
            }
            return null;
          },
          onSaved: (value) => _userEmail = value ?? l10n.notProvided,
        ),
      ],
    );
  }
  
  Widget _buildUsageSlider(Map<String, dynamic> question) {
    // Nota: min/max description siguen saliendo del JSON, si quieres traducirlos
    // tendrías que cambiar la estructura del JSON o hacer lógica compleja aquí.
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
            decoration: const InputDecoration(
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(l10n.aboutTitle, style: TextStyle(color: Colors.white, fontFamily: fontFamilyText, fontSize: fontTitleSize), ),
      ),
      body: CustomScrollView(
        
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildAboutContent(l10n.aboutAppTitle, l10n.aboutAppDesc),
                _buildAboutContent(l10n.aboutDevTitle, l10n.aboutDevDesc),
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
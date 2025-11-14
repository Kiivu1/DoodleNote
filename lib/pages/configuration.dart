import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:doodle_note/providers/config_data.dart';
import 'package:provider/provider.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key, required this.title});

  final String title;

  @override
  State<ConfigurationPage> createState() => _ConfigurationPage();
}

class _ConfigurationPage extends State<ConfigurationPage> {
  var log = Logger();



  @override
  Widget build(BuildContext context){

    final config = context.watch<ConfigurationData>();

    log.d("Widget did this: build");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 28, 1, 44)))),
      body: ListView(
        children: <Widget>[
          Divider(),
          ListTile(
            title: Text('Configuración de Fuente', style: TextStyle(fontFamily: config.FontFamily, fontSize: config.sizeFontTitle.toDouble(), fontWeight: FontWeight.bold)),
            subtitle: Text('Estos ajustes afectan el tamaño y tipo de fuente en toda la aplicación.', style: TextStyle(fontFamily: config.FontFamily, fontSize: config.sizeFont.toDouble())),
          ),
          Divider(),
          ListTile(
            title: Text('Tamaño de Texto: ${config.sizeFont}', style: TextStyle(fontFamily: config.FontFamily)),
            subtitle: Slider(
              value: config.sizeFont.toDouble(),
              min: 8,
              max: 20,
              divisions: 12,
              label: config.sizeFont.toString(),
              onChanged: (double value) {
                config.setFontSize(value.toInt());
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Tamaño de Titulo: ${config.sizeFontTitle}', style: TextStyle(fontFamily: config.FontFamily)),
            subtitle: Slider(
              value: config.sizeFontTitle.toDouble(),
              min: 16,
              max: 32,
              divisions: 16,
              label: config.sizeFontTitle.toString(),
              onChanged: (double value) {
                config.setFontTitleSize(value.toInt());
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Tipo de fuente'),
            subtitle: DropdownButton<int>(
              value: config.typeFont,
              items: [
                DropdownMenuItem(value: 0, child: Text('Normal')),
                DropdownMenuItem(value: 1, child: Text('Orbitron', style: TextStyle(fontFamily: 'Orbitron'))),
                DropdownMenuItem(value: 2, child: Text('Comic Relief', style: TextStyle(fontFamily: 'ComicRelief'))),
              ],
              onChanged: (int? value) {
                if (value != null) {
                  config.setFontType(value);
                }
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Diseño del menú',style: TextStyle(fontFamily: config.FontFamily)),
            subtitle: DropdownButton<int>(
              value: config.menuLayout,
              items: [
                DropdownMenuItem(value: 0, child: Text('Predeterminado')),
                DropdownMenuItem(value: 1, child: Text('Grande')),
                DropdownMenuItem(value: 2, child: Text('Compacto')),
              ],
              onChanged: (int? value) {
                if (value != null) {
                  config.setMenuLayout(value);
                }
              },
            ),
          ),
          Divider(),
          SwitchListTile(
              title: Text('Mostrar imagen en notas', style: TextStyle(fontFamily: config.FontFamily)),
              value: config.showImage,
              onChanged: (bool value) {
                config.setShowImage(value);
              },
          ),
          Divider(),
          SwitchListTile(
              title: Text('Mostrar fecha en notas', style: TextStyle(fontFamily: config.FontFamily)),
              value: config.showDate,
              onChanged: (bool value) {
                config.setShowDate(value);
              },
          ),
        ]
      )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:doodle_note/providers/config_data.dart';
import 'package:doodle_note/services/cloud_service.dart'; 
import 'package:doodle_note/l10n/app_localizations.dart';


class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key, required this.title});

  final String title;

  @override
  State<ConfigurationPage> createState() => _ConfigurationPage();
}

class _ConfigurationPage extends State<ConfigurationPage> {
  var log = Logger();
  
  final CloudService _cloudService = CloudService(); 
  
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
  }

  // --- FUNCIONES WRAPPER PARA LA UI ---

  Future<void> _handleSignIn() async {
    setState(() => _isSyncing = true);
    final user = await _cloudService.signInWithGoogle();
    setState(() => _isSyncing = false);
    
    if (user != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hola ${user.displayName}!'), backgroundColor: Colors.green)
      );
    }
  }

  Future<void> _handleSignOut() async {
    await _cloudService.signOut();
    setState((){}); // Actualizamos para que aparezca el botón de login
  }

  Future<void> _handleBackup() async {
    setState(() => _isSyncing = true);
    // Usamos el servicio centralizado
    bool success = await _cloudService.uploadNotes();
    setState(() => _isSyncing = false);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(success ? "Backup OK" : "Error"),
        backgroundColor: success ? Colors.teal : Colors.red,
      ));
    }
  }

  Future<void> _handleRestore() async {
    setState(() => _isSyncing = true);
    try {
      // Usamos el servicio centralizado
      int count = await _cloudService.restoreNotes();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$count notas restauradas"), backgroundColor: Colors.teal)
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red)
        );
      }
    } finally {
      setState(() => _isSyncing = false);
    }
  }

  // --- WIDGET DE LA NUBE ---

  Widget _cloudSyncCard(BuildContext context, ConfigurationData config) {
    final l10n = AppLocalizations.of(context)!; 
    final user = _cloudService.currentUser; // Obtenemos usuario del servicio
    final String? fontFamily = config.FontFamily;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.indigo[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(l10n.cloudSync, style: TextStyle(fontFamily: fontFamily, fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
             const SizedBox(height: 5),
             Text(l10n.cloudSyncDesc, style: TextStyle(fontFamily: fontFamily, fontSize: 12, color: Colors.grey[700])),
            const Divider(),
            const SizedBox(height: 10),

            _isSyncing
                ? const Center(child: CircularProgressIndicator())
                : user == null
                    ? Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.login),
                          label: Text(l10n.signInGoogle, style: TextStyle(fontFamily: fontFamily)),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
                          onPressed: _handleSignIn,
                        ),
                      )
                    : Column(
                        children: [
                          // Info Usuario
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                              child: user.photoURL == null ? const Icon(Icons.person) : null,
                            ),
                            title: Text(user.displayName ?? "Usuario", style: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.bold)),
                            subtitle: Text(user.email ?? "", style: TextStyle(fontFamily: fontFamily, fontSize: 12)),
                            trailing: IconButton(
                              icon: const Icon(Icons.logout, color: Colors.redAccent),
                              onPressed: _handleSignOut,
                            ),
                          ),
                          
                          // Switch AutoSync
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(l10n.autoSync, style: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.bold)),
                            subtitle: Text(l10n.autoSyncDesc, style: TextStyle(fontFamily: fontFamily, fontSize: 12)),
                            activeColor: Colors.green,
                            value: config.autoSync,
                            onChanged: (val) => config.setAutoSync(val),
                          ),

                          const Divider(),
                          
                          // Botones Manuales
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.cloud_upload),
                                  label: Text(l10n.uploadNow),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                                  onPressed: _handleBackup,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton.icon(
                                  icon: const Icon(Icons.cloud_download),
                                  label: Text(l10n.download),
                                  style: OutlinedButton.styleFrom(foregroundColor: Colors.deepPurple),
                                  onPressed: _handleRestore,
                                ),
                              ),
                            ],
                          )
                        ],
                      )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigurationData>();
    // Variable corta para usar traducciones fácilmente
    final l10n = AppLocalizations.of(context)!; 

    log.d("Widget did this: build");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(l10n.settingsTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 28, 1, 44))),
      ),
      body: ListView(
        children: <Widget>[
          const Divider(),
          
          // 1. SECCIÓN IDIOMA
          ListTile(
            title: Text(l10n.language, style: TextStyle(fontFamily: config.FontFamily, fontWeight: FontWeight.bold)),
            subtitle: DropdownButton<String>(
              value: config.appLocale?.languageCode ?? 'auto',
              isExpanded: true,
              underline: Container(height: 1, color: Colors.deepPurple),
              items: const [
                DropdownMenuItem(value: 'auto', child: Text('Automático (Sistema)')),
                DropdownMenuItem(value: 'es', child: Text('Español 🇪🇸')),
                DropdownMenuItem(value: 'en', child: Text('English 🇺🇸')),
              ],
              onChanged: (String? value) {
                if (value == 'auto') {
                  config.setAppLocale(null);
                } else {
                  config.setAppLocale(Locale(value!));
                }
              },
            ),
          ),
          const Divider(),

          // 2. FUENTES
          ListTile(
            title: Text(l10n.fontSettings, style: TextStyle(fontFamily: config.FontFamily, fontSize: config.sizeFontTitle.toDouble(), fontWeight: FontWeight.bold)),
            subtitle: Text(l10n.fontSettingsDesc, style: TextStyle(fontFamily: config.FontFamily, fontSize: config.sizeFont.toDouble())),
          ),
          const Divider(),
          
          ListTile(
            title: Text('${l10n.textSize}: ${config.sizeFont}', style: TextStyle(fontFamily: config.FontFamily)),
            subtitle: Slider(
              value: config.sizeFont.toDouble(),
              min: 8, max: 20, divisions: 12,
              label: config.sizeFont.toString(),
              onChanged: (double value) { config.setFontSize(value.toInt()); },
            ),
          ),
          
          ListTile(
            title: Text('${l10n.titleSize}: ${config.sizeFontTitle}', style: TextStyle(fontFamily: config.FontFamily)),
            subtitle: Slider(
              value: config.sizeFontTitle.toDouble(),
              min: 16, max: 32, divisions: 16,
              label: config.sizeFontTitle.toString(),
              onChanged: (double value) { config.setFontTitleSize(value.toInt()); },
            ),
          ),
          const Divider(),
          
          // 3. TIPO DE FUENTE
          ListTile(
            title: Text(l10n.fontType, style: TextStyle(fontFamily: config.FontFamily)),
            subtitle: DropdownButton<int>(
              value: config.typeFont,
              isExpanded: true,
              items: [
                DropdownMenuItem(value: 0, child: Text(l10n.normal)),
                DropdownMenuItem(value: 1, child: const Text('Orbitron', style: TextStyle(fontFamily: 'Orbitron'))),
                DropdownMenuItem(value: 2, child: const Text('Comic Relief', style: TextStyle(fontFamily: 'ComicRelief'))),
              ],
              onChanged: (int? value) { if (value != null) config.setFontType(value); },
            ),
          ),
          
          // 4. DISEÑO MENÚ
          ListTile(
            title: Text(l10n.menuLayout, style: TextStyle(fontFamily: config.FontFamily)),
            subtitle: DropdownButton<int>(
              value: config.menuLayout,
              isExpanded: true,
              items: [
                DropdownMenuItem(value: 0, child: Text(l10n.defaultOption)),
                DropdownMenuItem(value: 1, child: Text(l10n.large)),
                DropdownMenuItem(value: 2, child: Text(l10n.compact)),
              ],
              onChanged: (int? value) { if (value != null) config.setMenuLayout(value); },
            ),
          ),
          const Divider(),
          
          // 5. SWITCHES
          SwitchListTile(
            title: Text(l10n.showImage, style: TextStyle(fontFamily: config.FontFamily)),
            value: config.showImage,
            onChanged: (bool value) { config.setShowImage(value); },
          ),
          
          SwitchListTile(
            title: Text(l10n.showDate, style: TextStyle(fontFamily: config.FontFamily)),
            value: config.showDate,
            onChanged: (bool value) { config.setShowDate(value); },
          ),
          
          // 6. TARJETA DE NUBE
          const SizedBox(height: 20),
          _cloudSyncCard(context, config),
          const SizedBox(height: 50), 
        ],
      ),
    );
  }
}
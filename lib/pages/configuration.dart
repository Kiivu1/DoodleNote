import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:doodle_note/providers/config_data.dart';
import 'package:doodle_note/services/cloud_service.dart';
import 'package:doodle_note/l10n/app_localizations.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

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

  Future<void> _handleSignIn() async {
    bool hasNet = await InternetConnection().hasInternetAccess;
    if (!hasNet) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sin conexión a internet 📶'), backgroundColor: Colors.orange)
        );
      }
      return;
    }

    setState(() => _isSyncing = true);
    final user = await _cloudService.signInWithGoogle();

    if (!mounted) return;

    setState(() => _isSyncing = false);

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hola ${user.displayName}!'), backgroundColor: Colors.green)
      );
    }
  }

  Future<void> _handleSignOut() async {
    await _cloudService.signOut();
    if (mounted) {
      setState((){});
    }
  }

  Future<void> _handleBackup() async {
    setState(() => _isSyncing = true);

    bool success = await _cloudService.uploadNotes();

    if (!mounted) return;

    setState(() => _isSyncing = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Backup OK"), backgroundColor: Colors.teal)
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Revisa tu conexión"), backgroundColor: Colors.redAccent)
      );
    }
  }

  Future<void> _handleRestore() async {
    setState(() => _isSyncing = true);
    try {
      int count = await _cloudService.restoreNotes();

      if (!mounted) return;

      if (count == -1) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text("Sin internet. No se puede restaurar."), backgroundColor: Colors.orange)
         );
      } else if (count == 0) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text("No se encontraron notas o error."), backgroundColor: Colors.grey)
         );
      } else {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("¡$count notas restauradas!"), backgroundColor: Colors.teal)
         );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red)
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  Widget _cloudSyncCard(BuildContext context, ConfigurationData config) {
    final l10n = AppLocalizations.of(context)!;
    final user = _cloudService.currentUser;
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

                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(l10n.autoSync, style: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.bold)),
                            subtitle: Text(l10n.autoSyncDesc, style: TextStyle(fontFamily: fontFamily, fontSize: 12)),
                            activeColor: Colors.green,
                            value: config.autoSync,
                            onChanged: (val) => config.setAutoSync(val),
                          ),

                          const Divider(),

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

          const SizedBox(height: 20),
          _cloudSyncCard(context, config),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
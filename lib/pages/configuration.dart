import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:doodle_note/providers/config_data.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doodle_note/services/note_storage.dart'; 
import 'package:doodle_note/models/notes.dart';       

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key, required this.title});

  final String title;

  @override
  State<ConfigurationPage> createState() => _ConfigurationPage();
}

class _ConfigurationPage extends State<ConfigurationPage> {
  var log = Logger();
  final NoteStorage _storage = NoteStorage(); 

  // Variables de Estado para Auth
  User? _user;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  // --- AUTENTICACIÓN ---

  void _checkCurrentUser() {
    setState(() {
      _user = FirebaseAuth.instance.currentUser;
    });
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isSyncing = true);
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        setState(() => _isSyncing = false);
        return; 
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      setState(() {
        _user = userCredential.user;
        _isSyncing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bienvenido ${_user?.displayName ?? "Usuario"}'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      setState(() => _isSyncing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error Login: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    setState(() => _user = null);
  }

  // --- BACKUP / RESTORE (SOLO TEXTO) ---

  Future<void> _backupToCloud() async {
    if (_user == null) return;
    setState(() => _isSyncing = true);

    try {
      // 1. Leer notas locales
      List<Note> localNotes = await _storage.readAllNotes();

      if (localNotes.isEmpty) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No hay notas para guardar.')));
        setState(() => _isSyncing = false);
        return;
      }

      // 2. Convertir a JSON
      final notesJson = localNotes.map((n) => n.toJson()).toList();

      // 3. Subir a Firestore (Sobrescribe lo anterior)
      await FirebaseFirestore.instance.collection('user_data').doc(_user!.uid).set({
        'notes_backup': notesJson,
        'lastBackup': FieldValue.serverTimestamp(),
        'device': 'android',
        'note_count': localNotes.length,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Respaldo de notas guardado! ☁️'), backgroundColor: Colors.teal),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al subir: $e'), backgroundColor: Colors.red));
    } finally {
      setState(() => _isSyncing = false);
    }
  }

  Future<void> _restoreFromCloud() async {
    if (_user == null) return;
    setState(() => _isSyncing = true);

    try {
      // 1. Descargar de Firestore
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('user_data').doc(_user!.uid).get();

      if (!doc.exists || doc.data() == null) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No hay copia de seguridad en la nube.')));
        setState(() => _isSyncing = false);
        return;
      }

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List<dynamic> notesJson = data['notes_backup'] ?? [];

      // 2. Convertir JSON a Objetos Note
      List<Note> cloudNotes = notesJson.map((json) => Note.fromJson(json)).toList();

      // 3. Guardar en local (Necesita saveAllNotes en note_storage.dart)
      await _storage.saveAllNotes(cloudNotes); 

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('¡Restauradas ${cloudNotes.length} notas!'), backgroundColor: Colors.teal),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al restaurar: $e'), backgroundColor: Colors.red));
    } finally {
      setState(() => _isSyncing = false);
    }
  }

  // --- UI WIDGETS ---

  // En lib/pages/configuration.dart

  Widget _cloudSyncCard(ConfigurationData config) { // <--- Recibimos 'config' para leer el estado
    final user = FirebaseAuth.instance.currentUser;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.indigo[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text("Sincronización en la Nube", style: TextStyle(fontFamily: config.FontFamily, fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
             const SizedBox(height: 5),
             Text("Respalda tus textos (sin imágenes).", style: TextStyle(fontFamily: config.FontFamily, fontSize: 12, color: Colors.grey[700])),
            const Divider(),
            const SizedBox(height: 10),

            _isSyncing
                ? const Center(child: CircularProgressIndicator())
                : user == null
                    ? Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.login),
                          label: Text("Iniciar sesión con Google", style: TextStyle(fontFamily: config.FontFamily)),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
                          onPressed: _signInWithGoogle,
                        ),
                      )
                    : Column(
                        children: [
                          // 1. INFORMACIÓN DEL USUARIO
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                              child: user.photoURL == null ? const Icon(Icons.person) : null,
                            ),
                            title: Text(user.displayName ?? "Usuario", style: TextStyle(fontFamily: config.FontFamily, fontWeight: FontWeight.bold)),
                            subtitle: Text(user.email ?? "", style: TextStyle(fontFamily: config.FontFamily, fontSize: 12)),
                            trailing: IconButton(
                              icon: const Icon(Icons.logout, color: Colors.redAccent),
                              onPressed: _signOut,
                            ),
                          ),
                          
                          const Divider(),

                          // 2. AQUÍ ESTÁ TU BOTÓN DE ACTIVAR/DESACTIVAR AUTOMÁTICO ⬇️
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text("Sincronización Automática", style: TextStyle(fontFamily: config.FontFamily, fontWeight: FontWeight.bold)),
                            subtitle: Text("Subir cambios al guardar o borrar", style: TextStyle(fontFamily: config.FontFamily, fontSize: 12)),
                            activeColor: Colors.green, // Color cuando está encendido
                            value: config.autoSync,    // Lee el valor guardado
                            onChanged: (bool value) {
                              // Guarda el cambio y actualiza la app
                              config.setAutoSync(value); 
                            },
                          ),
                          // --------------------------------------------------------

                          const SizedBox(height: 10),
                          
                          // 3. BOTONES MANUALES (Siempre útiles)
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.cloud_upload),
                                  label: const Text("Subir Ahora"),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                                  onPressed: _isSyncing ? null : _backupToCloud,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton.icon(
                                  icon: const Icon(Icons.cloud_download),
                                  label: const Text("Restaurar"),
                                  style: OutlinedButton.styleFrom(foregroundColor: Colors.deepPurple),
                                  onPressed: _isSyncing ? null : _restoreFromCloud,
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

    log.d("Widget did this: build");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 28, 1, 44))),
      ),
      body: ListView(
        children: <Widget>[
          // --- TU CONFIGURACIÓN EXISTENTE ---
          const Divider(),
          ListTile(
            title: Text('Configuración de Fuente', style: TextStyle(fontFamily: config.FontFamily, fontSize: config.sizeFontTitle.toDouble(), fontWeight: FontWeight.bold)),
            subtitle: Text('Estos ajustes afectan el tamaño y tipo de fuente en toda la aplicación.', style: TextStyle(fontFamily: config.FontFamily, fontSize: config.sizeFont.toDouble())),
          ),
          const Divider(),
          ListTile(
            title: Text('Tamaño de Texto: ${config.sizeFont}', style: TextStyle(fontFamily: config.FontFamily)),
            subtitle: Slider(
              value: config.sizeFont.toDouble(),
              min: 8, max: 20, divisions: 12,
              label: config.sizeFont.toString(),
              onChanged: (double value) { config.setFontSize(value.toInt()); },
            ),
          ),
          ListTile(
            title: Text('Tamaño de Titulo: ${config.sizeFontTitle}', style: TextStyle(fontFamily: config.FontFamily)),
            subtitle: Slider(
              value: config.sizeFontTitle.toDouble(),
              min: 16, max: 32, divisions: 16,
              label: config.sizeFontTitle.toString(),
              onChanged: (double value) { config.setFontTitleSize(value.toInt()); },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Tipo de fuente'),
            subtitle: DropdownButton<int>(
              value: config.typeFont,
              items: const [
                DropdownMenuItem(value: 0, child: Text('Normal')),
                DropdownMenuItem(value: 1, child: Text('Orbitron', style: TextStyle(fontFamily: 'Orbitron'))),
                DropdownMenuItem(value: 2, child: Text('Comic Relief', style: TextStyle(fontFamily: 'ComicRelief'))),
              ],
              onChanged: (int? value) { if (value != null) config.setFontType(value); },
            ),
          ),
          ListTile(
            title: Text('Diseño del menú', style: TextStyle(fontFamily: config.FontFamily)),
            subtitle: DropdownButton<int>(
              value: config.menuLayout,
              items: const [
                DropdownMenuItem(value: 0, child: Text('Predeterminado')),
                DropdownMenuItem(value: 1, child: Text('Grande')),
                DropdownMenuItem(value: 2, child: Text('Compacto')),
              ],
              onChanged: (int? value) { if (value != null) config.setMenuLayout(value); },
            ),
          ),
          const Divider(),
          SwitchListTile(
            title: Text('Mostrar imagen en notas', style: TextStyle(fontFamily: config.FontFamily)),
            value: config.showImage,
            onChanged: (bool value) { config.setShowImage(value); },
          ),
          SwitchListTile(
            title: Text('Mostrar fecha en notas', style: TextStyle(fontFamily: config.FontFamily)),
            value: config.showDate,
            onChanged: (bool value) { config.setShowDate(value); },
          ),
          
          // --- NUEVA TARJETA DE CLOUD ---
          const SizedBox(height: 20),
          _cloudSyncCard(config),
          const SizedBox(height: 50), 
        ],
      ),
    );
  }
}
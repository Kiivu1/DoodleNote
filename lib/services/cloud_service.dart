import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doodle_note/services/note_storage.dart';
import 'package:doodle_note/models/notes.dart';

class CloudService {
  // Singleton para usar la misma instancia siempre
  static final CloudService _instance = CloudService._internal();
  factory CloudService() => _instance;
  CloudService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NoteStorage _storage = NoteStorage();

  User? get currentUser => _auth.currentUser;

  // --- AUTENTICACIÓN ---
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return (await _auth.signInWithCredential(credential)).user;
    } catch (e) {
      print("Error Auth: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }

  // --- MÉTODO DE SUBIDA (Manual o Automático) ---
  Future<bool> uploadNotes() async {
    final user = _auth.currentUser;
    if (user == null) return false; // Si no hay usuario, no hacemos nada

    try {
      // 1. Leemos todas las notas locales
      List<Note> localNotes = await _storage.readAllNotes();
      
      // 2. Las convertimos a JSON
      final notesJson = localNotes.map((n) => n.toJson()).toList();

      // 3. Subimos a Firestore (Sobrescribe lo anterior para mantener el espejo exacto)
      await FirebaseFirestore.instance.collection('user_data').doc(user.uid).set({
        'notes_backup': notesJson,
        'lastBackup': FieldValue.serverTimestamp(),
        'device': 'android',
        'count': localNotes.length
      });
      
      print("☁️ Nube actualizada correctamente");
      return true;
    } catch (e) {
      print("☁️ Error subiendo a la nube: $e");
      return false;
    }
  }

  // --- MÉTODO DE BAJADA (Restaurar) ---
  Future<int> restoreNotes() async {
    final user = _auth.currentUser;
    if (user == null) return 0;

    try {
      final doc = await FirebaseFirestore.instance.collection('user_data').doc(user.uid).get();
      
      if (!doc.exists || doc.data() == null) return 0;

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List<dynamic> list = data['notes_backup'] ?? [];
      
      List<Note> cloudNotes = list.map((j) => Note.fromJson(j)).toList();
    
      await _storage.saveAllNotes(cloudNotes);
      
      return cloudNotes.length;
    } catch (e) {
      print("Error restaurando: $e");
      rethrow;
    }
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doodle_note/services/note_storage.dart';
import 'package:doodle_note/models/notes.dart';

class CloudService {
  static final CloudService _instance = CloudService._internal();
  factory CloudService() => _instance;
  CloudService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NoteStorage _storage = NoteStorage();

  User? get currentUser => _auth.currentUser;

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

  Future<bool> uploadNotes() async {
    final user = _auth.currentUser;
    if (user == null) return false; 

    try {
      List<Note> allLocalNotes = await _storage.readAllNotes();
      
      List<Note> starredNotes = allLocalNotes.where((n) => n.isStarred).toList();

      final notesJson = starredNotes.map((n) => n.toJson()).toList();

      await FirebaseFirestore.instance.collection('user_data').doc(user.uid).set({
        'notes_backup': notesJson,
        'lastBackup': FieldValue.serverTimestamp(),
        'device': 'android',
        'count': starredNotes.length 
      });
      
      print("☁️ Nube actualizada: ${starredNotes.length} notas favoritas guardadas.");
      return true;
    } catch (e) {
      print("☁️ Error subiendo a la nube: $e");
      return false;
    }
  }
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
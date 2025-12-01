import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:doodle_note/models/notes.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class NoteStorage {

  static const String _folderName = 'DoodleNote';
  static const String _notesSubFolder = 'Notes';
  static const String _imageSubFolder = 'Images';

  Future<String> _localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<Directory> get _localNotesDirectory async {
    final path = await _localPath();
    final directory = Directory(p.join(path, _folderName, _notesSubFolder));
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  Future<Directory> get _localImagesDirectory async {
    final path = await _localPath();
    final directory = Directory(p.join(path, _folderName, _imageSubFolder));
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }


  Future<void> saveNote(Note note) async {
    final notesDirectory = await _localNotesDirectory;
    final String fileName = '${note.id}.json'; 
    final File file = File(p.join(notesDirectory.path, fileName));

    String? newImagePath = note.imagePath;

    if (newImagePath != null && !newImagePath.startsWith('assets/')) {
      final File originalFile = File(newImagePath);
      
      if (await originalFile.exists()) {
        final imageDir = await _localImagesDirectory;
        final String imageExtension = p.extension(newImagePath);
        
        if (!p.isWithin(imageDir.path, newImagePath)) {
            final String newImageFileName = '${note.id}_${DateTime.now().microsecondsSinceEpoch}$imageExtension';
            final String persistentFilePath = p.join(imageDir.path, newImageFileName);

            await originalFile.copy(persistentFilePath);
            newImagePath = persistentFilePath; 

            try {
              final File fileToSave = File(persistentFilePath);
              final Uint8List bytes = await fileToSave.readAsBytes();
              
              await ImageGallerySaverPlus.saveImage(
                bytes, 
                name: 'DoodleNote_${note.noteTitle}', 
              );
            } catch (e) {
              print('Error saving image to gallery: $e');
            }
        }
      }
    }

    final Note noteToSave = Note(
      id: note.id,
      noteTitle: note.noteTitle,
      imagePath: newImagePath, 
      creationDate: note.creationDate,
      editCreationDate: note.editCreationDate,
      
      isStarred: note.isStarred, 
      
      tags: note.tags,
      tabs: note.tabs,
    );

    final jsonString = jsonEncode(noteToSave.toJson());
    await file.writeAsString(jsonString);
  }

  Future<void> deleteNote(Note note) async {
    try {
      final notesDirectory = await _localNotesDirectory;
      final String fileName = '${note.id}.json';
      final File noteFile = File(p.join(notesDirectory.path, fileName));
      
      if (await noteFile.exists()) {
        await noteFile.delete();
        print('Note JSON deleted: ${noteFile.path}');
      }

      if (note.imagePath != null && !note.imagePath!.startsWith('assets/')) {
        final File imageFile = File(note.imagePath!);
        if (await imageFile.exists()) {
          await imageFile.delete();
          print('Note Image deleted: ${imageFile.path}');
        }
      }
    } catch (e) {
      print('Error deleting note with ID ${note.id}: $e');
      rethrow;
    }
  }

  Future<List<Note>> readAllNotes() async {
    final directory = await _localNotesDirectory; 
    final List<Note> notes = [];

    if (await directory.exists()) {
      final files = directory.listSync().whereType<File>();

      for (final file in files) {
        if (file.path.endsWith('.json')) {
          try {
            final jsonString = await file.readAsString();
            final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
            final note = Note.fromJson(jsonMap);
            notes.add(note);
          } catch (e) {
            print('Error leyendo archivo ${file.path}: $e');
          }
        }
      }
    }

    notes.sort((a, b) {
      if (a.isStarred && !b.isStarred) return -1; 
      if (!a.isStarred && b.isStarred) return 1;  
      return b.editCreationDate.compareTo(a.editCreationDate);
    });

    return notes;
  }

  Future<void> deleteAllNotes() async {
    final directory = await _localNotesDirectory;
    if (await directory.exists()) {
      final files = directory.listSync().whereType<File>();
      for (final file in files) {
        if (file.path.endsWith('.json')) {
          await file.delete();
        }
      }
    }
  }

  Future<void> saveAllNotes(List<Note> notes) async {
    await deleteAllNotes();

    final directory = await _localNotesDirectory;

    for (var note in notes) {
      final String fileName = '${note.id}.json';
      final File file = File(p.join(directory.path, fileName));
      
      
      await file.writeAsString(jsonEncode(note.toJson()));
    }
  }
}
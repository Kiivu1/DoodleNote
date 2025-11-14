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

  Future<String> _localPath() async{
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Obtener directorio para las notas, JSON
  Future<Directory> get _localNotesDirectory async{
    final path = await _localPath();
    final directory = Directory(p.join(path, _folderName, _notesSubFolder));
    if(!await directory.exists()){
      await directory.create(recursive: true);
    }
    return directory;
  }

  // Obtener directorio de imagenes
  Future<Directory> get _localImagesDirectory async {
    final path = await _localPath();
    //    /Documents/DoodleNote/Images
    final directory = Directory(p.join(path, _folderName, _imageSubFolder));
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  // GUARDAR------------------------------
  Future<void> saveNote(Note note) async{
    // 1. Set up JSON file destination (Corrected to use _localNotesDirectory and .json extension)
    final notesDirectory = await _localNotesDirectory;
    final String fileName = '${note.id}.json'; 
    final File file = File(p.join(notesDirectory.path, fileName));

    String? newImagePath = note.imagePath;

    // 2. Handle Image: Copy to persistent app storage & Save to Gallery
    if (newImagePath != null && !newImagePath.startsWith('assets/')) {
      final File originalFile = File(newImagePath);
      final imageDir = await _localImagesDirectory;
      final String imageExtension = p.extension(newImagePath);
      
      // Create a new unique file name for persistent storage
      final String newImageFileName = '${note.id}_${DateTime.now().microsecondsSinceEpoch}$imageExtension';
      final String persistentFilePath = p.join(imageDir.path, newImageFileName);

      // A. Copy image to persistent app storage
      await originalFile.copy(persistentFilePath);
      newImagePath = persistentFilePath; // Update the path to the persistent location

      // B. Save a copy of the image to the public gallery
      try {
        // Read bytes from the newly copied persistent file
        final File fileToSave = File(persistentFilePath);
        final Uint8List bytes = await fileToSave.readAsBytes();
        
        await ImageGallerySaverPlus.saveImage(
          bytes, 
          name: note.noteTitle, 
        );
      } catch (e) {
        print('Error saving image to gallery: $e');
      }
    }

    // 3. Save JSON Note data
    final Note noteToSave = Note(
      id: note.id,
      noteTitle: note.noteTitle,
      imagePath: newImagePath, // Use the persistent path
      creationDate: note.creationDate,
      editCreationDate: note.editCreationDate,
      tags: note.tags,
      tabs: note.tabs,
    );

    final jsonString = jsonEncode(noteToSave.toJson());
    await file.writeAsString(jsonString);
  }

  Future<void> deleteNote(Note note) async{
    try {
    
    //Borrar la nota
    final notesDirectory = await _localNotesDirectory;
    final String fileName = '${note.id}.json';
    final File noteFile = File(p.join(notesDirectory.path, fileName));
    
    if (await noteFile.exists()) {
      await noteFile.delete();
      print('Note JSON deleted: ${noteFile.path}');
    }

    //Borrar imagen
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

    final files = directory.listSync().whereType<File>();

    for (final file in files){
      if(file.path.endsWith('.json')){
        try{
          final jsonString = await file.readAsString();
          final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
          final note = Note.fromJson(jsonMap);
          notes.add(note);
        } catch (e){
          print('Error leyendo archivo ${file.path}: $e');
        }
      }
    }

    notes.sort((a,b)=> b.editCreationDate.compareTo(a.editCreationDate));
    return notes;
  }
}
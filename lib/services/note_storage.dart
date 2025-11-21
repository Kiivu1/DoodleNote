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

  // Obtener directorio para las notas (JSON)
  Future<Directory> get _localNotesDirectory async {
    final path = await _localPath();
    final directory = Directory(p.join(path, _folderName, _notesSubFolder));
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  // Obtener directorio de imágenes
  Future<Directory> get _localImagesDirectory async {
    final path = await _localPath();
    final directory = Directory(p.join(path, _folderName, _imageSubFolder));
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  // --- 1. GUARDAR NOTA INDIVIDUAL (Uso normal de la App) ---
  Future<void> saveNote(Note note) async {
    final notesDirectory = await _localNotesDirectory;
    final String fileName = '${note.id}.json'; 
    final File file = File(p.join(notesDirectory.path, fileName));

    String? newImagePath = note.imagePath;

    // Lógica de Imágenes: Copiar a carpeta persistente y guardar en Galería
    if (newImagePath != null && !newImagePath.startsWith('assets/')) {
      final File originalFile = File(newImagePath);
      
      // Verificamos que el archivo original exista antes de copiar
      if (await originalFile.exists()) {
        final imageDir = await _localImagesDirectory;
        final String imageExtension = p.extension(newImagePath);
        
        // Si la imagen ya está en nuestra carpeta, no la duplicamos innecesariamente
        // (A menos que quieras guardar copias nuevas al editar)
        if (!p.isWithin(imageDir.path, newImagePath)) {
            final String newImageFileName = '${note.id}_${DateTime.now().microsecondsSinceEpoch}$imageExtension';
            final String persistentFilePath = p.join(imageDir.path, newImageFileName);

            // A. Copiar imagen a almacenamiento de la app
            await originalFile.copy(persistentFilePath);
            newImagePath = persistentFilePath; 

            // B. Guardar copia en la galería pública
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

    // Guardar JSON
    final Note noteToSave = Note(
      id: note.id,
      noteTitle: note.noteTitle,
      imagePath: newImagePath, 
      creationDate: note.creationDate,
      editCreationDate: note.editCreationDate,
      tags: note.tags,
      tabs: note.tabs,
    );

    final jsonString = jsonEncode(noteToSave.toJson());
    await file.writeAsString(jsonString);
  }

  // --- 2. ELIMINAR NOTA ---
  Future<void> deleteNote(Note note) async {
    try {
      // Borrar JSON
      final notesDirectory = await _localNotesDirectory;
      final String fileName = '${note.id}.json';
      final File noteFile = File(p.join(notesDirectory.path, fileName));
      
      if (await noteFile.exists()) {
        await noteFile.delete();
        print('Note JSON deleted: ${noteFile.path}');
      }

      // Borrar imagen asociada (si es local)
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

  // --- 3. LEER TODAS LAS NOTAS ---
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

    notes.sort((a, b) => b.editCreationDate.compareTo(a.editCreationDate));
    return notes;
  }

  // ---------------------------------------------------------
  // MÉTODOS NUEVOS PARA CLOUD SYNC (Necesarios para ConfigurationPage)
  // ---------------------------------------------------------

  // 4. Borrar todas las notas locales (Limpieza antes de restaurar)
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

  // 5. Guardar la lista completa que viene de Firebase
  Future<void> saveAllNotes(List<Note> notes) async {
    // Limpiamos primero para evitar duplicados o notas viejas
    await deleteAllNotes();

    final directory = await _localNotesDirectory;

    for (var note in notes) {
      final String fileName = '${note.id}.json';
      final File file = File(p.join(directory.path, fileName));
      
      // Escribimos el archivo individualmente tal cual viene de la nube
      await file.writeAsString(jsonEncode(note.toJson()));
    }
  }
}
import 'package:doodle_note/services/note_storage.dart';
import 'package:flutter/material.dart';
import 'package:doodle_note/pages/edit.dart';
import 'package:provider/provider.dart';
import 'package:doodle_note/providers/config_data.dart';
import 'package:doodle_note/models/notes.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';

class NotePageScreen extends StatefulWidget {
  const NotePageScreen({super.key, required this.notaPage});

  final Note notaPage;

  @override
  State<NotePageScreen> createState() => _NotePageScreen();
}

class _NotePageScreen extends State<NotePageScreen> {
  final NoteStorage _storage = NoteStorage();

  late Note _currentNote;

  @override
  void initState(){
    super.initState();
    _currentNote = widget.notaPage;
  }

  double get fontTitleSize => context.watch<ConfigurationData>().sizeFontTitle.toDouble();
  double get fontTextSize => context.watch<ConfigurationData>().sizeFont.toDouble();
  bool get imageVisible => context.watch<ConfigurationData>().showImage;
  bool get dateVisible => context.watch<ConfigurationData>().showDate;
  String get fontFamilyText => context.watch<ConfigurationData>().FontFamily ?? '';

  void _goToEdit() async { 
  final result = await Navigator.push(
    context, 
    MaterialPageRoute(builder: (context) => EditPage(notaEdited: _currentNote)),
  );

  if (result != null && result is Note) {
    if (context.mounted) {
      setState(() {
        _currentNote = result; // _currentNote is updated with the new content
      });
    }
  }
}

  void _deleteNote() async {
    try {
      await _storage.deleteNote(_currentNote);
      Navigator.pop(context, true); 
    } catch (e){
      print('Error deleting note: $e');
      Navigator.pop(context, false); 
    }
  }

  void _shareNote() async {
    final note = _currentNote; //Nota actual

    //Formatear mensaje
    StringBuffer shareText = StringBuffer();
    shareText.writeln('${note.noteTitle}');
    shareText.writeln('');
    shareText.writeln('--------------------------------');
    shareText.writeln('Creada: ${note.creationDate}');
    shareText.writeln('Editado en: ${note.editCreationDate}');
    shareText.writeln('');
    if (note.tags != null && note.tags!.isNotEmpty) {
      shareText.writeln('Tags: ${note.tags!.join(', ')}');
      shareText.writeln('-----------------------------------');
    }
    shareText.writeln('');
    if (note.tabs != null) {
      for (var tab in note.tabs!) {
        shareText.writeln('\n-- ${tab.title.toUpperCase()} --');
        shareText.writeln(tab.body);
      }
    }

    List<XFile> filesToShare = [];      //Imagen
    String textContent = shareText.toString();
    String subject = 'Doodle Note: ${note.noteTitle}';
    
    if (note.imagePath != null && !note.imagePath!.startsWith('assets/')) {
      final imageFile = File(note.imagePath!);
      if (await imageFile.exists()) {
        filesToShare.add(XFile(note.imagePath!));
        subject = 'Doodle Note: ${note.noteTitle} (con Imagen)';
      }
    }

    //Compartir
    try {
      if (filesToShare.isNotEmpty) {
        await Share.shareXFiles( filesToShare, text: textContent, subject: subject, );
      }
      else {
        await Share.share( textContent, subject: subject, );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo compartir la nota: $e')),
        );
      }
    }
  }
  
  SliverToBoxAdapter _tabContentExpandable(title, body){
    final double space = 2;
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(6),
        child: Card(
          margin: EdgeInsets.all(space),
          color: const Color.fromARGB(255, 165, 142, 219),
          child: ExpansionTile(
            initiallyExpanded: false,
            tilePadding: EdgeInsets.all(8.0),
            title: Text(
              title,
              style: TextStyle(fontFamily: fontFamilyText,fontSize: fontTitleSize, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), 
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text( body, style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTextSize, color: Colors.black87), ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  SliverToBoxAdapter _tagContent(List<String> tags) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(6),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          alignment: WrapAlignment.center,
          children: tags.map((tag) => Chip(
                avatar: Icon(Icons.tag),
                label: Text(tag, style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTextSize, color: Colors.black)),
                backgroundColor: Colors.purple[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              )).toList(),
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.purple[50],
            title: Text('Delete DoodleNote', style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTitleSize)),
            content: Text('Do you want to delete this Note?', style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTextSize)),
            actions: <Widget>[
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                  _deleteNote();
                } ,
                child: Text('Delete')
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel')
              )
            ],
          );
        });
  }

  Widget _footerButtons() {
    TextStyle buttonTextStyle = TextStyle(
      fontSize: fontTextSize,
      fontWeight: FontWeight.bold,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: TextButton.icon(
            onPressed: _showDialog,
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            label: const Text('Delete', style: TextStyle(color: Colors.white)),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: buttonTextStyle,
            ),
          ),
        ),
        VerticalDivider(),
        Expanded(
          flex: 2,
          child: TextButton.icon(
            onPressed: _goToEdit,
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text('Edit', style: TextStyle(color: Colors.white)),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: buttonTextStyle,
            ),
          ),
        ),
        VerticalDivider(),
        Expanded(
          child: TextButton.icon(
            onPressed: _shareNote,
            icon: const Icon(Icons.share, color: Colors.white),
            label: const Text('Share', style: TextStyle(color: Colors.white)),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: buttonTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  SliverToBoxAdapter _titleNote(String? imagePath, String title){
    ImageProvider? imageProvider;

    if (imagePath != null) {
      if (imagePath.startsWith('assets/')) {
        imageProvider = AssetImage(imagePath);
      } else if (File(imagePath).existsSync()) {
        imageProvider = FileImage(File(imagePath));
      }
    }

    // Fallback to a default asset if no image is found or path is null
    if (imageProvider == null) {
      imageProvider = const AssetImage('assets/images/DNImage1.png');
    }

    return SliverToBoxAdapter(
      child: Padding(padding: const EdgeInsets.all(3),
        child: Card(
          margin: EdgeInsets.all(6),
          color: const Color.fromARGB(255, 194, 175, 238),
          child: Column(
            children: [
              if (imageVisible) // Apply visibility check here
              Padding(
                padding: EdgeInsets.all(6),
                child: Container(
                  width: double.infinity,
                  height: 250, // Added a fixed height for better layout
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    // CORRECTED: Use Image widget with the determined ImageProvider
                    child: Image(image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
              ),
              // Title Text
              Padding(
                padding: EdgeInsets.all(12),
                child: Text( title, style: TextStyle(fontFamily: fontFamilyText , fontSize: fontTitleSize, fontWeight: FontWeight.bold, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        )
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 53, 36, 102),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.deepPurple,
            title: Row( children: [
              Image.asset('assets/images/DNLogo_Edit.png', width: 50, height: 50 ,fit: BoxFit.fitHeight),
              const Expanded(child: Text('Page', style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 28, 1, 44)))),
            ]),
          ),
          _titleNote(_currentNote.imagePath, _currentNote.noteTitle),
          if (_currentNote.tags != null) _tagContent(_currentNote.tags!),
          if (_currentNote.tabs != null) 
            for (var tab in _currentNote.tabs!) _tabContentExpandable(tab.title, tab.body),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.deepPurple,
        child: _footerButtons(),
      )
    );
  }
}
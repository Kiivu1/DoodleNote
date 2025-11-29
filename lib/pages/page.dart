import 'package:flutter/material.dart';
import 'package:doodle_note/pages/edit.dart';
import 'package:provider/provider.dart';
import 'package:doodle_note/providers/config_data.dart';
import 'package:doodle_note/models/notes.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:doodle_note/services/note_storage.dart';
import 'package:doodle_note/services/cloud_service.dart';
import 'package:doodle_note/l10n/app_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';

class NotePageScreen extends StatefulWidget {
  const NotePageScreen({super.key, required this.notaPage});

  final Note notaPage;

  @override
  State<NotePageScreen> createState() => _NotePageScreen();
}

class _NotePageScreen extends State<NotePageScreen> {
  final NoteStorage _storage = NoteStorage();
  final CloudService _cloudService = CloudService();
  
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;

  late Note _currentNote;

  @override
  void initState(){
    super.initState();
    _currentNote = widget.notaPage;
    _initTts();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  void _initTts() async {
    await _flutterTts.setLanguage("es-ES");
    await _flutterTts.setPitch(1.0);
    
    _flutterTts.setStartHandler(() {
      setState(() => _isSpeaking = true);
    });

    _flutterTts.setCompletionHandler(() {
      setState(() => _isSpeaking = false);
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() => _isSpeaking = false);
    });
  }

  Future<void> _speak(String text) async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      setState(() => _isSpeaking = false);
    } else {
      if (text.isNotEmpty) {
        final langCode = Localizations.localeOf(context).languageCode;
        await _flutterTts.setLanguage(langCode == 'en' ? 'en-US' : 'es-ES');
        await _flutterTts.speak(text);
      }
    }
  }

  double get fontTitleSize => context.watch<ConfigurationData>().sizeFontTitle.toDouble();
  double get fontTextSize => context.watch<ConfigurationData>().sizeFont.toDouble();
  bool get imageVisible => context.watch<ConfigurationData>().showImage;
  bool get dateVisible => context.watch<ConfigurationData>().showDate;
  String get fontFamilyText => context.watch<ConfigurationData>().FontFamily ?? '';

  void _goToEdit() async { 
    await _flutterTts.stop();
    
    final result = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => EditPage(notaEdited: _currentNote)),
    );

    if (result != null && result is Note) {
      if (context.mounted) {
        setState(() {
          _currentNote = result;
        });
      }
    }
  }

  void _deleteNote() async {
    try {
      await _storage.deleteNote(_currentNote);
      if (mounted) {
        bool isAutoSyncOn = context.read<ConfigurationData>().autoSync;
        if (isAutoSyncOn) {
          _cloudService.uploadNotes();
        }
        Navigator.pop(context, true); 
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context, false);
      }
    }
  }

  void _shareNote() async {
    final l10n = AppLocalizations.of(context)!;
    final note = _currentNote;

    StringBuffer shareText = StringBuffer();
    shareText.writeln('${note.noteTitle}');
    shareText.writeln('');
    shareText.writeln('${l10n.createdDate}: ${note.creationDate}');
    if (note.tags != null && note.tags!.isNotEmpty) {
      shareText.writeln('${l10n.tag}s: ${note.tags!.join(', ')}');
    }
    shareText.writeln('');
    if (note.tabs != null) {
      for (var tab in note.tabs!) {
        shareText.writeln('\n-- ${tab.title} --');
        shareText.writeln(tab.body);
      }
    }

    List<XFile> filesToShare = [];
    if (note.imagePath != null && !note.imagePath!.startsWith('assets/')) {
      final imageFile = File(note.imagePath!);
      if (await imageFile.exists()) {
        filesToShare.add(XFile(note.imagePath!));
      }
    }

    try {
      if (filesToShare.isNotEmpty) {
        await Share.shareXFiles(filesToShare, text: shareText.toString(), subject: note.noteTitle);
      } else {
        await Share.share(shareText.toString(), subject: note.noteTitle);
      }
    } catch (e) {
      // Error handling
    }
  }
  
  SliverToBoxAdapter _tabContentExpandable(String title, String body){
    final double space = 2;
    final l10n = AppLocalizations.of(context)!;

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(6),
        child: Card(
          margin: EdgeInsets.all(space),
          color: const Color.fromARGB(255, 165, 142, 219),
          child: ExpansionTile(
            initiallyExpanded: false,
            tilePadding: EdgeInsets.all(8.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontFamily: fontFamilyText,fontSize: fontTitleSize, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.volume_up),
                  tooltip: l10n.readAloud, 
                  onPressed: () => _speak(body), 
                ),
              ],
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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.purple[50],
            title: Text(l10n.deleteNoteTitle, style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTitleSize)),
            content: Text(l10n.deleteNoteContent, style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTextSize)),
            actions: <Widget>[
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                  _deleteNote();
                } ,
                child: Text(l10n.delete)
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.cancel)
              )
            ],
          );
        });
  }

  Widget _footerButtons() {
    final l10n = AppLocalizations.of(context)!;
    TextStyle buttonTextStyle = TextStyle(fontSize: fontTextSize, fontWeight: FontWeight.bold);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: TextButton.icon(
            onPressed: _showDialog,
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            label: Text(l10n.delete, style: TextStyle(color: Colors.white)),
            style: TextButton.styleFrom(textStyle: buttonTextStyle),
          ),
        ),
        VerticalDivider(),
        Expanded(
          flex: 2,
          child: TextButton.icon(
            onPressed: _goToEdit,
            icon: const Icon(Icons.edit, color: Colors.white),
            label: Text(l10n.edit, style: TextStyle(color: Colors.white)),
            style: TextButton.styleFrom(textStyle: buttonTextStyle),
          ),
        ),
        VerticalDivider(),
        Expanded(
          child: TextButton.icon(
            onPressed: _shareNote,
            icon: const Icon(Icons.share, color: Colors.white),
            label: Text(l10n.share, style: TextStyle(color: Colors.white)),
            style: TextButton.styleFrom(textStyle: buttonTextStyle),
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
    if (imageProvider == null) imageProvider = const AssetImage('assets/images/DNImage1.png');

    return SliverToBoxAdapter(
      child: Padding(padding: const EdgeInsets.all(3),
        child: Card(
          margin: EdgeInsets.all(6),
          color: const Color.fromARGB(255, 194, 175, 238),
          child: Column(
            children: [
              if (imageVisible) 
              Padding(
                padding: EdgeInsets.all(6),
                child: Container(
                  width: double.infinity,
                  height: 250, 
                  decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 3), borderRadius: BorderRadius.circular(15)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image(image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Text( title, style: TextStyle(fontFamily: fontFamilyText , fontSize: fontTitleSize, fontWeight: FontWeight.bold, color: Colors.black), textAlign: TextAlign.center),
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
              
              // --- BOTÓN ESTRELLA (NUEVO) ---
              IconButton(
                onPressed: () async {
                  setState(() {
                    _currentNote.isStarred = !_currentNote.isStarred;
                  });
                  // 1. Guardar Localmente
                  await _storage.saveNote(_currentNote);
                  
                  // 2. Sincronizar si está activo
                  if (context.mounted) {
                     bool isAutoSyncOn = context.read<ConfigurationData>().autoSync;
                     if (isAutoSyncOn) {
                       _cloudService.uploadNotes();
                     }
                  }
                },
                icon: Icon(
                  _currentNote.isStarred ? Icons.star : Icons.star_border,
                  color: _currentNote.isStarred ? Colors.amber : Colors.white70,
                  size: 28,
                ),
                tooltip: 'Marcar para respaldo',
              ),
              // ------------------------------
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
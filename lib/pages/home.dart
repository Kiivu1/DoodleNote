import 'package:flutter/material.dart';
import 'package:doodle_note/pages/page.dart';
import 'package:doodle_note/pages/search.dart';
import 'package:doodle_note/pages/edit.dart';
import 'package:doodle_note/pages/configuration.dart';
import 'package:provider/provider.dart';
import 'package:doodle_note/providers/config_data.dart';
import 'package:doodle_note/services/note_storage.dart'; 
import 'package:doodle_note/models/notes.dart'; 
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:doodle_note/pages/about.dart';
// IMPORTAR IDIOMAS
import 'package:doodle_note/l10n/app_localizations.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final NoteStorage _storage = NoteStorage();
  List<Note> _notes = [];
  bool _isLoading = true;

  String _formatDate(String dateStrign){
    try{
      final dateTime = DateTime.parse(dateStrign);
      return DateFormat('MMM d, yyyy h:mm a').format(dateTime);
    } catch (e){
      print('Error parsing date: $e');
      return 'Invalid Date';
    }
  }

  double get fontTitleSize => context.watch<ConfigurationData>().sizeFontTitle.toDouble();
  double get fontDateSize => context.watch<ConfigurationData>().sizeFont.toDouble();
  bool get imageVisible => context.watch<ConfigurationData>().showImage;
  bool get dateVisible => context.watch<ConfigurationData>().showDate;
  String get fontFamilyText => context.watch<ConfigurationData>().FontFamily ?? '';

  @override
  void initState(){
    super.initState();
    _loadNotes();
  }

  //FUNCIONES------------------------------------------------------
  Future<void> _loadNotes() async{
    setState((){ _isLoading = true; });
    final loadedNotes = await _storage.readAllNotes();
    setState(() {
      _notes = loadedNotes;
      _isLoading = false;
    });
  }

  void _goToPage(Note note) async {
    await Navigator.push( context, MaterialPageRoute(builder: (context) => NotePageScreen(notaPage: note)), );
    _loadNotes();
  }

  void _goToSearch() async {
    await Navigator.push( context, MaterialPageRoute(builder: (context) => SearchPage()), );
    _loadNotes();
  }

  void _goToEdit({Note? note}) async {
    final Note noteToEdit = note ?? Note(id: 0, noteTitle: 'New Doodle Note', creationDate: DateTime.now().toString(), editCreationDate: DateTime.now().toString());
    await Navigator.push( context, MaterialPageRoute(builder: (context) => EditPage(notaEdited: noteToEdit)), );
    _loadNotes();
  }
  
  // Nota: Usamos Textos traducidos al pasar el titulo, aunque ConfigurationPage ya lo maneja internamente
  void _goToConfig() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => ConfigurationPage(title: 'Configuration')), ); 
    _loadNotes(); 
  }
  
  void _goToAbout() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutPage()), ); 
    _loadNotes(); 
  }

  //REFACTORS------------------------------------------------------
  Widget _imageContainer(String? imagePath, {double size = 40}){
    ImageProvider? imageProvider;

    if(imagePath != null){
      if(imagePath.startsWith('assets/')){
        imageProvider = AssetImage(imagePath);
      } else if (File(imagePath).existsSync()) {
        imageProvider = FileImage(File(imagePath));
      }
    }

    if(imageProvider == null){
      return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 3,),
        borderRadius: BorderRadius.circular(10)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(width: size, height: size, child: Image.asset('assets/images/DNImage1.png', fit: BoxFit.cover))
      )
    );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 3,),
        borderRadius: BorderRadius.circular(10)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(width: size, height: size, child: Image(image: imageProvider, fit: BoxFit.cover))
      )
    );
  }

  //Contenedor original
  Widget _ogNoteContent(Note note){
    return Padding(padding: const EdgeInsets.all(1),
        child: Card( margin: EdgeInsets.all(2), color: const Color.fromARGB(255, 144, 119, 244),
          child: ListTile(
            onTap: () => _goToPage(note),
            leading: imageVisible ? _imageContainer(note.imagePath) : null,
            title: Text(note.noteTitle, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTitleSize, fontWeight: FontWeight.bold , color: Colors.black)),
            subtitle: Text(dateVisible ? _formatDate(note.editCreationDate) : '', style: TextStyle(fontFamily: fontFamilyText, fontSize: fontDateSize, fontWeight: FontWeight.bold , color: Colors.black)),
            trailing: Icon(Icons.arrow_forward, color: const Color.fromARGB(255, 20, 1, 34))
          ) 
        )
    );
  }
  //contenedor pequeño
  Widget _compactNote(Note note){
    return Padding(padding: const EdgeInsets.all(1),
      child: Card( margin: EdgeInsets.all(2), color: const Color.fromARGB(255, 144, 119, 244),
        child: ListTile(
          onTap: () => _goToPage(note),
          title: Text(note.noteTitle, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTitleSize, fontWeight: FontWeight.bold , color: Colors.black)),
        )
      )
    );
  }
  //Contenedor Grande
  Widget _gridNote(Note note){
    const double imageSize = 200;

    return Card(
      margin: const EdgeInsets.all(4),
      color: const Color.fromARGB(255, 144, 119, 244),
      child: InkWell(
        onTap: () => _goToPage(note),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: imageVisible ? _imageContainer(note.imagePath, size: imageSize): null),
              const SizedBox(height: 8),
              Text(
                note.noteTitle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTitleSize, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 4),
              Text(
                dateVisible ? _formatDate(note.editCreationDate): '',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: fontFamilyText, fontSize: fontDateSize, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  //Refactor: agrega la nota
  Widget _noteContent(Note note){
    int typeNoteLayout = context.watch<ConfigurationData>().menuLayout;

    switch (typeNoteLayout) {
      case 0: return SliverToBoxAdapter(child:  _ogNoteContent(note));
      case 1: return SliverToBoxAdapter(child:  _gridNote(note));
      case 2: return SliverToBoxAdapter(child:  _compactNote(note));
      default: return SliverToBoxAdapter(child:  _ogNoteContent(note));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // Variable corta para textos

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 57, 29, 82),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        edgeOffset: kToolbarHeight,
        onRefresh: _loadNotes,
        color: Colors.deepPurple,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.deepPurple,
              title:Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset('assets/images/DNLogo_Home.png', width: 50, height: 50 ,fit: BoxFit.fitHeight),
                  // USAMOS l10n PARA EL TÍTULO
                  Expanded(child: Text(l10n.appTitle, style: TextStyle(fontFamily: fontFamilyText, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 28, 1, 44)))),
                ]
              )
            ),
            if(_isLoading)
              const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))),
            if (!_isLoading)
              ..._notes.map((note) => _noteContent(note)).toList(),
            if (!_isLoading && _notes.isEmpty)
              // USAMOS l10n PARA MENSAJE VACÍO
              SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(50), child: Text(l10n.noNotes, style: TextStyle(fontFamily: fontFamilyText,color: Colors.white, fontSize: fontDateSize))))),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.more,
        activeIcon: Icons.close,
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
        spacing: 10,
        spaceBetweenChildren: 10,
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add, color: Colors.white),
            backgroundColor: Colors.green,
            // USAMOS l10n
            label: l10n.createNote,
            labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            onTap: () => _goToEdit(),
          ),
          SpeedDialChild(
            child: const Icon(Icons.search, color: Colors.white),
            backgroundColor: Colors.blueAccent,
            // USAMOS l10n
            label: l10n.search,
            labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            onTap: () => _goToSearch(),
          ),
          SpeedDialChild(
            child: const Icon(Icons.settings, color: Colors.white),
            backgroundColor: Colors.orange,
            // USAMOS l10n
            label: l10n.settingsTitle,
            labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            onTap: () => _goToConfig(),
          ),
          SpeedDialChild(
            child: const Icon(Icons.person, color: Colors.white),
            backgroundColor: Colors.purple,
            // USAMOS l10n
            label: l10n.about,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            onTap: () => _goToAbout(),
          ),
        ],
      ),
    );
  }
}
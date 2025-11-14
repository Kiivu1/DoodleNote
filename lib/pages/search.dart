import 'package:flutter/material.dart';
import 'package:doodle_note/pages/page.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:doodle_note/providers/config_data.dart';
import 'package:doodle_note/services/note_storage.dart';
import 'package:doodle_note/models/notes.dart';
import 'dart:io';
import 'package:intl/intl.dart';


class SearchPage extends StatefulWidget{
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage>{

  double get fontTitleSize => context.watch<ConfigurationData>().sizeFontTitle.toDouble();
  double get fontTextSize => context.watch<ConfigurationData>().sizeFont.toDouble();
  bool get imageVisible => context.watch<ConfigurationData>().showImage;
  bool get dateVisible => context.watch<ConfigurationData>().showDate;
  String get fontFamilyText => context.watch<ConfigurationData>().FontFamily ?? '';

  final NoteStorage _storage = NoteStorage();
  List<Note> _allNotes = [];
  List<Note> _filteredNotes = [];
  bool _isLoading = true;

  String _searchText = '';

  String _formatDate(String dateStrign){
    try{
      final dateTime = DateTime.parse(dateStrign);
      return DateFormat('MMM d, yyyy h:mm a').format(dateTime);
    } catch (e){
      print('Error parsing date: $e');
      return 'Invalid Date';
    }
  }

  void _goToPage(Note note) async {
    await Navigator.push( context, MaterialPageRoute(builder: (context) => NotePageScreen(notaPage: note)), );
    _loadNotes();
  }

  @override
  void initState(){
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async{
    setState((){ _isLoading = true; });
    final loadedNotes = await _storage.readAllNotes();
    setState(() {
      _allNotes = loadedNotes;
      _filteredNotes = loadedNotes;
      _isLoading = false;
    });
  }

  List<Note> _getFilteredNotes(String filter){
    if(filter.isEmpty){return _allNotes;}

    final lowerCaseFilter = filter.toLowerCase();

    return _allNotes.where((note) {
      if ((note.noteTitle ?? '').toLowerCase().contains(lowerCaseFilter)) {
        return true;
      }
      if (note.tags?.any((tag) => tag.toLowerCase().contains(lowerCaseFilter)) ?? false) {
        return true;
      }

      if (note.tabs?.any((tab) => 
            tab.body.toLowerCase().contains(lowerCaseFilter) || 
            tab.title.toLowerCase().contains(lowerCaseFilter)
        ) ?? false) {
        return true;
      }

      return false;
    }).toList();
  }

  SliverToBoxAdapter _searchBarSliver(){
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(6),
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder( borderRadius: BorderRadius.circular(10)),
            prefixIcon: Icon(Icons.search),
            hintText: 'Search DoodleNote',
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (text){
            setState(() {
              _searchText = text;
              _filteredNotes = _getFilteredNotes(text);            
            });
          },
        )
      )
    );
  }

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

  Widget _listOfTags(List<String> tags){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tags.map((tag) => Padding(padding: EdgeInsets.only(right: 6),
            child: Chip(
              avatar: Icon(Icons.tag, color: Colors.black,),
              label: Text(tag, style: TextStyle(fontSize: fontTextSize, color: Colors.black, fontWeight: FontWeight.bold),),
              backgroundColor: const Color.fromARGB(255, 225, 107, 156),
            )
          )
        ).toList(),
      ),
    );
  }

  SliverToBoxAdapter _noteContent(Note note){
    final double fontTitleSize = 16;
    final double fontTextSize = 10;

    return SliverToBoxAdapter(
      child: Padding(padding: const EdgeInsets.all(1),
        child: Card( margin: EdgeInsets.all(2), color: Colors.pinkAccent,
          child: ListTile(
            onTap: ()=> _goToPage(note),                                                                                      //AQUI PONER METODO DE NAVEGADOR
            leading: imageVisible ? _imageContainer(note.imagePath): null,
            title: Text(note.noteTitle, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: fontTitleSize, fontWeight: FontWeight.bold , color: Colors.black)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( dateVisible ?  _formatDate(note.creationDate) : '', style: TextStyle(fontSize: fontTextSize, fontWeight: FontWeight.bold , color: Colors.black)) ,
                SizedBox(height: 10),
                _listOfTags(note.tags ?? [])
              ],
            ),
            trailing: Icon(Icons.arrow_forward, color: const Color.fromARGB(255, 20, 1, 34), )
          ) 
        )
      )
    );
  }

  @override
  Widget build(BuildContext context){

    var logger = Logger();
    logger.d("build compiladp");

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 57, 29, 82),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/images/DNSearchLogo.png', fit: BoxFit.cover, height: 40),
            Expanded(child: Text('Search', style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 28, 1, 44)))),
          ]
        )
      ),
      body: CustomScrollView(
        slivers: [
          _searchBarSliver(),
          if (_isLoading)
            const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator()
                )
              )
            ),
          
          if (!_isLoading && _filteredNotes.isNotEmpty)
            ..._filteredNotes.map((note) => _noteContent(note)).toList(),
          if (!_isLoading && _filteredNotes.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: Text(
                  _searchText.isEmpty ? 'No notes found yet.' : 'No results found for "$_searchText".',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                )
              )
            )
          ),
        ],
      )
    );
  }
}
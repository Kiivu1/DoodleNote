import 'package:flutter/material.dart';
import 'package:doodle_note/models/notes.dart';
import 'package:doodle_note/models/tab.dart';
import 'package:provider/provider.dart';
import 'package:doodle_note/providers/config_data.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:doodle_note/services/note_storage.dart';
import 'package:doodle_note/services/cloud_service.dart';
import 'package:doodle_note/l10n/app_localizations.dart'; // IMPORT VITAL

class EditPage extends StatefulWidget{
  const EditPage({super.key, required this.notaEdited});

  final Note notaEdited;

  @override
  State<EditPage> createState() => _EditPage();
}

class _EditPage extends State<EditPage>{  
  //CONFIGURATION DATA VAR
  double get fontTitleSize => context.watch<ConfigurationData>().sizeFontTitle.toDouble();
  double get fontTextSize => context.watch<ConfigurationData>().sizeFont.toDouble();
  bool get imageVisible => context.watch<ConfigurationData>().showImage;
  bool get dateVisible => context.watch<ConfigurationData>().showDate;
  String get fontFamilyText => context.watch<ConfigurationData>().FontFamily ?? '';


  late String _noteTitle;
  late List<String> _tags;
  late List<TabItem> _tabs;
  String? _currentImagePath;

  late TextEditingController _titleController;

  final NoteStorage _storage = NoteStorage();
  final CloudService _cloudService = CloudService(); // Instancia servicio nube

  @override
  void initState(){
    super.initState();
    _noteTitle = widget.notaEdited.noteTitle;
    _tags = widget.notaEdited.tags ?? [];
    _tabs = widget.notaEdited.tabs ?? [];
    _currentImagePath = widget.notaEdited.imagePath;
    _titleController = TextEditingController(text: _noteTitle);
    _titleController.addListener(_updateNoteTitle);
  }

  @override
  void dispose(){
    _titleController.removeListener(_updateNoteTitle);
    _titleController.dispose();
    super.dispose();
  }


  //FUNCIONES-----------------------------------------------------

  int _getNewId(){
    return DateTime.now().millisecondsSinceEpoch;
  }

  final ImagePicker _picker = ImagePicker();
  
  void _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _currentImagePath = pickedFile.path;
      });
    }
  }

  void _takePhoto() => _pickImage(ImageSource.camera);
  void _selectFromGallery() => _pickImage(ImageSource.gallery);

  void _updateNoteTitle(){
    setState(() {
      _noteTitle = _titleController.text;
    });
  }

  void _saveAndGoBack() async {

    final int noteId = widget.notaEdited.id == 0 ? _getNewId() : widget.notaEdited.id;

    final Note updatedNote = Note(
      id: noteId,
      noteTitle: _noteTitle,
      imagePath: _currentImagePath,
      creationDate: widget.notaEdited.creationDate,
      editCreationDate: DateTime.now().toString(),
      tags: _tags.isEmpty ? null : _tags,
      tabs: _tabs.isEmpty ? null : _tabs,
    );

    // 1. Guardar Local
    await _storage.saveNote(updatedNote);

    // 2. Sincronización Automática
    if (mounted) {
      bool isAutoSyncOn = context.read<ConfigurationData>().autoSync;
      if (isAutoSyncOn) {
        _cloudService.uploadNotes(); // Sin await para no bloquear UI
      }
    }

    await Future.delayed(const Duration(milliseconds: 100));

    if (mounted) {
        Navigator.pop(context, updatedNote);
    }
  }

  void _goBackWithoutSaving() {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void _addTag(String newTag){
    if(newTag.trim().isEmpty) return;
    setState(() {
      _tags.add(newTag);
    });
  }

  void _deleteTag(int index){
    setState(() {
      _tags.removeAt(index);
    });
  }

  void _updateTag(int index, String newTag){
    if(newTag.trim().isEmpty) return;
    setState(() {
      _tags[index] = newTag;
    });
  }

  void _addTab(String title, String body){
    if(title.trim().isEmpty) return;
    setState(() {
      _tabs.add(TabItem(title: title, body: body));
    });
  }

  void _deleteTab(int index){
    setState(() {
      _tabs.removeAt(index);
    });
  }

  void _updateTabTitle(int index, String newTitle) {
    if (newTitle.trim().isNotEmpty) {
      setState(() {
        _tabs[index] = _tabs[index].copyWith(title: newTitle.trim());
      });
    }
  }

  void _updateTabBody(int index, String newBody) {
    setState(() {
      _tabs[index] = _tabs[index].copyWith(body: newBody);
    });
  }

  //REFACTORS ------------------------------------------------
  SliverToBoxAdapter _imageSelection(){
    final l10n = AppLocalizations.of(context)!; // Variable para idiomas
    final String? imagePath = _currentImagePath;

    ImageProvider? imageProvider;

    if (imagePath != null) {
      if(imagePath.startsWith('assets/')){
        imageProvider = AssetImage(imagePath);
      } else {
        imageProvider = FileImage(File(imagePath));
      }
    }

    return SliverToBoxAdapter(
      child: Padding(padding: const EdgeInsets.all(1),
        child: Card(
          margin: EdgeInsets.all(2),
          color: const Color.fromARGB(255, 224, 162, 54),
          child: Column(
            children : [
              Padding(
                padding: EdgeInsets.only(top: 6, left: 6, right: 6),
                child: (imageVisible && imageProvider!= null)? Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image(image: imageProvider, fit: BoxFit.cover),
                  ),
                ): null,
              ),
              Padding(padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _takePhoto,
                      child: Row(children: [Icon(Icons.photo), Text(l10n.takePhoto, style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTextSize))])),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _selectFromGallery,
                      child: Row(children: [Icon(Icons.folder), Text(l10n.fromGallery, style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTextSize))]))
                  ],
                )
              )
            ]
          )
        )
      )
    );
  }

  SliverToBoxAdapter _noteTabWidget(TabItem tab, index){
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Card(
          margin: EdgeInsets.all(2),
          color: Colors.deepPurple[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children:[
              Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    IconButton(onPressed: () => _deleteTab(index),
                      icon: Icon(Icons.delete), tooltip: 'DeleteTab',
                    ),
                    SizedBox(width: 16),
                    Expanded( 
                      child: TextFormField(
                        initialValue: tab.title,
                        decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                        style: TextStyle(fontFamily: fontFamilyText, fontSize: fontTitleSize, fontWeight: FontWeight.bold, color: Colors.white),
                        onChanged: (newTitle) => _updateTabTitle(index, newTitle),
                      ) 
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.tab, color: Colors.white,),
                  ],
                ),
              ),
              Divider(color: Colors.white),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded( 
                      child: TextFormField(
                        initialValue: tab.body,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                        style: TextStyle(fontSize: fontTextSize, fontFamily: fontFamilyText, color: Colors.white),
                        onChanged: (newBody) => _updateTabBody(index, newBody),
                      ) 
                    )
                  ],
                ) 
              )
            ]
          )
        ),
      )
    );
  }

  SliverToBoxAdapter _noteTagWidget(String tag, int index){
    return SliverToBoxAdapter(
      child: Padding(padding: const EdgeInsets.all(1),
        child: Card(
          margin: EdgeInsets.all(2),
          color: const Color.fromARGB(255, 82, 158, 187),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => _deleteTag(index), 
                  icon: const Icon(Icons.delete), 
                  tooltip: 'Delete Tag',
                ),
                const SizedBox(width: 8),
                Expanded( 
                  child: TextFormField(
                    initialValue: tag,
                    decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                    style: TextStyle(fontSize: fontTitleSize, fontFamily: fontFamilyText, fontWeight: FontWeight.bold, color: Colors.white),
                    onChanged: (newText) => _updateTag(index, newText),
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.label, color: Colors.white,),
              ],
            ),
          ),
        )
      )
    );
  }
  
  SliverToBoxAdapter _noteTitleWidget(){
    return SliverToBoxAdapter(
      child: Padding(padding: const EdgeInsets.all(1),
        child: Card(
          margin: const EdgeInsets.all(2),
          color: const Color.fromARGB(255, 203, 62, 109),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded( 
                  child: TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                    style: TextStyle(fontSize: fontTitleSize, fontFamily: fontFamilyText, fontWeight: FontWeight.bold, color: Colors.white), 
                  ), 
                ),
                const SizedBox(width: 8),
                const Icon(Icons.document_scanner, color: Colors.white,),
              ],
            ),
          ),
        )
      )
    );
  }

  //DIALOGS------------------------------------
  void _showAddTagDialog() {
    final l10n = AppLocalizations.of(context)!; // Idiomas
    final TextEditingController tagController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.addTagTitle),
          content: TextField(
            controller: tagController,
            autofocus: true,
            decoration: InputDecoration(hintText: l10n.enterTagName),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _addTag(tagController.text);
                Navigator.pop(context);
              },
              child: Text(l10n.add),
            ),
            TextButton( onPressed: () => Navigator.pop(context), child: Text(l10n.cancel), ),
          ],
        );
      },
    );
  }

  void _showAddTabDialog() {
    final l10n = AppLocalizations.of(context)!; // Idiomas
    final TextEditingController titleController = TextEditingController();
    final TextEditingController bodyController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.addTabTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  autofocus: true,
                  decoration: InputDecoration(hintText: l10n.enterTabTitle),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: bodyController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: l10n.enterTabContent,
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _addTab(titleController.text, bodyController.text);
                Navigator.pop(context);
              },
              child: Text(l10n.add),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
          ],
        );
      },
    );
  }

  void _showDialog(){
    final l10n = AppLocalizations.of(context)!; 
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          backgroundColor: Colors.purple[50],
          title: Text(l10n.saveProgress),
          content: Text(l10n.wantToSave),
          actions: <Widget>[
            TextButton(onPressed: ()=> { Navigator.of(context).pop(), _saveAndGoBack()}, child: Text(l10n.save)),
            TextButton(onPressed: (){ Navigator.of(context).pop(); } 
            , child: Text(l10n.cancel))
          ],
        );
      }
    );
  }
  
  void _showChooseAddDialog(){
    final l10n = AppLocalizations.of(context)!; 
    showDialog(context: context,
    builder: (BuildContext context){
      return AlertDialog(
          backgroundColor: Colors.purple[50],
          title: Text(l10n.chooseAdd),
          actions: <Widget>[
            TextButton( onPressed: () => { Navigator.of(context).pop(),_showAddTabDialog(), },
            child: Row( mainAxisSize: MainAxisSize.min, children: [ Icon(Icons.tab, color: Colors.indigo[200]), SizedBox(width: 8), Text(l10n.tab), ],),
          ),
          TextButton(
            onPressed: () => { Navigator.of(context).pop(), _showAddTagDialog(), },
            child: Row( mainAxisSize: MainAxisSize.min, children: [ Icon(Icons.label_outline, color: Colors.blueGrey), SizedBox(width: 8), Text(l10n.tag), ], ),
          ),
            TextButton(onPressed: () => {Navigator.of(context).pop()}, child: Text(l10n.cancel))
          ],
        );
      }
    );
  }

  void _showLeaveDialog(){
    final l10n = AppLocalizations.of(context)!; 
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          backgroundColor: Colors.purple[50],
          title: Text(l10n.leaveWithoutSaving),
          content: Text(l10n.leaveLoseChanges),
          actions: <Widget>[
            TextButton(onPressed: _goBackWithoutSaving, child: Text(l10n.leave)),
            TextButton(onPressed: (){ Navigator.of(context).pop(); } 
            , child: Text(l10n.cancel))
          ],
        );
      }
    );
  }

  //Add Tabs or Tags, to make sure SpeedDial doesnt make  ----------------------------------
  SliverToBoxAdapter _addTabSliver() {
    final l10n = AppLocalizations.of(context)!; 
    return SliverToBoxAdapter(
      child: Padding(padding: EdgeInsets.all(1),
        child: Card(
          margin: const EdgeInsets.all(2),
          color: const Color.fromARGB(255, 53, 36, 102),
          elevation: 2, 
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(8.0),  side: const BorderSide( color: Colors.white, width: 3.0, ),
          ),
          child: InkWell(
            onTap: () => _showChooseAddDialog(),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 60, horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline, size: 28, color: Colors.white),
                  SizedBox(width: 12),
                  Text(
                    l10n.tapToAdd, // TRADUCIDO
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white
                    ),
                  ),
                ],
              ),
            )
          ) 
        )
      )
    );
  }
  //BUILD--------------------------------

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 53, 36, 102),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false, 
            backgroundColor: Colors.deepPurple,
            title: Row( children: [
              IconButton(
                onPressed: () => _showLeaveDialog(),
                icon: const Icon(Icons.arrow_back), 
                padding: EdgeInsets.zero, 
              ),
              Image.asset('assets/images/DNLogo_Edit.png', width: 50, height: 50 ,fit: BoxFit.fitHeight),
              const Expanded(child: Text('Page', style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 28, 1, 44)))),
            ]),
          ),
          if (imageVisible) _imageSelection(),
          _noteTitleWidget(),
          for (int i = 0; i < _tags.length; i++) _noteTagWidget(_tags[i], i),
          for (int i = 0; i < _tabs.length; i++) _noteTabWidget(_tabs[i], i),
          _addTabSliver()
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { _saveAndGoBack(); },
        backgroundColor: Colors.teal,
        child: const Icon( Icons.save, color: Colors.white, size: 28.0, ),
      )
    );
  }
}
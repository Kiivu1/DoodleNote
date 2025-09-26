import 'package:doodle_note/models/tab.dart';

class Note {
  //NOTA PRINCIPAL
  String noteTitle = "Doodle Note: Placeholder";
  String? imagePath = 'assets/images/spr_Test.png'; //imagen de la nota, puede ser null
  String creationDate;
  String editPage;

  //TAGS
  List<String>? tags;

  //TABS
  List<TabItem>? tabs;

  Note({
    required this.noteTitle,
    this.imagePath,
    required this.creationDate,
    required this.editPage,
    this.tags,
    this.tabs
  });
}


//POR HACER

//splash screen
//logo
//implementar logos
//agregar imagenes
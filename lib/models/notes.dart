import 'package:doodle_note/models/tab.dart';

class Note {
  //NOTA PRINCIPAL
  int id = 0;
  String noteTitle = "Doodle Note: Placeholder";
  String? imagePath = 'assets/images/DNImage1.png'; //imagen de la nota, puede ser null
  String creationDate;
  String editCreationDate;

  bool isStarred;

  //TAGS
  List<String>? tags;

  //TABS
  List<TabItem>? tabs;

  Note({
    required this.id,
    required this.noteTitle,
    this.imagePath,
    required this.creationDate,
    required this.editCreationDate,
    this.isStarred=false,
    this.tags,
    this.tabs
  });

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'noteTitle': noteTitle,
      'imagePath': imagePath,
      'creationDate': creationDate,
      'editCreationDate': editCreationDate,
      'isStarred': isStarred,
      'tags': tags,
      'tabs': tabs?.map((tab) => tab.toJson() ).toList(),
    };
  }
  
  factory Note.fromJson(Map<String, dynamic> json){
    final List<TabItem>? tabs = (json['tabs'] as List<dynamic>?)?.map((tabJson) => TabItem.fromJson(tabJson as Map<String, dynamic>)).toList();

    return Note(
      id: json['id'] as int,
      noteTitle: json['noteTitle'] as String,
      imagePath: json['imagePath'] as String?,
      creationDate: json['creationDate'] as String,
      editCreationDate: json['editCreationDate'] as String,
      isStarred: json['isStarred'] ?? false,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      tabs: tabs,
    );
  }

}

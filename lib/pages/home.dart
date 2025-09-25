import 'package:flutter/material.dart';
import 'package:doodle_note/pages/page.dart';
import 'package:doodle_note/pages/search.dart';
import 'package:doodle_note/pages/edit.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _goToPage(){
    Navigator.push( context, MaterialPageRoute(builder: (context) => NotePageScreen()), );
  }

  void _goToSearch(){
    Navigator.push( context, MaterialPageRoute(builder: (context) => SearchPage()), );
  }

  void _goToEdit(){
    Navigator.push( context, MaterialPageRoute(builder: (context) => EditPage()), );
  }


  //refactor, crea una imagen, con un borde blanco
  Widget _imageContainer(assetPath){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 3,),
        borderRadius: BorderRadius.circular(10)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(width: 40, height: 40, child: Image.asset(assetPath, fit: BoxFit.cover))
      )
    );
  }

  //Refactor: agrega la nota
  SliverToBoxAdapter _noteContent(assetPath, title, date){
    final double fontTitleSize = 16;
    final double fontDateSize = 10;

    return SliverToBoxAdapter(
      child: Padding(padding: const EdgeInsets.all(1),
        child: Card( margin: EdgeInsets.all(2), color: const Color.fromARGB(255, 144, 119, 244),
          child: ListTile(
            onTap: _goToPage,                                                                                      //AQUI PONER METODO DE NAVEGADOR
            leading: _imageContainer(assetPath),
            title: Text(title, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: fontTitleSize, fontWeight: FontWeight.bold , color: Colors.black)),
            subtitle: Text(date, style: TextStyle(fontSize: fontDateSize, fontWeight: FontWeight.bold , color: Colors.black)),
            trailing: Icon(Icons.arrow_forward, color: const Color.fromARGB(255, 20, 1, 34))
          ) 
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 57, 29, 82),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.deepPurple,
            title:Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('assets/icons/DoodleNoteWhite.png', width: 50, height: 50 ,fit: BoxFit.fitHeight),
                Expanded(child: Text('DoodleNote', style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 28, 1, 44)))),
                SizedBox(width: 1),
                ElevatedButton(onPressed: _goToSearch, child: Row( children: [ Icon(Icons.search), Text('Search')]))
              ]
            )
          ),
          _noteContent('assets/images/spr_Test.png', 'Doodle Note #1', '21/09/2025'),
          _noteContent('assets/images/spr_Test.png', 'Doodle Note #2', '21/09/2025'),
          _noteContent('assets/images/spr_Test.png', 'Doodle Note #3', '21/09/2025'),
          _noteContent('assets/images/spr_Test.png', 'Doodle Note #4', '21/09/2025'),
          _noteContent('assets/images/spr_Test.png', 'Doodle Note #5', '21/09/2025'),
          _noteContent('assets/images/spr_Test.png', 'Doodle Note #6', '21/09/2025'),
          _noteContent('assets/images/spr_Test.png', 'Doodle Note #7', '21/09/2025'),
          _noteContent('assets/images/spr_Test.png', 'Doodle Note #8', '21/09/2025'),
          _noteContent('assets/images/spr_Test.png', 'Doodle Note #9', '21/09/2025'),
          _noteContent('assets/images/spr_Test.png', 'Doodle Note #10', '21/09/2025'),
          _noteContent('assets/images/spr_Test.png', 'Doodle Note #11', '21/09/2025'),
          _noteContent('assets/images/spr_Test.png', 'Doodle Note #12', '21/09/2025'),
          _noteContent('assets/images/spr_Test.png', 'Doodle Note #13', '21/09/2025'),
          _noteContent('assets/images/spr_Test.png', 'Doodle Note #14', '21/09/2025'),
          _noteContent('assets/images/spr_Test.png', 'Doodle Note #15', '21/09/2025'),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: _goToEdit, tooltip: 'Create Note', child: Icon(Icons.add)),
    );
  }
}

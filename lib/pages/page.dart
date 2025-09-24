import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:DoodleNote/pages/edit.dart';

//COSAS POR HACER:
// - CONVERTIRLO A UN STATEFUL WIDGET
// - QUITAR LOS TAGS
// - QUITAR TITULO

class NotePageScreen extends StatefulWidget{
  const NotePageScreen({super.key});

    @override
  State<NotePageScreen> createState() => _NotePageScreen();
}


class _NotePageScreen extends State<NotePageScreen>{

  //texto debug, para probar
  final String debugText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse pulvinar augue et nisl varius ullamcorper. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ac lacus leo. Sed sit amet sagittis nibh, at lacinia tortor. Pellentesque porta, purus vehicula viverra congue, mauris augue pulvinar enim, sed dapibus metus neque at risus. Sed eleifend luctus magna at dictum. Pellentesque eget ex interdum, tristique diam vel, dictum lacus. Pellentesque viverra viverra tincidunt. Aliquam tortor nulla, auctor a odio et, dictum lobortis metus. In et dui non libero vehicula fringilla eget ut nibh. Aliquam fringilla blandit risus eget varius. Praesent id dapibus nisl. Sed sagittis lectus non feugiat molestie. Aenean ullamcorper mi diam. Sed augue nisi, eleifend non pulvinar nec, molestie sed tellus. Duis rutrum maximus finibus. Nulla sed dolor scelerisque, placerat nibh ultrices, pulvinar ante. Maecenas faucibus ante quis sapien ullamcorper finibus. Mauris et dolor a enim tempus bibendum. Cras eu cursus massa. Duis a ultricies risus. In hac habitasse platea dictumst. Nunc facilisis urna orci, eu dictum arcu sodales ut. Integer molestie tincidunt aliquet. Vivamus rhoncus nec lacus eget imperdiet. In ac pulvinar ipsum, nec feugiat leo. Vivamus id consequat erat, at faucibus dui. Ut dolor sapien, tempor ut risus at, scelerisque pretium quam. Sed et nibh quis urna hendrerit ornare. Cras id scelerisque neque. Nullam at varius tortor. Sed id mauris sit amet ligula commodo condimentum. Donec nec molestie risus, a vehicula ante. Integer sed erat mi. Curabitur condimentum nibh ut convallis ultricies. Nam et interdum lacus. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed consectetur, nulla vulputate posuere viverra, libero ex viverra eros, non viverra velit tellus ac felis. Aenean ultricies dui sed nisi fringilla, a ultricies ipsum cursus. Vestibulum sit amet sem enim. Quisque varius vestibulum dolor, ut placerat nibh euismod in. Aliquam sit amet mauris ante. Mauris in nisi nisi.  Nulla tristique ante enim, et eleifend nunc rutrum in. Nullam metus lorem, sollicitudin eget arcu a, tristique varius libero. Donec pharetra, ante a malesuada tincidunt, nisl ligula consectetur libero, in volutpat est augue sed sem. Duis suscipit justo purus, ac accumsan dolor pellentesque eget. Donec imperdiet scelerisque faucibus. Integer elementum augue et massa gravida, nec sodales metus dictum. Donec et semper massa.';

    
  void _goToEdit(){
    Navigator.push( context, MaterialPageRoute(builder: (context) => EditPage()), );
  }

  void _goBackTwice(){
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void _showDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          backgroundColor: Colors.purple[50],
          title: const Text('Delete DoodleNote'),
          content: const Text('Do you want to delete this Note?'),
          actions: <Widget>[
            TextButton(onPressed: _goBackTwice, child: Text('Delete')),
            TextButton(onPressed: (){ Navigator.of(context).pop(); } 
            , child: Text('Cancel'))
          ],
        );
      }
    );
  }

  //Refactor, sirve para poder tener los botones de abajo.
  Widget _footerButtons(){
    return
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton( onPressed: _showDialog, tooltip: 'Borrar', child: const Icon(Icons.delete), heroTag: 'BtnDelNote',),
          SizedBox(width: 10),
          Expanded( child: FloatingActionButton.extended(onPressed: _goToEdit, label: Text('Editar'), icon: Icon(Icons.edit), heroTag: 'BtnEdtNote',) ),
          SizedBox(width: 10),
          FloatingActionButton( onPressed: null, tooltip: 'Compartir', child: const Icon(Icons.share), heroTag: 'BtnShrNote',),
        ]
      );
  }
  
  //orden es SingleChildScroll -> Card -> Padding -> Column(titulo: (Card + padding + text), espacio(sizedbox), texto (Card + Padding + text))
  Widget _noteContent(title, text){
    final double space = 3; //variable que determina el espacio

    return SingleChildScrollView(
      padding: EdgeInsets.all(space),
      child: Card(
        margin: EdgeInsets.all(space), color: const Color.fromARGB(255, 89, 63, 148),
        child: Padding(
          padding: EdgeInsets.all(space),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card( margin: EdgeInsets.all(space), color: const Color.fromARGB(255, 165, 142, 219), child: Padding(padding: EdgeInsets.all(5),
                child: Text(title, style: TextStyle(fontSize: 20),),),),
              SizedBox(height: space),
              Card( margin: EdgeInsets.all(space), color: const Color.fromARGB(255, 165, 142, 219), child: Padding(padding: EdgeInsets.all(5),
                child: Text(text, style: TextStyle(fontSize: 16),),),),
            ]
          )
        )
      )
    );
  }

  //refactor, titulo de la nota
  Widget _titleContent(imagePath, title){
    return Row(
      children: [
        Container(width: 45, height: 45,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child:ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(imagePath, fit: BoxFit.cover)
          )
        ),
        SizedBox(width: 6),
        Expanded(child: Text(title, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 20, color: Colors.black))), //texto
      ]
    );
  }



  //build de la pantalla
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 53, 36, 102),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: _titleContent('assets/images/spr_Test.png', 'Doodle Note: Placeholder'),
                floating: false,
                pinned: false,
                expandedHeight: 300,
                backgroundColor: Colors.deepPurple,
                flexibleSpace: FlexibleSpaceBar(

                ),
                bottom: const TabBar(
                  tabs: [
                    Tab(child: Text('TAB 1', style: TextStyle(color: Colors.white))),
                    Tab(child: Text('TAB 2', style: TextStyle(color: Colors.white))),
                  ]
                ),
              ),
            ];
          },
          body: TabBarView(
            children: <Widget>[
              _noteContent('Tab 1 title', debugText),
              _noteContent('Titulo 2: texto largo para ver el tamaño', debugText)
            ] 
          ),
        ),
        bottomNavigationBar: BottomAppBar( color: Colors.deepPurple ,child: _footerButtons(), ),
      ),
    );
  }
}

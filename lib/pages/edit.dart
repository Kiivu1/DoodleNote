import 'package:flutter/material.dart';

class EditPage extends StatefulWidget{
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPage();
}

class _EditPage extends State<EditPage>{

  //final double _fontSizeText = 14;
  final double _fontSizeTitle = 14;
  final double _fontSizeTag = 14;
  //Debug Text
  final String debugText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse pulvinar augue et nisl varius ullamcorper. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ac lacus leo. Sed sit amet sagittis nibh, at lacinia tortor. Pellentesque porta, purus vehicula viverra congue, mauris augue pulvinar enim, sed dapibus metus neque at risus. Sed eleifend luctus magna at dictum. Pellentesque eget ex interdum, tristique diam vel, dictum lacus. Pellentesque viverra viverra tincidunt. Aliquam tortor nulla, auctor a odio et, dictum lobortis metus. In et dui non libero vehicula fringilla eget ut nibh. Aliquam fringilla blandit risus eget varius. Praesent id dapibus nisl. Sed sagittis lectus non feugiat molestie. Aenean ullamcorper mi diam. Sed augue nisi, eleifend non pulvinar nec, molestie sed tellus. Duis rutrum maximus finibus. Nulla sed dolor scelerisque, placerat nibh ultrices, pulvinar ante. Maecenas faucibus ante quis sapien ullamcorper finibus. Mauris et dolor a enim tempus bibendum. Cras eu cursus massa. Duis a ultricies risus. In hac habitasse platea dictumst. Nunc facilisis urna orci, eu dictum arcu sodales ut. Integer molestie tincidunt aliquet. Vivamus rhoncus nec lacus eget imperdiet. In ac pulvinar ipsum, nec feugiat leo. Vivamus id consequat erat, at faucibus dui. Ut dolor sapien, tempor ut risus at, scelerisque pretium quam. Sed et nibh quis urna hendrerit ornare. Cras id scelerisque neque. Nullam at varius tortor. Sed id mauris sit amet ligula commodo condimentum. Donec nec molestie risus, a vehicula ante. Integer sed erat mi. Curabitur condimentum nibh ut convallis ultricies. Nam et interdum lacus. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed consectetur, nulla vulputate posuere viverra, libero ex viverra eros, non viverra velit tellus ac felis. Aenean ultricies dui sed nisi fringilla, a ultricies ipsum cursus. Vestibulum sit amet sem enim. Quisque varius vestibulum dolor, ut placerat nibh euismod in. Aliquam sit amet mauris ante. Mauris in nisi nisi.  Nulla tristique ante enim, et eleifend nunc rutrum in. Nullam metus lorem, sollicitudin eget arcu a, tristique varius libero. Donec pharetra, ante a malesuada tincidunt, nisl ligula consectetur libero, in volutpat est augue sed sem. Duis suscipit justo purus, ac accumsan dolor pellentesque eget. Donec imperdiet scelerisque faucibus. Integer elementum augue et massa gravida, nec sodales metus dictum. Donec et semper massa.';

  //giardar dialogo
  void _showDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          backgroundColor: Colors.purple[50],
          title: const Text('Save Progress?'),
          content: const Text('Want to save this Note?'),
          actions: <Widget>[
            TextButton(onPressed: null, child: Text('Save')),
            TextButton(onPressed: (){ Navigator.of(context).pop(); } 
            , child: Text('Cancel'))
          ],
        );
      }
    );
  }

  //Refactor: title and button
  Card _tabTitle(String title) {
    return Card(
      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(6), ),
      child: Padding(
        padding: const EdgeInsets.all(8), // Slightly more padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FloatingActionButton( onPressed: null, tooltip: 'Delete Tab', child: Icon(Icons.delete), heroTag: Object(),),
            SizedBox(width: 16),
            Expanded( child: Text( title, style: TextStyle(fontSize: _fontSizeTitle, fontWeight: FontWeight.bold),maxLines: 10, overflow: TextOverflow.ellipsis, ), ),
            SizedBox(width: 8),
            Icon(Icons.tab),
          ],
        ),
      ),
    );
  }

  //Refactor: regresa un card que contiene el texto
  Card _tabText(text){
    return Card(
      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(6), ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Text(text),
      )
    );
  }

  //REFACTOR: Regresa todo un 'tab'
  SliverToBoxAdapter _tabContent(title, text){
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            color: Colors.deepPurple[200],
            child: Column(
              children: [
                _tabTitle(title),
                SizedBox(),
                _tabText(text)
              ]
            ), 
          )
        ),
      )
    );
  }

  //Refactor: crea un contenedor para el tag
  SliverToBoxAdapter _tagsContent(tag){
    return SliverToBoxAdapter(
      child: Padding(padding: const EdgeInsets.all(3),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            color: const Color.fromARGB(255, 100, 153, 174),
            child: Card(
              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(6), ),
              child: Padding(
                padding: const EdgeInsets.all(8), // Slightly more padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FloatingActionButton( onPressed: null, tooltip: 'Delete Tab', child: Icon(Icons.delete), heroTag: Object(),),
                    SizedBox(width: 8),
                    Expanded( child: Text( tag, style: TextStyle(fontSize: _fontSizeTag, fontWeight: FontWeight.bold),maxLines: 10, overflow: TextOverflow.ellipsis, ), ),
                    SizedBox(width: 8),
                    Icon(Icons.label),
                  ],
                ),
              ),
            )
          )
        )
      )
    );
  }

  //Refactor: Botones del fondo
  Widget _footerButtons(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(child: FloatingActionButton.extended(onPressed: null, label: Text('Add Tag'), icon: Icon(Icons.label), heroTag: 'BtnAddTag',)),
        SizedBox(width: 5),
        Expanded(child: FloatingActionButton.extended(onPressed: null, label: Text('Add Tab'), icon: Icon(Icons.add), heroTag: 'BtnAddTab',)),
        SizedBox(width: 5),
        FloatingActionButton(onPressed: _showDialog, tooltip: 'Save', child: const Icon(Icons.save), heroTag: 'BtnSaveNote',)
      ]
    );
  }

  //icono
  Widget _imageContainer(assetPath){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 3,),
        borderRadius: BorderRadius.circular(10)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(width: 100, height: 100, child: Image.asset(assetPath, fit: BoxFit.fitHeight))
      )
    );
  }

  //Refactor: icono de la nota, ademas de poder cambiar el color
  SliverToBoxAdapter _topIcon(assetPath){
    return SliverToBoxAdapter(
      child: Padding(padding: const EdgeInsets.all(3),
        child: Card(
          margin: EdgeInsets.all(1),
          color: const Color.fromARGB(255, 203, 62, 109),
          child: Padding(padding: const EdgeInsets.all(3),
            child: Row(
              children: [
                _imageContainer(assetPath),
                SizedBox(width: 10),
                Column(
                  children: [
                    ElevatedButton(onPressed: null, child:  Row (children: [Icon(Icons.photo), Text('Sacar Foto')])),
                    SizedBox(height: 10),
                    ElevatedButton(onPressed: null, child:  Row (children: [Icon(Icons.folder), Text('De Album')]))
                  ]
                )
              ]
            )
          )
        )
      )
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 53, 36, 102),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(                   //PARTE SUPERIOR DEL WIDGET
            backgroundColor: Colors.deepPurple,
            title: Row( children: [Icon(Icons.edit), SizedBox(width: 6), Text('Editing Page')]), //Titulo
          ),
          _topIcon('assets/images/spr_Test.png'),
          _tagsContent('Tag Uno'),
          _tagsContent('Tag Dos'),
          _tagsContent('Tag Tres'),
          _tabContent('Texto uno wow mira que tan largo es el texto wows wows wows wows wows wos', debugText),
          _tabContent('Titulo 2', debugText),
        ]
      ),
      bottomNavigationBar: BottomAppBar( color: Colors.deepPurple, child: _footerButtons(), ),
    );
  }
}

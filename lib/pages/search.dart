import 'package:flutter/material.dart';
import 'package:DoodleNote/pages/page.dart';

class SearchPage extends StatefulWidget{
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPage();
}



class _SearchPage extends State<SearchPage>{
  String _searchText = '';

    void _goToPage(){
    Navigator.push( context, MaterialPageRoute(builder: (context) => NotePageScreen()), );
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
            });
          },
        )
      )
    );
  }

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
        child: Card( margin: EdgeInsets.all(2), color: const Color.fromARGB(255, 227, 102, 138),
          child: ListTile(
            onTap: _goToPage,                                                                                      //AQUI PONER METODO DE NAVEGADOR
            leading: _imageContainer(assetPath),
            title: Text(title, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: fontTitleSize, fontWeight: FontWeight.bold , color: Colors.black)),
            subtitle: Text(date, style: TextStyle(fontSize: fontDateSize, fontWeight: FontWeight.bold , color: Colors.black)),
            trailing: Icon(Icons.search, color: const Color.fromARGB(255, 20, 1, 34))
          ) 
        )
      )
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 57, 29, 82),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/icons/DNSearchLogo.png', width: 50, height: 50 ,fit: BoxFit.fitHeight),
            Expanded(child: Text('Search', style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 28, 1, 44)))),
          ]
        )
      ),
      body: CustomScrollView(
        slivers: [
          _searchBarSliver(),
          _noteContent('assets/images/spr_Test.png', 'Doodle Note #1', '21/09/2025'),
          _noteContent('assets/images/spr_Test.png', 'Doodle Note #2', '21/09/2025'),
          _noteContent('assets/images/spr_Test.png', 'Doodle Note #3', '21/09/2025'),
          _noteContent('assets/images/spr_Test.png', 'Doodle Note #4', '21/09/2025'),
          _noteContent('assets/images/spr_Test.png', 'Doodle Note #5', '21/09/2025'),
          _noteContent('assets/images/spr_Test.png', 'Doodle Note #6', '21/09/2025'),
          _noteContent('assets/images/spr_Test.png', 'Doodle Note #7', '21/09/2025'),

        ],
      ) 
    );
  }
}
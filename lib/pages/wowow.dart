
import 'package:flutter/material.dart';
class EditingPage extends StatefulWidget {

  const EditingPage({super.key, required this.title});

  final String title;

  @override
  State<EditingPage> createState() => _MyEditingPage();
}

class _MyEditingPage extends State<EditingPage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.deepPurple,
            //title: Text('Editing'),             //titulo del widget (NOTA, NUNA AGREGAR ESTE SI BAS A PONER UNP EN FLEXIBLESPACEBAR)
            expandedHeight: 300,                  //height of our title
            //floating: false,                    //true = aparece apenas subes, false = apenas llegas a la cima, no existe
            pinned: true,                         //si el menu aparece en la cima si o no
            flexibleSpace: FlexibleSpaceBar(      //espacio flexible, cuando esta extendido
              background: Container(
                color: Colors.pink,
                
                //Card -> Padding -> Row (Container(ClipRRect(Imagen)) y Elegir Nueva Imagen(BOTON))
                child: Column( //COLUMNA PARA QUE NO ESTE JUNTO AL TITULO
                  children: [
                    Card( margin: EdgeInsets.all(10), color: Colors.redAccent,
                      child: Padding( padding: const EdgeInsets.all(8.0),
                        child: Row( children: [
                            Container(
                              decoration: BoxDecoration( border: Border.all(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(16) ),
                              child: ClipRRect( borderRadius: BorderRadius.circular(16),
                                child: SizedBox(width: 100, height: 100, child: Image.asset('assets/images/spr_Test.png', fit: BoxFit.fitHeight,),), //LA IMAGEN
                              )
                            ),
                            SizedBox(width: 30),
                            Column(
                              children: [
                                ElevatedButton(onPressed: null, child: Row( children:[ Icon(Icons.photo), Text('Sacar Foto'),]), ),
                                SizedBox(height: 20),
                                ElevatedButton(onPressed: null, child: Row( children:[ Icon(Icons.folder), Text('De Album'),]), ),
                              ]
                            ),
                            //PONER BOTON A ESCOGER NUEVA IMAGEN
                          ]
                        ),
                      ),
                    )
                  ],
                ), 
              ),
              
              title: Row( children: [Icon(Icons.edit), Text('Editing Page')]), //Titulo
            ),
          ),

          //sliver items
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 4000,
                  color: Colors.deepPurple[200],
                )
              )
            )
          )
        ]
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            FloatingActionButton(onPressed: null, tooltip:'Add tab', child: Icon(Icons.add)),
            FloatingActionButton(onPressed: null, tooltip:'Add tab', child: Icon(Icons.add)),
            FloatingActionButton(onPressed: null, tooltip:'Add tab', child: Icon(Icons.add))
          ],
        )
      )
    );
  } //return

}
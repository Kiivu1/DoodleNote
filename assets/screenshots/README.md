
# DoodleNote

"DoodleNote, the app where you write down on notes, the doodles of your thoughts"

DoodleNote es una aplicacion de notas, movil, la cual tiene como objetivo el poder facilitar la organizacion y la perzonalizacion de estas.

Como mayor atractivo tiene el poder estructurar la nota mediante pestañas, partiendo la informacion necesaria. Aparte de eso permite la inclusion de Tags, los cuales permiten identificar las notas de manera rapida. Por ultimo tambien esta la capacidad de añadir una imagen a la nota de por si.
## Caracteristicas y Funcionalidades

- Habilidad de crear, editar, guardar y eliminar.
- El usuario puede crear secciones dentro de la nota mediante pestañas, permitiendo un mayor control e informacion en este.
- Habilidad de crear etiquetas, o *tags*, que permiten mayor perzonalizacion/filtracion.
- Poder asignar un icono/imagen a la nota. Desde la camara o el album de fotos.
- Pagina de busqueda para filtrar notas.
- Modo de Lectura de la nota.
- Modo de edicion de la nota.
- Configuracion a aspectos sobre la presentacion de la aplicacion
- Posibilidad de enviar Feedback al desarrollador

## Capturas de pantalla
<p align="left">
    <img src="assets/screenshots/4" alt="DoodleNote, Home screen" width="300"/>
    <img src="assets/screenshots/2" alt="DoodleNote, Notes page" width= "300"/>
    <img src="assets/screenshots/3" alt="DoodleNote, Edit screen" width="300"/>
    <img src="assets/screenshots/1" alt="DoodleNote, Configuration screen" width="300"/>
</p>

## Pila de Tecnologia
- SDK de flutter
- flutter_lints
- logger
- cupertino_icons
- flutter_launcher_icons
- flutter_native_splash
- shared_preferences
- provider
- path_provider
- image_picker
- permission_handler
- path
- image_gallery_saver_plus
- flutter_speed_dial
- url_launcher
- share_plus
- change_app_package_name



## Diagrama de Flujo
```mermaid
    flowchart TD
        Home[fa:fa-home Home Page]
        NotePage[fa:fa-file Note Page]
        NoteEditor[fa:fa-pencil Note Editor]
        SearchPage[fa:fa-search Search Page]
        config[Configuration]
        about[About]

        Act{fa:fa-user ¿Que quiero hacer?}
        Act2{fa:fa-user ¿Quiero eliminarla?}
        Act3{fa:fa-user ¿Guardo la nota?}
        Act4{fa:fa-user ¿Edito la nota?}

        Home --> Act
        Act --> |Buscar una Nota| SearchPage
        Act --> |Leer una Nota| Y(Apretar una Nota) --> NotePage
        Act --> |Crear una Nota| R(Apretar crear una nota) --> NoteEditor
        Act --> |Modificar la aplicacion| Z(Apretar configuraciones) --> config
        Act --> |Ver sobre la aplicacion| P(Apretar About) --> about

        config --> Home
        about --> T(Mandar Feedback)
        about --> Home

        SearchPage --> U(Apretar nota filtrada) --> NotePage
        NotePage --> Act4 --> |Si| I(Apretar editar) -->NoteEditor
        NoteEditor --> Act3
        Act3 --> |Si| Q(Apretar guardar cambios) --> NotePage

        NotePage --> Act2 --> |Si| D(Apretar eliminar nota) --> Home & SearchPage
```

## Links
[Link al video](https://youtu.be/X6v998YmYdI)
[Descargar APK](https://drive.google.com/drive/folders/1dCXJV_R9-zCJJeZi4rBgyQ0YPDKJ5xcP?usp=sharing)
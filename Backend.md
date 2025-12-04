Configuración de Backend para la Versión Clonada

Este documento explica los pasos necesarios para configurar el proyecto DoodleNote con su propia instancia de Firebase, permitiendo que la sincronización en la nube y otras funcionalidades dependientes de secretos funcionen.

El proyecto ignora archivos críticos de configuración y credenciales por motivos de seguridad, por lo que deben ser generados y colocados manualmente.

1. Archivos Criticos de configugracion para el proyecto

Los siguientes archivos son ignorados por .gitignore y deben ser obtenidos de la consola de Firebase e insertados en las rutas especificadas:

Archivo                  /              Plataforma                / Ruta
google-services.json                     Android            android/app/google-services.json

2. Pasos Detallados para la Configuración

Para poner en funcionamiento el "backend" de Firebase en una copia del proyecto, sigue estas instrucciones:

A. Configuración de Firebase
    1. Crear Proyecto en Firebase: Acceder a la consola de Firebase y crear un nuevo proyecto (Ej: "DoodleNote Clone").
    2. Activar Servicios: Dentro del nuevo proyecto de Firebase, activar los siguientes servicios (si son requeridos por la aplicación, como la sincronización):
        - Authentication: Habilitar el proveedor de inicio de sesión de Google.
        - Firestore Database: Crear la base de datos (iniciar en modo de prueba o con reglas de seguridad adecuadas).
    3  Añadir Aplicaciones: Registrar las aplicaciones de Android e iOS en el proyecto de Firebase:
        - Android: Registrar con el package name de la aplicación (Ej: com.ejemplo.doodlenote). Descargar el archivo google-services.json.

B. Inserción de Archivos de Configuración
    1. Archivo Android (google-services.json): Mover el archivo descargado a la ruta android/app/.

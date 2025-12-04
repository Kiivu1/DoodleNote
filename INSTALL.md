Configuración y Arranque de Proyecto (INSTALL.md)

Este documento es mandatorio para el arranque del proyecto. Debido a que las claves privadas de configuración de Google/Firebase han sido cifradas y excluidas del repositorio (vía .gitignore), es necesario recrear la estructura de archivos secretos para que la aplicación compile y funcione correctamente.

1. Archivos Secretos Requeridos

Asegúrese de contar con las siguientes 4 claves y de que estén ubicadas en sus rutas exactas:

Archivo                             /Proposito                                                                  /  Ruta 
.env            Contiene claves API de Google/Firebase y variables de entorno cifradas.                 Raíz del proyecto 
google-services.json        Configuración nativa para conectar Android con Firebase.                    android/app/
upload-keystore.jks         Archivo de firma digital para generar el APK (La llave del cofre).          android/app/
key.properties              Contraseñas para el almacén de claves (.jks) (La combinación del cofre).    android/



2. Creación y Ubicación de Archivos

2.1. Archivo: .env 

# Contenido de ejemplo para .env (reemplazar con datos reales)
FIREBASE_API_KEY=TuClaveAPI_Proporcionada
ENCRYPTION_SECRET=TuClaveSecretaDeCifrado

2.2. Archivo: google-services.json (Configuración de Android)

# Este archivo se obtiene de la Consola de Firebase al configurar la aplicación Android.

2.3. Archivo: upload-keystore.jks (Firma de Android)
Este archivo es el almacén de claves utilizado para firmar las versiones de producción de la aplicación.

2.4. Archivo: key.properties (Credenciales de Firma)
Contiene las contraseñas necesarias para leer el archivo .jks (upload-keystore.jks).

Acción: Debe crear manualmente este archivo con sus credenciales de firma:

# Comandos

storeFile=app/upload-keystore.jks
storePassword=TU_PASSWORD_DE_ALMACEN
keyAlias=TU_ALIAS_DE_CLAVE
keyPassword=TU_PASSWORD_DE_CLAVE

3. Pasos Finales de Arranque

Una vez que los 4 archivos han sido colocados en sus rutas correctas, el proyecto está listo para ser ejecutado:

flutter clean
flutter pub get
flutter run(en caso de querer hacerlo manualmente si no ejecutar desde visual studio)


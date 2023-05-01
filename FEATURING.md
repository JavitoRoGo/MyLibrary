# Now featuring:

### Aquí se irán recogiendo las mejoras o nuevas funcionalidades que estén actualmente en desarrollo. Funcionará como un diario o lista de tareas del trabajo en curso.

### Una vez terminado un nuevo feature, se borrará el registro y se agregará como descripción de una nueva versión en README.md.

#

# Trabajo con ramas de Git.

### Sin llegar a implantar git-flow, la idea es hacer algo similar:

* Mantener la rama main solo para la app en producción.
* Usar una rama develop directamente desde main, para usarla como punto intermedio y previo a hacer merge hacia main.
* Usar una rama feature y parte del nombre del feature para identificarla, a partir de develop, y hacer ahí las pruebas y nuevos desarrollos.

#

## Descarga de imágenes de portada de OpenLibrary API.

La idea es descargar la imagen al crear el registro en la lista de espera y guardarla en local.

* ~~Usar la función que ya existe para crear el nombre de la imagen.~~
* ~~Añadir botón o confirmationDialog para elegir entre descargar la imagen o elegirla del carrete como hasta ahora.~~
* ~~Añadir progressview mientras se descarga la imagen.~~
* ~~Añadir confirmationDialog para elegir entre carrete o cámara en ActualReadingEdit. ¿También aquí que se descargue? Ya debería estar descargada al crear el registro en AddReading.~~
* ¿Mostrar alerta informando por qué no se encuentra la imagen?

## Modificar UserMainView.

* ~~Añadir confirmationDialog para elegir entre carrete o cámara para la foto de perfil.~~

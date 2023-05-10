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
* ~~¿Mostrar alerta informando por qué no se encuentra la imagen?~~
* ~~En AddReading añadir opción de búsqueda de portada por autor, título o isbn si está en la base de datos.~~
* ~~Cambiar la lógica de descarga de imagen en ActualReadingEdit por AsyncImage.~~


## DownloadCoverView.

* ~~Implementar la lógica para buscar en la API por título y/o autor. Obtener el id o isbn de esos resultados para buscar las covers.~~
* ~~Implementar la lógica de búsqueda directa de cover por isbn.~~
* ~~Eliminar la búsqueda por autor. Poner la búsqueda por isbn como primera opción por funcionar mejor.~~
* ~~Pasar la función de descarga a otra página (Functions?) e intentar factorizarla.~~
* ~~A modo de prueba, volver a implementar la función de descarga en la propia vista para ver si da mejores resultados en la primera búsqueda o también hay que buscar varias veces.~~ Cambiado porque funciona mejor.


## Modificar UserMainView.

* ~~Añadir confirmationDialog para elegir entre carrete o cámara para la foto de perfil.~~


## Google Books API.

* OJO, ya sé cómo usar Google Books API, y buscar por título, autor o isbn. El resultado que devuelve es más fácil de tratar, sobretodo la búsqueda por autor, y ya incluye la imagen.
* ¿Sustituir la búsqueda de OpenLibrary por Google Books? ¿Añadir un botón al menú para usar las dos búsquedas?
* En caso de optar por Google Books incluir la búsqueda por autor.
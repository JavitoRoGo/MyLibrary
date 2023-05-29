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

## Mejorar la descarga de imágenes.

Con lo visto en *Concurrency ByExample* mejorar la descarga de imágenes de portada. Tratar de pasar la función de descarga downloadCoverFromAPI que está en DownloadCoverView a un archivo independiente.

* ~~Pasar la función de descarga a un archivo independiente creando una nueva función con valor de retorno para las imágenes descargadas.~~
* ~~Sustituir URLSession.shared.dataTask por URLSession.shared.data, que sí es puro código async/await.~~
* ~~Dividir la función en varias funciones que usen async. Como las nuevas funciones finales dependerán del resultado de las primeras, reunir los resultados en una última función también con async.~~
* ~~Mejorar la lógica creando un TaskGroup con el bucle for-in dentro.~~
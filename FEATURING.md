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

# maps

### Actualizar las vistas de mapas a iOS 17, añadiendo alguna nueva feature.

* Adaptar las vistas de mapas a los nuevos cambios de iOS 17: Marker, Annotation, UserAnnotation, UserLocationButton, CompassButton...
* Usar safeAreaInset para los botones: ¿añadir pin? ¿user location?
* En la vista del mapa general con todos los ReadingData, al pulsar sobre un pin que muestre info en una ventana flotante regulable: título, autor, portada, lookAround...
* En la vista del mapa para cada registro individual, sustituir el icono por Annotation con la portada.


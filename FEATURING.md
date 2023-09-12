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

# covers

### Incluir portadas en books y ebooks igual que en leyendo: foto, carrete o descarga.

* ¿Nueva propiedad cover String opcional en el modelo de datos? ¿O generar cover cada vez con la función imageCoverName?
* Elegir portada al crear nuevo libro y ebook, y también en Editar.
* Nueva vista de portadas en grid en cualquiera de las vistas actuales: por lugar, propietario, estado...
* Cambiar de vista con botón como estaba inicialmente en ReadingData.
* En la vista en grid mostrar una portada genérica con título si no se dispone de ninguna, como en epublibre.
* Mostrar portada también en la vista detalle, pero solo si existe.

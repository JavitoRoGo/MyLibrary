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

# booksview

### Cambios en vista Todos de libros

* Hecho. Cambiar también la vista principal de ebooks para incluirla en un scroll.
* Hecho. Eliminar el scroll por place de la vista principal de libros.
* Hecho. Añadir vista para elegir filtrar por ubicación, autor, editorial, edición, año y año de escritura.
* Hecho. Crear la vista por autores, con DisclosureGroup por letra, y autor.
* Hecho. Repetir para los otros casos.
* En la vista de sesiones de lectura y gráfica, al entrar en el detalle de la lista de sesiones, eliminar el botón para ver la gráfica de la parte superior para los casos de Año y Total del picker.
* Hecho. Para Año mostrar el listado de sesiones con disclosure group por mes (y usarlo para obtener también los datos para la gráfica).
* Hecho. Para Total mostrar el listado por año y mes (y usar el agrupado por años para la gráfica).
* Hecho. Añadir vista vacía a las vistas chunked si no hay datos.

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

* Cambiar también la vista principal de ebooks para incluirla en un scroll.
* Eliminar el scroll por place de la vista principal de libros.
* Añadir vista para elegir filtrar por ubicación, autor, editorial, edición, año y año de escritura.
* Crear la vista por autores, con DisclosureGroup por letra, y autor.
* Repetir para los otros casos.
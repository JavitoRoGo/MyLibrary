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

# userview

### Cambios en la vista de usuario

* Crear nueva vista para las opciones de configuración, y dejar en la vista principal los accesos a objetivos, notas y cerrar sesión.
* ¿Acceder a la nueva vista con botón en toolbar o botón en la lista?
* En la nueva vista incluir la vista de portadas por defecto y los botones de borrado.
* Incluir nueva feature de selección de modo claro y oscuro, o según sistema.
* Incluir nueva feature para importar y exportar el json. ¿También las imágenes? En ese caso, exportar todas las imágenes, de Archivos y Bundle.
* ¿Importar el nuevo json y sobreescribir los datos actuales? ¿O hacer una especie de merge?
* Eliminar el botón de exportar actual de ReadingList.

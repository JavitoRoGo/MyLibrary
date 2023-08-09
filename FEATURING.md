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

# Refactoring

## Refactorizar todo el código mediante el uso de extensiones.

Uso de extensiones para las vistas en aquellos casos que merezca la pena, pasando a las extensiones propiedades calculadas, métodos y modificadores de vista.
Solo en aquellos casos en los que aporte algo para reducir el archivo con la vista; si los modificadores o métodos son pocos o de pocas líneas, no pasarlos a una extensión.

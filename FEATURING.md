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

# yearnoenum

### Eliminar el enum Year y pasar ese parámetro a Int.

* Eliminar el enum Year.
* Cambiar la propiedad finishedInYear de ReadingData a Int.
* Recodificar todo lo relacionado con Year para trabajar con datos tipo Int.
* La propiedad finishedInYear se debe generar sola en función de la fecha.

# ownerinuser

### Eliminar lista de owners del viewmodel y pasarlo a User igual de las ubicaciones.

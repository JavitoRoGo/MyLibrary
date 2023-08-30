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

# onemodel

## Unificar todos los viewmodel (book, ebook...) en uno solo, asocido a User. Unificar todos los archivos JSON en uno solo, con todos los datos asociados al user.

También se arreglan todos los fallos que se producen al iniciar la app desde cero y sin datos.

#

# yearDAta

## Selección de los años en función de las fechas de las sesiones y no a mano.

Arreglar la gráfica Clásica que muestra los datos globales por año: modificar la función que llama los datos, *graphData(tag: Int) -> [Double]* en RSModelExt. Hacer que los años se creen en función de las fechas de las sesiones y no a mano.
También añadir datos vacíos a la gráfica de Mes y Semana en caso que no haya datos suficientes para representar todo el mes o toda la semana.

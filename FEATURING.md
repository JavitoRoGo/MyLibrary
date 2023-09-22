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

# upgrade

### Actualizar a iOS17. Además, cambiar la lógica de modelos y persistencia según tutorial de jcfmunoz para adoptar el patrón singleton y la nueva API Obervation.

Son varios cambios, pero cambios grandes que implican casi una restructuración completa, al menos de los modelos. Las vistas se mantienen igual, salvo los cambios necesarios al adoptar la nueva API Observation.

* Subir el minimum deployment target a iOS17.
* Pasar las extensiones del modelo a final class que hereden del modelo.
* Usar el patrón singleton en todas las clases para que todas las llamadas lo hagan a los mismos datos.
* Mejorar el Preview Content con datos "reales": json con un par de libros, de registros...
* Usar la arquitectura del ejemplo de Julio con un viewmodel global, varios modelLogic, y persistencia para producción y para la preview.
* Cuando todo esté funcionando, cambiar a Observation.
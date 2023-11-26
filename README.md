# MyLibrary App-v1.0
#

## App iniciada el 30/12/2021, y no ha parado de evolucionar desde entonces.

#

### El propósito de la app es servir de base de datos para libros en papel y ebooks, y llevar un registro de los leídos: tiempo, sesiones, valoración, etc.
### Posteriormente se agregó un registro para libros en lectura y en espera, con un temporizador y la posibilidad de agregar notas a las sesiones.
### También contienen diferentes gráficas de las sesiones, estadísticas de los libros, ebooks y registros de lectura.

#

App iniciada antes de tener conocimientos de Git, por lo que todo lo desarrollado hasta la fecha de creación del repositorio (25/04/2023) carece de comentarios o commits.

Al no tener un sistema implantado de gestión de versiones hasta el 25/04/23, el estado actual de la app se tomará como v1.0 y se etiquetará con el correspondiente tag.

Características principales de la app:

* Desarrollada en SwiftUI usando librerías propias de Apple.
* Uso de listas, botones, menús, alertas, scrollviews, geometry readers, mapas, gráficas, picker y datepikcer, imagepicker, etc.
* Inicialmente se inició con un target único para iOS. Luego se agregó un target para macOS y se desarrolló durante un tiempo, pero se acabó eliminando.
* Cuenta con varios widgets en diferentes tamaños.
* Target para watchOS. Uso de 
ConnectivityManager para conectar con iOS.
* Persistencia de datos con JSON y Codable. Temporalmente se usó CoreData de forma paralela a modo de prueba, pero se descartó.
* Los libros llevan asociados un propietario y una ubicación en una estantería (además de todos los datos típicos de autor, título, editorial, etc.). Posibilidad de crear, editar y borrar tanto los propietarios como las ubicaciones. La lista de propietarios es compartida con los ebooks.
* Uso de TabView para vistas de libros en lectura, gráficas por sesión, libros con registro, biblioteca, y datos del usuario.
* Petición de usuario y contraseña para registrarse en la app y posibilidad de login con biometrics. Uso de comprobador de contraseña y almacenamiento en keychain.
* Uso de un contador de tiempo para las sesiones de lectura, que funciona también en segundo plano. Se puede añadir un comentario o cita en cada sesión, así como un comentario general al libro.
* Se muestran varias gráficas en diferentes puntos de la app. Inicialmente se crearon las gráficas pintando elementos con GeometryReader (se han dejado en la app a modo de ejemplo), pero luego se crearon otras nuevas a partir de la publicación de SwiftCharts. Hay gráficas de páginas por sesión (semanales, mensuales...), de libros registrados, libros por autor, ubicación, etc. Gráficas de línea, de barras, de sectores.
* Uso de diferentes animaciones: al presentar las gráficas, al tocar una portada de los registros en el carrusel horizontal, efecto confetti...
* Lo último en añadirse es la vista de un mapa con la ubicación en la que se ha leído el libro. Esta ubicación puede agregarse y modificarse.

#

## v1.1

* Se añade funcionalidad para poder descargar la portada del libro en lectura, tanto al añadirlo a lista de espera como desde la vista de edición de ese libro. Opción activa solo para libros en papel, porque la descarga se hace desde OpenLibrary API con ISBN.

### v1.1.1

* Se añade funcionalidad para descargar la portada buscando por título, autor o ISBN, tanto para papel como ebook. La descarga se hace desde la API de GoogleBooks.

### v1.1.2

* Se mejora y optimiza el código de descarga de portada mediante el uso de async/await con URLSession y TaskGroup.

### v1.1.3

* Cambios internos en la app. Se refactoriza todo el código para ordenarlo y evitar MVC (massive view controlers), mediante el uso de extensiones para métodos, propiedades calculadas y view modifiers.


## v1.2

* Se recodifica gran parte de la app para unificar todos los ViewModel en uno solo: los ViewModel existentes pasan a ser conformados como extensiones de UserViewModel, que permanece como único modelo. Se eliminan los json y todos los datos pasan a estar dentro de User.
* Se corrigen los fallos al intentar mostrar las sesiones o ReadingData si no hay datos, cuando se inicia la app desde cero. Si no hay datos se muestra una imagen de fondo y un texto. Y se deshabilitan los botones de estadísticas para Books y EBooks.
* Se añaden datos vacíos a las gráficas de sesiones para mostrar el periodo completo aunque no haya datos: semana, mes o año.
* Para la gráfica clásica total, se recodifica para que los años se generen a partir de los propios datos y no de forma manual.
* Se modifica la vista de edición de NowReading para que pueda descargarse la portada también para los ebook.
* Se elimina el enum de Year y se pasa a Int, generándose a partir de las fechas de las sesiones.
* Se traslada la lista de propietarios del viewmodel a una propiedad de User.
* Se arregla un fallo al grabar una nueva sesión, que hacía que no se grabara en sessions en el json.
* Se modifica la creación de nuevo user para asignarle un id nuevo.


### v1.2.1

* Se añade la opción de borrar un libro en lista de espera aunque tenga datos de lectura. Al borrar el libro se pregunta si mantener las sesiones o borrarlas.
* En la vista de Usuario se añaden botones para borrar todos los datos registrados y mantener el usuario, o para eliminar el usuario y sus datos.
* Las funciones de cambio de tiempos entre String<- ->Double se eliminan como tal y se reescriben como extensiones de String y Double. También alguna función para fechas como extensión de Date.
* Se eliminan las funciones de formateado de números y se sustituye por código de formato nativo de SwiftUI.


## v1.3

* Se añade la funcionalidad de poder elegir una portada para libros y ebooks, tanto al crear uno nuevo como al editarlo en la vista detalle correspondiente. Se puede elegir entre seleccionar una imagen existente, hacer foto, o descargar la portada.
* Opción de lista o vista de parrilla de portadas al listar los libros y ebooks.
* Opción de elegir por defecto entre lista y parrilla en la vista de usuario.
* Se muestra la portada, si existe, en la vista detalle.
* En la vista en parrilla se muestra solo el título si la imagen de portada no existe.

* Se crea una nueva vista para las opciones de configuración, dejando en la vista principal los accesos a objetivos, notas y cerrar sesión.
* En la nueva vista de configuración se añade la opción de elegir entre modo claro y oscuro, vista por defecto para las portadas (o en lista), y poder compartir los datos como json, importarlos o exportarlos.


# v2.0

* Actualización a iOS 17.
* Se adopta la nueva API Observation para el modelo principal, mientras que se mantiene la estructura anterior con ObservableObject para las preferencias de usuario y la comprobación de contraseña.
* Adopción del patrón singleton para los modelos, con modelLogic y un viewmodel global.
* Mejora del Preview Content con datos para las previews.
* Se cambian las vistas de mapas que muestran la ubicación de los libros según las novedades de iOS 17.
* Se muestra información sobre cada libro al pulsar sobre su icono en los mapas.
* Y en el mapa que muestra la ubicación de cada libro, se muestra su portada y la vista lookAround al pinchar sobre el icono.


### v2.0.1

* Cambios menores que mejoran el rendimiento de vistas con scroll, al utilizar LazyVStack y LazyHStack.
* Se eliminan los indicadores de desplazamiento en varios scrolls.
* Se añade una vista de contenido no disponible a vistas con opción de búsqueda, en caso de no encontrar resultados.


## v2.1

* Se elimina el uso de keychain para guardar la contraseña, que pasa a guardarse junto a los datos de usuario, aplicando un hash.

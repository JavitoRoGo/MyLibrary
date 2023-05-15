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

# v1.1

* Se añade funcionalidad para poder descargar la portada del libro en lectura, tanto al añadirlo a lista de espera como desde la vista de edición de ese libro. Opción activa solo para libros en papel, porque la descarga se hace desde OpenLibrary API con ISBN.

## v1.1.1

* Se añade funcionalidad para descargar la portada buscando por título, autor o ISBN, tanto para papel como ebook. La descarga se hace desde la API de GoogleBooks.

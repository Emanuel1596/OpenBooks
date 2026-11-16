# Navegación y estado de OpenBooks

OpenBooks utiliza `NavigationStack` para navegar entre Inicio, Buscar, Resultados y Detalle. Mis favoritos comparte la misma información de libros guardados, por lo que no necesita mantener otra colección independiente.

## Recorridos principales

```text
Inicio → sugerencia → Detalle → Agregar a favoritos → Mis favoritos
Inicio → Buscar → Resultados → Detalle
Mis favoritos → libro guardado → Detalle → Quitar de favoritos
```

Cuando no hay resultados o favoritos guardados, se muestra un mensaje dentro de la pantalla correspondiente. Los errores de conexión y los indicadores de carga también se presentan sin abrir pantallas adicionales.

## Responsabilidades de cada pantalla

| Pantalla | Función |
| --- | --- |
| `HomeView` | Muestra las sugerencias, la ilustración de Inicio y el acceso al buscador. |
| `SearchView` | Permite escribir y enviar una consulta mediante el teclado. |
| `SearchResultsView` | Muestra los resultados o los estados de carga, error y sin coincidencias. |
| `BookDetailView` | Muestra la información del libro y la acción para agregarlo o quitarlo de favoritos. |
| `MyBooksView` | Muestra los libros guardados y su estado vacío. |
| `ContentView` | Coordina las rutas y las acciones que cambian de pantalla. |

## Navegación

`ContentView` conserva `path: [Int]` y utiliza `navigationDestination(for: Int.self)` para abrir cada destino. Los valores especiales `-2` y `-1` identifican Buscar y Resultados, respectivamente. Los índices válidos de `BooksState.books` identifican los libros que pueden abrirse en Detalle.

La barra inferior permite volver a Inicio o abrir Mis favoritos. Después de guardar o quitar un favorito, la navegación regresa a Mis favoritos **solo si el almacenamiento confirma que la operación se realizó correctamente**.

## Estado de búsqueda

`ContentView` utiliza dos instancias de `SearchViewModel`: una para las sugerencias de Inicio y otra para la consulta escrita por el usuario. Ambas utilizan un servicio que cumple `BookSearchService`, pero conservan sus estados por separado.

`SearchViewModel` administra el texto de búsqueda, los índices de resultados y estos estados:

- `.loading`: la solicitud está en curso.
- `.content`: existen libros para mostrar.
- `.noResults`: la búsqueda terminó sin coincidencias.
- `.error(String)`: ocurrió un problema y se muestra su mensaje.

La búsqueda entra en estado de carga al enviarse, antes de recibir una respuesta. Así no se presenta incorrectamente «sin resultados» mientras se están descargando los libros.

Inicio puede recuperar sugerencias almacenadas temporalmente en `UserDefaults`, mientras realiza una nueva consulta. Si el servicio falla y ya había libros cargados, conserva esos resultados.

## Estado de los libros y favoritos

`BooksState` es la fuente compartida de libros y del indicador `isSaved`. Cuando llegan libros desde la búsqueda, combina los resultados usando su identificador para evitar duplicados y conservar datos de la obra que ya se hubieran recibido.

El guardado y la eliminación se solicitan mediante `BooksState.toggleSaved(at:)`, que utiliza el contrato `FavoriteBooksStore`. `SavedBooksRepository` implementa ese contrato con SwiftData. Si falla la operación, el estado de favorito no se confirma y se muestra un aviso.

El detalle obtiene descripción y temas desde `OpenLibraryBookDetailsService` cuando es necesario, y `BooksState` actualiza los datos de la colección compartida. El año se muestra solo cuando existe. Las portadas descargadas pueden reutilizarse desde la caché local.

## Componentes y accesibilidad

Los componentes visuales se reutilizan desde `Views/Components/`. Se emplean `VStack`, `HStack`, `LazyVGrid`, `ScrollView` y modificadores de SwiftUI para organizar el contenido. La interfaz incorpora identificadores y etiquetas de accesibilidad en elementos importantes, además de colores para ambos modos de apariencia.

Para ver la estructura completa y la comunicación con Open Library, consulta [Arquitectura y servicios](arquitectura-y-servicios.md).

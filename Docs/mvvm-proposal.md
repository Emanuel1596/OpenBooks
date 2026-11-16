# Organización MVVM de OpenBooks

El proyecto separa las pantallas, los datos y las operaciones externas para que cada parte tenga una responsabilidad clara. La interfaz utiliza SwiftUI y comparte los libros y sus favoritos mediante estado observable.

## Modelos

- `Book`: datos utilizados para mostrar un libro. Incluye identificador, título, autor, año opcional, portada y la información descriptiva disponible.
- `SavedBook`: modelo `@Model` que SwiftData utiliza para conservar los favoritos.
- `OpenLibrarySearchResponse`, `OpenLibraryBookDTO` y `OpenLibraryWorkResponse`: estructuras que decodifican el JSON recibido de Open Library.

## Vistas

`HomeView`, `SearchView`, `SearchResultsView`, `BookDetailView` y `MyBooksView` muestran la información y permiten interactuar con ella. `ContentView` organiza la navegación. Los elementos repetidos, como las portadas, la barra inferior y los colores, se encuentran en `Views/Components/`.

Las vistas no realizan consultas directas a SwiftData ni construyen las direcciones de la API. Cuando el usuario realiza una acción, utilizan el estado compartido o solicitan la operación correspondiente mediante el servicio recibido.

## Estado y lógica de presentación

- `SearchViewModel` administra el texto de búsqueda, los índices de los libros encontrados y el estado de la consulta. También puede recuperar sugerencias recientes desde `UserDefaults`.
- `BooksState` mantiene los libros de la aplicación, combina resultados usando sus identificadores y actualiza cuáles están guardados como favoritos.
- `SearchViewState` distingue carga, contenido, ausencia de resultados y error.

`OpenBooksApp` crea las dependencias y entrega la instancia compartida de `BooksState` a `ContentView`. De esta manera, Detalle y Mis favoritos leen el mismo estado.

## Servicios

- `OpenLibraryBookSearchService` consulta libros con `URLSession` y `async/await`.
- `OpenLibraryBookDetailsService` obtiene la descripción y los temas de una obra cuando están disponibles.
- `SavedBooksRepository` utiliza SwiftData para consultar, insertar, eliminar y actualizar favoritos.
- `FavoriteBooksStore` y `BookSearchService` definen contratos que permiten sustituir las dependencias por versiones controladas durante las pruebas.

## Flujo de búsqueda

```text
Buscar → SearchViewModel → BookSearchService → Open Library
                           ↓
                    BooksState agrega los libros
                           ↓
                   Resultados muestra el estado
```

## Flujo de favoritos

```text
Detalle → ContentView → BooksState → FavoriteBooksStore
                                     ↓
                               SwiftData guarda
                                     ↓
                           Mis favoritos se actualiza
```

## Organización de archivos

```text
OpenBooks/
├── Models/
├── Services/
├── ViewModels/
├── Views/
│   └── Components/
├── Assets.xcassets/
└── OpenBooksApp.swift

OpenBooksTests/
```

La organización permite cambiar una vista sin tener que modificar cómo se descargan los libros o cómo se guardan sus datos. Para obtener detalles de los endpoints, la persistencia y las limitaciones, consulta [Arquitectura y servicios](arquitectura-y-servicios.md).

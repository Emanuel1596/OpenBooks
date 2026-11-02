# Arquitectura y separación de responsabilidades — OpenBooks

## 1. Contexto actual

OpenBooks aplica **una organización progresiva basada en MVVM**. No se creó un ViewModel para cada pantalla: se separaron responsabilidades conforme aparecieron necesidades concretas. El catálogo y la búsqueda continúan utilizando datos locales; la colección **Mis favoritos** ya se conserva con SwiftData.

## 2. Componentes y responsabilidades

| Componente | Ubicación | Responsabilidad |
| --- | --- | --- |
| `Book` | `OpenBooks/Models/Book.swift` | Representar un libro de la interfaz, con título, autor, año opcional, género, sinopsis y temas, además de su identificador y `isSaved`. |
| `SavedBook` | `OpenBooks/Models/SavedBook.swift` | Modelo `@Model` de SwiftData para la colección guardada. |
| `MockBooks` | `OpenBooks/Mocks/MockBooks.swift` | Proveer diez libros locales de demostración. |
| `SavedBooksRepository` | `OpenBooks/Services/SavedBooksRepository.swift` | Leer, insertar, eliminar y guardar registros `SavedBook` mediante `ModelContext`, evitando duplicados. |
| `SearchViewModel` | `OpenBooks/ViewModels/SearchViewModel.swift` | Mantener `searchText`, `state`, `resultIndices` y calcular los resultados del prototipo. |
| `SearchViewState` | `OpenBooks/ViewModels/SearchViewState.swift` | Representar los estados de resultados. |
| `BooksState` | `OpenBooks/ViewModels/BooksState.swift` | Coordinar los libros visibles y reflejar los favoritos leídos desde SwiftData; solicitar guardado o eliminación al repositorio. |
| `ContentView` | `OpenBooks/Views/ContentView.swift` | Coordinar `NavigationStack`, rutas, sección activa, acciones y carga inicial de favoritos; mostrar errores de persistencia. |
| Vistas de pantalla | `OpenBooks/Views/` | Presentar Inicio, Buscar, Resultados, Detalle y Mis favoritos. |
| Componentes | `OpenBooks/Views/Components/` | Reutilizar portadas, filas, barra inferior y estado vacío. |
| `OpenBooksApp` | `OpenBooks/OpenBooksApp.swift` | Crear la escena e inyectar el contenedor de SwiftData. |

## 3. Búsqueda

`SearchView` recibe el texto como `@Binding`. `ContentView` lo conecta con `SearchViewModel` mediante `@Bindable` y solicita `searchBooks()` al presionar Enter. El ViewModel determina los índices y el estado de Resultados. La búsqueda solo reconoce las cadenas exactas «Harry Potter» y «Orgullo y prejuicio»; los demás textos producen `.noResults`. La lógica no usa una API y no activa actualmente los estados de carga o error.

## 4. Favoritos y persistencia

La fuente duradera de favoritos es **SwiftData**, no una segunda colección persistente en cada vista. `OpenBooksApp` registra `SavedBook` con `.modelContainer(for: SavedBook.self)`.

Al aparecer `ContentView`, se crea un `SavedBooksRepository` con el `ModelContext` del entorno y se invoca `booksState.loadFavorites(using:)`. El método consulta los identificadores guardados y actualiza los indicadores `isSaved` de los libros locales. Al tocar Agregar/Quitar de favoritos:

1. `BookDetailView` avisa mediante `onSaveOrDelete`.
2. `ContentView` pide a `BooksState` que ejecute `toggleSaved(at:using:)`.
3. `BooksState` utiliza `SavedBooksRepository` para guardar o borrar `SavedBook`.
4. `BooksState` recarga los identificadores persistidos y SwiftUI refleja el resultado; `ContentView` navega a Mis favoritos.
5. Ante un error se muestra una alerta y no se navega como si la acción hubiera sido exitosa.

El modelo persistente almacena `bookID`, título, autor, año opcional y disponibilidad de portada. `Book` mantiene los datos de presentación, entre ellos género, sinopsis y temas. Los identificadores del catálogo de prueba se derivan del autor y el título; la integración futura con Open Library deberá usar su identificador estable.

**Límite actual:** `BooksState` reconstruye la colección visible a partir de `mockBooks`. El registro persistido contiene datos para mostrar un libro, pero la app todavía no incorpora libros guardados que estén fuera de ese catálogo local. Esto debe ampliarse al integrar la API.

## 5. Estado y navegación

- `@State` en `ContentView` mantiene el objeto de búsqueda, el estado compartido de libros, la ruta de navegación y la sección Inicio/Mis favoritos.
- `@Bindable` y `@Binding` conectan el texto editable sin mantener una segunda copia.
- `NavigationStack` y `navigationDestination(for: Int.self)` reciben índices de libros o rutas especiales de búsqueda/resultados.
- `SearchResultsView`, `HomeView` y `MyBooksView` reciben información y acciones, pero no acceden directamente a `ModelContext`.
- El detalle conserva el botón de favoritos fuera del `ScrollView`; su información puede desplazarse naturalmente.

## 6. Pruebas y límites arquitectónicos

`OpenBooksTests` contiene ocho pruebas XCTest sin API real, incluidas pruebas con contenedores SwiftData **en memoria**. El workflow del repositorio de pruebas ejecuta además recorridos Maestro: comprobar el cierre y la reapertura de la app se hace allí, con el almacén real de la aplicación, no con el contenedor en memoria de XCTest.

Esta separación evita mezclar operaciones de base de datos en cada vista. La arquitectura todavía puede evolucionar cuando exista networking real, pero no hace falta reconstruirla para esta práctica.

**Pendientes:** integrar Open Library, manejar resultados remotos, recuperar favoritos no presentes en los mocks, comprobar accesibilidad integral y reorganizar el catálogo de recursos, que en el ZIP actual aparece dentro de `OpenBooks/ViewModels/Assets.xcassets`.

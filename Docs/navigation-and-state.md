# Diseño de navegación y manejo de estado — OpenBooks

## 1. Flujos de usuario implementados

```text
Inicio
├── Sugerencias → Detalle del libro
├── Buscar → Resultados → Detalle del libro
│                     └── Buscar de nuevo → Resultados
└── Mis favoritos
    ├── Libro guardado → Detalle del libro
    └── Estado vacío → Buscar

Detalle del libro
└── Agregar o quitar de favoritos → Mis favoritos
```

La barra inferior cambia entre Inicio y Mis favoritos. La navegación de búsqueda y detalle se organiza mediante `NavigationStack` y `navigationDestination`. El detalle reutiliza la misma vista desde Inicio, Resultados o Mis favoritos.

## 2. Contenido y acciones por pantalla

| Pantalla | Muestra | Acciones y responsabilidad |
| --- | --- | --- |
| Inicio (`HomeView`) | Identidad editorial, ilustración adaptable al modo claro/oscuro, búsqueda, sugerencias. | Abrir Buscar, ampliar sugerencias, abrir Detalle o ir a Mis favoritos. |
| Buscar (`SearchView`) | Campo de consulta. | Editar el texto mediante `@Binding` y solicitar búsqueda al presionar Enter. |
| Resultados (`SearchResultsView`) | Resultados para el texto simulado y estados de interfaz. | Abrir Detalle o volver a Buscar; carga y error están preparados, pero no son activados por el buscador actual. |
| Detalle (`BookDetailView`) | Portada, título, autor, año cuando existe, género cuando existe, descripción, temas cuando existen. | Desplazar el contenido y agregar o quitar favoritos mediante una acción recibida del padre. |
| Mis favoritos (`MyBooksView`) | Lista de libros marcados como guardados y estado vacío. | Abrir Detalle, Inicio o Buscar; refleja el estado de `BooksState`. |

Las portadas de tres libros son ilustraciones locales. Cuando no hay recurso disponible, se muestra el indicador correspondiente; no se descargan portadas de Open Library.

## 3. Responsabilidad de los datos

| Información | Fuente responsable | Uso |
| --- | --- | --- |
| Catálogo actual, título, autor, género, sinopsis y temas | `Book` y `MockBooks.swift` | Inicio, Resultados y Detalle. |
| Texto y resultados de búsqueda | `SearchViewModel` (`@Observable`) | Buscar y Resultados. |
| Indicadores `isSaved` de la colección mostrada | `BooksState` (`@Observable`) | Inicio, Detalle y Mis favoritos. |
| Registros guardados entre ejecuciones | `SavedBook` en SwiftData | Fuente persistente de favoritos. |
| Consultas y operaciones SwiftData | `SavedBooksRepository` | Guardar, eliminar, listar e impedir duplicados. |
| `ModelContext`, ruta y sección activa | `ContentView` | Coordinación de acciones, navegación y sincronización inicial. |
| Configuración del contenedor | `OpenBooksApp` | `.modelContainer(for: SavedBook.self)`. |

**Una sola fuente de verdad:** la existencia persistente del favorito se determina mediante SwiftData. `BooksState` usa los identificadores guardados para reflejar `isSaved` en los diez libros locales. No mantiene una base de datos paralela de favoritos.

## 4. Flujo de guardar y eliminar

1. El usuario abre Detalle y pulsa «Agregar a favoritos» o «Quitar de favoritos».
2. `BookDetailView` llama a la acción `onSaveOrDelete` recibida.
3. `ContentView` crea el repositorio con el `modelContext` y llama a `booksState.toggleSaved(at:using:)`.
4. `SavedBooksRepository` consulta, inserta o elimina `SavedBook` y guarda el contexto. El identificador único previene registros duplicados; el repositorio también comprueba si ya está guardado.
5. `BooksState` recarga los identificadores para actualizar `isSaved`; `ContentView` muestra Mis favoritos.
6. Si SwiftData produce un error, `ContentView` informa mediante una alerta.

Al volver a abrir OpenBooks, `ContentView.onAppear` vuelve a cargar los favoritos persistidos. El test `persistence-flow.yaml` comprueba este flujo después de `stopApp` y `launchApp(clearState: false)`.

## 5. Navegación y estados especiales

En `ContentView`:

- `path` mantiene una ruta de enteros. `searchRoute = -2` abre Buscar; `resultsRoute = -1` abre Resultados; los índices no negativos indican el libro del catálogo local.
- `showingMyBooks` decide si la pantalla principal enseña Inicio o Mis favoritos.
- `SearchViewModel` mantiene `searchText`, `resultIndices` y `state`.
- `BooksState` presenta los libros locales y sus indicadores de guardado, sincronizados desde SwiftData.

**Estados disponibles:** resultados, sin resultados, carga, error, favoritos vacíos y portada ausente/pendiente. La búsqueda local asigna `.content` o `.noResults`; la pantalla de carga y la de error no se activan hasta implementar consultas reales.

## 6. Persistencia: alcance y pendientes

`SavedBook` almacena `bookID`, `title`, `author`, `year` y `hasCover`. El identificador local del prototipo se construye a partir del título y autor; la integración con Open Library deberá utilizar un identificador estable proporcionado por esa API.

Actualmente la vista Mis favoritos muestra libros existentes en `mockBooks`, aunque la base de datos guarde información básica del libro. Cuando exista búsqueda remota, habrá que definir la recuperación o reconstrucción de registros persistidos que no aparezcan en el catálogo de prueba.

El cierre y la reapertura **sin borrar datos** se verifican con el recorrido de Maestro; los unit tests de SwiftData usan un contenedor independiente en memoria para cada caso.

## 7. Referencias internas

- [Arquitectura y responsabilidades](mvvm-proposal.md).
- [Práctica 6: pruebas y SwiftData](practica-6-xctest-swiftdata.md).
- [README general](../README.md).

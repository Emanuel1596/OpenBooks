# Arquitectura y servicios de OpenBooks

Documento técnico de la versión preparada para la Práctica 8. Describe lo que está implementado en el código, no funciones previstas para el futuro.

## Estructura y responsabilidades

| Componente | Responsabilidad |
| --- | --- |
| `OpenBooks/OpenBooksApp.swift` | Prepara `ModelContainer`, el repositorio de favoritos, el estado observable y el servicio real. |
| `Models/Book.swift` | Modelo compartido de libro: identificador, título, autor, año opcional, portada, descripción, género y temas. |
| `Models/OpenLibrarySearchResponse.swift` | DTO `Decodable` de búsqueda y ficha de obra; transforma las respuestas a modelos internos. |
| `Models/SavedBook.swift` | Modelo `@Model` de SwiftData para registros de favoritos. |
| `Services/OpenLibraryBookSearchService.swift` | Construye solicitudes HTTPS, valida respuestas, decodifica JSON y consulta los detalles de obras. |
| `Services/SavedBooksRepository.swift` | Aísla el acceso a SwiftData a través del contrato `FavoriteBooksStore`. |
| `ViewModels/SearchViewModel.swift` | Mantiene texto de búsqueda, resultados, estados y una caché de sugerencias. |
| `ViewModels/BooksState.swift` | Fuente de verdad para libros y estado de favoritos; combina datos sin perder metadatos previamente recibidos. |
| `Views/ContentView.swift` | Organiza navegación y conecta vistas con los estados y servicios. |
| `Views/HomeView.swift`, `SearchView.swift`, `SearchResultsView.swift`, `BookDetailView.swift`, `MyBooksView.swift` | Presentación e interacción del usuario. |
| `Views/Components/` | Componentes visuales reutilizables: barra inferior, colores, filas, portadas y estados vacíos. |
| `OpenBooksTests/` | Datos de muestra aislados y pruebas XCTest. |

Se aplica una separación MVVM pragmática: **las vistas no construyen URLs ni manipulan directamente `ModelContext`**. `SearchViewModel` coordina la búsqueda, `BooksState` mantiene los datos compartidos y los servicios realizan I/O. `@State`, `@Bindable`, `@Observable` y `NavigationStack` siguen los contenidos de estado y navegación revisados en clase.

## Networking

`OpenLibraryBookSearchService` implementa `BookSearchService`, que declara `searchBooks(query:) async throws -> [Book]`. Se usa `URLComponents` para evitar concatenar parámetros sin codificar y `URLSession.shared.data(for:)` para ejecutar las solicitudes de forma asíncrona.

| Operación | Endpoint | Campos o respuesta |
| --- | --- | --- |
| Buscar y sugerir | `GET https://openlibrary.org/search.json?q=...&fields=key,title,author_name,first_publish_year,cover_i&limit=15` | JSON con `docs`; cada elemento se convierte de `OpenLibraryBookDTO` a `Book` |
| Detalle de obra | `GET https://openlibrary.org/works/{id}.json` | `description` (texto o objeto), `subjects`, `covers` |
| Portadas | `GET https://covers.openlibrary.org/b/id/{coverID}-M.jpg?default=false` | Imagen JPEG cuando existe |

`Book.year` es `String?` porque `first_publish_year` es opcional. `OpenLibraryWorkDescription` admite descripción como cadena o como objeto con `value`. Se aceptan respuestas HTTP 2xx; se informan errores de conexión, HTTP y decodificación. El detalle utiliza el identificador estable de tipo `/works/OL...W` para construir una URL de obra válida. La app **no emplea una clave API** para estos endpoints públicos.

Inicio usa la consulta `subject:fiction` para sugerencias. No es un listado certificado de libros más populares. La sinopsis y los temas pueden estar en inglés o no estar registrados; se muestran tal como llegan. El cliente limita el número de resultados solicitados y presenta estados de carga, sin resultados y error.

## Persistencia y caché

**Favoritos:** `SavedBook` es un modelo SwiftData con identificador `bookID` único, título, autor, año opcional, metadatos de portada y temas. `SavedBooksRepository` usa `ModelContext` para insertar, consultar, eliminar y actualizar metadatos. `BooksState` actualiza la propiedad `isSaved` después de consultar los registros de SwiftData; un fallo de guardado muestra un aviso y no confirma éxito.

**Sugerencias temporales:** `SearchViewModel` utiliza `UserDefaults` (`OpenBooks.Suggestions.v1`) para recuperar resultados reales recientes al abrir Inicio y volver a consultar en segundo plano. **Portadas temporales:** `BookCoverArtworkView` utiliza `NSCache` en memoria y un directorio `OpenBooksCovers` bajo `cachesDirectory` para evitar descargas repetidas. Las cachés no sustituyen el almacenamiento de favoritos.

No se guardan cuentas, contraseñas ni tokens. La conexión a Open Library es necesaria para una búsqueda nueva y para consultar una descripción que no esté disponible localmente. La aplicación no permite sincronizar favoritos entre dispositivos.

## Decisiones técnicas

1. **SwiftUI y MVVM:** vistas declarativas con estado observable y servicios separados para mantener responsabilidades claras.
2. **Inyección de dependencias mediante protocolos:** permite simular respuestas de búsqueda y fallos de persistencia durante XCTest sin usar una API real.
3. **SwiftData para favoritos:** conserva registros entre lanzamientos; `UserDefaults` y la caché de archivos se reservan para información temporal.
4. **Datos parciales:** se usan optionals y se conserva el último dato conocido, sin inventar autores, años o descripciones.
5. **Reintento visible:** el usuario puede repetir una consulta que falle; un timeout de Open Library no se presenta como «sin resultados».
6. **Interfaz adaptable:** colores y recursos para modo claro/oscuro y componentes reutilizables.

## Límites de la implementación

- Open Library puede tardar o devolver resultados incompletos; los tiempos y la disponibilidad no están controlados por OpenBooks.
- Los temas del servicio son etiquetas de la obra, no necesariamente géneros y no se traducen.
- Las descripciones obtenidas para la vista Detalle no se guardan como campo persistente de `SavedBook`; pueden requerir otra consulta al reabrir Detalle.
- No hay inicio de sesión, sincronización, libros completos ni reseñas. Tampoco se garantiza que todas las obras tengan portada.
- La inicialización de SwiftData puede fallar; actualmente el arranque utiliza `fatalError` si no se puede crear `ModelContainer`. Es una limitación registrada, no una situación que se haya verificado como resuelta.
- A falta de una revisión manual en dispositivo real, el comportamiento de VoiceOver y todos los tamaños de texto requiere verificación adicional.

Para el estado concreto de las comprobaciones y la transferencia a la rama oficial, consultar [Revisión de entrega](revision-de-entrega.md).

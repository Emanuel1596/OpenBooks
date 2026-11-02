# Práctica 6 · Pruebas unitarias y persistencia local con SwiftData

## Objetivo

Incorporar pruebas de reglas concretas mediante XCTest y conservar **Mis favoritos** entre ejecuciones de OpenBooks utilizando SwiftData, sin cambiar la búsqueda simulada ni la navegación aprobada.

## 1. Pruebas unitarias (XCTest)

Los archivos están en `OpenBooksTests/`, incluidos por el target `OpenBooksTests` definido en `project.yml`. El esquema `OpenBooks` incluye el target de pruebas al **regenerar el proyecto con XcodeGen**.

| Prueba | Comportamiento comprobado |
| --- | --- |
| `testHarryPotterReturnsFourResults` | Consulta válida, cuatro resultados correctos y estado `.content`. |
| `testPrideAndPrejudiceReturnsThreeResults` | Otra consulta válida con tres resultados y estado `.content`. |
| `testEmptySearchReturnsNoResults` | Consulta vacía, sin índices y estado `.noResults`. |
| `testUnknownSearchResetsPreviousResults` | Entrada inexistente tras búsqueda válida; no conserva resultados anteriores. |
| `testSavingBookMakesItAvailableInAnotherContext` | Guarda un libro y lo recupera desde otro `ModelContext`; `BooksState` refleja el favorito. |
| `testSavingTheSameBookTwiceDoesNotDuplicateIt` | Impide duplicar un registro del mismo libro. |
| `testRemovingBookLeavesAnEmptyCollection` | Elimina el favorito y maneja su eliminación repetida. |
| `testInvalidIndexDoesNotChangeSavedBooks` | Un índice inválido no modifica la colección. |

Las pruebas utilizan `XCTAssertEqual`, `XCTAssertTrue` y `XCTAssertFalse`. No realizan llamadas a Open Library. Las pruebas de SwiftData usan **un contenedor en memoria nuevo en cada caso** para asegurar independencia; por sí solas no verifican persistencia después de cerrar la aplicación.

## 2. Datos y organización de SwiftData

- `Models/Book.swift`: modelo `struct` para los libros mostrados, con identificador, metadatos y bandera `isSaved` de presentación.
- `Models/SavedBook.swift`: modelo persistente `@Model`, con `bookID` marcado como único, título, autor, año opcional y disponibilidad de portada.
- `Services/SavedBooksRepository.swift`: recibe `ModelContext`, consulta, guarda, elimina y evita duplicados.
- `ViewModels/BooksState.swift`: lee los identificadores guardados y actualiza `isSaved` en el catálogo local. Llama al repositorio para las operaciones.
- `Views/ContentView.swift`: obtiene `modelContext` del entorno, carga favoritos al aparecer, coordina las acciones y muestra una alerta cuando hay errores.
- `OpenBooksApp.swift`: configura SwiftData con `.modelContainer(for: SavedBook.self)`.

La colección de favoritos se persiste en SwiftData; `BooksState` refleja esa información en la interfaz sin almacenar otra colección persistente independiente. El identificador actual se deriva del autor y título de cada mock; cuando haya API, debe sustituirse por la clave estable de Open Library.

## 3. Verificación en el repositorio de pruebas

**XCTest:** el workflow ejecuta `xcodegen generate`, compila y corre los tests del esquema `OpenBooks` en un simulador de iOS. El artefacto `OpenBooks-XCTest` guarda el resultado `.xcresult`.

**Maestro:** `shared-state.yaml`, `search-flow.yaml`, `recorrido-completo.yaml` y `persistence-flow.yaml` verifican navegación y favoritos. La prueba de persistencia realiza esta secuencia:

1. Inicia la app con datos limpios y agrega *1984*.
2. Verifica que aparece en Mis favoritos y toma una captura.
3. Ejecuta `stopApp` y después `launchApp` con `clearState: false`.
4. Comprueba que el libro sigue guardado y toma otra captura.
5. Elimina el libro y verifica el estado vacío.

El recorrido también utiliza `startRecording` y `stopRecording` para dejar un video que documenta el cierre y la reapertura. Este flujo es una **prueba de interfaz con almacenamiento real de la app**, no una prueba unitaria en memoria.

La ejecución revisada de esta rama aprobó ocho pruebas XCTest y los recorridos de Maestro; la evidencia corresponde al repositorio de pruebas y deberá repetirse al integrar el código al oficial.

## 4. Pendientes y consideraciones

- `SearchViewModel` sigue reconociendo consultas exactas sobre diez mocks; no usa la API.
- Mis favoritos solo refleja libros que están en `MockBooks.swift`. Al incorporar resultados remotos habrá que visualizar también los favoritos que no formen parte del catálogo local.
- Los datos persistidos permiten identificar y mostrar información básica, pero no guardan sinopsis ni temas; hoy estos se recuperan del libro local.
- `project.yml` declara XCTest; el proyecto `OpenBooks.xcodeproj` que aparece en el ZIP todavía no incluye los archivos SwiftData ni el target de test. **Regenerar mediante XcodeGen es obligatorio antes de abrirlo y compilarlo localmente.**
- Los archivos `.maestro/`, el workflow de UI y la configuración de pruebas del repositorio experimental no deben trasladarse sin evaluación al repositorio oficial.

## 5. Entrega de la práctica

El Pull Request de la rama oficial deberá incluir código funcional, el modelo y la configuración de SwiftData, el target XCTest, los tests unitarios y esta documentación adaptada a la estructura final. Describir qué casos se probaron, cómo se comprueba la persistencia, las decisiones técnicas y los pendientes. Antes de compartir el PR en Moodle, ejecutar las pruebas sobre el código realmente integrado en el repositorio oficial.

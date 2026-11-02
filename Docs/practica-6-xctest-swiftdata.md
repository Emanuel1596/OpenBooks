# Práctica 6 · XCTest y SwiftData

## Pruebas unitarias

En `OpenBooksTests` se prueban reglas concretas sin usar una API: la búsqueda de Harry Potter, la búsqueda de Orgullo y prejuicio, la búsqueda vacía y una consulta sin coincidencias después de otra válida. Se comprueban los índices y el estado esperado mediante `XCTAssertEqual` y `XCTAssertTrue`.

También se prueba la persistencia con un `ModelContainer` **en memoria y diferente para cada prueba**: guardar, recuperar desde otro contexto, impedir duplicados, eliminar, eliminar un elemento inexistente y manejar índices inválidos.

## Persistencia local

`SavedBook` es el modelo `@Model` de SwiftData y guarda un identificador (`bookID`), título, autor, año y disponibilidad de portada. `SavedBooksRepository` encapsula las operaciones de `ModelContext` (`fetch`, `insert`, `delete` y `save`). `BooksState` lee los identificadores guardados y actualiza el estado que presentan Inicio, Detalle y Mis favoritos. No se vuelve a crear un estado de favoritos independiente en cada vista.

En este prototipo, el identificador local se deriva del autor y del título de cada libro de prueba. Cuando se conecte Open Library, deberá usarse una clave estable proporcionada por la API; el modelo `Book` ya permite recibirla explícitamente.

## Verificación

- XCTest desde el target `OpenBooksTests` en el esquema `OpenBooks`.
- Maestro: recorridos de favoritos, búsqueda y navegación.
- Maestro: `persistence-flow.yaml` guarda 1984, cierra la aplicación, la vuelve a abrir **sin borrar datos**, comprueba que sigue en Mis favoritos y finalmente lo elimina.
- Las capturas y el resultado de XCTest se suben como artefactos de GitHub Actions.

## Decisiones y pendientes

- Se mantiene `Book` como `struct` para los libros de prueba; la colección personal utiliza `SavedBook` persistido.
- La búsqueda sigue utilizando mocks y no se implementa networking en esta práctica.
- El catálogo actual se obtiene de `MockBooks`; al integrar Open Library será necesario recuperar también los libros que no estén en ese catálogo usando sus datos guardados. Esa ampliación queda fuera de esta práctica.
- No se pretende que la prueba en memoria demuestre por sí sola persistencia entre procesos: ese caso se comprueba con Maestro cerrando y reabriendo la app.

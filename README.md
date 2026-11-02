# OpenBooks

## Integrantes

- Romero Palacios Randy Rodrigo
- Villanueva García Emanuel

## Descripción y objetivo

**OpenBooks** es un proyecto iOS desarrollado con Swift y SwiftUI para explorar libros, consultar sus datos y administrar una colección de **Mis favoritos**. Actualmente funciona con diez libros locales de demostración: **todavía no consulta Open Library**.

El objetivo del MVP es permitir la búsqueda de libros, la consulta de sus detalles y la conservación de favoritos entre ejecuciones de la aplicación. La integración con Open Library se mantiene como trabajo pendiente.

## Funcionalidades implementadas

- **Inicio:** identidad visual editorial, ilustración adaptada al modo claro u oscuro, sugerencias de libros y acceso a Buscar y Mis favoritos. El enlace «Ver todo» amplía las sugerencias locales.
- **Buscar:** vista dedicada con un campo de texto. La consulta se envía al presionar Buscar/Enter en el teclado.
- **Resultados:** libros correspondientes a las consultas de prueba, navegación al detalle y estado «No se encontraron libros».
- **Detalle:** portada ilustrativa cuando existe, título, autor, año de publicación si existe, género si existe, sinopsis o mensaje de ausencia y temas principales si están disponibles. El contenido se desplaza verticalmente; el botón para agregar o quitar favoritos permanece visible en la parte inferior.
- **Mis favoritos:** muestra los libros guardados, permite abrir sus detalles y presenta un estado vacío con acceso a Buscar.
- **Persistencia:** SwiftData conserva los favoritos después de cerrar y volver a abrir OpenBooks. Se evita guardar dos veces el mismo libro.
- **Pruebas:** ocho pruebas unitarias XCTest para búsqueda y favoritos; pruebas de interfaz y de persistencia mediante Maestro en este repositorio de pruebas.
- **Accesibilidad:** etiquetas y encabezados de accesibilidad en varias vistas. La revisión integral con VoiceOver y Dynamic Type sigue pendiente.

### Alcance actual de la búsqueda

`SearchViewModel` utiliza exclusivamente datos de `MockBooks.swift`. Reconoce las consultas exactas «Harry Potter» (cuatro resultados) y «Orgullo y prejuicio» (tres resultados); una consulta distinta produce el estado sin resultados. No realiza peticiones HTTP.

Las vistas de **carga** y **error** están implementadas, pero esas condiciones todavía no se activan mediante la búsqueda simulada. No deben presentarse como comportamiento real de una conexión a Open Library.

### Portadas y datos de demostración

Las ilustraciones de *Harry Potter y la piedra filosofal*, *1984* y *Orgullo y prejuicio* utilizadas en las sugerencias son recursos editoriales de demostración, **no portadas oficiales descargadas de Open Library**. En listas y Detalle, `BookCoverArtworkView` respeta `hasCover`: por ejemplo, *Orgullo y prejuicio* tiene `hasCover = false` y muestra «Sin portada» en Detalle, aunque aparezca una ilustración en Sugerencias. Otros libros presentan un indicador provisional según los datos locales. Las sinopsis, géneros y temas también son información de demostración.

## Flujo de navegación

- Inicio → libro sugerido → Detalle.
- Inicio → Buscar → Resultados → Detalle.
- Resultados → Buscar → nuevos Resultados.
- Inicio → Mis favoritos → libro guardado → Detalle.
- Mis favoritos vacío → Buscar.
- Detalle → Agregar/Quitar de favoritos → Mis favoritos.

`ContentView` coordina `NavigationStack`, la ruta y el cambio entre Inicio y Mis favoritos. El estado de búsqueda vive en `SearchViewModel` y los favoritos se coordinan mediante `BooksState`.

## Persistencia local con SwiftData

`SavedBook` es un modelo `@Model` que conserva `bookID`, título, autor, año opcional y disponibilidad de portada. `OpenBooksApp` configura el contenedor de SwiftData mediante `.modelContainer(for: SavedBook.self)`.

`SavedBooksRepository` realiza las operaciones de consulta, inserción, eliminación y guardado con `ModelContext`. `BooksState` lee los identificadores persistidos y actualiza `isSaved` en los libros de la interfaz. `ContentView` carga los favoritos al aparecer y presenta una alerta si ocurre un error de persistencia.

El identificador local deriva del autor y el título en estos datos de prueba; cuando se integre Open Library deberá utilizarse una clave estable de esa API. Hoy **Mis favoritos solo puede representar libros presentes en el catálogo local**. Para libros remotos habrá que recuperar o reconstruir su información a partir de los datos persistidos.

## Organización del código

```text
OpenBooks/
├── OpenBooksApp.swift
├── Models/
│   ├── Book.swift
│   └── SavedBook.swift
├── Mocks/
│   └── MockBooks.swift
├── Services/
│   └── SavedBooksRepository.swift
├── ViewModels/
│   ├── BooksState.swift
│   ├── SearchViewModel.swift
│   └── SearchViewState.swift
└── Views/
    ├── ContentView.swift
    ├── HomeView.swift
    ├── SearchView.swift
    ├── SearchResultsView.swift
    ├── BookDetailView.swift
    ├── MyBooksView.swift
    └── Components/
        ├── BookCoverArtworkView.swift
        ├── BookRowView.swift
        ├── BottomNavigationView.swift
        └── EmptyMyBooksView.swift

OpenBooksTests/
├── SearchViewModelTests.swift
└── SavedBooksRepositoryTests.swift
Docs/
├── mvvm-proposal.md
├── navigation-and-state.md
└── practica-6-xctest-swiftdata.md
```

**Ubicación actual de los recursos:** el ZIP de esta rama contiene `Assets.xcassets` dentro de `OpenBooks/ViewModels/`; conviene moverlo a `OpenBooks/` en una refactorización separada y comprobada, sin mezclar ese movimiento con la práctica 6.

## Pruebas y verificación

### Pruebas unitarias (XCTest)

El target `OpenBooksTests` contiene ocho casos: búsqueda conocida, otra búsqueda conocida, texto vacío, consulta inexistente después de una válida, guardar y recuperar desde un segundo `ModelContext`, impedir duplicados, eliminar y rechazar un índice inválido. Cada prueba de SwiftData utiliza su propio contenedor en memoria; no necesita servicios externos.

### Pruebas de interfaz (Maestro)

En este repositorio de pruebas, los archivos `.maestro/` cubren favoritos, búsqueda, navegación y persistencia. La prueba de persistencia guarda *1984*, ejecuta `stopApp`, reabre con `clearState: false`, verifica que el favorito continúa y luego lo elimina. Se generan capturas y video como evidencia.

### Ejecución local y en GitHub Actions

**Importante:** este repositorio utiliza `project.yml` y **GitHub Actions regenera `OpenBooks.xcodeproj` mediante XcodeGen antes de compilar**. El `project.pbxproj` incluido en el ZIP no contiene aún los archivos/target añadidos en la práctica 6. Para compilar o ejecutar XCTest en Xcode, hay que generar primero el proyecto:

```bash
xcodegen generate
```

Después, abrir `OpenBooks.xcodeproj`, seleccionar un simulador iOS y ejecutar el esquema `OpenBooks`. En Xcode se pueden ejecutar las pruebas XCTest del esquema. Alternativamente, el workflow de GitHub Actions genera el proyecto, compila, ejecuta XCTest y las pruebas de Maestro. Esta configuración y los scripts de Maestro pertenecen al repositorio de pruebas y no deben copiarse automáticamente al repositorio oficial.

## Documentación adicional

- [Diseño de navegación y estado](Docs/navigation-and-state.md): flujos, responsabilidades y fuente de verdad.
- [Arquitectura y separación de responsabilidades](Docs/mvvm-proposal.md): modelos, vistas, ViewModels y repositorio de persistencia.
- [Práctica 6: XCTest y SwiftData](Docs/practica-6-xctest-swiftdata.md): casos, datos guardados, evidencias y pendientes.

## Pendientes del MVP

- Búsqueda real en Open Library, con `async/await`, servicio separado y manejo real de carga/error.
- Identificadores estables proporcionados por la API y visualización de favoritos que no estén en los mocks.
- Descarga de portadas cuando la API tenga imágenes disponibles.
- Verificación completa de accesibilidad y adaptación a distintos tamaños de texto.
- Actualizar el registro visual del proyecto con capturas de la interfaz editorial actual.

## Registro visual histórico

Las imágenes enlazadas a continuación son **wireframes y capturas de versiones anteriores**. Pueden mostrar la antigua etiqueta «Mis libros», elementos provisionales o un diseño diferente. Se conservan como evidencia del desarrollo, **no como representación de la implementación actual**.

- [Diagrama inicial de navegación](https://github.com/user-attachments/assets/fa488ace-31df-4de5-bb4a-6094bfa4aee4)
- [Wireframe: Inicio](https://github.com/user-attachments/assets/aeec5ced-9d0f-40c3-9ad7-566936d6f885)
- [Wireframe: Resultados](https://github.com/user-attachments/assets/2832437b-cfa3-40a6-b506-cfcec5a5204c)
- [Wireframe: Detalle sin guardar](https://github.com/user-attachments/assets/29a59be6-227a-4ca1-865d-6f1440dba4d5)
- [Wireframe: Mis libros (nombre anterior)](https://github.com/user-attachments/assets/d0d44fd2-88cc-4d64-907c-714b101020bf)
- [Wireframe: Detalle guardado](https://github.com/user-attachments/assets/fc9a6265-71e6-4ee3-83da-af05aebe0d3d)
- [Wireframe: Lista vacía](https://github.com/user-attachments/assets/39c7128d-7280-4e08-bd93-36ec7da5010c)
- [Wireframe: Estados adicionales](https://github.com/user-attachments/assets/d4c5124b-5d78-457f-b252-ebaca66c3d95)
- [Captura anterior: Inicio](https://github.com/user-attachments/assets/9000cb2b-fc82-4a9f-9aa6-3ad09755adaf)
- [Captura anterior: Resultados](https://github.com/user-attachments/assets/f4403735-70f6-4926-bfb7-46987f16e3d2)
- [Captura anterior: Detalle sin guardar](https://github.com/user-attachments/assets/205931c3-31c4-406b-a4e7-82029595fd97)
- [Captura anterior: Detalle guardado](https://github.com/user-attachments/assets/784b783f-d948-44a5-8bb1-91cb97f91c38)
- [Captura anterior: Mis libros](https://github.com/user-attachments/assets/b7568132-028e-44f4-be32-34d895bcfe1d)
- [Captura anterior: Lista vacía](https://github.com/user-attachments/assets/7beac29c-e70e-4cd8-86a0-08563d5f0957)
- [Captura anterior: Carga](https://github.com/user-attachments/assets/f441b56a-8f55-4bcb-af79-4cd62969084e)
- [Captura anterior: Sin resultados](https://github.com/user-attachments/assets/a80647df-3a93-47a4-bb42-9883a9712b98)
- [Captura anterior: Error](https://github.com/user-attachments/assets/ac6c4726-265b-4c22-84cd-2c316f16477e)
- [Captura anterior: Sin portada](https://github.com/user-attachments/assets/7d89a443-d41a-4d5b-b5e3-a766f45defe6)

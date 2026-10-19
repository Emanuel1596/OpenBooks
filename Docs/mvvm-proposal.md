# Propuesta de arquitectura MVVM

Este documento presenta el análisis de la estructura de OpenBooks y los cambios realizados durante la práctica 5 para comenzar a organizar el proyecto mediante MVVM.

La refactorización se realizó de forma gradual. No se reescribió la aplicación ni se modificaron sus pantallas; únicamente se separaron responsabilidades que antes estaban dentro de las vistas.

## 1. Estructura actual del proyecto

Actualmente, OpenBooks está dividido principalmente en los siguientes archivos:

### `Book.swift`

Contiene el modelo `Book`, que representa la información de cada libro:

- Título.
- Autor.
- Año de publicación, cuando esté disponible.
- Disponibilidad de portada.
- Estado de guardado.

También contiene `SearchViewState`, que representa los estados de búsqueda, y `BooksState`, un objeto `@Observable` que mantiene la colección compartida de libros.

Durante la práctica 5 se agregó a `BooksState` el método `toggleSaved(at:)`, encargado de cambiar el estado `isSaved` del libro seleccionado.

### `MockBooks.swift`

Contiene los datos locales utilizados para probar las pantallas y el funcionamiento del proyecto. Todavía no se realizan consultas a Open Library.

### `ContentView.swift`

Es la vista raíz de la aplicación.

Actualmente se encarga de:

- Mantener el `NavigationStack` y su ruta de navegación.
- Controlar el cambio entre Inicio y Mis libros.
- Mantener una instancia de `SearchViewModel` mediante `@State`.
- Mantener una instancia de `BooksState` mediante `@State`.
- Conectar Inicio, Buscar, Resultados, Detalle y Mis libros.
- Solicitar la búsqueda al ViewModel y navegar a Resultados.
- Solicitar a `BooksState` que guarde o elimine un libro y navegar a Mis libros.

Antes de esta práctica también contenía las condiciones que decidían el estado de cada búsqueda y modificaba directamente `isSaved`. Esas responsabilidades ya se trasladaron fuera de la vista.

### `HomeView.swift`

Representa la pantalla principal.

Muestra:

- El nombre de la aplicación.
- La lupa que permite abrir Buscar.
- La lista inicial de libros.
- El acceso a Mis libros.

También utiliza `NavigationLink` para abrir el detalle de un libro.

En el mismo archivo se encuentra `SearchView`, la vista donde el usuario escribe la consulta. Recibe el texto mediante `@Binding` y solicita ejecutar la búsqueda cuando se presiona Enter.

### `SearchResultsView.swift`

Representa la pantalla de resultados.

Actualmente recibe:

- Los índices de los libros seleccionados (`resultIndices`).
- La colección de libros.
- El estado actual de la búsqueda.

La vista muestra los resultados correspondientes a los índices recibidos. Ya no contiene condiciones para decidir qué libros aparecen según el texto de búsqueda.

También puede representar los estados de carga, contenido, sin resultados y error. Con los datos de prueba actuales, la búsqueda solo establece contenido o sin resultados; las vistas de carga y error están preparadas, pero no se activan.

### `ViewModels/SearchViewModel.swift`

Es el archivo agregado durante la práctica 5. Contiene `SearchViewModel`, definido mediante `@Observable`.

Se encarga de:

- Mantener el texto de búsqueda en `searchText`.
- Mantener el estado de la búsqueda en `state`.
- Determinar los índices de los libros que corresponden a la consulta en `resultIndices`.
- Ejecutar la lógica de búsqueda mediante `searchBooks()`.

Por ahora reconoce «Harry Potter» y «Orgullo y prejuicio» usando los libros de prueba. Para otras consultas establece el estado sin resultados. No realiza solicitudes a Open Library.

### `BookDetailView.swift`

Representa el detalle del libro seleccionado y muestra la opción de guardarlo o eliminarlo de Mis libros.

La vista solicita el cambio mediante `onSaveOrDelete`. `ContentView` recibe esa acción y llama a `booksState.toggleSaved(at:)`. De esta forma, el detalle no modifica por su cuenta la colección compartida.

### `MyBooksView.swift`

Representa la sección de libros guardados.

Recibe la colección compartida, muestra los libros con `isSaved` igual a `true` y determina cuándo presentar el estado de lista vacía.

### `OpenBooksApp.swift`

Es el punto de entrada de la aplicación y muestra `ContentView` como contenido principal.

---

## 2. Separación de responsabilidades

Durante la revisión se identificaron tres responsabilidades principales:

### Interfaz

Corresponde a las vistas que muestran información y reciben las acciones del usuario.

Por ejemplo:

- `HomeView`.
- `SearchView`.
- `SearchResultsView`.
- `BookDetailView`.
- `MyBooksView`.

Su función principal es presentar información y comunicar lo que quiere hacer el usuario.

### Datos

Corresponden a la información con la que trabaja la aplicación.

El ejemplo principal es `Book`, que contiene los datos de cada libro. Actualmente esos datos provienen de `MockBooks.swift`.

### Estado y lógica

Corresponden a los valores que pueden cambiar y a las operaciones que determinan qué información se presenta.

En la implementación actual:

- `SearchViewModel` mantiene el texto, el estado y los resultados de búsqueda.
- `BooksState` mantiene la colección de libros y cambia `isSaved` mediante `toggleSaved(at:)`.
- `ContentView` mantiene la navegación y comunica las acciones a esos objetos.
- `MyBooksView` todavía revisa la colección recibida para mostrar los libros guardados y el estado vacío.

Con esto se redujeron las responsabilidades de `ContentView` y `SearchResultsView`, sin agregar capas que el proyecto todavía no necesita.

---

## 3. MVVM aplicado a OpenBooks

MVVM organiza la aplicación en tres partes principales:

### Model

Representa los datos de la aplicación.

En OpenBooks el modelo principal es `Book`. No decide cómo se muestra visualmente la información.

### View

Representa la interfaz y recibe las acciones del usuario.

En OpenBooks, las principales vistas son `ContentView`, `HomeView`, `SearchView`, `SearchResultsView`, `BookDetailView` y `MyBooksView`.

### ViewModel

Mantiene el estado y la lógica que necesita la interfaz.

En la práctica 5 se incorporó `SearchViewModel` para el flujo de búsqueda. `BooksState` sigue siendo un objeto de estado compartido y ahora contiene también la operación de guardar o eliminar libros.

De manera sencilla, el flujo de búsqueda queda así:

```text
Usuario
   ↓
Buscar (View)
   ↓
SearchViewModel (ViewModel)
   ↓
Índices de libros de prueba
   ↓
Resultados (View)
```

Cuando el usuario escribe, `SearchView` modifica `searchText` mediante `@Binding`. `ContentView` utiliza `@Bindable` para conectar ese campo con el ViewModel.

Al presionar Enter, `ContentView` llama a `searchViewModel.searchBooks()` y después navega a Resultados. La vista Resultados recibe el estado y los índices calculados, junto con los libros de `BooksState`.

---

## 4. Organización de MVVM en OpenBooks

No fue necesario crear un ViewModel para cada pantalla ni reorganizar todas las carpetas del proyecto.

### Búsqueda: `SearchViewModel`

**Ya implementado en la práctica 5.**

El ViewModel mantiene una sola fuente de verdad para el texto, el estado y los índices de resultados. Las vistas no contienen las condiciones que deciden qué libros corresponden a una búsqueda.

Los índices siguen haciendo referencia a los libros de `MockBooks.swift` disponibles en `BooksState`. Por ahora, la búsqueda no se conecta a Open Library.

### Libros guardados: `BooksState`

**Responsabilidad reorganizada en la práctica 5.**

`BooksState` ya mantenía la colección compartida mediante `@Observable`. Ahora también tiene el método `toggleSaved(at:)`, que cambia `isSaved` del libro seleccionado.

Antes `ContentView` modificaba directamente ese valor. Ahora solamente solicita el cambio y se encarga de navegar hacia Mis libros.

No se creó un archivo `BooksViewModel.swift`. El proyecto conserva `BooksState` porque ya cumple la función de mantener y modificar el estado compartido que necesitamos en esta etapa.

### Organización actual de los archivos

```text
OpenBooks/
├── Book.swift
├── MockBooks.swift
├── ContentView.swift
├── HomeView.swift
├── SearchResultsView.swift
├── BookDetailView.swift
├── MyBooksView.swift
├── OpenBooksApp.swift
└── ViewModels/
    └── SearchViewModel.swift
```

La carpeta `ViewModels` contiene por ahora solamente `SearchViewModel.swift`. Las vistas siguen en sus archivos existentes; no se crearon carpetas adicionales para Model y View.

### Estado local y estado compartido

La ruta de navegación (`path`) y la sección activa (`showingMyBooks`) continúan en `ContentView` mediante `@State` porque corresponden a la vista raíz.

El texto, el estado y los índices de búsqueda pertenecen a `SearchViewModel`. La colección de libros y su estado de guardado pertenecen a `BooksState`.

Así evitamos tener varias copias independientes de la misma información.

---

## 5. Cambios realizados durante la práctica 5

### Primera refactorización: búsqueda

1. Se creó `ViewModels/SearchViewModel.swift` con `@Observable`.
2. Se trasladaron las condiciones de búsqueda que estaban en `ContentView` al método `searchBooks()` del ViewModel.
3. Se trasladó la selección de los índices que estaba en `SearchResultsView` al ViewModel.
4. `ContentView` ahora utiliza `@Bindable` para conectar el texto editable con `SearchView` y continúa controlando la navegación.
5. `SearchResultsView` recibe los índices y el estado para mostrar la información, sin decidir qué libros corresponden a cada consulta.

### Segunda refactorización: libros guardados

1. Se agregó el método `toggleSaved(at:)` a `BooksState`, dentro de `Book.swift`.
2. Se reemplazó la modificación directa de `isSaved` en `ContentView` por la llamada `booksState.toggleSaved(at: route)`.
3. Se conservaron la colección compartida, las pantallas y el comportamiento de guardar o eliminar libros.

### Comprobación de los cambios

Después de cada refactorización se ejecutó el workflow `UI Test OpenBooks` en GitHub Actions sobre la rama `practica-5-mvvm`.

Se completaron las pruebas de Maestro para guardar y eliminar libros, realizar dos búsquedas consecutivas y recorrer las pantallas principales. El recorrido también se grabó en video.

Estas pruebas comprueban los recorridos del prototipo con datos locales. No demuestran todavía integración con Open Library ni persistencia entre ejecuciones.

### Beneficios de la refactorización

Con estos cambios:

- `ContentView` conserva la navegación sin decidir qué libros corresponden a cada búsqueda.
- `SearchResultsView` muestra los resultados que recibe y ya no repite las condiciones de búsqueda.
- `BooksState` mantiene en un solo lugar la operación para guardar o eliminar libros.
- El código se puede comprender y modificar sin concentrar toda la lógica en las vistas.

### Consideraciones

La separación también requiere identificar correctamente quién mantiene cada dato y cómo se comparte con las vistas. Por eso se utilizó un ViewModel solo donde existía una responsabilidad clara y se conservó `BooksState` para la colección.

### Posibles mejoras posteriores

La organización podrá seguir mejorándose conforme se avance en el proyecto. Por ejemplo, se podría revisar la forma en que `MyBooksView` determina qué libros mostrar o valorar si conviene separar más responsabilidades de `BooksState`.

No se considera necesario realizar esos cambios en esta etapa si no aportan una mejora concreta. Tampoco se implementaron nuevas funcionalidades, servicios ni persistencia durante esta práctica.

---

## 6. Conclusión

Durante la práctica 5 comenzamos a aplicar MVVM de manera progresiva en OpenBooks.

`SearchViewModel` reúne la lógica del flujo de búsqueda y `BooksState` se encarga de modificar el estado de guardado de los libros. `ContentView` conserva la navegación y coordina las acciones entre las vistas y los objetos que mantienen el estado.

Con estos cambios el código tiene responsabilidades más claras sin modificar el funcionamiento de las pantallas que ya estaban implementadas.

La aplicación todavía no utiliza una arquitectura MVVM completa. La conexión con Open Library, la persistencia y otras funciones pendientes se incorporarán en las etapas correspondientes del proyecto.

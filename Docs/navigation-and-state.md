# Diseño de navegación y estado

Este documento define la organización de la navegación y el estado de OpenBooks y registra cómo estas decisiones se relacionan con la implementación actual del proyecto.

La propuesta parte del MVP del proyecto y busca dejar claro qué pantallas existen, cómo se relacionan entre sí, qué información utiliza cada una y dónde debería vivir cada dato para evitar duplicaciones o inconsistencias.

---

## 1. Mapa de navegación

Los flujos principales de OpenBooks son:

- Inicio → lista de libros → Detalle del libro.
- Inicio → Buscar → Resultados → Detalle del libro.
- Resultados → Buscar → Resultados.
- Mis libros → libro guardado → Detalle del libro.
- Mis libros → Buscar → Resultados.

A partir de esos flujos, el mapa de navegación propuesto es:

```text
OpenBooks
│
├── Inicio
│   │
│   ├── Seleccionar un libro
│   │   └── Detalle del libro
│   │       ├── Regresar → Inicio
│   │       └── Guardar libro → Mis libros
│   │
│   ├── Tocar lupa
│   │   └── Buscar
│   │       └── Escribir búsqueda y presionar Enter
│   │           └── Resultados
│   │               ├── Carga
│   │               ├── Contenido
│   │               │   └── Seleccionar un libro
│   │               │       └── Detalle del libro
│   │               │           ├── Regresar → Resultados
│   │               │           └── Guardar libro → Mis libros
│   │               ├── Sin resultados
│   │               └── Error
│   │
│   └── Ir a Mis libros
│       └── Mis libros
│
├── Resultados
│   └── Tocar lupa
│       └── Buscar
│           └── Escribir búsqueda y presionar Enter
│               └── Resultados
│
└── Mis libros
    │
    ├── Seleccionar un libro guardado
    │   └── Detalle del libro
    │       ├── Regresar → Mis libros
    │       └── Eliminar de Mis libros → Mis libros
    │
    └── Lista vacía
        └── Buscar libros
            └── Buscar
                └── Escribir búsqueda y presionar Enter
                    └── Resultados
```

**Detalle del libro** se repite dentro de los distintos recorridos únicamente para mostrar desde dónde puede abrirse y a qué pantalla regresa. Corresponde a una misma pantalla reutilizable y no a una tercera sección principal de la aplicación.

Los estados **Carga**, **Sin resultados** y **Error** no se consideran pantallas independientes. Son estados de la pantalla **Resultados**. En el prototipo, el estado sin resultados ya se utiliza; las vistas de carga y error están preparadas, pero todavía no se activan durante la búsqueda.

De la misma forma, **Lista vacía** pertenece a **Mis libros** y **Sin portada** es una condición de presentación de un libro, no una pantalla adicional.

La navegación principal entre **Inicio** y **Mis libros** se mantiene mediante la barra inferior definida en el diseño del proyecto.

---

## 2. Información por pantalla

### Pantalla principal · Inicio

**Propósito:**
Permitir al usuario consultar la lista inicial de libros, abrir la búsqueda y acceder a Mis libros.

**Muestra:**

- Nombre de la aplicación.
- Botón de búsqueda representado por una lupa.
- Lista inicial de libros.
- Título y autor de cada libro.
- Portada cuando esté disponible.
- Accesos a Inicio y Mis libros.

**Recibe:**

- Libros que se mostrarán en la lista inicial.

**Modifica:**

- No modifica directamente el texto de búsqueda.
- Solicita cambios de navegación cuando el usuario abre Buscar, selecciona un libro o entra a Mis libros.

**Necesita conservar:**

- No necesita conservar una copia propia del texto de búsqueda.

Inicio ya no contiene un campo editable de búsqueda. La lupa funciona como una acción de navegación que abre la vista Buscar.

---

### Buscar

**Propósito:**
Permitir al usuario escribir una consulta antes de mostrar los resultados.

**Muestra:**

- Campo de búsqueda.
- Lupa como elemento visual dentro del campo.
- Texto de búsqueda actual cuando exista.

**Recibe:**

- El texto de búsqueda cuya fuente de verdad se encuentra en `ContentView`.

**Modifica:**

- El texto de búsqueda mediante `@Binding`.
- Solicita ejecutar la búsqueda cuando el usuario presiona Enter en el teclado.

**Necesita conservar:**

- El texto escrito hasta que se ejecute la búsqueda.

`ContentView` mantiene la fuente de verdad del texto mediante `@State`. Buscar recibe acceso de lectura y escritura mediante `@Binding`, por lo que no crea una segunda copia del dato.

Escribir únicamente modifica el texto. La búsqueda comienza cuando el usuario presiona Enter en el teclado.

---

### Resultados

**Propósito:**
Mostrar el resultado de una búsqueda. Actualmente se utilizan libros de prueba; la conexión con Open Library se realizará después.

**Muestra:**

- Título de la pantalla: Resultados.
- Lista de libros de prueba correspondiente a la consulta.
- Vista de carga preparada, todavía no activada por la búsqueda actual.
- Estado sin resultados.
- Vista de error preparada, todavía no activada por la búsqueda actual.
- Acción para volver a intentar la búsqueda, dentro de la vista de error.
- Botón de búsqueda representado por una lupa.

**Recibe:**

- El texto de búsqueda cuya fuente de verdad se encuentra en `ContentView`.
- La colección de libros proporcionada por `ContentView`.
- El estado actual de la búsqueda proporcionado por `ContentView`.

**Modifica:**

- No modifica directamente el texto de búsqueda.
- Solicita volver a ejecutar la búsqueda cuando el usuario utiliza Intentar nuevamente.
- Solicita abrir Buscar cuando el usuario toca la lupa.
- Solicita navegación cuando el usuario selecciona un libro.

Resultados recibe el texto para determinar qué libros de prueba debe mostrar. No presenta la consulta como un texto independiente en pantalla. Si el usuario quiere escribir una consulta diferente, abre nuevamente la vista Buscar mediante la lupa.

**Necesita conservar:**

- Texto de búsqueda.
- Los libros de prueba que se muestran como resultados. Por ahora no se descargan ni guardan resultados de una consulta externa.
- Estado de la búsqueda mientras el usuario entra a un detalle y posteriormente regresa.

---

### Detalle del libro

**Propósito:**
Mostrar la información del libro seleccionado y permitir guardarlo o eliminarlo de Mis libros.

**Muestra:**

- Título.
- Autor o autores.
- Portada cuando esté disponible.
- Año de publicación cuando esté disponible.
- Acción Guardar libro o Eliminar de Mis libros.

**Recibe:**

- Libro seleccionado.

**Modifica:**

- No modifica directamente los datos del libro como título, autor, año o portada.
- Cuando el usuario presiona Guardar libro o Eliminar de Mis libros, solicita a `ContentView` cambiar el estado `isSaved` del libro seleccionado.

`BookDetailView` muestra el libro recibido, pero la colección de libros y su estado de guardado pertenecen a `ContentView`.

La vista de detalle solicita el cambio mediante la acción `onSaveOrDelete`, y `ContentView` modifica el libro correspondiente dentro de la colección compartida.

**Necesita conservar:**

- La información del libro mientras el detalle permanezca abierto.
- El cambio realizado sobre la colección de libros guardados debe mantenerse al navegar a otras pantallas.

La pantalla de detalle no debe crear una segunda copia independiente del estado de guardado. El estado real debe provenir de la misma fuente de verdad utilizada por Mis libros.

---

### Mis libros

**Propósito:**
Mostrar los libros que el usuario ha marcado como guardados.

**Muestra:**

- Lista de libros guardados.
- Título y autor de cada libro.
- Portada cuando esté disponible.
- Estado de lista vacía.
- Acción Buscar libros cuando la lista esté vacía.

**Recibe:**

- La colección de libros compartida proporcionada desde `booksState.books`.
- A partir de esa colección muestra únicamente los libros cuyo estado `isSaved` indica que están guardados.

**Modifica:**

- No modifica directamente la colección de libros ni el estado `isSaved`.
- Únicamente solicita cambios de navegación cuando el usuario selecciona un libro, regresa a Inicio o utiliza la acción Buscar libros.

**Necesita conservar:**

- Necesita que la colección compartida y el estado de guardado de sus libros permanezcan disponibles mientras el usuario navega por la aplicación.
- La fuente de verdad de esta información se encuentra en `BooksState`, cuya instancia es mantenida por `ContentView`. Mis libros solamente recibe la colección y la muestra.
- Posteriormente, esta información deberá persistirse localmente para conservarse entre ejecuciones de la aplicación.

Mis libros no es la pantalla encargada de guardar o eliminar libros. Cuando el usuario realiza esa acción desde Detalle, `ContentView` modifica `isSaved` dentro de `booksState.books`. Mis libros recibe después el estado actualizado y muestra los libros correspondientes.

---

## 3. Organización del estado

No toda la información que aparece en una vista debe convertirse en estado. Los datos de un libro, como título, autor, año o disponibilidad de portada, forman parte del modelo. En cambio, los datos que pueden cambiar y modificar lo que muestra la interfaz sí deben organizarse como estado.

La organización propuesta es la siguiente:

| Dato | Quién lo utiliza | Quién lo modifica | Dónde debería vivir | Justificación |
| --- | --- | --- | --- | --- |
| Texto de búsqueda | Buscar y Resultados | Usuario desde Buscar | `ContentView` | `ContentView` mantiene una sola fuente de verdad mediante `@State`. Buscar puede editar el mismo valor mediante `@Binding` y Resultados lo recibe para representar la búsqueda actual. |
| Resultados de búsqueda | Resultados y Detalle | Actualmente, `ContentView` determina el estado y `SearchResultsView` selecciona qué libros mostrar | Ahora se utilizan `booksState.books` y el texto de búsqueda; después podrá organizarse como estado del flujo de búsqueda | En el prototipo no se obtiene una lista nueva de Open Library. Se muestran libros de prueba según el texto escrito y siguen disponibles al regresar de Detalle. |
| Estado de búsqueda: loading, content, noResults o error | Resultados | `ContentView`, mediante `searchBooks()` | `ContentView`, como `searchViewState` | Resultados muestra una vista según el estado recibido. Actualmente la búsqueda establece `.content` o `.noResults`; `.loading` y `.error` tienen vistas preparadas, pero no se asignan desde `searchBooks()`. |
| Libros guardados | Mis libros y Detalle | `ContentView`, a partir de la acción solicitada desde Detalle | `BooksState` | Ambas vistas necesitan consultar el mismo estado. `BooksState` mantiene una sola fuente de verdad y `ContentView` actualiza el estado de guardado del libro seleccionado. |
| Estado de guardado de un libro | Detalle y Mis libros | `ContentView`, cuando Detalle solicita guardar o eliminar | Dentro de `booksState.books` | El valor `isSaved` pertenece al libro almacenado en la colección compartida. Detalle lo muestra y solicita su cambio, pero no mantiene una copia independiente. |
| Libro seleccionado | Detalle | La pantalla desde la que se selecciona el libro | Se identifica mediante un índice `Int` durante la navegación | `NavigationLink` envía el índice del libro; `ContentView` lo busca en `booksState.books` y pasa el `Book` a Detalle. No hace falta mantener otra colección para la selección. |
| Sección principal activa: Inicio o Mis libros | Barra inferior y vista raíz | Usuario al cambiar de sección | Estado local de la vista que contiene ambas secciones | La vista raíz es la responsable de esta decisión de navegación. |
| Título, autor, año y disponibilidad de portada | Inicio, Resultados, Detalle y Mis libros | Actualmente, los datos locales de prueba; más adelante, Open Library | Modelo `Book` | Son datos propios del libro. `hasCover` indica si se muestra un marcador provisional o el estado «Sin portada»; todavía no se descargan portadas reales. |

### Estado local y estado compartido

Se considera **estado local** cuando el dato pertenece a una sola vista y no necesita ser conocido por otras.

Se considera **estado compartido** cuando varias vistas necesitan leerlo o cuando una vista distinta de la propietaria necesita modificarlo.

Para OpenBooks:

- La colección de libros guardados debe ser compartida.
- Los resultados y el estado de una búsqueda deben mantenerse durante el flujo de búsqueda.
- El texto de búsqueda debe compartirse entre Buscar y Resultados.
- La selección de la sección principal puede pertenecer a la vista raíz.
- El libro seleccionado puede viajar como información de navegación hacia Detalle.

### Single Source of Truth

La aplicación debe evitar que un mismo dato tenga varios dueños.

El caso más importante es **Mis libros**. Si la lista de guardados y la pantalla de detalle mantuvieran copias diferentes de la información de guardado, podrían dejar de coincidir.

Por eso, la colección de libros guardados debe ser la fuente de verdad.

Actualmente, la colección compartida se encuentra organizada en `BooksState`, un objeto `@Observable`, lo que permite mantener una sola fuente de verdad para los libros utilizados por las diferentes vistas.

`ContentView` mantiene una instancia de `BooksState`. Cuando el usuario guarda o elimina un libro desde Detalle, se modifica `isSaved` dentro de `booksState.books`. Después, Mis libros utiliza esa misma colección actualizada.

De esta forma, Detalle y Mis libros trabajan con el mismo estado y no necesitan mantener copias independientes de la información de guardado.

La idea es que cada dato viva en el nivel más bajo desde el que pueda compartirse correctamente, sin duplicar la fuente de verdad.

### Persistencia

La colección de libros guardados deberá persistirse localmente porque forma parte del MVP.

La persistencia y el estado de la interfaz tienen responsabilidades diferentes:

- El estado compartido permite que las pantallas trabajen con la misma colección durante la ejecución.
- La persistencia local permite recuperar esa colección cuando la aplicación se vuelva a abrir.

La implementación concreta de persistencia se realizará posteriormente. En esta etapa solo se define dónde debe vivir la información y cómo debe compartirse.

---

## 4. Estrategia de navegación

Para el flujo de OpenBooks se utilizan los mecanismos de navegación de SwiftUI que mejor se ajustan a la estructura del proyecto.

### NavigationStack

`NavigationStack` puede actuar como contenedor del flujo de navegación de una sección.

Su función es mantener una pila de vistas. Cuando se abre una pantalla nueva, esta se agrega sobre la anterior y el usuario puede regresar a la pantalla previa.

Esto resulta adecuado para recorridos como:

- Inicio → Detalle.
- Inicio → Buscar → Resultados → Detalle.
- Resultados → Buscar → Resultados.
- Mis libros → Detalle.
- Mis libros → Buscar → Resultados.

Además, evita tener que guardar manualmente una copia de la pantalla anterior solo para saber a dónde regresar.

### NavigationLink

`NavigationLink` puede utilizarse cuando el usuario toca directamente un elemento para abrir otra vista.

En OpenBooks puede utilizarse para:

- Abrir el detalle de un libro desde Inicio.
- Abrir el detalle de un resultado.
- Abrir el detalle de un libro guardado.

En la implementación actual, cada fila usa `NavigationLink` con un índice `Int` que identifica al libro. `ContentView` obtiene el elemento correspondiente de `booksState.books` y lo entrega a `BookDetailView` para mostrar el detalle.

### navigationDestination

`navigationDestination` permite relacionar un valor o tipo de navegación con la vista que debe mostrarse.

Para OpenBooks resulta útil porque **Detalle del libro es una misma pantalla que puede abrirse desde diferentes lugares**: Inicio, Resultados y Mis libros.

En lugar de diseñar tres pantallas de detalle diferentes, se mantiene una sola pantalla. `navigationDestination` recibe el índice y `ContentView` le proporciona el libro correspondiente a `BookDetailView`.

También se utiliza para organizar los destinos del flujo de búsqueda. En la implementación actual, la ruta puede abrir Buscar o Resultados según la acción realizada por el usuario.

### Navegación entre Inicio y Mis libros

Inicio y Mis libros son las dos secciones principales del proyecto.

La barra inferior definida en los wireframes puede cambiar entre ambas secciones. La sección activa debe pertenecer a la vista raíz porque es la vista que contiene y coordina esas dos opciones.

Este cambio de sección es diferente a abrir un detalle sobre una pantalla. Por eso, la selección de Inicio o Mis libros se mantiene como estado de la raíz, mientras que los recorridos hacia Resultados o Detalle pueden organizarse mediante `NavigationStack`.

### Regreso entre pantallas

Cuando el usuario abra Detalle mediante una navegación apilada, el regreso puede ser manejado por `NavigationStack`.

Los casos principales son:

- Inicio → Detalle → regresar a Inicio.
- Inicio → Buscar → regresar a Inicio si el usuario no realiza una búsqueda.
- Resultados → Buscar → regresar a Resultados si el usuario no realiza una nueva búsqueda.
- Resultados → Detalle → regresar a Resultados.
- Mis libros → Detalle → regresar a Mis libros.

### Guardar o eliminar un libro

Cuando el usuario guarde o elimine un libro:

1. Detalle solicita guardar o eliminar el libro.
2. `ContentView` modifica `isSaved` del libro seleccionado dentro de `booksState.books`.
3. Mis libros utiliza ese mismo estado compartido.
4. La interfaz de Mis libros refleja el cambio.
5. De acuerdo con el flujo definido para el proyecto, el usuario puede continuar hacia Mis libros.

No se necesita crear una copia diferente del estado de guardado para cada pantalla.

---

## 5. Relación con la implementación actual

Las decisiones de navegación y organización del estado definidas anteriormente ya se encuentran aplicadas en el prototipo actual de OpenBooks.

La aplicación utiliza `NavigationStack` como contenedor del flujo principal y una ruta almacenada en `ContentView` para representar los destinos que se encuentran dentro de la pila de navegación.

Las filas de libros utilizan `NavigationLink` para abrir el detalle correspondiente y `navigationDestination` relaciona los valores de navegación con las pantallas Buscar, Resultados y Detalle.

Inicio y Resultados muestran una lupa que abre la vista Buscar. El campo editable se encuentra únicamente en Buscar. El texto de búsqueda pertenece a `ContentView` mediante `@State` y Buscar lo modifica mediante `@Binding`. Resultados utiliza el texto actual para elegir qué libros de prueba mostrar, sin mostrar la consulta como un encabezado independiente.

Cuando el usuario presiona Enter desde Buscar, se ejecuta `searchBooks()` y la ruta se actualiza para mostrar Resultados. Por ahora, esta función reconoce las búsquedas «Harry Potter» y «Orgullo y prejuicio» y muestra el estado sin resultados para las demás consultas. No realiza solicitudes a Open Library ni activa los estados de carga o error.

Para la colección de libros se utiliza `BooksState`, definido como un objeto `@Observable`. `ContentView` mantiene una instancia de este estado y proporciona la misma colección a las vistas que la necesitan.

Cuando el usuario guarda o elimina un libro desde Detalle, se modifica `isSaved` dentro de `booksState.books`. Después, Mis libros utiliza esa misma colección actualizada.

De esta forma existe una sola fuente de verdad para el estado de guardado y el cambio realizado en una vista puede reflejarse en otra.

---

## 6. Decisiones principales

1. **Inicio será la pantalla inicial.**
2. **Buscar será una vista dedicada para escribir la consulta** y se abrirá desde la lupa de Inicio, Resultados o la acción Buscar libros de Mis libros.
3. **La búsqueda se ejecutará al presionar Enter en el teclado** desde la vista Buscar.
4. **Resultados será una sola pantalla con diferentes estados**, no una pantalla diferente para carga, error o sin resultados.
5. **Detalle del libro será reutilizable** sin importar si se abre desde Inicio, Resultados o Mis libros.
6. **Mis libros vacío será un estado de Mis libros**, no una pantalla independiente.
7. **Sin portada será una condición del libro**, no una pantalla.
8. **Los libros guardados tendrán una sola fuente de verdad compartida**.
9. **El texto de búsqueda pertenecerá a `ContentView` y Buscar lo modificará mediante `@Binding`**.
10. **El libro seleccionado viajará hacia Detalle como información de navegación**.
11. **`NavigationStack`, `NavigationLink` y `navigationDestination` son los mecanismos utilizados para organizar el flujo en SwiftUI**.
12. **Las decisiones de navegación y estado definidas en este documento ya se encuentran aplicadas en la implementación actual del proyecto**.

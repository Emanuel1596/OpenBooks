# Propuesta de arquitectura MVVM

Este documento analiza la estructura actual de OpenBooks y propone una forma de separar responsabilidades mediante MVVM.

La intención no es implementar todavía toda la arquitectura, sino identificar qué partes del proyecto corresponden a los datos, cuáles pertenecen a la interfaz y qué lógica podría salir de las vistas para mantener el proyecto más organizado conforme continúe creciendo.

## 1. Estructura actual del proyecto

Actualmente, la aplicación se encuentra dividida principalmente en los siguientes archivos:

### `Book.swift`

Contiene el modelo `Book`, que representa la información de cada libro, como:

- Título.
- Autor.
- Año.
- Disponibilidad de portada.
- Estado de guardado.

También contiene `SearchViewState`, utilizado para representar los diferentes estados de la búsqueda, y `BooksState`, que mantiene la colección compartida de libros mediante `@Observable`.

Por lo tanto, este archivo actualmente reúne información relacionada con los datos y con parte del estado utilizado por la aplicación.

---

### `MockBooks.swift`

Contiene los libros locales utilizados actualmente para probar el funcionamiento de la aplicación.

Estos datos permiten trabajar con las pantallas, búsquedas, detalles y libros guardados antes de integrar la información real obtenida desde Open Library.

---

### `ContentView.swift`

Actualmente funciona como la vista raíz de la aplicación.

Entre sus responsabilidades se encuentran:

- Mantener el `NavigationStack`.
- Mantener la ruta actual de navegación.
- Decidir si se muestra Inicio o Mis libros.
- Mantener el texto de búsqueda.
- Mantener el estado actual de la búsqueda.
- Mantener el estado compartido de los libros mediante `BooksState`.
- Crear y conectar las diferentes vistas.
- Ejecutar la lógica actual de búsqueda.
- Modificar el estado de guardado de un libro.
- Definir los destinos de navegación hacia Resultados y Detalle.

Esta es actualmente la vista que concentra la mayor cantidad de responsabilidades.

---

### `HomeView.swift`

Representa la pantalla principal de OpenBooks.

Su responsabilidad principal es mostrar:

- El nombre de la aplicación.
- El campo de búsqueda.
- La lista inicial de libros.
- El acceso a Mis libros.

También contiene componentes reutilizables utilizados para representar el campo de búsqueda y las filas de libros.

Las filas utilizan `NavigationLink` para iniciar la navegación hacia el detalle del libro seleccionado.

---

### `SearchResultsView.swift`

Representa la pantalla de resultados.

Recibe:

- El texto de búsqueda.
- La colección de libros.
- El estado actual de la búsqueda.

A partir de esta información muestra los diferentes estados de la interfaz:

- Carga.
- Contenido.
- Sin resultados.
- Error.

También permite realizar nuevamente una búsqueda y navegar hacia el detalle de un libro.

---

### `BookDetailView.swift`

Representa la pantalla de detalle de un libro.

Muestra la información del libro seleccionado y permite al usuario:

- Guardarlo en Mis libros.
- Eliminarlo de Mis libros.
- Regresar mediante la navegación.
- Cambiar entre las secciones principales de la aplicación.

La vista no mantiene una segunda colección independiente de libros guardados. Cuando el usuario guarda o elimina un libro, el cambio se realiza sobre el estado compartido de la aplicación.

---

### `MyBooksView.swift`

Representa la sección de libros guardados.

Recibe la colección de libros y muestra solamente aquellos cuyo estado indica que se encuentran guardados.

También determina:

- Si existe al menos un libro guardado.
- Si debe mostrar el estado de lista vacía.
- Si existe otro libro guardado después de una posición para organizar visualmente la lista.

Por lo tanto, además de presentar la interfaz, actualmente contiene una pequeña parte de lógica relacionada con la colección de libros guardados.

---

### `OpenBooksApp.swift`

Representa el punto de entrada de la aplicación y muestra `ContentView` como contenido principal.

---

## Situación actual

La aplicación ya tiene separadas sus pantallas principales y cuenta con un modelo para representar los libros.

También existe una sola fuente de verdad para la colección compartida de libros, lo que permite que los cambios realizados al guardar o eliminar un libro se reflejen en las diferentes vistas que utilizan esa información.

Sin embargo, todavía existe lógica de la aplicación dentro de algunas vistas.

El caso principal es `ContentView`, ya que actualmente no solamente presenta y conecta vistas, sino que también controla navegación, búsqueda, estado compartido y cambios sobre los libros guardados.

`MyBooksView` también contiene lógica para determinar qué información debe mostrarse dependiendo de los libros que se encuentran guardados.

Estas responsabilidades son las principales candidatas a analizar antes de realizar una separación mediante MVVM.

## 2. Separación de responsabilidades

En OpenBooks existen diferentes tipos de responsabilidades que actualmente se encuentran repartidas entre los modelos y las vistas.

Para mantener el proyecto organizado conforme continúe creciendo, conviene distinguir entre la interfaz, los datos y la lógica de la aplicación.

### Interfaz

El código relacionado con la interfaz se encarga de mostrar información y permitir que el usuario interactúe con la aplicación.

En OpenBooks esta responsabilidad corresponde principalmente a vistas como:

- `HomeView`.
- `SearchResultsView`.
- `BookDetailView`.
- `MyBooksView`.

Estas vistas muestran textos, listas, botones, estados visuales y opciones de navegación.

Su responsabilidad principal debería ser presentar la información que reciben y comunicar las acciones realizadas por el usuario.

---

### Datos

Los datos representan la información con la que trabaja la aplicación.

En OpenBooks, el principal ejemplo es `Book`, que contiene información como:

- Título.
- Autor.
- Año.
- Disponibilidad de portada.
- Estado de guardado.

Estos datos pueden ser utilizados por diferentes pantallas y no pertenecen exclusivamente a una sola vista.

---

### Estado y lógica de la aplicación

Existe información que puede cambiar durante el uso de la aplicación y que modifica lo que se muestra en pantalla.

Actualmente, algunos ejemplos son:

- El texto de búsqueda.
- El estado de una búsqueda.
- La colección compartida de libros.
- El estado de guardado de cada libro.
- La sección principal que se encuentra activa.
- La ruta de navegación.

También existe lógica que determina qué debe ocurrir cuando el usuario realiza una acción.

Por ejemplo:

- Ejecutar una búsqueda.
- Cambiar el estado de la búsqueda.
- Guardar o eliminar un libro.
- Determinar qué libros deben aparecer en Mis libros.

Parte de esta lógica actualmente se encuentra dentro de las vistas, principalmente en `ContentView` y `MyBooksView`.

---

### Problema de concentrar demasiadas responsabilidades

Una vista puede volverse más difícil de entender cuando, además de mostrar la interfaz, también administra diferentes estados, modifica datos y ejecuta lógica de la aplicación.

Actualmente, `ContentView` es el ejemplo más claro dentro de OpenBooks.

Además de conectar las diferentes pantallas, también:

- Mantiene el estado compartido.
- Controla parte de la navegación.
- Mantiene el texto de búsqueda.
- Mantiene el estado de la búsqueda.
- Ejecuta la lógica de búsqueda.
- Modifica el estado de guardado de los libros.

Mientras el proyecto es pequeño, esta organización todavía puede funcionar.

Sin embargo, conforme se agregue el funcionamiento real de Open Library, la persistencia local y más comportamiento al proyecto, `ContentView` podría comenzar a concentrar demasiadas responsabilidades.

Separar estas tareas permitiría que las vistas se enfoquen principalmente en presentar la información y responder a la interacción del usuario.

---

### Caso de `MyBooksView`

`MyBooksView` se encarga principalmente de presentar los libros guardados.

Sin embargo, también contiene lógica para:

- Determinar si existe al menos un libro guardado.
- Decidir si debe mostrarse el estado vacío.
- Determinar si existe otro libro guardado después de una posición para organizar visualmente la lista.

Parte de esta lógica depende de la colección de libros y no solamente de la construcción visual de la pantalla.

Por esta razón, también es una candidata para analizar qué responsabilidades podrían mantenerse en la vista y cuáles podrían organizarse fuera de ella.

## 3. MVVM aplicado a OpenBooks

MVVM propone separar la aplicación en tres partes principales:

- Model.
- View.
- ViewModel.

La intención de aplicar esta separación en OpenBooks sería evitar que las vistas tengan que encargarse al mismo tiempo de presentar la interfaz, mantener diferentes estados y ejecutar la lógica de la aplicación.

### Model

El Model representa los datos y conceptos principales de la aplicación.

En OpenBooks, el ejemplo principal es `Book`.

Este modelo representa un libro y contiene información como:

- Título.
- Autor.
- Año.
- Disponibilidad de portada.
- Estado de guardado.

`MockBooks.swift` contiene los datos locales que se utilizan actualmente para trabajar con estos modelos antes de integrar la información real de Open Library.

El Model representa los datos y no debería encargarse de decidir cómo se presentan visualmente en una pantalla.

---

### View

Las View representan la interfaz y la interacción con el usuario.

Actualmente, las principales vistas de OpenBooks son:

- `ContentView`.
- `HomeView`.
- `SearchResultsView`.
- `BookDetailView`.
- `MyBooksView`.

También existen componentes visuales reutilizables, como el campo de búsqueda y las filas utilizadas para representar libros.

Las vistas se encargan principalmente de:

- Mostrar información.
- Construir la interfaz con SwiftUI.
- Mostrar los diferentes estados visuales.
- Recibir acciones del usuario.
- Comunicar acciones como buscar, guardar o eliminar.
- Realizar la navegación correspondiente mediante los mecanismos utilizados por la aplicación.

La View debería concentrarse principalmente en presentar el estado disponible y en permitir que el usuario interactúe con la aplicación.

---

### ViewModel

El ViewModel coordina el estado y la lógica que una View necesita para poder presentar la información.

Dentro de OpenBooks, un ViewModel podría encargarse de responsabilidades como:

- Ejecutar una búsqueda.
- Actualizar el estado de una búsqueda.
- Mantener la información necesaria para mostrar los resultados.
- Determinar qué libros están guardados.
- Guardar o eliminar un libro.
- Preparar la información que una View necesita mostrar.

Actualmente estas responsabilidades todavía no se encuentran organizadas completamente en ViewModels.

Parte de ellas se encuentran dentro de `ContentView`, `MyBooksView` y del estado compartido representado actualmente por `BooksState`.

Por esta razón, la propuesta de MVVM no consiste en reemplazar inmediatamente todo el código existente, sino en identificar qué responsabilidades podrían trasladarse gradualmente fuera de las vistas.

---

### Relación entre los componentes

De forma general, la relación sería:

```text
Usuario
   ↓
View
   ↓
ViewModel
   ↓
Model
```

Cuando una acción del usuario produce un cambio de estado, ese cambio posteriormente debe reflejarse en la interfaz.

```text
Usuario realiza una acción
        ↓
View comunica la acción
        ↓
ViewModel realiza la lógica necesaria
        ↓
El estado cambia
        ↓
View muestra el nuevo estado
```

Por ejemplo, aplicado al guardado de un libro:

```text
Usuario pulsa "Guardar libro"
        ↓
BookDetailView comunica la acción
        ↓
Se modifica el estado compartido del libro
        ↓
MyBooksView utiliza ese mismo estado
        ↓
El libro aparece en Mis libros
```

Actualmente este flujo ya existe parcialmente mediante el estado compartido de los libros.

La propuesta de MVVM permitiría organizar con mayor claridad la lógica relacionada con estas acciones sin crear diferentes copias del mismo estado.

## 4. Aplicación del análisis a OpenBooks

A partir de la estructura actual se pueden identificar elementos que corresponden al Model, elementos que corresponden a las View y responsabilidades que podrían organizarse posteriormente en ViewModels.

### Elementos que corresponden al Model

El elemento principal es:

- `Book`.

`Book` representa la información propia de cada libro.

Sus propiedades forman parte de los datos con los que trabaja la aplicación.

---

### Elementos que corresponden a las View

Actualmente corresponden a la interfaz:

- `ContentView`.
- `HomeView`.
- `SearchResultsView`.
- `BookDetailView`.
- `MyBooksView`.

Estas vistas construyen las pantallas y muestran la información correspondiente al usuario.

---

### Responsabilidades que podrían salir de `ContentView`

`ContentView` debe continuar funcionando como la vista raíz y puede seguir siendo responsable de organizar la navegación principal.

Sin embargo, actualmente contiene otras responsabilidades que podrían separarse.

#### Lógica de búsqueda

Actualmente `ContentView` mantiene información relacionada con la búsqueda y ejecuta la acción correspondiente.

Esta responsabilidad podría organizarse en un ViewModel dedicado al flujo de búsqueda.

Este ViewModel podría encargarse de:

- Mantener el texto utilizado para la búsqueda.
- Mantener el estado de la búsqueda.
- Ejecutar la búsqueda.
- Cambiar entre los estados de carga, contenido, sin resultados o error.
- Mantener la información necesaria para presentar los resultados.

De esta forma, `SearchResultsView` podría concentrarse en mostrar el estado que recibe.

#### Lógica de libros guardados

Actualmente `ContentView` también participa en la modificación del estado de guardado de los libros.

Esta responsabilidad podría organizarse en un ViewModel encargado de la colección compartida.

Este ViewModel podría encargarse de:

- Mantener la colección compartida de libros.
- Guardar un libro.
- Eliminar un libro de Mis libros.
- Permitir conocer cuáles libros están guardados.

De esta forma se mantendría una sola fuente de verdad para la información compartida.

---

### Responsabilidades que podrían salir de `MyBooksView`

`MyBooksView` debería concentrarse principalmente en mostrar:

- La lista de libros guardados.
- El estado vacío cuando no existan libros guardados.
- Las opciones de navegación correspondientes.

La lógica utilizada para determinar qué libros se encuentran guardados podría obtenerse desde el mismo estado compartido encargado de la colección.

De esta manera, la vista recibiría la información necesaria para presentarla sin tener que encargarse de toda la lógica relacionada con la colección.

Algunas decisiones exclusivamente visuales pueden continuar dentro de la vista cuando solamente se utilicen para construir la presentación.

## 5. ViewModels propuestos

La propuesta no busca crear un ViewModel para cada archivo o cada componente visual.

Para el estado actual de OpenBooks, se proponen únicamente ViewModels relacionados con responsabilidades que ya comienzan a crecer dentro de las vistas.

### `SearchViewModel`

Estaría relacionado con el flujo de búsqueda.

Sus responsabilidades propuestas serían:

- Mantener el texto de búsqueda utilizado por Inicio y Resultados.
- Mantener el estado actual de la búsqueda.
- Ejecutar la acción de búsqueda.
- Mantener la información necesaria para mostrar los resultados.
- Actualizar el estado cuando una búsqueda se encuentre cargando, tenga contenido, no tenga resultados o produzca un error.

Esto permitiría que `HomeView` y `SearchResultsView` se enfoquen principalmente en la interfaz del flujo de búsqueda.

---

### `BooksViewModel`

Estaría relacionado con la colección de libros utilizada por las diferentes pantallas.

Sus responsabilidades propuestas serían:

- Mantener la colección compartida de libros.
- Mantener una sola fuente de verdad para el estado de guardado.
- Guardar un libro.
- Eliminar un libro guardado.
- Permitir obtener los libros que deben aparecer en Mis libros.

El estado que actualmente mantiene `BooksState` serviría como punto de partida para esta responsabilidad.

La intención no sería mantener al mismo tiempo dos colecciones diferentes, sino conservar una sola fuente de verdad y organizar alrededor de ella la lógica relacionada con los libros guardados.

---

### ViewModels que no son necesarios actualmente

No es necesario crear un ViewModel diferente para cada componente visual.

Por ejemplo, componentes que solamente presentan información, como una fila de libro, pueden continuar funcionando como View.

Tampoco es necesario agregar más componentes de arquitectura mientras el MVP no los necesite.

La propuesta busca separar solamente las responsabilidades que actualmente aportan claridad al proyecto.

## 6. Estado local y estado compartido en la propuesta

La aplicación seguirá necesitando tanto estado local como estado compartido.

### Estado local

Un estado puede permanecer local cuando solamente pertenece a una vista o a una parte específica del flujo.

En la propuesta, pueden mantenerse como estado local de la vista raíz:

- La ruta utilizada por `NavigationStack`.
- La selección entre Inicio y Mis libros.

Estos datos están relacionados directamente con la navegación que coordina la vista raíz.

El libro seleccionado tampoco necesita convertirse en una segunda copia global del estado.

Puede continuar viajando como información necesaria para mostrar la pantalla de Detalle.

---

### Estado compartido

El estado debe ser compartido cuando diferentes vistas necesitan utilizar la misma información.

En OpenBooks, los principales casos son:

#### Texto y estado de búsqueda

Inicio y Resultados forman parte del mismo flujo de búsqueda.

Por esta razón, la información necesaria para ese flujo debe mantenerse disponible mientras el usuario navega entre esas pantallas.

En la propuesta, esta responsabilidad estaría asociada a `SearchViewModel`.

#### Colección de libros

Inicio, Resultados, Detalle y Mis libros pueden necesitar información de los libros.

Especialmente, Detalle y Mis libros necesitan coincidir respecto al estado de guardado.

Por esta razón, la colección debe mantenerse como estado compartido y conservar una sola fuente de verdad.

En la propuesta, esta responsabilidad estaría asociada a `BooksViewModel`.

---

### Single Source of Truth

La propuesta debe conservar el principio de una sola fuente de verdad que ya se comenzó a aplicar en el proyecto.

El estado de guardado de un libro no debe existir como diferentes copias independientes en Detalle y Mis libros.

Cuando un libro cambie de estado, las vistas que utilizan esa información deben reflejar el mismo valor.

```text
BooksViewModel
      ↓
colección compartida
   ↙            ↘
Detalle      Mis libros
```

De esta forma, guardar o eliminar un libro modifica la misma información que posteriormente utilizan las demás vistas.

## 7. Organización propuesta

Sin implementar todavía los cambios, la organización conceptual de OpenBooks podría quedar de la siguiente manera:

```text
OpenBooks
│
├── Model
│   └── Book
│
├── View
│   ├── ContentView
│   ├── HomeView
│   ├── SearchResultsView
│   ├── BookDetailView
│   └── MyBooksView
│
├── ViewModel
│   ├── SearchViewModel
│   └── BooksViewModel
│
├── MockBooks
│
└── OpenBooksApp
```

Esta estructura representa una propuesta de organización de responsabilidades.

No significa que todos estos cambios deban realizarse al mismo tiempo.

La intención es utilizarla como guía para una refactorización gradual del proyecto.

## 8. Relación entre pantallas y ViewModels

La propuesta relacionaría las pantallas actuales de la siguiente forma:

| Pantalla | Información principal | ViewModel relacionado |
| --- | --- | --- |
| Inicio | Texto de búsqueda y lista de libros | `SearchViewModel` y `BooksViewModel` |
| Resultados | Texto, estado y resultados de búsqueda | `SearchViewModel` |
| Detalle | Libro seleccionado y estado de guardado | `BooksViewModel` |
| Mis libros | Libros guardados | `BooksViewModel` |

`ContentView` continuaría coordinando la estructura principal de navegación y conectando las vistas necesarias.

La navegación no necesita convertirse en otro componente mientras la organización actual siga siendo suficiente para el MVP.

## 9. Primeros cambios propuestos para una refactorización

La propuesta plantea realizar los cambios de forma gradual para evitar modificar todo el proyecto al mismo tiempo.

### Primer cambio: separar la búsqueda

El primer cambio podría consistir en sacar de `ContentView` la responsabilidad relacionada con:

- El texto de búsqueda compartido.
- El estado de búsqueda.
- La acción de búsqueda.

Estas responsabilidades podrían pasar a `SearchViewModel`.

Después, `HomeView` y `SearchResultsView` utilizarían el estado coordinado por ese ViewModel para presentar la información.

---

### Segundo cambio: organizar los libros guardados

El siguiente cambio podría consistir en organizar la responsabilidad que actualmente cumple `BooksState` junto con la lógica utilizada para guardar y eliminar libros.

Esta responsabilidad podría formar `BooksViewModel`.

El objetivo sería mantener:

- Una sola colección compartida.
- Una sola fuente de verdad.
- La lógica de guardar y eliminar fuera de las vistas.

---

### Tercer cambio: simplificar `MyBooksView`

Una vez organizada la colección compartida, la información necesaria para mostrar los libros guardados podría obtenerse mediante `BooksViewModel`.

`MyBooksView` podría concentrarse principalmente en presentar:

- Los libros guardados.
- El estado vacío.
- Las opciones visuales y de navegación.

---

### Responsabilidades que pueden permanecer en las View

No toda la lógica debe salir de una View.

Las responsabilidades relacionadas directamente con la construcción de la interfaz pueden permanecer dentro de ellas.

Por ejemplo:

- `VStack`, `HStack` y otros layouts.
- `padding`.
- `frame`.
- `Spacer`.
- Modifiers visuales.
- Organización visual de textos, imágenes y botones.
- Composición mediante subviews.
- `NavigationLink` utilizado para iniciar una navegación desde una opción visible.

La separación debe realizarse solamente cuando exista una responsabilidad clara que convenga organizar fuera de la presentación.

## 10. Beneficios de la propuesta

Aplicar gradualmente esta organización permitiría:

- Reducir la cantidad de responsabilidades dentro de `ContentView`.
- Mantener las vistas enfocadas principalmente en la presentación.
- Separar la lógica de búsqueda de la construcción visual de las pantallas.
- Mantener organizada la lógica de libros guardados.
- Conservar una sola fuente de verdad para el estado compartido.
- Facilitar la comprensión del flujo de información.
- Hacer más claro dónde debe realizarse cada cambio conforme crezca el proyecto.
- Evitar repetir lógica en diferentes vistas.

## 11. Complejidad adicional

La aplicación de MVVM también agrega cierta complejidad.

Al separar responsabilidades:

- El proyecto tendría más archivos.
- Sería necesario identificar correctamente qué estado pertenece a cada parte.
- Las vistas tendrían que comunicarse con sus ViewModels.
- Sería necesario mantener claro el flujo de información entre Model, ViewModel y View.

Por esta razón, no conviene crear componentes adicionales sin una responsabilidad clara.

La propuesta para OpenBooks se limita a separar las partes que actualmente ya concentran suficiente estado o lógica como para justificarlo.

## 12. Flujo de información propuesto

### Búsqueda

El flujo de búsqueda podría organizarse así:

```text
Usuario escribe una búsqueda
        ↓
HomeView
        ↓
SearchViewModel
        ↓
actualiza estado de búsqueda
        ↓
SearchResultsView
        ↓
muestra carga, contenido, sin resultados o error
```

### Guardar un libro

El flujo para guardar un libro podría organizarse así:

```text
Usuario pulsa "Guardar libro"
        ↓
BookDetailView
        ↓
BooksViewModel
        ↓
modifica la colección compartida
        ↓
MyBooksView
        ↓
muestra el libro guardado
```

### Eliminar un libro

El flujo para eliminar un libro podría organizarse así:

```text
Usuario pulsa "Eliminar de Mis libros"
        ↓
BookDetailView
        ↓
BooksViewModel
        ↓
modifica la colección compartida
        ↓
MyBooksView
        ↓
actualiza la lista o muestra el estado vacío
```

En los tres casos, una acción del usuario produce un cambio de estado y ese cambio posteriormente se refleja en la interfaz.

## 13. Decisiones principales de la propuesta

1. `Book` continuará representando los datos de cada libro.

2. Las pantallas actuales continuarán funcionando como View.

3. `ContentView` continuará funcionando como vista raíz y coordinando la navegación principal.

4. La lógica de búsqueda es una de las principales responsabilidades que conviene sacar de `ContentView`.

5. La lógica relacionada con guardar, eliminar y obtener los libros guardados debe mantenerse alrededor de una sola fuente de verdad compartida.

6. `SearchViewModel` se propone para coordinar el estado y la lógica del flujo de búsqueda.

7. `BooksViewModel` se propone para coordinar la colección compartida y la lógica de libros guardados.

8. La ruta de navegación y la sección principal activa pueden permanecer como estado local de la vista raíz.

9. El libro seleccionado continuará pasando a Detalle mediante la navegación, sin crear una segunda copia global.

10. No es necesario crear un ViewModel para cada View.

11. No se propone agregar componentes que el MVP todavía no necesita.

12. Los cambios deberían realizarse de manera gradual y manteniendo el proyecto compilando y funcionando durante la refactorización.

## Conclusión

La estructura actual de OpenBooks permite que el MVP continúe funcionando, pero `ContentView` comienza a concentrar responsabilidades relacionadas con navegación, búsqueda y estado compartido.

La propuesta basada en MVVM busca separar gradualmente esas responsabilidades sin modificar innecesariamente las partes que ya tienen una función clara.

`Book` continuaría representando los datos principales de la aplicación, las View se enfocarían principalmente en presentar información y recibir acciones del usuario, y los ViewModel coordinarían el estado y la lógica necesaria para cada flujo.

Los primeros casos que justifican esta separación son la búsqueda y la colección de libros guardados.

De esta manera, OpenBooks podría continuar creciendo con una organización más clara, manteniendo una sola fuente de verdad para la información compartida y evitando concentrar toda la lógica dentro de las vistas.
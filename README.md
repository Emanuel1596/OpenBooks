## Accesibilidad con VoiceOver

La accesibilidad se consideró desde la etapa de diseño de los wireframes y del flujo de usuario de OpenBooks.

El objetivo es que una persona que utilice VoiceOver pueda comprender la información principal de cada pantalla, identificar las acciones disponibles y navegar por la aplicación sin recibir información innecesaria o repetida.

Para decidir qué elementos deben ser anunciados se seguirá una regla principal:

> Si una persona que no puede ver la pantalla necesita conocer un elemento para comprender o utilizar la aplicación, VoiceOver debe proporcionar esa información. Si el elemento es únicamente decorativo o repite información que ya está disponible mediante texto, no será necesario anunciarlo de forma independiente.

Las etiquetas de accesibilidad deberán ser breves, claras y describir directamente la información o acción relevante.

No se utilizarán nombres técnicos de imágenes, archivos o iconos como parte de la información anunciada.

Por ejemplo, no sería útil anunciar:

`cover_1984.jpg`

o:

`Icono de bookmark`

En cambio, las acciones deben poder entenderse directamente mediante textos como:

`Buscar libros`

`Guardar libro`

`Eliminar de Mis libros`

`Intentar nuevamente`

No es necesario agregar palabras como “botón” dentro de estas etiquetas, ya que la propia interfaz puede identificar el tipo de control.

### Pantalla principal

En la pantalla principal se encuentran el nombre de la aplicación, el buscador, la sección de libros, una lista inicial y la navegación entre **Inicio** y **Mis libros**.

VoiceOver deberá permitir identificar:

| Elemento | Comportamiento esperado |
| --- | --- |
| `OpenBooks` | Se anuncia como el nombre principal de la pantalla. |
| Campo de búsqueda | Se identifica como `Buscar libros`. |
| Sección `Libros` | Se anuncia para indicar el contenido que comienza a continuación. |
| Título y autor de cada libro | Se presentan como información relacionada, por ejemplo: `1984, George Orwell`. |
| `Inicio` | Debe poder identificarse como opción de navegación. |
| `Mis libros` | Debe poder identificarse como opción de navegación. |

La lupa utilizada dentro del buscador no necesita anunciarse por separado, ya que su función ya está representada mediante el campo **Buscar libros**.

Las portadas tampoco necesitan convertirse en elementos independientes cuando la misma fila ya contiene el título y el autor del libro.

La flecha ubicada al final de cada fila funciona como un indicador visual de que el libro puede abrirse, por lo que tampoco necesita ser una parada independiente para VoiceOver.

En las filas se buscará que la información relacionada pueda comprenderse de manera conjunta.

Por ejemplo, en lugar de obligar al usuario a recorrer por separado:

`1984`

`George Orwell`

`flecha`

la información importante de la opción es:

`1984, George Orwell`

Esto evita una navegación innecesariamente fragmentada.

### Resultados de búsqueda

La pantalla de resultados conserva una estructura similar a la pantalla principal, pero muestra los libros encontrados después de realizar una búsqueda.

VoiceOver deberá permitir identificar:

| Elemento | Comportamiento esperado |
| --- | --- |
| Acción para regresar | Permite volver a la pantalla anterior. |
| `Resultados` | Se anuncia como título de la pantalla. |
| Campo de búsqueda | Se identifica como `Buscar libros` y conserva el texto escrito por el usuario. |
| Título y autor de cada resultado | Se comunican como información relacionada. |
| Navegación inferior | Permite identificar `Inicio` y `Mis libros`. |

Por ejemplo, uno de los resultados podría comunicarse como:

`Harry Potter y la piedra filosofal, J. K. Rowling`

La portada y la flecha de navegación no necesitan anunciarse individualmente si no aportan información adicional respecto al título y al autor.

### Detalle de un libro no guardado

La pantalla de detalle contiene la información principal del libro seleccionado y la acción disponible para guardarlo.

VoiceOver deberá permitir acceder a:

| Elemento | Comportamiento esperado |
| --- | --- |
| Acción para regresar | Permite volver a la pantalla anterior. |
| `Detalle del libro` | Se anuncia como título de la pantalla. |
| Título del libro | Se anuncia como información principal. |
| Autor o autores | Se anuncian como información del libro. |
| Año de publicación | Se anuncia cuando esté disponible. |
| `Guardar libro` | Se identifica claramente como la acción disponible. |

Un ejemplo de la información importante de esta pantalla sería:

`Harry Potter y la piedra filosofal`

`J. K. Rowling`

`Año, 1997`

`Guardar libro`

La portada no necesita anunciarse por separado cuando no aporta información adicional a la identificación del libro.

### Mis libros

La sección **Mis libros** muestra los libros que el usuario haya guardado en su colección personal.

VoiceOver deberá permitir identificar:

| Elemento | Comportamiento esperado |
| --- | --- |
| `Mis libros` | Se anuncia como título de la sección. |
| Título y autor de cada libro guardado | Se presentan como información relacionada. |
| `Inicio` | Permite regresar a la sección principal. |
| `Mis libros` | Permite identificar la sección actual. |

Por ejemplo:

`Cien años de soledad, Gabriel García Márquez`

o:

`1984, George Orwell`

Al igual que en las otras listas, las portadas y las flechas utilizadas únicamente como apoyo visual no necesitan convertirse en elementos independientes para VoiceOver.

El usuario necesita conocer qué libros tiene guardados, pero no necesita recorrer varios elementos redundantes para identificar cada uno.

### Detalle de un libro guardado

Esta pantalla utiliza la misma estructura de detalle de libro, pero cambia la acción disponible debido al estado del libro.

VoiceOver deberá permitir acceder a:

| Elemento | Comportamiento esperado |
| --- | --- |
| `Detalle del libro` | Se anuncia como título de la pantalla. |
| Título del libro | Se anuncia como información principal. |
| Autor o autores | Se anuncian como información del libro. |
| Año de publicación | Se anuncia cuando esté disponible. |
| `Eliminar de Mis libros` | Se identifica claramente como la acción disponible. |

Por ejemplo:

`Cien años de soledad`

`Gabriel García Márquez`

`Año, 1967`

`Eliminar de Mis libros`

La diferencia principal respecto al detalle de un libro no guardado será la acción disponible.

Esto permite que la accesibilidad refleje el estado actual de la interfaz: si el libro no está guardado, la acción es **Guardar libro**; si ya está guardado, la acción es **Eliminar de Mis libros**.

### Mis libros vacío

Cuando el usuario todavía no tenga libros guardados se mostrará un estado vacío.

VoiceOver deberá permitir identificar:

| Elemento | Comportamiento esperado |
| --- | --- |
| `Mis libros` | Se anuncia como título de la pantalla. |
| Mensaje principal | `Todavía no tienes libros guardados`. |
| Explicación | `Busca un libro y guárdalo para verlo aquí`. |
| `Buscar libros` | Se identifica como la acción disponible para continuar. |

El icono de libro utilizado en este estado es únicamente decorativo.

No sería necesario anunciar:

`Imagen de libro`

antes de comunicar:

`Todavía no tienes libros guardados`

porque el icono no agrega información necesaria para comprender la situación.

### Estado de carga

Mientras se realiza una búsqueda en Open Library se mostrará un estado de carga.

La información importante para VoiceOver será el mensaje que indique al usuario que la búsqueda se encuentra en proceso.

Por ejemplo:

`Buscando libros`

y, si se mantiene el texto complementario visible:

`Esto puede tardar unos segundos`

Los iconos utilizados únicamente para representar visualmente la carga no necesitan aportar información adicional si el mensaje ya explica lo que está ocurriendo.

### Búsqueda sin resultados

Cuando Open Library no devuelva coincidencias, VoiceOver deberá comunicar el estado al usuario.

La información importante será:

`No se encontraron libros`

`Intenta realizar otra búsqueda`

El campo de búsqueda seguirá siendo accesible para permitir que el usuario modifique el texto e intente nuevamente.

Los iconos visuales utilizados para representar una búsqueda sin resultados no necesitan ser anunciados de manera independiente cuando el mensaje de texto ya explica el estado.

### Error en la búsqueda

Cuando ocurra un problema al obtener información desde Open Library, VoiceOver deberá permitir comprender qué ocurrió y cuál es la acción disponible.

La información relevante será:

`No se pudieron cargar los libros`

`Ocurrió un error al obtener los resultados. Intenta nuevamente`

y la acción:

`Intentar nuevamente`

El objetivo es que el usuario no dependa únicamente de un icono o de un cambio visual para saber que ocurrió un error.

### Libro sin portada

Cuando Open Library no tenga una portada disponible para un libro, se mostrará un elemento visual sustituto.

Para VoiceOver no será necesario describir este elemento de manera independiente cuando el libro ya pueda identificarse mediante su título y autor.

Por ejemplo, si visualmente se presenta:

`Sin portada`

`Orgullo y prejuicio`

`Jane Austen`

la información fundamental para identificar el libro sigue siendo:

`Orgullo y prejuicio, Jane Austen`

Por esta razón, no se utilizarán nombres internos como:

`cover_missing.png`

`book_placeholder`

`image01`

Estos nombres no aportan información útil para una persona que utiliza VoiceOver.

Si en algún caso una imagen futura aportara información relevante que no estuviera disponible mediante texto, entonces sí debería utilizarse una descripción breve que explique únicamente esa información importante.

### Portadas e imágenes

En OpenBooks las portadas normalmente acompañan información que ya está disponible mediante el título y el autor.

Por este motivo, no se buscará que VoiceOver se detenga de manera independiente en cada portada cuando hacerlo provoque información redundante.

Visualmente puede existir:

`[PORTADA]`

`1984`

`George Orwell`

pero para comprender y seleccionar el libro resulta suficiente comunicar:

`1984, George Orwell`

La portada seguirá siendo visible dentro de la interfaz, pero no debe provocar una parada adicional de VoiceOver si no aporta información necesaria.

Si en el futuro alguna imagen contiene información que no esté representada mediante texto, su descripción deberá comunicar esa información de forma breve y comprensible.

Nunca se utilizará el nombre del archivo como descripción para el usuario.

### Textos y descripciones

La idea de mantener etiquetas concisas se aplica principalmente a las descripciones que se agreguen específicamente para accesibilidad.

Por ejemplo, no sería necesario utilizar una etiqueta como:

`Este es un botón que sirve para guardar el libro seleccionado dentro de la colección personal del usuario`

cuando la acción puede expresarse directamente como:

`Guardar libro`

Sin embargo, esto no significa que el contenido visible de la aplicación deba recortarse únicamente para VoiceOver.

Si en una versión futura de OpenBooks se agrega una sinopsis u otro contenido textual visible, esa información también deberá ser accesible.

Actualmente la sinopsis no forma parte del MVP, por lo que no se agregará contenido adicional únicamente para VoiceOver.

### Criterio general de accesibilidad

En OpenBooks no se busca describir individualmente cada elemento gráfico de la interfaz.

La prioridad será comunicar lo necesario para que una persona que utilice VoiceOver pueda:

- Saber en qué pantalla se encuentra.
- Conocer la información principal de cada libro.
- Utilizar la búsqueda.
- Seleccionar libros.
- Guardar o eliminar libros.
- Navegar entre **Inicio** y **Mis libros**.
- Comprender los estados de carga, error, búsqueda sin resultados y lista vacía.
- Identificar las acciones disponibles en cada momento.

Los elementos decorativos o redundantes, como determinadas portadas, lupas, flechas e iconos visuales, no necesitarán anunciarse de forma independiente cuando su información ya esté representada mediante contenido accesible.

De esta manera, la accesibilidad busca mantener una navegación comprensible y útil, evitando tanto la falta de información como la repetición innecesaria de contenido.

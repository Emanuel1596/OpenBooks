## Accesibilidad con VoiceOver

La accesibilidad se consideró desde el diseño de los wireframes y del flujo de usuario de OpenBooks.

El criterio principal es que VoiceOver comunique la información necesaria para comprender y utilizar la aplicación, evitando anunciar de forma independiente elementos decorativos o información que ya esté representada mediante texto.

Las etiquetas de accesibilidad serán breves, claras y describirán directamente la información o acción relevante. No se utilizarán nombres internos de archivos, imágenes o iconos como descripciones para el usuario.

### Información accesible por pantalla

| Pantalla o estado | Información relevante para VoiceOver |
| --- | --- |
| Pantalla principal | OpenBooks, Buscar libros, Libros, título y autor de cada libro, Inicio y Mis libros. |
| Resultados | Resultados, acción para regresar, Buscar libros, valor actual de la búsqueda y título y autor de cada resultado. |
| Detalle del libro | Acción para regresar, Detalle del libro, título, autor, año cuando esté disponible y Guardar libro o Eliminar de Mis libros, según corresponda. |
| Mis libros | Mis libros, título y autor de cada libro guardado, Inicio y Mis libros. |
| Mis libros vacío | Mis libros, Todavía no tienes libros guardados, Busca un libro y guárdalo para verlo aquí y Buscar libros. |
| Carga | Buscando libros y Esto puede tardar unos segundos. |
| Sin resultados | No se encontraron libros e Intenta realizar otra búsqueda. |
| Error | No se pudieron cargar los libros, el mensaje correspondiente e Intentar nuevamente. |
| Libro sin portada | El libro se identificará mediante su título y autor sin depender de la portada. |

En las listas de libros se buscará presentar el título y el autor como información relacionada. Por ejemplo:

1984, George Orwell

De esta manera se evita que el usuario tenga que recorrer por separado varios elementos que pertenecen a una misma opción.

### Elementos visuales

Los elementos que sean únicamente decorativos o que repitan información disponible mediante texto no necesitarán anunciarse de forma independiente.

Esto incluye:

- La lupa del buscador.
- Las flechas utilizadas como indicadores visuales.
- El icono utilizado en el estado Mis libros vacío.
- Las portadas cuando el libro ya pueda identificarse mediante su título y autor.

Por ejemplo, si una fila contiene una portada, el título 1984 y el autor George Orwell, la información relevante para VoiceOver será:

1984, George Orwell

Cuando Open Library no disponga de una portada, se mostrará un elemento visual sustituto, pero VoiceOver seguirá identificando el libro mediante su título y autor.

No se utilizarán nombres internos como cover_missing.png, book_placeholder o image01 como descripciones de accesibilidad.

Si en el futuro una imagen aporta información importante que no esté disponible mediante texto, deberá utilizarse una descripción breve que comunique únicamente la información necesaria para comprenderla.

### Etiquetas de accesibilidad

Las etiquetas creadas específicamente para accesibilidad serán concisas y describirán directamente la acción correspondiente.

Algunos ejemplos son:

- Buscar libros
- Guardar libro
- Eliminar de Mis libros
- Intentar nuevamente

No se utilizarán descripciones extensas cuando una acción pueda expresarse de forma directa.

Si posteriormente se agrega contenido textual visible, como una sinopsis, este también deberá ser accesible mediante VoiceOver. Actualmente la sinopsis no forma parte del MVP.

### Objetivo de accesibilidad

La accesibilidad de OpenBooks busca que una persona que utilice VoiceOver pueda identificar las pantallas, conocer la información principal de los libros, utilizar la búsqueda, consultar detalles, guardar o eliminar libros, navegar entre Inicio y Mis libros y comprender los distintos estados de la aplicación.

El objetivo es proporcionar la información necesaria para utilizar la aplicación sin generar contenido repetido o innecesario durante la navegación.

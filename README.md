## Accesibilidad con VoiceOver

La accesibilidad se consideró desde el diseño de los wireframes y del flujo de usuario de OpenBooks.

El criterio principal es que VoiceOver comunique la información necesaria para comprender y utilizar la aplicación, evitando anunciar de forma independiente elementos decorativos o información que ya esté representada mediante texto. :chatgpt-content-reference{index="1"}

Las etiquetas de accesibilidad serán breves, claras y describirán directamente la información o acción relevante. No se utilizarán nombres internos de archivos, imágenes o iconos.

### Elementos principales

| Pantalla o elemento | Información relevante para VoiceOver |
| --- | --- |
| Pantalla principal | OpenBooks, Buscar libros, Libros, título y autor de cada libro, Inicio y Mis libros. |
| Resultados | Resultados, acción para regresar, Buscar libros, título y autor de cada resultado. |
| Detalle del libro | Detalle del libro, título, autor, año cuando esté disponible y la acción Guardar libro o Eliminar de Mis libros. |
| Mis libros | Mis libros, título y autor de cada libro guardado, Inicio y Mis libros. |
| Mis libros vacío | Mis libros, Todavía no tienes libros guardados, Busca un libro y guárdalo para verlo aquí y Buscar libros. |

En las listas de libros se buscará presentar título y autor como información relacionada. Por ejemplo:

1984, George Orwell

Esto evita que el usuario tenga que recorrer por separado varios elementos que pertenecen a una misma opción. :chatgpt-content-reference{index="2"}

### Estados de la aplicación

Los estados también deberán comunicar claramente lo que está ocurriendo:

- **Carga:** Buscando libros y Esto puede tardar unos segundos.
- **Sin resultados:** No se encontraron libros e Intenta realizar otra búsqueda.
- **Error:** No se pudieron cargar los libros, el mensaje explicativo correspondiente e Intentar nuevamente.
- **Lista vacía:** Todavía no tienes libros guardados y la opción Buscar libros.

De esta forma, el usuario no dependerá únicamente de cambios visuales o iconos para comprender el estado de la aplicación.

### Elementos visuales y decorativos

No será necesario que VoiceOver se detenga de forma independiente en elementos que no aporten información adicional, como:

- La lupa del buscador.
- Las flechas utilizadas como indicadores visuales.
- El icono del estado Mis libros vacío.
- Las portadas cuando el libro ya pueda identificarse mediante su título y autor.

Por ejemplo, si visualmente aparece una portada junto con:

1984  
George Orwell

la información necesaria para identificar el libro puede comunicarse como:

1984, George Orwell

La portada seguirá formando parte de la interfaz visual, pero no será necesario anunciarla por separado si su información resulta redundante. :chatgpt-content-reference{index="3"}

### Libro sin portada

Cuando Open Library no disponga de una portada, se mostrará un elemento visual sustituto.

Para VoiceOver, la información principal seguirá siendo el título y el autor del libro. Por ejemplo:

Orgullo y prejuicio, Jane Austen

No se utilizarán nombres internos como cover_missing.png, book_placeholder o image01 como descripciones de accesibilidad.

Si en el futuro una imagen aporta información que no esté disponible mediante texto, su descripción deberá comunicar únicamente la información relevante para comprenderla.

### Criterio para las etiquetas

Las etiquetas creadas específicamente para accesibilidad serán concisas.

Por ejemplo:

- Buscar libros
- Guardar libro
- Eliminar de Mis libros
- Intentar nuevamente

No se utilizarán descripciones largas cuando una acción pueda expresarse de forma directa.

Si en versiones futuras se agregan textos visibles como una sinopsis, ese contenido también deberá poder ser accedido mediante VoiceOver. Actualmente la sinopsis no forma parte del MVP.

En conjunto, la accesibilidad de OpenBooks busca que una persona que utilice VoiceOver pueda identificar las pantallas, conocer la información principal de los libros, utilizar la búsqueda, navegar entre Inicio y Mis libros, guardar o eliminar libros y comprender los distintos estados de la aplicación sin recibir información innecesaria o repetida.

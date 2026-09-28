## Accesibilidad con VoiceOver

La accesibilidad se consideró desde la etapa de diseño de los wireframes y del flujo de usuario de OpenBooks.

El objetivo es que una persona que utilice VoiceOver pueda comprender la información principal de cada pantalla, identificar las acciones disponibles y navegar por la aplicación sin recibir información innecesaria o repetida.

Como criterio general, VoiceOver debe comunicar los elementos necesarios para comprender y utilizar la aplicación. Los elementos puramente decorativos o cuya información ya esté representada mediante texto no necesitan anunciarse de forma independiente.

Las etiquetas de accesibilidad deberán ser breves, claras y describir directamente la información o acción relevante. No se utilizarán nombres técnicos de imágenes, archivos o iconos.

Por ejemplo, una acción debe identificarse como Buscar libros, Guardar libro, Eliminar de Mis libros o Intentar nuevamente, en lugar de utilizar nombres internos o descripciones innecesariamente largas.

### Pantalla principal

VoiceOver deberá permitir identificar:

| Elemento | Comportamiento esperado |
| --- | --- |
| OpenBooks | Nombre principal de la pantalla. |
| Campo de búsqueda | Buscar libros. |
| Libros | Identifica el inicio de la lista. |
| Título y autor | Se presentan como información relacionada, por ejemplo: 1984, George Orwell. |
| Inicio y Mis libros | Opciones de navegación. |

La lupa del buscador, las portadas y las flechas de cada fila no necesitan anunciarse de forma independiente cuando su función o información ya está representada mediante texto.

En las listas se buscará que título y autor puedan comprenderse como una misma opción, evitando que VoiceOver obligue al usuario a recorrer información fragmentada.

### Resultados de búsqueda

VoiceOver deberá permitir identificar el título Resultados, la acción para regresar, el campo Buscar libros y el título y autor de cada resultado.

Por ejemplo:

Harry Potter y la piedra filosofal, J. K. Rowling

Las portadas y flechas visuales no necesitan anunciarse por separado si no aportan información adicional.

### Detalle del libro

Tanto para un libro guardado como para uno no guardado, VoiceOver deberá permitir identificar:

| Elemento | Comportamiento esperado |
| --- | --- |
| Detalle del libro | Título de la pantalla. |
| Título | Nombre del libro. |
| Autor o autores | Información del libro. |
| Año | Se anuncia cuando esté disponible. |
| Acción principal | Guardar libro o Eliminar de Mis libros, según el estado. |

La portada no necesita anunciarse de forma independiente si el libro ya puede identificarse mediante su título y autor.

La acción disponible deberá corresponder con el estado actual del libro: si no está guardado, Guardar libro; si ya está guardado, Eliminar de Mis libros.

### Mis libros

VoiceOver deberá permitir identificar el título Mis libros y cada libro guardado mediante su título y autor.

Por ejemplo:

Cien años de soledad, Gabriel García Márquez

Las portadas y flechas utilizadas únicamente como apoyo visual no necesitan convertirse en elementos independientes.

### Mis libros vacío

Cuando todavía no existan libros guardados, VoiceOver deberá comunicar:

- Mis libros.
- Todavía no tienes libros guardados.
- Busca un libro y guárdalo para verlo aquí.
- Buscar libros.

El icono de libro de esta pantalla es decorativo y no necesita anunciarse de forma independiente.

### Estados de la aplicación

Los estados también deben comunicar información suficiente para que el usuario comprenda qué está ocurriendo.

En carga se deberán anunciar mensajes como Buscando libros y Esto puede tardar unos segundos.

Cuando no existan resultados se deberán comunicar No se encontraron libros e Intenta realizar otra búsqueda.

En caso de error se deberán comunicar No se pudieron cargar los libros, el mensaje explicativo correspondiente y la acción Intentar nuevamente.

Los iconos utilizados para representar visualmente estos estados no necesitan anunciarse cuando el texto ya explica la situación.

### Libro sin portada

Cuando Open Library no disponga de una portada, se mostrará un elemento visual sustituto.

VoiceOver no necesita describir ese elemento de forma independiente si el libro ya puede identificarse mediante su título y autor.

Por ejemplo, para Orgullo y prejuicio de Jane Austen, la información principal seguirá siendo:

Orgullo y prejuicio, Jane Austen

No se utilizarán nombres internos como cover_missing.png, book_placeholder o image01.

Si en el futuro alguna imagen aporta información que no esté disponible mediante texto, entonces deberá utilizarse una descripción breve que comunique únicamente la información relevante.

### Portadas e imágenes

Las portadas normalmente acompañan información que ya se encuentra disponible mediante el título y el autor.

Por esta razón, no se buscará que VoiceOver se detenga de forma independiente en cada portada cuando esto genere información redundante.

La prioridad será identificar correctamente el libro mediante información útil, como:

1984, George Orwell

Nunca se utilizará el nombre del archivo de una imagen como descripción para el usuario.

### Textos y descripciones

Las etiquetas creadas específicamente para accesibilidad deben ser concisas.

Por ejemplo, es preferible Guardar libro en lugar de una explicación extensa sobre la función del botón.

Esto no significa que el contenido visible de la aplicación deba recortarse para VoiceOver. Si posteriormente se agrega una sinopsis u otro texto visible, ese contenido también deberá ser accesible.

Actualmente la sinopsis no forma parte del MVP, por lo que no se agregará contenido adicional únicamente para VoiceOver.

### Criterio general

La accesibilidad de OpenBooks busca que una persona que utilice VoiceOver pueda conocer en qué pantalla se encuentra, identificar los libros, utilizar la búsqueda, navegar entre Inicio y Mis libros, guardar o eliminar libros y comprender los distintos estados de la aplicación.

Los elementos decorativos o redundantes, como algunas portadas, lupas, flechas e iconos visuales, no necesitan anunciarse de forma independiente cuando la misma información ya esté disponible mediante contenido accesible.

De esta manera se busca evitar tanto la falta de información como la repetición innecesaria durante la navegación con VoiceOver.

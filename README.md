## Accesibilidad con VoiceOver

La accesibilidad se consideró desde el diseño de los wireframes y del flujo de usuario de OpenBooks.

El criterio principal es que VoiceOver comunique la información necesaria para comprender y utilizar la aplicación, evitando anunciar de forma independiente elementos decorativos o información que ya se encuentre representada mediante texto.

Las etiquetas de accesibilidad serán breves, claras y describirán directamente la información o acción relevante. No se utilizarán nombres internos de archivos, imágenes o iconos como descripciones para el usuario.

### Elementos principales

| Pantalla | Información relevante para VoiceOver |
| --- | --- |
| Pantalla principal | OpenBooks, Buscar libros, Libros, título y autor de cada libro, Inicio y Mis libros. |
| Resultados | Resultados, acción para regresar, Buscar libros, valor actual de la búsqueda, título y autor de cada resultado. |
| Detalle del libro | Acción para regresar, Detalle del libro, título, autor, año cuando esté disponible y la acción Guardar libro o Eliminar de Mis libros. |
| Mis libros | Mis libros, título y autor de cada libro guardado, Inicio y Mis libros. |
| Mis libros vacío | Mis libros, Todavía no tienes libros guardados, Busca un libro y guárdalo para verlo aquí y Buscar libros. |

En las listas de libros se buscará presentar el título y el autor como información relacionada.

Por ejemplo:

1984, George Orwell

Esto evita que el usuario tenga que recorrer por separado varios elementos que pertenecen a una misma opción.

### Pantalla principal

VoiceOver deberá permitir identificar el nombre OpenBooks, el campo Buscar libros, la sección Libros, los libros disponibles y las opciones de navegación Inicio y Mis libros.

La lupa del buscador, las portadas y las flechas de cada fila no necesitan anunciarse de forma independiente cuando no aporten información adicional.

Cada libro podrá identificarse principalmente mediante su título y autor, por ejemplo:

Cien años de soledad, Gabriel García Márquez

### Resultados de búsqueda

VoiceOver deberá permitir identificar el título Resultados, la acción para regresar, el campo Buscar libros, el texto que el usuario haya introducido y el título y autor de cada resultado.

Por ejemplo, si la búsqueda actual es Harry Potter, esa información deberá seguir estando disponible para el usuario.

Un resultado podrá identificarse como:

Harry Potter y la piedra filosofal, J. K. Rowling

Las portadas y las flechas visuales no necesitarán anunciarse de forma independiente cuando el título y el autor ya permitan identificar el libro.

### Detalle del libro

La misma pantalla de detalle se utilizará tanto para libros guardados como para libros que todavía no formen parte de Mis libros.

VoiceOver deberá permitir identificar:

- La acción para regresar.
- Detalle del libro.
- El título del libro.
- El autor o autores.
- El año de publicación cuando esté disponible.
- La acción principal disponible.

Si el libro todavía no está guardado, la acción será:

Guardar libro

Si el libro ya se encuentra guardado, la acción será:

Eliminar de Mis libros

Por ejemplo, un detalle podría comunicar:

Harry Potter y la piedra filosofal  
J. K. Rowling  
Año, 1997  
Guardar libro

La portada no necesitará anunciarse de forma independiente cuando la información necesaria para identificar el libro ya se encuentre disponible mediante texto.

### Mis libros

La sección Mis libros permitirá identificar los libros que el usuario haya guardado.

Cada libro podrá presentarse mediante su título y autor, por ejemplo:

Cien años de soledad, Gabriel García Márquez

Las portadas y las flechas utilizadas únicamente como apoyo visual no necesitarán convertirse en elementos independientes para VoiceOver.

También deberán poder identificarse las opciones de navegación Inicio y Mis libros.

### Mis libros vacío

Cuando todavía no existan libros guardados, VoiceOver deberá comunicar:

- Mis libros.
- Todavía no tienes libros guardados.
- Busca un libro y guárdalo para verlo aquí.
- Buscar libros.

El icono de libro utilizado en esta pantalla es decorativo y no necesita anunciarse de forma independiente, ya que el texto explica el estado de la sección.

### Estados de la aplicación

Los distintos estados deberán comunicar claramente lo que está ocurriendo para que el usuario no dependa únicamente de cambios visuales o iconos.

#### Carga

Mientras se realiza una búsqueda, se deberá comunicar:

- Buscando libros.
- Esto puede tardar unos segundos.

#### Búsqueda sin resultados

Cuando no existan coincidencias, se deberá comunicar:

- No se encontraron libros.
- Intenta realizar otra búsqueda.

El campo de búsqueda seguirá disponible para que el usuario pueda modificar su consulta.

#### Error en la búsqueda

Cuando ocurra un problema al obtener los resultados, se deberá comunicar:

- No se pudieron cargar los libros.
- Ocurrió un error al obtener los resultados. Intenta nuevamente.
- Intentar nuevamente.

La acción Intentar nuevamente deberá permitir identificar claramente qué puede hacer el usuario después del error.

### Libro sin portada

Cuando Open Library no disponga de una portada, se mostrará un elemento visual sustituto.

Para VoiceOver, la información principal seguirá siendo el título y el autor del libro.

Por ejemplo:

Orgullo y prejuicio, Jane Austen

No se utilizarán nombres internos como cover_missing.png, book_placeholder o image01 como descripciones de accesibilidad.

Si en el futuro una imagen aporta información importante que no se encuentre disponible mediante texto, su descripción deberá comunicar únicamente la información necesaria para comprenderla.

### Portadas e imágenes

Las portadas normalmente acompañan información que ya se encuentra disponible mediante el título y el autor.

Por esta razón, no será necesario que VoiceOver se detenga de forma independiente en cada portada cuando esto provoque información repetida.

Por ejemplo, si visualmente aparecen una portada, el título 1984 y el autor George Orwell, la información necesaria para identificar el libro puede comunicarse como:

1984, George Orwell

La portada seguirá formando parte de la interfaz visual, pero no necesitará anunciarse por separado si no aporta información adicional.

### Criterio para las etiquetas

Las etiquetas creadas específicamente para accesibilidad serán concisas y describirán directamente la información o acción correspondiente.

Algunos ejemplos son:

- Buscar libros.
- Guardar libro.
- Eliminar de Mis libros.
- Intentar nuevamente.

No se utilizarán descripciones largas cuando una acción pueda expresarse de forma directa.

Tampoco se utilizarán nombres técnicos de imágenes o iconos, ya que esa información no ayuda al usuario a comprender o utilizar la aplicación.

Si en versiones futuras se agrega contenido textual visible, como una sinopsis, ese contenido también deberá ser accesible mediante VoiceOver. Actualmente la sinopsis no forma parte del MVP.

### Criterio general

La accesibilidad de OpenBooks busca que una persona que utilice VoiceOver pueda:

- Saber en qué pantalla se encuentra.
- Identificar los libros mediante su información principal.
- Utilizar la búsqueda y conocer el texto introducido.
- Seleccionar libros y consultar su detalle.
- Guardar o eliminar libros.
- Navegar entre Inicio y Mis libros.
- Regresar a la pantalla anterior cuando corresponda.
- Comprender los estados de carga, error, búsqueda sin resultados y lista vacía.
- Identificar las acciones disponibles en cada momento.

Los elementos decorativos o redundantes, como algunas portadas, lupas, flechas e iconos visuales, no necesitarán anunciarse de forma independiente cuando la misma información ya esté disponible mediante contenido textual.

De esta manera se busca que la navegación con VoiceOver sea comprensible, útil y sin información repetida innecesariamente.

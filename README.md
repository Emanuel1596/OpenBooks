# OpenBooks

OpenBooks es una aplicación para iOS que permite descubrir libros de Open Library, buscar títulos, consultar su información y guardar favoritos en el dispositivo.

## ¿Qué puedes hacer con OpenBooks?

- **Explorar libros en Inicio.** La pantalla principal muestra sugerencias consultadas en Open Library. Se pueden recorrer al desplazarse hacia abajo.
- **Buscar libros.** Escribe un título o una palabra en Buscar y consulta los resultados de Open Library.
- **Consultar detalles.** Abre un libro para ver su portada, título, autor y, cuando estén disponibles, año de publicación, descripción y temas.
- **Guardar y eliminar favoritos.** Los libros seleccionados permanecen en Mis favoritos después de cerrar y volver a abrir la aplicación.
- **Reconocer estados de la aplicación.** Hay indicadores de carga y mensajes para errores de conexión, búsquedas sin resultados, portadas no disponibles y una lista de favoritos vacía.
- **Usar modo claro u oscuro.** La interfaz cambia de colores e ilustración de acuerdo con la apariencia del sistema.

Las sugerencias de Inicio proceden de una búsqueda por tema (`subject:fiction`); no son una clasificación oficial de popularidad.

## Capturas de la aplicación

Estas capturas muestran pantallas de OpenBooks ejecutadas en el simulador de iPhone.

| Inicio | Resultados | Detalle |
| :---: | :---: | :---: |
| <img width="235" alt="Inicio real con sugerencias" src="Docs/capturas-finales/inicio.png" /> | <img width="235" alt="Resultados reales de The Hobbit" src="Docs/capturas-finales/resultados.png" /> | <img width="235" alt="Detalle de The Hobbit" src="Docs/capturas-finales/detalle.png" /> |

| Descripción | Favorito guardado | Favoritos vacíos |
| :---: | :---: | :---: |
| <img width="235" alt="Descripción real de The Hobbit" src="Docs/capturas-finales/sinopsis.png" /> | <img width="235" alt="Libro recuperado de favoritos" src="Docs/capturas-finales/favorito-reabierto.png" /> | <img width="235" alt="Vista vacía de favoritos" src="Docs/capturas-finales/favoritos-vacios.png" /> |

## Tecnologías

| Tecnología | Uso |
| --- | --- |
| Swift 5 | Lenguaje de programación del proyecto |
| SwiftUI | Pantallas, navegación e interacción |
| Observation (`@Observable`) | Estado que utilizan las vistas |
| SwiftData | Almacenamiento local de favoritos |
| Foundation y `URLSession` | Solicitudes HTTPS y lectura de JSON |
| `Decodable` | Conversión de las respuestas de Open Library a modelos Swift |
| XCTest | Pruebas unitarias de búsqueda, respuestas y persistencia |
| Xcode | Compilación y ejecución en iPhone o simulador |

## Requisitos

- Una **Mac con Xcode 15 o posterior** y un SDK compatible con iOS 17 o posterior.
- Un simulador de iPhone o un dispositivo físico compatible con **iOS 17.0 o posterior**.
- Conexión a Internet para consultar nuevos libros, sus datos y las portadas disponibles.
- Para ejecutar la aplicación en un iPhone físico, configurar la firma con un equipo de desarrollo en Xcode.

No es necesario registrarse en Open Library, crear una clave API ni instalar paquetes de terceros para ejecutar este proyecto.

## Instalación y ejecución

1. Clona el repositorio o descarga su contenido en ZIP.
2. En una Mac, abre `OpenBooks.xcodeproj` con Xcode.
3. Selecciona el esquema **OpenBooks** y un simulador de iPhone compatible.
4. Presiona **Run** (⌘R).
5. En Inicio, abre una sugerencia o utiliza **Buscar libros**. Desde el detalle puedes agregar un libro a **Mis favoritos**.
6. Para verificar que los favoritos se guardan, cierra y vuelve a abrir la aplicación **sin eliminar los datos**.

Si las sugerencias o la búsqueda no cargan, revisa la conexión a Internet y utiliza la opción para intentarlo nuevamente. Open Library es un servicio externo y puede tardar o presentar errores temporales.

## Open Library y servicios externos

OpenBooks consulta la API pública de [Open Library](https://openlibrary.org/developers/api) mediante HTTPS. Los endpoints utilizados son:

| Uso | Endpoint |
| --- | --- |
| Búsqueda y sugerencias | `GET https://openlibrary.org/search.json` |
| Detalle de una obra | `GET https://openlibrary.org/works/{workID}.json` |
| Portada de un libro | `GET https://covers.openlibrary.org/b/id/{coverID}-M.jpg?default=false` |

La búsqueda utiliza los parámetros `q`, `fields` y `limit=15`. La aplicación pide identificador, título, autores, primera fecha de publicación y portada. Para el detalle se consultan la descripción y los temas cuando hace falta esa información.

**Configuración de la API:** no requiere token, contraseña ni archivo de credenciales. Las direcciones del servicio están definidas en `OpenBooks/Services/OpenLibraryBookSearchService.swift`.

El año de publicación es opcional: cuando Open Library no lo proporciona, no se muestra esa fila. Si una obra no tiene descripción, la aplicación lo indica. Las descripciones y los temas se presentan en el idioma registrado en Open Library; no se traducen automáticamente.

## Organización del proyecto

```text
OpenBooks/
├── Assets.xcassets/     Imágenes y colores
├── Models/             Modelos de libros y respuestas JSON
├── Services/           API de Open Library y almacenamiento
├── ViewModels/         Estado de búsqueda y favoritos
├── Views/              Pantallas y componentes visuales
└── OpenBooksApp.swift   Inicio y configuración de la aplicación

OpenBooksTests/          Pruebas unitarias XCTest
Docs/                    Documentación técnica y capturas
```

La aplicación utiliza una organización basada en MVVM: las vistas presentan el contenido; los modelos representan los libros; los ViewModels administran el estado; y los servicios realizan las solicitudes de red y el acceso a datos locales.

Para conocer los archivos y responsabilidades, consulta:

- [Arquitectura y servicios](Docs/arquitectura-y-servicios.md)
- [Navegación y manejo de estado](Docs/navigation-and-state.md)
- [Organización MVVM](Docs/mvvm-proposal.md)
- [Pruebas y persistencia](Docs/pruebas-y-persistencia.md)

## Pruebas

El objetivo `OpenBooksTests` contiene **24 métodos de prueba XCTest** para modelos de respuesta, estados de búsqueda y favoritos. Los casos de búsqueda usan respuestas controladas y los de persistencia utilizan SwiftData en memoria, por lo que no necesitan llamar a Open Library.

En Xcode, selecciona el esquema **OpenBooks** y ejecuta **Product → Test** (⌘U). También puedes hacerlo desde una Mac por Terminal, reemplazando `NOMBRE_DEL_SIMULADOR` por uno instalado:

```bash
xcodebuild -project OpenBooks.xcodeproj -scheme OpenBooks \
  -destination 'platform=iOS Simulator,name=NOMBRE_DEL_SIMULADOR' \
  CODE_SIGNING_ALLOWED=NO test
```

La presencia de las pruebas no significa que hayan pasado en todas las versiones del proyecto. Para conocer el resultado de una versión concreta, consulta la ejecución correspondiente en Xcode o en la integración continua del repositorio.

## Limitaciones conocidas

- Open Library puede responder lentamente o devolver datos incompletos. La aplicación informa los errores, pero no controla la disponibilidad del servicio.
- Algunas obras no incluyen año, portada o descripción. Las descripciones y temas pueden aparecer en inglés.
- Los favoritos se almacenan **localmente** con SwiftData; no se sincronizan entre dispositivos ni requieren cuenta.
- Las sugerencias recientes pueden recuperarse de `UserDefaults` y las portadas descargadas se guardan temporalmente en caché. Esa caché puede borrarse sin eliminar los favoritos.
- No incluye lectura de libros completos, compras, reseñas ni recomendaciones personalizadas con IA.
- El recorrido completo con VoiceOver y la experiencia en un dispositivo físico requieren revisión adicional.
- Si SwiftData no puede iniciar su contenedor local, la aplicación todavía no ofrece un mecanismo alternativo de recuperación.

## Integrantes

- Romero Palacios Randy Rodrigo
- Villanueva García Emanuel

## Diseños y capturas de referencia

Las siguientes imágenes conservan los diagramas, diseños y capturas anteriores. Pueden servir para comparar la distribución de las pantallas con la interfaz actual.

<details>
<summary>Ver diagramas y wireframes</summary>

<img width="1448" height="1086" alt="07-flujo-usuario" src="https://github.com/user-attachments/assets/fa488ace-31df-4de5-bb4a-6094bfa4aee4" />

<img width="941" height="1672" alt="01-pantalla-principal" src="https://github.com/user-attachments/assets/aeec5ced-9d0f-40c3-9ad7-566936d6f885" />

<img width="941" height="1672" alt="02-resultados" src="https://github.com/user-attachments/assets/2832437b-cfa3-40a6-b506-cfcec5a5204c" />

<img width="941" height="1672" alt="03-detalle-no-guardado" src="https://github.com/user-attachments/assets/29a59be6-227a-4ca1-865d-6f1440dba4d5" />

<img width="941" height="1672" alt="04-mis-libros" src="https://github.com/user-attachments/assets/d0d44fd2-88cc-4d64-907c-714b101020bf" />

<img width="941" height="1672" alt="05-detalle-guardado" src="https://github.com/user-attachments/assets/fc9a6265-71e6-4ee3-83da-af05aebe0d3d" />

<img width="941" height="1672" alt="06-mis-libros-vacio" src="https://github.com/user-attachments/assets/39c7128d-7280-4e08-bd93-36ec7da5010c" />

<img width="1536" height="1024" alt="08-estados-adicionales" src="https://github.com/user-attachments/assets/d4c5124b-5d78-457f-b252-ebaca66c3d95" />

</details>

<details>
<summary>Ver capturas de referencia de otras versiones</summary>

<img width="260" alt="01-pantalla-principal" src="https://github.com/user-attachments/assets/9000cb2b-fc82-4a9f-9aa6-3ad09755adaf" />

<img width="260" alt="02-resultados" src="https://github.com/user-attachments/assets/f4403735-70f6-4926-bfb7-46987f16e3d2" />

<img width="260" alt="03-detalle-no-guardado" src="https://github.com/user-attachments/assets/205931c3-31c4-406b-a4e7-82029595fd97" />

<img width="260" alt="05-detalle-guardado" src="https://github.com/user-attachments/assets/784b783f-d948-44a5-8bb1-91cb97f91c38" />

<img width="260" alt="04-mis-libros" src="https://github.com/user-attachments/assets/b7568132-028e-44f4-be32-34d895bcfe1d" />

<img width="260" alt="06-mis-libros-vacio" src="https://github.com/user-attachments/assets/7beac29c-e70e-4cd8-86a0-08563d5f0957" />

<img width="260" alt="07-cargando" src="https://github.com/user-attachments/assets/f441b56a-8f55-4bcb-af79-4cd62969084e" />

<img width="260" alt="08-no-resultados" src="https://github.com/user-attachments/assets/a80647df-3a93-47a4-bb42-9883a9712b98" />

<img width="260" alt="09-error" src="https://github.com/user-attachments/assets/ac6c4726-265b-4c22-84cd-2c316f16477e" />

<img width="260" alt="10-sin-portada" src="https://github.com/user-attachments/assets/7d89a443-d41a-4d5b-b5e3-a766f45defe6" />

</details>

# Revisión de la entrega final · Práctica 8

**Alcance:** revisión del repositorio de pruebas previa a integrar los cambios al repositorio oficial del equipo. No sustituye el registro final de compilación y pruebas del commit de entrega.

## Lista de verificación

| Elemento | Estado y comprobación necesaria |
| --- | --- |
| README: objetivo, funciones, tecnologías, integrantes | Documentado; cotejar con el PR final |
| Requisitos, instalación, ejecución y servicios externos | Documentado; probar desde una copia limpia en una Mac |
| Arquitectura, networking y persistencia | Documentado en `Docs/arquitectura-y-servicios.md` |
| Decisiones y limitaciones | Documentadas, incluidas dependencias de Open Library, acceso a datos y VoiceOver |
| Pruebas unitarias | 24 métodos XCTest definidos; **pendiente registrar su ejecución sobre el commit final** |
| Recorrido visual real | Workflow preparado en el repositorio de pruebas; **pendiente registrar resultado sobre el commit final** |
| Capturas de pantalla | Seis capturas auténticas de una corrida previa de simulador, `Docs/capturas-finales/`; actualizar si cambia la interfaz |
| Búsqueda de credenciales | Revisión textual local sin claves detectadas; repetir con `git grep` y revisar historial antes de entregar |
| Archivos temporales y mocks | Mocks movidos al objetivo XCTest; no subir parches, ZIP de diagnóstico ni archivos de configuración privados |
| Proyecto Xcode | Referencias del proyecto oficial y recursos en carpeta habitual; **pendiente compilar/ejecutar en Xcode** |
| Versión final | **Pendiente:** llenar SHA y enlace del PR después de las verificaciones |

## Verificación funcional que debe realizar el equipo

1. Compilar con el esquema `OpenBooks` en un simulador de iOS 17 o posterior.
2. Abrir Inicio y verificar sugerencias reales y desplazamiento; cambiar a modo oscuro y regresar.
3. Buscar `The Hobbit`; comprobar estados de carga, resultados y acceso al detalle.
4. Revisar portada, título, autores, año y sección «Sobre este libro», considerando que algunos datos pueden faltar.
5. Agregar el libro a Mis favoritos, cerrar y reabrir sin limpiar los datos, comprobar que permanece y eliminarlo.
6. Probar una búsqueda que termine sin resultados y una falla de red, comprobando que no se confundan ambos estados.
7. Ejecutar las pruebas XCTest y el recorrido real de interfaz; registrar el resultado y el identificador de la ejecución.
8. Revisar los comandos de instalación y abrir una copia nueva descargada del repositorio oficial.

## Seguridad y limpieza

- Buscar `api_key`, `token`, `secret`, contraseñas y claves privadas; confirmar que ningún archivo sensible se haya publicado **incluido el historial de Git**.
- No se necesita API key para los endpoints públicos de Open Library. No crear un archivo `.env` ficticio.
- No agregar archivos `.patch`, `.zip` de depuración, videos pesados, `.DS_Store`, `DerivedData/`, `.build/`, `xcuserdata/` ni secretos al commit de entrega.
- Conservar los recursos de interfaz usados por la app y las capturas reales del recorrido.

## Diferencias entre los ZIP revisados

Los ZIP entregados durante la revisión **no son idénticos**: `Proyecto-Open-Library-main` todavía conserva una implementación anterior (entre otras cosas, menos pruebas y funciones de detalle que `OpenBooks-practica-7-open-library`). Para la entrega final, es necesario llevar a una **rama independiente del repositorio oficial** las modificaciones probadas, sin reemplazar indiscriminadamente `OpenBooks.xcodeproj` por un proyecto generado de pruebas. Revisar los cambios con Git y ejecutar Xcode sobre la versión combinada.

## Registro de entrega (completar al final)

- Repositorio oficial: `RandyPalacios074/Proyecto-Open-Library`
- Rama de entrega propuesta: `practica-8-entrega-final` (crear a partir del objetivo indicado por el docente)
- Commit de entrega: **PENDIENTE**
- Pull Request hacia la rama principal: **PENDIENTE**
- Fecha y versión de Xcode utilizada: **PENDIENTE**
- Simulador/dispositivo y versión de iOS: **PENDIENTE**
- XCTest: **PENDIENTE** (anotar aprobadas/ejecutadas)
- Verificación del recorrido real: **PENDIENTE** (enlace a la ejecución)
- Revisión funcional y VoiceOver: **PENDIENTE**
- Limitaciones pendientes: consultar `README.md` y `Docs/arquitectura-y-servicios.md`

Nunca rellenar estas casillas con resultados o hashes que aún no se hayan comprobado.

# Plan de pruebas

Este plan deriva de la guía de Abraham y del contrato API Anexo A. El resultado obtenido se deja como **Pendiente** hasta ejecutar cada caso contra la API y WinForms integrados. No se registran pruebas ficticias.

| ID | Módulo | Caso | Pasos | Resultado esperado | Resultado obtenido | Figura |
| --- | --- | --- | --- | --- | --- | --- |
| API-01 | API | Consulta correcta | Ejecutar consulta GET válida desde el `.http` | 200 y JSON | Pendiente | Pendiente |
| API-02 | API | Crear recurso válido | Ejecutar POST válido | 201 y objeto creado | Pendiente | Pendiente |
| API-03 | API | Actualizar recurso | Ejecutar PUT con id de semilla | 204 sin cuerpo | Pendiente | Pendiente |
| API-04 | API | Validación inválida | Enviar datos inválidos según prueba `.http` | 400 con formato de error | Pendiente | Pendiente |
| API-05 | API | Id de ruta inexistente | Consultar recurso con id inexistente | 404 | Pendiente | Pendiente |
| API-06 | API | Conflicto de negocio | Repetir cédula o exceder stock | 409 con `detail` | Pendiente | Pendiente |
| API-07 | Productos | Lista y filtro por tipo | Ejecutar casos 01–02 de `.http` | 200; el filtro contiene solo ese tipo | Pendiente | Pendiente |
| API-08 | Productos | Alta, duplicado y tipo inválido | Ejecutar casos 03–05 | 201, 409 y 400 | Pendiente | Pendiente |
| API-09 | Productos | Editar, consultar inexistente y borrar | Ejecutar casos 06–09 | 204, 404, 409 y 204 | Pendiente | Pendiente |
| API-10 | Donantes | Alta y validaciones | Ejecutar casos 10–14 | 201, 400, 409, 400, 409 | Pendiente | Pendiente |
| API-11 | Beneficiarios | Alta con y sin dirección | Ejecutar casos 15–16 | 201; dirección puede ser null | Pendiente | Pendiente |
| API-12 | Beneficiarios | Cédula y dependencias | Ejecutar casos 17–19 | 400, 409 y 409 | Pendiente | Pendiente |
| API-13 | Donaciones | Alimento, ropa y anónima | Ejecutar casos 20–22 | 201; donante nulo permitido | Pendiente | Pendiente |
| API-14 | Donaciones | Reglas de validación | Ejecutar casos 23–28 | 400 en cada caso inválido | Pendiente | Pendiente |
| API-15 | Donaciones | Filtrar y conflicto de stock | Ejecutar casos 29–31 y 51 | 200, 404, 409 | Pendiente | Pendiente |
| API-16 | Entregas | Entregar todo el disponible | Ejecutar en orden casos 20–22 y luego 32 tras reiniciar BD | 201; disponible queda en 0 | Pendiente | Pendiente |
| API-17 | Entregas | Exceso y artículo sin stock | Ejecutar casos 33–34 | 409 e indica disponible | Pendiente | Pendiente |
| API-18 | Entregas | Ropa y beneficiario inexistente | Ejecutar casos 35–36 | 201 y 400 | Pendiente | Pendiente |
| API-19 | Entregas | Editar aumentando/reduciendo y borrar | Ejecutar casos 37–39 | 204; el stock se recalcula | Pendiente | Pendiente |
| API-20 | Inventario | Todos, ropa e inválido | Ejecutar casos 40–42 | 200, 200 y 400 | Pendiente | Pendiente |
| API-21 | Reportes | Totales y donaciones por tipo | Ejecutar casos 43–45 | 200, tres tipos; sin tipo 400 | Pendiente | Pendiente |
| API-22 | Reportes | Ropa filtrada | Ejecutar casos 46–47 | 200; solo ropa coincidente | Pendiente | Pendiente |
| API-23 | Reportes | Movimientos con y sin fechas | Ejecutar casos 48–50 | 200, rango inclusivo; rango invertido 400 | Pendiente | Pendiente |
| UI-01 | WinForms | Crear, consultar, editar y eliminar por pantalla | Recorrer cada formulario con datos controlados | Operaciones visibles y respuestas correctas | Bloqueado: WinForms no está en esta rama | Pendiente |
| E2E-01 | End-to-end | Donante → producto → donación → inventario → entrega → reportes | Seguir flujo recomendado; validar cada paso con SELECT en SQL | Datos persistidos y stock disminuye correctamente | Pendiente: API/WinForms aún no integrados | Pendiente |
| E2E-02 | End-to-end | Entrega por encima del stock | Solicitar una unidad adicional | 409 y disponible informado; sin cambio en BD | Pendiente | Pendiente |
| E2E-03 | End-to-end | Borrar donante con donaciones | Intentar eliminar el donante asociado | 409; dato permanece en BD | Pendiente | Pendiente |
| E2E-04 | End-to-end | API apagada | Apagar API y realizar consulta desde WinForms | Mensaje claro de conexión; no se cierra inesperadamente | Bloqueado: WinForms no está en esta rama | Pendiente |

## Recorrido end-to-end detallado

Ejecutar después de integrar API y WinForms. Usar valores únicos para que las consultas SQL permitan localizar los registros. Después de cada escritura desde WinForms, comprobar el registro en SSMS.

1. Crear un donante desde WinForms. Confirmar con `SELECT Id, Cedula, Nombre, Telefono FROM dbo.Donantes WHERE Cedula = N'<cedula de prueba>';`.
2. Crear un producto de tipo Alimentos. Confirmar con `SELECT Id, Nombre, Tipo FROM dbo.Productos WHERE Nombre = N'<producto de prueba>';`.
3. Registrar una donación para el producto y el donante. Confirmar con `SELECT Id, ProductoId, DonanteId, Descripcion, Cantidad FROM dbo.Donaciones WHERE Descripcion = N'<descripción única>';`.
4. Consultar inventario desde WinForms. Comparar `disponible` con `SELECT SUM(d.Cantidad) AS Donado, COALESCE((SELECT SUM(e.Cantidad) FROM dbo.Entregas e WHERE e.ProductoId = p.Id), 0) AS Entregado FROM dbo.Productos p LEFT JOIN dbo.Donaciones d ON d.ProductoId = p.Id WHERE p.Nombre = N'<producto de prueba>' GROUP BY p.Id;`.
5. Registrar una entrega menor o igual al disponible. Confirmar con `SELECT Id, BeneficiarioId, ProductoId, Cantidad FROM dbo.Entregas WHERE ProductoId = <id del producto> ORDER BY Id DESC;`.
6. Consultar inventario de nuevo; confirmar que `disponible` disminuyó por la cantidad entregada y coincide con los totales SQL.
7. Consultar reportes de totales, donaciones por tipo y movimientos. Comparar filas y cantidades con las tablas en SSMS.
8. Intentar entregar más de lo disponible. Esperar 409 con el saldo disponible; confirmar que no se insertó otra fila en `dbo.Entregas` y que el inventario no cambió.
9. Intentar borrar el donante usado en la donación. Esperar 409; confirmar que el donante y la donación siguen en sus tablas.
10. Apagar la API y consultar desde WinForms. Capturar el mensaje de conexión; volver a iniciar la API antes de continuar con otras pruebas.

Para entregar por pantalla, repetir en cada formulario las operaciones crear, consultar, editar y eliminar, incluyendo una captura por pantalla y las respuestas de error aplicables. Registrar resultados reales en la tabla inicial después de ejecutar.

## Preparación y evidencia

1. Ejecutar el script SQL completo dos veces seguidas y comprobar que ambas ejecuciones terminan sin errores.
2. Confirmar con `usp_TotalPorTipo`: las donaciones semilla suman Alimentos 100, Insumos 125 y Ropa 67; comparar además entregas y disponible.
3. Antes de cada recorrido completo del `.http`, volver a ejecutar el script para recuperar los ids y saldos semilla.
4. Ejecutar las 51 solicitudes en orden; el caso de stock exacto depende de las donaciones de prueba anteriores del mismo archivo. Registrar el resultado real y adjuntar capturas para los códigos 200, 201, 204, 400, 404 y 409.
5. En WinForms, capturar cada pantalla durante crear, consultar, editar y eliminar. Completar la sección end-to-end y consultar la BD después de cada paso.
6. Guardar imágenes como `docs/evidencia/Figura-01-descripcion.png` y agregar una frase explicativa por figura. Solo marcar “Aprobado” tras observar el resultado.

## Incidencias

Los defectos encontrados durante pruebas se documentan con pasos para repetir, respuesta observada y módulo responsable. Según la guía, se informan al dueño del módulo; no se corrigen desde esta tarea.

# Centro de Acopio

Sistema para registrar productos, donantes, beneficiarios, donaciones y entregas, controlar las existencias y consultar reportes. La arquitectura acordada separa una aplicación WinForms, una API ASP.NET Core y SQL Server Express. La API aplica las validaciones y reglas de stock; WinForms consume la API y no se conecta a SQL Server.

> **Estado de esta copia de `main`:** el contrato DTO y el esqueleto de la API están presentes. Controllers, servicios, modelos EF Core y la aplicación WinForms todavía no aparecen en esta rama. Por eso las instrucciones de ejecución y las pruebas HTTP quedan preparadas, pero no se pueden marcar como ejecutadas hasta integrar esos módulos.

## Tecnologías

- .NET 10
- ASP.NET Core Web API
- Entity Framework Core (Database-First)
- SQL Server Express
- WinForms para Windows
- SQL Server Management Studio y Visual Studio

## Estructura

```text
BaseDeDatos/Script_CentroAcopio.sql       Esquema, procedimientos y datos de ejemplo
Api/CentroAcopioApi/                      API, DTOs, excepciones y pruebas .http
WinForms/                                 Aplicación de escritorio (pendiente de integrar)
docs/                                     Diagramas, plan y evidencias de pruebas
CentroAcopio.slnx                         Solución de Visual Studio
```

## Preparación y ejecución

1. Instala SQL Server Express, SQL Server Management Studio y .NET 10 SDK.
2. En SSMS, ejecuta `BaseDeDatos/Script_CentroAcopio.sql` en la instancia de SQL Express. El script es reiniciable y restablece datos conocidos. No lo ejecutes sobre una base que necesites conservar.
3. Crea `Api/CentroAcopioApi/appsettings.Development.json` localmente, sin subirlo al repositorio:

   ```json
   {
     "ConnectionStrings": {
       "CentroAcopioDb": "Server=localhost\\SQLEXPRESS;Database=CentroAcopioDb;Trusted_Connection=True;TrustServerCertificate=True"
     }
   }
   ```

   Ajusta `Server` a la instancia instalada. No compartas credenciales ni cadenas con contraseñas.
4. En una terminal, confía el certificado HTTPS de desarrollo con `dotnet dev-certs https --trust`.
5. Cuando se integren los controllers y servicios, inicia la API:

   ```powershell
   dotnet run --project Api/CentroAcopioApi --launch-profile https
   ```

   El perfil preparado usa `https://localhost:7001` y Swagger en desarrollo.
6. Cuando se integre el proyecto WinForms, inicia su proyecto desde Visual Studio. Configura su cliente HTTP para `https://localhost:7001`; WinForms no debe acceder a la base de datos.

## Endpoints acordados

CRUD: `GET /api/{recurso}`, `GET /api/{recurso}/{id}`, `POST /api/{recurso}`, `PUT /api/{recurso}/{id}`, `DELETE /api/{recurso}/{id}` para productos, donantes, beneficiarios, donaciones y entregas. Inventario es de solo lectura.

| Ruta | Uso |
| --- | --- |
| `/api/productos?tipo=` | Catálogo de productos |
| `/api/donantes` | Donantes |
| `/api/beneficiarios` | Beneficiarios |
| `/api/donaciones?tipo=&productoId=&donanteId=` | Donaciones |
| `/api/entregas?tipo=&beneficiarioId=` | Entregas |
| `/api/inventario?tipo=` | Existencias disponibles |
| `/api/reportes/totales-por-tipo` | Totales por tipo |
| `/api/reportes/donaciones-por-tipo?tipo=` | Donaciones de un tipo |
| `/api/reportes/ropa?talla=&sexo=` | Donaciones de ropa filtradas |
| `/api/reportes/movimientos?desde=&hasta=` | Movimientos por fecha |

Los endpoints son el contrato acordado en la guía; aún deben implementarse en los controllers. Respuestas esperadas: 200 consulta, 201 creación, 204 edición o borrado, 400 validación, 404 id de ruta inexistente y 409 conflicto de estado o dependencias.

## Convenciones

- Base de datos Database-First: el script define el modelo y EF Core genera los modelos.
- C# en PascalCase; JSON en camelCase; rutas y campos según el contrato del Anexo A.
- Validaciones centralizadas en la API; WinForms solo ayuda a evitar errores obvios.
- Nunca guardar `appsettings.Development.json`, contraseñas ni cadenas de conexión.
- No cambiar tablas, parámetros ni resultados de procedimientos después del scaffold sin coordinarlo con Jorge.
- Ramas por tarea, commits pequeños en español y Pull Request revisado por otra persona. No hacer commits directos a main.

## Integrantes

| Integrante | Responsabilidad indicada |
| --- | --- |
| Abrahan | Base de datos, pruebas y documentación |
| Jorge | Contrato y modelo de datos; revisión de cambios al modelo |
| Moisés | API: donantes, beneficiarios, entregas, inventario y reportes |
| Andrea | WinForms y reportes existentes del parcial 2 |

Confirma nombres completos y cédulas con el equipo antes de completar la portada del informe.

## Documentación y pruebas

- [Plan de pruebas](docs/PlanPruebas.md)
- [Modelo de datos](docs/diagrama-modelo-datos.md)
- [Diagrama de arquitectura y clases](docs/diagramas-arquitectura.md)
- [Borrador del informe](docs/Proyecto.md)
- Evidencia pendiente: `docs/evidencia/`

El PDF final y el enlace del repositorio se agregarán cuando estén integrados los módulos, las capturas y los datos de portada confirmados.

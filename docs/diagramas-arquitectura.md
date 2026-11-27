# Diagramas de arquitectura y clases

## Arquitectura por capas (acordada)

```mermaid
flowchart LR
    UI[WinForms: formularios] --> CLIENT[ApiClient / HttpClient]
    CLIENT -->|HTTPS JSON| API[ASP.NET Core Web API]
    API --> CTRL[Controllers]
    CTRL --> SERVICES[Services y validaciones]
    SERVICES --> EF[EF Core: modelos Database-First]
    EF --> SQL[(SQL Server Express)]
    SERVICES --> SP[Procedimientos almacenados de reportes e inventario]
    SP --> SQL
```

WinForms no se conecta a SQL Server. La API aplica las validaciones y es la autoridad para calcular y proteger el stock.

## Clases de la API presentes en esta copia

El siguiente diagrama solo nombra tipos que existen en el `main` recibido. Controllers, interfaces, services y modelos EF todavía no están implementados; no se inventan sus métodos ni relaciones.

```mermaid
classDiagram
    class Program
    class FiltroExcepciones
    class ConflictoException
    class SolicitudInvalidaException
    class Catalogo
    class ProductoDto
    class GuardarProductoDto
    class DonanteDto
    class GuardarDonanteDto
    class BeneficiarioDto
    class GuardarBeneficiarioDto
    class DonacionDto
    class GuardarDonacionDto
    class EntregaDto
    class GuardarEntregaDto
    class InventarioDto
    class TotalPorTipoDto
    class MovimientoDto

    Program ..> FiltroExcepciones : registra como filtro
    FiltroExcepciones ..> ConflictoException : maneja
    FiltroExcepciones ..> SolicitudInvalidaException : maneja
    GuardarProductoDto ..> Catalogo : reglas compartidas
    GuardarDonanteDto ..> Catalogo : regex
    GuardarBeneficiarioDto ..> Catalogo : regex
    GuardarDonacionDto ..> Catalogo : cantidad máxima
    GuardarEntregaDto ..> Catalogo : cantidad máxima
```

## WinForms

Los formularios, `ApiClient`, `ApiException`, DTOs y `Mensajes` no están incluidos todavía en esta copia. El diagrama de clases de WinForms y las capturas deben añadirse después de integrar el proyecto real; hacerlo antes supondría adivinar nombres y relaciones.

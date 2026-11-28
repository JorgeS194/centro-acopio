# Modelo de datos acordado

El diagrama refleja las cinco tablas y sus relaciones especificadas en la guía. Las cardinalidades representan las claves foráneas del script.

```mermaid
erDiagram
    Productos ||--o{ Donaciones : recibe
    Donantes o|--o{ Donaciones : realiza
    Beneficiarios ||--o{ Entregas : recibe
    Productos ||--o{ Entregas : incluye

    Productos {
        int Id PK
        nvarchar Nombre UK
        nvarchar Tipo
    }
    Donantes {
        int Id PK
        nvarchar Cedula UK
        nvarchar Nombre
        nvarchar Telefono
    }
    Beneficiarios {
        int Id PK
        nvarchar Cedula UK
        nvarchar Nombre
        nvarchar Telefono
        nvarchar Direccion "nullable"
    }
    Donaciones {
        int Id PK
        datetime2 Fecha
        int ProductoId FK
        int DonanteId FK "nullable, anónima"
        nvarchar Descripcion
        int Cantidad
        nvarchar Talla "nullable"
        nvarchar GrupoEdad "nullable"
        nvarchar Sexo "nullable"
    }
    Entregas {
        int Id PK
        datetime2 Fecha
        int BeneficiarioId FK
        int ProductoId FK
        int Cantidad
        nvarchar Talla "nullable"
        nvarchar GrupoEdad "nullable"
        nvarchar Sexo "nullable"
    }
```

La clave de inventario es ProductoId y, para ropa, también Talla, GrupoEdad y Sexo. Los tres campos de ropa son todos nulos para artículos que no son ropa o todos tienen valor para ropa. Las relaciones no usan borrado en cascada.

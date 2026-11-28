USE master;
GO
IF DB_ID(N'CentroAcopioDb') IS NULL
    CREATE DATABASE CentroAcopioDb;
GO
USE CentroAcopioDb;
GO

-- Reinicio determinista: procedimientos primero y tablas en orden dependiente.
DROP PROCEDURE IF EXISTS dbo.usp_Movimientos;
DROP PROCEDURE IF EXISTS dbo.usp_RopaFiltrada;
DROP PROCEDURE IF EXISTS dbo.usp_DonacionesPorTipo;
DROP PROCEDURE IF EXISTS dbo.usp_TotalPorTipo;
DROP PROCEDURE IF EXISTS dbo.usp_Inventario;
GO
DROP TABLE IF EXISTS dbo.Entregas;
DROP TABLE IF EXISTS dbo.Donaciones;
DROP TABLE IF EXISTS dbo.Beneficiarios;
DROP TABLE IF EXISTS dbo.Donantes;
DROP TABLE IF EXISTS dbo.Productos;
GO

CREATE TABLE dbo.Productos (
    Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Productos PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Tipo NVARCHAR(20) NOT NULL,
    CONSTRAINT UQ_Productos_Nombre UNIQUE (Nombre),
    CONSTRAINT CK_Productos_Tipo CHECK (Tipo IN (N'Alimentos', N'Insumos', N'Ropa'))
);

CREATE TABLE dbo.Donantes (
    Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Donantes PRIMARY KEY,
    Cedula NVARCHAR(20) NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    Telefono NVARCHAR(8) NOT NULL,
    CONSTRAINT UQ_Donantes_Cedula UNIQUE (Cedula),
    CONSTRAINT CK_Donantes_Telefono CHECK (Telefono NOT LIKE N'%[^0-9]%' AND LEN(Telefono) IN (7, 8))
);

CREATE TABLE dbo.Beneficiarios (
    Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Beneficiarios PRIMARY KEY,
    Cedula NVARCHAR(20) NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    Telefono NVARCHAR(8) NOT NULL,
    Direccion NVARCHAR(200) NULL,
    CONSTRAINT UQ_Beneficiarios_Cedula UNIQUE (Cedula),
    CONSTRAINT CK_Beneficiarios_Telefono CHECK (Telefono NOT LIKE N'%[^0-9]%' AND LEN(Telefono) IN (7, 8))
);

CREATE TABLE dbo.Donaciones (
    Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Donaciones PRIMARY KEY,
    Fecha DATETIME2(0) NOT NULL CONSTRAINT DF_Donaciones_Fecha DEFAULT SYSDATETIME(),
    ProductoId INT NOT NULL,
    DonanteId INT NULL,
    Descripcion NVARCHAR(250) NOT NULL,
    Cantidad INT NOT NULL,
    Talla NVARCHAR(5) NULL,
    GrupoEdad NVARCHAR(10) NULL,
    Sexo NVARCHAR(10) NULL,
    CONSTRAINT FK_Donaciones_Productos FOREIGN KEY (ProductoId) REFERENCES dbo.Productos(Id),
    CONSTRAINT FK_Donaciones_Donantes FOREIGN KEY (DonanteId) REFERENCES dbo.Donantes(Id),
    CONSTRAINT CK_Donaciones_Cantidad CHECK (Cantidad BETWEEN 1 AND 10000),
    CONSTRAINT CK_Donaciones_Talla CHECK (Talla IS NULL OR Talla IN (N'XS', N'S', N'M', N'L', N'XL', N'XXL')),
    CONSTRAINT CK_Donaciones_GrupoEdad CHECK (GrupoEdad IS NULL OR GrupoEdad IN (N'Niño', N'Adulto')),
    CONSTRAINT CK_Donaciones_Sexo CHECK (Sexo IS NULL OR Sexo IN (N'Hombre', N'Mujer', N'Unisex')),
    CONSTRAINT CK_Donaciones_Ropa CHECK
        ((Talla IS NULL AND GrupoEdad IS NULL AND Sexo IS NULL) OR
         (Talla IS NOT NULL AND GrupoEdad IS NOT NULL AND Sexo IS NOT NULL))
);

CREATE TABLE dbo.Entregas (
    Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Entregas PRIMARY KEY,
    Fecha DATETIME2(0) NOT NULL CONSTRAINT DF_Entregas_Fecha DEFAULT SYSDATETIME(),
    BeneficiarioId INT NOT NULL,
    ProductoId INT NOT NULL,
    Cantidad INT NOT NULL,
    Talla NVARCHAR(5) NULL,
    GrupoEdad NVARCHAR(10) NULL,
    Sexo NVARCHAR(10) NULL,
    CONSTRAINT FK_Entregas_Beneficiarios FOREIGN KEY (BeneficiarioId) REFERENCES dbo.Beneficiarios(Id),
    CONSTRAINT FK_Entregas_Productos FOREIGN KEY (ProductoId) REFERENCES dbo.Productos(Id),
    CONSTRAINT CK_Entregas_Cantidad CHECK (Cantidad BETWEEN 1 AND 10000),
    CONSTRAINT CK_Entregas_Talla CHECK (Talla IS NULL OR Talla IN (N'XS', N'S', N'M', N'L', N'XL', N'XXL')),
    CONSTRAINT CK_Entregas_GrupoEdad CHECK (GrupoEdad IS NULL OR GrupoEdad IN (N'Niño', N'Adulto')),
    CONSTRAINT CK_Entregas_Sexo CHECK (Sexo IS NULL OR Sexo IN (N'Hombre', N'Mujer', N'Unisex')),
    CONSTRAINT CK_Entregas_Ropa CHECK
        ((Talla IS NULL AND GrupoEdad IS NULL AND Sexo IS NULL) OR
         (Talla IS NOT NULL AND GrupoEdad IS NOT NULL AND Sexo IS NOT NULL))
);
GO

CREATE OR ALTER PROCEDURE dbo.usp_Inventario @Tipo NVARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    WITH Movs AS (
        SELECT ProductoId, Talla, GrupoEdad, Sexo, Cantidad AS Donado, 0 AS Entregado FROM dbo.Donaciones
        UNION ALL
        SELECT ProductoId, Talla, GrupoEdad, Sexo, 0, Cantidad FROM dbo.Entregas
    )
    SELECT p.Id AS ProductoId, p.Nombre AS ProductoNombre, p.Tipo,
           m.Talla, m.GrupoEdad, m.Sexo,
           SUM(m.Donado) AS TotalDonado, SUM(m.Entregado) AS TotalEntregado,
           SUM(m.Donado) - SUM(m.Entregado) AS Disponible
    FROM Movs m JOIN dbo.Productos p ON p.Id = m.ProductoId
    WHERE @Tipo IS NULL OR p.Tipo = @Tipo
    GROUP BY p.Id, p.Nombre, p.Tipo, m.Talla, m.GrupoEdad, m.Sexo
    ORDER BY p.Tipo, p.Nombre, m.Talla, m.GrupoEdad, m.Sexo;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_TotalPorTipo
AS
BEGIN
    SET NOCOUNT ON;
    WITH Tipos AS (SELECT Tipo FROM (VALUES (N'Alimentos'), (N'Insumos'), (N'Ropa')) v(Tipo)),
    Donado AS (
        SELECT p.Tipo, SUM(d.Cantidad) AS TotalDonado
        FROM dbo.Donaciones d JOIN dbo.Productos p ON p.Id = d.ProductoId GROUP BY p.Tipo
    ),
    Entregado AS (
        SELECT p.Tipo, SUM(e.Cantidad) AS TotalEntregado
        FROM dbo.Entregas e JOIN dbo.Productos p ON p.Id = e.ProductoId GROUP BY p.Tipo
    )
    SELECT t.Tipo, COALESCE(d.TotalDonado, 0) AS TotalDonado,
           COALESCE(e.TotalEntregado, 0) AS TotalEntregado,
           COALESCE(d.TotalDonado, 0) - COALESCE(e.TotalEntregado, 0) AS Disponible
    FROM Tipos t LEFT JOIN Donado d ON d.Tipo = t.Tipo LEFT JOIN Entregado e ON e.Tipo = t.Tipo
    ORDER BY t.Tipo;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_DonacionesPorTipo @Tipo NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT d.Id, d.Fecha, d.ProductoId, p.Nombre AS ProductoNombre, p.Tipo,
           d.DonanteId, dn.Nombre AS DonanteNombre, d.Descripcion, d.Cantidad,
           d.Talla, d.GrupoEdad, d.Sexo
    FROM dbo.Donaciones d JOIN dbo.Productos p ON p.Id = d.ProductoId
    LEFT JOIN dbo.Donantes dn ON dn.Id = d.DonanteId
    WHERE p.Tipo = @Tipo
    ORDER BY d.Fecha DESC, d.Id DESC;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_RopaFiltrada
    @Talla NVARCHAR(5) = NULL, @Sexo NVARCHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT d.Id, d.Fecha, d.ProductoId, p.Nombre AS ProductoNombre, p.Tipo,
           d.DonanteId, dn.Nombre AS DonanteNombre, d.Descripcion, d.Cantidad,
           d.Talla, d.GrupoEdad, d.Sexo
    FROM dbo.Donaciones d JOIN dbo.Productos p ON p.Id = d.ProductoId
    LEFT JOIN dbo.Donantes dn ON dn.Id = d.DonanteId
    WHERE p.Tipo = N'Ropa' AND (@Talla IS NULL OR d.Talla = @Talla) AND (@Sexo IS NULL OR d.Sexo = @Sexo)
    ORDER BY d.Fecha DESC, d.Id DESC;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Movimientos @Desde DATE = NULL, @Hasta DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT x.Fecha, x.Movimiento, x.ProductoNombre, x.Tipo, x.Cantidad,
           x.Talla, x.GrupoEdad, x.Sexo, x.Persona
    FROM (
        SELECT d.Fecha, N'Donación' AS Movimiento, p.Nombre AS ProductoNombre, p.Tipo,
               d.Cantidad, d.Talla, d.GrupoEdad, d.Sexo,
               COALESCE(dn.Nombre, N'Anónimo') AS Persona
        FROM dbo.Donaciones d JOIN dbo.Productos p ON p.Id = d.ProductoId
        LEFT JOIN dbo.Donantes dn ON dn.Id = d.DonanteId
        UNION ALL
        SELECT e.Fecha, N'Entrega', p.Nombre, p.Tipo, e.Cantidad,
               e.Talla, e.GrupoEdad, e.Sexo, b.Nombre
        FROM dbo.Entregas e JOIN dbo.Productos p ON p.Id = e.ProductoId
        JOIN dbo.Beneficiarios b ON b.Id = e.BeneficiarioId
    ) x
    WHERE (@Desde IS NULL OR x.Fecha >= @Desde)
      AND (@Hasta IS NULL OR x.Fecha < DATEADD(DAY, 1, @Hasta))
    ORDER BY x.Fecha DESC;
END;
GO

-- Datos de ejemplo. Se mantienen los totales de donación acordados: 100, 125 y 67.
INSERT dbo.Productos (Nombre, Tipo) VALUES
    (N'Arroz', N'Alimentos'), (N'Frijoles', N'Alimentos'),
    (N'Jabón', N'Insumos'), (N'Pasta dental', N'Insumos'),
    (N'Camisa', N'Ropa'), (N'Pantalón', N'Ropa'), (N'Zapatos', N'Ropa'),
    (N'Producto sin movimientos', N'Alimentos');

INSERT dbo.Donantes (Cedula, Nombre, Telefono) VALUES
    (N'8-123-456', N'Ana Pérez', N'61234567'),
    (N'PE-12-345', N'Luis Gómez', N'66778899'),
    (N'E-8-123456', N'María López', N'6001234'),
    (N'N-12-3456', N'José Rivera', N'69998877'),
    (N'4-321-654', N'Carla Díaz', N'65544332');

INSERT dbo.Beneficiarios (Cedula, Nombre, Telefono, Direccion) VALUES
    (N'8-234-567', N'Rosa Martínez', N'61220011', N'Barrio Norte'),
    (N'PE-23-456', N'Pedro Castillo', N'63334455', NULL),
    (N'3-111-222', N'Elena Torres', N'67778899', N'Las Palmas');

INSERT dbo.Donaciones (Fecha, ProductoId, DonanteId, Descripcion, Cantidad, Talla, GrupoEdad, Sexo) VALUES
    ('2026-11-20T09:00:00', 1, 1, N'Sacos de arroz', 60, NULL, NULL, NULL),
    ('2026-11-20T10:00:00', 2, 2, N'Paquetes de frijoles', 40, NULL, NULL, NULL),
    ('2026-11-20T11:00:00', 3, 3, N'Jabones de uso personal', 75, NULL, NULL, NULL),
    ('2026-11-20T12:00:00', 4, NULL, N'Pasta dental donada', 50, NULL, NULL, NULL),
    ('2026-11-21T09:00:00', 5, 1, N'Camisas para adultos', 12, N'M', N'Adulto', N'Mujer'),
    ('2026-11-21T09:10:00', 5, 2, N'Camisas para adultos', 10, N'L', N'Adulto', N'Hombre'),
    ('2026-11-21T09:20:00', 5, 3, N'Camisas para niños', 8, N'S', N'Niño', N'Unisex'),
    ('2026-11-21T09:30:00', 6, 4, N'Pantalones para adultos', 12, N'M', N'Adulto', N'Hombre'),
    ('2026-11-21T09:40:00', 6, 5, N'Pantalones para niños', 10, N'XS', N'Niño', N'Hombre'),
    ('2026-11-21T09:50:00', 7, NULL, N'Zapatos para adultos', 15, N'XL', N'Adulto', N'Unisex');

INSERT dbo.Entregas (Fecha, BeneficiarioId, ProductoId, Cantidad, Talla, GrupoEdad, Sexo) VALUES
    ('2026-11-22T10:00:00', 1, 1, 10, NULL, NULL, NULL),
    ('2026-11-22T10:10:00', 2, 3, 15, NULL, NULL, NULL),
    ('2026-11-22T10:20:00', 3, 5, 2, N'M', N'Adulto', N'Mujer');
GO

/*
CONSULTAS DE VERIFICACIÓN (ejecutar aparte al revisar el script)
EXEC dbo.usp_Inventario;
EXEC dbo.usp_Inventario @Tipo = N'Ropa';
EXEC dbo.usp_TotalPorTipo;
EXEC dbo.usp_DonacionesPorTipo @Tipo = N'Alimentos';
EXEC dbo.usp_RopaFiltrada;
EXEC dbo.usp_Movimientos;
SELECT * FROM dbo.Productos;
SELECT * FROM dbo.Donantes;
SELECT * FROM dbo.Beneficiarios;
SELECT * FROM dbo.Donaciones;
SELECT * FROM dbo.Entregas;
*/

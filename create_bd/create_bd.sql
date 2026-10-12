-- ============================================================
-- Descripción: Este script crea la base de datos, los file groups y el esquema del proyecto.

USE master;
GO

-- Eliminar BD si existe
IF EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE name = 'CompuComisiones'
)
BEGIN
    ALTER DATABASE CompuComisiones
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE CompuComisiones;
END
GO

-- Crear base de datos
CREATE DATABASE CompuComisiones
ON PRIMARY (
    NAME = CompuComisiones_Primary,
    FILENAME = 'C:\SQLData\CompuComisiones_Primary.mdf', -- TODO: ajustar la ruta
    SIZE = 10MB, FILEGROWTH = 5MB
),
-- Filegroup exclusivo para las TABLAS
FILEGROUP FG_Tables (
    NAME = CompuComisiones_Tablas,
    FILENAME = 'C:\SQLData\CompuComisiones_Tables.ndf',
    SIZE = 20MB, FILEGROWTH = 10MB
),
-- Filegroup exclusivo para los ÍNDICES
FILEGROUP FG_Indices (
    NAME = CompuComisiones_Indices,
    FILENAME = 'C:\SQLData\CompuComisiones_Indices.ndf',
    SIZE = 20MB, FILEGROWTH = 10MB
)
LOG ON (
    NAME = CompuComisiones_Log,
    FILENAME = 'C:\SQLData\CompuComisiones_Log.ldf',
    SIZE = 10MB, FILEGROWTH = 5MB
);
GO

USE CompuComisiones;
GO

ALTER DATABASE CompuComisiones MODIFY FILEGROUP FG_Tables DEFAULT;
GO

-- Crear esquema (no se si hace falta pero porsia)
IF NOT EXISTS (
    SELECT *
    FROM sys.schemas
    WHERE name = 'reports'
)
BEGIN
    EXEC('CREATE SCHEMA reports');
END
GO
USE CompuComisiones;
GO

--Crear el usuario del propietario del esquema sin login (no puede conectarse a SQL Server)
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'schema_reports_owner')
BEGIN
    CREATE USER schema_reports_owner WITHOUT LOGIN;
END
GO
--Asignarle la propiedad del esquema 'reports'
ALTER AUTHORIZATION ON SCHEMA::reports TO schema_reports_owner;
GO

--los 3 roles que piden
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'registrador' AND type = 'R')
    CREATE ROLE registrador;
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'moderador' AND type = 'R')
    CREATE ROLE moderador;
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'administrador' AND type = 'R')
    CREATE ROLE administrador;
GO

--moderadores solo hacen consultas
GRANT SELECT ON SCHEMA::reports TO moderador;
GO

--admin pueden hacer detodo DML
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON SCHEMA::reports TO administrador;
GO

--registrador pueden insertar y modificar sobre personas y facturas
--tablas de personas y sus tipos
GRANT SELECT, INSERT, UPDATE ON reports.person TO registrador;
GRANT SELECT, INSERT, UPDATE ON reports.sales_rep TO registrador;
GRANT SELECT, INSERT, UPDATE ON reports.supervisor TO registrador;
GRANT SELECT, INSERT, UPDATE ON reports.finance_team_member TO registrador;
GRANT SELECT, INSERT, UPDATE ON reports.works_under TO registrador;

--vistas con triggers de inserción de personas
GRANT SELECT, INSERT, UPDATE ON reports.vw_sales_rep TO registrador;
GRANT SELECT, INSERT, UPDATE ON reports.vw_supervisor TO registrador;
GRANT SELECT, INSERT, UPDATE ON reports.vw_finance_team_member TO registrador;

--tablas de facturas y detalle
GRANT SELECT, INSERT, UPDATE ON reports.recit TO registrador;
GRANT SELECT, INSERT, UPDATE ON reports.recit_detail TO registrador;

--participaciones en facturas
GRANT SELECT, INSERT, UPDATE ON reports.commission TO registrador;

-- permisos de solo lectura para que puedan referenciar claves foráneas
GRANT SELECT ON reports.client TO registrador;
GRANT SELECT ON reports.product TO registrador;
GRANT SELECT ON reports.role TO registrador;
GO

--estos son usuarios de prueba, uno por rol
--admin
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'login_admin')
    CREATE LOGIN login_admin WITH PASSWORD = 'Password123!', CHECK_POLICY = OFF;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'user_admin')
    CREATE USER user_admin FOR LOGIN login_admin;
ALTER ROLE administrador ADD MEMBER user_admin;
GO

--moderador
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'login_moderador')
    CREATE LOGIN login_moderador WITH PASSWORD = 'Password123!', CHECK_POLICY = OFF;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'user_moderador')
    CREATE USER user_moderador FOR LOGIN login_moderador;
ALTER ROLE moderador ADD MEMBER user_moderador;
GO

--registrador
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'login_registrador')
    CREATE LOGIN login_registrador WITH PASSWORD = 'Password123!', CHECK_POLICY = OFF;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'user_registrador')
    CREATE USER user_registrador FOR LOGIN login_registrador;
ALTER ROLE registrador ADD MEMBER user_registrador;
GO
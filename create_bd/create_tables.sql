-- ============================================================
-- Descripción: Este script crea las tablas de la base de datos segun el modelo relacional.

USE CompuComisiones;
GO

-- Limpiar base de datos

DROP TABLE IF EXISTS reports.finance_team_member;
DROP TABLE IF EXISTS reports.sales_rep;
DROP TABLE IF EXISTS reports.supervisor;
DROP TABLE IF EXISTS reports.person;

DROP TABLE IF EXISTS reports.recit_detail;
DROP TABLE IF EXISTS reports.recit;

DROP TABLE IF EXISTS reports.product;
DROP TABLE IF EXISTS reports.client;

-- Crear tablas

-- ============================================================
-- Personas y roles de la compañía
-- ============================================================

CREATE TABLE reports.person (
    id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    hired_date DATE,
    status BIT NOT NULL CONSTRAINT DF_Active_Person DEFAULT 1
) ON FG_Tables;
GO

CREATE TABLE reports.sales_rep (
    id INT PRIMARY KEY,
    sales_quota DECIMAL(12, 2), -- asumiendo que es distinta a la comision?

    -- porque sql server no deja hacer herencias directamente.
    CONSTRAINT FK_Sales_Rep_Person FOREIGN KEY (id) REFERENCES reports.person(id)
        ON DELETE CASCADE
) ON FG_Tables;
GO

CREATE TABLE reports.supervisor (
    id INT PRIMARY KEY,
    zone_in_charge VARCHAR(50) NOT NULL,

    CONSTRAINT FK_Supervisor_Person FOREIGN KEY (id) REFERENCES reports.person(id)
        ON DELETE CASCADE
) ON FG_Tables;
GO

CREATE TABLE reports.finance_team_member (
    id INT PRIMARY KEY,
    job_title VARCHAR(50) NOT NULL,

    CONSTRAINT FK_Finance_Person FOREIGN KEY (id) REFERENCES reports.person(id)
        ON DELETE CASCADE
) ON FG_Tables;
GO

-- ============================================================
-- Producto
-- ============================================================
CREATE TABLE reports.product (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL
    -- yo supongo que deberia haber un precio unitario?
    -- unit_price DECIMAL(10, 2) NOT NULL
) ON FG_Tables;
GO

-- ============================================================
-- Cliente
-- ============================================================
CREATE TABLE reports.client (
    id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    market_segment VARCHAR(100) NOT NULL
) ON FG_Tables;
GO

-- ============================================================
-- Factura
-- ============================================================
CREATE TABLE reports.recit (
    number INT PRIMARY KEY,
    date_created DATE,
    status VARCHAR(15) NOT NULL,
    client_id INT NOT NULL, -- Relation Has

    CONSTRAINT CK_Recit_Status CHECK (status IN ('paid', 'issued', 'canceled')),
    CONSTRAINT FK_client_recit FOREIGN KEY (client_id) REFERENCES reports.client(id)
) ON FG_Tables;
GO

CREATE TABLE reports.recit_detail (
    number_recit INT NOT NULL,
    product_id INT NOT NULL,
    product_quantity INT NOT NULL,
    product_subtotal DECIMAL(12, 2) NOT NULL,
    sale_concept VARCHAR(150),

    CONSTRAINT FK_number_recit FOREIGN KEY (number_recit) REFERENCES reports.recit(number),
    CONSTRAINT FK_product_recit FOREIGN KEY (product_id) REFERENCES reports.product(id)
) ON FG_Tables;
GO
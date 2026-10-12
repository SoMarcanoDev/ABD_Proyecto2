-- ============================================================
-- Descripción: Este script crea las tablas de la base de datos segun el modelo relacional.

USE CompuComisiones;
GO

-- Limpiar base de datos
DROP TABLE IF EXISTS reports.commission_plan_history;

DROP TABLE IF EXISTS reports.finance_team_member;
DROP TABLE IF EXISTS reports.sales_rep;
DROP TABLE IF EXISTS reports.supervisor;
DROP TABLE IF EXISTS reports.person;

DROP TABLE IF EXISTS reports.recit_detail;
DROP TABLE IF EXISTS reports.recit;

DROP TABLE IF EXISTS reports.product;
DROP TABLE IF EXISTS reports.client;
DROP TABLE IF EXISTS reports.role;

DROP TABLE IF EXISTS reports.filter;
DROP TABLE IF EXISTS reports.commission_plan;

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
    supervisor_id INT, -- subordinate relationship

    CONSTRAINT FK_Supervisor_Person FOREIGN KEY (id) REFERENCES reports.person(id)
        ON DELETE CASCADE,
    CONSTRAINT FK_Supervisor_id FOREIGN KEY (id) REFERENCES reports.supervisor(id)
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

    CONSTRAINT CK_Recit_Status CHECK (LOWER(status) IN ('paid', 'issued', 'canceled')),
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

-- ============================================================
-- Rol
-- ============================================================
CREATE TABLE reports.role (
    id INT PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    description VARCHAR(150) NOT NULL
) ON FG_Tables;
GO

-- ============================================================
-- Plan de comisiones
-- ============================================================
CREATE TABLE reports.commission_plan (
    code INT PRIMARY KEY,
    name VARCHAR(20), -- se identifica tambien por este pero creo que vale hacer un indice y ya
    commission_rate DECIMAL(5, 4) NOT NULL,
    base VARCHAR(10) NOT NULL,
    
    CONSTRAINT CK_Commission_Plan_Base CHECK (LOWER(base) IN ('income', 'margin', 'quantity')),
) ON FG_Tables;
GO

CREATE TABLE reports.filter (
    plan_code INT NOT NULL,
    number INT NOT NULL,

    content VARCHAR(255) NOT NULL,

    CONSTRAINT CK_Filter_Number CHECK (number > 0),
    CONSTRAINT PK_Filter PRIMARY KEY (plan_code, number),
    CONSTRAINT FK_Filter_CommissionPlan FOREIGN KEY (plan_code) 
        REFERENCES reports.commission_plan(code) 
        ON DELETE CASCADE
) ON FG_Tables;
GO

CREATE TABLE reports.commission_plan_history (
    sales_rep_id INT NOT NULL,
    role_id INT NOT NULL,
    commission_plan_code INT NOT NULL,
    start_date DATE,

    CONSTRAINT PK_commission_plan_history PRIMARY KEY (sales_rep_id, role_id, commission_plan_code, start_date),
    CONSTRAINT FK_Sales_Rep_Id FOREIGN KEY (sales_rep_id)
        REFERENCES reports.sales_rep(id),
    CONSTRAINT FK_Role_Id FOREIGN KEY (role_id)
        REFERENCES reports.role(id),
    CONSTRAINT FK_Commission_Plan_Code FOREIGN KEY (commission_plan_code)
        REFERENCES reports.commission_plan(code)
) ON FG_Tables;
GO

-- ============================================================
-- Periodo
-- ============================================================


-- ============================================================
-- Pago
-- ============================================================


-- ============================================================
-- Calculo de comisiones??
-- ============================================================
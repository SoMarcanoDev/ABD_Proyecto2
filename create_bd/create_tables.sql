-- ============================================================
-- Descripción: Este script crea las tablas de la base de datos segun el modelo relacional.

USE CompuComisiones;
GO

-- Limpiar base de datos
DROP TABLE IF EXISTS reports.commission_calculation;
DROP TABLE IF EXISTS reports.payment;

DROP TABLE IF EXISTS reports.commission;
DROP TABLE IF EXISTS reports.commission_plan_history;

DROP TABLE IF EXISTS reports.works_under;

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

DROP TABLE IF EXISTS reports.period;
GO

-- Crear tablas

-- ============================================================
-- Personas y roles de la compañía
-- ============================================================
-- Nadie deberia tener permiso de insertar directamente en estas tablas
-- Para garantizar que no exista registro de persona sin tipo asociado,
-- la inserción se deberia hacer por medio de una vista con un trigger
CREATE TABLE reports.person (
    id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    hired_date DATE NOT NULL,
    status BIT NOT NULL CONSTRAINT DF_Active_Person DEFAULT 1,
    CONSTRAINT id_person_indx PRIMARY KEY NONCLUSTERED (id) ON FG_Indices
) ON FG_Tables;
GO

CREATE TABLE reports.sales_rep (
    id INT NOT NULL,
    sales_quota DECIMAL(12, 2) NOT NULL, -- asumiendo que es distinta a la comision?

    CONSTRAINT id_sales_rep_indx PRIMARY KEY NONCLUSTERED (id) ON FG_Indices,
    -- porque sql server no deja hacer herencias directamente.
    CONSTRAINT FK_Sales_Rep_Person FOREIGN KEY (id) REFERENCES reports.person(id)
        ON DELETE CASCADE
) ON FG_Tables;
GO

CREATE TABLE reports.supervisor (
    id INT NOT NULL,
    zone_in_charge VARCHAR(50) NOT NULL,
    superior_id INT, -- subordinate relationship

    CONSTRAINT id_supervisor_indx PRIMARY KEY NONCLUSTERED (id) ON FG_Indices,
    CONSTRAINT FK_Supervisor_Person FOREIGN KEY (id) REFERENCES reports.person(id)
        ON DELETE CASCADE,
    CONSTRAINT FK_Superior_id FOREIGN KEY (superior_id) REFERENCES reports.supervisor(id)
) ON FG_Tables;
GO

CREATE TABLE reports.finance_team_member (
    id INT NOT NULL,
    job_title VARCHAR(50) NOT NULL,

    CONSTRAINT id_finance_team_member_indx PRIMARY KEY NONCLUSTERED (id) ON FG_Indices,
    CONSTRAINT FK_Finance_Person FOREIGN KEY (id) REFERENCES reports.person(id)
        ON DELETE CASCADE
) ON FG_Tables;
GO

CREATE TABLE reports.works_under (
    sales_rep_id INT NOT NULL,
    supervisor_id INT NOT NULL,
    validity_date DATE NOT NULL,
    recognition_rate DECIMAL(5, 4) NOT NULL,

    CONSTRAINT sales_rep_id_supervisor_id_validity_date_works_under_indx
        PRIMARY KEY NONCLUSTERED (sales_rep_id, supervisor_id, validity_date)
        ON FG_Indices,
    CONSTRAINT FK_Works_Under_Sales_Rep_Id FOREIGN KEY (sales_rep_id) REFERENCES reports.sales_rep(id),
    CONSTRAINT FK_Works_Under_Supervisor_Id FOREIGN KEY (supervisor_id) REFERENCES reports.supervisor(id)
) ON FG_Tables;
GO

-- ============================================================
-- Producto
-- ============================================================
CREATE TABLE reports.product (
    id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    -- yo supongo que deberia haber un precio unitario?
    -- unit_price DECIMAL(10, 2) NOT NULL

    CONSTRAINT id_product_indx PRIMARY KEY NONCLUSTERED (id) ON FG_Indices
) ON FG_Tables;
GO

-- ============================================================
-- Cliente
-- ============================================================
CREATE TABLE reports.client (
    id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    market_segment VARCHAR(100) NOT NULL,

    CONSTRAINT id_client_indx PRIMARY KEY NONCLUSTERED (id) ON FG_Indices
) ON FG_Tables;
GO

-- ============================================================
-- Factura
-- ============================================================
CREATE TABLE reports.recit (
    number INT NOT NULL,
    date_created DATE NOT NULL,
    status VARCHAR(15) NOT NULL,
    client_id INT NOT NULL, -- Relation Has
    date_paid DATE,

    CONSTRAINT number_recit_indx PRIMARY KEY NONCLUSTERED (number) ON FG_Indices,
    CONSTRAINT CK_Recit_Status CHECK (LOWER(status) IN ('paid', 'issued', 'canceled')),
    CONSTRAINT CK_Date_Paid_Status CHECK (
        (LOWER(status) != 'paid' OR date_paid IS NOT NULL) -- si esta pagada es no nula
        AND (LOWER(status) = 'paid' OR date_paid IS NULL)  -- si no esta pagada es nula
    ),
    -- Ninguna factura puede registrar una fecha de cobro anterior a su fecha de emisión.
    CONSTRAINT CK_Date_Paid_After_Emmited CHECK (date_paid IS NULL OR date_paid >= date_created),
    CONSTRAINT FK_client_recit FOREIGN KEY (client_id) REFERENCES reports.client(id),
) ON FG_Tables;
GO

CREATE TABLE reports.recit_detail (
    number_recit INT NOT NULL,
    product_id INT NOT NULL,
    product_quantity INT NOT NULL,
    product_subtotal DECIMAL(12, 2) NOT NULL,
    sale_concept VARCHAR(150),

    CONSTRAINT number_recit_product_id_recit_detail_indx
        PRIMARY KEY NONCLUSTERED (number_recit, product_id)
        ON FG_Indices,
    CONSTRAINT FK_number_recit FOREIGN KEY (number_recit) REFERENCES reports.recit(number),
    CONSTRAINT FK_product_recit FOREIGN KEY (product_id) REFERENCES reports.product(id)
) ON FG_Tables;
GO

-- ============================================================
-- Rol
-- ============================================================
CREATE TABLE reports.role (
    id INT NOT NULL,
    name VARCHAR(25) NOT NULL,
    description VARCHAR(150) NOT NULL,

    CONSTRAINT id_role_indx PRIMARY KEY NONCLUSTERED (id) ON FG_Indices
) ON FG_Tables;
GO

CREATE TABLE reports.commission (
    sales_rep_id INT NOT NULL,
    role_id INT NOT NULL,
    recit_number INT NOT NULL,
    participation_percentage DECIMAL(3, 2),

    CONSTRAINT sales_rep_id_role_id_recit_number_commission_indx
        PRIMARY KEY NONCLUSTERED (sales_rep_id, role_id, recit_number)
        ON FG_Indices,
    CONSTRAINT FK_Commission_Sales_Rep_Id FOREIGN KEY (sales_rep_id)
        REFERENCES reports.sales_rep(id),
    CONSTRAINT FK_Commission_Role_Id FOREIGN KEY (role_id)
        REFERENCES reports.role(id),
    CONSTRAINT FK_Commission_Recit_Number FOREIGN KEY (recit_number)
        REFERENCES reports.recit(number)
) ON FG_Tables;
GO

-- ============================================================
-- Plan de comisiones
-- ============================================================
CREATE TABLE reports.commission_plan (
    code INT NOT NULL,
    name VARCHAR(20), -- se identifica tambien por este pero creo que vale hacer un indice y ya
    commission_rate DECIMAL(5, 4) NOT NULL,
    base VARCHAR(10) NOT NULL,
    discount BIT NOT NULL CONSTRAINT DF_Has_Discount DEFAULT 0,
    
    CONSTRAINT code_commission_plan_indx PRIMARY KEY NONCLUSTERED (code) ON FG_Indices,
    CONSTRAINT CK_Commission_Plan_Base CHECK (LOWER(base) IN ('income', 'margin', 'quantity'))
) ON FG_Tables;
GO

CREATE TABLE reports.filter (
    plan_code INT NOT NULL,
    number INT NOT NULL,

    content VARCHAR(255) NOT NULL,

    CONSTRAINT CK_Filter_Number CHECK (number > 0),
    CONSTRAINT plan_code_number_filter_indx
        PRIMARY KEY NONCLUSTERED (plan_code, number)
        ON FG_Indices,
    CONSTRAINT FK_Filter_CommissionPlan FOREIGN KEY (plan_code) 
        REFERENCES reports.commission_plan(code) 
        ON DELETE CASCADE
) ON FG_Tables;
GO

CREATE TABLE reports.commission_plan_history (
    sales_rep_id INT NOT NULL,
    role_id INT NOT NULL,
    commission_plan_code INT NOT NULL,
    start_date DATE NOT NULL,

    CONSTRAINT sales_rep_id_role_id_commission_plan_code_start_date_commission_plan_history_indx
        PRIMARY KEY NONCLUSTERED (sales_rep_id, role_id, commission_plan_code, start_date)
        ON FG_Indices,
    CONSTRAINT FK_Commission_Plan_Hist_Sales_Rep_Id FOREIGN KEY (sales_rep_id)
        REFERENCES reports.sales_rep(id),
    CONSTRAINT FK_Commission_Plan_Hist_Role_Id FOREIGN KEY (role_id)
        REFERENCES reports.role(id),
    CONSTRAINT FK_Commission_Plan_Hist_Code FOREIGN KEY (commission_plan_code)
        REFERENCES reports.commission_plan(code)
) ON FG_Tables;
GO

-- ============================================================
-- Periodo
-- ============================================================
CREATE TABLE reports.period (
    id INT NOT NULL,
    description VARCHAR(150) NOT NULL,
    aditional_notes VARCHAR(255),
    type VARCHAR(10) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,

    CONSTRAINT id_period_indx PRIMARY KEY NONCLUSTERED (id) ON FG_Indices,
    CONSTRAINT CK_Period_Type CHECK (LOWER(type) IN ('weekly', 'monthly', 'quarterly', 'anual'))
) ON FG_Tables;
GO

-- ============================================================
-- Pago
-- ============================================================
CREATE TABLE reports.payment (
    person_id INT NOT NULL,
    period_id INT NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    date_paid DATE,
    status VARCHAR(10),

    CONSTRAINT period_id_person_id_payment_indx
        PRIMARY KEY NONCLUSTERED (period_id, person_id)
        ON FG_Indices,
    CONSTRAINT FK_Payment_Person_Id FOREIGN KEY (person_id) REFERENCES reports.person,
    CONSTRAINT FK_Payment_Period_Id FOREIGN KEY (period_id) REFERENCES reports.period
) ON FG_Tables;
GO

-- ============================================================
-- Calculo de comisiones
-- ============================================================
CREATE TABLE reports.commission_calculation (
    person_id INT NOT NULL, --usamos un trigger para verificar que no sea el id de una persona de finanza
    period_id INT NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    status VARCHAR(10),

    CONSTRAINT period_id_person_id_commission_calculation_indx
        PRIMARY KEY NONCLUSTERED (period_id, person_id)
        ON FG_Indices,
    CONSTRAINT FK_Commission_Calc_Person_Id FOREIGN KEY (person_id) REFERENCES reports.person,
    CONSTRAINT FK_Commission_Calc_Period_Id FOREIGN KEY (period_id) REFERENCES reports.period
) ON FG_Tables;
GO
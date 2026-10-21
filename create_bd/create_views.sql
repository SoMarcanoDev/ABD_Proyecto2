-- ============================================================
-- Descripción: Este script crea las vistas de otras tablas.

USE CompuComisiones;
GO

-- eliminar vistas
DROP VIEW IF EXISTS reports.vw_sales_rep;
DROP VIEW IF EXISTS reports.vw_supervisor;
DROP VIEW IF EXISTS reports.vw_finance_team_member;
DROP VIEW IF EXISTS reports.vw_payment_report;
GO

-- Vistas de personas: Para hacer inserciones (asegurando que no se creen registros de persona sin tipo asociado) 
-- o mostrar las columnas juntas

-- ============================================================
-- Vendedor
-- ============================================================
CREATE VIEW reports.vw_sales_rep AS (
    SELECT p.*, s.sales_quota, wu.supervisor_id, wu.validity_date AS supervisor_validity_date, wu.recognition_rate
    FROM reports.person p
    JOIN reports.sales_rep s ON p.id = s.id
    OUTER APPLY (
        SELECT TOP 1
            w.supervisor_id, 
            w.validity_date, 
            w.recognition_rate
        FROM reports.works_under w
        WHERE w.sales_rep_id = p.id
        ORDER BY w.validity_date DESC
    ) wu
);
GO

-- ============================================================
-- Supervisor
-- ============================================================
CREATE VIEW reports.vw_supervisor AS (
    SELECT p.*, s.zone_in_charge, s.superior_id
    FROM reports.person p
    JOIN reports.supervisor s ON p.id = s.id
);
GO

-- ============================================================
-- Equipo de finanzas
-- ============================================================
CREATE VIEW reports.vw_finance_team_member AS (
    SELECT p.*, f.job_title
    FROM reports.person p
    JOIN reports.finance_team_member f ON p.id = f.id
);
GO

--reporte de pagos
CREATE OR ALTER VIEW reports.vw_payment_report AS
SELECT
    --informacion del periodo
    p.id AS period_id,
    p.description AS period_description,
    p.type AS period_type,
    p.start_date AS period_start_date,
    p.end_date AS period_end_date,

    --informacion de la persona
    per.id AS person_id,
    CONCAT(per.first_name, ' ', per.last_name) AS full_name,
    per.email,
    CASE
        WHEN sr.id IS NOT NULL THEN 'Vendedor'
        WHEN sup.id IS NOT NULL THEN 'Supervisor'
        WHEN ftm.id IS NOT NULL THEN 'Finanzas'
        ELSE 'Otro'
    END AS person_role,

    --informacion del pago
    pay.amount AS payment_amount,
    pay.date_paid AS payment_date,
    pay.status AS payment_status
FROM reports.payment pay
JOIN reports.period p ON pay.period_id = p.id
JOIN reports.person per ON pay.person_id = per.id
LEFT JOIN reports.sales_rep sr ON per.id = sr.id
LEFT JOIN reports.supervisor sup ON per.id = sup.id
LEFT JOIN reports.finance_team_member ftm ON per.id = ftm.id;
GO
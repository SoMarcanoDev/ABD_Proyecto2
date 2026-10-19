-- ============================================================
-- Descripción: Este script crea las vistas de otras tablas.

USE CompuComisiones;
GO

-- eliminar vistas
DROP VIEW IF EXISTS reports.vw_sales_rep;
DROP VIEW IF EXISTS reports.vw_supervisor;
DROP VIEW IF EXISTS reports.vw_finance_team_member;
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
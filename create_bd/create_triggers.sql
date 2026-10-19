-- ============================================================
-- Descripción: Este script crea los triggers para asegurar el cumplimiento de las reglas de negocio.

USE CompuComisiones;
GO

-- ============================================================
-- Triggers del enunciado
-- ============================================================
-- 1. Control de la participación en la factura
CREATE OR ALTER TRIGGER reports.TR_Commission_CheckParticipation_Percent
ON reports.commission
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON; -- segun stackoverflow esto es una buena practica :p

    IF EXISTS (
        SELECT 1
        FROM reports.commission c 
        WHERE c.recit_number IN (SELECT recit_number FROM inserted)
        GROUP BY c.recit_number
        HAVING SUM(c.participation_percentage) > 1.00
    )
    BEGIN
        RAISERROR ('El porcentaje de participación para una factura dada no puede superar el 100% (1.00).', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;
GO

-- 2. Integridad de la cadena de supervisión
CREATE OR ALTER TRIGGER reports.TR_Supervisor_CheckSupervisor_Chain
ON reports.supervisor
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Primero verifica si no es su propio superior
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE id = superior_id
    )
    BEGIN
        RAISERROR ('Un supervisor no puede ser su propior superior.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- Luego verifica la cadena de supervision en busca de ciclos
    WITH superiorChain (original_id, current_id, superior_id) AS (
        -- caso base
        SELECT 
            i.id AS original_id, 
            s.id AS current_id, 
            s.superior_id
        FROM inserted i
        JOIN reports.supervisor s ON i.superior_id = s.id
        
        UNION ALL
        -- caso recursivo
        SELECT sc.original_id, s.id AS current_id, s.superior_id
        FROM superiorChain sc
        JOIN reports.supervisor s ON sc.superior_id = s.id
    )
    SELECT 1
    FROM superiorChain
    WHERE original_id = current_id

    IF @@ROWCOUNT > 0
    BEGIN
        RAISERROR ('Un supervisor no puede ser superior de un superior suyo.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;
GO

-- 3. Recupero por devolución
-- CREATE OR ALTER TRIGGER reports.TR_Recit_CheckDevolution_Commission
-- ON reports.recit
-- AFTER UPDATE -- no sé si deberia dispararse con inserts también?
-- AS 
-- BEGIN
--     SET NOCOUNT ON;

--     -- verifica que el registro modificado tiene el estado de anulada
--     IF EXISTS (
--         SELECT 1
--         FROM inserted i
--         WHERE LOWER(status) = 'canceled'
--     )
--     BEGIN
--         -- Esto no hace nada ahorita ya sé jsjsj
--     END;
-- END;
-- GO

-- ============================================================
-- Triggers para la inserción de personas
-- ============================================================
-- Inserción en la vista de vendedor
CREATE OR ALTER TRIGGER reports.TR_vw_sales_rep_Insert
ON reports.vw_sales_rep
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO reports.person (id, first_name, last_name, email, hired_date, status)
    SELECT id, first_name, last_name, email, hired_date, status
    FROM inserted;

    INSERT INTO reports.sales_rep (id, sales_quota)
    SELECT id, sales_quota
    FROM inserted;
END;
GO

-- Inserción en la vista de supervisor
CREATE OR ALTER TRIGGER reports.TR_vw_supervisor_Insert
ON reports.vw_supervisor
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO reports.person (id, first_name, last_name, email, hired_date, status)
    SELECT id, first_name, last_name, email, hired_date, status
    FROM inserted;

    INSERT INTO reports.supervisor (id, zone_in_charge, superior_id)
    SELECT id, zone_in_charge, superior_id
    FROM inserted;
END;
GO

-- Inserción en la vista de miembro del equipo de finanzas
CREATE OR ALTER TRIGGER reports.TR_vw_finance_team_member_Insert
ON reports.vw_finance_team_member
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO reports.person (id, first_name, last_name, email, hired_date, status)
    SELECT id, first_name, last_name, email, hired_date, status
    FROM inserted;

    INSERT INTO reports.finance_team_member (id, job_title)
    SELECT id, job_title
    FROM inserted;
END;
GO
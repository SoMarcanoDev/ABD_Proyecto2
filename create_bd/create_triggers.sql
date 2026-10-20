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
    DECLARE @has_cycle INT = 0;
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
    SELECT TOP 1 @has_cycle = 1
    FROM superiorChain
    WHERE original_id = current_id

    IF @has_cycle = 1
    BEGIN
        RAISERROR ('Un supervisor no puede ser superior de un superior suyo.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;
GO

-- 3. Recupero por devolución
CREATE OR ALTER TRIGGER reports.TR_Recit_CheckDevolution_Commission
ON reports.recit
AFTER UPDATE -- no sé si deberia dispararse con inserts también?
AS 
BEGIN
    SET NOCOUNT ON;
    -- verificar si el cambio fue del estado y es a anulado
    IF NOT EXISTS (
        SELECT 1
        FROM inserted i
        JOIN deleted d ON i.number = d.number
        WHERE LOWER(i.status) = 'canceled'
            AND LOWER(d.status) <> 'canceled'
    )
    RETURN;

    -- verifica si el plan de comisión asociado tiene la opcion de discount
    IF EXISTS (
        SELECt 1
        FROM reports.commission_plan_history cph
        INNER JOIN (
            SELECT cph.sales_rep_id, cph.role_id, MAX(cph.start_date) latest_date
            FROM reports.commission_plan_history cph
            JOIN reports.commission c ON c.sales_rep_id = cph.sales_rep_id AND c.role_id = cph.role_id
            JOIN inserted i ON i.number = c.recit_number
            WHERE LOWER(i.status) = 'canceled'
            GROUP BY cph.sales_rep_id, cph.role_id
        ) cph_max ON cph_max.sales_rep_id = cph.sales_rep_id 
            AND cph_max.role_id = cph.role_id 
            AND cph_max.latest_date = cph.start_date
        JOIN reports.commission_plan cp ON cp.code = cph.commission_plan_code
        WHERE cp.discount = 1
    )
    BEGIN
        -- se resta el monto correspondiente de la entrada de commission_calculation,
        -- si no existe entrada la creamos con un monto negativo
        MERGE reports.commission_calculation AS target
        USING (
            SELECT c.sales_rep_id AS person_id, p.id AS period_id,
                SUM(rd.product_subtotal * c.participation_percentage * cp.commission_rate) AS total_deduct
            FROM inserted i
            JOIN reports.period p 
                ON i.date_created >= p.start_date AND i.date_created <= p.end_date
            JOIN reports.recit_detail rd ON i.number = rd.number_recit
            JOIN reports.commission c ON c.recit_number = i.number
            CROSS APPLY (
                SELECT TOP 1 cph.commission_plan_code
                FROM reports.commission_plan_history cph
                WHERE cph.sales_rep_id = c.sales_rep_id 
                  AND cph.role_id = c.role_id
                  AND (cph.start_date <= i.date_created OR cph.start_date IS NULL)
                ORDER BY cph.start_date DESC
            ) latest_cph
            JOIN reports.commission_plan cp ON cp.code = latest_cph.commission_plan_code
            WHERE LOWER(i.status) = 'canceled' AND cp.discount = 1
            GROUP BY c.sales_rep_id, p.id
        ) AS source
            ON target.person_id = source.person_id AND target.period_id = source.period_id
        WHEN MATCHED THEN
            UPDATE SET target.amount = target.amount - source.total_deduct
        WHEN NOT MATCHED THEN
            INSERT (person_id, period_id, amount, status)
            VALUES (source.person_id, source.period_id, -source.total_deduct, 'Clawback');
    END;
END;
GO

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

    INSERT INTO reports.works_under (sales_rep_id, supervisor_id, validity_date, recognition_rate)
    SELECT id, supervisor_id, supervisor_validity_date, recognition_rate
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
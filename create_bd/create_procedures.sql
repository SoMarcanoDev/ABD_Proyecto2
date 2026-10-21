USE CompuComisiones;
GO

CREATE OR ALTER PROCEDURE reports.sp_calcular_comisiones
    @period_id INT
AS
BEGIN
    SET NOCOUNT ON;

    --valida que el periodo exista y conisgue sus fechas
    DECLARE @start_date DATE;
    DECLARE @end_date DATE;

    SELECT
        @start_date = start_date,
        @end_date = end_date
    FROM reports.period
    WHERE id = @period_id;

    IF @start_date IS NULL OR @end_date IS NULL
    BEGIN
        RAISERROR ('El periodo especificado no existe o no tiene fechas validas.', 16, 1);
        RETURN;
    END;

    --tabla temporal para acumular las comisiones por cada persona (vendedores y supervisores)
    CREATE TABLE #comisiones_acumuladas (
        person_id INT NOT NULL,
        monto DECIMAL(12, 2) NOT NULL
    );

    --calcular la comision que gana cada vendedor por sus propias ventas y guardarla en una tabla temporal para
    --luego poder sacar el porcentaje del supervisor
    SELECT
        c.sales_rep_id,
        r.number AS recit_number,
        r.date_paid,
        --comision=base*participacion*Tasa_Plan
        CAST(dbo_plan.base_comisionable * c.participation_percentage * cp.commission_rate AS DECIMAL(12, 2)) AS comision_vendedor
    INTO #comisiones_vendedores
    FROM reports.recit r
    JOIN reports.commission c ON r.number = c.recit_number
    --buscar el plan de comision vigente para la dupla (vendedor, rol) a la fecha de cobro de la factura
    CROSS APPLY (
        SELECT TOP 1 cph.commission_plan_code
        FROM reports.commission_plan_history cph
        WHERE cph.sales_rep_id = c.sales_rep_id
          AND cph.role_id = c.role_id
          AND cph.start_date <= r.date_paid
        ORDER BY cph.start_date DESC
    ) latest_plan
    JOIN reports.commission_plan cp ON cp.code = latest_plan.commission_plan_code
    --llamamos a la funcion de filtros para obtener la base comisionable
    CROSS APPLY (
        SELECT reports.fn_calcular_base_comisionable(r.number, cp.code) AS base_comisionable
    ) dbo_plan
    WHERE LOWER(r.status) = 'paid'
      AND r.date_paid >= @start_date
      AND r.date_paid <= @end_date;

    --acumular lo que ganan los vendedores por sus ventas
    INSERT INTO #comisiones_acumuladas (person_id, monto)
    SELECT
        sales_rep_id,
        ISNULL(SUM(comision_vendedor), 0.00)
    FROM #comisiones_vendedores
    GROUP BY sales_rep_id;

    --calcular el reconocimiento que perciben los supervisores sobre lo que sus vendedores generaron en esas mismas
    --facturas
    INSERT INTO #comisiones_acumuladas (person_id, monto)
    SELECT
        sup.supervisor_id,
        ISNULL(SUM(cv.comision_vendedor * sup.recognition_rate), 0.00)
    FROM #comisiones_vendedores cv
    --buscar el supervisor y tasa vigente a la fecha de cobro de la factura
    CROSS APPLY (
        SELECT TOP 1 wu.supervisor_id, wu.recognition_rate
        FROM reports.works_under wu
        WHERE wu.sales_rep_id = cv.sales_rep_id
          AND wu.validity_date <= cv.date_paid
        ORDER BY wu.validity_date DESC
    ) sup
    GROUP BY sup.supervisor_id;

    --insertar o actualizar en reports.commission_calculation usando merge para ver si una persona es a la
    --vez vendedor o supervisor
    MERGE reports.commission_calculation AS target
    USING (
        SELECT
            person_id,
            @period_id AS period_id,
            SUM(monto) AS total_amount
        FROM #comisiones_acumuladas
        GROUP BY person_id
        HAVING SUM(monto) > 0
    ) AS source
    ON target.person_id = source.person_id AND target.period_id = source.period_id
    WHEN MATCHED THEN
        UPDATE SET target.amount = source.total_amount, target.status = 'Calculado'
    WHEN NOT MATCHED THEN
        INSERT (person_id, period_id, amount, status)
        VALUES (source.person_id, source.period_id, source.total_amount, 'Calculado');

    --limpieza de tablas temporales
    DROP TABLE #comisiones_acumuladas;
    DROP TABLE #comisiones_vendedores;
END;
GO

CREATE OR ALTER PROCEDURE reports.sp_registrar_pagos
    @period_id_calculo INT,
    @period_id_pago INT,
    @fecha_pago DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    --validar que ambos periodos existan
    IF NOT EXISTS (SELECT 1 FROM reports.period WHERE id = @period_id_calculo)
    BEGIN
        RAISERROR ('El periodo de calculo especificado no existe.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM reports.period WHERE id = @period_id_pago)
    BEGIN
        RAISERROR ('El periodo de pago especificado no existe.', 16, 1);
        RETURN;
    END;

    --si no se envia fecha de pago, se toma la fecha actual
    IF @fecha_pago IS NULL
        SET @fecha_pago = CAST(GETDATE() AS DATE);

    --validar que existan comisiones calculadas y pendientes de pago para ese periodo
    IF NOT EXISTS (
        SELECT 1
        FROM reports.commission_calculation
        WHERE period_id = @period_id_calculo
          AND amount > 0
          AND LOWER(status) <> 'paid'
    )
    BEGIN
        RAISERROR ('No existen comisiones calculadas pendientes de pago para el periodo indicado.', 16, 1);
        RETURN;
    END;

    BEGIN TRANSACTION;

    BEGIN TRY
        --insertar o actualizar los pagos en reports.payment
        MERGE reports.payment AS target
        USING (
            SELECT
                person_id,
                amount
            FROM reports.commission_calculation
            WHERE period_id = @period_id_calculo
              AND amount > 0
              AND LOWER(status) <> 'paid'
        ) AS source
        ON target.person_id = source.person_id AND target.period_id = @period_id_pago
        WHEN MATCHED THEN
            UPDATE SET
                target.amount = source.amount,
                target.date_paid = @fecha_pago,
                target.status = 'Paid'
        WHEN NOT MATCHED THEN
            INSERT (person_id, period_id, amount, date_paid, status)
            VALUES (source.person_id, @period_id_pago, source.amount, @fecha_pago, 'Paid');

        --actualizar el estado en reports.commission_calculation a pagado
        UPDATE reports.commission_calculation
        SET status = 'Paid'
        WHERE period_id = @period_id_calculo
          AND amount > 0
          AND LOWER(status) <> 'paid';

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH;
END;
GO
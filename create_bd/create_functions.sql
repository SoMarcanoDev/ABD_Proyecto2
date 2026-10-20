USE CompuComisiones;
GO

CREATE OR ALTER FUNCTION reports.fn_calcular_base_comisionable (
    @recit_number INT,
    @plan_code INT
)
RETURNS DECIMAL(12, 2)
AS
BEGIN
    DECLARE @base_type VARCHAR(10);
    DECLARE @base_comisionable DECIMAL(12, 2) = 0.00;

    --obtener la base del plan (income, margin, quantity)
    SELECT @base_type = LOWER(base)
    FROM reports.commission_plan
    WHERE code = @plan_code;

    --si el plan no existe retorna 0
    IF @base_type IS NULL
        RETURN 0.00;

    --si el plan no tiene filtros entra la factura completa
    IF NOT EXISTS (SELECT 1 FROM reports.filter WHERE plan_code = @plan_code)
    BEGIN
        SELECT @base_comisionable = CASE
            WHEN @base_type = 'quantity' THEN ISNULL(SUM(rd.product_quantity), 0)
            ELSE ISNULL(SUM(rd.product_subtotal), 0) --income o margin
        END
        FROM reports.recit_detail rd
        WHERE rd.number_recit = @recit_number;

        RETURN @base_comisionable;
    END;

    --si el plan tiene filtros se revisa cada línea de detalle
    --una línea va a entrar al calculo si cumple con todos los filtros definidos para ese plan
    SELECT @base_comisionable = CASE
        WHEN @base_type = 'quantity' THEN ISNULL(SUM(lineas_validas.product_quantity), 0)
        ELSE ISNULL(SUM(lineas_validas.product_subtotal), 0)
    END
    FROM (
        SELECT rd.product_quantity, rd.product_subtotal
        FROM reports.recit_detail rd
        JOIN reports.recit r ON rd.number_recit = r.number
        JOIN reports.product prod ON rd.product_id = prod.id
        JOIN reports.client c ON r.client_id = c.id
        WHERE rd.number_recit = @recit_number
          --verificamos que esta línea cumpla todos los filtros del plan:
          AND NOT EXISTS (
              SELECT 1
              FROM reports.filter f
              WHERE f.plan_code = @plan_code
                AND NOT (
                    --categoría
                    (f.content LIKE 'Category = %' AND LOWER(prod.category) = LOWER(LTRIM(RTRIM(SUBSTRING(f.content, 12, LEN(f.content))))))
                    --segmento de cliente
                    OR (f.content LIKE 'Client_Segment = %' AND LOWER(c.market_segment) = LOWER(LTRIM(RTRIM(SUBSTRING(f.content, 18, LEN(f.content))))))
                    --cantidad minima
                    OR (f.content LIKE 'Quantity >= %' AND rd.product_quantity >= TRY_CAST(LTRIM(RTRIM(SUBSTRING(f.content, 13, LEN(f.content)))) AS INT))
                    --monto minimo
                    OR (f.content LIKE 'Amount > %' AND rd.product_subtotal > TRY_CAST(LTRIM(RTRIM(SUBSTRING(f.content, 10, LEN(f.content)))) AS DECIMAL(12,2)))
                    --concepto de venta
                    OR (f.content LIKE 'Concept = %' AND LOWER(rd.sale_concept) = LOWER(LTRIM(RTRIM(SUBSTRING(f.content, 11, LEN(f.content))))))
                    --producto especifico
                    OR (f.content LIKE 'Product_Id = %' AND prod.id = TRY_CAST(LTRIM(RTRIM(SUBSTRING(f.content, 14, LEN(f.content)))) AS INT))
                )
          )
    ) AS lineas_validas;

    RETURN ISNULL(@base_comisionable, 0.00);
END;
GO
-- ============================================================
-- Descripción: Este script inserta registros en la base de datos.

USE CompuComisiones;
GO

INSERT INTO reports.vw_sales_rep (id, first_name, last_name, email, hired_date, status, sales_quota)
VALUES (1, 'John', 'Doe', 'john@email.com', '2026-03-01', 1, 50000.00);
-- ============================================================
-- Descripción: Este script inserta registros en la base de datos.

USE CompuComisiones;
GO

-- Limpiar tablas 
DELETE FROM reports.works_under;
DELETE FROM reports.sales_rep;
DELETE FROM reports.supervisor;
DELETE FROM reports.finance_team_member;
DELETE FROM reports.person;
GO

-- Crear inserciones
-- Supervisores
INSERT INTO reports.vw_supervisor (id, first_name, last_name, email, hired_date, status, zone_in_charge, superior_id)
VALUES (11, 'Roberto', 'Gomez', 'roberto.gomez@email.com', '2023-01-10', 1, 'Northen Region', NULL);

INSERT INTO reports.vw_supervisor (id, first_name, last_name, email, hired_date, status, zone_in_charge, superior_id)
VALUES (12, 'Elena', 'Vargas', 'elena.vargas@email.com', '2024-03-15', 1, 'District North-A', 11);

INSERT INTO reports.vw_supervisor (id, first_name, last_name, email, hired_date, status, zone_in_charge, superior_id)
VALUES (13, 'Diego', 'Ramirez', 'diego.ramirez@email.com', '2024-06-20', 1, 'District North-B', 11);

INSERT INTO reports.vw_supervisor (id, first_name, last_name, email, hired_date, status, zone_in_charge, superior_id)
VALUES (14, 'Camila', 'Castro', 'camila.castro@email.com', '2022-11-05', 1, 'Southern Region', NULL);

INSERT INTO reports.vw_supervisor (id, first_name, last_name, email, hired_date, status, zone_in_charge, superior_id)
VALUES (15, 'Gabriel', 'Ortiz', 'gabriel.ortiz@email.com', '2025-01-12', 1, 'District South-A', 14);

INSERT INTO reports.vw_supervisor (id, first_name, last_name, email, hired_date, status, zone_in_charge, superior_id)
VALUES (16, 'Valentina', 'Rojas', 'valentina.rojas@email.com', '2025-09-01', 1, 'Sub-District South-A1', 15);

INSERT INTO reports.vw_supervisor (id, first_name, last_name, email, hired_date, status, zone_in_charge, superior_id)
VALUES (17, 'Andres', 'Navarro', 'andres.navarro@email.com', '2023-08-19', 1, 'Eastern Region', NULL);

INSERT INTO reports.vw_supervisor (id, first_name, last_name, email, hired_date, status, zone_in_charge, superior_id)
VALUES (18, 'Sonia', 'Mendez', 'sonia.mendez@email.com', '2026-02-10', 1, 'District East-A', 17);

INSERT INTO reports.vw_supervisor (id, first_name, last_name, email, hired_date, status, zone_in_charge, superior_id)
VALUES (19, 'Martin', 'Pardo', 'martin.pardo@email.com', '2021-04-01', 0, 'Western Region', NULL);

INSERT INTO reports.vw_supervisor (id, first_name, last_name, email, hired_date, status, zone_in_charge, superior_id)
VALUES (20, 'Paula', 'Rivas', 'paula.rivas@email.com', '2025-05-18', 1, 'District West-A', 19);
GO

-- Vendedores
INSERT INTO reports.vw_sales_rep (id, first_name, last_name, email, hired_date, status, sales_quota, supervisor_id, supervisor_validity_date, recognition_rate)
VALUES (1, 'John', 'Doe', 'john@email.com', '2026-03-01', 0, 50000.00, 11, '2026-03-01', 0.0500);

INSERT INTO reports.vw_sales_rep (id, first_name, last_name, email, hired_date, status, sales_quota, supervisor_id, supervisor_validity_date, recognition_rate)
VALUES (2, 'Miguelangel', 'Parra', 'migue13parra@email.com', '2025-06-04', 1, 60000.00, 12, '2025-06-04', 0.0650);

INSERT INTO reports.vw_sales_rep (id, first_name, last_name, email, hired_date, status, sales_quota, supervisor_id, supervisor_validity_date, recognition_rate)
VALUES (3, 'Nuria', 'Torres', 'nunu13@email.com', '2026-09-21', 1, 45000.00, 13, '2026-09-21', 0.0400);

INSERT INTO reports.vw_sales_rep (id, first_name, last_name, email, hired_date, status, sales_quota, supervisor_id, supervisor_validity_date, recognition_rate)
VALUES (4, 'Andrea', 'Novas', 'andromedanovas@email.com', '2024-12-01', 1, 8300.00, 14, '2024-12-01', 0.0700);

INSERT INTO reports.vw_sales_rep (id, first_name, last_name, email, hired_date, status, sales_quota, supervisor_id, supervisor_validity_date, recognition_rate)
VALUES (5, 'Carlos', 'Mendoza', 'carlos.mendoza@email.com', '2025-01-15', 1, 55000.00, 15, '2025-01-15', 0.0550);

INSERT INTO reports.vw_sales_rep (id, first_name, last_name, email, hired_date, status, sales_quota, supervisor_id, supervisor_validity_date, recognition_rate)
VALUES (6, 'Sofia', 'Gomez', 'sofi.gomez@email.com', '2023-11-10', 0, 32000.00, 16, '2023-11-10', 0.0300);

INSERT INTO reports.vw_sales_rep (id, first_name, last_name, email, hired_date, status, sales_quota, supervisor_id, supervisor_validity_date, recognition_rate)
VALUES (7, 'Lucas', 'Silva', 'lucas.silva@email.com', '2026-02-14', 1, 72000.00, 17, '2026-02-14', 0.0800);

INSERT INTO reports.vw_sales_rep (id, first_name, last_name, email, hired_date, status, sales_quota, supervisor_id, supervisor_validity_date, recognition_rate)
VALUES (8, 'Valeria', 'Ruiz', 'valeria.ruiz@email.com', '2025-08-19', 1, 41000.00, 18, '2025-08-19', 0.0450);

INSERT INTO reports.vw_sales_rep (id, first_name, last_name, email, hired_date, status, sales_quota, supervisor_id, supervisor_validity_date, recognition_rate)
VALUES (9, 'Mateo', 'Morales', 'mateo.m@email.com', '2024-05-22', 0, 29000.00, 19, '2024-05-22', 0.0350);

INSERT INTO reports.vw_sales_rep (id, first_name, last_name, email, hired_date, status, sales_quota, supervisor_id, supervisor_validity_date, recognition_rate)
VALUES (10, 'Lucia', 'Fernandez', 'lucia.f@email.com', '2026-01-05', 1, 95000.00, 20, '2026-01-05', 0.0900);
GO

-- Equipo de finanzas
INSERT INTO reports.vw_finance_team_member (id, first_name, last_name, email, hired_date, status, job_title)
VALUES (21, 'Julian', 'Torres', 'julian.torres@email.com', '2023-05-12', 1, 'Accountant');

INSERT INTO reports.vw_finance_team_member (id, first_name, last_name, email, hired_date, status, job_title)
VALUES (22, 'Mariana', 'Rios', 'mariana.rios@email.com', '2024-02-18', 1, 'Financial Analyst');

INSERT INTO reports.vw_finance_team_member (id, first_name, last_name, email, hired_date, status, job_title)
VALUES (23, 'Esteban', 'Castro', 'esteban.castro@email.com', '2022-10-01', 1, 'Auditor');

INSERT INTO reports.vw_finance_team_member (id, first_name, last_name, email, hired_date, status, job_title)
VALUES (24, 'Gabriela', 'Silva', 'gabriela.silva@email.com', '2025-07-20', 1, 'Payroll Specialist');

INSERT INTO reports.vw_finance_team_member (id, first_name, last_name, email, hired_date, status, job_title)
VALUES (25, 'Ricardo', 'Morales', 'ricardo.morales@email.com', '2021-03-15', 0, 'Treasurer');

INSERT INTO reports.vw_finance_team_member (id, first_name, last_name, email, hired_date, status, job_title)
VALUES (26, 'Daniela', 'Vargas', 'daniela.vargas@email.com', '2026-01-10', 1, 'Senior Accountant');

INSERT INTO reports.vw_finance_team_member (id, first_name, last_name, email, hired_date, status, job_title)
VALUES (27, 'Tomas', 'Navarro', 'tomas.navarro@email.com', '2023-11-05', 1, 'Risk Manager');

INSERT INTO reports.vw_finance_team_member (id, first_name, last_name, email, hired_date, status, job_title)
VALUES (28, 'Jimena', 'Ortiz', 'jimena.ortiz@email.com', '2024-08-14', 1, 'Tax Specialist');

INSERT INTO reports.vw_finance_team_member (id, first_name, last_name, email, hired_date, status, job_title)
VALUES (29, 'Felipe', 'Rojas', 'felipe.rojas@email.com', '2026-02-28', 1, 'Junior Analyst');

INSERT INTO reports.vw_finance_team_member (id, first_name, last_name, email, hired_date, status, job_title)
VALUES (30, 'Catalina', 'Mendoza', 'catalina.mendoza@email.com', '2020-06-01', 1, 'Controller');
GO


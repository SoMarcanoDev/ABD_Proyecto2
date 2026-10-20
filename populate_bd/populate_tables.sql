-- ============================================================
-- Descripción: Este script inserta registros en la base de datos.

USE CompuComisiones;
GO

-- Limpiar tablas 
DELETE FROM reports.payment;
DELETE FROM reports.commission_calculation;

DELETE FROM reports.commission_plan_history;
DELETE FROM reports.filter;
DELETE FROM reports.commission_plan;

DELETE FROM reports.commission;
DELETE FROM reports.role;

DELETE FROM reports.works_under;
DELETE FROM reports.sales_rep;
DELETE FROM reports.supervisor;
DELETE FROM reports.finance_team_member;
DELETE FROM reports.person;

DELETE FROM reports.recit_detail;
DELETE FROM reports.product;
DELETE FROM reports.recit;
DELETE FROM reports.client;

DELETE FROM reports.period;
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

-- productos
INSERT INTO reports.product (id, name, category)
VALUES (1, 'Enterprise CRM License', 'Software');

INSERT INTO reports.product (id, name, category)
VALUES (2, 'Cloud Storage 1TB (Annual)', 'Cloud Services');

INSERT INTO reports.product (id, name, category)
VALUES (3, 'Ergonomic Office Chair', 'Office Furniture');

INSERT INTO reports.product (id, name, category)
VALUES (4, 'Wireless Mechanical Keyboard', 'Hardware');

INSERT INTO reports.product (id, name, category)
VALUES (5, 'Ultrawide 34" Monitor', 'Hardware');

INSERT INTO reports.product (id, name, category)
VALUES (6, 'Project Management Tool (Annual)', 'Software');

INSERT INTO reports.product (id, name, category)
VALUES (7, 'Electric Standing Desk', 'Office Furniture');

INSERT INTO reports.product (id, name, category)
VALUES (8, 'Noise-Canceling Headset', 'Hardware');

INSERT INTO reports.product (id, name, category)
VALUES (9, 'Cybersecurity Suite', 'Software');

INSERT INTO reports.product (id, name, category)
VALUES (10, 'HD Document Scanner', 'Hardware');

-- clientes
INSERT INTO reports.client (id, first_name, last_name, market_segment)
VALUES (1, 'Alejandro', 'Perez', 'Corporate');

INSERT INTO reports.client (id, first_name, last_name, market_segment)
VALUES (2, 'Beatriz', 'Gomez', 'Retail');

INSERT INTO reports.client (id, first_name, last_name, market_segment)
VALUES (3, 'Carlos', 'Santana', 'Technology');

INSERT INTO reports.client (id, first_name, last_name, market_segment)
VALUES (4, 'Diana', 'Ross', 'Healthcare');

INSERT INTO reports.client (id, first_name, last_name, market_segment)
VALUES (5, 'Eduardo', 'Silva', 'Finance');

INSERT INTO reports.client (id, first_name, last_name, market_segment)
VALUES (6, 'Fernanda', 'Lima', 'Education');

INSERT INTO reports.client (id, first_name, last_name, market_segment)
VALUES (7, 'Gabriel', 'Morales', 'Manufacturing');

INSERT INTO reports.client (id, first_name, last_name, market_segment)
VALUES (8, 'Helena', 'Vargas', 'Telecommunications');

INSERT INTO reports.client (id, first_name, last_name, market_segment)
VALUES (9, 'Ignacio', 'Castro', 'Energy');

INSERT INTO reports.client (id, first_name, last_name, market_segment)
VALUES (10, 'Julia', 'Rojas', 'Retail');
GO

-- facturas
INSERT INTO reports.recit (number, date_created, status, client_id, date_paid)
VALUES (101, '2026-01-10', 'paid', 1, '2026-01-12');

INSERT INTO reports.recit (number, date_created, status, client_id, date_paid)
VALUES (102, '2026-01-15', 'issued', 2, NULL);

INSERT INTO reports.recit (number, date_created, status, client_id, date_paid)
VALUES (103, '2026-02-01', 'paid', 3, '2026-02-05');

INSERT INTO reports.recit (number, date_created, status, client_id, date_paid)
VALUES (104, '2026-02-10', 'canceled', 4, NULL);

INSERT INTO reports.recit (number, date_created, status, client_id, date_paid)
VALUES (105, '2026-03-01', 'paid', 5, '2026-03-02');

INSERT INTO reports.recit (number, date_created, status, client_id, date_paid)
VALUES (106, '2026-03-05', 'issued', 6, NULL);

INSERT INTO reports.recit (number, date_created, status, client_id, date_paid)
VALUES (107, '2026-04-12', 'paid', 7, '2026-04-15');

INSERT INTO reports.recit (number, date_created, status, client_id, date_paid)
VALUES (108, '2026-05-01', 'canceled', 8, NULL);

INSERT INTO reports.recit (number, date_created, status, client_id, date_paid)
VALUES (109, '2026-05-20', 'paid', 9, '2026-05-22');

INSERT INTO reports.recit (number, date_created, status, client_id, date_paid)
VALUES (110, '2026-06-01', 'issued', 10, NULL);
GO

-- detalles de factura
INSERT INTO reports.recit_detail (number_recit, product_id, product_quantity, product_subtotal, sale_concept)
VALUES (101, 1, 2, 1000.00, 'Enterprise CRM licenses');

INSERT INTO reports.recit_detail (number_recit, product_id, product_quantity, product_subtotal, sale_concept)
VALUES (102, 2, 1, 120.00, 'Cloud Storage annual subscription');

INSERT INTO reports.recit_detail (number_recit, product_id, product_quantity, product_subtotal, sale_concept)
VALUES (103, 3, 4, 600.00, 'Ergonomic chairs for office');

INSERT INTO reports.recit_detail (number_recit, product_id, product_quantity, product_subtotal, sale_concept)
VALUES (104, 4, 10, 450.00, 'Mechanical keyboards bundle');

INSERT INTO reports.recit_detail (number_recit, product_id, product_quantity, product_subtotal, sale_concept)
VALUES (105, 5, 2, 800.00, 'Ultrawide monitors');

INSERT INTO reports.recit_detail (number_recit, product_id, product_quantity, product_subtotal, sale_concept)
VALUES (106, 6, 1, 500.00, 'Project management tool');

INSERT INTO reports.recit_detail (number_recit, product_id, product_quantity, product_subtotal, sale_concept)
VALUES (107, 7, 3, 900.00, 'Electric standing desks');

INSERT INTO reports.recit_detail (number_recit, product_id, product_quantity, product_subtotal, sale_concept)
VALUES (108, 8, 5, 250.00, 'Noise-canceling headsets');

INSERT INTO reports.recit_detail (number_recit, product_id, product_quantity, product_subtotal, sale_concept)
VALUES (109, 9, 1, 1200.00, 'Cybersecurity suite enterprise');

INSERT INTO reports.recit_detail (number_recit, product_id, product_quantity, product_subtotal, sale_concept)
VALUES (110, 10, 2, 300.00, 'Document scanners');
GO

-- roles
INSERT INTO reports.role (id, name, description)
VALUES (1, 'Primary Seller', 'Main sales representative who closed the deal');

INSERT INTO reports.role (id, name, description)
VALUES (2, 'Account Manager', 'Manages the ongoing client relationship');

INSERT INTO reports.role (id, name, description)
VALUES (3, 'Sales Closer', 'Specialist brought in to finalize the negotiation');

INSERT INTO reports.role (id, name, description)
VALUES (4, 'Lead Generator', 'Sales representative responsible for initial prospecting');

INSERT INTO reports.role (id, name, description)
VALUES (5, 'Technical Advisor', 'Provides technical pre-sales support and scoping');

INSERT INTO reports.role (id, name, description)
VALUES (6, 'Regional Lead', 'Supervisor or senior rep overseeing regional performance');

INSERT INTO reports.role (id, name, description)
VALUES (7, 'Support Agent', 'Assists with post-sale implementation and adoption');

INSERT INTO reports.role (id, name, description)
VALUES (8, 'Partner Rep', 'Third-party or channel partner collaboration representative');

INSERT INTO reports.role (id, name, description)
VALUES (9, 'Consultant', 'Domain expert providing specialized guidance');

INSERT INTO reports.role (id, name, description)
VALUES (10, 'Onboarding Specialist', 'Handles customer setup, training, and initial transition');
GO

-- comisiones
INSERT INTO reports.commission (sales_rep_id, role_id, recit_number, participation_percentage)
VALUES (1, 1, 101, 1.00);

INSERT INTO reports.commission (sales_rep_id, role_id, recit_number, participation_percentage)
VALUES (2, 2, 102, 1.00);

INSERT INTO reports.commission (sales_rep_id, role_id, recit_number, participation_percentage)
VALUES (3, 1, 103, 1.00);


INSERT INTO reports.commission (sales_rep_id, role_id, recit_number, participation_percentage)
VALUES (4, 3, 105, 0.70);
INSERT INTO reports.commission (sales_rep_id, role_id, recit_number, participation_percentage)
VALUES (5, 4, 105, 0.30);


INSERT INTO reports.commission (sales_rep_id, role_id, recit_number, participation_percentage)
VALUES (6, 1, 106, 1.00);


INSERT INTO reports.commission (sales_rep_id, role_id, recit_number, participation_percentage)
VALUES (7, 1, 107, 1.00);

INSERT INTO reports.commission (sales_rep_id, role_id, recit_number, participation_percentage)
VALUES (8, 5, 109, 0.50);
INSERT INTO reports.commission (sales_rep_id, role_id, recit_number, participation_percentage)
VALUES (9, 2, 109, 0.50);

INSERT INTO reports.commission (sales_rep_id, role_id, recit_number, participation_percentage)
VALUES (10, 1, 110, 1.00);
GO

-- planes de comisiones
INSERT INTO reports.commission_plan (code, name, commission_rate, base, discount)
VALUES (1, 'Standard Plan', 0.0500, 'income', 0);

INSERT INTO reports.commission_plan (code, name, commission_rate, base, discount)
VALUES (2, 'Premium Margin', 0.0850, 'margin', 1);

INSERT INTO reports.commission_plan (code, name, commission_rate, base, discount)
VALUES (3, 'Volume Tier 1', 0.0300, 'quantity', 0);

INSERT INTO reports.commission_plan (code, name, commission_rate, base, discount)
VALUES (4, 'Enterprise Boost', 0.1000, 'income', 1);

INSERT INTO reports.commission_plan (code, name, commission_rate, base, discount)
VALUES (5, 'Gross Margin Plus', 0.0650, 'margin', 0);

INSERT INTO reports.commission_plan (code, name, commission_rate, base, discount)
VALUES (6, 'Bulk Incentive', 0.0400, 'quantity', 0);

INSERT INTO reports.commission_plan (code, name, commission_rate, base, discount)
VALUES (7, 'New Market Growth', 0.1200, 'income', 1);

INSERT INTO reports.commission_plan (code, name, commission_rate, base, discount)
VALUES (8, 'Retention Reward', 0.0550, 'margin', 0);

INSERT INTO reports.commission_plan (code, name, commission_rate, base, discount)
VALUES (9, 'High-Unit Push', 0.0750, 'quantity', 1);

INSERT INTO reports.commission_plan (code, name, commission_rate, base, discount)
VALUES (10, 'Executive Plan', 0.0900, 'income', 0);
GO

-- filtros
INSERT INTO reports.filter (plan_code, number, content)
VALUES (1, 1, 'Region = North');

INSERT INTO reports.filter (plan_code, number, content)
VALUES (2, 1, 'Category = Software');

INSERT INTO reports.filter (plan_code, number, content)
VALUES (3, 1, 'Quantity >= 10');

INSERT INTO reports.filter (plan_code, number, content)
VALUES (4, 1, 'Amount > 5000');

INSERT INTO reports.filter (plan_code, number, content)
VALUES (5, 1, 'Margin > 25%');

INSERT INTO reports.filter (plan_code, number, content)
VALUES (6, 1, 'Quantity >= 50');

INSERT INTO reports.filter (plan_code, number, content)
VALUES (7, 1, 'Client_Segment = Corporate');

INSERT INTO reports.filter (plan_code, number, content)
VALUES (8, 1, 'Status = Paid');

INSERT INTO reports.filter (plan_code, number, content)
VALUES (9, 1, 'Quantity >= 100');

INSERT INTO reports.filter (plan_code, number, content)
VALUES (10, 1, 'Amount > 20000');
GO

-- historial de plan de comisiones
INSERT INTO reports.commission_plan_history (sales_rep_id, role_id, commission_plan_code, start_date)
VALUES (1, 1, 1, '2025-01-01');

INSERT INTO reports.commission_plan_history (sales_rep_id, role_id, commission_plan_code, start_date)
VALUES (2, 2, 2, '2025-02-01');

INSERT INTO reports.commission_plan_history (sales_rep_id, role_id, commission_plan_code, start_date)
VALUES (3, 1, 3, '2025-03-01');

INSERT INTO reports.commission_plan_history (sales_rep_id, role_id, commission_plan_code, start_date)
VALUES (4, 3, 4, '2025-04-01');

INSERT INTO reports.commission_plan_history (sales_rep_id, role_id, commission_plan_code, start_date)
VALUES (5, 4, 5, '2025-05-01');

INSERT INTO reports.commission_plan_history (sales_rep_id, role_id, commission_plan_code, start_date)
VALUES (6, 1, 6, '2025-06-01');

INSERT INTO reports.commission_plan_history (sales_rep_id, role_id, commission_plan_code, start_date)
VALUES (7, 1, 7, '2025-07-01');

INSERT INTO reports.commission_plan_history (sales_rep_id, role_id, commission_plan_code, start_date)
VALUES (8, 5, 8, '2025-08-01');

INSERT INTO reports.commission_plan_history (sales_rep_id, role_id, commission_plan_code, start_date)
VALUES (9, 2, 9, '2025-09-01');

INSERT INTO reports.commission_plan_history (sales_rep_id, role_id, commission_plan_code, start_date)
VALUES (10, 1, 10, '2025-10-01');
GO

-- periodo
INSERT INTO reports.period (id, description, aditional_notes, type, start_date, end_date)
VALUES (1, 'January 2026 Monthly Period', 'Standard monthly sales cycle', 'monthly', '2026-01-01', '2026-01-31');

INSERT INTO reports.period (id, description, aditional_notes, type, start_date, end_date)
VALUES (2, 'February 2026 Monthly Period', 'Standard monthly sales cycle', 'monthly', '2026-02-01', '2026-02-28');

INSERT INTO reports.period (id, description, aditional_notes, type, start_date, end_date)
VALUES (3, 'March 2026 Monthly Period', 'Standard monthly sales cycle', 'monthly', '2026-03-01', '2026-03-31');

INSERT INTO reports.period (id, description, aditional_notes, type, start_date, end_date)
VALUES (4, 'Q1 2026 Quarterly Period', 'First quarter summary and evaluation', 'quarterly', '2026-01-01', '2026-03-31');

INSERT INTO reports.period (id, description, aditional_notes, type, start_date, end_date)
VALUES (5, 'Q2 2026 Quarterly Period', 'Second quarter summary and evaluation', 'quarterly', '2026-04-01', '2026-06-30');

INSERT INTO reports.period (id, description, aditional_notes, type, start_date, end_date)
VALUES (6, 'Annual Period 2025', 'Previous fiscal year evaluation', 'anual', '2025-01-01', '2025-12-31');

INSERT INTO reports.period (id, description, aditional_notes, type, start_date, end_date)
VALUES (7, 'Annual Period 2026', 'Current fiscal year tracking', 'anual', '2026-01-01', '2026-12-31');

INSERT INTO reports.period (id, description, aditional_notes, type, start_date, end_date)
VALUES (8, 'Week 01 - 2026', 'First weekly cycle of the year', 'weekly', '2026-01-01', '2026-01-07');

INSERT INTO reports.period (id, description, aditional_notes, type, start_date, end_date)
VALUES (9, 'Week 02 - 2026', 'Second weekly cycle of the year', 'weekly', '2026-01-08', '2026-01-14');

INSERT INTO reports.period (id, description, aditional_notes, type, start_date, end_date)
VALUES (10, 'Week 03 - 2026', 'Third weekly cycle of the year', 'weekly', '2026-01-15', '2026-01-21');
GO

-- pago
-- para vendedores
INSERT INTO reports.payment (person_id, period_id, amount, date_paid, status)
VALUES (1, 1, 2500.00, '2026-02-05', 'Paid');

INSERT INTO reports.payment (person_id, period_id, amount, date_paid, status)
VALUES (2, 1, 3900.00, '2026-02-05', 'Paid');

INSERT INTO reports.payment (person_id, period_id, amount, date_paid, status)
VALUES (3, 2, 1800.00, NULL, 'Pending');

INSERT INTO reports.payment (person_id, period_id, amount, date_paid, status)
VALUES (4, 2, 581.00, '2026-03-05', 'Paid');

-- para supervisores
INSERT INTO reports.payment (person_id, period_id, amount, date_paid, status)
VALUES (11, 4, 12500.00, '2026-04-10', 'Paid');

INSERT INTO reports.payment (person_id, period_id, amount, date_paid, status)
VALUES (12, 4, 8400.00, '2026-04-10', 'Paid');

INSERT INTO reports.payment (person_id, period_id, amount, date_paid, status)
VALUES (13, 5, 9100.00, NULL, 'Approved');

-- para el equipo de finanzas
INSERT INTO reports.payment (person_id, period_id, amount, date_paid, status)
VALUES (21, 1, 4200.00, '2026-02-01', 'Paid');

INSERT INTO reports.payment (person_id, period_id, amount, date_paid, status)
VALUES (22, 2, 4800.00, '2026-03-01', 'Paid');

INSERT INTO reports.payment (person_id, period_id, amount, date_paid, status)
VALUES (23, 3, 5100.00, NULL, 'Processing');
GO

-- calculo de comisiones
-- para vendedores
INSERT INTO reports.commission_calculation (person_id, period_id, amount, status)
VALUES (1, 1, 2500.00, 'Calculated');

INSERT INTO reports.commission_calculation (person_id, period_id, amount, status)
VALUES (2, 1, 3900.00, 'Calculated');

INSERT INTO reports.commission_calculation (person_id, period_id, amount, status)
VALUES (3, 2, 1800.00, 'Pending');

INSERT INTO reports.commission_calculation (person_id, period_id, amount, status)
VALUES (4, 2, 581.00, 'Calculated');

INSERT INTO reports.commission_calculation (person_id, period_id, amount, status)
VALUES (5, 3, 3025.00, 'Approved');

INSERT INTO reports.commission_calculation (person_id, period_id, amount, status)
VALUES (6, 3, 960.00, 'Draft');

INSERT INTO reports.commission_calculation (person_id, period_id, amount, status)
VALUES (7, 4, 5760.00, 'Calculated');

-- Para supervisores
INSERT INTO reports.commission_calculation (person_id, period_id, amount, status)
VALUES (11, 4, 12500.00, 'Calculated');

INSERT INTO reports.commission_calculation (person_id, period_id, amount, status)
VALUES (12, 4, 8400.00, 'Calculated');

INSERT INTO reports.commission_calculation (person_id, period_id, amount, status)
VALUES (13, 5, 9100.00, 'Approved');
GO
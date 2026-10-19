USE CompuComisiones;
GO

--indices para nombres
--Nombre de persona
DROP INDEX IF EXISTS first_name_person_indx ON reports.person;
CREATE NONCLUSTERED INDEX first_name_person_indx
ON reports.person (first_name, last_name)
ON FG_Indices;
GO

--Nombre de cliente
DROP INDEX IF EXISTS first_name_client_indx ON reports.client;
CREATE NONCLUSTERED INDEX first_name_client_indx
ON reports.client (first_name, last_name)
ON FG_Indices;
GO

--Nombre de producto
DROP INDEX IF EXISTS name_product_indx ON reports.product;
CREATE NONCLUSTERED INDEX name_product_indx
ON reports.product (name)
ON FG_Indices;
GO

--Nombre de rol
DROP INDEX IF EXISTS name_role_indx ON reports.role;
CREATE NONCLUSTERED INDEX name_role_indx
ON reports.role (name)
ON FG_Indices;
GO

--Nombre de plan de comision
DROP INDEX IF EXISTS name_commission_plan_indx ON reports.commission_plan;
CREATE NONCLUSTERED INDEX name_commission_plan_indx
ON reports.commission_plan (name)
ON FG_Indices;
GO

--para claves foraneas, para joins y triggers
-- Supervisor para el trigger 2
DROP INDEX IF EXISTS superior_id_supervisor_indx ON reports.supervisor;
CREATE NONCLUSTERED INDEX superior_id_supervisor_indx
ON reports.supervisor (superior_id)
WHERE superior_id IS NOT NULL
ON FG_Indices;
GO

--busqueda de vendedores a cargo de un supervisor
DROP INDEX IF EXISTS supervisor_id_works_under_indx ON reports.works_under;
CREATE NONCLUSTERED INDEX supervisor_id_works_under_indx
ON reports.works_under (supervisor_id)
ON FG_Indices;
GO

--facturas, busqueda por cliente
DROP INDEX IF EXISTS client_id_recit_indx ON reports.recit;
CREATE NONCLUSTERED INDEX client_id_recit_indx
ON reports.recit (client_id)
ON FG_Indices;
GO

--detalle de factura: búsqueda por producto
DROP INDEX IF EXISTS product_id_recit_detail_indx ON reports.recit_detail;
CREATE NONCLUSTERED INDEX product_id_recit_detail_indx
ON reports.recit_detail (product_id)
ON FG_Indices;
GO

--comisiones para el Trigger 1
DROP INDEX IF EXISTS recit_number_commission_indx ON reports.commission;
CREATE NONCLUSTERED INDEX recit_number_commission_indx
ON reports.commission (recit_number)
INCLUDE (participation_percentage)
ON FG_Indices;
GO

DROP INDEX IF EXISTS role_id_commission_indx ON reports.commission;
CREATE NONCLUSTERED INDEX role_id_commission_indx
ON reports.commission (role_id)
ON FG_Indices;
GO

--Pagos y calculos por persona
DROP INDEX IF EXISTS person_id_payment_indx ON reports.payment;
CREATE NONCLUSTERED INDEX person_id_payment_indx
ON reports.payment (person_id)
ON FG_Indices;
GO

DROP INDEX IF EXISTS person_id_commission_calculation_indx ON reports.commission_calculation;
CREATE NONCLUSTERED INDEX person_id_commission_calculation_indx
ON reports.commission_calculation (person_id)
ON FG_Indices;
GO


--para consultas frecuentes
--facturas cobradas dentro del rango del periodo
DROP INDEX IF EXISTS status_date_created_recit_indx ON reports.recit;
CREATE NONCLUSTERED INDEX status_date_created_recit_indx
ON reports.recit (status, date_created)
ON FG_Indices;
GO

--historial de plan para encontrar el plan vigente de la dupla (vendedor, rol)
DROP INDEX IF EXISTS plan_vigente_commission_plan_history_indx ON reports.commission_plan_history;
CREATE NONCLUSTERED INDEX plan_vigente_commission_plan_history_indx
ON reports.commission_plan_history (sales_rep_id, role_id, start_date DESC)
INCLUDE (commission_plan_code)
ON FG_Indices;
GO

--periodos: busqueda por rango de fechas
DROP INDEX IF EXISTS start_end_date_period_indx ON reports.period;
CREATE NONCLUSTERED INDEX start_end_date_period_indx
ON reports.period (start_date, end_date)
ON FG_Indices;
GO
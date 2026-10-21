-- ============================================================
-- Descripción: Este script hace la configuración inicial de la estrategia de respaldos.

USE CompuComisiones;
GO

ALTER DATABASE CompuComisiones SET RECOVERY FULL;
GO
BACKUP DATABASE CompuComisiones
TO DISK = 'C:\SQLData\backup\CompuComisiones_FULL.bak'
WITH INIT, COMPRESSION, CHECKSUM, STATS = 10;
GO
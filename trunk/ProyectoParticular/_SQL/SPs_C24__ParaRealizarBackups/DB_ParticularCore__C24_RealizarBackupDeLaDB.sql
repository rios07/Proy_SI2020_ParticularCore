-- =====================================================
-- Descripción: Creación de las TABLAS
-- Script: DB_ParticularCore__C24_RealizarBackupDeLaDB.sql - INICIO
-- =====================================================


				 --REF: https://sqlbackupandftp.com/blog/how-to-automate-sql-server-database-backups
				 --https://www.mssqltips.com/sqlservertip/1070/simple-script-to-backup-all-sql-server-databases/
				 
				 
USE DB_ParticularCore
GO

DECLARE @NombreEnELBackup VARCHAR(100) = 'DB_ParticularCore'
	,@FechaTexto VARCHAR(9) = CAST(YEAR(GETDATE()) AS VARCHAR) + RIGHT(CAST(100 + MONTH(GETDATE()) AS VARCHAR), 2) + '-' + RIGHT(CAST(100 + DAY(GETDATE()) AS VARCHAR), 2) --'202001-02'
	,@BackupearEnElServidor BIT = '0'
	,@Nombre VARCHAR(100)
	
--SET @Nombre = '_vC01' -- "Hasta ese Script inclusive"
--SET @Nombre = '_vC02-07'
--SET @Nombre = '_vC02-08a'
--SET @Nombre = '_vC02-10'
--SET @Nombre = '_vC02-13b-SinAutom'
--SET @Nombre = '_vC02-13b'
--SET @Nombre = '_vC02-19a'
--SET @Nombre = '_vC02-19a2'
--SET @Nombre = '_vC02-19a3'
--SET @Nombre = '_vC02-19a4'
--SET @Nombre = '_vC02-19b'
--SET @Nombre = '_vC02-19c'
--SET @Nombre = '_vC03'
SET @Nombre = '_vC99'

--SET @Nombre = '_v8_Aguante_P_PostRenameTablasYAntesDeEliminarFKs'

SET @Nombre = @NombreEnELBackup + '_' + @FechaTexto + @Nombre

DECLARE @Ubicacion VARCHAR(100) = 'F:\_BDs\' + @Nombre + '.bak'

IF @BackupearEnElServidor = '1'
	BEGIN
		SET @Ubicacion = '\\is40\Compartida\DBs\' + @Nombre + '.bak'
	END
		
BACKUP DATABASE DB_ParticularCore
TO DISK = @Ubicacion
WITH FORMAT,
MEDIANAME = @Nombre,
NAME = @Nombre--, COMPRESSION; // La version express no soporta compresión.
GO


-- =====================================================
-- Script: DB_ParticularCore__C24_RealizarBackupDeLaDB.sql - FIN
-- -------------------------
-- =====================================================
-- Descripción: Restaurar BD
-- Script: DB_ParticularCore__C25-1__Restore DB.sql - INICIO
-- =====================================================


							--RESTORE DATABASE [DB_ParticularCore] 
							--FROM  DISK = N'F:\_BDs\BD_IntranetMVC_201910-09_vP01-06.bak' 
							--WITH  FILE = 1,  
							--MOVE N'DB_ParticularCore_dat' 
							--TO N'c:\Program Files (x86)\Microsoft SQL Server\MSSQL10_50.SQLEXPRESS\MSSQL\DATA\DB_ParticularCore.mdf',  
							--MOVE N'DB_ParticularCore_log' 
							--TO N'c:\Program Files (x86)\Microsoft SQL Server\MSSQL10_50.SQLEXPRESS\MSSQL\DATA\DB_ParticularCore.ldf',  
							--NOUNLOAD,  REPLACE,  STATS = 10
							--GO

DECLARE @NombreEnELBackup VARCHAR(100) = 'DB_ParticularCore'
	,@FechaTexto VARCHAR(9) = '201911-12'
	,@BackupearEnElServidor BIT = '0'
	,@Nombre VARCHAR(100)
	,@DB VARCHAR(100) = 'DB_ParticularCore'
	,@PathDB VARCHAR(100) = 'c:\Program Files (x86)\Microsoft SQL Server\MSSQL10_50.SQLEXPRESS\MSSQL\DATA\'
	

DECLARE @Dat VARCHAR(100) =  @DB + '_dat' 
	,@DatTo VARCHAR(100) = @PathDB + @DB + '.mdf'
	,@Log VARCHAR(100) =  @DB + '_log' 
	,@LogTo VARCHAR(100) = @PathDB + @DB + '.ldf'

SET @Nombre = 'DB_ParticularCore_backup_2019_09_01_190001_2769588'
--SET @Nombre = @NombreEnELBackup + '_' + @FechaTexto + '_vC01' -- "Hasta ese Script inclusive"
--SET @Nombre = @NombreEnELBackup + '_' + @FechaTexto + '_vC02-13b-SinAutom'
--SET @Nombre = @NombreEnELBackup + '_' + @FechaTexto + '_vC02-13b'
--SET @Nombre = @NombreEnELBackup + '_' + @FechaTexto + '_vC02-19a'
--SET @Nombre = @NombreEnELBackup + '_' + @FechaTexto + '_vC02-19a2'
--SET @Nombre = @NombreEnELBackup + '_' + @FechaTexto + '_vC02-19a3'
--SET @Nombre = @NombreEnELBackup + '_' + @FechaTexto + '_vC02-19a4'
--SET @Nombre = @NombreEnELBackup + '_' + @FechaTexto + '_vC02-19b'
--SET @Nombre = @NombreEnELBackup + '_' + @FechaTexto + '_vC02-19c'
--SET @Nombre = @NombreEnELBackup + '_' + @FechaTexto + '_vC02-99__P'
--SET @Nombre = @NombreEnELBackup + '_' + @FechaTexto + '_vC03'
--SET @Nombre = @NombreEnELBackup + '_' + @FechaTexto + '_vP01-01'
--SET @Nombre = @NombreEnELBackup + '_' + @FechaTexto + '_vP01-02'
--SET @Nombre = @NombreEnELBackup + '_' + @FechaTexto + '_vP01-03'
--SET @Nombre = @NombreEnELBackup + '_' + @FechaTexto + '_vP01-04'
--SET @Nombre = @NombreEnELBackup + '_' + @FechaTexto + '_vP01-05'
--SET @Nombre = @NombreEnELBackup + '_' + @FechaTexto + '_vP01-06'
--SET @Nombre = @NombreEnELBackup + '_' + @FechaTexto + '_vP01-07'
--SET @Nombre = @NombreEnELBackup + '_' + @FechaTexto + '_vP01-08'
--SET @Nombre = @NombreEnELBackup + '_' + @FechaTexto + '_vP01-09'
--SET @Nombre = @NombreEnELBackup + '_' + @FechaTexto + '_vP01-10'
--SET @Nombre = @NombreEnELBackup + '_' + @FechaTexto + '_vP01-11'
--SET @Nombre = @NombreEnELBackup + '_' + @FechaTexto + '_vP03'

DECLARE @Ubicacion VARCHAR(100) = 'F:\_BDs\' + @Nombre + '.bak'

RESTORE DATABASE [DB_ParticularCore] 
FROM  DISK = @Ubicacion
WITH  FILE = 1,  
MOVE @Dat
TO @DatTo,  
MOVE @Log
TO @LogTo,  
NOUNLOAD,  REPLACE,  STATS = 10
GO


-- =====================================================
-- Script: DB_ParticularCore__C25-1__Restore DB.sql - FIN
-- -------------------------
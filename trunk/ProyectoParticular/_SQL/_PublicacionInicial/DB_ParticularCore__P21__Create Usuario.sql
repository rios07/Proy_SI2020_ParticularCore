-- =====================================================
-- Descripción: Creacion de usuario contra SQL
-- Script: DB_ParticularCore__P21__Create Usuario.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO

IF EXISTS (SELECT loginname FROM MASTER.dbo.syslogins WHERE name = 'User_Login_DB_ParticularCore' AND dbname = 'DB_ParticularCore')
    BEGIN
		DROP LOGIN User_Login_DB_ParticularCore
	END
	
IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'User_Login_DB_ParticularCore')
	BEGIN
		DROP SCHEMA User_Login_DB_ParticularCore
		DROP USER User_Login_DB_ParticularCore
	END

CREATE LOGIN User_Login_DB_ParticularCore 
WITH 
 PASSWORD = '4nH2dV61FsT4J2eE' -- fué 'M4hU6k4S71aoU35V' hasta 2020/01
 ,DEFAULT_DATABASE = DB_ParticularCore
 ,DEFAULT_LANGUAGE = Español
GO

ALTER LOGIN User_Login_DB_ParticularCore WITH DEFAULT_LANGUAGE = Español -- SI NO, ARRIBA NO LO TOMA REALMENTE.
GO

--IF (OBJECT_ID('User_Login_DB_ParticularCore') IS NOT NULL)
--	BEGIN
		--EXEC sp_addlogin 'User_Login_DB_ParticularCore', '4nH2dV61FsT4J2eE', 'DB_ParticularCore' -- fué 'M4hU6k4S71aoU35V' hasta 2020/01
		--GO
--	END

EXEC sp_grantdbaccess 'User_Login_DB_ParticularCore'
GO


EXEC sp_addrolemember 'db_datawriter', 'User_Login_DB_ParticularCore'
GO


EXEC sp_addrolemember 'db_datareader', 'User_Login_DB_ParticularCore'
GO

EXEC sp_addrolemember 'db_owner', 'User_Login_DB_ParticularCore'
GO


-- Para realizar Backups
EXEC sp_addrolemember 'db_backupoperator', 'User_Login_DB_ParticularCore'
GO

EXEC sp_addrolemember 'db_accessadmin', 'User_Login_DB_ParticularCore'
GO

-- El Siguiente da error, pero es el rol necesario para hacer RESTORE
--EXEC sp_addrolemember 'dbcreator', 'User_Login_DB_ParticularCore'
--GO


-- =====================================================
-- Script: DB_ParticularCore__P21__Create Usuario.sql - FIN
-- -------------------------
-- =====================================================
-- Descripción: Volvemos a crear el usuario de login contra la BD
-- Script: DB_ParticularCore__C25-2__Recrear Usuario.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO


							----      REVISAR EL PASSWORD      !!!!!!!!


--EXEC sp_rename 'User_Login_DB_ParticularCore', 'User_Login_DB_ParticularCore_OLD'
--GO

DROP LOGIN User_Login_DB_ParticularCore
GO
DROP SCHEMA User_Login_DB_ParticularCore
GO
DROP USER User_Login_DB_ParticularCore
GO

CREATE LOGIN User_Login_DB_ParticularCore 
WITH 
 PASSWORD = '4nH2dV61FsT4J2eE' -- fué 'M4hU6k4S71aoU35V' y 'PwdTest1!-' de restore, hasta 2020/01 
 ,DEFAULT_DATABASE = DB_ParticularCore
 ,DEFAULT_LANGUAGE = Español
GO


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
--EXEC sp_addrolemember 'dbcreator', 'User_Login_DB_SI2014_Comunic'
--GO


-- =====================================================
-- Script: DB_ParticularCore__C25-2__Recrear Usuario.sql - FIN
-- -------------------------
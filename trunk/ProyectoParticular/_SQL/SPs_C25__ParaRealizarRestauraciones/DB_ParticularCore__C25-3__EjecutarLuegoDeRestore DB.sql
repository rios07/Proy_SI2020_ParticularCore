-- =====================================================
-- Descripción: Para corregir el "mapeo" del usuario de login (del #Servidor#\Security, no del de la propia BD) Luego de restaurar la BD desde el BK de otra PCo Servidor.
-- Script: DB_ParticularCore__C25-3__EjecutarLuegoDeRestore DB.sql - INICIO
-- =====================================================

USE master;


							----      REVISAR EL PASSWORD      !!!!!!!!
							


-- 1ero Eliminamos el Login si es que existía
DROP LOGIN User_Login_DB_ParticularCore
GO

-- 2do creamos nuevamente el Login
CREATE LOGIN User_Login_DB_ParticularCore WITH PASSWORD='4nH2dV61FsT4J2eE', CHECK_POLICY=OFF; -- fué 'M4hU6k4S71aoU35V' hasta 2020/01
GO

-- 3ro "mapeamos" el login (del servidor) con el usuario creado desntro de la BD
USE DB_ParticularCore
ALTER user User_Login_DB_ParticularCore WITH LOGIN = User_Login_DB_ParticularCore;
GO

-- Esto es algo separado, pero lo dejamos acá; Tiene que ver con el sa para darle un owner válido (y que entre otras cosas, deje crear diagramas). 
-- Esto eas necesario cuando hemos sacado el BK que restauramos desde una PC que lo hicimos con autenticacion "Windows Authenticatios" en lugar de "sa".
ALTER AUTHORIZATION ON DATABASE::DB_ParticularCore TO [sa]
GO


-- ---------------------------
-- Script: DB_ParticularCore__C25-3__EjecutarLuegoDeRestore DB.sql - FIN
-- =====================================================
-- ==========================================================================================================
-- Script: DB_ParticularCore__C06c_Funciones - Nombre de Secciones.sql - v10.5 - INICIO
-- -------------------------
 
USE DB_ParticularCore
GO
			-- En este Script solo se incluyen las funciones de Secciones que se matchean registros.
			-- El motivo es para que no queden hardcodeadas en los SPs.
 
		-- Tablas Involucradas: - INICIO
			-- Secciones
		-- Tablas Involucradas: - FIN
 
 
-- Secciones /Funciones - Nombre de Secciones/ - INICIO
IF (OBJECT_ID('ufc_Secciones__Administracion') IS NOT NULL) DROP FUNCTION ufc_Secciones__Administracion
GO
CREATE FUNCTION ufc_Secciones__Administracion
	()
	RETURNS VARCHAR(30)
	AS
	BEGIN
		RETURN 'Administracion'
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_Secciones__AdministracionId') IS NOT NULL) DROP FUNCTION ufc_Secciones__AdministracionId
GO
CREATE FUNCTION ufc_Secciones__AdministracionId
	()
	RETURNS INT
	AS
	BEGIN
		DECLARE @Nombre VARCHAR(30)
		EXEC @Nombre = ufc_Secciones__Administracion
 
		RETURN (SELECT id FROM Secciones WHERE Nombre = @Nombre)
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_Secciones__Intranet') IS NOT NULL) DROP FUNCTION ufc_Secciones__Intranet
GO
CREATE FUNCTION ufc_Secciones__Intranet
	()
	RETURNS VARCHAR(30)
	AS
	BEGIN
		RETURN 'Intranet'
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_Secciones__IntranetId') IS NOT NULL) DROP FUNCTION ufc_Secciones__IntranetId
GO
CREATE FUNCTION ufc_Secciones__IntranetId
	()
	RETURNS INT
	AS
	BEGIN
		DECLARE @Nombre VARCHAR(30)
		EXEC @Nombre = ufc_Secciones__Intranet
 
		RETURN (SELECT id FROM Secciones WHERE Nombre = @Nombre)
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_Secciones__PrivadaDelUsuario') IS NOT NULL) DROP FUNCTION ufc_Secciones__PrivadaDelUsuario
GO
CREATE FUNCTION ufc_Secciones__PrivadaDelUsuario
	()
	RETURNS VARCHAR(30)
	AS
	BEGIN
		RETURN 'PrivadaDelUsuario'
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_Secciones__PrivadaDelUsuarioId') IS NOT NULL) DROP FUNCTION ufc_Secciones__PrivadaDelUsuarioId
GO
CREATE FUNCTION ufc_Secciones__PrivadaDelUsuarioId
	()
	RETURNS INT
	AS
	BEGIN
		DECLARE @Nombre VARCHAR(30)
		EXEC @Nombre = ufc_Secciones__PrivadaDelUsuario
 
		RETURN (SELECT id FROM Secciones WHERE Nombre = @Nombre)
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_Secciones__Web') IS NOT NULL) DROP FUNCTION ufc_Secciones__Web
GO
CREATE FUNCTION ufc_Secciones__Web
	()
	RETURNS VARCHAR(30)
	AS
	BEGIN
		RETURN 'Web'
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_Secciones__WebId') IS NOT NULL) DROP FUNCTION ufc_Secciones__WebId
GO
CREATE FUNCTION ufc_Secciones__WebId
	()
	RETURNS INT
	AS
	BEGIN
		DECLARE @Nombre VARCHAR(30)
		EXEC @Nombre = ufc_Secciones__Web
 
		RETURN (SELECT id FROM Secciones WHERE Nombre = @Nombre)
	END
GO
-- Secciones /Funciones - Nombre de Secciones/ - FIN
 
 
-- -------------------------
-- Script: DB_ParticularCore__C06c_Funciones - Nombre de Secciones.sql - v10.5 - FIN
-- ==========================================================================================================

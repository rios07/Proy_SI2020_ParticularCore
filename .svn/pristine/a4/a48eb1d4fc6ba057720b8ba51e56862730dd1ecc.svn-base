-- ==========================================================================================================
-- Script: DB_ParticularCore__C06d_Funciones - Nombre de Usuarios.sql - v10.5 - INICIO
-- -------------------------
 
USE DB_ParticularCore
GO
			-- En este Script solo se incluyen las funciones de Usuarios que se matchean registros.
			-- El motivo es para que no queden hardcodeadas en los SPs.
 
		-- Tablas Involucradas: - INICIO
			-- Usuarios
		-- Tablas Involucradas: - FIN
 
 
-- Usuarios /Funciones - Nombre de Usuarios/ - INICIO
IF (OBJECT_ID('ufc_Usuarios__administrador') IS NOT NULL) DROP FUNCTION ufc_Usuarios__administrador
GO
CREATE FUNCTION ufc_Usuarios__administrador
	()
	RETURNS VARCHAR(40)
	AS
	BEGIN
		RETURN 'administrador'
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_Usuarios__administradorId') IS NOT NULL) DROP FUNCTION ufc_Usuarios__administradorId
GO
CREATE FUNCTION ufc_Usuarios__administradorId
	(
		@CodigoDelContexto VARCHAR(40)
	)
	RETURNS INT
	AS
	BEGIN
		DECLARE @id INT
			,@UserName VARCHAR(40)
 
		EXEC @UserName = ufc_Usuarios__administrador
 
		SELECT @id = U.id FROM Usuarios U
			INNER JOIN Contextos C ON U.ContextoId = C.id
		WHERE U.UserName = @UserName
			AND C.Codigo = @CodigoDelContexto
 
		RETURN @id
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_Usuarios__administradordesoportes') IS NOT NULL) DROP FUNCTION ufc_Usuarios__administradordesoportes
GO
CREATE FUNCTION ufc_Usuarios__administradordesoportes
	()
	RETURNS VARCHAR(40)
	AS
	BEGIN
		RETURN 'administradordesoportes'
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_Usuarios__administradordesoportesId') IS NOT NULL) DROP FUNCTION ufc_Usuarios__administradordesoportesId
GO
CREATE FUNCTION ufc_Usuarios__administradordesoportesId
	(
		@CodigoDelContexto VARCHAR(40)
	)
	RETURNS INT
	AS
	BEGIN
		DECLARE @id INT
			,@UserName VARCHAR(40)
 
		EXEC @UserName = ufc_Usuarios__administradordesoportes
 
		SELECT @id = U.id FROM Usuarios U
			INNER JOIN Contextos C ON U.ContextoId = C.id
		WHERE U.UserName = @UserName
			AND C.Codigo = @CodigoDelContexto
 
		RETURN @id
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_Usuarios__anonimo') IS NOT NULL) DROP FUNCTION ufc_Usuarios__anonimo
GO
CREATE FUNCTION ufc_Usuarios__anonimo
	()
	RETURNS VARCHAR(40)
	AS
	BEGIN
		RETURN 'anonimo'
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_Usuarios__anonimoId') IS NOT NULL) DROP FUNCTION ufc_Usuarios__anonimoId
GO
CREATE FUNCTION ufc_Usuarios__anonimoId
	(
		@CodigoDelContexto VARCHAR(40)
	)
	RETURNS INT
	AS
	BEGIN
		DECLARE @id INT
			,@UserName VARCHAR(40)
 
		EXEC @UserName = ufc_Usuarios__anonimo
 
		SELECT @id = U.id FROM Usuarios U
			INNER JOIN Contextos C ON U.ContextoId = C.id
		WHERE U.UserName = @UserName
			AND C.Codigo = @CodigoDelContexto
 
		RETURN @id
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_Usuarios__masteradmin') IS NOT NULL) DROP FUNCTION ufc_Usuarios__masteradmin
GO
CREATE FUNCTION ufc_Usuarios__masteradmin
	()
	RETURNS VARCHAR(40)
	AS
	BEGIN
		RETURN 'masteradmin'
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_Usuarios__masteradminId') IS NOT NULL) DROP FUNCTION ufc_Usuarios__masteradminId
GO
CREATE FUNCTION ufc_Usuarios__masteradminId
	(
		@CodigoDelContexto VARCHAR(40)
	)
	RETURNS INT
	AS
	BEGIN
		DECLARE @id INT
			,@UserName VARCHAR(40)
 
		EXEC @UserName = ufc_Usuarios__masteradmin
 
		SELECT @id = U.id FROM Usuarios U
			INNER JOIN Contextos C ON U.ContextoId = C.id
		WHERE U.UserName = @UserName
			AND C.Codigo = @CodigoDelContexto
 
		RETURN @id
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_Usuarios__SinUsuario') IS NOT NULL) DROP FUNCTION ufc_Usuarios__SinUsuario
GO
CREATE FUNCTION ufc_Usuarios__SinUsuario
	()
	RETURNS VARCHAR(40)
	AS
	BEGIN
		RETURN 'SinUsuario'
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_Usuarios__SinUsuarioId') IS NOT NULL) DROP FUNCTION ufc_Usuarios__SinUsuarioId
GO
CREATE FUNCTION ufc_Usuarios__SinUsuarioId
	(
		@CodigoDelContexto VARCHAR(40)
	)
	RETURNS INT
	AS
	BEGIN
		DECLARE @id INT
			,@UserName VARCHAR(40)
 
		EXEC @UserName = ufc_Usuarios__SinUsuario
 
		SELECT @id = U.id FROM Usuarios U
			INNER JOIN Contextos C ON U.ContextoId = C.id
		WHERE U.UserName = @UserName
			AND C.Codigo = @CodigoDelContexto
 
		RETURN @id
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_Usuarios__testadministrador') IS NOT NULL) DROP FUNCTION ufc_Usuarios__testadministrador
GO
CREATE FUNCTION ufc_Usuarios__testadministrador
	()
	RETURNS VARCHAR(40)
	AS
	BEGIN
		RETURN 'testadministrador'
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_Usuarios__testadministradorId') IS NOT NULL) DROP FUNCTION ufc_Usuarios__testadministradorId
GO
CREATE FUNCTION ufc_Usuarios__testadministradorId
	(
		@CodigoDelContexto VARCHAR(40)
	)
	RETURNS INT
	AS
	BEGIN
		DECLARE @id INT
			,@UserName VARCHAR(40)
 
		EXEC @UserName = ufc_Usuarios__testadministrador
 
		SELECT @id = U.id FROM Usuarios U
			INNER JOIN Contextos C ON U.ContextoId = C.id
		WHERE U.UserName = @UserName
			AND C.Codigo = @CodigoDelContexto
 
		RETURN @id
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_Usuarios__testmasteradmin') IS NOT NULL) DROP FUNCTION ufc_Usuarios__testmasteradmin
GO
CREATE FUNCTION ufc_Usuarios__testmasteradmin
	()
	RETURNS VARCHAR(40)
	AS
	BEGIN
		RETURN 'testmasteradmin'
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_Usuarios__testmasteradminId') IS NOT NULL) DROP FUNCTION ufc_Usuarios__testmasteradminId
GO
CREATE FUNCTION ufc_Usuarios__testmasteradminId
	(
		@CodigoDelContexto VARCHAR(40)
	)
	RETURNS INT
	AS
	BEGIN
		DECLARE @id INT
			,@UserName VARCHAR(40)
 
		EXEC @UserName = ufc_Usuarios__testmasteradmin
 
		SELECT @id = U.id FROM Usuarios U
			INNER JOIN Contextos C ON U.ContextoId = C.id
		WHERE U.UserName = @UserName
			AND C.Codigo = @CodigoDelContexto
 
		RETURN @id
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_Usuarios__testoperador') IS NOT NULL) DROP FUNCTION ufc_Usuarios__testoperador
GO
CREATE FUNCTION ufc_Usuarios__testoperador
	()
	RETURNS VARCHAR(40)
	AS
	BEGIN
		RETURN 'testoperador'
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_Usuarios__testoperadorId') IS NOT NULL) DROP FUNCTION ufc_Usuarios__testoperadorId
GO
CREATE FUNCTION ufc_Usuarios__testoperadorId
	(
		@CodigoDelContexto VARCHAR(40)
	)
	RETURNS INT
	AS
	BEGIN
		DECLARE @id INT
			,@UserName VARCHAR(40)
 
		EXEC @UserName = ufc_Usuarios__testoperador
 
		SELECT @id = U.id FROM Usuarios U
			INNER JOIN Contextos C ON U.ContextoId = C.id
		WHERE U.UserName = @UserName
			AND C.Codigo = @CodigoDelContexto
 
		RETURN @id
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_Usuarios__testoperadoravanzado') IS NOT NULL) DROP FUNCTION ufc_Usuarios__testoperadoravanzado
GO
CREATE FUNCTION ufc_Usuarios__testoperadoravanzado
	()
	RETURNS VARCHAR(40)
	AS
	BEGIN
		RETURN 'testoperadoravanzado'
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_Usuarios__testoperadoravanzadoId') IS NOT NULL) DROP FUNCTION ufc_Usuarios__testoperadoravanzadoId
GO
CREATE FUNCTION ufc_Usuarios__testoperadoravanzadoId
	(
		@CodigoDelContexto VARCHAR(40)
	)
	RETURNS INT
	AS
	BEGIN
		DECLARE @id INT
			,@UserName VARCHAR(40)
 
		EXEC @UserName = ufc_Usuarios__testoperadoravanzado
 
		SELECT @id = U.id FROM Usuarios U
			INNER JOIN Contextos C ON U.ContextoId = C.id
		WHERE U.UserName = @UserName
			AND C.Codigo = @CodigoDelContexto
 
		RETURN @id
	END
GO
-- Usuarios /Funciones - Nombre de Usuarios/ - FIN
 
 
-- -------------------------
-- Script: DB_ParticularCore__C06d_Funciones - Nombre de Usuarios.sql - v10.5 - FIN
-- ==========================================================================================================

-- ==========================================================================================================
-- Script: DB_ParticularCore__C06b_Funciones - Nombre de RolesDeUsuarios.sql - v10.6 - INICIO
-- -------------------------
 
USE DB_ParticularCore
GO
			-- En este Script solo se incluyen las funciones de RolesDeUsuarios que matchean los registros de esta tabla por sus nombres.
			-- El motivo es para que no queden hardcodeadas en los SPs.
 
		-- Tablas Involucradas: - INICIO
			-- RolesDeUsuarios
		-- Tablas Involucradas: - FIN
 
 
-- RolesDeUsuarios /Funciones - Nombre de RolesDeUsuarios/ - INICIO
IF (OBJECT_ID('ufc_RolesDeUsuarios__Administrador') IS NOT NULL) DROP FUNCTION ufc_RolesDeUsuarios__Administrador
GO
CREATE FUNCTION ufc_RolesDeUsuarios__Administrador
	()
	RETURNS VARCHAR(80)
	AS
	BEGIN
		RETURN 'Administrador'
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_RolesDeUsuarios__AdministradorId') IS NOT NULL) DROP FUNCTION ufc_RolesDeUsuarios__AdministradorId
GO
CREATE FUNCTION ufc_RolesDeUsuarios__AdministradorId
	()
	RETURNS INT
	AS
	BEGIN
		RETURN (SELECT id FROM RolesDeUsuarios WHERE Nombre = dbo.ufc_RolesDeUsuarios__Administrador())
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_RolesDeUsuarios__AdministrarSoportes') IS NOT NULL) DROP FUNCTION ufc_RolesDeUsuarios__AdministrarSoportes
GO
CREATE FUNCTION ufc_RolesDeUsuarios__AdministrarSoportes
	()
	RETURNS VARCHAR(80)
	AS
	BEGIN
		RETURN 'AdministrarSoportes'
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_RolesDeUsuarios__AdministrarSoportesId') IS NOT NULL) DROP FUNCTION ufc_RolesDeUsuarios__AdministrarSoportesId
GO
CREATE FUNCTION ufc_RolesDeUsuarios__AdministrarSoportesId
	()
	RETURNS INT
	AS
	BEGIN
		RETURN (SELECT id FROM RolesDeUsuarios WHERE Nombre = dbo.ufc_RolesDeUsuarios__AdministrarSoportes())
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_RolesDeUsuarios__Consultor') IS NOT NULL) DROP FUNCTION ufc_RolesDeUsuarios__Consultor
GO
CREATE FUNCTION ufc_RolesDeUsuarios__Consultor
	()
	RETURNS VARCHAR(80)
	AS
	BEGIN
		RETURN 'Consultor'
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_RolesDeUsuarios__ConsultorId') IS NOT NULL) DROP FUNCTION ufc_RolesDeUsuarios__ConsultorId
GO
CREATE FUNCTION ufc_RolesDeUsuarios__ConsultorId
	()
	RETURNS INT
	AS
	BEGIN
		RETURN (SELECT id FROM RolesDeUsuarios WHERE Nombre = dbo.ufc_RolesDeUsuarios__Consultor())
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_RolesDeUsuarios__MasterAdmin') IS NOT NULL) DROP FUNCTION ufc_RolesDeUsuarios__MasterAdmin
GO
CREATE FUNCTION ufc_RolesDeUsuarios__MasterAdmin
	()
	RETURNS VARCHAR(80)
	AS
	BEGIN
		RETURN 'MasterAdmin'
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_RolesDeUsuarios__MasterAdminId') IS NOT NULL) DROP FUNCTION ufc_RolesDeUsuarios__MasterAdminId
GO
CREATE FUNCTION ufc_RolesDeUsuarios__MasterAdminId
	()
	RETURNS INT
	AS
	BEGIN
		RETURN (SELECT id FROM RolesDeUsuarios WHERE Nombre = dbo.ufc_RolesDeUsuarios__MasterAdmin())
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_RolesDeUsuarios__Operador') IS NOT NULL) DROP FUNCTION ufc_RolesDeUsuarios__Operador
GO
CREATE FUNCTION ufc_RolesDeUsuarios__Operador
	()
	RETURNS VARCHAR(80)
	AS
	BEGIN
		RETURN 'Operador'
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_RolesDeUsuarios__OperadorId') IS NOT NULL) DROP FUNCTION ufc_RolesDeUsuarios__OperadorId
GO
CREATE FUNCTION ufc_RolesDeUsuarios__OperadorId
	()
	RETURNS INT
	AS
	BEGIN
		RETURN (SELECT id FROM RolesDeUsuarios WHERE Nombre = dbo.ufc_RolesDeUsuarios__Operador())
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_RolesDeUsuarios__OperadorAvanzado') IS NOT NULL) DROP FUNCTION ufc_RolesDeUsuarios__OperadorAvanzado
GO
CREATE FUNCTION ufc_RolesDeUsuarios__OperadorAvanzado
	()
	RETURNS VARCHAR(80)
	AS
	BEGIN
		RETURN 'OperadorAvanzado'
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_RolesDeUsuarios__OperadorAvanzadoId') IS NOT NULL) DROP FUNCTION ufc_RolesDeUsuarios__OperadorAvanzadoId
GO
CREATE FUNCTION ufc_RolesDeUsuarios__OperadorAvanzadoId
	()
	RETURNS INT
	AS
	BEGIN
		RETURN (SELECT id FROM RolesDeUsuarios WHERE Nombre = dbo.ufc_RolesDeUsuarios__OperadorAvanzado())
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_RolesDeUsuarios__PedirSoportes') IS NOT NULL) DROP FUNCTION ufc_RolesDeUsuarios__PedirSoportes
GO
CREATE FUNCTION ufc_RolesDeUsuarios__PedirSoportes
	()
	RETURNS VARCHAR(80)
	AS
	BEGIN
		RETURN 'PedirSoportes'
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_RolesDeUsuarios__PedirSoportesId') IS NOT NULL) DROP FUNCTION ufc_RolesDeUsuarios__PedirSoportesId
GO
CREATE FUNCTION ufc_RolesDeUsuarios__PedirSoportesId
	()
	RETURNS INT
	AS
	BEGIN
		RETURN (SELECT id FROM RolesDeUsuarios WHERE Nombre = dbo.ufc_RolesDeUsuarios__PedirSoportes())
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_RolesDeUsuarios__RecibeNotifPorModifInformes') IS NOT NULL) DROP FUNCTION ufc_RolesDeUsuarios__RecibeNotifPorModifInformes
GO
CREATE FUNCTION ufc_RolesDeUsuarios__RecibeNotifPorModifInformes
	()
	RETURNS VARCHAR(80)
	AS
	BEGIN
		RETURN 'RecibeNotifPorModifInformes'
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_RolesDeUsuarios__RecibeNotifPorModifInformesId') IS NOT NULL) DROP FUNCTION ufc_RolesDeUsuarios__RecibeNotifPorModifInformesId
GO
CREATE FUNCTION ufc_RolesDeUsuarios__RecibeNotifPorModifInformesId
	()
	RETURNS INT
	AS
	BEGIN
		RETURN (SELECT id FROM RolesDeUsuarios WHERE Nombre = dbo.ufc_RolesDeUsuarios__RecibeNotifPorModifInformes())
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_RolesDeUsuarios__RecibeNotifPorModifUsuarios') IS NOT NULL) DROP FUNCTION ufc_RolesDeUsuarios__RecibeNotifPorModifUsuarios
GO
CREATE FUNCTION ufc_RolesDeUsuarios__RecibeNotifPorModifUsuarios
	()
	RETURNS VARCHAR(80)
	AS
	BEGIN
		RETURN 'RecibeNotifPorModifUsuarios'
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_RolesDeUsuarios__RecibeNotifPorModifUsuariosId') IS NOT NULL) DROP FUNCTION ufc_RolesDeUsuarios__RecibeNotifPorModifUsuariosId
GO
CREATE FUNCTION ufc_RolesDeUsuarios__RecibeNotifPorModifUsuariosId
	()
	RETURNS INT
	AS
	BEGIN
		RETURN (SELECT id FROM RolesDeUsuarios WHERE Nombre = dbo.ufc_RolesDeUsuarios__RecibeNotifPorModifUsuarios())
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_RolesDeUsuarios__SoloLogin') IS NOT NULL) DROP FUNCTION ufc_RolesDeUsuarios__SoloLogin
GO
CREATE FUNCTION ufc_RolesDeUsuarios__SoloLogin
	()
	RETURNS VARCHAR(80)
	AS
	BEGIN
		RETURN 'SoloLogin'
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_RolesDeUsuarios__SoloLoginId') IS NOT NULL) DROP FUNCTION ufc_RolesDeUsuarios__SoloLoginId
GO
CREATE FUNCTION ufc_RolesDeUsuarios__SoloLoginId
	()
	RETURNS INT
	AS
	BEGIN
		RETURN (SELECT id FROM RolesDeUsuarios WHERE Nombre = dbo.ufc_RolesDeUsuarios__SoloLogin())
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_RolesDeUsuarios__Supervisor') IS NOT NULL) DROP FUNCTION ufc_RolesDeUsuarios__Supervisor
GO
CREATE FUNCTION ufc_RolesDeUsuarios__Supervisor
	()
	RETURNS VARCHAR(80)
	AS
	BEGIN
		RETURN 'Supervisor'
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_RolesDeUsuarios__SupervisorId') IS NOT NULL) DROP FUNCTION ufc_RolesDeUsuarios__SupervisorId
GO
CREATE FUNCTION ufc_RolesDeUsuarios__SupervisorId
	()
	RETURNS INT
	AS
	BEGIN
		RETURN (SELECT id FROM RolesDeUsuarios WHERE Nombre = dbo.ufc_RolesDeUsuarios__Supervisor())
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_RolesDeUsuarios__Visitante') IS NOT NULL) DROP FUNCTION ufc_RolesDeUsuarios__Visitante
GO
CREATE FUNCTION ufc_RolesDeUsuarios__Visitante
	()
	RETURNS VARCHAR(80)
	AS
	BEGIN
		RETURN 'Visitante'
	END
GO
 
 
 
 
IF (OBJECT_ID('ufc_RolesDeUsuarios__VisitanteId') IS NOT NULL) DROP FUNCTION ufc_RolesDeUsuarios__VisitanteId
GO
CREATE FUNCTION ufc_RolesDeUsuarios__VisitanteId
	()
	RETURNS INT
	AS
	BEGIN
		RETURN (SELECT id FROM RolesDeUsuarios WHERE Nombre = dbo.ufc_RolesDeUsuarios__Visitante())
	END
GO
-- RolesDeUsuarios /Funciones - Nombre de RolesDeUsuarios/ - FIN
 
 
-- -------------------------
-- Script: DB_ParticularCore__C06b_Funciones - Nombre de RolesDeUsuarios.sql - v10.6 - FIN
-- ==========================================================================================================

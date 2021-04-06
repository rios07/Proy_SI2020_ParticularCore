---- =====================================================
-- Descripción: Constantes
-- Script: DB_ParticularCore__C05__Constantes.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO


IF (OBJECT_ID('ufc_Respuesta__NoTieneElRol') IS NOT NULL) DROP FUNCTION ufc_Respuesta__NoTieneElRol
GO
CREATE FUNCTION ufc_Respuesta__NoTieneElRol
		()
	RETURNS VARCHAR(1000)
	AS
	BEGIN
		RETURN 'No tiene el Rol consultado.'
	END
GO




IF (OBJECT_ID('ufc_Respuesta__NoTienePermiso') IS NOT NULL) DROP FUNCTION ufc_Respuesta__NoTienePermiso
GO
CREATE FUNCTION ufc_Respuesta__NoTienePermiso
		()
	RETURNS VARCHAR(1000)
	AS
	BEGIN
		RETURN 'No tiene permiso para realizar esta acción. Disculpe las molestias.'
	END
GO




IF (OBJECT_ID('ufc_Respuesta__UsuarioNoPerteneceAlContexto') IS NOT NULL) DROP FUNCTION ufc_Respuesta__UsuarioNoPerteneceAlContexto
GO
CREATE FUNCTION ufc_Respuesta__UsuarioNoPerteneceAlContexto
		()
	RETURNS VARCHAR(1000)
	AS
	BEGIN
		RETURN 'No se puede realizar la acción. El Usuario no pertenece al contexto en cuestión.'
	END
GO




IF (OBJECT_ID('ufc_Respuesta__ResultadoDeOperacionDelete') IS NOT NULL) DROP FUNCTION ufc_Respuesta__ResultadoDeOperacionDelete
GO
CREATE FUNCTION ufc_Respuesta__ResultadoDeOperacionDelete
		(
			@RegistrosQueDeberianEliminarse INT
			,@RegistrosAfectados INT
		)
	RETURNS VARCHAR(1000)
	AS
	BEGIN
		DECLARE @sResSQL						VARCHAR(1000)
		
		SET @sResSQL = CASE WHEN @RegistrosQueDeberianEliminarse <> @RegistrosAfectados THEN 'No se pudo concretar la eliminación' ELSE '' END 
		
		RETURN @sResSQL
	END
GO




-- ---------------------------------
-- Script: DB_ParticularCore__C05__Constantes.sql - FIN
-- =====================================================
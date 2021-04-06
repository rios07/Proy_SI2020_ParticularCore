-- =====================================================
-- Descripción: Testing
-- Script: DB_ParticularCore__C23__Informes__Listado.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO

				-- Variable que utilizamos en los insert - INICIO
					DECLARE	@Seccion_Administracion VARCHAR(30)
						,@Seccion_Intranet VARCHAR(30)
						,@Seccion_Web VARCHAR(30)
						,@Seccion_PrivadaDelUsuario VARCHAR(30)
		
					EXEC @Seccion_Administracion = ufc_Secciones__Administracion
					EXEC @Seccion_Intranet = ufc_Secciones__Intranet
					EXEC @Seccion_Web = ufc_Secciones__Web
					EXEC @Seccion_PrivadaDelUsuario = ufc_Secciones__PrivadaDelUsuario
					
					DECLARE @UsuarioQueEjecutaId INT = '4' -- Administrador de Testing
						--@UsuarioQueEjecutaId INT = '2' -- Master admin de Testing
						--@UsuarioQueEjecutaId INT = '10' -- masteradmin de Testing
						,@FechaDeEjecucion DATETIME = GetDate()
						,@Token                     VARCHAR(40) = NULL
						,@Seccion					VARCHAR(30) = @Seccion_Administracion
						,@CodigoDelContexto			VARCHAR(40) = NULL
					 
						,@UsuarioId						INT	= '5' -- Usuario de test
	
						,@sResSQL VARCHAR(1000)
				-- Variable que utilizamos en los insert - FIN


SELECT 'Usuario:'				
SELECT * FROM Usuarios WHERE id = @UsuarioId

SELECT 'Antes:'				
SELECT * FROM RelAsig_RolesDeUsuarios_A_Usuarios WHERE UsuarioId = @UsuarioId

begin tran

EXEC [dbo].usp_RelAsig_RolesDeUsuarios_A_Usuarios__Delete_by_@UsuarioId
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
		,@FechaDeEjecucion = @FechaDeEjecucion
		,@Token = @Token
		,@Seccion = @Seccion
		,@CodigoDelContexto = @CodigoDelContexto
		
		,@UsuarioId = @UsuarioId
		
		,@sResSQL = @sResSQL OUTPUT
		
	SELECT 'Salida:'		
	SELECT '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') --+ ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
	

SELECT 'Despues:'				
SELECT * FROM RelAsig_RolesDeUsuarios_A_Usuarios WHERE UsuarioId = @UsuarioId

ROLLBACK tran

SELECT 'Luego del rollback:'				
SELECT * FROM RelAsig_RolesDeUsuarios_A_Usuarios WHERE UsuarioId = @UsuarioId
GO


-- ---------------------------
-- Script: DB_ParticularCore__C23__Informes__Listado.sql - FIN
-- =====================================================
-- =====================================================
-- Descripción: Testing
-- Script: DB_CPT__C23__Tests__Archivos__Insert.sql - INICIO
-- =====================================================

USE DB_CPT
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
					
					DECLARE @UsuarioQueEjecutaId INT = '1'
						--@UsuarioQueEjecutaId INT = '2' -- Master admin de Testing
						--@UsuarioQueEjecutaId INT = '4' -- Administrador de Testing
						,@FechaDeEjecucion DATETIME = GetDate()
						,@Token                     VARCHAR(40) = NULL
						,@Seccion					VARCHAR(30) = @Seccion_Web
						,@CodigoDelContexto			VARCHAR(40) = 'CPT'
						
						,@sResSQL VARCHAR(1000)
						,@id INT = '3'
				-- Variable que utilizamos en los insert - FIN
				

	EXEC [dbo].usp_Archivos__Insert
			@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
			,@FechaDeEjecucion = @FechaDeEjecucion
			,@Token = @Token
			,@Seccion = @Seccion
			,@CodigoDelContexto = @CodigoDelContexto
			
			,@Tabla = 'Matriculados'
			,@RegistroId = '2257'
			,@NombreFisicoCompleto = 'rtest - copia (17) - copia.txt'
			,@NombreAMostrar = 'DNI: lalalala lalalala - 2020-04-24'
			,@Observaciones	= '-'
		
			,@id = @id OUTPUT
		
			,@sResSQL = @sResSQL OUTPUT
			
	SELECT '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
	
				
-- ---------------------------
-- Script: DB_CPT__C23__Tests__Archivos__Insert.sql - FIN
-- =====================================================
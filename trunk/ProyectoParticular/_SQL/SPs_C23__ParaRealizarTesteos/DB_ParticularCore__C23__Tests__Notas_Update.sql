-- =====================================================
-- Descripción: Testing
-- Script: DB_ParticularCore__C23__Tests_Notas_Update.sql - INICIO
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
					
					DECLARE @UsuarioQueEjecutaId INT = '10'
						--@UsuarioQueEjecutaId INT = '2' -- Master admin de Testing
						--@UsuarioQueEjecutaId INT = '4' -- Administrador de Testing
						,@FechaDeEjecucion DATETIME = GetDate()
						,@Token                     VARCHAR(40) = NULL
						,@Seccion					VARCHAR(30) = @Seccion_intranet
						,@CodigoDelContexto			VARCHAR(40) = null
						
						,@sResSQL VARCHAR(1000)
						,@id INT = '3'
				-- Variable que utilizamos en los insert - FIN
				

	EXEC [dbo].usp_Notas__Update_by_@id
			@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
			,@FechaDeEjecucion = @FechaDeEjecucion
			,@Token = @Token
			,@Seccion = @Seccion
			,@CodigoDelContexto = @CodigoDelContexto
			
			,
			@UsuarioId = '-1',
			@IconoCSSId = '19',
			@Fecha = @FechaDeEjecucion,
			@FechaDeVencimiento = @FechaDeEjecucion,
			@Titulo = 'NOTA TESTEO PARA EDICIÓNsd',
			@Cuerpo = 'CUERPO DE NOTA IRRELEVANTE',
			@CompartirConTodos = '1'
		
			,@id = @id
		
			,@sResSQL = @sResSQL OUTPUT
			
	SELECT '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
	
				
-- ---------------------------
-- Script: DB_ParticularCore__C23__Tests_Notas_Update.sql - FIN
-- =====================================================
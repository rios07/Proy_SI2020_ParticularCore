-- =====================================================
-- Descripción: Testing
-- Script: DB_ParticularCore__C23__Delete Registros.sql - INICIO
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
					
					DECLARE --@UsuarioQueEjecutaId INT = '2' -- Master admin de Testing
						@UsuarioQueEjecutaId INT = '4' -- Administrador de Testing
						,@FechaDeEjecucion DATETIME = GetDate()
						,@Token                     VARCHAR(40) = NULL
						,@Seccion					VARCHAR(30) = @Seccion_Administracion
						,@CodigoDelContexto			VARCHAR(40) = 'Testing'
					 
						,@sResSQL VARCHAR(1000)
						,@id INT
				-- Variable que utilizamos en los insert - FIN
				

	SET LANGUAGE 'SPANISH'
			
	DECLARE @Fecha DATETIME = CAST('21/1/2020' AS DATETIME)
			,@FechaDeVencimiento DATETIME = CAST('23/3/2020' AS DATETIME)
			
	--CORREGIR: EXEC [dbo].usp_Notas__Insert
			@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
			,@FechaDeEjecucion = @FechaDeEjecucion
			,@Token = @Token
			,@Seccion = @Seccion
			,@CodigoDelContexto = @CodigoDelContexto
			
			-- Particulares:
			--,@UsuarioId = 1
			,@IconoCSSId = 1
			,@Fecha = @Fecha
			,@FechaDeVencimiento = @FechaDeVencimiento
			,@Titulo = 'Titulo A'
			,@Cuerpo = 'Cuerpo A'
			,@CompartirConTodos = 1
			
			-- Salida:
			,@sResSQL = @sResSQL OUTPUT
			,@id = @id OUTPUT
		
	SELECT '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
	
				
-- ---------------------------
-- Script: DB_ParticularCore__C23__Delete Registros.sql - FIN
-- =====================================================
-- =====================================================
-- Descripción: Testing
-- Script: DB_ParticularCore__C23__Tests_Permisos Precarga de una pagina.sql - INICIO
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
					
					DECLARE @UsuarioQueEjecutaId INT = '1'
						--@UsuarioQueEjecutaId INT = '2' -- Master admin de Testing
						--@UsuarioQueEjecutaId INT = '4' -- Administrador de Testing
						,@FechaDeEjecucion DATETIME = GetDate()
						,@Token                     VARCHAR(40) = NULL
						,@Seccion					VARCHAR(30) = @Seccion_PrivadaDelUsuario
						,@CodigoDelContexto			VARCHAR(40) = null
						
						,@sResSQL VARCHAR(1000)
						,@id INT = '3'
				-- Variable que utilizamos en los insert - FIN
				

	EXEC [dbo].usp_Paginas__PermisosDePrecargaInicial
			@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
			,@FechaDeEjecucion = @FechaDeEjecucion
			--,@Token = @Token
			,@Seccion = @Seccion
			--,@CodigoDelContexto = @CodigoDelContexto
			
			,@Tabla = 'Usuarios'
			,@FuncionDePagina = 'CambiarPassword'
		
			--,@id = @id
		
			,@sResSQL = @sResSQL OUTPUT
			
	SELECT '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
	
				
-- ---------------------------
-- Script: DB_ParticularCore__C23__Tests_Permisos Precarga de una pagina.sql - FIN
-- =====================================================
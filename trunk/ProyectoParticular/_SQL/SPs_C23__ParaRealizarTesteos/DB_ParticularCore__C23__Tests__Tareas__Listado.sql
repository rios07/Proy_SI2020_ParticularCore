-- =====================================================
-- Descripción: Testing
-- Script: DB_ParticularCore__C23__Tests__Tareas__Listado.sql - INICIO
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
						--@UsuarioQueEjecutaId INT = '4' -- Administrador de Testing
						@UsuarioQueEjecutaId INT = '10'
						,@FechaDeEjecucion DATETIME = GetDate()
						,@Token                     VARCHAR(40) = NULL
						,@Seccion					VARCHAR(30) = @Seccion_Intranet
						,@CodigoDelContexto			VARCHAR(40) = null
						,@OrdenarPor				VARCHAR(50) = ''
						,@Sentido					BIT = '0'
						,@Filtro					VARCHAR(50) = ''
						
						,@RegistrosPorPagina        INT = '-1'
						,@NumeroDePagina            INT = '1'
						,@TotalDeRegistros          INT = '100'
	
						,@sResSQL VARCHAR(1000)
				-- Variable que utilizamos en los insert - FIN

EXEC	[dbo].usp_Tareas__Listado
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId,
		@FechaDeEjecucion = @FechaDeEjecucion,
		@Token = @Token,
		@Seccion = @Seccion,
		@CodigoDelContexto = @CodigoDelContexto,
		
		@OrdenarPor = @OrdenarPor,
		@Sentido = @Sentido,
		@Filtro = @Filtro
		
		,@Activo = null
		
		-- Parametros del SP Particular:
			,@TipoDeTareaId = '-1' -- FiltroDDL (FK)
			,@IdsString_EstadosDeTareas = '-1' --@EstadoDeTareaId			INT = '-1' -- FiltroDDL (FK)
			,@ImportanciaDeTareaId = '-1' -- FiltroDDL (FK)
			,@TablaDelRegistro = ''
			,@FechaInicioDesde = '25/01/2018' -- NULL
			,@FechaInicioHasta = '17/01/2022' -- NULL
			,@FechaLimiteDesde = '17/01/2020' -- NULL
			,@FechaLimiteHasta = '20/01/2022' -- NULL

		,@RegistrosPorPagina = @RegistrosPorPagina,
		@NumeroDePagina = @NumeroDePagina,
		@TotalDeRegistros = @TotalDeRegistros OUTPUT,
		@sResSQL = @sResSQL OUTPUT

SELECT	'sResSQL=' + @sResSQL
GO


-- ---------------------------
-- Script: DB_ParticularCore__C23__Tests__Tareas__Listado.sql - FIN
-- =====================================================
-- =====================================================
-- Descripción: Testing
-- Script: DB_ParticularCore__C23__RelAsig_RolesDeUsuarios_A_Paginas__Listado.sql - INICIO
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
					
					DECLARE @UsuarioQueEjecutaId INT = '2' -- Master admin de Testing
						--@UsuarioQueEjecutaId INT = '4' -- Administrador de Testing
						
						,@FechaDeEjecucion DATETIME = GetDate()
						,@Token                     VARCHAR(40) = NULL
						,@Seccion					VARCHAR(30) = @Seccion_Administracion
						,@CodigoDelContexto			VARCHAR(40) = 'Testing'
					 
						,@OrdenarPor				VARCHAR(50) = ''
						--,@OrdenarPor				VARCHAR(50) = 'AutorizadoA_CargarLaPagina'
						--,@OrdenarPor				VARCHAR(50) = 'AutorizadoA_OperarLaPagina'
						--,@OrdenarPor				VARCHAR(50) = 'AutorizadoA_VerRegAnulados'
						--,@OrdenarPor				VARCHAR(50) = 'AutorizadoA_AccionesEspeciales'
						
						,@Sentido					BIT = '0'
						--,@Sentido					BIT = '1'
						
						,@Filtro					VARCHAR(50) = ''
						
						,@RegistrosPorPagina        INT = '-1'
						,@NumeroDePagina            INT = '1'
						,@TotalDeRegistros          INT = '100'
	
						,@sResSQL VARCHAR(1000)
				-- Variable que utilizamos en los insert - FIN
				

EXEC	[dbo].[usp_RelAsig_RolesDeUsuarios_A_Paginas__Listado]
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId,
		@FechaDeEjecucion = @FechaDeEjecucion,
		@Token = @Token,
		@Seccion = @Seccion,
		@CodigoDelContexto = @CodigoDelContexto,
		
		@OrdenarPor = @OrdenarPor,
		@Sentido = @Sentido,
		@Filtro = @Filtro,
		
		-- Parametros del SP Particular:
		@RolDeUsuarioId =  '-1',
		@PaginaId = '-1',
		@AutorizadoA_CargarLaPagina = NULL,
		@AutorizadoA_OperarLaPagina = NULL,
		@AutorizadoA_VerRegAnulados = NULL,
		@AutorizadoA_AccionesEspeciales = NULL,
		@TablaId = '-1',
		
		@RegistrosPorPagina = @RegistrosPorPagina,
		@NumeroDePagina = @NumeroDePagina,
		@TotalDeRegistros = @TotalDeRegistros OUTPUT,
		@sResSQL = @sResSQL OUTPUT

SELECT	'sResSQL=' + @sResSQL
GO


-- ---------------------------
-- Script: DB_ParticularCore__C23__RelAsig_RolesDeUsuarios_A_Paginas__Listado.sql - FIN
-- =====================================================
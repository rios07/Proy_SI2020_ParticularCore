-- =====================================================
-- Descripción: Testing
-- Script: DB_ParticularCore__C23__Tests_RelAsig_RolesDeUsuarios_A_Paginas__Listado.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO

				-- Variable que utilizamos en los insert - INICIO
					DECLARE @UsuarioQueEjecutaId INT = '4' -- OJO, q si va UsuarioId=1 -- > VA EN ContextoId=1 --> no logueable
						,@FechaDeEjecucion DATETIME = GetDate()
						,@sResSQL VARCHAR(1000)	
						,@id INT
						,@TotalDeRegistros int
				-- Variable que utilizamos en los insert - FIN
				

EXEC	[dbo].[usp_RelAsig_RolesDeUsuarios_A_Paginas__Listado]
		@UsuarioQueEjecutaId = 1,
		@FechaDeEjecucion = N'1/1/2019',
		@Token = N'1',
		@OrdenarPor = N' ',
		@Sentido = 0,
		@Filtro = N'',
		@RolDeUsuarioId = -1,
		@PaginaId = -1,
		@AutorizadoA_CargarLaPagina = NULL,
		@AutorizadoA_OperarLaPagina = NULL,
		@AutorizadoA_VerRegAnulados = NULL,
		@AutorizadoA_AccionesEspeciales = NULL,
		@TablaId = -1,
		@RegistrosPorPagina = 10,
		@NumeroDePagina = 1,
		@TotalDeRegistros = @TotalDeRegistros OUTPUT,
		@sResSQL = @sResSQL OUTPUT

SELECT	
		@sResSQL as N'@sResSQL'
GO


-- ---------------------------
-- Script: DB_ParticularCore__C23__Tests_RelAsig_RolesDeUsuarios_A_Paginas__Listado.sql - FIN
-- =====================================================
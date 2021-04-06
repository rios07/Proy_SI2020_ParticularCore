-- =====================================================
-- Descripción: Testing
-- Script: DB_ParticularCore__C23__Tests_Paginas_Listado.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO


				-- Variable que utilizamos en los insert - INICIO
					DECLARE @UsuarioQueEjecutaId INT = '4' -- OJO, q si va UsuarioId=1 -- > VA EN ContextoId=1 --> no logueable
						,@FechaDeEjecucion DATETIME = GetDate()
						,@sResSQL VARCHAR(1000)	
						,@id INT
				-- Variable que utilizamos en los insert - FIN
				

/****** Script for SelectTopNRows command from SSMS  ******/
USE [DB_ParticularCore]
GO

DECLARE	@return_value int,
		@sResSQL varchar(1000),
		@id int

SELECT	@sResSQL = N'1'
SELECT	@id = 1

EXEC	@return_value = [usp_Paginas__Listado]
		@UsuarioQueEjecutaId = 4,
		@FechaDeEjecucion = N'1/1/2019',
		@OrdenarPor = N'',
		@Sentido = '1',
		@Filtro = N'',
		@SeMuestraEnAsignacionDePermisos = -1,
		@FuncionDePaginaId = -1,
		@TablaId = -1,
		@RegistrosPorPagina = 10,
		@NumeroDePagina = 1,
		@TotalDeRegistros = '10',
		@sResSQL = @sResSQL OUTPUT


-- ---------------------------
-- Script: DB_ParticularCore__C23__Tests_Paginas_Listado.sql - FIN
-- =====================================================
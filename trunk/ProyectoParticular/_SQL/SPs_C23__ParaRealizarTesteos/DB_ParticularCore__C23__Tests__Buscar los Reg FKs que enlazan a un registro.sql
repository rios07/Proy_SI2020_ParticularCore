-- =====================================================
-- Descripción: Testing
-- Script: DB_ParticularCore__C23__Buscar los Reg FKs que enlazan a un registro.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO

DECLARE	@return_value int,
		@sResSQL varchar(1000)

EXEC	@return_value = [dbo].[usp_TablaDinamica__BuscarLosRegFKsQueLaApuntan]
		@UsuarioQueEjecutaId = 4,
		@FechaDeEjecucion = N'1/1/2020',
		@Token = N'A',
		@Seccion = N'Intranet',
		@CodigoDelContexto = N'testing',
		@id = 4,
		@Tabla = N'Usuarios',
		@sResSQL = @sResSQL OUTPUT

SELECT	@sResSQL
GO



-- ---------------------------
-- Script: DB_ParticularCore__C23__Buscar los Reg FKs que enlazan a un registro.sql - FIN
-- =====================================================
-- =====================================================
-- Descripción: Testing
-- Script: DB_ParticularCore__C23__Tests_Swap Orden en Tablas Dinamicas.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO


				-- Variable que utilizamos en los insert - INICIO
					DECLARE @UsuarioQueEjecutaId INT = '4' -- OJO, q si va UsuarioId=1 -- > VA EN ContextoId=1 --> no logueable
						,@FechaDeEjecucion DATETIME = GetDate()
						,@sResSQL VARCHAR(1000)	
						,@id INT
						,@RegistroId1 INT = '2'
						,@RegistroId2 INT = '3'
				-- Variable que utilizamos en los insert - FIN
		
		
SELECT * FROM ImportanciasDeTareas

EXEC	usp_TablaDinamica_SwapOrden
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId,
		@FechaDeEjecucion = @FechaDeEjecucion,
		@Tabla = 'ImportanciasDeTareas',
		@RegistroId1 = @RegistroId1,
		@RegistroId2 = @RegistroId2,
		@sResSQL = @sResSQL OUTPUT

SELECT	@sResSQL

SELECT * FROM ImportanciasDeTareas


-- ---------------------------
-- Script: DB_ParticularCore__C23__Tests_Swap Orden en Tablas Dinamicas.sql - FIN
-- =====================================================
-- =====================================================
-- Descripción: Testing
-- Script: DB_ParticularCore__C23__Tests__Fechas.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO

				declare @FechaDeEjecucion date = getdate()
	,@a as varchar(1000)
DECLARE @FechaComoTexto VARCHAR(30)
			,@Tiempo AS TIME
			
			
exec @a = ufc_Fechas__FormatoFechaComoTexto @FechaYHora = @FechaDeEjecucion

print @a

--PRINT GETDATE()
--SET @Tiempo = GETDATE()

--PRINT @Tiempo
GO


-- ---------------------------
-- Script: DB_ParticularCore__C23__Tests__Fechas.sql - FIN
-- =====================================================
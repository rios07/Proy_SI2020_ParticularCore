-- =====================================================
-- Descripción: Testing
-- Script: DB_ParticularCore__C23__Tests_usp_Usuarios__Update_Campos_Reset_Pass.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO

				-- Variable que utilizamos en los insert - INICIO
					DECLARE @UsuarioQueEjecutaId INT = '2' -- OJO, q si va UsuarioId=1 -- > VA EN ContextoId=1 --> no logueable
						,@FechaDeEjecucion DATETIME = GetDate()
						,@sResSQL VARCHAR(1000)	
						,@id INT = 3
						,@TotalDeRegistros int
				-- Variable que utilizamos en los insert - FIN
		
SELECT	[UserName]
,[Pass]
FROM [DB_ParticularCore].[dbo].[Usuarios]
WHERE id = @id
  		

EXEC	[dbo].[usp_Usuarios__Update_Campos_Reset_Pass]
		@id = @id,
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId,
		@FechaDeEjecucion = N'1/1/2019',
		@Token = N'a',
		@PassNuevo = N'aadfhdf2',
		@sResSQL = @sResSQL OUTPUT

SELECT	
		@sResSQL as N'@sResSQL'
		
SELECT	[UserName]
,[Pass]
FROM [DB_ParticularCore].[dbo].[Usuarios]
WHERE id = @id

GO


-- ---------------------------
-- Script: DB_ParticularCore__C23__Tests_usp_Usuarios__Update_Campos_Reset_Pass.sql - FIN
-- =====================================================
-- =====================================================
-- Descripción: Testing
-- Script: DB_ParticularCore__C23__Tests_Insert Tareas con Notificaciones y EnviosDeCorreos.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO

				-- Variable que utilizamos en los insert - INICIO
					DECLARE @UsuarioQueEjecutaId INT = '4' -- OJO, q si va UsuarioId=1 -- > VA EN ContextoId=1 --> no logueable
						,@FechaDeEjecucion DATETIME = GetDate()
						,@sResSQL VARCHAR(1000)	
						,@id INT
				-- Variable que utilizamos en los insert - FIN
				

-- INSERT VALUES: TiposDeTareas - INICIO
	-- Insertamos un par p/los testeos, luego las carga cada Admin dentro de su contexto.
	EXEC [dbo].[usp_TiposDeTareas__Insert] @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion
		,@Nombre = 'Tipo de Tarea A'
		,@Observaciones	= 'Es para testear. Obs A.'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT 'Tabla TiposDeTareas - id = ' + CAST(@id AS VARCHAR)  -- De la tabla insertada
		
	EXEC [dbo].[usp_TiposDeTareas__Insert] @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion
		,@Nombre = 'Tipo de Tarea B'
		,@Observaciones	= 'Es para testear. Obs B.'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT 'Tabla TiposDeTareas - id = ' + CAST(@id AS VARCHAR)  -- De la tabla insertada
-- INSERT VALUES: TiposDeTareas - FIN


DECLARE	@return_value int,
		@sResSQL varchar(1000),
		@id int

SELECT	@sResSQL = N'1'
SELECT	@id = 1

EXEC	@return_value = [dbo].[usp_Tareas__Insert]
		@UsuarioQueEjecutaId = 2,
		@FechaDeEjecucion = N'1/1/2018',
		@Token = N'nada',
		@UsuarioOriginanteId = 2,
		@UsuarioDestinatarioId = 2,
		@FechaDeInicio =N'10/31/2018',
		@FechaLimite = N'11/11/2018',
		@TipoDeTareaId = 1,
		@EstadoDeTareaId = 1,
		@Titulo = N'Titulo de tarea 14',
		@ImportanciaDeTareaId = 1,
		@TablaDeReferencia = N'Paginas',
		@RegistroId = 1,
		@Observaciones = N'obs de tareas',
		@EnviarCorreo = 1,
		@sResSQL = @sResSQL OUTPUT,
		@id = @id OUTPUT



SELECT TOP 1000 [id]
      ,[ContextoId]
      ,[UsuarioOriginanteId]
      ,[UsuarioDestinatarioId]
      ,[FechaDeInicio]
      ,[FechaLimite]
      ,[Numero]
      ,[TipoDeTareaId]
      ,[EstadoDeTareaId]
      ,[Titulo]
      ,[ImportanciaDeTareaId]
      ,[TablaId]
      ,[RegistroId]
      ,[Observaciones]
      ,[Activo]
  FROM [DB_CPT].[dbo].[Tareas]
  
  SELECT TOP 1000 [id]
      ,[ContextoId]
      ,[Fecha]
      ,[Numero]
      ,[UsuarioDestinatarioId]
      ,[TablaId]
      ,[RegistroId]
      ,[IconoCSSId]
      ,[Cuerpo]
      ,[Leida]
      ,[Activo]
  FROM [DB_CPT].[dbo].[Notificaciones]
  
SELECT TOP 1000 [id]
      ,[UsuarioOriginanteId]
      ,[UsuarioDestinatarioId]
      ,[TablaId]
      ,[RegistroId]
      ,[EmailDeDestino]
      ,[Asunto]
      ,[Contenido]
      ,[FechaPactadaDeEnvio]
  FROM [DB_CPT].[dbo].[EnviosDeCorreos]
  

EXEC	@return_value = [dbo].[usp_EnviosDeCorreos__Pendientes]
		@UsuarioQueEjecutaId = 2,
		@FechaDeEjecucion = N'10/31/2018',
		@sResSQL = @sResSQL OUTPUT
		
		
-- ---------------------------
-- Script: DB_ParticularCore__C23__Tests_Insert Tareas con Notificaciones y EnviosDeCorreos.sql - FIN
-- =====================================================
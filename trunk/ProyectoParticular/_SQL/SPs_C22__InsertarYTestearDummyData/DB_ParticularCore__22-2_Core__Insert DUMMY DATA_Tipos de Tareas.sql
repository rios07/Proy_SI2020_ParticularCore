-- =====================================================
-- Descripción: Creación de las TABLAS
-- Script: 22-2_Core__Insert DUMMY DATA_Usuarios.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO


				-- Variable que utilizamos en los Insert - INICIO
					DECLARE @UsuarioQueEjecutaId INT = '2' -- (ContextoId=2) OJO, q si se utiliza el UsuarioId=1 -- > VA EN ContextoId=1 --> no logueable
						,@FechaDeEjecucion DATETIME = GetDate()
						,@sResSQL VARCHAR(1000)	
						,@id INT
				-- Variable que utilizamos en los Insert - FIN
				

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

	
	

-- ---------------------------
-- Script: 22-2_Core__Insert DUMMY DATA_Usuarios.sql - FIN
-- =====================================================
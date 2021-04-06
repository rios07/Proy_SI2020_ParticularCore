-- =====================================================
-- Descripción: Se incluyen SP "Especiales" que no corresponden a ninguna clasificación.
-- Script: DB_ParticularCore__C10__Especiales.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO

		-- Tablas Involucradas: - INICIO
			-- #TablaDinamica#
			-- Archivos
			-- EnviosDeCorreos
			-- Menu
			-- Secciones
			-- Recursos
			-- ReservasDeRecursos
			-- Tablas
		-- Tablas Involucradas: - FIN
		
		
-- SP-TABLA: #TablaDinamica# /ABMs/ - INICIO
IF (OBJECT_ID('usp_TablaDinamica__BuscarLosRegFKsQueLaApuntan') IS NOT NULL) DROP PROCEDURE usp_TablaDinamica__BuscarLosRegFKsQueLaApuntan
GO
CREATE PROCEDURE usp_TablaDinamica__BuscarLosRegFKsQueLaApuntan
	@UsuarioQueEjecutaId		INT						
	,@FechaDeEjecucion			DATETIME				
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
	
	,@id							INT		
	,@Tabla							VARCHAR(80)
	
	,@sResSQL						VARCHAR(1000)	OUTPUT		
AS
BEGIN TRY
	DECLARE --@Tabla VARCHAR(80) = ''
		@FuncionDePagina VARCHAR(30) = 'Reporte'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	-- En principio, se excluye este SP de verificar permisos. Regisar el VAL de SPs:
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
		, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
		, @RegistroId = @id 
		--, @UsuarioId = @UsuarioId OUTPUT 
		, @sResSQL = @sResSQL OUTPUT

	IF @sResSQL = ''
		BEGIN
			DECLARE @sql NVARCHAR(MAX)
				,@FilasDeLaTabla INT
				,@i INT
				,@TablaConLaFKInteresada VARCHAR(80)
				,@ColumnaFK VARCHAR(255)
				,@Link VARCHAR(255)
				
			CREATE TABLE #Tablas (Indice INT IDENTITY(1,1)
									,TablaConLaFKInteresada VARCHAR(80)
									,ColumnaFK VARCHAR(255)
								)

			INSERT INTO #Tablas (TablaConLaFKInteresada, ColumnaFK)
			SELECT OBJECT_NAME(f.parent_object_id) AS TablaConLaFKInteresada,
							   COL_NAME(fc.parent_object_id,fc.parent_column_id) AS ColumnaFK
							FROM sys.foreign_keys AS f
								INNER JOIN sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id
								INNER JOIN sys.tables t ON t.OBJECT_ID = fc.referenced_object_id
							WHERE OBJECT_NAME (f.referenced_object_id) = @Tabla

			CREATE TABLE #TablaConRegistrosEnFK (Indice INT IDENTITY(1,1)
													,TablaConLaFKInteresada VARCHAR(80)
													,id INT
													,Link VARCHAR(255)
												)
						
			SET @FilasDeLaTabla = (SELECT COUNT(*) FROM #Tablas) -- Ahora lo uso para recorrer tablas
			SET @i = 0 -- Cantidad de Tablas
			WHILE @i < @FilasDeLaTabla 
				BEGIN
						SET @i = @i + 1
						SELECT @TablaConLaFKInteresada = TablaConLaFKInteresada, @ColumnaFK = ColumnaFK FROM #Tablas WHERE (Indice = @i)

						--PRINT @TablaConLaFKInteresada + '   //   Col:' + @ColumnaFK

						SELECT @sql = N'SELECT ''' + @TablaConLaFKInteresada + ''' AS TablaConLaFKInteresada ,'
											+ 'id AS id ,'
											--<a href="http://is40:50002/intranet/Informes/Registro/2" target="_blank">Abrir</a>
											--+ '''x'' AS Link' 
											--+ '''<a href="administracion/' + @TablaConLaFKInteresada + '/Registro/'' + CAST(id AS VARCHAR) + ''" target="_blank">Abrir</a>'' AS Link' 
											+ '''<a href="/administracion/' + @TablaConLaFKInteresada + '/Registro/'' + CAST(id AS VARCHAR) + ''" target="_blank">Abrir ' + @TablaConLaFKInteresada + '/Registro/'' + CAST(id AS VARCHAR) + ''</a>'' AS Link' 
											+ ' FROM ' + @TablaConLaFKInteresada + ' WHERE ' + @ColumnaFK + ' = ' + CAST(@id AS VARCHAR)
											
						PRINT @sql
						
						INSERT INTO #TablaConRegistrosEnFK exec sp_executesql @sql
				END
				
				--PRINT '#TablaConRegistrosEnFK:'
				--SELECT * FROM #TablaConRegistrosEnFK
				
				--PRINT '#Tablas:'
				--SELECT * FROM #Tablas
				
				SET @FilasDeLaTabla = (SELECT COUNT(*) FROM #TablaConRegistrosEnFK) -- Ahora lo uso para recorrer #TablaConRegistrosEnFK
				SET @i = 0 -- Cantidad de Filas
				IF @FilasDeLaTabla > 0 
					WHILE @i <= @FilasDeLaTabla
						BEGIN
							SET @i = @i + 1
							SET @Link = (SELECT Link FROM #TablaConRegistrosEnFK WHERE Indice = @i)
							
							IF @Link IS NOT NULL -- Ya que se insertaron nulos en la tabla temporal cuando no existía ningún registro.
								BEGIN
									SET @sResSQL = @sResSQL + ' - ' + @Link
								END
						END
				
				DROP TABLE #TablaConRegistrosEnFK
				DROP TABLE #Tablas
				
				IF @sResSQL <> ''
					BEGIN
						SET @sResSQL = 'El registro no puede ser eliminado, ya que otros registros lo "enlazan": ' + @sResSQL
					END
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			, @RegistroId = @id 
 			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO




IF (OBJECT_ID('usp_TablaDinamica__DeleteOActivo_by_@id') IS NOT NULL) DROP PROCEDURE usp_TablaDinamica__DeleteOActivo_by_@id
GO
CREATE PROCEDURE usp_TablaDinamica__DeleteOActivo_by_@id
	@UsuarioQueEjecutaId		INT						
	,@FechaDeEjecucion			DATETIME				
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
	
	,@id							INT		
	,@Tabla							VARCHAR(80)
	
	,@sResSQL						VARCHAR(1000)	OUTPUT		
AS
BEGIN TRY
	DECLARE --@Tabla VARCHAR(80) = ''
	-- El permiso de "Eliminar" o "Activar/Anular" un registro se define por el bit AutorizadoA_OperarLaPagina de la pagina "Registro".
		@FuncionDePagina VARCHAR(30) = 'Registro'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
		, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
		, @RegistroId = @id 
		--, @UsuarioId = @UsuarioId OUTPUT 
		, @sResSQL = @sResSQL OUTPUT

	IF @sResSQL = ''
		BEGIN
			DECLARE @LlevaActivo BIT = '0' -- Por defecto no dejamos nada.
				,@PermiteEliminarSusRegistros BIT = '0' -- Por defecto no dejamos nada.
				,@sSQL NVARCHAR(1000)
				,@Parametros NVARCHAR(1000)
				,@RegistrosAfectados INT -- POR EXCEPCION LAS DECLARAMOS ACÁ, POR Q LUEGO VAN EN DISTINTOS begin-end, y SE PIERDE EL VALOR
				,@NumeroDeError INT -- POR EXCEPCION LAS DECLARAMOS ACÁ, POR Q LUEGO VAN EN DISTINTOS begin-end, y SE PIERDE EL VALOR
				
			SET @LlevaActivo = CASE WHEN COL_LENGTH(@Tabla, 'Activo') IS NOT NULL THEN '1' ELSE '0' END
					
			IF @LlevaActivo = '0' -- Miro si deja eliminar. Si @LlevaActivo = '1' --> @PermiteEliminarSusRegistros = '0'. 
				BEGIN
					EXEC @PermiteEliminarSusRegistros = usp_VAL_Tablas__PermiteEliminarSusRegistros @Tabla = @Tabla
				END
			
				
			IF (@PermiteEliminarSusRegistros = '0' AND @LlevaActivo = '0') --> ESTA TABLA NO PERMITE NI ELIMINAR NI ANULAR.
				BEGIN
					SET @sResSQL = 'Se produjo un error. Esta tabla no permite la acción indicada.'
				END
				
				
			IF @sResSQL = ''
				BEGIN
					IF @PermiteEliminarSusRegistros = '1' --> Es una operación de eliminar
						BEGIN
							SET NOCOUNT ON
							
							EXEC usp_TablaDinamica__BuscarLosRegFKsQueLaApuntan  
									@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
									, @FechaDeEjecucion = @FechaDeEjecucion
									, @Token = @Token
									, @Seccion = @Seccion
									, @CodigoDelContexto = @CodigoDelContexto
									, @id = @id	
									, @Tabla = @Tabla 
									, @sResSQL = @sResSQL OUTPUT
							
							IF @sResSQL = '' --> Eliminamos el registro:
								BEGIN
									SET @Parametros = N'@id INT'
									SELECT @sSQL = N'DELETE FROM ' + QUOTENAME(@Tabla) + ' WHERE id = @id'
									EXEC  sp_executesql @sSQL, @Parametros, @id = @id
									
									SELECT @RegistrosAfectados = @@ROWCOUNT, @NumeroDeError = @@ERROR -- POR EXCEPCION LAS DECLARAMOS ACÁ, POR Q LUEGO VAN EN DISTINTOS begin-end, y SE PIERDE EL VALOR
									
									SET @FuncionDePagina = 'Delete' -- ESTO LO UTILIZA AL FINAL PARA EL LogRegistros
									
									IF @RegistrosAfectados = '1' -- Si efectivamente se eliminó el registro:
										BEGIN -- Elimino sus archivos:
											DELETE Archivos FROM Archivos WHERE TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND RegistroId = @id
										END
								END
						END
					ELSE --> Es una operación de Activo/Anulo
						BEGIN
							SET NOCOUNT ON
							
							DECLARE @Activo BIT				
							SET @Parametros = N'@id INT, @Activo BIT OUTPUT'
							SELECT @sSQL = N' SELECT @Activo = Activo FROM ' + QUOTENAME(@Tabla) + ' WHERE id = @id'
							EXEC  sp_executesql @sSQL, @Parametros, @id = @id, @Activo = @Activo OUTPUT
							
							--PRINT '@id = ' + CAST(@id as varchar) + ' // @Activo = ' + CAST(@Activo as varchar)
							
							SET @Parametros = N'@id INT'
							SELECT @sSQL = N' UPDATE ' + QUOTENAME(@Tabla) + ' SET Activo = 1 ^ Activo FROM ' + QUOTENAME(@Tabla) + ' WHERE id = @id'
							EXEC  sp_executesql @sSQL, @Parametros, @id = @id
					 
							SELECT @RegistrosAfectados = @@ROWCOUNT, @NumeroDeError = @@ERROR -- POR EXCEPCION LAS DECLARAMOS ACÁ, POR Q LUEGO VAN EN DISTINTOS begin-end, y SE PIERDE EL VALOR
							
							-- ESTO LO UTILIZA AL FINAL PARA EL LogRegistros
							SET @FuncionDePagina =	(
								CASE WHEN @Activo = 1 THEN 'Anular' -- Estaba Activo
								WHEN @Activo = 0 THEN 'Activar' -- Estaba Anulado
								ELSE 'ERROR' END -- Activo = NULL
							)
							--PRINT '@FuncionDePagina = ' + @FuncionDePagina
						END
				END
				
			IF @sResSQL = ''
				BEGIN
					-- Revisamos el resultado, si OK --> registra el LogRegistros, si falla --> Resgistra el LogError y devuelve el mensaje correcto.
					-- OJO CONTROL PARTICULAR, CON @RegistrosAfectados Y @NumeroDeError distinto al estandar:
					EXEC usp_ControlYLogRegistros__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
							, @Tabla = @Tabla , @RegistroId = @id, @FuncionDePagina = @FuncionDePagina, @SP = @SP
							, @RegistrosAfectados = @RegistrosAfectados -- <-- Particular
							, @NumeroDeError = @NumeroDeError -- <-- Particular
							, @sResSQL = @sResSQL OUTPUT
				END
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			, @RegistroId = @id 
 			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO




IF (OBJECT_ID('usp_TablaDinamica__SwapOrden') IS NOT NULL) DROP PROCEDURE usp_TablaDinamica__SwapOrden
GO
CREATE PROCEDURE usp_TablaDinamica__SwapOrden
	@UsuarioQueEjecutaId		INT						
	,@FechaDeEjecucion			DATETIME				
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
	
	,@Tabla							VARCHAR(80) -- Es la Tabla de "referencia" del Registro; EJ: "Informes"
	,@RegistroId1					INT
	,@RegistroId2					INT
	
	,@sResSQL						VARCHAR(1000)	OUTPUT		
AS
BEGIN TRY
BEGIN TRAN -- El Try va primero, si no, luego recibimos errores del tipo "The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION"
	DECLARE --@Tabla VARCHAR(80) = 'TablaDinamica' Comentada por que es un parámetro que pasa
		@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	-- Las validaciones siguientes no las hacemos, ya que luego adentro de cada EXEC, validará.
	
	--DECLARE @id INT = @RegistroId1
	--EXEC usp_VAL_Contextos__UsuarioPerteneceAlDelRegistro  @UsuarioId = @UsuarioQueEjecutaId, @Tabla = @Tabla, @RegistroId = @id, @sResSQL = @sResSQL OUTPUT
	
	---- Ahora revisamos que también tiene permiso contra el 2do registro (puede estar anulado)
	--SET @id = @RegistroId2
	--IF @sResSQL = ''
	--	BEGIN
	--		EXEC usp_VAL_Contextos__UsuarioPerteneceAlDelRegistro  @UsuarioId = @UsuarioQueEjecutaId, @Tabla = @Tabla, @RegistroId = @id, @sResSQL = @sResSQL OUTPUT
	--	END
		
	--IF @sResSQL = ''  -- VERIFICO SI TIENE PERMISO P ESTA ACCIÓN
	--	BEGIN
	--		EXEC usp_Permisos__AutorizadoA  @UsuarioId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Seccion = @Seccion, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @sResSQL = @sResSQL OUTPUT
	--	END
	
	SET @sResSQL = ''
	IF @sResSQL = ''
		BEGIN
			DECLARE @TablaId INT
				,@ValorDeOrden1 INT
				,@ValorDeOrden2 INT
				,@ContextoId1 INT
				,@ContextoId2 INT
				,@Parametros NVARCHAR(1000)
				,@sSQL NVARCHAR(1000)
				
			SET @TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla)
			
			-- 1ero controlamos que si la tabla tiene ContextoId --> que sea el mismo para ambos registros
			IF COL_LENGTH(@Tabla, 'ContextoId') IS NOT NULL -- La tabla tiene ContextoId.
				BEGIN
					SET @Parametros = N'@ValorDeOrden1 INT OUTPUT, @ContextoId1 INT OUTPUT'
					SET @sSQL = N'SELECT @ValorDeOrden1 = Orden, @ContextoId1 = ContextoId FROM ' + @Tabla + ' WHERE id = ' + CAST(@RegistroId1 AS VARCHAR(MAX))
					--PRINT @sSQL
					EXEC  sp_executesql @sSQL, @Parametros, @ValorDeOrden1 = @ValorDeOrden1 OUTPUT, @ContextoId1 = @ContextoId1 OUTPUT
					
					SET @Parametros = N'@ValorDeOrden2 INT OUTPUT, @ContextoId2 INT OUTPUT'
					SET @sSQL = N'SELECT @ValorDeOrden2 = Orden, @ContextoId2 = ContextoId FROM ' + @Tabla + ' WHERE id = ' + CAST(@RegistroId2 AS VARCHAR(MAX))
					--PRINT @sSQL
					EXEC  sp_executesql @sSQL, @Parametros, @ValorDeOrden2 = @ValorDeOrden2 OUTPUT, @ContextoId2 = @ContextoId2 OUTPUT
					
					IF @ContextoId1 <> @ContextoId2
						BEGIN
							SET @sResSQL = 'La acción no puede realizarse por que los registros no pertenecen al mismo contexto.'
						END
				END
			ELSE
				BEGIN
					SET @Parametros = N'@ValorDeOrden1 INT OUTPUT'
					SET @sSQL = N'SELECT @ValorDeOrden1 = Orden FROM ' + @Tabla + ' WHERE id = ' + CAST(@RegistroId1 AS VARCHAR(MAX))
					--PRINT @sSQL
					EXEC  sp_executesql @sSQL, @Parametros, @ValorDeOrden1 = @ValorDeOrden1 OUTPUT
					
					SET @Parametros = N'@ValorDeOrden2 INT OUTPUT'
					SET @sSQL = N'SELECT @ValorDeOrden2 = Orden FROM ' + @Tabla + ' WHERE id = ' + CAST(@RegistroId2 AS VARCHAR(MAX))
					--PRINT @sSQL
					EXEC  sp_executesql @sSQL, @Parametros, @ValorDeOrden2 = @ValorDeOrden2 OUTPUT
				END
		END
	
	IF @sResSQL = ''
		BEGIN -- 1ero "liberamos" el Orden del registro 2
			EXEC usp_TablaDinamica__Update_@Campo_by_@id  
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					,@FechaDeEjecucion = @FechaDeEjecucion
					,@Token = @Token
					,@Seccion = @Seccion
					,@CodigoDelContexto = @CodigoDelContexto
					,@Tabla = @Tabla
					,@id = @RegistroId2
					,@Campo = 'Orden'
					,@ValorDelCampo = '-999999' -- Inicialmente ponemos un Orden cualquiera, para liberar el Orden, ya que no se puede repetir por UQ.
					,@sResSQL = @sResSQL OUTPUT	
		END
		
	IF @sResSQL = ''
		BEGIN -- 2do, Seteamos el Orden del Registro 1 con el Orden del Registro 2
			EXEC usp_TablaDinamica__Update_@Campo_by_@id  
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					,@FechaDeEjecucion = @FechaDeEjecucion
					,@Token = @Token
					,@Seccion = @Seccion
					,@CodigoDelContexto = @CodigoDelContexto
					,@Tabla = @Tabla
					,@id = @RegistroId1
					,@Campo = 'Orden'
					,@ValorDelCampo = @ValorDeOrden2
					,@sResSQL = @sResSQL OUTPUT
		END
	
	IF @sResSQL = ''
		BEGIN -- 3ero, Seteamos el Orden del Registro 2 con el Orden del Registro 1
			EXEC usp_TablaDinamica__Update_@Campo_by_@id  
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					,@FechaDeEjecucion = @FechaDeEjecucion
					,@Token = @Token
					,@Seccion = @Seccion
					,@CodigoDelContexto = @CodigoDelContexto
					,@Tabla = @Tabla
					,@id = @RegistroId2
					,@Campo = 'Orden'
					,@ValorDelCampo = @ValorDeOrden1
					,@sResSQL = @sResSQL OUTPUT	
		END
		
	IF @sResSQL = ''
		BEGIN
			COMMIT TRAN
		END
	ELSE
		BEGIN
			SET @sResSQL = COALESCE(@sResSQL, '-NULL-')
			RAISERROR (@sResSQL, 16, 1) --> ROLLBACK TRAN //RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState) // De esta forma, se hace el ROLLBACK, pero queda registrado el error en LogErrores.
		END		
END TRY
BEGIN CATCH
	ROLLBACK TRAN
	
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id 
 			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO




IF (OBJECT_ID('usp_TablaDinamica__Update_@Campo_by_@id') IS NOT NULL) DROP PROCEDURE usp_TablaDinamica__Update_@Campo_by_@id
GO
CREATE PROCEDURE usp_TablaDinamica__Update_@Campo_by_@id
		-- Validaciones:
			-- 1) 
		-------------
		-- Acotaciones:
			-- 1) Se puede realizar la acción con un usuario con permiso, o de forma "Anónima" cuando cumple con los requisitos para este caso.
		------------- 
	@UsuarioQueEjecutaId		INT						
	,@FechaDeEjecucion			DATETIME				
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@id							INT		
	,@Tabla							VARCHAR(80)
	,@Campo							VARCHAR(80) 
	,@ValorDelCampo					VARCHAR(MAX)
	
	,@sResSQL						VARCHAR(1000)	OUTPUT		
AS
BEGIN TRY
	DECLARE --@Tabla VARCHAR(80) = ''
		@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
		, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
		, @RegistroId = @id 
		--, @UsuarioId = @UsuarioId OUTPUT 
		, @sResSQL = @sResSQL OUTPUT

	IF @sResSQL = ''
		BEGIN
			IF COL_LENGTH(@Tabla, @Campo) IS NOT NULL  -- o sea, si la tabla tiene el campo: @Campo
				BEGIN
					--DECLARE @Parametros NVARCHAR(1000) = N'@ValorDelCampo VARCHAR(MAX)'
					--DECLARE @sSQL NVARCHAR(1000) = N'UPDATE ' + @Tabla + ' SET ' + @Campo + ' = @ValorDelCampo FROM ' + @Tabla + ' WHERE id = ' + @id
					----PRINT @sSQL
					--EXEC  sp_executesql @sSQL, @Parametros, @ValorDelCampo = @ValorDelCampo
					
					--DECLARE @TipoDeDato VARCHAR(100)
					--SELECT @Campo = column_name, @TipoDeDato = DATA_TYPE FROM Information_schema.Columns WHERE TABLE_NAME = @Tabla
					
					DECLARE @sSQL NVARCHAR(1000) = N'UPDATE ' + @Tabla + ' SET ' + @Campo + ' = ' + @ValorDelCampo + ' FROM ' + @Tabla + ' WHERE id = ' + CAST(@id AS VARCHAR(MAX)) 
					--PRINT @sSQL
					EXEC  sp_executesql @sSQL
					
					---- Revisamos el resultado, si OK --> registra el LogRegistros, si falla --> Resgistra el LogError y devuelve el mensaje correcto.
					--EXEC usp_ControlYLogRegistros__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
					--		, @Tabla = @Tabla , @RegistroId = @id, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @RegistrosAfectados = @@ROWCOUNT
					--		, @NumeroDeError = @@ERROR, @sResSQL = @sResSQL OUTPUT
				END
			ELSE
				BEGIN
					SET @sResSQL = 'La actualización no puede realizarse. No existe el campo "' + @Campo + '" en la tabla "' + @Tabla + '".'
				END
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			, @RegistroId = @id 
 			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: #TablaDinamica# /ABMs/ - FIN




-- SP-TABLA: Archivos /Especiales/ - INICIO
IF (OBJECT_ID('usp_Archivos__DevolverId') IS NOT NULL) DROP PROCEDURE usp_Archivos__DevolverId
GO
CREATE PROCEDURE usp_Archivos__DevolverId
		-- Validaciones:
			-- 1) 
		-------------
		-- Acotaciones:
			-- 1) Revisa si existe alguno igual, que romopa las constraints. Si no hay --> devuelve sResSQL=''
		------------- 
	@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@Tabla								VARCHAR(80)
	,@RegistroId						INT
	,@NombreFisicoCompleto				VARCHAR(100) -- En este caso es el "nombre original con extensión", que no será el definitivo q se almacena.
	,@NombreAMostrar					VARCHAR(100)
	
	,@Observaciones						VARCHAR(1000)
	
	,@sResSQL							VARCHAR(1000)	OUTPUT
	,@id								INT		OUTPUT
AS
BEGIN TRY
	DECLARE --@Tabla VARCHAR(80) = 'Archivos' Comentada por que es un parámetro que pasa, pero luego de las linas de testeo de permisos la seteamos = 'Archivos' para mantener compatibilidad.
		@FuncionDePagina VARCHAR(30) = 'Registro'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	---- La validación siguiente no se hace contra la tabla 'Archivos' sinó contra la del registro relacionado, que pertenece a la tabla @Tabla
	--EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
	--		, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
	--		, @RegistroId = @id 
	--		--, @UsuarioId = @UsuarioId OUTPUT 
	--		, @sResSQL = @sResSQL OUTPUT
	
	DECLARE @TablaDelArchivo VARCHAR(80) = @Tabla -- En @TablaDelArchivo guardo la tabla del registro, ya que unas lineas más adelante seteo a @Tabla = 'Archivo' para compatibilidad de funcionalidades
	SET @Tabla = 'Archivos' -- Hago esto para mantener compatibilidad con las funciones genericas q se utilizan a continuación con @Tabla.
	
	SET @sResSQL = ''
	
	IF @sResSQL = ''
		BEGIN
			DECLARE @TablaId INT = (SELECT id FROM Tablas WHERE Nombre = @TablaDelArchivo)
				
			SET @id = NULL --LO LIMPIO.
			
			
			-- No queremos llenar el sResSQL por que lo toma como error y rompe:	
			--SET @id = (SELECT id FROM Archivos WHERE NombreFisicoCompleto = @NombreFisicoCompleto
			--									AND TablaId = TablaId
			--									AND RegistroId = @RegistroId
			--			)
			
			--IF @id IS NOT NULL
			--	BEGIN
			--		SET @sResSQL = 'Ya existe un archivo de este registro con el mismo "nombre físico completo"'
			--	END
			
			--IF @sResSQL = ''
			--	BEGIN
			--		SET @id = (SELECT id FROM Archivos WHERE NombreAMostrar = @NombreAMostrar
			--									AND TablaId = TablaId
			--									AND RegistroId = @RegistroId
			--					)
								
			--		IF @id IS NOT NULL
			--			BEGIN
			--				SET @sResSQL = 'Ya existe un archivo de este registro con el mismo "nombre a mostrar"'
			--			END
			--	END
				
				
			SET @id = (SELECT id FROM Archivos WHERE (NombreFisicoCompleto = @NombreFisicoCompleto
														OR NombreAMostrar = @NombreAMostrar
														)
														AND TablaId = TablaId
														AND RegistroId = @RegistroId
						)
			
			-- SALE EL id. Con eso ya sabe si es NOT NULL que existe.
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			, @RegistroId = @id 
 			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: Archivos /Especiales/ - FIN




-- SP-TABLA: EnviosDeCorreos /Especiales/ - INICIO
IF (OBJECT_ID('usp_EnviosDeCorreos__Pendientes') IS NOT NULL) DROP PROCEDURE usp_EnviosDeCorreos__Pendientes
GO
CREATE PROCEDURE usp_EnviosDeCorreos__Pendientes
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- Para q el listado devuelva los pendientes tiene q existir cuenta de envio de correo que esté relacionada con esa tabla de envío.
	 -------------
		@UsuarioQueEjecutaId       INT
		,@FechaDeEjecucion          DATETIME
		,@Token                     VARCHAR(40)
		,@Seccion					VARCHAR(30)
		,@CodigoDelContexto			VARCHAR(40)
		
		,@sResSQL					VARCHAR(1000)	OUTPUT
    AS
	BEGIN TRY
		DECLARE @Tabla VARCHAR(80) = 'EnviosDeCorreos'
			,@FuncionDePagina VARCHAR(30) = 'Pendientes'
			,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
			,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
		
		EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
				--, @RegistroId = @id 
				--, @UsuarioId = @UsuarioId OUTPUT 
				, @sResSQL = @sResSQL OUTPUT
		
		IF @sResSQL = ''
			BEGIN
				--DECLARE @ContextoId	INT
				--EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				
				SELECT * INTO #TempTable
				FROM
				(
					SELECT EDC.id
						,EDC.EmailDeDestino AS EnvioHacia_Emails
						,CDE.CuentaDeEmail AS EnvioDesde_Email
						,CDE.PwdDeEmail AS EnvioDesde_Pwd
						,CDE.Smtp AS EnvioDesde_Smtp
						,CDE.Puerto AS EnvioDesde_Puerto
						,EDC.Asunto
						,EDC.Contenido
					FROM EnviosDeCorreos EDC
						--LEFT JOIN LogEnviosDeCorreos LEC ON LEC.EnvioDeCorreoId = EDC.id
						INNER JOIN Tablas T ON EDC.TablaId = T.id
						INNER JOIN RelAsig_CuentasDeEnvios_A_Tablas RACAT ON RACAT.TablaId = T.id
						INNER JOIN CuentasDeEnvios CDE ON CDE.id = RACAT.CuentaDeEnvioId
						--INNER JOIN Usuarios UD ON EDC.UsuarioDestinatarioId = UD.id
					WHERE
						--(LEC.Satisfactorio = 0)
						--AND 
						(EDC.FechaPactadaDeEnvio < @FechaDeEjecucion)
						
						AND EDC.Activo = '1' -- Si están = '0' --> No los enviamos (Están "pausados").
						
						AND (DATEDIFF(DAY, EDC.FechaPactadaDeEnvio, @FechaDeEjecucion) < 31)
						
						AND EDC.id NOT IN
							(
								SELECT EnvioDeCorreoId 
								FROM LogEnviosDeCorreos
								WHERE Satisfactorio = 1
							)
						AND NOT EXISTS
							(
								SELECT LEC2.id 
								FROM LogEnviosDeCorreos LEC2
								WHERE LEC2.EnvioDeCorreoId = EDC.id
									AND (LEC2.Satisfactorio = 1)
							) -- No existe log de envío exitoso
						AND (
								(SELECT COUNT(id) 
									FROM LogEnviosDeCorreos LEC3 
									WHERE LEC3.EnvioDeCorreoId = EDC.id
										AND (LEC3.Satisfactorio = 0)
										) IS NULL -- No existe Log de Envios Fallidos
								OR 
								(SELECT COUNT(id) 
									FROM LogEnviosDeCorreos LEC3 
									WHERE LEC3.EnvioDeCorreoId = EDC.id
										AND (LEC3.Satisfactorio = 0)
										) < 5 -- Si ya se intentó enviarla al menos 5 veces y falló --> no lo intento más.
							)
							
							
							
							
							-- Probando:
						--AND EXISTS	(SELECT COUNT(LEDC3.id), EDC.id
						--	FROM EnviosDeCorreos EDC
						--		INNER JOIN LogEnviosDeCorreos LEDC3 ON LEDC3.EnvioDeCorreoId = EDC.id
						--	GROUP BY EDC.id
						--	HAVING COUNT(LEDC3.id) < 5)
							

						--	SELECT Employees.LastName, COUNT(Orders.OrderID) AS NumberOfOrders
						--	FROM Orders
						--	INNER JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID
						--	WHERE LastName = 'Davolio' OR LastName = 'Fuller'
						--	GROUP BY LastName
						--	HAVING COUNT(Orders.OrderID) > 25;

				) Query
				
				SELECT	*
				FROM  #TempTable
				--WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				--	OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
			
				--SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
				DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id 
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: EnviosDeCorreos /Especiales/ - FIN




-- SP-TABLA: #Menu# /Especiales/ - INICIO
IF (OBJECT_ID('usp_Menu__Listado') IS NOT NULL) DROP PROCEDURE usp_Menu__Listado
GO
CREATE PROCEDURE usp_Menu__Listado
AS	
	BEGIN				
		SELECT --P.id
			--,P.SeccionId
			--,P.TablaId
			--,P.FuncionDePaginaId
			--,P.Nombre
			--,P.Titulo
			--,P.Tips
			--,P.SeMuestraEnAsignacionDePermisos
			CASE WHEN P.SeMuestraEnAsignacionDePermisos = '0' AND Secc.Nombre <> 'PrivadaDelUsuario' THEN 'MasterAdmin' ELSE CAST(Secc.Nombre AS VARCHAR(MAX)) END AS Seccion
			--,Secc.Nombre
			,CAST(T.Nombre AS VARCHAR(MAX)) AS Tabla
			,FDP.Nombre AS FuncionDePagina
		FROM Paginas AS P
			INNER JOIN FuncionesDePaginas FDP ON FDP.id = P.FuncionDePaginaId
			INNER JOIN Secciones Secc ON Secc.id = P.SeccionId
			INNER JOIN Tablas T ON T.id = P.TablaId
		WHERE
			CHARINDEX('RelAsig', P.Nombre ) = 0
			AND CHARINDEX('Actores', P.Nombre ) = 0
			AND CHARINDEX('Archivos', P.Nombre ) = 0
			AND CHARINDEX('XXXXXX', P.Nombre ) = 0
			AND CHARINDEX('XXXXXX', P.Nombre ) = 0
			AND CHARINDEX('XXXXXX', P.Nombre ) = 0
			AND CHARINDEX('XXXXXX', P.Nombre ) = 0
			AND CHARINDEX('XXXXXX', P.Nombre ) = 0
			AND CHARINDEX('XXXXXX', P.Nombre ) = 0
		--	(P.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
		--	--AND (P.SeMuestraEnAsignacionDePermisos = @SeMuestraEnAsignacionDePermisos OR @SeMuestraEnAsignacionDePermisos IS NULL)
		--	--AND (P.FuncionDePaginaId = @FuncionDePaginaId OR @FuncionDePaginaId = '-1') -- FiltroDDL (FK)
		--GROUP BY T.Nombre, Secc.Nombre,  P.SeMuestraEnAsignacionDePermisos, FDP.Nombre
		ORDER BY Seccion, T.Nombre, FDP.Nombre
	END
GO
-- SP-TABLA: #Menu# /Especiales/ - FIN
		
		
		
		
-- SP-TABLA: Secciones /Especiales/ - INICIO
IF (OBJECT_ID('usp_Secciones__SeccionCorrespondiente') IS NOT NULL) DROP PROCEDURE usp_Secciones__SeccionCorrespondiente
GO
CREATE PROCEDURE usp_Secciones__SeccionCorrespondiente
	-- Validaciones:
		--
	-------------
	-- Acotaciones:
		-- Devolverá la Seccion Que le corresponda a la "Página" indicada por @Tabla y la Función de Página correspondiente al Registro (Que es donde linkeará la notificación).
	-------------
	(
		@Tabla	VARCHAR(80)
	)
AS	
	BEGIN				
		SELECT Nombre FROM Secciones WHERE id = dbo.ufc_Secciones__SeccionIdCorrespondiente(@Tabla)
	END
GO
-- SP-TABLA: Secciones /Especiales/ - FIN




-- SP-TABLA: Recursos /Especiales/ - INICIO
IF (OBJECT_ID('usp_Recursos__EsResponsableDelRecurso') IS NOT NULL) DROP PROCEDURE usp_Recursos__EsResponsableDelRecurso
GO
CREATE PROCEDURE usp_Recursos__EsResponsableDelRecurso
	-- Validaciones:
		-- 1) Valida que el usuario puede aprobar la reserva del recurso indicado.
	-------------
	-- Acotaciones:
		-- El chequeo se realiza verificando que exista el registro en la tabla: RelAsig_Usuarios_A_Recursos (Para el UsuarioId y RecursoId (del ContextoId del UsuarioId).
	-------------
	 @UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
 
	,@RecursoId												   INT
		
	,@sResSQL                                                  VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Recursos'
		,@FuncionDePagina VARCHAR(30) = 'Registro'
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	-- En principio, se excluye este SP de verificar permisos. Regisar el VAL de SPs:
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
		, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
		--, @RegistroId = @id 
		--, @UsuarioId = @UsuarioId OUTPUT 
		, @sResSQL = @sResSQL OUTPUT

	IF @sResSQL = ''
		BEGIN
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
		 			
			-- Validación de que exista el registro en la tabla: RelAsig_Usuarios_A_Recursos (Para el UsuarioId y RecursoId (del ContextoId del UsuarioId).
			IF (SELECT REL.id FROM RelAsig_Usuarios_A_Recursos REL 
								INNER JOIN Recursos REC ON REC.id = REL.RecursoId
							WHERE (REL.UsuarioId = @UsuarioQueEjecutaId) AND (REL.RecursoId = @RecursoId)
								AND (REC.Contextoid = @ContextoId)
				) IS NOT NULL
				BEGIN
					SET @sResSQL = ''
				END	
			ELSE
				BEGIN
					SET @sResSQL = 'No se puede contretar la acción. No tiene permiso de reservar el recurso indicado.'
				END
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id 
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: Recursos /Especiales/ - FIN



 
-- SP-TABLA: ReservasDeRecursos /Especiales/ - INICIO
IF (OBJECT_ID('usp_ReservasDeRecursos__RecursoDisponible') IS NOT NULL) DROP PROCEDURE usp_ReservasDeRecursos__RecursoDisponible
GO
CREATE PROCEDURE usp_ReservasDeRecursos__RecursoDisponible
	-- Validaciones:
		-- 1) Validación de que ese período está libre @FechaDeInicio < FechaLimite AND @FechaLimite > FechaDeInicio (Pisa una reserva en el final de la misma). 
	-------------
	-- Acotaciones:
		-- El chequeo se realiza contra un RecursoId del ContextoId del Usuario, con ReservaAprobada = '1'.
		-- Se pide @id para no tomarlo en cuenta si es un update de reserva del mismo RecursoId.
	-------------
	 @UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
 
	,@id													   INT = '0' -- De la reserva
	,@RecursoId												   INT
	,@FechaDeInicio											   DATETIME
	,@FechaLimite										       DATETIME
		
	,@sResSQL                                                  VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'ReservasDeRecursos'
		,@FuncionDePagina VARCHAR(30) = 'Registro'
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
		
	-- NO VALIDAMOS NADA: 
	
	DECLARE @ContextoId	INT
	EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 			
	-- Validación de que ese período está libre @FechaDeInicio < FechaLimite AND @FechaLimite > FechaDeInicio (Pisa una reserva en el final de la misma)
	IF (SELECT id FROM ReservasDeRecursos WHERE (@FechaDeInicio < FechaLimite AND @FechaLimite > FechaDeInicio) 
												AND (Contextoid = @ContextoId)
												AND (RecursoId = @RecursoId)
												AND (ReservaAprobada = '1')
												AND (id <> @id)
		) IS NOT NULL
		BEGIN
			SET @sResSQL = 'No se puede contretar la acción. El período elegido no está libre.'
		END	
	ELSE
		BEGIN
			SET @sResSQL = ''
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			, @RegistroId = @id 
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: ReservasDeRecursos /Especiales/ - FIN
		
		
		
		
-- SP-TABLA: Tablas /Especiales/ - INICIO
IF (OBJECT_ID('usp_Tablas__ListadoParaDesarrollo') IS NOT NULL) DROP PROCEDURE usp_Tablas__ListadoParaDesarrollo
GO
CREATE PROCEDURE usp_Tablas__ListadoParaDesarrollo

	@Activo		BIT = NULL 
	,@TablaDeCore BIT = NULL 
	,@TieneArchivos BIT = NULL 
AS	
	BEGIN				
		SELECT T.Nombre
			,T.NombreAMostrar
			,CASE WHEN COL_LENGTH(T.Nombre, 'Activo') IS NULL THEN '0' ELSE '1' END AS TieneActivo
			--,T.Nomenclatura
			,T.PermiteEliminarSusRegistros
			,T.TablaDeCore
			,T.TieneArchivos
			,CAST(ICSS.CSS AS VARCHAR(MAX)) AS IconoCSS
		FROM Tablas AS T
			INNER JOIN IconosCSS ICSS ON ICSS.id = T.IconoCSSId
		WHERE (@Activo IS NULL 
				OR (
					(COL_LENGTH(T.Nombre, 'Activo') IS NULL AND @Activo = '0')
					OR (COL_LENGTH(T.Nombre, 'Activo') IS NOT NULL AND @Activo = '1')
					)
				)
				AND (T.TablaDeCore = @TablaDeCore OR @TablaDeCore IS NULL) 
				AND (T.TieneArchivos = @TieneArchivos OR @TieneArchivos IS NULL) 
			
		ORDER BY TieneActivo, T.PermiteEliminarSusRegistros, T.Nombre
	END
GO
-- SP-TABLA: Tablas /Especiales/ - FIN


-- ---------------------------------
-- Script: DB_ParticularCore__C10__Especiales.sql -  - FIN
-- =====================================================
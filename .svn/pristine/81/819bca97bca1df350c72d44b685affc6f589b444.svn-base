-- =====================================================
-- Descripción: ABMs Prioritarios
-- Script: DB_ParticularCore__C09a_ABMs PrioritariosA_ControlYLogRegistros, LogErrores y LogRegistros.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO

		-- Tablas Involucradas: - INICIO
			-- #ControlYLogRegistros#
			-- #LogErroresSP#
			-- LogRegistros
		-- Tablas Involucradas: - FIN

		--Ignorar los siguientes Mensages (Se producen solo por el orden en el que se ejecutan):
			-- The module 'usp_ControlYLogRegistros__Insert' depends on the missing object 'usp_LogRegistros__Insert'. The module will still be created; however, it cannot run successfully until the object exists.
			-- The module 'usp_ControlYLogRegistros__Insert' depends on the missing object 'usp_LogErroresSP__Insert'. The module will still be created; however, it cannot run successfully until the object exists.
			-- The module 'usp_LogErrores__Update_by_@id' depends on the missing object 'usp_LogRegistros__Listado_HistoriaDeUnRegistro'. The module will still be created; however, it cannot run successfully until the object exists.


-- SP-TABLA: "Control" - INICIO
IF (OBJECT_ID('usp_ControlYLogRegistros__Insert') IS NOT NULL) DROP PROCEDURE usp_ControlYLogRegistros__Insert
GO
CREATE PROCEDURE usp_ControlYLogRegistros__Insert

-- Nueva version "Agregado Diciembre 2019"

	@UsuarioQueEjecutaId		INT
	,@FechaDeEjecucion			DATETIME
	,@Token						VARCHAR(40) = NULL -- = NULL cuando es desde una PC --> "sin dispositivo".
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
	
	,@Tabla						VARCHAR(80)
	,@RegistroId				INT			= '-1' -- Indica que no hay registro
	,@FuncionDePagina			VARCHAR(30)
	,@SP						VARCHAR(50)
	,@RegistrosAfectados		INT
	
	,@NumeroDeError				INT
	
	,@sResSQL					VARCHAR(1000)			OUTPUT
AS
BEGIN
	DECLARE @LineaDeError INT = '0' -- Por default.
		,@MensajeDeError VARCHAR(1000)	
		,@ErrorInconsistente BIT = '0'
		
	IF (@NumeroDeError = '0' AND @RegistrosAfectados > 0) --> Operación OK.
		BEGIN
			SET @sResSQL = '' -- Está OK. No miro el resultado de ingresar el LogRegistros, ya q si me da error, estaría confundiendo el resultado de la operación.
			
			EXEC usp_LogRegistros__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
					, @Tabla = @Tabla, @RegistroId = @RegistroId, @FuncionDePagina = @FuncionDePagina
		END
	ELSE -- Se produjo un error --> Lo registro.
		BEGIN
			IF (@NumeroDeError = '0' AND @RegistrosAfectados = '0') --> ERROR INCONSISTENTE, ES UNA CONTRADICCIÓN, NO DEBERÍA PASAR.
				BEGIN 
					SET @MensajeDeError = 'Error inconsistente, una contradicción: @NumeroDeError = 0 y @RegistrosAfectados = 0'
							+ ' // @Tabla = ' + @Tabla + ' // @RegistroId = ' + CAST(@RegistroId AS VARCHAR(MAX))
					SET @ErrorInconsistente = 1
				END
			ELSE
				-- IF (@NumeroDeError <> 0 AND @RegistrosAfectados = 0) --> Error, no se pudo concretar la operacion.
				BEGIN
					SET @MensajeDeError = 'sys.message: ' + COALESCE((SELECT Text FROM sys.messages AS m WHERE m.message_id = @NumeroDeError AND m.language_id = 3082), '')
							+ ' // @Tabla = ' + @Tabla + ' // @RegistroId = ' + CAST(@RegistroId AS VARCHAR(MAX))
				END
				
			EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @LineaDeError, @MensajeDeError = @MensajeDeError
				--, @RegistroId = @id 
 				, @NumeroDeError = @NumeroDeError, @ErrorInconsistente = @ErrorInconsistente, @sResSQL = @sResSQL OUTPUT
		END
END
GO
-- SP-TABLA: "Control" - FIN




-- SP-TABLA: LogErrores - INICIO
IF (OBJECT_ID('usp_LogErroresSP__Insert') IS NOT NULL) DROP PROCEDURE usp_LogErroresSP__Insert
GO
-- Este LogDeErrores se carga desde otro SP --> Registra el Error en la BD y tb Devuelve el mensaje
CREATE PROCEDURE usp_LogErroresSP__Insert
	@UsuarioQueEjecutaId		INT							
	,@FechaDeEjecucion			DATETIME					
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@Tabla							VARCHAR(80)
	,@RegistroId					INT			= '-1' -- Indica que no hay registro
	,@FuncionDePagina				VARCHAR(30)
	,@SP							VARCHAR(80)
	,@NumeroDeError					INT
	,@LineaDeError					INT
	,@MensajeDeError				VARCHAR(1000)				
	,@ErrorInconsistente			BIT = '0'
	
	,@sResSQL						VARCHAR(1000)			OUTPUT
	--,@id							INT						OUTPUT	
AS
BEGIN
	DECLARE @sResSQLDeEntrada VARCHAR(1000) = @sResSQL -- Lo guardo para poder entender los errores, por que hay situaciones de errores que quedan enmascaradas por el Mensaje (Por ejemplo en TRANs encadenadas)
		,@ErrorEnAmbienteSQL BIT = '1' -- Error en SQL
		,@EstadoDeLogErrorId INT = '1' -- Por revisar
		,@UsuarioQueEjecutaPersisteEnLaBD BIT = COALESCE((SELECT id FROM Usuarios WHERE id = @UsuarioQueEjecutaId), '0') -- Si ya no se encuentra en la BD (Fué un Rollback) --> '0'
		
	-- hay errores no afectados por el TRY…CATCH: Warnings or informational messages that have a severity of 10 or lower.
	-- https://docs.microsoft.com/en-us/sql/t-sql/language-elements/try-catch-transact-sql?view=sql-server-2017
	
	-- Como la tabla originalmente se pensó para insertar los errores desde .NET, tiene otros campos.
	-- Ahora, van a comvivir ambas formas sobre la misma tabla; Para ello hacemos un "mapeo" de campos.
	--	DECLARE @TablaId				INT = (SELECT id FROM Tablas WHERE Nombre = @Tabla)	
		--,@Pagina					VARCHAR(100) = '' -- Indica que se registró directo desde SQL.
		--,@TipoDeOperacionId			INT = 0 -- Por defecto lo dejo en 0, Al tener el SP, en Nº de Error y la Linea, no lo necesito.
		--,@Modulo					VARCHAR(100) = 'Error Nº: ' + CAST(@NumeroDeError AS VARCHAR(MAX))				
		--,@Metodo					VARCHAR(50)	= @SP
		--,@Observaciones				VARCHAR(255) = 'Linea: ' + CAST(@LineaDeError AS VARCHAR(MAX))
	
	
	DECLARE @TipoDeOperacionId	INT = COALESCE((SELECT id FROM TiposDeOperaciones WHERE Nombre = @FuncionDepagina), '1') --DEFAULT
	
	IF @ErrorInconsistente = '1'
		BEGIN
			SET @sResSQL = 'Se produjo un error. Avise a sistemas. [Código: 001]. ' -- Como es un error incoherente, no se sabe si se ejecutó o no la acción.
		END
	ELSE
		BEGIN
			SET @sResSQL = (
				CASE 
					WHEN @NumeroDeError = '2627' OR @NumeroDeError = '2601' THEN 'No se puede ralizar la operación, ya existe un registro con los mismos "datos característicos" y produciría un registro "repetido". Corregir para continuar. [Código: 002]. '
					WHEN @NumeroDeError = '547' OR @NumeroDeError = '2627' THEN 'No se puede ralizar la operación por violación en la integridad de datos (Respecto a un registro asociado de otra tabla relacionada). [Código: 003]. Avise a sistemas. ' -- Error por FK
					WHEN @NumeroDeError = '201' THEN 'No se pude realizar la operación. Se produjo un error en la ejecución del procedimiento. [Código: 004]. Avise a sistemas. ' -- El SP espera un pará metro que .Net no se lo pasó.
					-- @NumeroDeError = '201' THEN 'Es x q la TRAN tiene distinto numero de BEGIN y COMMIT (culpa de trans encadenadas)
					ELSE @sResSQL
					END
			)
			IF @sResSQL = '' -- No es ninguno de los errores específicos anteriores.
				BEGIN
					SET @sResSQL = (
						CASE 
							WHEN @TipoDeOperacionId = '2' THEN 'Se produjo un error, no se pudo agregar el registro. [Código: 005]. '
							WHEN @TipoDeOperacionId = '3' THEN 'Se produjo un error, no se pudo actualizar el registro. [Código: 006]. '
							WHEN @TipoDeOperacionId = '4' THEN 'Se produjo un error, no se pudo eliminar el registro. [Código: 007]. '
							WHEN @TipoDeOperacionId = '5' THEN 'Se produjo un error, no se pudo "anular" el registro. [Código: 008]. '
							WHEN @TipoDeOperacionId = '6' THEN 'Se produjo un error, no se pudo "activar" el registro. [Código: 009]. '
							ELSE 'Se produjo un error, no se pudo concretar la acción. [Código: 010]. ' 
							END
					)
				END
		END
	
	IF @NumeroDeError = '50000' -- Viene del RaiseError que tiramos nosotros --> mostramos este mensaje al usuario.
		BEGIN
			SET @sResSQL = COALESCE(@sResSQL, '') + @MensajeDeError -- Así registramos el mensaje de texto aquí, y le damos el mismo mensaje al usuario.
		END
	
	DECLARE @Observaciones VARCHAR(1000) = 'Mensaje devuelto: ' + COALESCE(@sResSQL, '-NULL-')
		
	--IF (@sResSQL <> '') -- VER SI REALMENTE LE AGREGAMOS ESTO.
	--	BEGIN
	--		SET @sResSQL = @sResSQL + ' Error específico: ' + COALESCE((SELECT Text FROM sys.messages AS m WHERE m.message_id = @NumeroDeError AND m.language_id = 3082), '')
	--	END
	
	--SET @Mensaje = 'sys.message: ' + COALESCE((SELECT Text FROM sys.messages AS m WHERE m.message_id = @NumeroDeError AND m.language_id = 3082), '') + @Mensaje
	
	DECLARE @SeccionId INT = (SELECT id FROM Secciones WHERE Nombre = @Seccion)
	DECLARE @TablaId INT = COALESCE((SELECT id FROM Tablas WHERE Nombre = @Tabla), '1') --DEFAULT
	DECLARE @FuncionDePaginaId INT = (SELECT id FROM FuncionesDePaginas WHERE Nombre = @FuncionDePagina)
	DECLARE @PaginaId INT = COALESCE((SELECT id FROM Paginas WHERE SeccionId = @SeccionId
																AND TablaId = @TablaId 
																AND FuncionDePaginaId = @FuncionDePaginaId
										)
									, '1') -- Default = '1' cuando no se puede determinar la página.
			
	INSERT INTO LogErrores
	(
		UsuarioQueEjecutaId 
		,FechaDeEjecucion
		,Token
 		,Seccion
		,CodigoDelContexto
		,UsuarioQueEjecutaPersisteEnLaBD
		,TablaId 
		,TipoDeOperacionId
		,SP
		,NumeroDeError
		,LineaDeError
		,ErrorEnAmbienteSQL
		,Mensaje
		,sResSQLDeEntrada 
		,PaginaId
		--,Accion	DEFAULT NULL
		--,Capa	DEFAULT NULL
		--,Metodo	DEFAULT NULL
		--,MachineName	DEFAULT NULL
		,EstadoDeLogErrorId
		,Observaciones
	)
	VALUES
	(
		@UsuarioQueEjecutaId 
		,@FechaDeEjecucion
		,@Token
 		,@Seccion
		,@CodigoDelContexto
		,@UsuarioQueEjecutaPersisteEnLaBD
		,@TablaId 
		,@TipoDeOperacionId
		,@SP
		,@NumeroDeError
		,@LineaDeError
		,@ErrorEnAmbienteSQL
		,@MensajeDeError 
		,@sResSQLDeEntrada
		,@PaginaId  --DEFAULT 1
		--,@Accion	DEFAULT NULL
		--,@Capa	DEFAULT NULL
		--,@Metodo	DEFAULT NULL
		--,@MachineName	DEFAULT NULL
		,@EstadoDeLogErrorId
		,@Observaciones
	)
	
	--NO LO NECESITO: SET @id = SCOPE_IDENTITY() -- Por compatibilidad.
	--VA EL MENSAJE ARMADO: SET @sResSQL = '' -- Por compatibilidad.
END
GO




IF (OBJECT_ID('usp_LogErrores__Insert') IS NOT NULL) DROP PROCEDURE usp_LogErrores__Insert
GO
-- Este LogDeErrores se carga desde .NET
CREATE PROCEDURE usp_LogErrores__Insert
	@UsuarioQueEjecutaId		INT							
	,@FechaDeEjecucion			DATETIME					
	,@Token                     VARCHAR(40)
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)

	,@Tabla							VARCHAR(80)
	--,@SP							VARCHAR(80) = NULL
	,@NumeroDeError					INT = NULL
	,@LineaDeError					INT = NULL
	--,@ErrorEnAmbienteSQL				BIT = '0' -- error en .Net
	,@Mensaje						VARCHAR(1000)
	,@Pagina						VARCHAR(100)
	,@Accion						VARCHAR(80)
	,@Capa							VARCHAR(80)
	,@Metodo						VARCHAR(80)
	,@MachineName					VARCHAR(80)
	
	,@sResSQL						VARCHAR(1000)			OUTPUT
	,@id							INT						OUTPUT	
AS
BEGIN
	DECLARE @PaginaId INT = COALESCE((SELECT id FROM Paginas WHERE Nombre = @Pagina),1) --DEFAULT
	DECLARE @TablaId INT = COALESCE((SELECT id FROM Tablas WHERE Nombre = @Tabla),1) --DEFAULT
	DECLARE @TipoDeOperacionId INT = COALESCE((SELECT id FROM TiposDeOperaciones WHERE Nombre = @Accion),1) --DEFAULT
	DECLARE @ErrorEnAmbienteSQL BIT = '0' -- error en .Net
		,@EstadoDeLogErrorId INT = '1' -- Por revisar
		,@UsuarioQueEjecutaPersisteEnLaBD BIT = COALESCE((SELECT id FROM Usuarios WHERE id = @UsuarioQueEjecutaId), '0') -- Si ya no se encuentra en la BD (Fué un Rollback) --> '0'
		
	-- Esto es para corregir más adelante
	SET @Mensaje = COALESCE(@Mensaje, '-NULL-') + ' // @Pagina=' + COALESCE(@Pagina, '-NULL-')
	
	INSERT INTO LogErrores
	(
		UsuarioQueEjecutaId 
		,FechaDeEjecucion
		,Token
		,Seccion
		,CodigoDelContexto
		,UsuarioQueEjecutaPersisteEnLaBD
		,TablaId 
		,TipoDeOperacionId
		--,SP // Va nulo por que es de .net
		,NumeroDeError 
		--,sResSQLDeEntrada // Va nulo por que es de .net
		,LineaDeError
		,ErrorEnAmbienteSQL
		,Mensaje 
		,PaginaId
		,Accion
		,Capa
		,Metodo
		,MachineName
		,EstadoDeLogErrorId
		--,Observaciones DEFAULT NULL
	)
	VALUES
	(
		@UsuarioQueEjecutaId 
		,@FechaDeEjecucion
		,@Token
		,@Seccion
		,@CodigoDelContexto
		,@UsuarioQueEjecutaPersisteEnLaBD
		,@TablaId 
		,@TipoDeOperacionId
		--,@SP // Va nulo por que es de .net
		,@NumeroDeError
		,@LineaDeError
		,@ErrorEnAmbienteSQL
		,@Mensaje 
		--,@sResSQLDeEntrada // Va nulo por que es de .net
		,@PaginaId
		,@Accion
		,@Capa
		,@Metodo
		,@MachineName
		,@EstadoDeLogErrorId
		--,@Observaciones DEFAULT NULL
	)
	
	SET @id = SCOPE_IDENTITY() -- Por compatibilidad.
	SET @sResSQL = '' -- Por compatibilidad.
	--EXEC @sResSQL = [dbo].ufc_ResultadoOperacion__Insert  @RegistrosAfectados = @@ROWCOUNT		
END
GO




IF (OBJECT_ID('usp_LogErrores__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_LogErrores__Update_by_@id
GO
CREATE PROCEDURE usp_LogErrores__Update_by_@id
	@id								INT							
	
	,@UsuarioQueEjecutaId		INT							
	,@FechaDeEjecucion			DATETIME					
	,@Token                     VARCHAR(40)
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
	
	,@EstadoDeLogErrorId			INT
	,@Observaciones					VARCHAR(1000)
	
	,@sResSQL						VARCHAR(1000)			OUTPUT		
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogErrores'
		,@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
		
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
			, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT

	IF @sResSQL = ''
		BEGIN
			DECLARE @Historia	VARCHAR(1000)
			EXEC usp_LogRegistros__Listado_HistoriaDeUnRegistro  @RegistroId = @id, @Tabla = @Tabla, @Seccion = @Seccion, @Historia = @Historia OUTPUT
			
			UPDATE LogErrores
			SET	
				EstadoDeLogErrorId = @EstadoDeLogErrorId
				,Observaciones = @Observaciones
			FROM LogErrores
			WHERE id = @id
	
			-- Revisamos el resultado, so OK --> registra el LogRegistros, si falla --> Resgistra el LogError y devuelve el mensaje correcto.
			EXEC usp_ControlYLogRegistros__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
					, @Tabla = @Tabla , @RegistroId = @id, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @RegistrosAfectados = @@ROWCOUNT
					, @NumeroDeError = @@ERROR, @sResSQL = @sResSQL OUTPUT
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
-- SP-TABLA: LogErrores - FIN




-- SP-TABLA: LogRegistros - INICIO
IF (OBJECT_ID('usp_LogRegistros__Insert') IS NOT NULL) DROP PROCEDURE usp_LogRegistros__Insert
GO
CREATE PROCEDURE usp_LogRegistros__Insert
		@UsuarioQueEjecutaId		INT
		,@FechaDeEjecucion			DATETIME
		,@Token                     VARCHAR(40) 
 		,@Seccion					VARCHAR(30) 
		,@CodigoDelContexto			VARCHAR(40) 
		
		,@Tabla							VARCHAR(80)
		,@RegistroId					INT
		,@FuncionDePagina				VARCHAR(30)
	AS
	BEGIN
		DECLARE @sResSQL VARCHAR(1000) = ''
		
		DECLARE @TablaId INT = COALESCE((SELECT id FROM Tablas WHERE Nombre = @Tabla),1) --DEFAULT
		DECLARE @TipoDeOperacionId INT = COALESCE((SELECT id FROM TiposDeOperaciones WHERE Nombre = @FuncionDePagina),1) --DEFAULT
		DECLARE @LogLoginDeDispositivoId INT = COALESCE((SELECT id FROM LogLoginsDeDispositivos WHERE Token = @Token),1) --DEFAULT = 1, Esto lo mete en el LogRegistros
		
		-- Si U=1, Seccion=Web y Contexto Valido --> devuelve el U anonimo@
		EXEC @UsuarioQueEjecutaId = usp_VAL_Datos__Y_DevolverUsuario 
										@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
										,@Token = @Token
										,@Seccion = @Seccion
										,@CodigoDelContexto = @CodigoDelContexto
										,@Tabla = @Tabla
										,@sResSQL = @sResSQL OUTPUT
				
		IF @sResSQL = ''
			BEGIN
				SET NOCOUNT ON
				INSERT INTO LogRegistros
				(
					UsuarioQueEjecutaId
					,FechaDeEjecucion
					,TablaId
					,RegistroId
					,LogLoginDeDispositivoId
					,TipoDeOperacionId
				)
				VALUES
				(
					@UsuarioQueEjecutaId
					,@FechaDeEjecucion
					,@TablaId
					,@RegistroId
					,@LogLoginDeDispositivoId
					,@TipoDeOperacionId
				)
			END
	END
GO
-- SP-TABLA: LogRegistros - FIN


-- ---------------------------------
-- Script: DB_ParticularCore__C09a_ABMs PrioritariosA_ControlYLogRegistros, LogErrores y LogRegistros.sql - FIN
-- =====================================================
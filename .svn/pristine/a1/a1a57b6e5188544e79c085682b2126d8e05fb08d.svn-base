-- =====================================================
-- Descripción: ABMs Especiales no prioritarios.
-- Script: DB_ParticularCore__C11b_ABMs Especiales.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO 

		-- Tablas Involucradas: - INICIO
			-- Archivos
			-- Dispositivos
			-- EnviosDeCorreos
			-- Notificaciones
			-- RelAsig_TiposDeContactos_A_Contextos
			-- ReservasDeRecursos
			-- Soportes
		-- Tablas Involucradas: - FIN
		

-- SP-TABLA: Archivos /ABMs Especiales/ - INICIO
IF (OBJECT_ID('usp_Archivos__DeleteHuerfanos') IS NOT NULL) DROP PROCEDURE usp_Archivos__DeleteHuerfanos
GO
CREATE PROCEDURE usp_Archivos__DeleteHuerfanos
		-- Validaciones:
			-- 1) 
		-------------
		-- Acotaciones:
			-- 1) Eliminamos los archivos que no tienen un registro correspondiente "padre"
		------------- 
	@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@Tabla								VARCHAR(80)
	
	,@sResSQL							VARCHAR(1000)	OUTPUT
	,@id								INT		OUTPUT
AS
BEGIN TRY
	DECLARE --@Tabla VARCHAR(80) = 'Archivos' Comentada por que es un parámetro que pasa, pero luego de las linas de testeo de permisos la seteamos = 'Archivos' para mantener compatibilidad.
		@FuncionDePagina VARCHAR(30) = 'Registro' -- Los permisos se controlan contra la FDP 'Registros' en vez de contra 'Delete'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	-- La validación siguiente no se hace contra la tabla 'Archivos' sinó contra la del registro relacionado, que pertenece a la tabla @Tabla
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
	
	SET @FuncionDePagina = 'Delete' -- Para que si se produce un error lo registre correctamente
			
	IF @sResSQL = ''
		BEGIN
			DECLARE @TablaId INT = (SELECT id FROM Tablas WHERE Nombre = @Tabla)
	
				CREATE TABLE #RegistrosHuerfanos (id INT
							,RegistroId INT
							,TablaId INT
							,NombreFisicoCompleto VARCHAR(100)
							,NombreAMostrar VARCHAR(100)
						)	
						
				DECLARE @Parametros NVARCHAR(MAX) --Es necesario NVARCHAR
					,@sql NVARCHAR(MAX)
		
				SET @Parametros = N'@Tabla VARCHAR(80)'

				SET  @sql =	('SELECT 	A.id
										,A.RegistroId
										,A.TablaId
										,A.NombreFisicoCompleto
										,A.NombreAMostrar
								FROM Archivos A
								WHERE (SELECT id FROM ' + @Tabla + ' WHERE id = A.RegistroId) IS NULL '
									+ 'AND A.TablaId = ' + CAST(@TablaId AS VARCHAR) 
									+ ' ORDER BY A.RegistroId'
							)
				
				INSERT INTO #RegistrosHuerfanos EXEC sp_executesql @sql, @Parametros, @Tabla = @Tabla

				--SELECT * FROM #RegistrosHuerfanos
				
				SET  @sql =	('DELETE * FROM ' + @Tabla + ' WHERE id IN (SELECT * FROM #RegistrosHuerfanos)')
				
				EXEC sp_executesql @sql, @Parametros, @Tabla = @Tabla
				
				DROP TABLE #RegistrosHuerfanos
		END
END TRY
BEGIN CATCH
	IF OBJECT_ID('tempdb..#RegistrosHuerfanos') IS NOT NULL DROP TABLE #RegistrosHuerfanos; --// Si saltó al CATCH pesiste la Tabla creada

	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			, @RegistroId = @id 
 			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO




IF (OBJECT_ID('usp_Archivos_SwapOrden') IS NOT NULL) DROP PROCEDURE usp_Archivos_SwapOrden
GO
CREATE PROCEDURE usp_Archivos_SwapOrden
	@UsuarioQueEjecutaId		INT						
	,@FechaDeEjecucion			DATETIME				
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@Tabla							VARCHAR(80) -- Es la Tabla de "referencia" del Archivo; EJ: "Informes"
	,@RegistroId					INT -- Es el id del Archivo de referencia, o sea, "el id del Informe"
	
	,@SwapOrdenDelRegistroId		INT -- Es el id del Archivo que queremos "Subir" 1 nivel.
	
	,@sResSQL						VARCHAR(1000)	OUTPUT		
AS
BEGIN TRY
BEGIN TRAN -- El Try va primero, si no, luego recibimos errores del tipo "The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION"
	DECLARE --@Tabla VARCHAR(80) = 'Archivos' Comentada por que es un parámetro que pasa
		@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	-- La validación siguiente no se hace contra la tabla 'Archivos' sinó contra la del registro relacionado, que pertenece a la tabla @Tabla
	
	DECLARE @id INT = @RegistroId
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
		, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
		, @RegistroId = @id 
		--, @UsuarioId = @UsuarioId OUTPUT 
		, @sResSQL = @sResSQL OUTPUT
	
	--DECLARE @TablaDelArchivo VARCHAR(80) = @Tabla -- En @TablaDelArchivo guardo la tabla del registro, ya que unas lineas más adelante seteo a @Tabla = 'Archivo' para compatibilidad de funcionalidades
	--SET @Tabla = 'Archivos' -- Hago esto para mantener compatibilidad con las funciones genericas q se utilizan a continuación con @Tabla.
	-- Para descomentar las 2 lineas anteriores, 1ero hay q corregir que @Tabla usa la funciona a continuación.
	
	IF @sResSQL = ''
		BEGIN
			DECLARE @TablaId INT, @ValorDeOrdenInicial INT, @ValorDeOrdenFinal INT, @SwapOrdenDelRegistroId2 INT, @ContextoId INT
			
			SET @TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla)
			
			SELECT @ValorDeOrdenInicial = Orden, @ContextoId = ContextoId, @TablaId = TablaId FROM Archivos WHERE id = @SwapOrdenDelRegistroId
			
			SET @ValorDeOrdenFinal = (SELECT MAX(Orden) FROM Archivos WHERE 
										RegistroId = @RegistroId AND ContextoId = @ContextoId AND TablaId = @TablaId
										AND (Orden < @ValorDeOrdenInicial)) -- o sea, el inmediato anterior
										--GROUP BY id, Orden
			
			-- Ahora busco el id del orden q encontramos recien (cuandolo hacia en el mismo SELECT, con group by me daba error en el resultado).
			SET @SwapOrdenDelRegistroId2 = (SELECT id FROM Archivos WHERE 
				RegistroId = @RegistroId AND ContextoId = @ContextoId AND TablaId = @TablaId
				AND Orden = @ValorDeOrdenFinal)
			 	
			IF (@SwapOrdenDelRegistroId2 IS NULL)
				BEGIN
					SET @sResSQL = 'Se produjo un error, no existe un Archivo de orden superior.'
				END
			ELSE
				BEGIN
					UPDATE Archivos SET Orden = @ValorDeOrdenInicial FROM Archivos WHERE id = @SwapOrdenDelRegistroId2 -- Seteo Al otro
					
					UPDATE Archivos SET Orden = @ValorDeOrdenFinal FROM Archivos WHERE id = @SwapOrdenDelRegistroId -- Seteo Al Reg en cuestión.
					
					-- No registramos este log, es un cambio sin importancia
					--SELECT @Tabla = 'Archivos' -- El registro va con esta tabla.
					---- Revisamos el resultado, si OK --> registra el LogRegistros, si falla --> Resgistra el LogError y devuelve el mensaje correcto.
					--EXEC usp_ControlYLogRegistros__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
					--		, @Tabla = @Tabla , @RegistroId = @id, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @RegistrosAfectados = @@ROWCOUNT
					--		, @NumeroDeError = @@ERROR, @sResSQL = @sResSQL OUTPUT
				END
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
			, @RegistroId = @id 
 			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: Archivos /ABMs Especiales/ - FIN




-- SP-TABLA: Dispositivos /ABMs Especiales/ - INICIO
IF (OBJECT_ID('usp_Dispositivos__Update_DatosTecnicos') IS NOT NULL) DROP PROCEDURE usp_Dispositivos__Update_DatosTecnicos
GO
CREATE PROCEDURE usp_Dispositivos__Update_DatosTecnicos
	@id									INT	
	
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	--,@AsignadoAUsuarioId				INT
    ,@MachineName						VARCHAR(50) -- @Imei
    ,@OSVersion							VARCHAR(100)
    --,@UserMachineName					VARCHAR(50)
    --,@ClavePrivada					VARCHAR(40)
    --,@ClavePrivadaEntregada			BIT
    --,@ClavePrivadaFechaEntrega		DATETIME	
    --,@Observaciones					VARCHAR(1000)
    
    ,@sResSQL							VARCHAR(1000)			OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Dispositivos'
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
			UPDATE Dispositivos
			SET
				MachineName = @MachineName	
				,OSVersion = @OSVersion
				--,ClavePrivada = @ClavePrivada VER SI SE PUEDE MODIFICAR DESDE EL SITIO
			FROM Dispositivos
			WHERE id = @id

			-- Revisamos el resultado, si OK --> registra el LogRegistros, si falla --> Resgistra el LogError y devuelve el mensaje correcto.
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




IF (OBJECT_ID('usp_Dispositivos__Update_by_@Imei') IS NOT NULL) DROP PROCEDURE usp_Dispositivos__Update_by_@Imei
GO
CREATE PROCEDURE usp_Dispositivos__Update_by_@Imei				
		@UsuarioQueEjecutaId		INT						
		,@FechaDeEjecucion			DATETIME				
		,@Token                     VARCHAR(40) 
 		,@Seccion					VARCHAR(30) 
		,@CodigoDelContexto			VARCHAR(40) 
		
		,@Imei							VARCHAR(50) --MachineName 
		
		,@sResSQL						VARCHAR(1000)			OUTPUT
	AS
	BEGIN TRY
		DECLARE @Tabla VARCHAR(80) = 'Dispositivos'
			,@FuncionDePagina VARCHAR(30) = 'Update'
			,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
			,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
		
		DECLARE @id INT = (SELECT id FROM Dispositivos WHERE MachineName = @Imei)
		EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT

		IF @sResSQL = ''
			BEGIN
				UPDATE Dispositivos
				SET ClavePrivadaEntregada = 1
					 ,ClavePrivadaFechaEntrega = @FechaDeEjecucion
				FROM Dispositivos
				WHERE id = @id

				-- Revisamos el resultado, si OK --> registra el LogRegistros, si falla --> Resgistra el LogError y devuelve el mensaje correcto.
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
-- SP-TABLA: Dispositivos /ABMs Especiales/ - FIN




-- SP-TABLA: EnviosDeCorreos /ABMs Especiales/ - INICIO
IF (OBJECT_ID('usp_EnviosDeCorreos__InsertConRolDeUsuario') IS NOT NULL) DROP PROCEDURE usp_EnviosDeCorreos__InsertConRolDeUsuario
GO
CREATE PROCEDURE usp_EnviosDeCorreos__InsertConRolDeUsuario
	-- Todos los usuarios con el rol @RolReceptorId recibirán la notificación.
	
	@UsuarioQueEjecutaId        INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@Fecha								DATETIME			
	--,@UsuarioDestinatarioId				INT					
	,@TablaDeReferencia					VARCHAR(80) -- Luego en la BD lleva TablaId
	,@RegistroId						INT					
	,@IconoCSSId						INT
	,@Cuerpo							VARCHAR(1000)		
	,@Activo                            BIT = '1'
	
	,@RolReceptorId						INT -- Todos los usuarios con tal rol recibirán la notificación.
	
	,@sResSQL							VARCHAR(1000)	OUTPUT
	,@id								INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'EnviosDeCorreos'
		,@FuncionDePagina VARCHAR(30) = 'Insert'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	-- No miramos permisos ya que lo hará cada usp_EnviosDeCorreos__Insert 
	--EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
	--		, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
	--		, @RegistroId = @id 
	--		--, @UsuarioId = @UsuarioId OUTPUT 
	--		, @sResSQL = @sResSQL OUTPUT
	
	SET @sResSQL = ''
	
	
	
							-- FALTA ACOMODAR  !!!!!
	
	
	
	
	
	--IF @sResSQL = ''
	--	BEGIN
	--		DECLARE @UsuarioDestinatarioId INT
			
	--		DECLARE @ContextoId INT 
	--		EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
								
	--		DECLARE db_cursorUREnviosDeCorreos CURSOR LOCAL FOR 
	--		SELECT U.id 
	--		FROM Usuarios U
	--			INNER JOIN RelAsig_RolesDeUsuarios_A_Usuarios REL ON U.id = REL.UsuarioId AND REL.RolDeUsuarioId = @RolReceptorId
	--		WHERE U.ContextoId = @ContextoId -- Del mismo contexto

	--		OPEN db_cursorUREnviosDeCorreos  
	--		FETCH NEXT FROM db_cursorUREnviosDeCorreos INTO @UsuarioDestinatarioId

	--		WHILE @@FETCH_STATUS = 0 
	--			BEGIN 
	--				EXEC usp_EnviosDeCorreos__Insert 
	--						@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
	--						,@FechaDeEjecucion = @FechaDeEjecucion
	--						,@Token = @Token
	--						,@Seccion = @Seccion
	--						,@CodigoDelContexto = @CodigoDelContexto
	--						,@Fecha = @Fecha 
	--						,@UsuarioDestinatarioId = @UsuarioDestinatarioId -- El del cursor
	--						,@TablaDeReferencia = @TablaDeReferencia
	--						,@RegistroId = @RegistroId
	--						,@Cuerpo = @Cuerpo
	--						,@IconoCSSId = @IconoCSSId
	--						,@sResSQL = @sResSQL OUTPUT
	--						,@id = @id OUTPUT
				
	--				FETCH NEXT FROM db_cursorUREnviosDeCorreos INTO @UsuarioDestinatarioId 
	--			END 

	--		CLOSE db_cursorUREnviosDeCorreos  
	--		DEALLOCATE db_cursorUREnviosDeCorreos
	--	END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			, @RegistroId = @id 
 			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: EnviosDeCorreos /ABMs Especiales/ - FIN




-- SP-TABLA: Notificaciones /ABMs Especiales/ - INICIO
IF (OBJECT_ID('usp_Notificaciones__InsertConRolDeUsuario') IS NOT NULL) DROP PROCEDURE usp_Notificaciones__InsertConRolDeUsuario
GO
CREATE PROCEDURE usp_Notificaciones__InsertConRolDeUsuario
	-- Todos los usuarios con el rol @RolReceptorId recibirán la notificación.
	
	@UsuarioQueEjecutaId        INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@Fecha								DATETIME			
	--,@UsuarioDestinatarioId				INT					
	,@TablaDeReferencia					VARCHAR(80) -- Luego en la BD lleva TablaId
	,@RegistroId						INT					
	,@IconoCSSId						INT
	,@Cuerpo							VARCHAR(1000)		
	,@Activo                            BIT = '1'
	
	,@RolReceptorId						INT -- Todos los usuarios con tal rol recibirán la notificación.
	
	,@sResSQL							VARCHAR(1000)	OUTPUT
	,@id								INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Notificaciones'
		,@FuncionDePagina VARCHAR(30) = 'Insert'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	-- No miramos permisos ya que lo hará cada usp_Notificaciones__Insert 
	--EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
	--		, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
	--		, @RegistroId = @id 
	--		--, @UsuarioId = @UsuarioId OUTPUT 
	--		, @sResSQL = @sResSQL OUTPUT
	
	SET @sResSQL = ''
	
	IF @sResSQL = ''
		BEGIN
			DECLARE @UsuarioDestinatarioId INT
			
			DECLARE @ContextoId INT 
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
								
			DECLARE db_cursorURNotificaciones CURSOR LOCAL FOR 
			SELECT U.id 
			FROM Usuarios U
				INNER JOIN RelAsig_RolesDeUsuarios_A_Usuarios REL ON U.id = REL.UsuarioId AND REL.RolDeUsuarioId = @RolReceptorId
			WHERE U.ContextoId = @ContextoId -- Del mismo contexto

			OPEN db_cursorURNotificaciones  
			FETCH NEXT FROM db_cursorURNotificaciones INTO @UsuarioDestinatarioId

			WHILE @@FETCH_STATUS = 0 
				BEGIN 
					EXEC usp_Notificaciones__Insert 
							@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
							,@FechaDeEjecucion = @FechaDeEjecucion
							,@Token = @Token
							,@Seccion = @Seccion
							,@CodigoDelContexto = @CodigoDelContexto
							,@Fecha = @Fecha 
							,@UsuarioDestinatarioId = @UsuarioDestinatarioId -- El del cursor
							,@TablaDeReferencia = @TablaDeReferencia
							,@RegistroId = @RegistroId
							,@Cuerpo = @Cuerpo
							,@IconoCSSId = @IconoCSSId
							,@sResSQL = @sResSQL OUTPUT
							,@id = @id OUTPUT
				
					FETCH NEXT FROM db_cursorURNotificaciones INTO @UsuarioDestinatarioId 
				END 

			CLOSE db_cursorURNotificaciones  
			DEALLOCATE db_cursorURNotificaciones
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
-- SP-TABLA: Notificaciones /ABMs Especiales/ - FIN
 
 
 

-- SP-TABLA: RelAsig_TiposDeContactos_A_Contextos /ABMs Especiales/ - INICIO
IF (OBJECT_ID('usp_RelAsig_TiposDeContactos_A_Contextos__Swap@TipoDeContactoId') IS NOT NULL) DROP PROCEDURE usp_RelAsig_TiposDeContactos_A_Contextos__Swap@TipoDeContactoId
GO
CREATE PROCEDURE usp_RelAsig_TiposDeContactos_A_Contextos__Swap@TipoDeContactoId
	-- Validaciones:
		-- 
	-------------
	-- Acotaciones:
		-- Hace el Swap respecto a la asignación del @TipoDeContactoId al Contexto. Si existe --> lo elimina, si no existe --> lo inserta.
	-------------
	--@id                                            INT
 
	@UsuarioQueEjecutaId        INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
	
	,@TipoDeContactoId                      INT
 
	,@sResSQL                               VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_TiposDeContactos_A_Contextos'
		,@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	DECLARE @id INT
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			
			SET @id = (SELECT id FROM RelAsig_TiposDeContactos_A_Contextos WHERE ContextoId = @ContextoId AND TipoDeContactoId = @TipoDeContactoId)
			
			IF @id IS NULL
				BEGIN -- NO EXIXTE --> LO INSERTO
					INSERT INTO RelAsig_TiposDeContactos_A_Contextos
					(
						ContextoId	
						,TipoDeContactoId
					)
					VALUES
					(
						@ContextoId		
						,@TipoDeContactoId
					)
					
					SET @id = SCOPE_IDENTITY()
					
					-- Revisamos el resultado, si OK --> registra el LogRegistros, si falla --> Resgistra el LogError y devuelve el mensaje correcto.
					EXEC usp_ControlYLogRegistros__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
							, @Tabla = @Tabla , @RegistroId = @id, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @RegistrosAfectados = @@ROWCOUNT
							, @NumeroDeError = @@ERROR, @sResSQL = @sResSQL OUTPUT
				END
			ELSE
				BEGIN -- EXIXTE --> LO ELIMINO
					DELETE FROM RelAsig_TiposDeContactos_A_Contextos WHERE id = @id
					
					-- Revisamos el resultado, si OK --> registra el LogRegistros, si falla --> Resgistra el LogError y devuelve el mensaje correcto.
					EXEC usp_ControlYLogRegistros__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
							, @Tabla = @Tabla , @RegistroId = @id, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @RegistrosAfectados = @@ROWCOUNT
							, @NumeroDeError = @@ERROR, @sResSQL = @sResSQL OUTPUT
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
-- SP-TABLA: RelAsig_TiposDeContactos_A_Contextos /ABMs Especiales/ - FIN




-- SP-TABLA: ReservasDeRecursos /ABMs Especiales/ - INICIO
IF (OBJECT_ID('usp_ReservasDeRecursos__Update_Aprobacion') IS NOT NULL) DROP PROCEDURE usp_ReservasDeRecursos__Update_Aprobacion
GO
CREATE PROCEDURE usp_ReservasDeRecursos__Update_Aprobacion
	-- Validaciones:
		-- 1) IF @ReservaAprobada_EstadoActual <> @ReservaAprobada (Cambió) --> SET @FechaDeAprobacion = CASE WHEN @ReservaAprobada = '1' THEN @FechaDeEjecucion ELSE NULL END
		-- 2) Que no pise otras fechas de reserva para el mismo RecursoId.
	-------------
	-- Acotaciones:
		-- Una reserva no aprobada puede estar ocupando un período no permitido. Esto saltará cuando la quiera aprobar.
		-- @FechaDeAprobacion  Se modifica internamente, solo si se está aprobando o desaprobando, por medio de SET @FechaDeEjecucion si cambió @ReservaAprobada
	-------------
	 @id                                                       INT
 
	,@UsuarioQueEjecutaId        INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
	
	,@ReservaAprobada										   BIT -- Es calculado, pero lo usamos para setear la @FechaDeAprobacion.
	,@ObservacionesDelAprobador								   VARCHAR(1000)	
	
	,@sResSQL                                                  VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'ReservasDeRecursos'
		,@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
 
	DECLARE @RecursoId INT
		,@FechaDeInicio  DATETIME
		,@FechaLimite    DATETIME
		,@ReservaAprobada_EstadoActual BIT
		,@FechaDeAprobacion DATETIME
	
	SELECT @RecursoId = RecursoId, @FechaDeInicio = FechaDeInicio, @FechaLimite = FechaLimite, @ReservaAprobada_EstadoActual = ReservaAprobada FROM ReservasDeRecursos WHERE id = @id
	
	IF @sResSQL = '' AND @ReservaAprobada_EstadoActual = @ReservaAprobada -- NO Cambió
		BEGIN	
			SET @sResSQL = 'No se puede contretar la acción. La reserva ya se encuentra en el estado de aprobación indicado.'
		END
						
	IF @sResSQL = '' AND @RecursoId IS NULL
		BEGIN
			SET @sResSQL = 'No se puede contretar la acción. No existe el registro indicado.'
		END	
					
	IF @sResSQL = '' -- Verifico que tiene permisos de Aprobar/Desaprobar/Cambiar la reserva del recurso
		BEGIN
			EXEC  usp_Recursos__EsResponsableDelRecurso 
						@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
						,@FechaDeEjecucion = @FechaDeEjecucion
						,@Token = @Token
						,@Seccion = @Seccion
						,@CodigoDelContexto = @CodigoDelContexto
						,@RecursoId = @RecursoId
						,@sResSQL = @sResSQL OUTPUT
		END
		
	IF @sResSQL = '' AND @ReservaAprobada = '1' -- Reviso si está libre:
		BEGIN
			 EXEC usp_ReservasDeRecursos__RecursoDisponible 
						@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
						,@FechaDeEjecucion = @FechaDeEjecucion
						,@Token = @Token
						,@Seccion = @Seccion
						,@CodigoDelContexto = @CodigoDelContexto
						,@RecursoId = @RecursoId
						,@FechaDeInicio = @FechaDeInicio
						,@FechaLimite = @FechaLimite
						,@sResSQL = @sResSQL OUTPUT
						,@id = @id -- // Se incluye solo en un update.
					
			SET @FechaDeAprobacion = @FechaDeEjecucion
		END
	ELSE
		BEGIN	-- Está "borrando" la aprobación.
			SET @FechaDeAprobacion = NULL -- Es redundante por que se crea NULL, pero lo dejamos escrito para evitar malos entendidos.
		END
		
	IF @sResSQL = ''
		BEGIN 	
			UPDATE ReservasDeRecursos
			SET
				FechaDeAprobacion = @FechaDeAprobacion
				,ObservacionesDelAprobador = @ObservacionesDelAprobador
	
			FROM ReservasDeRecursos
			WHERE id = @id
 
			-- Revisamos el resultado, si OK --> registra el LogRegistros, si falla --> Resgistra el LogError y devuelve el mensaje correcto.
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
-- SP-TABLA: ReservasDeRecursos /ABMs Especiales/ - FIN




-- SP-TABLA: Soportes /ABMs Especiales/ - INICIO
IF (OBJECT_ID('usp_Soportes__Update_Campos_@PublicacionId_by_@id') IS NOT NULL) DROP PROCEDURE usp_Soportes__Update_Campos_@PublicacionId_by_@id
GO
CREATE PROCEDURE usp_Soportes__Update_Campos_@PublicacionId_by_@id
	@id									INT		
	
	,@PublicacionId						INT
	
	,@UsuarioQueEjecutaId       INT						
	,@FechaDeEjecucion			DATETIME				
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@sResSQL							VARCHAR(1000)	OUTPUT						
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Soportes'
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
			IF @PublicacionId = -1
				BEGIN
					SET @PublicacionId = NULL
				END
		
			UPDATE Soportes
			SET PublicacionId = @PublicacionId
			FROM Soportes
			WHERE id = @id

			SET @id = SCOPE_IDENTITY()
	
			-- Revisamos el resultado, si OK --> registra el LogRegistros, si falla --> Resgistra el LogError y devuelve el mensaje correcto.
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
-- SP-TABLA: Soportes /ABMs Especiales/ - FIN


-- ---------------------------------
-- Script: DB_ParticularCore__C11b_ABMs Especiales.sql - FIN
-- =====================================================
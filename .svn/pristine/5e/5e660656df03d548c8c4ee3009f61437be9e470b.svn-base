-- =====================================================
-- Descripción: ABMs Particulares no prioritarios.
-- Script: DB_ParticularCore__C11b_ABMs Particulares.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO 

		-- Tablas Involucradas: - INICIO
			-- Archivos
			-- Importaciones
			-- Informes
			-- LogLoginsDeDispositivos
			-- Notas
			-- Notificaciones
			-- RecorridosDeDispositivos
			-- ReservasDeRecursos
			-- Soportes
			-- Tareas
			-- Ubicaciones
		-- Tablas Involucradas: - FIN


-- SP-TABLA: Archivos /ABMs Particulares/ - INICIO
IF (OBJECT_ID('usp_Archivos__Insert') IS NOT NULL) DROP PROCEDURE usp_Archivos__Insert
GO
CREATE PROCEDURE usp_Archivos__Insert
		-- Validaciones:
			-- 1) 
		-------------
		-- Acotaciones:
			-- 1) Se puede realizar la acción con un usuario con permiso, o de forma "Anónima" cuando cumple con los requisitos para este caso.
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
		@FuncionDePagina VARCHAR(30) = 'Insert'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	-- La validación siguiente no se hace contra la tabla 'Archivos' sinó contra la del registro relacionado, que pertenece a la tabla @Tabla
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
	
	DECLARE @TablaDelArchivo VARCHAR(80) = @Tabla -- En @TablaDelArchivo guardo la tabla del registro, ya que unas lineas más adelante seteo a @Tabla = 'Archivo' para compatibilidad de funcionalidades
	SET @Tabla = 'Archivos' -- Hago esto para mantener compatibilidad con las funciones genericas q se utilizan a continuación con @Tabla.
	
	IF @sResSQL = ''
		BEGIN
			DECLARE @NomenclaturaDeTabla	VARCHAR(12)
			DECLARE @TablaId	INT
			SELECT @TablaId = id, @NomenclaturaDeTabla = Nomenclatura FROM Tablas WHERE Nombre = @TablaDelArchivo
			
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			
			DECLARE @Orden	INT
			EXEC @Orden = ufc_Registros__ValorSiguiente @Tabla = 'Archivos', @Campo = 'Orden', @ContextoId = @ContextoId
			
			DECLARE	@Extension	VARCHAR(8) = (RIGHT(@NombreFisicoCompleto, CHARINDEX('.',REVERSE(@NombreFisicoCompleto))-1))
			
			IF (@Extension IS NULL OR @Extension = '')
				BEGIN
					SET @sResSQL = 'No se puede concretar la acción. El Archivo ingresado debe incluir una extensión de archivo.'
				END
			ELSE
				BEGIN
					DECLARE @ExtensionDeArchivoId INT
					EXEC usp_ExtensionesDeArchivos__id_by_@nombre  
							@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
							,@FechaDeEjecucion = @FechaDeEjecucion
							,@Token = @Token
							,@Seccion = @Seccion
							,@CodigoDelContexto = @CodigoDelContexto
							,@Nombre = @Extension
							,@id = @ExtensionDeArchivoId OUTPUT
							,@sResSQL = @sResSQL OUTPUT
					
					IF @sResSQL = ''
						BEGIN
							DECLARE @NumAleatorioDe8Digitos INT = (SELECT ROUND(((99999999 - 1) * RAND() + 1), 0))
							-- Ejemplo: "Informes_12945678_557_Imagen de una postal.jpg"  (Tabla: Informes, id: 557)
							SET @NombreFisicoCompleto = @NomenclaturaDeTabla + '_' + CAST(@NumAleatorioDe8Digitos AS VARCHAR(MAX))
									 + '_' + CAST(@RegistroId AS VARCHAR(MAX)) + '_' + @NombreFisicoCompleto
						END
					
					IF @sResSQL = ''
						BEGIN
							SET NOCOUNT ON
							INSERT INTO Archivos
							(
								ContextoId	
								,TablaId
								,RegistroId
								,NombreFisicoCompleto
								,NombreAMostrar
								,ExtensionDeArchivoId
								,Orden
								,Observaciones
							)
							VALUES
							(
								@ContextoId
								,@TablaId
								,@RegistroId
								,@NombreFisicoCompleto
								,@NombreAMostrar
								,@ExtensionDeArchivoId
								,@Orden
								,@Observaciones
							)
							
							SET @id = SCOPE_IDENTITY()
	
							-- Revisamos el resultado, si OK --> registra el LogRegistros, si falla --> Resgistra el LogError y devuelve el mensaje correcto.
							EXEC usp_ControlYLogRegistros__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
									, @Tabla = @Tabla , @RegistroId = @id, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @RegistrosAfectados = @@ROWCOUNT
									, @NumeroDeError = @@ERROR, @sResSQL = @sResSQL OUTPUT
						END
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




IF (OBJECT_ID('usp_Archivos__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_Archivos__Update_by_@id
GO
CREATE PROCEDURE usp_Archivos__Update_by_@id
	@id									INT	
	
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	--,ContextoId						INT	
	--,@Tabla								VARCHAR(100)		
	--,@RegistroId						INT	
	--,@NombreFisicoCompleto				VARCHAR(100)
	,@NombreAMostrar					VARCHAR(100)
	--,ExtensionDeArchivoId				INT		
	--,Orden							INT	-- Si un registro tiene + de 1 Archivo --> Este campo los "ordena".
	,@Observaciones						VARCHAR(1000)
	
	,@sResSQL							VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = (SELECT Nombre FROM Tablas T INNER JOIN Archivos A ON T.id = A.TablaId WHERE A.id = @id) -- No la indicamos directamente, si no que se busca del registro que se pasa.
		,@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	-- Los permisos no se evalúan contra la tabla "Archivos", si no contra la tabla: @Tabla --> Contra el Registro "Padre"
	DECLARE @RegistroPadreId INT = (SELECT RegistroId FROM Archivos WHERE id = @id)
		,@RegistroInicial INT = @id -- Lo guardo
	
	SET @id = @RegistroPadreId
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
	
	SET @id = @RegistroInicial -- Lo recupero
	SET @Tabla = 'Archivos' -- Hago esto para mantener compatibilidad con las funciones genericas q se utilizan a continuación con @Tabla.
	
	IF @sResSQL = ''
		BEGIN
			UPDATE Archivos
			SET
				NombreAMostrar = @NombreAMostrar	
				,Observaciones = @Observaciones
			FROM Archivos
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
-- SP-TABLA: Archivos /ABMs Particulares/ - FIN




-- SP-TABLA: Importaciones /ABMs Particulares/ - INICIO
IF (OBJECT_ID('usp_Importaciones__Insert') IS NOT NULL) DROP PROCEDURE usp_Importaciones__Insert
GO
CREATE PROCEDURE usp_Importaciones__Insert
	@UsuarioQueEjecutaId		INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
			
	,@TablaDestino					VARCHAR(80)
	,@Observaciones					VARCHAR(1000) = ''
	
    ,@sResSQL						VARCHAR(1000)	OUTPUT
    ,@id							INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Importaciones'
		,@FuncionDePagina VARCHAR(30) = 'Insert'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT

	IF @sResSQL = ''
		BEGIN
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			
			DECLARE @Numero INT = (SELECT COALESCE(MAX(Numero), 0) + 1 FROM Importaciones WHERE ContextoId = @ContextoId)
			DECLARE @TablaId INT = (SELECT id FROM Tablas WHERE Nombre = @TablaDestino)
			
			INSERT INTO Importaciones
			(
				ContextoId
				,UsuarioQueImportaId
				,TablaId
				,Numero
				,Fecha
				,Observaciones
			)
			VALUES
			(
				@ContextoId
				,@UsuarioQueEjecutaId
				,@TablaId
				,@Numero
				,@FechaDeEjecucion
				,@Observaciones
			)
		
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




IF (OBJECT_ID('usp_Importaciones__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_Importaciones__Update_by_@id
GO
CREATE PROCEDURE usp_Importaciones__Update_by_@id
	@id								INT	
	
	,@UsuarioQueEjecutaId		INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@ObservacionesPosteriores		VARCHAR(1000) = ''
	
    ,@sResSQL						VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Importaciones'
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
			UPDATE Importaciones
			SET
				ObservacionesPosteriores = @ObservacionesPosteriores
			FROM Importaciones
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
-- SP-TABLA: Importaciones /ABMs Particulares/ - FIN
 
 
 
 
-- SP-TABLA: Informes /ABMs Particulares/ - INICIO
IF (OBJECT_ID('usp_Informes__Insert') IS NOT NULL) DROP PROCEDURE usp_Informes__Insert
GO
CREATE PROCEDURE usp_Informes__Insert
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@UsuarioId                                                INT = '-2' -- Agrego un valor por default = '-2' y más adelante, si es = '-2' --> le asigno el @UsuarioQueEjecutaId
	,@CategoriaDeInformeId                                     INT
	,@Titulo                                                   VARCHAR(150)
	,@Texto                                                    VARCHAR(MAX)
	,@FechaDeInforme                                           DATE
	,@Activo                                                   BIT = 1
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                                                  VARCHAR(1000)	OUTPUT
	,@id                                                       INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Informes'
		,@FuncionDePagina VARCHAR(30) = 'Insert'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				, @RegistroId = @id
				, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SET NOCOUNT ON
			INSERT INTO Informes
			(
				ContextoId
				,UsuarioId
				,CategoriaDeInformeId
				,Titulo
				,Texto
				,FechaDeInforme
				,Activo
				,Observaciones
			)
			VALUES
			(
				@ContextoId
				,@UsuarioId
				,@CategoriaDeInformeId
				,@Titulo
				,@Texto
				,@FechaDeInforme
				,@Activo
				,@Observaciones
			)
			SET @id = SCOPE_IDENTITY()
 
			-- Revisamos el resultado, si OK --> registra el LogRegistros, si falla --> Resgistra el LogError y devuelve el mensaje correcto.
			EXEC usp_ControlYLogRegistros__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
					, @Tabla = @Tabla , @RegistroId = @id, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @RegistrosAfectados = @@ROWCOUNT
					, @NumeroDeError = @@ERROR, @sResSQL = @sResSQL OUTPUT
					
					
			-- Agregamos las notificaciones: 
			IF @sResSQL = '' AND dbo.ufc_SPs__GeneracionDeNotificacionesHabilitada(@SP) = '1'
				BEGIN
					DECLARE @NotificacionId INT
						,@Cuerpo VARCHAR(1000) = 'Nuevo informe: ' + @Titulo
						,@IconoCSSId INT = COALESCE((SELECT id FROM IconosCSS WHERE Nombre = 'Life Ring Gray'), 1) -- Si no la encuentra id=1 (Default)
						,@RolReceptorId INT
					
					EXEC @RolReceptorId = ufc_RolesDeUsuarios__RecibeNotifPorModifInformesId
					
					EXEC usp_Notificaciones__InsertConRolDeUsuario -- Le envía a todos los del rol
							@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
							,@FechaDeEjecucion = @FechaDeEjecucion
							,@Token = @Token
							,@Seccion = @Seccion
							,@CodigoDelContexto = @CodigoDelContexto
							,@Fecha = @FechaDeEjecucion 
							--,@UsuarioDestinatarioId = @UsuarioDestinatarioId
							,@TablaDeReferencia = @Tabla
							,@RegistroId = @id
							,@Cuerpo = @Cuerpo
							,@RolReceptorId = @RolReceptorId
							,@IconoCSSId = @IconoCSSId
							,@sResSQL = @sResSQL OUTPUT
							,@id = @NotificacionId OUTPUT
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
 
 
 
 
IF (OBJECT_ID('usp_Informes__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_Informes__Update_by_@id
GO
CREATE PROCEDURE usp_Informes__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@CategoriaDeInformeId                                     INT
	,@Titulo                                                   VARCHAR(150)
	,@Texto                                                    VARCHAR(MAX)
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                                                  VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Informes'
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
			UPDATE Informes
			SET
				CategoriaDeInformeId = @CategoriaDeInformeId
				,Titulo = @Titulo
				,Texto = @Texto
				,Observaciones = @Observaciones
			FROM Informes
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
-- SP-TABLA: Informes /ABMs Particulares/ - FIN




-- SP-TABLA: LogLoginsDeDispositivos_Rechazados /ABMs Particulares/ - INICIO 
IF (OBJECT_ID('usp_LogLoginsDeDispositivosRechazados__Insert') IS NOT NULL) DROP PROCEDURE usp_LogLoginsDeDispositivosRechazados__Insert
GO
CREATE PROCEDURE usp_LogLoginsDeDispositivosRechazados__Insert
	@UsuarioQueEjecutaId        INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
    ,@JSON								VARCHAR(5000)
	,@UsuarioIngresado					VARCHAR(81)
    ,@MachineName						VARCHAR(50)	
	,@MotivoDeRechazo					VARCHAR(1000)
	
    ,@sResSQL							VARCHAR(1000)			OUTPUT
    ,@id								INT						OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogLoginsDeDispositivosRechazados'
		,@FuncionDePagina VARCHAR(30) = 'Insert'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
		
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
	
	IF @sResSQL = ''
		BEGIN
			SET NOCOUNT ON
			INSERT INTO LogLoginsDeDispositivosRechazados
			(
				JSON
				,UsuarioIngresado
				,MachineName
				,MotivoDeRechazo		
				,FechaDeEjecucion							
			)
			VALUES
			(
				 @JSON
				,@UsuarioIngresado
				,@MachineName
				,@MotivoDeRechazo		
				,@FechaDeEjecucion		
			)
			
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
-- SP-TABLA: LogLoginsDeDispositivos_Rechazados /ABMs Particulares/ - FIN
 
 
 
 
-- SP-TABLA: Notas /ABMs Particulares/ - INICIO
IF (OBJECT_ID('usp_Notas__Insert') IS NOT NULL) DROP PROCEDURE usp_Notas__Insert
GO
CREATE PROCEDURE usp_Notas__Insert
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	--,@UsuarioId                                                INT = '-2' -- Agrego un valor por default = '-2' y más adelante, si es = '-2' --> le asigno el @UsuarioQueEjecutaId
	,@IconoCSSId                                               INT
	--,@Fecha                                                    DATETIME
	,@FechaDeVencimiento                                       DATETIME = NULL
	,@Titulo                                                   VARCHAR(100)
	,@Cuerpo                                                   VARCHAR(MAX)
	,@CompartirConTodos                                        BIT
 
	,@sResSQL                                                  VARCHAR(1000)	OUTPUT
	,@id                                                       INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Notas'
		,@FuncionDePagina VARCHAR(30) = 'Insert'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SET NOCOUNT ON
			INSERT INTO Notas
			(
				ContextoId
				,UsuarioId
				,IconoCSSId
				,Fecha
				,FechaDeVencimiento
				,Titulo
				,Cuerpo
				,CompartirConTodos
			)
			VALUES
			(
				@ContextoId
				,@UsuarioQueEjecutaId -- UsuarioId = @UsuarioQueEjecutaId
				,@IconoCSSId
				,@FechaDeEjecucion --  Fecha = @FechaDeEjecucion
				,@FechaDeVencimiento
				,@Titulo
				,@Cuerpo
				,@CompartirConTodos
			)
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
 
 
 
 
IF (OBJECT_ID('usp_Notas__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_Notas__Update_by_@id
GO
CREATE PROCEDURE usp_Notas__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	--,@UsuarioId                                                INT
	,@IconoCSSId                                               INT
	--,@Fecha                                                    DATETIME
	,@FechaDeVencimiento                                       DATETIME
	,@Titulo                                                   VARCHAR(100)
	,@Cuerpo                                                   VARCHAR(MAX)
	,@CompartirConTodos                                        BIT
 
	,@sResSQL                                                  VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Notas'
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
			UPDATE Notas
			SET
				--UsuarioId = @UsuarioId
				IconoCSSId = @IconoCSSId
				--,Fecha = @Fecha
				,FechaDeVencimiento = @FechaDeVencimiento
				,Titulo = @Titulo
				,Cuerpo = @Cuerpo
				,CompartirConTodos = @CompartirConTodos
			FROM Notas
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
-- SP-TABLA: Notas /ABMs Particulares/ - FIN




-- SP-TABLA: Notificaciones /ABMs Particulares/ - INICIO
IF (OBJECT_ID('usp_Notificaciones__Insert') IS NOT NULL) DROP PROCEDURE usp_Notificaciones__Insert
GO
CREATE PROCEDURE usp_Notificaciones__Insert
	@UsuarioQueEjecutaId        INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@Fecha								DATETIME			
	,@UsuarioDestinatarioId				INT					
	,@TablaDeReferencia					VARCHAR(80) -- Luego en la BD lleva TablaId
	,@RegistroId						INT					
	,@IconoCSSId						INT
	,@Cuerpo							VARCHAR(1000)		
	,@Activo                            BIT = '1'
	
	,@sResSQL							VARCHAR(1000)	OUTPUT
	,@id								INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Notificaciones'
		,@FuncionDePagina VARCHAR(30) = 'Insert'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
	
	IF @sResSQL = ''
		BEGIN
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			DECLARE @Numero INT
			EXEC @Numero = ufc_Registros__ValorSiguiente @Tabla = @Tabla, @Campo = 'Numero' ,@ContextoId = @ContextoId
 
			DECLARE @TablaId INT = (SELECT id FROM Tablas WHERE Nombre = @TablaDeReferencia)
			
			DECLARE @SeccionId INT
			EXEC @SeccionId = ufc_Secciones__SeccionIdCorrespondiente @Tabla = @Tabla
			
			SET NOCOUNT ON
			INSERT INTO Notificaciones
			(
				ContextoId
				,Fecha
				,Numero
				,UsuarioDestinatarioId
				,TablaId
				,RegistroId
				,SeccionId
				,IconoCSSId
				,Cuerpo
				,Activo
			)
			VALUES
			(
				@ContextoId
				,@Fecha
				,@Numero
				,@UsuarioDestinatarioId
				,@TablaId
				,@RegistroId
				,@SeccionId
				,@IconoCSSId
				,@Cuerpo
				,@Activo
			)
			
			SET @id = SCOPE_IDENTITY()
	
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




IF (OBJECT_ID('usp_Notificaciones__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_Notificaciones__Update_by_@id
GO
CREATE PROCEDURE usp_Notificaciones__Update_by_@id
	@id									INT	
	
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@Fecha								DATETIME
	,@UsuarioDestinatarioId				INT					
	,@TablaId							INT					
	,@RegistroId						INT					
	,@Cuerpo							VARCHAR(1000)		
	,@IconoCSSId						INT		
	
	,@sResSQL							VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Notificaciones'
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
			UPDATE Notificaciones
			SET
				Fecha = @Fecha
				,UsuarioDestinatarioId = @UsuarioDestinatarioId
				,TablaId = @TablaId
				,RegistroId = @RegistroId
				,Cuerpo = @Cuerpo
				,IconoCSSId = @IconoCSSId
				,Leida = '1'
			FROM Notificaciones
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
-- SP-TABLA: Notificaciones /ABMs Particulares/ - FIN




-- SP-TABLA: RecorridosDeDispositivos /ABMs Particulares/ - INICIO
IF (OBJECT_ID('usp_RecorridosDeDispositivos__Insert') IS NOT NULL) DROP PROCEDURE usp_RecorridosDeDispositivos__Insert
GO
CREATE PROCEDURE usp_RecorridosDeDispositivos__Insert
	@UsuarioQueEjecutaId		INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
				
	,@UsuarioId						INT
	,@GpsLatitud					VARCHAR(40)
	,@GpsLongitud					VARCHAR(40) 
	,@RedLatitud 					VARCHAR(40)
	,@RedLongitud					VARCHAR(40)
	,@DispositivoId					INT
	
	,@sResSQL						VARCHAR(1000)			OUTPUT
	,@id							INT						OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RecorridosDeDispositivos'
		,@FuncionDePagina VARCHAR(30) = 'Insert'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			, @RegistroId = @id 
			, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
	
	IF @sResSQL = ''
		BEGIN
			--DECLARE @UsuarioIngresado	VARCHAR(40) = Nombre + ' ' + Apellido  FROM Usuarios WHERE Usuarios.id = @UsuarioId 
			
			DECLARE @Latitud				VARCHAR(40) = ''
				,@Longitud				VARCHAR(40) = ''
			
			IF @GpsLatitud <> '' and @GpsLongitud <> ''
				BEGIN
					SET @Latitud = @GpsLatitud
					SET @Longitud = @GpsLongitud		
				END
			ELSE
				IF  @RedLatitud <> '' and @RedLongitud <> ''
					BEGIN
						SET @Latitud = @RedLatitud
						SET @Longitud = @RedLongitud
					END

			
			INSERT INTO RecorridosDeDispositivos
			(
				Token	
				,UsuarioId	
				--,UsuarioIngresado		
				,Latitud		
				,Longitud		
				,DispositivoId 
				,FechaDeEjecucion
			)
			VALUES
			(
				@Token		
				,@UsuarioId	
				--,@UsuarioIngresado	
				,@Latitud		
				,@Longitud		
				,@DispositivoId 
				,@FechaDeEjecucion
			)
			
			SET @id = SCOPE_IDENTITY()

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
-- SP-TABLA: RecorridosDeDispositivos /ABMs Particulares/ - FIN
 
 
 
 
-- SP-TABLA: ReservasDeRecursos /ABMs Particulares/ - INICIO
IF (OBJECT_ID('usp_ReservasDeRecursos__Insert') IS NOT NULL) DROP PROCEDURE usp_ReservasDeRecursos__Insert
GO
CREATE PROCEDURE usp_ReservasDeRecursos__Insert
	-- Validaciones:
		-- 1) Solo se incluirán @ObservacionesDelAprobador si el que inserta es el mismo que aprueba (ie @ReservaAprobada = '1')
		-- 2) IF @ReservaAprobada = '1' --> Verificamos que el usuario tiene permisos de Aprobar la reserva de ese Recurso Id y además: SET @FechaDeAprobacion = @FechaDeEjecucion // ELSE SET @FechaDeAprobacion = NULL & SET @ObservacionesDelAprobador = ''
		-- 3) Que no pise otras fechas de reserva para el mismo RecursoId.
	-------------
	-- Acotaciones:
		-- A @UsuarioOriginanteId Se le impacta el @UsuarioQueEjecutaId
		-- A @FechaDePedido Se le impacta la @FechaDeEjecucion
		-- A @FechaDeAprobacion Si es una solicitud se ingresa como NULL
	-------------
	 @UsuarioQueEjecutaId        INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
	
	--,@UsuarioOriginanteId                                      INT // Se le impacta el @UsuarioQueEjecutaId
	,@UsuarioDestinatarioId                                    INT
	,@RecursoId                                                INT
	--,@FechaDePedido                                            DATETIME // Se le impacta la @FechaDeEjecucion
	--,@FechaDeAprobacion                                        DATETIME = NULL -- Si es una solicitud se ingresa como NULL
	,@ReservaAprobada										   BIT = '0' -- Es calculado, pero lo usamos para setear la @FechaDeAprobacion.
	,@FechaDeInicio                                            DATETIME
	,@FechaLimite                                              DATETIME
	,@ObservacionesDelOriginante							   VARCHAR(1000)
	,@ObservacionesDelAprobador								   VARCHAR(1000) = '' -- Solo se incluirán si el que inserta es el mismo que aprueba (ie @ReservaAprobada = '1')
	
	,@sResSQL                                                  VARCHAR(1000)	OUTPUT
	,@id                                                       INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'ReservasDeRecursos'
		,@FuncionDePagina VARCHAR(30) = 'Insert'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN -- Validación de que ese período está libre
			 EXEC  usp_ReservasDeRecursos__RecursoDisponible 
						@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
						,@FechaDeEjecucion = @FechaDeEjecucion
						,@Token = @Token
						,@Seccion = @Seccion
						,@CodigoDelContexto = @CodigoDelContexto
						,@RecursoId = @RecursoId
						,@FechaDeInicio = @FechaDeInicio
						,@FechaLimite = @FechaLimite
						,@sResSQL = @sResSQL OUTPUT
						--,@id = @id // Se incluye solo en un update.
		END					
	
	DECLARE @FechaDeAprobacion DATETIME
	
	IF @sResSQL = '' AND @ReservaAprobada = '1' -- Verifico que tiene permisos de Aprobar el recurso
		BEGIN
			EXEC usp_Recursos__EsResponsableDelRecurso
						@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
						,@FechaDeEjecucion = @FechaDeEjecucion
						,@Token = @Token
						,@Seccion = @Seccion
						,@CodigoDelContexto = @CodigoDelContexto
						,@RecursoId = @RecursoId
						,@sResSQL = @sResSQL OUTPUT
						
			SET @FechaDeAprobacion = @FechaDeEjecucion
		END
	ELSE
		BEGIN	
			SET @FechaDeAprobacion = NULL -- Es redundante por que se crea NULL, pero lo dejamos escrito para evitar malos entendidos.
			SET @ObservacionesDelAprobador = ''  -- Solo se incluirán si el que inserta es el mismo que aprueba (ie @ReservaAprobada = '1')
		END
							
	IF @sResSQL = ''
		BEGIN 
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
		 			
			DECLARE @Numero INT
			EXEC @Numero = ufc_Registros__ValorSiguiente @Tabla = @Tabla, @Campo = 'Numero' ,@ContextoId = @ContextoId
 
			DECLARE @UsuarioOriginanteId INT = @UsuarioQueEjecutaId
				,@FechaDePedido DATETIME = @FechaDeEjecucion
								
			SET NOCOUNT ON
			INSERT INTO ReservasDeRecursos
			(
				ContextoId
				,UsuarioOriginanteId
				,UsuarioDestinatarioId
				,RecursoId
				,FechaDePedido
				,FechaDeAprobacion
				,FechaDeInicio
				,FechaLimite
				,Numero
				,ObservacionesDelOriginante
				,ObservacionesDelAprobador
			)
			VALUES
			(
				@ContextoId
				,@UsuarioOriginanteId
				,@UsuarioDestinatarioId
				,@RecursoId
				,@FechaDePedido
				,@FechaDeAprobacion
				,@FechaDeInicio
				,@FechaLimite
				,@Numero
				,@ObservacionesDelOriginante
				,@ObservacionesDelAprobador
			)
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



 
IF (OBJECT_ID('usp_ReservasDeRecursos__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_ReservasDeRecursos__Update_by_@id
GO
CREATE PROCEDURE usp_ReservasDeRecursos__Update_by_@id
	-- Validaciones:
		-- 1) IF @ReservaAprobada_EstadoActual <> @ReservaAprobada (Cambió) --> SET @FechaDeAprobacion = CASE WHEN @ReservaAprobada = '1' THEN @FechaDeEjecucion ELSE NULL END
		-- 2) Que no pise otras fechas de reserva para el mismo RecursoId.
	-------------
	-- Acotaciones:
		-- Si la reserva se encuentra aprobada no se puede modificar. Si se desea modificarlo --> 1ero hay que desaprobarla.
		-- @UsuarioOriginanteId No se modifica
		-- FechaDePedido No se modifica
		-- @FechaDeAprobacion  Se modifica internamente, solo si se está aprobando o desaprobando, por medio de SET @FechaDeEjecucion si cambió @ReservaAprobada
	-------------
	 @id                                                       INT
 
	,@UsuarioQueEjecutaId        INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
	
	--,@UsuarioOriginanteId                                      INT // No se modifica
	,@UsuarioDestinatarioId                                    INT
	--,@RecursoId                                                INT // No se modifica
	--,@FechaDePedido                                            DATETIME // No se modifica
	--,@FechaDeAprobacion                                        DATETIME // Se modifica internamente, solo si se está aprobando o desaprobando, por medio de SET @FechaDeEjecucion si cambió @ReservaAprobada
	--,@ReservaAprobada										   BIT -- Es calculado, pero lo usamos para setear la @FechaDeAprobacion.
	,@FechaDeInicio                                            DATETIME
	,@FechaLimite                                              DATETIME
	,@ObservacionesDelOriginante							   VARCHAR(1000)
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
		,@ReservaAprobada_EstadoActual BIT
		,@UsuarioOriginanteId INT
	
	SELECT @RecursoId = RecursoId, @ReservaAprobada_EstadoActual = ReservaAprobada, @UsuarioOriginanteId = UsuarioOriginanteId FROM ReservasDeRecursos WHERE id = @id
	
	IF @sResSQL = '' AND @RecursoId IS NULL
		BEGIN
			SET @sResSQL = 'No se puede contretar la acción. No existe el registro indicado.'
		END	
	
	IF @sResSQL = '' AND @ReservaAprobada_EstadoActual = '1'
		BEGIN	
			SET @sResSQL = 'No se puede contretar la acción. La reserva ya se encuentra aprobada.'
		END
				
	IF @sResSQL = '' AND @UsuarioQueEjecutaId = @UsuarioOriginanteId -- Es el usuario que solicitó:
		BEGIN
			SET @ObservacionesDelAprobador = (SELECT ObservacionesDelAprobador FROM ReservasDeRecursos WHERE id = @id) -- GUARDO LAS DEL APROBADOR
		END				
	ELSE
		BEGIN -- VERIFICO QUE TIENE PERMISO:
			SET @ObservacionesDelOriginante	= (SELECT ObservacionesDelOriginante FROM ReservasDeRecursos WHERE id = @id) -- GUARDO LAS DEL ORIGINANDTE
			
			EXEC @sResSQL = usp_Recursos__EsResponsableDelRecurso 
								@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
								,@FechaDeEjecucion = @FechaDeEjecucion
								,@Token = @Token
								,@Seccion = @Seccion
								,@CodigoDelContexto = @CodigoDelContexto
								,@RecursoId = @RecursoId
								,@sResSQL = @sResSQL OUTPUT
		END
						
	IF @sResSQL = '' -- Reerva no Aprobada:
		BEGIN 
			UPDATE ReservasDeRecursos
			SET
				--UsuarioOriginanteId = @UsuarioOriginanteId
				UsuarioDestinatarioId = @UsuarioDestinatarioId
				--,RecursoId = @RecursoId
				--,FechaDePedido = @FechaDePedido
				--,FechaDeAprobacion = @FechaDeAprobacion
				,FechaDeInicio = @FechaDeInicio
				,FechaLimite = @FechaLimite
				,ObservacionesDelOriginante	= @ObservacionesDelOriginante
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
-- SP-TABLA: ReservasDeRecursos /ABMs Particulares/ - FIN




-- SP-TABLA: Soportes /ABMs Particulares/ - INICIO
IF (OBJECT_ID('usp_Soportes__Insert') IS NOT NULL) DROP PROCEDURE usp_Soportes__Insert
GO
CREATE PROCEDURE usp_Soportes__Insert
	@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@UsuarioQueCerroId					INT = 1
	,@UsuarioQueSolicitaId				INT
	,@FechaDeCierre						DATETIME = NULL
	,@Texto								VARCHAR(MAX)	
	,@Observaciones						VARCHAR(MAX)
	,@Cerrado							BIT
	,@PrioridadDeSoporteId				INT
	,@EstadoDeSoporteId					INT = 1 -- Es obligatorio q sea 1, pero por compatibilidad del modelo .net lo ponemos. Luego lo validamos.
	,@ObservacionesPrivadas				VARCHAR(MAX) = ''
	
	,@sResSQL							VARCHAR(1000)	OUTPUT
	,@id								INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Soportes'
		,@FuncionDePagina VARCHAR(30) = 'Insert'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
	
	--Validamos que sea 1 ( -- Es obligatorio q sea 1, pero por compatibilidad del modelo .net lo ponemos en el Insert. Luego lo validamos.)
	IF @EstadoDeSoporteId <> 1
		BEGIN
			SET @sResSQL = 'Estado de soporte inválido, debe ser igual a 1'
		END
	
	IF @sResSQL = ''
		BEGIN
			DECLARE @NumeroSiguiente INT
			EXEC @NumeroSiguiente = ufc_Registros__ValorSiguiente @Tabla = 'Soportes', @Campo = 'Numero'	
			
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
						
			SET NOCOUNT ON
			INSERT INTO Soportes
			(
				ContextoId
				,FechaDeEjecucion
				,UsuarioQueCerroId
				,UsuarioQueSolicitaId
				,FechaDeCierre
				,Numero
				,Texto
				,PrioridadDeSoporteId
				,EstadoDeSoportesId
			)
			VALUES
			(
				@ContextoId
				,@FechaDeEjecucion
				,@UsuarioQueCerroId
				,@UsuarioQueSolicitaId
				,@FechaDeCierre
				,@NumeroSiguiente
				,@Texto
				,@PrioridadDeSoporteId
				,@EstadoDeSoporteId
			)
			
			SET @id = SCOPE_IDENTITY()
	
			-- Revisamos el resultado, si OK --> registra el LogRegistros, si falla --> Resgistra el LogError y devuelve el mensaje correcto.
			EXEC usp_ControlYLogRegistros__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
					, @Tabla = @Tabla , @RegistroId = @id, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @RegistrosAfectados = @@ROWCOUNT
					, @NumeroDeError = @@ERROR, @sResSQL = @sResSQL OUTPUT
			
			-- Agregamos las notificaciones para Masteradmins 
			IF @sResSQL = '' AND dbo.ufc_SPs__GeneracionDeNotificacionesHabilitada(@SP) = '1'
				BEGIN
					DECLARE @UsuarioDestinatarioId INT
						,@NotificacionId INT
						,@Cuerpo VARCHAR(1000) = (SELECT 'Nuevo pedido de soporte de ' + Apellido + ', ' + Nombre FROM Usuarios WHERE id = @UsuarioQueSolicitaId)
						,@IconoCSSId INT = COALESCE((SELECT id FROM IconosCSS WHERE Nombre = 'Life Ring Gray'), 1) -- Si no la encuentra id=1 (Default)
						,@RolAdministrarSoportesId INT
						
					EXEC @RolAdministrarSoportesId = ufc_RolesDeUsuarios__AdministrarSoportesId
						
					DECLARE db_cursorUDSoportes CURSOR LOCAL FOR 
					SELECT U.id 
					FROM Usuarios U
						INNER JOIN RelAsig_RolesDeUsuarios_A_Usuarios REL ON U.id = REL.UsuarioId AND REL.RolDeUsuarioId = @RolAdministrarSoportesId
					WHERE U.ContextoId = @ContextoId -- Del mismo contexto
					
					OPEN db_cursorUDSoportes  
					FETCH NEXT FROM db_cursorUDSoportes INTO @UsuarioDestinatarioId

					WHILE @@FETCH_STATUS = 0  
						BEGIN  
							EXEC usp_Notificaciones__Insert 
									@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
									,@FechaDeEjecucion = @FechaDeEjecucion
									,@Token = @Token
									,@Seccion = @Seccion
									,@CodigoDelContexto = @CodigoDelContexto
									,@Fecha = @FechaDeEjecucion 
									,@UsuarioDestinatarioId = @UsuarioDestinatarioId
									,@TablaDeReferencia = @Tabla
									,@RegistroId = @id
									,@Cuerpo = @Cuerpo
									,@IconoCSSId = @IconoCSSId
									,@sResSQL = @sResSQL OUTPUT
									,@id = @NotificacionId OUTPUT
			
							FETCH NEXT FROM db_cursorUDSoportes INTO @UsuarioDestinatarioId 
						END 

					CLOSE db_cursorUDSoportes  
					DEALLOCATE db_cursorUDSoportes 
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




IF (OBJECT_ID('usp_Soportes__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_Soportes__Update_by_@id
GO
CREATE PROCEDURE usp_Soportes__Update_by_@id
	@id									INT	
	
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@UsuarioQueCerroId					INT = 0
	,@UsuarioQueSolicitaId				INT
	,@FechaDeCierre						DATETIME = 0
	,@Texto								VARCHAR(max)	
	,@Observaciones						VARCHAR(MAX)
	,@Cerrado							BIT
	,@PrioridadDeSoporteId				INT
	,@EstadoDeSoporteId					INT
	,@ObservacionesPrivadas				VARCHAR(max)	= ''
	
	,@sResSQL							VARCHAR(1000)	OUTPUT			
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Soportes'
		,@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
		,@NotificacionId INT
		,@UsuarioDestinatarioId INT -- De la Notificación / Correos.
		,@Cuerpo VARCHAR(1000) -- Para el cuerpo de la notificación.
		
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
		, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
		, @RegistroId = @id 
		--, @UsuarioId = @UsuarioId OUTPUT 
		, @sResSQL = @sResSQL OUTPUT

	IF @sResSQL = ''
		BEGIN
			DECLARE @RegistrosAfectados INT, @NumeroDeError2 INT -- POR EXCEPCION LAS DECLARAMOS ACÁ, POR Q LUEGO VAN EN DISTINTOS begin-end, y SE PIERDE EL VALOR
				,@CierraSoporte BIT = (SELECT CierraSoporte FROM EstadosDeSoportes WHERE id = @EstadoDeSoporteId)
				,@IconoCSSId INT = COALESCE((SELECT id FROM IconosCSS WHERE Nombre = 'Life Ring Gray'), 1) -- Si no la encuentra id=1 (Default)
			
			IF @CierraSoporte = '1'  
				BEGIN
					IF (SELECT Cerrado FROM Soportes Where id = @id) = 0
						BEGIN -- Si estaba Abierto y Ahora viene Cerrado --> impacto quien lo realizó
							UPDATE Soportes
							SET
								UsuarioQueCerroId = @UsuarioQueEjecutaId
								,FechaDeCierre = @FechaDeEjecucion
								,EstadoDeSoportesId = @EstadoDeSoporteId
								,PrioridadDeSoporteId = @PrioridadDeSoporteId
								,Observaciones = @Observaciones
								,ObservacionesPrivadas = @ObservacionesPrivadas
								,Cerrado = '1'
							FROM Soportes
							WHERE id = @id
							
							SELECT @RegistrosAfectados = @@ROWCOUNT, @NumeroDeError2 = @@ERROR -- POR EXCEPCION LAS DECLARAMOS ACÁ, POR Q LUEGO VAN EN DISTINTOS begin-end, y SE PIERDE EL VALOR
							
							-- Agregamos las notificaciones: 
							IF @RegistrosAfectados = '1' AND dbo.ufc_SPs__GeneracionDeNotificacionesHabilitada(@SP) = '1'
								BEGIN
									--Agrego notificacion de cerrado para el usuario que solicitó
									SET @Cuerpo = 'Su pedido de soporte ha sido cerrado.'
									SELECT @UsuarioDestinatarioId = UsuarioQueSolicitaId FROM Soportes WHERE id = @Id
										
									EXEC usp_Notificaciones__Insert 
											@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
											,@FechaDeEjecucion = @FechaDeEjecucion
											,@Token = @Token
											,@Seccion = @Seccion
											,@CodigoDelContexto = @CodigoDelContexto
											,@Fecha = @FechaDeEjecucion 
											,@UsuarioDestinatarioId = @UsuarioDestinatarioId
											,@TablaDeReferencia = @Tabla
											,@RegistroId = @id
											,@Cuerpo = @Cuerpo
											,@IconoCSSId = @IconoCSSId
											,@sResSQL = @sResSQL OUTPUT
											,@id = @NotificacionId OUTPUT
								END
						END
					ELSE
						BEGIN -- YA ESTABA CERRADO, LO ÚNICO ACTUALIZABLE SON LAS OBS PRIVADAS
							UPDATE Soportes
							SET
								ObservacionesPrivadas = @ObservacionesPrivadas
							FROM Soportes
							WHERE id = @id
							
							SELECT @RegistrosAfectados = @@ROWCOUNT, @NumeroDeError2 = @@ERROR -- POR EXCEPCION LAS DECLARAMOS ACÁ, POR Q LUEGO VAN EN DISTINTOS begin-end, y SE PIERDE EL VALOR
						END
				END
			ELSE
				IF (SELECT Cerrado FROM Soportes Where id = @id) = 0
					BEGIN -- SIGUE ABIERTO
						IF ((SELECT EstadoDeSoportesId FROM Soportes WHERE id = @id) <> @EstadoDeSoporteId) --CAMBIO EL ESTADO DE SOPORTE
							AND dbo.ufc_SPs__GeneracionDeNotificacionesHabilitada(@SP) = '1'
							BEGIN
								--Agrego notificacion de 'en revisión' para el usuario que solicitó
								SELECT @Cuerpo = 'Su pedido de soporte cambió de estado a: ' + Nombre FROM EstadosDeSoportes WHERE id = @EstadoDeSoporteId
								SELECT @UsuarioDestinatarioId = UsuarioQueSolicitaId FROM Soportes WHERE id = @Id
								
								EXEC usp_Notificaciones__Insert 
										@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
										,@FechaDeEjecucion = @FechaDeEjecucion
										,@Token = @Token
										,@Seccion = @Seccion
										,@CodigoDelContexto = @CodigoDelContexto
										,@Fecha = @FechaDeEjecucion
										,@UsuarioDestinatarioId = @UsuarioDestinatarioId
										,@TablaDeReferencia = @Tabla
										,@RegistroId = @id
										,@Cuerpo = @Cuerpo
										,@IconoCSSId = @IconoCSSId
										,@sResSQL = @sResSQL OUTPUT
										,@id = @NotificacionId OUTPUT
							END
					
						UPDATE Soportes
						SET
							EstadoDeSoportesId = @EstadoDeSoporteId
							,PrioridadDeSoporteId = @PrioridadDeSoporteId
							,Observaciones = @Observaciones
							,ObservacionesPrivadas = @ObservacionesPrivadas
						FROM Soportes
						WHERE id = @id
						
						SELECT @RegistrosAfectados = @@ROWCOUNT, @NumeroDeError2 = @@ERROR -- POR EXCEPCION LAS DECLARAMOS ACÁ, POR Q LUEGO VAN EN DISTINTOS begin-end, y SE PIERDE EL VALOR
					END
				ELSE
					BEGIN -- YA ESTABA CERRADO, LO ÚNICO ACTUALIZABLE SON LAS OBS PRIVADAS
						UPDATE Soportes
						SET
							ObservacionesPrivadas = @ObservacionesPrivadas
						FROM Soportes
						WHERE id = @id
						
						SELECT @RegistrosAfectados = @@ROWCOUNT, @NumeroDeError2 = @@ERROR -- POR EXCEPCION LAS DECLARAMOS ACÁ, POR Q LUEGO VAN EN DISTINTOS begin-end, y SE PIERDE EL VALOR
					END
	
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
-- SP-TABLA: Soportes /ABMs Particulares/ - FIN




-- SP-TABLA: Tareas /ABMs Particulares/ - INICIO
IF (OBJECT_ID('usp_Tareas__Insert') IS NOT NULL) DROP PROCEDURE usp_Tareas__Insert
GO
CREATE PROCEDURE usp_Tareas__Insert
	@UsuarioQueEjecutaId		INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
			
	,@UsuarioOriginanteId			INT		-- El que "pide" la tarea, que puede ser distinto de quien la carga.
	,@UsuarioDestinatarioId			INT		-- A quién se le asigna la tarea para que la realice.
	,@FechaDeInicio					DATE	-- Puede ser que la cargue con una fecha posterior de inicio.
	,@FechaLimite					DATE	-- Es la fecha en la que espera que esté realizada la tarea. No implica ninguna otra acción.
	--,@Numero
	,@TipoDeTareaId					INT		-- Es como "Categorizar" o "Clasificar" a la tarea.
	,@EstadoDeTareaId				INT = 1		-- Es obligatorio q sea 1, pero por compatibilidad del modelo .net lo ponemos. Luego lo validamos.
	,@Titulo						VARCHAR(100)
	,@ImportanciaDeTareaId			INT		-- Baja, Media, Alta
	,@TablaDeReferencia				VARCHAR(80) = '' -- Usa TablaId, pero adentro la busco; id=1 cuando es "sin tabla".	La tarea puede estar relacionada con un registros particular de cualquier tabla.
	,@RegistroId					INT	= NULL	-- No es FK. La tarea puede estar relacionada con un registros particular de cualquier tabla.
	,@Observaciones					VARCHAR(2000)
	
	,@EnviarCorreo					BIT		-- No pertenece a la tabla, indica si se genera un registro en EnviosDeCorreos
	
    ,@sResSQL						VARCHAR(1000)	OUTPUT
    ,@id							INT		OUTPUT
AS
BEGIN TRY
BEGIN TRAN -- El Try va primero, si no, luego recibimos errores del tipo "The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION"
	DECLARE @Tabla VARCHAR(80) = 'Tareas'
		,@FuncionDePagina VARCHAR(30) = 'Insert'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT

	--Validamos que sea 1 ( -- Es obligatorio q sea 1, pero por compatibilidad del modelo .net lo ponemos en el Insert. Luego lo validamos.)
	IF (@EstadoDeTareaId <> 1)
		BEGIN
			SET @sResSQL = 'Estado De Tarea inválido, debe ser igual a 1'
		END
	
	IF @sResSQL = ''
		BEGIN
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			
			DECLARE @Numero INT = (SELECT COALESCE(MAX(Numero), 0) + 1 FROM Tareas WHERE ContextoId = @ContextoId)
			DECLARE @TablaId INT = COALESCE((SELECT id FROM Tablas WHERE Nombre = @TablaDeReferencia), 1) -- Si no la encuentra id=1
		
			INSERT INTO Tareas
			(
				ContextoId
				,UsuarioOriginanteId
				,UsuarioDestinatarioId
				,FechaDeInicio
				,FechaLimite
				,Numero
				,TipoDeTareaId
				,EstadoDeTareaId
				,Titulo
				,ImportanciaDeTareaId
				,TablaId
				,RegistroId
				,Observaciones
			)
			VALUES
			(
				@ContextoId
				,@UsuarioOriginanteId
				,@UsuarioDestinatarioId
				,@FechaDeInicio
				,@FechaLimite
				,@Numero
				,@TipoDeTareaId
				,@EstadoDeTareaId
				,@Titulo
				,@ImportanciaDeTareaId
				,@TablaId
				,@RegistroId
				,@Observaciones
			)
		
			SET @id = SCOPE_IDENTITY()
	
			-- Revisamos el resultado, si OK --> registra el LogRegistros, si falla --> Resgistra el LogError y devuelve el mensaje correcto.
			EXEC usp_ControlYLogRegistros__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
					, @Tabla = @Tabla , @RegistroId = @id, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @RegistrosAfectados = @@ROWCOUNT
					, @NumeroDeError = @@ERROR, @sResSQL = @sResSQL OUTPUT
			
			DECLARE @Solicitante VARCHAR(100) = (SELECT Apellido + ', ' + Nombre	FROM Usuarios WHERE id = @UsuarioOriginanteId)
							
			--Agrego la notificación para el usuario destinatario de la tarea
			IF @sResSQL = '' AND dbo.ufc_SPs__GeneracionDeNotificacionesHabilitada(@SP) = '1'
				BEGIN
					DECLARE @NotificacionId INT
						--,@Cuerpo VARCHAR(1000) = (SELECT 'Notificación de tarea nº ' + CAST(@Numero AS VARCHAR(MAX)) + ' solicitada por: ' + @Solicitante)
						--Nueva tarea: Nº X - #Titulo# - Solicitada por XX - #Fecha# ?
						,@Cuerpo VARCHAR(1000) = (SELECT 'Nueva tarea: Nº ' + CAST(@Numero AS VARCHAR(MAX)) + ' - ' + @Titulo + ' - Solicitada por: ' + @Solicitante + ' - ' + CAST(@FechaDeEjecucion AS VARCHAR(MAX)))
						,@IconoCSSId INT = COALESCE((SELECT id FROM IconosCSS WHERE Nombre = 'Life Ring Gray'), 1) -- Si no la encuentra id=1 (Default)
						
					EXEC usp_Notificaciones__Insert 
							@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
							,@FechaDeEjecucion = @FechaDeEjecucion
							,@Token = @Token
							,@Seccion = @Seccion
							,@CodigoDelContexto = @CodigoDelContexto
							,@Fecha = @FechaDeEjecucion 
							,@UsuarioDestinatarioId = @UsuarioDestinatarioId
							,@TablaDeReferencia = @Tabla
							,@RegistroId = @id
							,@Cuerpo = @Cuerpo
							,@IconoCSSId = @IconoCSSId
							,@sResSQL = @sResSQL OUTPUT
							,@id = @NotificacionId OUTPUT
				END	
			
			--Revisamos si hay q enviar un correo
			IF (@sResSQL = '' AND @EnviarCorreo = '1') AND dbo.ufc_SPs__GeneracionDeEmailHabilitada(@SP) = '1'
				BEGIN	
					DECLARE @EmailDeDestino	VARCHAR(60) = (SELECT Email FROM Usuarios WHERE id = @UsuarioDestinatarioId)
					
					IF @EmailDeDestino <> ''
						BEGIN
							DECLARE @Asunto	VARCHAR(200) = (SELECT 'Nueva tarea: Nº ' + CAST(@Numero AS VARCHAR(MAX)) + ' - ' + @Titulo + ' - Solicitada por: ' + @Solicitante)
								,@Contenido	VARCHAR(MAX) = @Cuerpo
								,@FechaPactadaDeEnvio	DATETIME = @FechaDeEjecucion
								
							SET @TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) -- En este caso es la tabla de "Tareas"
							
							EXEC usp_EnviosDeCorreos__Insert 
									@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
									,@FechaDeEjecucion = @FechaDeEjecucion
									,@Token = @Token
									,@Seccion = @Seccion
									,@CodigoDelContexto = @CodigoDelContexto
									,@UsuarioOriginanteId = @UsuarioOriginanteId
									,@UsuarioDestinatarioId = @UsuarioDestinatarioId
									,@TablaId = @TablaId
									,@RegistroId = @id
									,@EmailDeDestino = @EmailDeDestino
									,@Asunto = @Asunto
									,@Contenido = @Contenido
									,@FechaPactadaDeEnvio = @FechaPactadaDeEnvio
									,@sResSQL = @sResSQL OUTPUT
									,@id = @NotificacionId OUTPUT
						END
					ELSE
						BEGIN
							SET @sResSQL = 'La tarea y notificación fueron agregadas correctamente, pero no se pudo realizar el envío de correo por que el usuario de destino no tiene uno indicado.'
						END
				
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




IF (OBJECT_ID('usp_Tareas__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_Tareas__Update_by_@id
GO
CREATE PROCEDURE usp_Tareas__Update_by_@id
	@id								INT	
	
	,@UsuarioQueEjecutaId		INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@UsuarioOriginanteId			INT -- El que "pide" la tarea, que puede ser distinto de quien la carga.
	,@UsuarioDestinatarioId			INT -- A quién se le asigna la tarea para que la realice.
	,@FechaDeInicio					DATE -- Puede ser que la cargue con una fecha posterior de inicio.
	,@FechaLimite					DATE -- Es la fecha en la que espera que esté realizada la tarea. No implica ninguna otra acción.
	--,@Numero
	,@TipoDeTareaId					INT -- Es como "Categorizar" o "Clasificar" a la tarea.
	,@EstadoDeTareaId				INT -- Asignada, Iniciada, Finalizada, Aplazada, Esperando Acción, Etc.
	,@Titulo						VARCHAR(100)
	,@ImportanciaDeTareaId			INT	-- Baja, Media, Alta
	,@TablaId						INT	= 1 -- id=1 cuando es "sin tabla".	La tarea puede estar relacionada con un registros particular de cualquier tabla.
	,@RegistroId					INT	= NULL -- No es FK. La tarea puede estar relacionada con un registros particular de cualquier tabla.
	,@Observaciones					VARCHAR(2000)
	
    ,@sResSQL						VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Tareas'
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
			UPDATE Tareas
			SET
				UsuarioOriginanteId = @UsuarioOriginanteId
				,UsuarioDestinatarioId = @UsuarioDestinatarioId
				,FechaDeInicio = @FechaDeInicio
				,FechaLimite = @FechaLimite
				--,@Numero
				,TipoDeTareaId = @TipoDeTareaId
				,EstadoDeTareaId = @EstadoDeTareaId
				,Titulo = @Titulo
				,ImportanciaDeTareaId = @ImportanciaDeTareaId
				--,@TablaId
				--,@RegistroId
				,Observaciones = @Observaciones
			FROM Tareas
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
-- SP-TABLA: Tareas /ABMs Particulares/ - FIN
 



-- SP-TABLA: Ubicaciones /ABMs Particulares/ - INICIO
IF (OBJECT_ID('usp_Ubicaciones__Insert') IS NOT NULL) DROP PROCEDURE usp_Ubicaciones__Insert
GO
CREATE PROCEDURE usp_Ubicaciones__Insert
	-- DESCRIPCION: DEVUELVE EL ID DE UBICACION DE LA TABLA Ubicaciones Y EN CASO DE NO EXISTIR SE AGREGA
	-- Y SE DEVUELVE EL ID DEL REGISTRO AGREGADO
	
	@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@Nombre							VARCHAR(150)
	,@Observaciones						VARCHAR(1000)
	,@UbicacionAbsoluta					BIT = 1
	
	,@sResSQL							VARCHAR(1000)	OUTPUT
	,@id								INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Ubicaciones' 
		,@FuncionDePagina VARCHAR(30) = 'Insert'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT

	IF @sResSQL = ''
		BEGIN
			SET @Nombre = (SELECT REPLACE (@Nombre, '~/', '')) -- SE LE QUITA LOS CARACTERES ~	(TAMBIEN SE PUEDE CAMBIAR POR SUBSTRING)
				
			SET @id = (SELECT id FROM Ubicaciones WHERE Nombre = @Nombre)
			
			IF @id IS NULL
				BEGIN
					INSERT INTO Ubicaciones
						(
						   Nombre
						   ,UbicacionAbsoluta
						   ,Observaciones
					   )
					VALUES
					   (
						   @Nombre
						   ,@UbicacionAbsoluta
						   ,@Observaciones
					   )
			
					SET @id = SCOPE_IDENTITY()
			
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
-- SP-TABLA: Ubicaciones /ABMs Particulares/ - FIN


-- ---------------------------------
-- Script: DB_ParticularCore__C11b_ABMs Particulares.sql - FIN
-- =====================================================
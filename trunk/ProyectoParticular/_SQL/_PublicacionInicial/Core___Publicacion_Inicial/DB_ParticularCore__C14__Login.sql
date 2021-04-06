-- =====================================================
-- Descripci�n: SPs para el Login
-- Script: DB_ParticularCore__C14__Login.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO


-- SP-TABLA: LogLogins - INICIO
IF (OBJECT_ID('usp_ControlyLogLogins__Insert') IS NOT NULL) DROP PROCEDURE usp_ControlyLogLogins__Insert
GO
CREATE PROCEDURE usp_ControlyLogLogins__Insert
	-- No solo registra el LogLogin, tambien controla multiples intentos de login fallidos.
		
	@UsuarioQueEjecutaId		INT						
	,@FechaDeEjecucion			DATETIME				
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
	
	,@UserName					VARCHAR(40) -- Usuario.UserName			
	--,@Contexto					VARCHAR(40) -- Contexto.Codigo
	,@Pass						VARCHAR(40)	
	,@AuthCookie				VARCHAR(1000) = ''	
	,@DispositivoId				INT = '1' -- Sin dispositivo
	
	,@sResSQL					VARCHAR(1000)	OUTPUT
	,@id						INT				OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogLogins'
		,@FuncionDePagina VARCHAR(30) = 'Insert'
		--,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
		--,@UsuarioId	INT Reemplazado por @id
		,@ContextoId INT
		,@Activo BIT
		,@PassDelUsuario	VARCHAR(40)
		,@TipoDeLogLoginId	INT
		,@AutenticaConCookie BIT
		,@VecesDeLoginFallido INT
		,@UserNameCompleto VARCHAR(100)
		
	--@TipoDeLogLoginId =
	-- Para los fallidos tomo el digito del Exitoso (respecto a con UserName, Con Cookie o con sesion, y le agrego uno atr�s, 
	--INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, Mensaje, Observaciones) VALUES ('10', '0', 'Exitoso: Con UserName@Contexto', '', 'Se logue� con Usuario y Contexto')
	--INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, Mensaje, Observaciones) VALUES ('11', '0',  'Fallido: @UsuarioQueEjecutaId <> 1', 'Error en el Login: Usuario inv�lido para realizar esta tarea.', 'El Login se realiza mediante el Usuario de Sistema')
	--INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, Mensaje, Observaciones) VALUES ('12', '0',  'Fallido: Usuario Erroneo', 'Error en el Login: Revise los datos ingresados e intente nuevamente.', 'Los datos ingresados dan por resultado un SELECT nulo')
	--INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, Mensaje, Observaciones) VALUES ('13', '0',  'Fallido: Contexto de sistemas', 'Error en el Login: No se permite operar sobre el Contexto indicado.', 'Es el contexto de sistema id=1 que no se puede operar sobre el.')
	--INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, Mensaje, Observaciones) VALUES ('14', '0',  'Fallido: Usuario NO Activo', 'Error en el Login: El usuario no se encuentra activo. Llame al administrador del sistema.', 'Usuario identificado, pwd correcto, pero Activo = 0')
	--INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, Mensaje, Observaciones) VALUES ('15', '0',  'Fallido: Pwd incorrecto', 'Error en el Login: Revise los datos ingresados e intente nuevamente.', 'Usuario identificado, pero el pwd es incorrecto, PERO NO LE DAREMOS EL MENSAJE CORRECTO, POR SI ES ALGUIEN QUE QUIERE HACKEAR')
	--INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, Mensaje, Observaciones) VALUES ('20', '1',  'Exitoso: Con Cookie', '', 'Se logue� con la cookie')
	--INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, Mensaje, Observaciones) VALUES ('21', '1',  'Fallido: c/Cookie y @UsuarioQueEjecutaId <> 1', 'Error en el Login: Usuario inv�lido para realizar esta tarea.', 'El Login se realiza mediante el Usuario de Sistema')
	--INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, Mensaje, Observaciones) VALUES ('22', '1',  'Fallido: Cookie incorrecta', 'Error en el Login: Ingrese los datos nuevamente.', 'La cookie no coincide con ningun usuario, PERO NO LE DAREMOS EL MENSAJE CORRECTO, POR SI ES ALGUIEN QUE QUIERE HACKEAR')
	--INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, Mensaje, Observaciones) VALUES ('23', '1',  'Fallido: c/Cookie y Contexto de sistemas', 'Error en el Login: No se permite operar sobre el Contexto indicado.', 'Es el contexto de sistema id=1 que no se puede operar sobre el.')
	--INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, Mensaje, Observaciones) VALUES ('24', '1',  'Fallido: c/Cookie y Usuario NO Activo', 'Error en el Login: El usuario no se encuentra activo. Llame al administrador del sistema.', 'Usuario identificado, Cookie correcta, pero Activo = 0')

	-- las opciones siguiente est�n por orden l�gico de intereses de validaci�n.
	
	-- Lo tiro 1ero, por q a pesar de cualquier error, si puedo, registro el @UsuarioId
	IF @AuthCookie IS NOT NULL AND @AuthCookie <> '' 
		BEGIN -- Autenticacion con cookie
			SET @AutenticaConCookie = '1' -- Si lo pongo dentro del SELECT, cuando este da null --> @AutenticaConCookie se queda NULL
			
			SELECT @id = U.id
				,@ContextoId = CON.id
				,@Activo = U.Activo
				,@PassDelUsuario = U.Pass -- No es necesario, pero si para que no rompa una comparaci�n posterior.
			FROM Usuarios U
				INNER JOIN Contextos CON ON CON.id = U.ContextoId
			WHERE (U.AuthCookie = @AuthCookie)
				AND (U.FechaDeExpiracionCookie > @FechaDeEjecucion)
				--AND (@AuthCookie IS NOT NULL) // Se controla m�s adelante
				--AND	(U.Activo = 1) // Se controla m�s adelante
		END
	ELSE
		BEGIN -- Autenticacion con UserNamer + Contexto, y Pwd
			SET @AutenticaConCookie = '0' -- Si lo pongo dentro del SELECT, cuando este da null --> @AutenticaConCookie se queda NULL
			
			SELECT @id = U.id
				,@ContextoId = CON.id
				,@Activo = U.Activo
				,@PassDelUsuario = U.Pass
			FROM Usuarios U
				INNER JOIN Contextos CON ON CON.id = U.ContextoId
			WHERE 
				(LOWER(U.UserName) = LOWER(@UserName))
				AND (LOWER(CON.Codigo) = LOWER(@CodigoDelContexto))
				-- AND (Pass = @Pass) // Se controla m�s adelante
				-- AND	(U.Activo = 1) // Se controla m�s adelante
		END	
	
	-- Lo 1ero que revisamos es si viene de varios intentos consecutivos fallidos en poco tiempo (INTENTO DE HACKING)
	-- Concretamente miramos si hay en los ultimos 5 minutos, al menos 5 intentos fallidos
	IF (SELECT COUNT(id) FROM LogLogins L WHERE
				L.UsuarioId = @id 
				AND (L.UsuarioId > '1') -- No contamos el de default (q toma todos los no reconocidos)
				AND (L.TipoDeLogLoginId <> '10') -- Excluimos Exitoso con Username + Contexto
				AND (L.TipoDeLogLoginId <> '20') -- Excluimos Exitoso con Cookie 
				AND (L.TipoDeLogLoginId <> '19') -- Excluimos Los Bloqueos con Username + Contexto
				AND (L.TipoDeLogLoginId <> '29') -- Excluimos Los Bloqueos con Cookie 
				AND (L.FechaDeEjecucion > DATEADD(MINUTE, -1,@FechaDeEjecucion)) -- Ocurrido en los ultimos 5 minutos.
			) > = 10 -- Ocurrido al menos 5 veces.
		BEGIN
			SET @TipoDeLogLoginId = CASE WHEN @AutenticaConCookie = '0' THEN '19' ELSE '29' END
		END
	
	-- El Login debe realizarse mediante el Usuario de Sistema:
	IF @TipoDeLogLoginId IS NULL AND @UsuarioQueEjecutaId <> '1' 
		BEGIN
			SET @TipoDeLogLoginId = CASE WHEN @AutenticaConCookie = '0' THEN '11' ELSE '21' END
		END
	
	-- Verificamos si no se pudo identificar al usuario:
	IF @TipoDeLogLoginId IS NULL AND @id IS NULL
		BEGIN
			SET @TipoDeLogLoginId = CASE WHEN @AutenticaConCookie = '0' THEN '12' ELSE '22' END
		END
		
	-- Verificamos si se identific� al usuario, pero pertenece al contexto de sistemas (no operable):
	IF @TipoDeLogLoginId IS NULL AND (@ContextoId = '1')
		BEGIN
			SET @TipoDeLogLoginId = CASE WHEN @AutenticaConCookie = '0' THEN '13' ELSE '23' END
		END
			
	-- Verificamos si se identific� al usuario, pero no est� activo:
	IF @TipoDeLogLoginId IS NULL AND (@Activo = '0')
		BEGIN
			SET @TipoDeLogLoginId = CASE WHEN @AutenticaConCookie = '0' THEN '14' ELSE '24' END
		END
	
	-- Verificamos si se identific� al usuario, pero no coincide la contrase�a:
	IF @TipoDeLogLoginId IS NULL AND (@AutenticaConCookie = '0') AND (@PassDelUsuario <> @Pass)
		BEGIN
			-- Ac� habr�a q revisar si viene haciendo muchos intentos de logueo fallido.
			-- No hay 25 --> SET @TipoDeLogLoginId = CASE WHEN @AutenticaConCookie = '0' THEN '15' ELSE '25' END
			SET @TipoDeLogLoginId = '15'
		END
	
	-- Verificamos si no se indic� ningun error:
	IF @TipoDeLogLoginId IS NULL
		BEGIN -- Exitoso. // Lleva el Usuario v�lido que se logue�.
			-- El de la autenticaci�n con la cookie ya est� seteado arriba.
			SET @TipoDeLogLoginId = CASE WHEN @AutenticaConCookie = '0' THEN '10' ELSE '20' END
		END
	
	-- Verificamos si no se identific� al usuario --> le ponemos el de sistema p/ el Log
	IF @id IS NULL
		BEGIN
			SET @id = '1' -- Usuario de sitema (no valido). // Lleva el TipoDeLog acorde al error.
		END
	
	-- Le devolvemos el mensaje correcto de al usuario:
	SET @sResSQL = (SELECT MensajeDeError FROM TiposDeLogLogins WHERE id = @TipoDeLogLoginId) 
	
	SET @UserNameCompleto = COALESCE(@UserName + '@' + @CodigoDelContexto, '') -- Datos Ingresados
	
	INSERT INTO LogLogins
	(
		UsuarioId
		,FechaDeEjecucion
		,UsuarioIngresado
		,TipoDeLogLoginId
		,DispositivoId
	)
	VALUES
	(
		@id
		,@FechaDeEjecucion
		,@UserNameCompleto
		,@TipoDeLogLoginId
		,@DispositivoId
	)
	
	SET @VecesDeLoginFallido = COALESCE((SELECT COUNT(id) 
											FROM LogLogins L 
											WHERE L.UsuarioId = @id 
												AND (L.id > 1) 
												AND L.FechaDeEjecucion > DATEADD(MINUTE, -1,@FechaDeEjecucion)
												AND L.TipoDeLogLoginId <> '10'
												AND L.TipoDeLogLoginId <> '20'
										)
										, 0)
	
			--id	ConCookie	Nombre	MensajeDeError
			--10	0	Exitoso: Con UserName@Contexto	
			--11	0	Fallido: @UsuarioQueEjecutaId <> 1	Error en el Login: Usuario inv�lido para realizar esta tarea.
			--12	0	Fallido: Usuario Erroneo	Error en el Login: Revise los datos ingresados e intente nuevamente.
			--13	0	Fallido: Contexto de sistemas	Error en el Login: No se permite operar sobre el Contexto indicado.
			--14	0	Fallido: Usuario NO Activo	Error en el Login: El usuario no se encuentra activo. Llame al administrador del sistema.
			--15	0	Fallido: Pwd incorrecto	Error en el Login: Revise los datos ingresados e intente nuevamente.
			--19	0	Usuario Bloqueado x Multiples Fallidos c/U+C	Usuario bloqueado x 5 intentos fallidos. Espere 5 minutos para volver a intentarlo.
			--20	1	Exitoso: Con Cookie	
			--21	1	Fallido: c/Cookie y @UsuarioQueEjecutaId <> 1	Error en el Login: Usuario inv�lido para realizar esta tarea.
			--22	1	Fallido: Cookie incorrecta	Error en el Login: Ingrese los datos nuevamente.
			--23	1	Fallido: c/Cookie y Contexto de sistemas	Error en el Login: No se permite operar sobre el Contexto indicado.
			--24	1	Fallido: c/Cookie y Usuario NO Activo	Error en el Login: El usuario no se encuentra activo. Llame al administrador del sistema.
			--29	1	Usuario Bloqueado x Multiples Fallidos c/Cookie	Usuario bloqueado x 5 intentos fallidos. Espere 5 minutos para volver a intentarlo.



	IF @VecesDeLoginFallido > = 5
		BEGIN
			SET @sResSQL = 'Usuario bloqueado x 5 intentos fallidos. Espere 1 minuto para volver a intentarlo'
		END
		
		
	--SET @id = SCOPE_IDENTITY()
	
	---- Revisamos el resultado, so OK --> registra el LogRegistros, si falla --> Resgistra el LogError y devuelve el mensaje correcto.
	--EXEC usp_ControlYLogRegistros__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Tabla = @Tabla
	--	,@RegistroId = @id, @Token = @Token, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @RegistrosAfectados = @@ROWCOUNT
	--	,@NumeroDeError = @@ERROR, @sResSQL = @sResSQL OUTPUT
--END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			, @RegistroId = @id 
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO		
-- SP-TABLA: LogLogins - FIN




-- SP-TABLA: Usuarios - INICIO
	
	-- El Siguiente Script se usa en los sistemas autonomos. En cambio en la INtranet se usa otro que autentica contra AD.   !!!
	
IF (OBJECT_ID('usp_Usuarios__login') IS NOT NULL) DROP PROCEDURE usp_Usuarios__login
GO
CREATE PROCEDURE usp_Usuarios__login
	@UsuarioQueEjecutaId		INT						
	,@FechaDeEjecucion			DATETIME				
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)	
	
	,@UserName					VARCHAR(40) = '' -- Usuario.UserName			
	-----,@Contexto					VARCHAR(40) = '' -- Contexto.Codigo
	,@Pass						VARCHAR(40)	= ''
	,@AuthCookie				VARCHAR(1000) = ''	
	
	,@sResSQL					VARCHAR(1000)			OUTPUT			
AS
BEGIN
	DECLARE @id INT -- Usuario.id
		
	IF (@AuthCookie = '') AND (@UserName = '' OR @CodigoDelContexto = '' OR @Pass = '') -- Si @AuthCookie = '' --> Login Con cookie., si no --> tiene q completar el resto de campos.
		BEGIN
			SET @sResSQL = 'Error en el Login: Debe ingresar el nombre de usuario completo, su contexto y las contrase�a. Por ejemplo: jperez@empresa.com'
		END
	ELSE
		BEGIN -- Revisa SI OK TODAS LAS CONDICIONES DE LOGEO Y LO REGISTRA
			EXEC usp_ControlyLogLogins__Insert  
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					,@FechaDeEjecucion = @FechaDeEjecucion
					,@Token = @Token
					,@Seccion = @Seccion
					,@CodigoDelContexto = @CodigoDelContexto
					, @UserName = @UserName
					--, @Contexto = @Contexto
					, @Pass = @Pass
					, @AuthCookie = @AuthCookie
					, @sResSQL = @sResSQL OUTPUT
					, @id = @id OUTPUT
		END
	
	
	IF @sResSQL = '' AND OBJECT_ID('usp_Usuarios__loginP_ValidacionesAdicionales') IS NOT NULL -- Consultamos validaciones adicionales de P
		BEGIN
			EXEC usp_Usuarios__loginP_ValidacionesAdicionales  
					@UsuarioQueEjecutaId = @id
					, @sResSQL = @sResSQL OUTPUT
		END
		
		
	IF @sResSQL = '' -- Revisa tb la salida de usp_ControlyLogLogins__Insert
		BEGIN
			SELECT 	U.id 
				--,U.UserName
				,CON.CarpetaDeContenidos AS Contexto_CarpetaDeContenidos
				--,'#' + COL.CodigoHexadecimal AS Color
				,CON.Codigo AS Contexto_Codigo
				,CON.id AS ContextoId
				,CON.Nombre AS Contexto_Nombre
				--,CON.ImagenUrl AS Contexto_UrlDeImagen
				,U.Apellido + N', ' + U.Nombre AS NombreCompleto
				,RDU.id AS RolDeUsuarioId
				,U.UserName + '@' + CON.Codigo AS UserName
				,COALESCE((SELECT 1 FROM RelAsig_RolesDeUsuarios_A_Usuarios _RARU WHERE _RARU.RolDeUsuarioId = 1 AND _RARU.UsuarioId = U.Id), 0) AS EsMasterAdmin
			FROM Usuarios U
				INNER JOIN RelAsig_RolesDeUsuarios_A_Usuarios RARU ON RARU.UsuarioId = U.id
				INNER JOIN RolesDeUsuarios RDU ON RDU.id = RARU.RolDeUsuarioId 
				INNER JOIN Contextos CON ON CON.id = U.ContextoId
				--INNER JOIN Colores COL ON COL.id = CON.Color_Id
			WHERE 
				U.id = @id
			ORDER BY RDU.id 
		END
END
GO




--IF (OBJECT_ID('usp_Usuarios__login_ConSesion') IS NOT NULL) DROP PROCEDURE usp_Usuarios__login_ConSesion
--GO
--CREATE PROCEDURE usp_Usuarios__login_ConSesion
--		@UsuarioQueEjecutaId		INT		
--		,@FechaDeEjecucion			DATETIME	
		
--		,@UserName					VARCHAR(80)		-- Completo, ejemplo: pepe@Abako.local	
--		,@UltimoLoginSesionId		VARCHAR(24)			
--		,@FechaMinima				DATETIME
		
--		,@sResSQL					VARCHAR(1000)			OUTPUT
--	AS
--	BEGIN
--		SET @sResSQL = ''
		
--		IF @UsuarioQueEjecutaId <> 1		-- El Login se realiza mediante el Usuario de Sistema
--			BEGIN
--				SET @sResSQL = 'Usuario inv�lido para realizar esta tarea'
--			END
			
--		DECLARE @delimiter  CHAR(1) = '@'
--		IF (@sResSQL = '' AND CHARINDEX(@delimiter,@UserName) =  0)
--			BEGIN
--				SET @sResSQL = 'Error en el Login: Falta indicar el contexto (@XXX)'
--			END
			
--		IF @sResSQL = ''
--			BEGIN
--				DECLARE @IndiceDe_Arroba INT = CHARINDEX(@delimiter, @UserName) 
--				DECLARE @Usuario_UserName VARCHAR(40) = SUBSTRING(@UserName, 1, @IndiceDe_Arroba - 1)
--		        DECLARE @Contexto_Codigo VARCHAR(30) = SUBSTRING(@UserName, @IndiceDe_Arroba + 1, LEN(@UserName) + 1)
		
--				IF (@Usuario_UserName IS NULL) OR (@Usuario_UserName = '') OR (@Contexto_Codigo IS NULL) OR (@Contexto_Codigo = '')
--					BEGIN
--						SET @sResSQL = 'Error en el Login: @Usuario_UserName=' + @Usuario_UserName + '; @Contexto_Codigo=' + @Contexto_Codigo
--					END
				
--				IF (@sResSQL = '' AND (SELECT id FROM Contextos WHERE Codigo = @Contexto_Codigo) = 1)
--					BEGIN
--						SET @sResSQL = 'No se permite operar sobre el Contexto indicado.'
--					END
					
--				IF @sResSQL = ''
--					BEGIN
--						SELECT 	U.id 
--							--,U.UserName
--							,CON.CarpetaDeContenidos AS Contexto_CarpetaDeContenidos
--							--,'#' + COL.CodigoHexadecimal AS Color
--							,CON.Codigo AS Contexto_Codigo
--							,CON.id AS ContextoId
--							,CON.Nombre AS Contexto_Nombre
--							--,CON.ImagenUrl AS Contexto_UrlDeImagen
--							,U.Apellido + N', ' + U.Nombre AS NombreCompleto
--							,RDU.id AS RolDeUsuarioId
--							,U.UserName + '@' + CON.Codigo AS UserName
--						FROM Usuarios U
--							INNER JOIN RelAsig_RolesDeUsuarios_A_Usuarios RARU ON RARU.UsuarioId = U.id
--							INNER JOIN RolesDeUsuarios RDU ON RDU.id = RARU.RolDeUsuarioId 
--							INNER JOIN Contextos CON ON CON.id = U.ContextoId
--							--INNER JOIN Colores COL ON COL.id = CON.Color_Id
--						WHERE 
--							(LOWER(U.UserName) = LOWER(@Usuario_UserName))
--							AND (LOWER(CON.Codigo) = LOWER(@Contexto_Codigo))
--							AND (U.UltimoLoginSesionId = @UltimoLoginSesionId)
--							AND (U.Activo = 1)
--							AND (U.UltimoLoginFecha > @FechaMinima)
--							AND (
--									RARU.FechaDesde <= GETDATE()
--									AND (RARU.FechaHasta IS NULL OR RARU.FechaHasta >= GETDATE())
--								)
--						--GROUP BY U.id, U.Usuario, U.Apellido, U.Nombre, U.Activo, U.UsuarioDeSistema, RDU.Orden
--						ORDER BY RDU.id
--					END
--			END
--	END
--GO




IF (OBJECT_ID('usp_Usuarios__Update_Cookie') IS NOT NULL) DROP PROCEDURE usp_Usuarios__Update_Cookie
GO
CREATE PROCEDURE usp_Usuarios__Update_Cookie
	-- NO ACTUALIZO EN EL REGISTRO DE MODIFICACIONES
	@UsuarioQueEjecutaId		INT						
	,@FechaDeEjecucion			DATETIME				
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
	
	,@AuthCookie					VARCHAR(1000)
	
	,@sResSQL						VARCHAR(1000)			OUTPUT					
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Usuarios'
		,@FuncionDePagina VARCHAR(30) = 'Update Cookie'
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	SET @sResSQL = ''
	
	IF @AuthCookie = ''
		BEGIN
			SET @sResSQL = 'No se puede actualizar la cookie, por una "vac�a".'
		END
	ELSE
		BEGIN
			UPDATE Usuarios
			SET AuthCookie = @AuthCookie
				,FechaDeExpiracionCookie = DATEADD(HOUR, 9, @FechaDeEjecucion)
			WHERE id = @UsuarioQueEjecutaId
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




--IF (OBJECT_ID('usp_Usuarios__Update_Campos_UltimoLogin_cUsuario') IS NOT NULL) DROP PROCEDURE usp_Usuarios__Update_Campos_UltimoLogin_cUsuario
--GO
--CREATE PROCEDURE usp_Usuarios__Update_Campos_UltimoLogin_cUsuario
--		-- NO ACTUALIZO EN EL REGISTRO DE MODIFICACIONES
--		@UsuarioQueEjecutaId			INT
--		,@FechaDeEjecucion				DATETIME	
		
--		,@UserName						VARCHAR(80)		-- Completo, ejemplo: pepe@Abako.local			
--		,@UltimoLoginSesionId			VARCHAR(24)	
		
--		,@sResSQL						VARCHAR(1000)			OUTPUT					
--	AS
--	BEGIN TRY
--		DECLARE @Tabla VARCHAR(80) = 'Usuarios'
--			,@FuncionDePagina VARCHAR(30) = 'Update Ultimo Login'
--			,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
--			,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
			
--		SET @sResSQL = ''
		
--		IF @UsuarioQueEjecutaId <> 1		-- El Login se realiza mediante el Usuario de Sistema
--			BEGIN
--				SET @sResSQL = 'Usuario inv�lido para realizar esta tarea'
--			END
			
--		DECLARE @delimiter  CHAR(1) = '@'
--		IF (@sResSQL = '' AND CHARINDEX(@delimiter,@UserName) =  0)
--			BEGIN
--				SET @sResSQL = 'Error en el Login: Falta indicar el contexto (@XXX.)'
--			END
			
--		IF @sResSQL = ''
--			BEGIN
--				DECLARE @IndiceDe_Arroba INT = CHARINDEX(@delimiter, @UserName) 
--				DECLARE @Usuario_UserName VARCHAR(40) = SUBSTRING(@UserName, 1, @IndiceDe_Arroba - 1)
--		        DECLARE @Contexto_Codigo VARCHAR(30) = SUBSTRING(@UserName, @IndiceDe_Arroba + 1, LEN(@UserName) + 1)
		
--				IF (@Usuario_UserName IS NULL) OR (@Usuario_UserName = '') OR (@Contexto_Codigo IS NULL) OR (@Contexto_Codigo = '')
--					BEGIN
--						SET @sResSQL = 'Error en el Login: @Usuario_UserName=' + @Usuario_UserName + '; @Contexto_Codigo=' + @Contexto_Codigo
--					END
				
--				IF (@sResSQL = '' AND (SELECT id FROM Contextos WHERE Codigo = @Contexto_Codigo) = 1)
--					BEGIN
--						SET @sResSQL = 'No se permite operar sobre el Contexto indicado.'
--					END
					
--				IF @sResSQL = ''
--					BEGIN
--						UPDATE Usuarios
--						SET
--							UltimoLoginSesionId = @UltimoLoginSesionId
--							,UltimoLoginFecha = @FechaDeEjecucion
--						FROM Usuarios U
--							INNER JOIN Contextos CON ON CON.id = U.ContextoId
--						WHERE 
--							(LOWER(U.UserName) = LOWER(@Usuario_UserName))
--							AND (LOWER(CON.Codigo) = LOWER(@Contexto_Codigo))
--							AND	(U.Activo = 1)
						
--						-- NO Registro el Update, por que no es de datos del usuario
						
--						--SET @id = SCOPE_IDENTITY()

--						---- Revisamos el resultado, so OK --> registra el LogRegistros, si falla --> Resgistra el LogError y devuelve el mensaje correcto.
--						--EXEC usp_ControlYLogRegistros__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Tabla = @Tabla
--						--	,@RegistroId = @id, @Token = @Token, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @RowCount = @@ROWCOUNT
--						--	,@NumeroDeError = @@ERROR, @sResSQL = @sResSQL OUTPUT
--					END
--			END
--	END TRY
--	BEGIN CATCH
--		DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @Mensaje VARCHAR(1000) = ERROR_MESSAGE()
--		EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Tabla = @Tabla
--			,@FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @LineaDeError, @Mensaje = @Mensaje
--			,@NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
--	END CATCH
--GO




-- No utilizaremos el siguiente script, por q en la intranet se autentica con AD --> no tengo el id del usuario; solo su nombre de usuario
--IF (OBJECT_ID('usp_Usuarios__Update_Campos_UltimoLogin') IS NOT NULL) DROP PROCEDURE usp_Usuarios__Update_Campos_UltimoLogin
--GO
--CREATE PROCEDURE usp_Usuarios__Update_Campos_UltimoLogin
--		-- NO ACTUALIZO EN EL REGISTRO DE MODIFICACIONES
--		@UsuarioQueEjecutaId			INT						
--		,@FechaDeEjecucion				DATETIME							
		
--		,@UltimoLoginSesionId			VARCHAR(24)	
		
--		,@sResSQL						VARCHAR(1000)			OUTPUT					
--	AS
--	BEGIN TRY
--		DECLARE @Tabla VARCHAR(80) = 'Usuarios'
--			,@FuncionDePagina VARCHAR(30) = 'Update Campo Ultimo Login'
--			,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
--			,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
			
--		UPDATE Usuarios
--		SET
--			UltimoLoginSesionId = @UltimoLoginSesionId
--			,UltimoLoginFecha = @FechaDeEjecucion
--		FROM Usuarios
--		WHERE id = @UsuarioQueEjecutaId
		
--		-- NO Registro el Update, por que no es de datos del usuario
--		-- Pero Registrar en una tabla de LOGINS
		
--		IF @sResSQL = '' AND @@rowcount > 0
--			BEGIN	-- Registro el Login
--				DECLARE @id AS INT
--				EXEC usp_LogLogins__Insert @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @UserName = '', @TipoDeLogLoginId = '1', @FechaDeEjecucion = @FechaDeEjecucion, @sResSQL = @sResSQL OUTPUT, @id = @id OUTPUT
--			END
--	END TRY
--	BEGIN CATCH
--		DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @Mensaje VARCHAR(1000) = ERROR_MESSAGE()
--		EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Tabla = @Tabla
--			,@FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @LineaDeError, @Mensaje = @Mensaje
--			,@NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
--	END CATCH
--GO
-- SP-TABLA: Usuarios - FIN


-- ---------------------------------
-- Script: DB_ParticularCore__C14__Login.sql - FIN
-- =====================================================
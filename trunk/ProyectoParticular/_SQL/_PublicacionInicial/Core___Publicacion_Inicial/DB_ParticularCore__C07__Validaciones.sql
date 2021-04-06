-- =====================================================
-- Descripci�n: Validaciones
-- Script: DB_ParticularCore__C07__Validaciones.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO
				---------------------------------------------
				-- Las consignas con las Validaciones son:
				-- 1) SET @sResSQL = '' -- Si lo devuelve "vac�o" es que tiene permiso, si no, lleva el mensaje de por qu� no.
				---------------------------------------------

				-- Involucradas: - INICIO
					-- Contextos
					-- Datos
					-- FuncionesDePagina
					-- Operacion
					-- Paginas
					-- Registros
					-- RolesDeUsuarios
					-- Secciones
					-- SPs
					-- Tablas
					-- TablasYFuncionesDePaginas
					-- Usuarios
				-- Involucradas: - FIN


-- SP-TABLA: #Operacion# /Validaciones/ - INICIO
IF (OBJECT_ID('usp_VAL_Operacion__SeDebenEvaluarPermisos') IS NOT NULL) DROP PROCEDURE usp_VAL_Operacion__SeDebenEvaluarPermisos
GO
CREATE PROCEDURE usp_VAL_Operacion__SeDebenEvaluarPermisos
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- La idea es buscar si se dan las condiciones para NO evaluar permisos. 
		-- Por lo tanto, arrancamos con ,@SeDebenEvaluarPermisos BIT = '1' y si hay alg�na razon para no evaluar permisos --> = '0'
	 -------------
	@UsuarioQueEjecutaId				INT
	,@FechaDeEjecucion					DATETIME
	,@Token								VARCHAR(40)
	,@Seccion							VARCHAR(30)
	,@CodigoDelContexto					VARCHAR(40)
	,@Tabla								VARCHAR(80)
	,@FuncionDePagina					VARCHAR(30)
	,@SP								VARCHAR(80) 
	,@sResSQL							VARCHAR(1000)	OUTPUT
AS
BEGIN
	SET @sResSQL = ''

	DECLARE @TieneElRolMasterAdmin BIT = '0'
		,@EsUnaOperacionDeCore BIT = '0' -- En principio NO es una operaci�n de core --> hay que evaluar permisos.
		,@SeDebenEvaluarPermisos BIT = '1' -- En principio lo seteamos que SI, que hay que evaluarlos.
	
	EXEC @EsUnaOperacionDeCore = usp_VAL_Datos__EsUnaOperacionDeCore
									@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
									,@Token	= @Token
									,@Seccion = @Seccion
									,@CodigoDelContexto = @CodigoDelContexto
									,@Tabla = @Tabla
		
	IF @EsUnaOperacionDeCore = '1'
		BEGIN
			SET @SeDebenEvaluarPermisos = '0' -- Excluimos de mirar permisos.
		END
	
	IF @UsuarioQueEjecutaId <> '1' -- Si es el U=1 --> Es el caso donde tengo que mirar permisos con el anonimo@, por lo tanto no valido si es master admin (lo cual lo excluir�a de mirar tales permisos).
		BEGIN
			EXEC @TieneElRolMasterAdmin = usp_VAL_Usuarios__TieneElRolMasterAdmin
											@UsuarioId = @UsuarioQueEjecutaId
											,@FechaDeEjecucion = @FechaDeEjecucion
		
			IF @TieneElRolMasterAdmin = '1'
				BEGIN
					SET @SeDebenEvaluarPermisos = '0'
				END
		END
		
	IF @sResSQL = '' AND @SeDebenEvaluarPermisos = '1'
		BEGIN
			DECLARE @TablaId INT = (SELECT id FROM Tablas WHERE Nombre = @Tabla)
				,@FuncionDePaginaId INT = (SELECT id FROM FuncionesDePaginas WHERE Nombre = @FuncionDePagina)
			
			-- Vamos recorriendo y buscando si hay alg�n motivo opr el cual NO evaluar permisos (@SeDebenEvaluarPermisos = '0') --> Cuando lo encontramos, no chequeamos m�s, esa es la salida.
			
			IF @FuncionDePaginaId IS NULL
				BEGIN
					SET @sResSQL = 'La funci�n de p�gina no existe en la base de datos'
				END
				
			IF @TablaId IS NULL
				BEGIN
					SET @sResSQL = 'La tabla no existe en la base de datos'
				END
							
			IF @sResSQL = '' AND @SeDebenEvaluarPermisos = '1'
				BEGIN
					EXEC @SeDebenEvaluarPermisos = usp_VAL_FuncionesDePaginas__SeDebeEvaluarPermisos
														@FuncionDePagina = @FuncionDePagina
				END
			
			IF @sResSQL = '' AND @SeDebenEvaluarPermisos = '1'
				BEGIN
					EXEC @SeDebenEvaluarPermisos = usp_VAL_SPs__SeDebeEvaluarPermisos
														@SP = @SP
				END												
					
			IF @sResSQL = '' AND @SeDebenEvaluarPermisos = '1'
				BEGIN
					EXEC @SeDebenEvaluarPermisos = usp_VAL_Tablas__SeDebeEvaluarPermisos
														@Tabla = @Tabla
				END
				
			IF @sResSQL = '' AND @SeDebenEvaluarPermisos = '1'
				BEGIN
					EXEC @SeDebenEvaluarPermisos = usp_VAL_TablasYFuncionesDePaginas__SeDebeEvaluarPermisos
														@Tabla = @Tabla
														,@FuncionDePagina = @FuncionDePagina
				END
		END
		
		--No lo controlamos por que nos limita, pero la dejamos igual por si a futuro lo reflotamos:	
		--IF @sResSQL = ''
		--	BEGIN
		--		EXEC @EsUnaFuncionDePaginaConRegistro = usp_VAL_FuncionesDePaginas__EsUnaConRegistro
		--													@FuncionDePagina = @FuncionDePagina
		--	END
						
	RETURN COALESCE(@SeDebenEvaluarPermisos, '1')	 
END
GO
-- SP-TABLA: #Operacion# /Validaciones/ - FIN




-- SP-TABLA: Contextos /Validaciones/ - INICIO
IF (OBJECT_ID('usp_VAL_Contextos__EsElCorrespondienteDelUsuario') IS NOT NULL) DROP PROCEDURE usp_VAL_Contextos__EsElCorrespondienteDelUsuario
GO
CREATE PROCEDURE usp_VAL_Contextos__EsElCorrespondienteDelUsuario
	@UsuarioQueEjecutaId		INT
	,@CodigoDelContexto			VARCHAR(40)
	,@sResSQL					VARCHAR(1000)	OUTPUT
AS
BEGIN
	SET @sResSQL = ''
	
	SET @UsuarioQueEjecutaId = (SELECT U.id 
									FROM Usuarios U
										INNER JOIN Contextos CON ON U.ContextoId = CON.id
									WHERE 
										(U.id = @UsuarioQueEjecutaId) -- Se valida contra si mismo.
										AND (U.Activo = '1')
										AND (LOWER(CON.Codigo) = LOWER(@CodigoDelContexto)) -- Y perteneciendo al contexto ingresado.
								)
						
	IF @UsuarioQueEjecutaId IS NULL
		BEGIN
			SET @sResSQL = 'El usuario no corresponde al Contexto indicado o se encuentra inactivo para operar.'
		END 
END
GO




IF (OBJECT_ID('usp_VAL_Contextos__EsValidoDeOperacion') IS NOT NULL) DROP PROCEDURE usp_VAL_Contextos__EsValidoDeOperacion
GO
CREATE PROCEDURE usp_VAL_Contextos__EsValidoDeOperacion
	@CodigoDelContexto					VARCHAR(40)
	,@sResSQL							VARCHAR(1000)	OUTPUT
AS
BEGIN
	SET @sResSQL = ''

	DECLARE @EsValidoDeOperacion BIT = '0'
		,@ContextoId INT
		
	SET @ContextoId = (SELECT id FROM Contextos WHERE Codigo = @CodigoDelContexto)
	
	IF @ContextoId IS NULL
		BEGIN
			SET @sResSQL = 'El contexto ingresado no existe.'
		END
	ELSE IF @ContextoId = '1'
		BEGIN
			SET @sResSQL = 'No se permite operar en el contexto ingresado.'
		END
	ELSE
		BEGIN
			SET @sResSQL = ''
			SET @EsValidoDeOperacion = '1'
		END
						
	 RETURN @EsValidoDeOperacion	 
END
GO




IF (OBJECT_ID('usp_VAL_Contextos__UsuarioPerteneceAlDelRegistro') IS NOT NULL) DROP PROCEDURE usp_VAL_Contextos__UsuarioPerteneceAlDelRegistro
GO
CREATE PROCEDURE usp_VAL_Contextos__UsuarioPerteneceAlDelRegistro
	@UsuarioId		INT
	,@Tabla			VARCHAR(80)
	,@RegistroId	INT
	,@sResSQL		VARCHAR(1000)	OUTPUT
AS
BEGIN
	SET @sResSQL = '' -- Si no le asignamos valor al inicio puede volver como NULL --> revienta al consultarla si = ''
	
	 -- Si la tabla NO tiene ContextoId, o el Usuario Pertenece a la tabla (@Tabla) --> devuelve ''
	
	IF (COL_LENGTH(@Tabla, 'ContextoId') IS NULL -- la tabla (@Tabla) NO tiene "ContextoId" --> no tiene sentido preguntar si corresponde al contexto. Responde positivamente de todas formas.
			OR @RegistroId IS NULL -- No tengo realmente un registro para constatar el Contexto --> no tiene sentido preguntar si corresponde al contexto. Responde positivamente de todas formas.
			OR @RegistroId = 0 -- Hay veces que desde .NET se pasa un 0 como equivalencia de NULO.
		)
		BEGIN
			SET @sResSQL = '' 
		END
	ELSE
		BEGIN
			DECLARE @ContextoDelUsuarioId INT = (SELECT ContextoId FROM Usuarios WHERE id = @UsuarioId)
			
			DECLARE @ContextoDelRegistroId INT
			
			SET NOCOUNT ON
			DECLARE @sSQL NVARCHAR(1000) --Es necesario NVARCHAR
			DECLARE @Par�metros NVARCHAR(1000) --Es necesario NVARCHAR
			SET @Par�metros = N'@RegistroId INT, @ContextoDelRegistroId INT OUTPUT'

			SELECT @sSQL = N'SELECT @ContextoDelRegistroId = ContextoId FROM ' + QUOTENAME(@Tabla) + ' WHERE id = @RegistroId'
			EXEC  sp_executesql @sSQL, @Par�metros, @ContextoDelRegistroId = @ContextoDelRegistroId OUTPUT, @RegistroId = @RegistroId

			--SELECT '@ContextoDelRegistroId = ' + Cast(@ContextoDelRegistroId as varchar)
			
			IF @ContextoDelRegistroId IS NULL
				BEGIN
					SET @sResSQL = 'No es un registro v�lido. La acci�n no puede continuar.' -- No es un registro v�lido
				END
			ELSE
				BEGIN
					IF (@ContextoDelUsuarioId = @ContextoDelRegistroId)
						BEGIN
							SET @sResSQL = '' -- La tabla (@Tabla) tiene Contexto, y el Registro de esa tabla con id = @RegistroId tiene el mismo contexto que el Usuario de id = @UsuarioId
						END
					ELSE -- El Registro es v�lido, pertenece a una tabla con ContextoId = @ContextoDelRegistroId, pero es <> del @ContextoDelUsuarioId
						BEGIN
							EXEC @sResSQL = dbo.[ufc_Respuesta__UsuarioNoPerteneceAlContexto]
						END
				END
		END
END
GO
-- SP-TABLA: Contextos /Validaciones/ - FIN




-- SP-TABLA: #Datos Ingresados# /Validaciones/ - INICIO
IF (OBJECT_ID('usp_VAL_Datos__Y_DevolverUsuario') IS NOT NULL) DROP PROCEDURE usp_VAL_Datos__Y_DevolverUsuario
GO
CREATE PROCEDURE usp_VAL_Datos__Y_DevolverUsuario
	-- Es para los casos donde se necesita que opere alguien que no est� logueado --> no tiene Usuario --> Que pase el @Contexto y le damos un Usuario Para operar en estos casos:
	(
		@UsuarioQueEjecutaId		INT
		,@Token						VARCHAR(40)
		,@Seccion					VARCHAR(30)
		,@CodigoDelContexto			VARCHAR(40)
		,@Tabla						VARCHAR(80)
		,@sResSQL					VARCHAR(1000)	OUTPUT
	)
AS
BEGIN
	SET @sResSQL = '' -- Si no le asignamos valor al inicio puede volver como NULL --> revienta al consultarla si = ''
	
	DECLARE @SeccionId INT = (SELECT id FROM Secciones WHERE Nombre = @Seccion)
		,@EsUnaOperacionDeCore BIT
		,@Seccion_Web VARCHAR(30)
		
	EXEC @Seccion_Web = ufc_Secciones__Web
	
	EXEC @EsUnaOperacionDeCore = usp_VAL_Datos__EsUnaOperacionDeCore
									@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
									,@Token	= @Token
									,@Seccion = @Seccion
									,@CodigoDelContexto = @CodigoDelContexto
									,@Tabla = @Tabla
		
	IF @EsUnaOperacionDeCore = '0' -- Si es = 1 no miramos nada m�s, ya est� validada
		BEGIN
			IF @UsuarioQueEjecutaId = '1'
				BEGIN
					IF @Seccion = @Seccion_Web -- Para realizar esta consulta el @UsuarioQueEjecutaId debe ser el que no se puede operar Y la Seccion = 'Web'
						BEGIN
							EXEC @UsuarioQueEjecutaId = usp_VAL_Usuarios__DevolverAnonimoUtilizandoCodigoDelContexto
															@CodigoDelContexto = @CodigoDelContexto
															,@sResSQL = @sResSQL OUTPUT  -- USO EL ANONIMO
						END
					ELSE	-- Ya se hab�a validado que la operaci�n no era de core
						BEGIN
							SET @sResSQL = 'La operaci�n no puede continuar. No se permite la operaci�n con el usuario y secci�n indicada.'
						END	
				END
			ELSE -- Es un usuario v�lido para operar, solo resta saber cual es su contexto.
				BEGIN
					IF @Seccion = @Seccion_Web OR @SeccionId IS NULL
						BEGIN
							SET @sResSQL = 'No se permite operar con este usuario en esta secci�n.'
						END
					ELSE
						BEGIN
							IF @CodigoDelContexto IS NULL 
								OR @CodigoDelContexto = ''
								BEGIN 
									SET @sResSQL = '' -- Va a operar con ese usurio (@UsuarioQueEjecutaId <> 1), est� OK que contin�e.
								END
							ELSE
								BEGIN -- Introdujo un contexto --> Validaremos que pertenezca al usuario ingresado (@UsuarioQueEjecutaId <> 1)
									EXEC usp_VAL_Contextos__EsElCorrespondienteDelUsuario
											@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
											,@CodigoDelContexto = @CodigoDelContexto
											,@sResSQL = @sResSQL OUTPUT
								END
						END			
				END
		END
		
	RETURN COALESCE(@UsuarioQueEjecutaId,  NULL, 0) -- No puede devolver nulo por que da error el SP.
END
GO




IF (OBJECT_ID('usp_VAL_Datos__EsUnaOperacionDeCore') IS NOT NULL) DROP PROCEDURE usp_VAL_Datos__EsUnaOperacionDeCore
GO
CREATE PROCEDURE usp_VAL_Datos__EsUnaOperacionDeCore
	(
		@UsuarioQueEjecutaId		INT
		,@Token						VARCHAR(40) = NULL
		,@Seccion					VARCHAR(30)
		,@CodigoDelContexto			VARCHAR(40)
		,@Tabla						VARCHAR(80)
	)
AS
BEGIN
	DECLARE @EsUnaOperacionDeCore BIT = '0'
	
	IF @UsuarioQueEjecutaId = '1' -- Caso especial para las tablas sin contexto, donde los valores ingresados son de "Core" --> �nico caso donde hay q utilizar el UsuarioId = 1 y no revisar permisos
			AND @Token = 'OperacionDeCore'
			--AND @Seccion IS NULL
			--AND @CodigoDelContexto IS NULL
			AND (@Tabla = 'Contextos'
					OR @Tabla = 'ExtensionesDeArchivos'
					OR @Tabla = 'Iconos'
					OR @Tabla = 'Paginas'
					OR @Tabla = 'RelAsig_RolesDeUsuarios_A_Paginas'
					OR @Tabla = 'Tablas'
				)
				-- Tambi�n podr�amos testear:  COL_LENGTH(@Tabla, 'ContextoId') IS NULL  y con esto generalizariamos todo respecto a las tablas Core.
		BEGIN
			SET @EsUnaOperacionDeCore = '1' -- Puede operar, es una operaci�n interna de Core
		END
		
	RETURN @EsUnaOperacionDeCore
END
GO
-- SP-TABLA: #Datos Ingresados# /Validaciones/ - FIN


				

-- SP-TABLA: FuncionesDePagina /Validaciones/ - INICIO
IF (OBJECT_ID('usp_VAL_FuncionesDePaginas__EsUnaConRegistro') IS NOT NULL) DROP PROCEDURE usp_VAL_FuncionesDePaginas__EsUnaConRegistro
GO
CREATE PROCEDURE usp_VAL_FuncionesDePaginas__EsUnaConRegistro
	-- Validaciones:
		--
	-------------
	-- Acotaciones:
		-- 
	-------------
	(
		@FuncionDePagina			VARCHAR(30)
	)
AS
BEGIN
	DECLARE @EsUnaConRegistro BIT = (SELECT EsUnaConRegistro FROM FuncionesDePaginas WHERE Nombre = @FuncionDePagina)
													
	RETURN @EsUnaConRegistro
END
GO




IF (OBJECT_ID('usp_VAL_FuncionesDePaginas__SeDebeEvaluarPermisos') IS NOT NULL) DROP PROCEDURE usp_VAL_FuncionesDePaginas__SeDebeEvaluarPermisos
GO
CREATE PROCEDURE usp_VAL_FuncionesDePaginas__SeDebeEvaluarPermisos
	-- Validaciones:
		--
	-------------
	-- Acotaciones:
		-- 
	-------------
	(
		@FuncionDePagina		VARCHAR(30)
	)
AS
BEGIN
	DECLARE @SeDebenEvaluarPermisos BIT = (SELECT SeDebenEvaluarPermisos FROM FuncionesDePaginas WHERE Nombre = @FuncionDePagina)
													
	RETURN COALESCE(@SeDebenEvaluarPermisos, '1')					
END
GO
-- SP-TABLA: FuncionesDePagina /Validaciones/ - FIN




-- SP-TABLA: P�ginas /Validaciones/ - INICIO
IF (OBJECT_ID('usp_VAL_Paginas__PaginaId') IS NOT NULL) DROP PROCEDURE usp_VAL_Paginas__PaginaId
GO
CREATE PROCEDURE usp_VAL_Paginas__PaginaId
	@Seccion					VARCHAR(30)
	,@Tabla						VARCHAR(80)
	,@FuncionDePagina			VARCHAR(30)
	
	,@sResSQL					VARCHAR(1000)	OUTPUT
AS
BEGIN
	SET @sResSQL = '' -- Si no le asignamos valor al inicio puede volver como NULL --> revienta al consultarla si = ''
	
	DECLARE @SeccionId INT = (SELECT id FROM Secciones WHERE Nombre = @Seccion)
	DECLARE @TablaId INT = (SELECT id FROM Tablas WHERE Nombre = @Tabla)
	DECLARE @FuncionDePaginaId INT = (SELECT id FROM FuncionesDePaginas WHERE Nombre = @FuncionDePagina)
	DECLARE @PaginaId INT = (SELECT id FROM Paginas WHERE SeccionId = @SeccionId
														AND TablaId = @TablaId 
														AND FuncionDePaginaId = @FuncionDePaginaId)
			
	IF @PaginaId IS NULL
		BEGIN
			SET @PaginaId = '0'
			SET @sResSQL = 'La p�gina no existe en la base de datos'
		END
		
	RETURN @PaginaId
END
GO




IF (OBJECT_ID('usp_VAL_Paginas__Existe') IS NOT NULL) DROP PROCEDURE usp_VAL_Paginas__Existe
GO
CREATE PROCEDURE usp_VAL_Paginas__Existe
	@Seccion					VARCHAR(30)
	,@Tabla						VARCHAR(80)
	,@FuncionDePagina			VARCHAR(30)
	
	--,@PaginaId					INT				OUTPUT  --> Devuelve la PaginaId
	--,@sResSQL					VARCHAR(1000)	OUTPUT 
AS
BEGIN
	DECLARE @Existe BIT = '0'
		,@sResSQL					VARCHAR(1000)
		
	--EXEC @PaginaId = usp_VAL_Paginas__PaginaId
	--					@Seccion = @Seccion
	--					,@Tabla = @Tabla
	--					,@FuncionDePagina = @FuncionDePagina
	--					,@sResSQL = @sResSQL OUTPUT 
						
	EXEC usp_VAL_Paginas__PaginaId
			@Seccion = @Seccion
			,@Tabla = @Tabla
			,@FuncionDePagina = @FuncionDePagina
			,@sResSQL = @sResSQL OUTPUT 
			
	IF @sResSQL = ''
		BEGIN
			SET @Existe = '1'
		END
		
	RETURN @Existe
END
GO




IF (OBJECT_ID('usp_VAL_Paginas__ExisteYEsDeSeccionAdministracion') IS NOT NULL) DROP PROCEDURE usp_VAL_Paginas__ExisteYEsDeSeccionAdministracion
GO
CREATE PROCEDURE usp_VAL_Paginas__ExisteYEsDeSeccionAdministracion
	@Seccion					VARCHAR(30)
	,@Tabla						VARCHAR(80)
	,@FuncionDePagina			VARCHAR(30)
	
	,@sResSQL					VARCHAR(1000)	OUTPUT
AS
BEGIN
	DECLARE @ExisteYEsDeSeccionAdministracion BIT = '0'
		,@PaginaId INT
		,@Seccion_Administracion VARCHAR(30)
		
	EXEC @Seccion_Administracion = ufc_Secciones__Administracion
		
	SET @sResSQL = '' -- Si no le asignamos valor al inicio puede volver como NULL --> revienta al consultarla si = ''
	
	EXEC @PaginaId = usp_VAL_Paginas__PaginaId
						@Seccion = @Seccion
						,@Tabla = @Tabla
						,@FuncionDePagina = @FuncionDePagina
						,@sResSQL = @sResSQL OUTPUT 
			
	IF @sResSQL = '' AND @Seccion = @Seccion_Administracion
		BEGIN	
			SET @ExisteYEsDeSeccionAdministracion = '1'
		END
		
	RETURN @ExisteYEsDeSeccionAdministracion
END
GO




IF (OBJECT_ID('usp_VAL_Paginas__ExisteYEsDeSeccionIntranet') IS NOT NULL) DROP PROCEDURE usp_VAL_Paginas__ExisteYEsDeSeccionIntranet
GO
CREATE PROCEDURE usp_VAL_Paginas__ExisteYEsDeSeccionIntranet
	@Seccion					VARCHAR(30)
	,@Tabla						VARCHAR(80)
	,@FuncionDePagina			VARCHAR(30)
	
	,@sResSQL					VARCHAR(1000)	OUTPUT
AS
BEGIN
	DECLARE @ExisteYEsDeSeccionIntranet BIT = '0'
		,@PaginaId INT
		,@Seccion_Intranet VARCHAR(30)
		
	EXEC @Seccion_Intranet = ufc_Secciones__Intranet
		
	SET @sResSQL = '' -- Si no le asignamos valor al inicio puede volver como NULL --> revienta al consultarla si = ''
	
	EXEC @PaginaId = usp_VAL_Paginas__PaginaId
						@Seccion = @Seccion
						,@Tabla = @Tabla
						,@FuncionDePagina = @FuncionDePagina
						,@sResSQL = @sResSQL OUTPUT 
			
	IF @sResSQL = '' AND @Seccion = @Seccion_Intranet
		BEGIN	
			SET @ExisteYEsDeSeccionIntranet = '1'
		END
		
	RETURN @ExisteYEsDeSeccionIntranet
END
GO




IF (OBJECT_ID('usp_VAL_Paginas__ExisteYEsDeSeccionWeb') IS NOT NULL) DROP PROCEDURE usp_VAL_Paginas__ExisteYEsDeSeccionWeb
GO
CREATE PROCEDURE usp_VAL_Paginas__ExisteYEsDeSeccionWeb
	@Seccion					VARCHAR(30)
	,@Tabla						VARCHAR(80)
	,@FuncionDePagina			VARCHAR(30)
	
	,@sResSQL					VARCHAR(1000)	OUTPUT
AS
BEGIN
	DECLARE @ExisteYEsDeSeccionWeb BIT = '0'
		,@PaginaId INT
		,@Seccion_Web VARCHAR(30)
		
	EXEC @Seccion_Web = ufc_Secciones__Web
		
	SET @sResSQL = '' -- Si no le asignamos valor al inicio puede volver como NULL --> revienta al consultarla si = ''
	
	EXEC @PaginaId = usp_VAL_Paginas__PaginaId
						@Seccion = @Seccion
						,@Tabla = @Tabla
						,@FuncionDePagina = @FuncionDePagina
						,@sResSQL = @sResSQL OUTPUT 
			
	IF @sResSQL = '' AND @Seccion = @Seccion_Web
		BEGIN	
			SET @ExisteYEsDeSeccionWeb = '1'
		END
		
	RETURN @ExisteYEsDeSeccionWeb
END
GO




IF (OBJECT_ID('usp_VAL_Paginas__ExisteYEsDeSeccionPrivadaDelUsuario') IS NOT NULL) DROP PROCEDURE usp_VAL_Paginas__ExisteYEsDeSeccionPrivadaDelUsuario
GO
CREATE PROCEDURE usp_VAL_Paginas__ExisteYEsDeSeccionPrivadaDelUsuario
	@Seccion					VARCHAR(30)
	,@Tabla						VARCHAR(80)
	,@FuncionDePagina			VARCHAR(30)
	
	,@sResSQL					VARCHAR(1000)	OUTPUT
AS
BEGIN
	DECLARE @ExisteYEsDeSeccionPrivadaDelUsuario BIT = '0'
		,@PaginaId INT
		,@Seccion_PrivadaDelUsuario VARCHAR(30)
		
	EXEC @Seccion_PrivadaDelUsuario = ufc_Secciones__PrivadaDelUsuario
		
	SET @sResSQL = '' -- Si no le asignamos valor al inicio puede volver como NULL --> revienta al consultarla si = ''
	
	EXEC @PaginaId = usp_VAL_Paginas__PaginaId
						@Seccion = @Seccion
						,@Tabla = @Tabla
						,@FuncionDePagina = @FuncionDePagina
						,@sResSQL = @sResSQL OUTPUT 
			
	IF @sResSQL = '' AND @Seccion = @Seccion_PrivadaDelUsuario
		BEGIN	
			SET @ExisteYEsDeSeccionPrivadaDelUsuario = '1'
		END
		
	RETURN @ExisteYEsDeSeccionPrivadaDelUsuario
END
GO
-- SP-TABLA: P�ginas /Validaciones/ - FIN




-- SP-TABLA: RolesDeUsuarios /Validaciones/ - INICIO
	--
-- SP-TABLA: RolesDeUsuarios /Validaciones/ - FIN




-- SP-TABLA: Secciones /Validaciones/ - INICIO
IF (OBJECT_ID('usp_VAL_Secciones__CorrespondeATextosPrivados') IS NOT NULL) DROP PROCEDURE usp_VAL_Secciones__CorrespondeATextosPrivados
GO
CREATE PROCEDURE usp_VAL_Secciones__CorrespondeATextosPrivados
	-- Validaciones:
		--
	-------------
	-- Acotaciones:
		-- 
	-------------
	(
		@Seccion					VARCHAR(30)
		,@TextoPrivado				VARCHAR(80) OUTPUT
	)
AS
BEGIN
	DECLARE	@Seccion_Administracion VARCHAR(30)
			,@Seccion_Intranet VARCHAR(30)
			,@Seccion_Web VARCHAR(30)
			,@Seccion_PrivadaDelUsuario VARCHAR(30)
			
		EXEC @Seccion_Administracion = ufc_Secciones__Administracion
		EXEC @Seccion_Intranet = ufc_Secciones__Intranet
		EXEC @Seccion_Web = ufc_Secciones__Web
		EXEC @Seccion_PrivadaDelUsuario = ufc_Secciones__PrivadaDelUsuario
		
		SELECT @TextoPrivado = CASE WHEN @Seccion = @Seccion_Web OR @Seccion = @Seccion_PrivadaDelUsuario THEN '-Privado-' ELSE '' END
END
GO




IF (OBJECT_ID('usp_VAL_Secciones__EsLaPrivadaDelUsuarioYRegistroPropio') IS NOT NULL) DROP PROCEDURE usp_VAL_Secciones__EsLaPrivadaDelUsuarioYRegistroPropio
GO
CREATE PROCEDURE usp_VAL_Secciones__EsLaPrivadaDelUsuarioYRegistroPropio
	-- Validaciones:
	-- 1) Que el @UsuarioQueEjecutaId = al UsuarioId del @RegistroId que corresponde a la tabla @Tabla.
	-- 2) Que la Seccion = "PrivadaDelUsuario".
	-------------
	-- Acotaciones:
		-- 
	-------------
	(
		@UsuarioQueEjecutaId		INT
		,@Seccion					VARCHAR(30)
		,@RegistroId				INT				-- De la tabla @Tabla
		,@Tabla						VARCHAR(80)		-- La cual deber� tener UsuarioId
		,@sResSQL					VARCHAR(1000)	OUTPUT
	)
AS
BEGIN
	SET @sResSQL = '' -- Si no le asignamos valor al inicio puede volver como NULL --> revienta al consultarla si = ''
	
	DECLARE @SeccionId INT = (SELECT id FROM Secciones WHERE Nombre = @Seccion)
	IF @SeccionId IS NULL
		BEGIN
			 SET @sResSQL = 'No existe la secci�n'
		END
	ELSE IF @SeccionId <> '4'
		BEGIN
			SET @sResSQL = 'La secci�n no es la privada del usuario'
		END
		
	IF @sResSQL = ''
		BEGIN
			EXEC usp_VAL_Usuarios__CorrespondeAlDelRegistro
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					,@RegistroId = @RegistroId
					,@Tabla = @Tabla
					,@sResSQL = @sResSQL OUTPUT
		END
END
GO




IF (OBJECT_ID('usp_VAL_Secciones__EsLaPrivadaDelUsuario') IS NOT NULL) DROP PROCEDURE usp_VAL_Secciones__EsLaPrivadaDelUsuario
GO
CREATE PROCEDURE usp_VAL_Secciones__EsLaPrivadaDelUsuario
	-- Validaciones:
		--
	-------------
	-- Acotaciones:
		-- 
	-------------
	(
		@Seccion							VARCHAR(30)
		,@sResSQL							VARCHAR(1000)	OUTPUT
	)
AS
BEGIN
	SET @sResSQL = '' -- Si no le asignamos valor al inicio puede volver como NULL --> revienta al consultarla si = ''
	
	DECLARE @SeccionId INT = (SELECT id FROM Secciones WHERE Nombre = @Seccion)
		,@EsLaSeccionPrivadaDelUsuario BIT = '0'
		
	IF @SeccionId IS NULL
		BEGIN
			 SET @sResSQL = 'No existe la secci�n'
		END
	ELSE IF @SeccionId = '4'
		BEGIN
			SET @EsLaSeccionPrivadaDelUsuario = '1'
		END
	ELSE
		BEGIN
			SET @EsLaSeccionPrivadaDelUsuario = '0'
		END
		
	RETURN @EsLaSeccionPrivadaDelUsuario
END
GO




IF (OBJECT_ID('usp_VAL_Secciones__EsLaWeb') IS NOT NULL) DROP PROCEDURE usp_VAL_Secciones__EsLaWeb
GO
CREATE PROCEDURE usp_VAL_Secciones__EsLaWeb
	-- Validaciones:
		--
	-------------
	-- Acotaciones:
		-- 
	-------------
	(
		@Seccion							VARCHAR(30)
		,@sResSQL							VARCHAR(1000)	OUTPUT
	)
AS
BEGIN
	SET @sResSQL = '' -- Si no le asignamos valor al inicio puede volver como NULL --> revienta al consultarla si = ''
	
	DECLARE @SeccionId INT = (SELECT id FROM Secciones WHERE Nombre = @Seccion)
		,@EsLaSeccionWeb BIT
		
	IF @SeccionId IS NULL
		BEGIN
			 SET @sResSQL = 'No existe la secci�n'
		END
	ELSE IF @SeccionId = '3'
		BEGIN
			SET @EsLaSeccionWeb = '1'
		END
	ELSE
		BEGIN
			SET @EsLaSeccionWeb = '0'
		END
		
	RETURN @EsLaSeccionWeb
END
GO
-- SP-TABLA: Secciones /Validaciones/ - FIN




-- SP-TABLA: SPs /Validaciones/ - INICIO
IF (OBJECT_ID('usp_VAL_SPs__ValorDeEntradaDeID') IS NOT NULL) DROP PROCEDURE usp_VAL_SPs__ValorDeEntradaDeID
GO
CREATE PROCEDURE usp_VAL_SPs__ValorDeEntradaDeID
	-- Validaciones:
		--
	-------------
	-- Acotaciones:
		-- 
	-------------
	(
		@SP					VARCHAR(80)
		,@FuncionDePagina	VARCHAR(30) = 'Insert'
		,@id				INT		OUTPUT
	)
AS
BEGIN
	-- Si en el SP que llama, @id es de entrada y de Insert --> lo limpio
	IF (SELECT s.is_output 
			FROM sys.parameters s
			--JOIN sys.types t ON s.system_type_id = t.user_type_id
			WHERE object_id = object_id(@SP)
				AND s.name = '@id'
			) = '1'
			AND @FuncionDePagina = 'Insert'
		BEGIN
			SET @id = NULL
		END
END
GO




IF (OBJECT_ID('usp_VAL_SPs__SeDebeEvaluarPermisos') IS NOT NULL) DROP PROCEDURE usp_VAL_SPs__SeDebeEvaluarPermisos
GO
CREATE PROCEDURE usp_VAL_SPs__SeDebeEvaluarPermisos
	-- Validaciones:
		--
	-------------
	-- Acotaciones:
		-- 
	-------------
	(
		@SP					VARCHAR(80)
	)
AS
BEGIN
	DECLARE @SeDebenEvaluarPermisos BIT = (SELECT SeDebenEvaluarPermisos FROM Sps WHERE Nombre = @SP)
	
	RETURN COALESCE(@SeDebenEvaluarPermisos, '1')						
END
GO
-- SP-TABLA: SPs /Validaciones/ - FIN




-- SP-TABLA: Tablas /Validaciones/ - INICIO
IF (OBJECT_ID('usp_VAL_Tablas__SeDebeEvaluarPermisos') IS NOT NULL) DROP PROCEDURE usp_VAL_Tablas__SeDebeEvaluarPermisos
GO
CREATE PROCEDURE usp_VAL_Tablas__SeDebeEvaluarPermisos
	-- Validaciones:
		--
	-------------
	-- Acotaciones:
		-- 
	-------------
	(
		@Tabla					VARCHAR(80)
	)
AS
BEGIN
	DECLARE @SeDebenEvaluarPermisos BIT = (SELECT SeDebenEvaluarPermisos FROM Tablas WHERE Nombre = @Tabla)
		
	RETURN COALESCE(@SeDebenEvaluarPermisos, '1')					
END
GO




IF (OBJECT_ID('usp_VAL_Tablas__PermiteEliminarSusRegistros') IS NOT NULL) DROP PROCEDURE usp_VAL_Tablas__PermiteEliminarSusRegistros
GO
CREATE PROCEDURE usp_VAL_Tablas__PermiteEliminarSusRegistros
	-- Validaciones:
		--
	-------------
	-- Acotaciones:
		-- 
	-------------
	(
		@Tabla					VARCHAR(80)
	)
AS
BEGIN
	DECLARE @SeDebenEvaluarPermisos BIT = (SELECT SeDebenEvaluarPermisos FROM Tablas WHERE Nombre = @Tabla)
		
	RETURN COALESCE(@SeDebenEvaluarPermisos, '1')					
END
GO
-- SP-TABLA: Tablas /Validaciones/ - FIN




-- SP-TABLA: TablasYFuncionesDePaginas /Validaciones/ - INICIO
IF (OBJECT_ID('usp_VAL_TablasYFuncionesDePaginas__SeDebeEvaluarPermisos') IS NOT NULL) DROP PROCEDURE usp_VAL_TablasYFuncionesDePaginas__SeDebeEvaluarPermisos
GO
CREATE PROCEDURE usp_VAL_TablasYFuncionesDePaginas__SeDebeEvaluarPermisos
	-- Validaciones:
		--
	-------------
	-- Acotaciones:
		-- 
	-------------
	(
		@Tabla					VARCHAR(80)
		,@FuncionDePagina		VARCHAR(30)
	)
AS
BEGIN
	DECLARE @SeDebenEvaluarPermisos BIT = (SELECT TyFDP.SeDebenEvaluarPermisos FROM TablasYFuncionesDePaginas TyFDP 
																				INNER JOIN Tablas T ON TyFDP.TablaId = T.id
																				INNER JOIN FuncionesDePaginas FDP ON TyFDP.FuncionDePaginaId = FDP.id
																				WHERE T.Nombre = @Tabla
																					AND FDP.Nombre = @FuncionDePagina
																				)
	
	RETURN COALESCE(@SeDebenEvaluarPermisos, '1')
END
GO
-- SP-TABLA: TablasYFuncionesDePaginas /Validaciones/ - FIN




-- SP-TABLA: Usuarios /Validaciones/ - INICIO
IF (OBJECT_ID('usp_VAL_Usuarios__CorrespondeAlDelRegistro') IS NOT NULL) DROP PROCEDURE usp_VAL_Usuarios__CorrespondeAlDelRegistro
GO
CREATE PROCEDURE usp_VAL_Usuarios__CorrespondeAlDelRegistro
	-- Validaciones:
		-- 1) Que el @UsuarioQueEjecutaId = al UsuarioId del @RegistroId que corresponde a la tabla @Tabla.
		-- 2) NO SE VALIDA LA SECCION.
	-------------
	-- Acotaciones:
		-- 
	-------------
	(
		@UsuarioQueEjecutaId		INT
		,@RegistroId				INT				-- De la tabla @Tabla
		,@Tabla						VARCHAR(80)		-- La cual deber� tener UsuarioId
		,@sResSQL					VARCHAR(1000)	OUTPUT
	)
AS
BEGIN
	SET @sResSQL = '' -- Si no le asignamos valor al inicio puede volver como NULL --> revienta al consultarla si = ''
	
	DECLARE @TablaId INT = (SELECT id FROM Tablas WHERE Nombre = @Tabla)
		,@sSQL NVARCHAR(1000)
		,@Par�metros NVARCHAR(1000)
		,@UsuarioId INT
		
	IF @TablaId IS NULL
		BEGIN
			SET @sResSQL = 'La tabla no existe en la base de datos.' 
		END
	
	IF @sResSQL = '' AND @Tabla = 'Usuarios' -- Es la propia tabla usuarios
		BEGIN
			SET @UsuarioId = (SELECT id FROM Usuarios WHERE id = @RegistroId)
			
			IF @UsuarioId IS NULL OR (@UsuarioId <> @UsuarioQueEjecutaId)
				BEGIN
					SET @sResSQL = 'El registro seleccionado no corresponde al Usuario.' 
				END
		END
	ELSE
		BEGIN
			IF COL_LENGTH(@Tabla, 'UsuarioId') IS NULL -- La tabla no tiene ese campo
				BEGIN
					SET @sResSQL = 'La tabla no tiene UsuarioId' 
				END
			
			IF @sResSQL = ''
				BEGIN
					SET @Par�metros = N'@RegistroId INT, @UsuarioId INT OUTPUT'
					SELECT @sSQL = N' SELECT @UsuarioId = @UsuarioId FROM ' + QUOTENAME(@Tabla) + ' WHERE id = @RegistroId'
					EXEC  sp_executesql @sSQL, @Par�metros, @RegistroId = @RegistroId, @UsuarioId = @UsuarioId OUTPUT
					
					IF @UsuarioId IS NULL OR (@UsuarioId <> @UsuarioQueEjecutaId)
						BEGIN
							SET @sResSQL = 'El registro seleccionado no corresponde al Usuario.' 
						END
				END
		END
END
GO




IF (OBJECT_ID('usp_VAL_Usuarios__DevolverAnonimoUtilizandoCodigoDelContexto') IS NOT NULL) DROP PROCEDURE usp_VAL_Usuarios__DevolverAnonimoUtilizandoCodigoDelContexto
GO
CREATE PROCEDURE usp_VAL_Usuarios__DevolverAnonimoUtilizandoCodigoDelContexto
	-- Es para los casos donde se necesita que opere alguien que no est� logueado --> no tiene Usuario --> Que pase el @Contexto y le damos un Usuario Para operar en estos casos:
	(
		@CodigoDelContexto					VARCHAR(40)
		,@sResSQL							VARCHAR(1000)	OUTPUT
	)
AS
BEGIN
	SET @sResSQL = '' -- Si no le asignamos valor al inicio puede volver como NULL --> revienta al consultarla si = ''
	
	DECLARE @UsuarioAnonimoId INT
		
	SET @UsuarioAnonimoId = (SELECT U.id 
								FROM Usuarios U
									INNER JOIN Contextos CON ON U.ContextoId = CON.id
								WHERE 
									(U.UserName = 'anonimo') -- NO VA MAS EL USUARIO ADMIN AN�NIMO, LO HACEMOS CON ESTE.
									--AND (U.Activo = '1')
									AND (LOWER(CON.Codigo) = LOWER(@CodigoDelContexto))
							)
	IF @UsuarioAnonimoId IS NULL
		BEGIN
			SET @sResSQL = 'La operaci�n no puede continuar. No es un contexto v�lido o no existe el usuario an�nimo para hacerlo.'
		END	
		
	RETURN COALESCE(@UsuarioAnonimoId,  NULL, 0) -- No puede devolver nulo por que da error el SP.
END
GO




IF (OBJECT_ID('usp_VAL_Usuarios__DevolverAnonimoUtilizandoUsuarioId') IS NOT NULL) DROP PROCEDURE usp_VAL_Usuarios__DevolverAnonimoUtilizandoUsuarioId
GO
CREATE PROCEDURE usp_VAL_Usuarios__DevolverAnonimoUtilizandoUsuarioId
	(
		@UsuarioId INT
		,@sResSQL VARCHAR(1000)	OUTPUT
	)
AS
BEGIN
	DECLARE @UsuarioAnonimoId INT
	DECLARE @CodigoDelContexto VARCHAR(40) = (SELECT C.Codigo FROM Contextos C
																	INNER JOIN Usuarios U ON U.ContextoId = C.id
																 WHERE U.id = @UsuarioId
													)
		
	EXEC @UsuarioAnonimoId = usp_VAL_Usuarios__DevolverAnonimoUtilizandoCodigoDelContexto
									@CodigoDelContexto = @CodigoDelContexto
									,@sResSQL = @sResSQL OUTPUT
		
	RETURN @UsuarioAnonimoId
END
GO



IF (OBJECT_ID('usp_VAL_Usuarios__SeMuestraEnAsignacionDeRolesYPermisos') IS NOT NULL) DROP PROCEDURE usp_VAL_Usuarios__SeMuestraEnAsignacionDeRolesYPermisos
GO
CREATE PROCEDURE usp_VAL_Usuarios__SeMuestraEnAsignacionDeRolesYPermisos
	-- Validaciones:
	-- 1) Verifico si el usuario puede ver los roles de acuerdo a si ellos se muestran en la asignaci�n de Permisos (A P�ginas) o en la asignaci�n de los propios roles a los usuarios.
	-------------
	-- Acotaciones:
		-- 
	-------------
	(
		@UsuarioQueEjecutaId		INT
		,@FechaDeEjecucion          DATETIME
		
		,@SeMuestraEnAsignacionDePermisos BIT	OUTPUT	-- Roles A P�ginas	
		,@SeMuestraEnAsignacionDeRoles BIT	OUTPUT		-- Roles A Usuarios	
	)
AS
BEGIN
	DECLARE @TieneElRolMasterAdmin BIT
		--,@TieneElRolAdministrador BIT // No le vamos a dar excepci�n al administrador
				
	EXEC @TieneElRolMasterAdmin = usp_VAL_Usuarios__TieneElRolMasterAdmin
									@UsuarioId = @UsuarioQueEjecutaId
									,@FechaDeEjecucion = @FechaDeEjecucion
									
	--EXEC @TieneElRolAdministrador = usp_VAL_Usuarios__TieneElRolAdministrador
	--									@UsuarioId = @UsuarioQueEjecutaId
	--									,@FechaDeEjecucion = @FechaDeEjecucion				


	IF @TieneElRolMasterAdmin = '1'
		BEGIN
			SET @SeMuestraEnAsignacionDePermisos = NULL --> Se ven ambos, con = 0 y con = 1
		END
	ELSE
		BEGIN
			SET @SeMuestraEnAsignacionDePermisos = '1' --> Solo ver� los que esten = 1
		END
		
	IF @TieneElRolMasterAdmin = '1' --OR @TieneElRolAdministrador = '1'
		BEGIN
			SET @SeMuestraEnAsignacionDeRoles = NULL --> Se ven ambos, con = 0 y con = 1
		END
	ELSE
		BEGIN
			SET @SeMuestraEnAsignacionDeRoles = '1' --> Solo ver� los que esten = 1
		END
END
GO




IF (OBJECT_ID('usp_VAL_Usuarios__SeMuestraEnAsignacionDePermisos') IS NOT NULL) DROP PROCEDURE usp_VAL_Usuarios__SeMuestraEnAsignacionDePermisos
GO
CREATE PROCEDURE usp_VAL_Usuarios__SeMuestraEnAsignacionDePermisos
	-- Validaciones:
	-- 1) Verifico si el usuario puede ver los permisos asignados de los roles a las p�ginas.
	-------------
	-- Acotaciones:
		-- 
	-------------
	(
		@UsuarioQueEjecutaId		INT
		,@FechaDeEjecucion          DATETIME
		
		,@SeMuestraEnAsignacionDePermisos BIT	OUTPUT		-- Permisos a las P�ginas
	)
AS
BEGIN
	DECLARE @SeMuestraEnAsignacionDeRoles BIT		-- Roles A Usuarios	// lo declaro pero luego no lo uso en la salida
			
	EXEC usp_VAL_Usuarios__SeMuestraEnAsignacionDeRolesYPermisos
			@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
			, @FechaDeEjecucion = @FechaDeEjecucion
			, @SeMuestraEnAsignacionDePermisos = @SeMuestraEnAsignacionDePermisos OUTPUT -- SOLO ESTE SE DEVUELVE
			, @SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OUTPUT 
END
GO




IF (OBJECT_ID('usp_VAL_Usuarios__SeMuestraEnAsignacionDeRoles') IS NOT NULL) DROP PROCEDURE usp_VAL_Usuarios__SeMuestraEnAsignacionDeRoles
GO
CREATE PROCEDURE usp_VAL_Usuarios__SeMuestraEnAsignacionDeRoles
	-- Validaciones:
	-- 1) Verifico si el usuario puede ver los roles de acuerdo a si ellos se muestran en la asignaci�n de Permisos (A P�ginas) o en la asignaci�n de los propios roles a los usuarios.
	-------------
	-- Acotaciones:
		-- 
	-------------
	(
		@UsuarioQueEjecutaId		INT
		,@FechaDeEjecucion          DATETIME
		
		,@SeMuestraEnAsignacionDeRoles BIT	OUTPUT		-- Roles A Usuarios	
	)
AS
BEGIN
	DECLARE @SeMuestraEnAsignacionDePermisos BIT		-- Roles A P�ginas	// lo declaro pero luego no lo uso en la salida
			
	EXEC usp_VAL_Usuarios__SeMuestraEnAsignacionDeRolesYPermisos  -- Validamos si puede ver los roles o no.
			@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
			, @FechaDeEjecucion = @FechaDeEjecucion
			, @SeMuestraEnAsignacionDePermisos = @SeMuestraEnAsignacionDePermisos OUTPUT
			, @SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OUTPUT -- SOLO ESTE SE DEVUELVE
END
GO




IF (OBJECT_ID('usp_VAL_Usuarios__MismoContexto') IS NOT NULL) DROP PROCEDURE usp_VAL_Usuarios__MismoContexto
GO
CREATE PROCEDURE usp_VAL_Usuarios__MismoContexto
	(
		@Usuario1Id INT
		,@Usuario2Id INT
	)
AS
BEGIN
	DECLARE @MismoContexto BIT = '0'
		
	IF (SELECT ContextoId FROM Usuarios WHERE id = @Usuario1Id) = (SELECT ContextoId FROM Usuarios WHERE id = @Usuario2Id)
		BEGIN
			SET @MismoContexto = '1'
		END	
		
	RETURN @MismoContexto
END
GO




IF (OBJECT_ID('usp_VAL_Usuarios__PuedeModificarAlUsuario') IS NOT NULL) DROP PROCEDURE usp_VAL_Usuarios__PuedeModificarAlUsuario
GO
CREATE PROCEDURE usp_VAL_Usuarios__PuedeModificarAlUsuario
	-- Validaciones:
	-- 1) Verifico si el usuario puede modificar los datos del usuario en cuesti�n (verifica si el usuario es reservado).
	-------------
	-- Acotaciones:
		-- 
	-------------
	(
		@UsuarioQueEjecutaId		INT
		,@FechaDeEjecucion          DATETIME
		
		,@UsuarioId					INT -- Usuario contra el q va a chequear si puede modificarlo
		
		,@sResSQL							VARCHAR(1000)	OUTPUT
	)
AS
BEGIN
	SET @sResSQL = ''
	
	DECLARE @SeMuestraEnAsignacionDeRoles BIT		-- Roles A Usuarios	
	EXEC usp_VAL_Usuarios__SeMuestraEnAsignacionDeRoles
			@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
			, @FechaDeEjecucion = @FechaDeEjecucion
			, @SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OUTPUT
	
	SET @SeMuestraEnAsignacionDeRoles = CASE WHEN @SeMuestraEnAsignacionDeRoles IS NULL THEN '0' ELSE @SeMuestraEnAsignacionDeRoles END -- Para evitar errores al comparar con null.
		
	IF (SELECT SeMuestraEnAsignacionDeRoles FROM Usuarios WHERE id = @UsuarioId) = '0' -- Es un usuario reservado
		AND @SeMuestraEnAsignacionDeRoles = '1' -- El usuario solo tiene permiso de ver los = 1
		BEGIN
			SET @sResSQL = 'Es un usuario reservado y no se permite modificarlo'
		END	
END
GO




IF (OBJECT_ID('usp_VAL_Usuarios__PuedeModificarElRolAsigALaPagina') IS NOT NULL) DROP PROCEDURE usp_VAL_Usuarios__PuedeModificarElRolAsigALaPagina
GO
CREATE PROCEDURE usp_VAL_Usuarios__PuedeModificarElRolAsigALaPagina
	-- Validaciones:
	-- 1) Verifico si el usuario puede modificar los roles que tiene asignado el usuario en cuesti�n.
		-- 1a)verifica si el rol a asgnarle es un rol reservado (@SeMuestraEnAsignacionDeRoles = '0').
		-- 1b)verifica si el usuario es reservado (@SeMuestraEnAsignacionDeRoles = '0').
	-------------
	-- Acotaciones:
		-- 
	-------------
	(
		@UsuarioQueEjecutaId		INT
		,@FechaDeEjecucion          DATETIME
		
		,@RolDeUsuarioId			INT
		,@PaginaId					INT	
		
		,@sResSQL							VARCHAR(1000)	OUTPUT
	)
AS
BEGIN
	SET @sResSQL = ''
	
	DECLARE @SeMuestraEnAsignacionDePermisos BIT		-- Roles A P�ginas
			
	EXEC usp_VAL_Usuarios__SeMuestraEnAsignacionDePermisos  -- Validamos si puede ver los roles o no.
			@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
			, @FechaDeEjecucion = @FechaDeEjecucion
			, @SeMuestraEnAsignacionDePermisos = @SeMuestraEnAsignacionDePermisos OUTPUT
	
	SET @SeMuestraEnAsignacionDePermisos = CASE WHEN @SeMuestraEnAsignacionDePermisos IS NULL THEN '0' ELSE @SeMuestraEnAsignacionDePermisos END -- Para evitar errores al comparar con null.
		
	IF (SELECT @SeMuestraEnAsignacionDePermisos FROM RolesDeUsuarios WHERE id = @RolDeUsuarioId) = '0' -- Es un rol reservado
		AND @SeMuestraEnAsignacionDePermisos = '1' -- El usuario solo tiene permiso de ver los = 1
		BEGIN
			SET @sResSQL = 'Es un rol reservado y no se permite asign�rselo a un usuario'
		END
		
	IF (SELECT SeMuestraEnAsignacionDePermisos FROM Paginas WHERE id = @PaginaId) = '0' -- Es una p�gina reservada
		AND @SeMuestraEnAsignacionDePermisos = '1' -- El usuario solo tiene permiso de ver los = 1
		BEGIN
			SET @sResSQL = 'Es una p�gina reservada y no se permite modificarla'
		END		
END
GO




IF (OBJECT_ID('usp_VAL_Usuarios__PuedeModificarElRolDelUsuario') IS NOT NULL) DROP PROCEDURE usp_VAL_Usuarios__PuedeModificarElRolDelUsuario
GO
CREATE PROCEDURE usp_VAL_Usuarios__PuedeModificarElRolDelUsuario
	-- Validaciones:
	-- 1) Verifico si el usuario puede modificar los roles que tiene asignado el usuario en cuesti�n.
		-- 1a)verifica si el rol a asgnarle es un rol reservado (@SeMuestraEnAsignacionDeRoles = '0').
		-- 1b)verifica si el usuario es reservado (@SeMuestraEnAsignacionDeRoles = '0').
	-------------
	-- Acotaciones:
		-- 
	-------------
	(
		@UsuarioQueEjecutaId		INT
		,@FechaDeEjecucion          DATETIME
		
		,@RolDeUsuarioId			INT	
		,@UsuarioId					INT -- Usuario contra el q va a chequear 
		
		,@sResSQL							VARCHAR(1000)	OUTPUT
	)
AS
BEGIN
	SET @sResSQL = ''
	
	DECLARE @SeMuestraEnAsignacionDeRoles BIT		-- Roles A Usuarios	
		,@SeMuestraEnAsignacionDePermisos BIT		-- Roles A P�ginas
			
	EXEC usp_VAL_Usuarios__SeMuestraEnAsignacionDeRolesYPermisos  -- Validamos si puede ver los roles o no.
			@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
			, @FechaDeEjecucion = @FechaDeEjecucion
			, @SeMuestraEnAsignacionDePermisos = @SeMuestraEnAsignacionDePermisos OUTPUT
			, @SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OUTPUT
	
	SET @SeMuestraEnAsignacionDePermisos = CASE WHEN @SeMuestraEnAsignacionDePermisos IS NULL THEN '0' ELSE @SeMuestraEnAsignacionDePermisos END -- Para evitar errores al comparar con null.
	SET @SeMuestraEnAsignacionDeRoles = CASE WHEN @SeMuestraEnAsignacionDeRoles IS NULL THEN '0' ELSE @SeMuestraEnAsignacionDeRoles END -- Para evitar errores al comparar con null.
		
	IF (SELECT @SeMuestraEnAsignacionDePermisos FROM RolesDeUsuarios WHERE id = @RolDeUsuarioId) = '0' -- Es un rol reservado
		AND @SeMuestraEnAsignacionDePermisos = '1' -- El usuario solo tiene permiso de ver los = 1
		BEGIN
			SET @sResSQL = 'Es un rol reservado y no se permite asign�rselo a un usuario'
		END
		
	IF (SELECT SeMuestraEnAsignacionDeRoles FROM Usuarios WHERE id = @UsuarioId) = '0' -- Es un usuario reservado
		AND @SeMuestraEnAsignacionDeRoles = '1' -- El usuario solo tiene permiso de ver los = 1
		BEGIN
			SET @sResSQL = 'Es un usuario reservado y no se permite modificarlo'
		END	
END
GO




IF (OBJECT_ID('usp_VAL_Usuarios__PuedeModificarLosRolesAsigALaPagina') IS NOT NULL) DROP PROCEDURE usp_VAL_Usuarios__PuedeModificarLosRolesAsigALaPagina
GO
CREATE PROCEDURE usp_VAL_Usuarios__PuedeModificarLosRolesAsigALaPagina
	-- Validaciones:
	-- 1) Verifico si el usuario puede modificar los roles que tiene asignado el usuario en cuesti�n.
		-- 1a)verifica si ALGUNO DE LOS ROLES a asgnarle es un rol reservado (@SeMuestraEnAsignacionDeRoles = '0').
		-- 1b)verifica si el usuario es reservado (@SeMuestraEnAsignacionDeRoles = '0').
	-------------
	-- Acotaciones:
		-- 
	-------------
	(
		@UsuarioQueEjecutaId		INT
		,@FechaDeEjecucion          DATETIME
		
		,@PaginaId					INT
		
		,@RolesIdsONombresString	VARCHAR(MAX)
		
		,@sResSQL					VARCHAR(1000)	OUTPUT
	)
AS
BEGIN
	SET @sResSQL = ''
	
	DECLARE @RolDeUsuarioId INT
		,@VarcharRolDeUsuario VARCHAR(MAX)
		,@lnuPosComa INT

	WHILE LEN(@RolesIdsONombresString) > 0 AND @sResSQL = ''
	BEGIN
		SET @lnuPosComa = CHARINDEX(',', @RolesIdsONombresString) -- Buscamos el caracter separador
		IF @lnuPosComa = '0'
			BEGIN
				SET @VarcharRolDeUsuario = @RolesIdsONombresString
				SET @RolesIdsONombresString = ''
			END
		ELSE
			BEGIN
				SET @VarcharRolDeUsuario = Substring(@RolesIdsONombresString, 1  ,@lnuPosComa - 1)
				SET @RolesIdsONombresString = Substring(@RolesIdsONombresString , @lnuPosComa + 1 , LEN(@RolesIdsONombresString))
			END
		
		IF ISNUMERIC(@VarcharRolDeUsuario) = '1'
			BEGIN
				SET @RolDeUsuarioId = (SELECT id FROM RolesDeUsuarios WHERE id = @VarcharRolDeUsuario) -- Con esto, adem�s se valida q sea un id q existe // CAST(@VarcharRolDeUsuario AS INT)
			END
		ELSE
			BEGIN
				SET @RolDeUsuarioId = (SELECT id FROM RolesDeUsuarios WHERE Nombre = @VarcharRolDeUsuario)
			END
		
		EXEC usp_VAL_Usuarios__PuedeModificarElRolAsigALaPagina
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					, @FechaDeEjecucion = @FechaDeEjecucion
					, @RolDeUsuarioId = @RolDeUsuarioId
					, @PaginaId = @PaginaId
					, @sResSQL = @sResSQL OUTPUT
	END			
END
GO




IF (OBJECT_ID('usp_VAL_Usuarios__PuedeModificarLosRolesDelUsuario') IS NOT NULL) DROP PROCEDURE usp_VAL_Usuarios__PuedeModificarLosRolesDelUsuario
GO
CREATE PROCEDURE usp_VAL_Usuarios__PuedeModificarLosRolesDelUsuario
	-- Validaciones:
	-- 1) Verifico si el usuario puede modificar los roles que tiene asignado el usuario en cuesti�n.
		-- 1a)verifica si ALGUNO DE LOS ROLES a asgnarle es un rol reservado (@SeMuestraEnAsignacionDeRoles = '0').
		-- 1b)verifica si el usuario es reservado (@SeMuestraEnAsignacionDeRoles = '0').
	-------------
	-- Acotaciones:
		-- 
	-------------
	(
		@UsuarioQueEjecutaId		INT
		,@FechaDeEjecucion          DATETIME
		
		,@UsuarioId					INT -- Usuario contra el q va a chequear 
		
		,@RolesIdsONombresString	VARCHAR(MAX)	
		
		,@sResSQL					VARCHAR(1000)	OUTPUT
	)
AS
BEGIN
	SET @sResSQL = ''
	
	DECLARE @RolDeUsuarioId INT
		,@VarcharRolDeUsuario VARCHAR(MAX)
		,@lnuPosComa INT

	WHILE LEN(@RolesIdsONombresString) > 0 AND @sResSQL = ''
	BEGIN
		SET @lnuPosComa = CHARINDEX(',', @RolesIdsONombresString) -- Buscamos el caracter separador
		IF @lnuPosComa = '0'
			BEGIN
				SET @VarcharRolDeUsuario = @RolesIdsONombresString
				SET @RolesIdsONombresString = ''
			END
		ELSE
			BEGIN
				SET @VarcharRolDeUsuario = Substring(@RolesIdsONombresString, 1  ,@lnuPosComa - 1)
				SET @RolesIdsONombresString = Substring(@RolesIdsONombresString , @lnuPosComa + 1 , LEN(@RolesIdsONombresString))
			END
		
		IF ISNUMERIC(@VarcharRolDeUsuario) = '1'
			BEGIN
				SET @RolDeUsuarioId = (SELECT id FROM RolesDeUsuarios WHERE id = @VarcharRolDeUsuario) -- Con esto, adem�s se valida q sea un id q existe // CAST(@VarcharRolDeUsuario AS INT)
			END
		ELSE
			BEGIN
				SET @RolDeUsuarioId = (SELECT id FROM RolesDeUsuarios WHERE Nombre = @VarcharRolDeUsuario)
			END
		
		EXEC usp_VAL_Usuarios__PuedeModificarElRolDelUsuario -- Validamos si tiene permiso segun el usuario y el rol
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					, @FechaDeEjecucion = @FechaDeEjecucion
					, @RolDeUsuarioId = @RolDeUsuarioId
					, @UsuarioId = @UsuarioId
					, @sResSQL = @sResSQL OUTPUT
	END			
END
GO




IF (OBJECT_ID('usp_VAL_Usuarios__TieneElRol') IS NOT NULL) DROP PROCEDURE usp_VAL_Usuarios__TieneElRol
GO
CREATE PROCEDURE usp_VAL_Usuarios__TieneElRol
	@UsuarioId			INT
	,@FechaDeEjecucion	DATETIME
	
	,@Rol				VARCHAR(80)
AS
BEGIN
	DECLARE @UsuarioTieneRol BIT = '0'
	
	IF EXISTS
		(
			SELECT RARU.id FROM RelAsig_RolesDeUsuarios_A_Usuarios RARU
				INNER JOIN Usuarios U ON RARU.UsuarioId = U.id
				INNER JOIN RolesDeUsuarios RDU ON RARU.RolDeUsuarioId = RDU.id
			WHERE RARU.UsuarioId = @UsuarioId
				AND U.Activo = '1'
				AND RDU.Nombre = @Rol
				AND RARU.FechaDesde <= @FechaDeEjecucion
				AND	(RARU.FechaHasta IS NULL OR RARU.FechaHasta >= @FechaDeEjecucion)
		)
		BEGIN
			SET @UsuarioTieneRol = '1'
		END
	
	RETURN @UsuarioTieneRol
END
GO




IF (OBJECT_ID('usp_VAL_Usuarios__TieneElRolAdministrador') IS NOT NULL) DROP PROCEDURE usp_VAL_Usuarios__TieneElRolAdministrador
GO
CREATE PROCEDURE usp_VAL_Usuarios__TieneElRolAdministrador
	@UsuarioId			INT
	,@FechaDeEjecucion	DATETIME
AS
BEGIN
	DECLARE @UsuarioTieneRol BIT = '0'
		,@Rol VARCHAR(80) = dbo.ufc_RolesDeUsuarios__Administrador()
		
	EXEC @UsuarioTieneRol = usp_VAL_Usuarios__TieneElRol  
								@UsuarioId = @UsuarioId
								,@FechaDeEjecucion = @FechaDeEjecucion
								,@Rol = @Rol

	RETURN @UsuarioTieneRol
END
GO




IF (OBJECT_ID('usp_VAL_Usuarios__TieneElRolSupervisor') IS NOT NULL) DROP PROCEDURE usp_VAL_Usuarios__TieneElRolSupervisor
GO
CREATE PROCEDURE usp_VAL_Usuarios__TieneElRolSupervisor
	@UsuarioId			INT
	,@FechaDeEjecucion	DATETIME
AS
BEGIN
	DECLARE @UsuarioTieneRol BIT = '0'
		,@Rol VARCHAR(80) = dbo.ufc_RolesDeUsuarios__Supervisor()
		
	EXEC @UsuarioTieneRol = usp_VAL_Usuarios__TieneElRol  
								@UsuarioId = @UsuarioId
								,@FechaDeEjecucion = @FechaDeEjecucion
								,@Rol = @Rol

	RETURN @UsuarioTieneRol
END
GO




IF (OBJECT_ID('usp_VAL_Usuarios__TieneElRolMasterAdmin') IS NOT NULL) DROP PROCEDURE usp_VAL_Usuarios__TieneElRolMasterAdmin
GO
CREATE PROCEDURE usp_VAL_Usuarios__TieneElRolMasterAdmin
	@UsuarioId			INT
	,@FechaDeEjecucion	DATETIME
AS
BEGIN
	DECLARE @UsuarioTieneRol BIT = '0'
		,@Rol VARCHAR(80) = dbo.ufc_RolesDeUsuarios__MasterAdmin()
		
	EXEC @UsuarioTieneRol = usp_VAL_Usuarios__TieneElRol  
								@UsuarioId = @UsuarioId
								,@FechaDeEjecucion = @FechaDeEjecucion
								,@Rol = @Rol

	RETURN @UsuarioTieneRol
END
GO




IF (OBJECT_ID('usp_VAL_Usuarios__UsuarioIdPermitido') IS NOT NULL) DROP PROCEDURE usp_VAL_Usuarios__UsuarioIdPermitido
GO
CREATE PROCEDURE usp_VAL_Usuarios__UsuarioIdPermitido
	(
		@UsuarioQueEjecutaId		INT
		,@Token						VARCHAR(40)
		,@Seccion					VARCHAR(30)
		,@CodigoDelContexto			VARCHAR(40)
		,@Tabla						VARCHAR(80)
		,@UsuarioId					INT				OUTPUT
		,@RegistroId				INT
		,@sResSQL					VARCHAR(1000)	OUTPUT
	)
AS
BEGIN
	DECLARE @Seccion_PrivadaDelUsuario VARCHAR(30)
	EXEC @Seccion_PrivadaDelUsuario = ufc_Secciones__PrivadaDelUsuario
	
	SET @sResSQL = '' -- Si no le asignamos valor al inicio puede volver como NULL --> revienta al consultarla si = ''
	
	-- Ac� no validamos si la seccion es valida o corresponde al usuario, eso se valida en VAL_Operacion
	
	IF @UsuarioId = '-2' -- Hasta 1/7/2020 era '-1', pero complicaba para los filtros de Listados que usan el '-1' para "todos".
		BEGIN
			SET @UsuarioId = @UsuarioQueEjecutaId -- Hay Sps donde el UsuarioId es opcional, con Default='-1' indicando que "va" el propio @UsuarioQueEjecutaId --> si no hacemos lo siguiente dar� error al controlar mismo Contexto o permisos.
		END
	
	IF @UsuarioId IS NULL AND COL_LENGTH(@Tabla, 'UsuarioId') IS NOT NULL --> Busco ese UsuarioId que corresponde a ese registro.
		BEGIN
			DECLARE @sSQL NVARCHAR(1000)
				,@Parametros NVARCHAR(1000)
			
			SET @Parametros = N'@RegistroId INT, @UsuarioId INT OUTPUT'
			SELECT @sSQL = N' SELECT @UsuarioId = UsuarioId FROM ' + QUOTENAME(@Tabla) + ' WHERE id = @RegistroId'
			EXEC  sp_executesql @sSQL, @Parametros, @RegistroId = @RegistroId, @UsuarioId = @UsuarioId OUTPUT
		END
	
	
	IF @UsuarioId IS NOT NULL -- Tengo un usuario contra que validar
		BEGIN
			IF @Seccion = @Seccion_PrivadaDelUsuario --> Ac� controlo que sea el mismo UsuarioId:
				BEGIN
					IF @UsuarioQueEjecutaId = @UsuarioId
						BEGIN
							SET @sResSQL = '' -- Es una obviedad, pero para clarificar --> con esto salimos.
						END
					ELSE
						BEGIN
							SET @sResSQL = 'El usuario ingresado no corresponde al ejecutante.'
						END
				END
			ELSE
				BEGIN -- Para cualquier otra secci�n controlo que por lo menos el contexto sea el mismo:
					-- Si la seccion es Web --> Reemplazo al @UsuarioQueEjecutaId ingresado con el anonimom para poder realizar la comparaci�n siguiente:
					EXEC @UsuarioQueEjecutaId = usp_VAL_Datos__Y_DevolverUsuario
													@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
													,@Token = @Token
													,@Seccion = @Seccion
													,@CodigoDelContexto = @CodigoDelContexto
													,@Tabla = @Tabla
													,@sResSQL = @sResSQL	OUTPUT
							
					IF @sResSQL = '' 
						BEGIN
							DECLARE @MismoContexto BIT
							EXEC @MismoContexto = usp_VAL_Usuarios__MismoContexto
														@Usuario1Id = @UsuarioQueEjecutaId
														,@Usuario2Id = @UsuarioId
																	
							IF @MismoContexto = '0' 
								BEGIN
									SET @sResSQL = 'Los usuarios indicados no corresponden al mismo contexto.'
								END
							ELSE	
								BEGIN
									SET @sResSQL = '' -- Es una obviedad, pero para clarificar --> con esto salimos.
								END
						END
				END
		END
END
GO
-- SP-TABLA: Usuarios /Validaciones/ - FIN


-- ---------------------------------
-- Script: DB_ParticularCore__C07__Validaciones.sql - FIN
-- =====================================================
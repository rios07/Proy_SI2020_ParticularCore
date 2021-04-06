-- =====================================================
-- Descripción: SPs que controlan los permisos
-- Script: DB_ParticularCore__C08__Permisos.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO


-- SP-TABLA: Paginas /PermisosEn/ - INICIO
IF (OBJECT_ID('usp_Paginas__ElUsuarioTienePermiso') IS NOT NULL) DROP PROCEDURE usp_Paginas__ElUsuarioTienePermiso
GO
CREATE PROCEDURE usp_Paginas__ElUsuarioTienePermiso
		-- Validaciones:
			--
		-------------
		-- Acotaciones:
			-- 
		-------------
	(
			@UsuarioQueEjecutaId				INT
			,@FechaDeEjecucion					DATETIME
			,@Seccion							VARCHAR(30)
			
			,@Tabla								VARCHAR(80)
			,@FuncionDePagina					VARCHAR(30)
			,@AutorizadoA						VARCHAR(30)
			,@sResSQL							VARCHAR(1000)	OUTPUT
			
			,@RegistroId						INT = NULL -- <> NULL SI @SP = "AutA_ConRegId"
	)
	AS
	BEGIN
		DECLARE @ElUsuarioTienePermisoEnLaPagina BIT = '0'
			,@PaginaId INT
			,@SeEvaluanPermisosSobreElRegistroId BIT = '0'
			,@Seccion_Web VARCHAR(30)
			,@Seccion_PrivadaDelUsuario VARCHAR(30)
			,@VerRegAnulados BIT = '0'
			
		SET NOCOUNT ON
		
		EXEC @Seccion_Web = ufc_Secciones__Web
		EXEC @Seccion_PrivadaDelUsuario = ufc_Secciones__PrivadaDelUsuario
	
		SET @SeEvaluanPermisosSobreElRegistroId = CASE WHEN @RegistroId IS NULL OR @RegistroId = '0' THEN '0' ELSE '1' END
		
		EXEC @PaginaId = usp_VAL_Paginas__PaginaId
							@Seccion = @Seccion
							,@Tabla = @Tabla
							,@FuncionDePagina = @FuncionDePagina
							,@sResSQL = @sResSQL OUTPUT 
			
		IF @sResSQL = '' -- La pagina existe --> Avanzamos:
			BEGIN
				SET NOCOUNT ON
											
				SELECT @ElUsuarioTienePermisoEnLaPagina = 
					CASE
						WHEN @AutorizadoA = 'CargarLaPagina' THEN MAX(CAST(RPRP.AutorizadoA_CargarLaPagina AS INT)) -- Con que haya 1 solo de los roles con BIT = 1 --> El MAX(...)=1; Si todos son = 0 --> El MAX(...)=0.
						WHEN @AutorizadoA = 'OperarLaPagina' THEN MAX(CAST(RPRP.AutorizadoA_OperarLaPagina AS INT)) -- Con que haya 1 solo de los roles con BIT = 1 --> El MAX(...)=1; Si todos son = 0 --> El MAX(...)=0.
						WHEN @AutorizadoA = 'VerRegAnulados' THEN MAX(CAST(RPRP.AutorizadoA_VerRegAnulados AS INT)) -- Con que haya 1 solo de los roles con BIT = 1 --> El MAX(...)=1; Si todos son = 0 --> El MAX(...)=0.
						WHEN @AutorizadoA = 'AccionesEspeciales' THEN MAX(CAST(RPRP.AutorizadoA_AccionesEspeciales AS INT)) -- Con que haya 1 solo de los roles con BIT = 1 --> El MAX(...)=1; Si todos son = 0 --> El MAX(...)=0.
					END
					,@VerRegAnulados = MAX(CAST(RPRP.AutorizadoA_VerRegAnulados AS INT)) -- LO GUARDO PARA CONTROLAR MAS TARDE
				FROM RelAsig_RolesDeUsuarios_A_Usuarios RARU
					INNER JOIN RelAsig_RolesDeUsuarios_A_Paginas RPRP ON RARU.RolDeUsuarioId = RPRP.RolDeUsuarioId
					INNER JOIN Usuarios U ON RARU.UsuarioId = U.id
				WHERE RARU.UsuarioId = @UsuarioQueEjecutaId 
					AND U.Activo = '1'
					AND RPRP.PaginaId = @PaginaId
					AND RARU.FechaDesde <= @FechaDeEjecucion
					AND	(RARU.FechaHasta IS NULL OR RARU.FechaHasta >= @FechaDeEjecucion)
			END
		
		
		IF @sResSQL = '' 
				AND @ElUsuarioTienePermisoEnLaPagina = '1' 
				AND @SeEvaluanPermisosSobreElRegistroId = '1' --> Revisaremos si está cargando una página 'Registro' donde el Registro esté "Anulado". Si es el caso --> Revisamos si tiene permisos de ver/operar Anulados.
				AND (
						(@AutorizadoA = 'CargarLaPagina' AND @FuncionDePagina = 'Registro')
						OR (@AutorizadoA = 'OperarLaPagina' AND @FuncionDePagina = 'Update')
					)
			BEGIN
				IF COL_LENGTH(@Tabla, 'Activo') IS NOT NULL
					BEGIN
						-- Primero: evaluamos si el regitro está anulado (Activo = '0')
						DECLARE @Activo BIT
						DECLARE @sSQL NVARCHAR(1000)
						DECLARE @Parámetros NVARCHAR(1000)
						SET @Parámetros = N'@RegistroId INT, @Activo BIT OUTPUT';

						SELECT @sSQL = N'SELECT @Activo = Activo FROM ' + QUOTENAME(@Tabla) + ' WHERE id = @RegistroId'
						EXEC  sp_executesql @sSQL, @Parámetros, @Activo = @Activo OUTPUT, @RegistroId = @RegistroId
						
						IF @sResSQL = ''
							AND (@Activo = '0') --> El registro está anulado
							AND (@VerRegAnulados = '0' --> El usuario NO tiene permiso de ver registros anulados
									OR @Seccion = @Seccion_Web --> o es la seccion Web, donde nunca permitiremos ver/operar registros anulados.
									OR @Seccion = @Seccion_PrivadaDelUsuario --> o es la seccion Privada del usuario, donde nunca permitiremos ver/operar registros anulados.
								)
							BEGIN
								SET @sResSQL = 'No se puede concretar la acción. El registro se encuentra anulado, y ud. no dispone de permisos para ver/operar registros anulados.'
							END
						
						IF @sResSQL = ''
							AND @Activo = '0' --> El registro está anulado
							AND @AutorizadoA = 'OperarLaPagina'
							AND @FuncionDePagina = 'Update'
							BEGIN
								SET @sResSQL = 'No se puede concretar la acción. El registro se encuentra anulado y no se permite su edición en este estado.'
							END
					END	
			END
		
		IF @sResSQL = '' AND @ElUsuarioTienePermisoEnLaPagina = '1'
			BEGIN
				SET @sResSQL = '' -- Es obvio, pero lo dejo así por claridad.
			END
		ELSE
			BEGIN
				SET @ElUsuarioTienePermisoEnLaPagina = '0'
				SET @sResSQL = CASE WHEN @sResSQL = '' THEN 'No tiene permisos' ELSE @sResSQL END -- Si ya traía un mensaje de error entonces que salga con ese mensaje.
			END
			
		RETURN @ElUsuarioTienePermisoEnLaPagina
	END
GO




IF (OBJECT_ID('usp_Paginas__PermisosDePrecargaInicial') IS NOT NULL) DROP PROCEDURE usp_Paginas__PermisosDePrecargaInicial
GO
CREATE PROCEDURE usp_Paginas__PermisosDePrecargaInicial
		-- Si @FuncionDePagina = 'Insert' --> AutorizadoA_OperarLaPagina indica si puede Eliminar/Activar in registro
		-- La Página de .NET se define con la Tabla y la FuncionDePagina Y AHORA también con  la seccion

		@UsuarioQueEjecutaId			INT
		,@FechaDeEjecucion				DATETIME
		,@Seccion						VARCHAR(30) -- 1:'Administracion' / 2:'Intranet' / 3:'Web' / 4:'PublicaDelUsuario'
		
		,@Tabla							VARCHAR(80) -- Es el Modelo (Nombre del controlador) de 
		,@FuncionDePagina				VARCHAR(30) -- Es la Action Result de c/u
		
		,@sResSQL						VARCHAR(1000) OUTPUT
	AS
	BEGIN
		SET @sResSQL = ''
		
		DECLARE @UsuarioActivo BIT = (SELECT Activo FROM Usuarios WHERE id = @UsuarioQueEjecutaId)
		
		IF @UsuarioActivo IS NULL 
			BEGIN
				SET @sResSQL = 'El usuario no existe en la base de datos.'
			END
		ELSE IF @UsuarioActivo = '0'
			BEGIN
				SET @sResSQL = 'El usuario no se encuentra activo para operar.'
			END
	
		IF @sResSQL = ''
			BEGIN
				DECLARE @SeccionId INT = (SELECT id FROM Secciones WHERE Nombre = @Seccion)
				DECLARE @TablaId INT = (SELECT id FROM Tablas WHERE Nombre = @Tabla)
				DECLARE @FuncionDePaginaId INT = (SELECT id FROM FuncionesDePaginas WHERE Nombre = @FuncionDePagina)
				DECLARE @PaginaId INT = (SELECT id FROM Paginas WHERE SeccionId = @SeccionId
																	AND TablaId = @TablaId 
																	AND FuncionDePaginaId = @FuncionDePaginaId)

				IF @PaginaId IS NULL
					BEGIN
						SET @sResSQL = 'La página no existe.'
					END
				ELSE
					BEGIN
						SET @sResSQL = ''

						-- Necesito tener al menos 1 columna con la que relacionar las tablas --> Rel
						SELECT *
						FROM
						(
							SELECT
								1 AS Rel
								,MAX(CAST(RPRP.AutorizadoA_CargarLaPagina AS INT)) AS AutorizadoACargarLaPagina -- Con que haya 1 solo de los roles con BIT = 1 --> El MAX(...)=1; Si todos son = 0 --> El MAX(...)=0.
								,MAX(CAST(RPRP.AutorizadoA_OperarLaPagina AS INT)) AS AutorizadoAOperarLaPagina -- Con que haya 1 solo de los roles con BIT = 1 --> El MAX(...)=1; Si todos son = 0 --> El MAX(...)=0.
								,MAX(CAST(RPRP.AutorizadoA_VerRegAnulados AS INT)) AS AutorizadoAVerRegAnulados -- Con que haya 1 solo de los roles con BIT = 1 --> El MAX(...)=1; Si todos son = 0 --> El MAX(...)=0.
								,MAX(CAST(RPRP.AutorizadoA_AccionesEspeciales AS INT)) AS AutorizadoAAccionesEspeciales -- Con que haya 1 solo de los roles con BIT = 1 --> El MAX(...)=1; Si todos son = 0 --> El MAX(...)=0.
							FROM RelAsig_RolesDeUsuarios_A_Usuarios RARU
								INNER JOIN RelAsig_RolesDeUsuarios_A_Paginas RPRP ON RARU.RolDeUsuarioId = RPRP.RolDeUsuarioId
							WHERE RARU.UsuarioId = @UsuarioQueEjecutaId 
								AND RPRP.PaginaId = @PaginaId
								AND RARU.FechaDesde <= @FechaDeEjecucion
								AND	(RARU.FechaHasta IS NULL OR RARU.FechaHasta >= @FechaDeEjecucion)
						) AS T1
						INNER JOIN
						(
							SELECT 
								1 AS Rel
								,(CASE WHEN P.Titulo IS NULL OR P.Titulo = '' THEN S.NombreAMostrar + ' > ' + T.NombreAMostrar + ' - ' + FP.NombreAMostrar
																				ELSE S.NombreAMostrar + ' > ' + P.Titulo 
																				END
																				) AS Titulo
								,P.Observaciones AS Notas
								,COALESCE(P.Tips, '') AS Tips
							FROM Paginas P
								INNER JOIN Secciones S ON P.SeccionId = S.id
								INNER JOIN Tablas T ON P.TablaId = T.id
								INNER JOIN FuncionesDePaginas FP ON P.FuncionDePaginaId = FP.id 
							WHERE
								P.id = @PaginaId
						) AS T2 ON T1.Rel = T2.Rel
					END
			END
		END
GO
-- SP-TABLA: Paginas /PermisosEn/ - FIN




-- SP-TABLA: Permisos /PermisosEn/ - INICIO
IF (OBJECT_ID('usp_Permisos__AutorizadoA') IS NOT NULL) DROP PROCEDURE usp_Permisos__AutorizadoA
GO
CREATE PROCEDURE usp_Permisos__AutorizadoA -- v5 (Marzo/2020)
	-- Validaciones:
		--
	-------------
	-- Acotaciones:
		-- 
	-------------
	@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion					DATETIME
	,@Seccion							VARCHAR(30) = NULL
	,@Token								VARCHAR(40) = NULL
	,@CodigoDelContexto					VARCHAR(40) = NULL -- Para seccion "Web".
	,@SP								VARCHAR(80)
	
	,@Tabla								VARCHAR(80)
	,@FuncionDePagina					VARCHAR(30)
	,@AutorizadoA						VARCHAR(30)
	
	,@sResSQL							VARCHAR(1000)	OUTPUT -- Si lo devuelve "vacío" es que tiene permiso, si no, lleva el mensaje de por qué no.
	
	--Opcionales:
	,@RegistroId						INT = NULL -- <> NULL SI @SP = "AutA_ConRegId"
	,@UsuarioId							INT = NULL		OUTPUT -- <> NULL SI @SP = "AutA_ConUsuarioId"
AS
BEGIN
	DECLARE @EsUnaOperacionDeCore BIT = '0' -- En principio NO es una operación de core --> hay que evaluar permisos.
		,@SeDebenEvaluarPermisos BIT = '1' -- En principio lo seteamos que SI, que hay que evaluarlos.
		,@TienePermiso BIT = '0' -- EN principio, NO tiene permiso.
		,@EsUnaFuncionDePaginaConRegistro BIT --
		,@SeControlaRegistroId BIT -- // El parámetro opcional pasado "@RegistroId"
		,@LaPaginaExiste BIT -- // No se carga al inicio.
		,@UsuarioParaChequearPermisoId INT -- // No se carga al inicio.
		,@SeccionParaChequearPermiso VARCHAR(30) --  // No se carga al inicio.
		,@Seccion_Administracion VARCHAR(30)
		,@Seccion_Web VARCHAR(30)
		
	EXEC @Seccion_Administracion = ufc_Secciones__Administracion
	EXEC @Seccion_Web = ufc_Secciones__Web
		
	SET @sResSQL = '' -- Nunca los usamos como IN --> los limpiamos
	EXEC usp_VAL_SPs__ValorDeEntradaDeID @SP = @SP, @FuncionDePagina	= @FuncionDePagina, @id = @RegistroId OUTPUT -- Si el SP es de Insert --> SET @id = NULL -- Nunca los usamos como IN --> los limpiamos
	
	
	--1
	EXEC @EsUnaOperacionDeCore = usp_VAL_Datos__EsUnaOperacionDeCore
									@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
									,@Token	= @Token
									,@Seccion = @Seccion
									,@CodigoDelContexto = @CodigoDelContexto
									,@Tabla = @Tabla

	IF @EsUnaOperacionDeCore = '0' -- Si es de Core no chequeo nada:						
		BEGIN
			EXEC usp_VAL_Datos__Y_DevolverUsuario
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					,@Token = @Token
					,@Seccion = @Seccion
					,@CodigoDelContexto = @CodigoDelContexto
					,@Tabla = @Tabla
					,@sResSQL = @sResSQL	OUTPUT
							
			
			-- 3	
			IF @sResSQL = ''
				BEGIN
					EXEC @SeDebenEvaluarPermisos = usp_VAL_Operacion__SeDebenEvaluarPermisos
														@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
														,@FechaDeEjecucion = @FechaDeEjecucion
														,@Token = @Token
														,@Seccion = @Seccion
														,@CodigoDelContexto = @CodigoDelContexto
														,@Tabla = @Tabla
														,@FuncionDePagina = @FuncionDePagina
														,@SP = @SP
														,@sResSQL = @sResSQL OUTPUT
				END
				
				
			-- 4
			IF @sResSQL = ''
				BEGIN
					-- Tener en cuenta que los insert reciben el pueden tener un valor de entrada de @id sin ser realmente algo esperado:
					
					---IF @EsUnaFuncionDePaginaConRegistro = '1'	// -- También deberíamos controlar la funcion de página u otra cosa VER !!!
					SET @SeControlaRegistroId = CASE WHEN @FuncionDePagina = 'Insert' -- El @id (RegistroId) es el de salida
															OR @RegistroId IS NULL -- No se pasó
															OR @RegistroId = '0'  -- No se pasó
																THEN '0' 
																ELSE '1' 
																END
				END
				
					
			-- 5 Validamos si el registro indicado en los parámetro @TablaId y @RegistroId pertenecen al contexto del usuario:
			IF @sResSQL = '' AND @SeControlaRegistroId = '1'
				BEGIN
					IF @Seccion = @Seccion_Web
						BEGIN
							EXEC @UsuarioParaChequearPermisoId = usp_VAL_Usuarios__DevolverAnonimoUtilizandoCodigoDelContexto
																	@CodigoDelContexto = @CodigoDelContexto
																	,@sResSQL = @sResSQL OUTPUT  -- USO EL ANONIMO
						END
					ELSE
						BEGIN
							SET @UsuarioParaChequearPermisoId = @UsuarioQueEjecutaId -- USO EL Q Ejecuta
						END
						
					EXEC usp_VAL_Contextos__UsuarioPerteneceAlDelRegistro
							@UsuarioId = @UsuarioParaChequearPermisoId
							,@Tabla	= @Tabla
							,@RegistroId = @RegistroId
							,@sResSQL = @sResSQL	OUTPUT
				END
															
			
			--6 Validamos si el usuario indicado en el parámetro @UsuarioId es correcto. Si es nulo lo resuelve adentro
			IF @sResSQL = ''
				BEGIN
					EXEC usp_VAL_Usuarios__UsuarioIdPermitido
							@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
							,@Token = @Token
							,@Seccion = @Seccion
							,@CodigoDelContexto = @CodigoDelContexto
							,@Tabla	= @Tabla
							,@UsuarioId	= @UsuarioId	OUTPUT
							,@RegistroId = @RegistroId
							,@sResSQL = @sResSQL	OUTPUT
				END
						
			
			-- 7 Acá comienza la validación de permisos:
			IF @sResSQL = '' AND @SeDebenEvaluarPermisos = '1'
				BEGIN		
					-- Comenzamos chequeando si la página existe.
					-- Tener en cuenta, que cuando se carga la página principal, se llama al SP "usp_Paginas__PermisosDePrecargaInicial" por lo tanto, la página inicial ya fué controlada en ese momento y existe.
					EXEC @LaPaginaExiste = usp_VAL_Paginas__Existe 
												@Seccion = @Seccion
												,@Tabla = @Tabla
												,@FuncionDePagina = @FuncionDePagina
					
					-- Si la página existe --> chequear los permisos contra ella
					IF @LaPaginaExiste = '1'
						BEGIN
							SET @SeccionParaChequearPermiso = @Seccion -- Como la página existe en esta sección --> Usaremos la sección original para chequear los permisos.
							
							IF @Seccion = @Seccion_Web
								BEGIN
									EXEC @UsuarioParaChequearPermisoId = usp_VAL_Usuarios__DevolverAnonimoUtilizandoCodigoDelContexto
																			@CodigoDelContexto = @CodigoDelContexto
																			,@sResSQL = @sResSQL OUTPUT  -- USO EL ANONIMO
								END
							ELSE
								BEGIN
									SET @UsuarioParaChequearPermisoId = @UsuarioQueEjecutaId -- USO EL Q Ejecuta
								END
						END
					ELSE --> Debe ser un "llamado interno" y chequeamos los permisos contra la página pero en la seccion "Administracion"
						BEGIN
							IF @Seccion = @Seccion_Administracion --> Es la sección donde si o si tiene que existir la página para mirar permisos
								BEGIN
									SET @sResSQL = 'La página no existe'
								END
							ELSE
								BEGIN -- Controlamos si existe en la 'Administracion'. Éste será el caso de una llamada interna (no del propio SP de la pagina cargada, sino, llamado desde ésta).:
									EXEC @LaPaginaExiste = usp_VAL_Paginas__Existe 
																@Seccion = @Seccion_Administracion -- Ahora voy a chequear si existe en la seccion intranet, donde debería existir siempre.
																,@Tabla = @Tabla
																,@FuncionDePagina = @FuncionDePagina
																
									IF @LaPaginaExiste = '0'
										BEGIN
											SET @sResSQL = 'La página no existe'
										END
												
									IF @sResSQL = '' -- > Busco el usuario anónimo para mirar permisos, pero dependiendo la seccion busco con el @CodigoDelContexto o con el @UsuarioQueEjecutaId
										BEGIN
											IF @Seccion = @Seccion_Web
												BEGIN
													EXEC @UsuarioParaChequearPermisoId = usp_VAL_Usuarios__DevolverAnonimoUtilizandoCodigoDelContexto
																							@CodigoDelContexto = @CodigoDelContexto
																							,@sResSQL = @sResSQL OUTPUT  -- USO EL ANONIMO
												END
											ELSE    -- Busco el anónimo con el Código que sacamos del @UsuarioQueEjecutaId
												BEGIN
													EXEC @UsuarioParaChequearPermisoId = usp_VAL_Usuarios__DevolverAnonimoUtilizandoUsuarioId
																							@UsuarioId = @UsuarioQueEjecutaId
																							,@sResSQL = @sResSQL OUTPUT 
												END
						
											SET @SeccionParaChequearPermiso = @Seccion_Administracion
										END
								END
						END
						
					
					-- FINAL)
					IF @sResSQL = ''
						BEGIN
							EXEC @TienePermiso = usp_Paginas__ElUsuarioTienePermiso
													@UsuarioQueEjecutaId = @UsuarioParaChequearPermisoId -- <-- Es el @UsuarioQueEjecutaId o el ANONIMO según el caso !!!
													,@FechaDeEjecucion = @FechaDeEjecucion
													,@Seccion = @SeccionParaChequearPermiso -- <-- Contra la seccion original o la Administracion según el caso !!!
													,@Tabla = @Tabla
													,@FuncionDePagina = @FuncionDePagina
													,@AutorizadoA = @AutorizadoA
													,@sResSQL = @sResSQL OUTPUT 
													,@RegistroId = @RegistroId -- PUEDE IR NULL
						END
				END
		END	
			
	-- Se elabora el mensaje:
	IF @sResSQL = '' AND (@EsUnaOperacionDeCore = '1' OR @TienePermiso = '1' OR @SeDebenEvaluarPermisos = '0')
		BEGIN
			SET @sResSQL = '' -- Es obvio, pero lo dejo así por claridad.
		END
	ELSE
		BEGIN
			SET @sResSQL = CASE WHEN @sResSQL = '' THEN 'No tiene permisos' ELSE @sResSQL END -- Si ya traía un mensaje de error entonces que salga con ese mensaje.
		END
END
GO
-- SP-TABLA: Permisos /PermisosEn/ - FIN


-- ---------------------------------
-- Script: DB_ParticularCore__C08__Permisos.sql - FIN
-- =====================================================
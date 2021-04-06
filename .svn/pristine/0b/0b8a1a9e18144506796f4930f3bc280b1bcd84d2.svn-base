-- =====================================================
-- Descripción: Insertamos valor prioritarios, sin los cuales el sistema no funciona.
-- Script: DB_ParticularCore__P19b_Insert Values del Sistema_Prioritarios 2 - Tablas y Paginas.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO
 
		-- Tablas Involucradas: - INICIO
			-- Tabla1
			-- Tabla2
		-- Tablas Involucradas: - FIN

				-- Variable que utilizamos en los insert - INICIO
					DECLARE	@Seccion_Administracion VARCHAR(30)
						,@Seccion_Intranet VARCHAR(30)
						,@Seccion_Web VARCHAR(30)
						,@Seccion_PrivadaDelUsuario VARCHAR(30)
		
					EXEC @Seccion_Administracion = ufc_Secciones__Administracion
					EXEC @Seccion_Intranet = ufc_Secciones__Intranet
					EXEC @Seccion_Web = ufc_Secciones__Web
					EXEC @Seccion_PrivadaDelUsuario = ufc_Secciones__PrivadaDelUsuario
					
					DECLARE @RolDeUsuario_SoloLogin VARCHAR(80)
						,@RolDeUsuario_Operador VARCHAR(80)
						,@RolDeUsuario_OperadorAvanzado VARCHAR(80)
						,@RolDeUsuario_Administrador VARCHAR(80)
						,@RolDeUsuario_MasterAdmin VARCHAR(80)
						,@RolDeUsuario_PedirSoportes VARCHAR(80)
						,@RolDeUsuario_AdministrarSoportes VARCHAR(80)
						,@RolDeUsuario_RecibeNotifPorModifUsuarios VARCHAR(80)
						,@RolDeUsuario_RecibeNotifPorModifInformes VARCHAR(80)
					
					EXEC @RolDeUsuario_SoloLogin = ufc_RolesDeUsuarios__SoloLogin
					EXEC @RolDeUsuario_Operador = ufc_RolesDeUsuarios__Operador
					EXEC @RolDeUsuario_OperadorAvanzado = ufc_RolesDeUsuarios__OperadorAvanzado
					EXEC @RolDeUsuario_Administrador = ufc_RolesDeUsuarios__Administrador
					EXEC @RolDeUsuario_MasterAdmin = ufc_RolesDeUsuarios__MasterAdmin
					EXEC @RolDeUsuario_PedirSoportes = ufc_RolesDeUsuarios__PedirSoportes
					EXEC @RolDeUsuario_AdministrarSoportes = ufc_RolesDeUsuarios__AdministrarSoportes
					EXEC @RolDeUsuario_RecibeNotifPorModifUsuarios = ufc_RolesDeUsuarios__RecibeNotifPorModifUsuarios
					EXEC @RolDeUsuario_RecibeNotifPorModifInformes = ufc_RolesDeUsuarios__RecibeNotifPorModifInformes
					
					DECLARE @UsuarioQueEjecutaId	INT = '1' -- OJO, q si va UsuarioId=1 -- > Va En ContextoId=1 --> no logueable
						,@FechaDeEjecucion			DATETIME = GetDate()
						,@Token                     VARCHAR(40) = 'OperacionDeCore'
 						--,@Seccion					VARCHAR(30) = @Seccion_Administracion -- Las páginas que se crearán deben ir es esta sección.
						,@CodigoDelContexto			VARCHAR(40) = NULL
						
						,@sResSQL VARCHAR(1000)	
						,@id INT
						
						,@IconoGenericoCSSId INT = (SELECT id FROM IconosCSS WHERE Nombre = 'Default-*')
						,@IconoOjoCSSId INT = (SELECT id FROM IconosCSS WHERE Nombre = 'Ojo')
						,@IconoPencilCSSId INT = (SELECT id FROM IconosCSS WHERE Nombre = 'pencil square')
						,@IconoPenCSSId INT = (SELECT id FROM IconosCSS WHERE Nombre = 'Basic Pen')
						,@IconoSupportCSSId INT = (SELECT id FROM IconosCSS WHERE Nombre = 'Soportes')
						,@IconoGrupoCSSId INT = (SELECT id FROM IconosCSS WHERE Nombre = 'Grupo')
						,@IconoActoresCSSId INT = (SELECT id FROM IconosCSS WHERE Nombre = 'software')
						,@IconoWarningCSSId INT = (SELECT id FROM IconosCSS WHERE Nombre = 'warning')
						,@IconoBasicWebpageCSSId INT = (SELECT id FROM IconosCSS WHERE Nombre = 'basicwarning')
						,@IconoWebpageCSSId INT = (SELECT id FROM IconosCSS WHERE Nombre = 'webpage')
						,@SaltarRegistrosExistentes BIT = '1'
						,@RealizarUpdateSiElRegistroExiste BIT = '1'
						,@TablaDeCore BIT = '0'
						,@Nombre VARCHAR(100)
						,@Mensaje VARCHAR(MAX)
						,@TablaDelExec VARCHAR(80)
						
						-- para todo lo que es P se debe setear  @SeCreanPaginas = '1' por que si no no existe la página --> no se puede operar sobre la tabla.
						
				-- Variable que utilizamos en los insert - FIN


-- INSERT VALUES: Tablas y sus páginas - INICIO
	PRINT 'Insertando Tablas y sus Páginas "P"'
	
	SET @TablaDelExec = 'Tablas'
	PRINT 'Insertando sobre la tabla: ' + @TablaDelExec
	
	SET @Nombre = 'Tabla1'  
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
  		,@FechaDeEjecucion = @FechaDeEjecucion 
  		,@Token = @Token 
 		,@Seccion = @Seccion_Administracion  
  		,@CodigoDelContexto = @CodigoDelContexto  
 		,@IconoCSSId = @IconoOjoCSSId
		,@Nombre = @Nombre 
 		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
  		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste 
 		,@NombreAMostrar = 'Tabla1'
		,@Nomenclatura = 'Tabla1'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_OperadorAvanzado
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_OperadorAvanzado
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_Administrador
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = ''
		,@CamposAIncluirEnFiltrosDeListado = ''
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
			
	SET @Nombre = 'Tabla2'  
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
  		,@FechaDeEjecucion = @FechaDeEjecucion 
  		,@Token = @Token 
 		,@Seccion = @Seccion_Administracion  
  		,@CodigoDelContexto = @CodigoDelContexto  
 		,@IconoCSSId = @IconoOjoCSSId
		,@Nombre = @Nombre 
 		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
  		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste 
 		,@NombreAMostrar = 'Tabla2'
		,@Nomenclatura = 'Tabla2'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_OperadorAvanzado
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_OperadorAvanzado
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_Administrador
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = ''
		,@CamposAIncluirEnFiltrosDeListado = ''
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 					
			
	SELECT * FROM Tablas
	SELECT * FROM Paginas
	SELECT * FROM RelAsig_RolesDeUsuarios_A_Paginas
-- INSERT VALUES: Tablas - FIN


-- =====================================================
-- Script: DB_ParticularCore__P19b_Insert Values del Sistema_Prioritarios 2 - Tablas y Paginas.sql - FIN
-- -------------------------
-- =====================================================
-- Descripción: Insertamos valor prioritarios, sin los cuales el sistema no funciona.
-- Script: DB_ParticularCore__19b_Core__Insert Values del Sistema_Prioritarios 2 - Tablas y Paginas.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO

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
						,@RolDeUsuario_RecibeNotifPorModifInformes VARCHAR(80)
						,@RolDeUsuario_RecibeNotifPorModifUsuarios VARCHAR(80)
					
					EXEC @RolDeUsuario_SoloLogin = ufc_RolesDeUsuarios__SoloLogin
					EXEC @RolDeUsuario_Operador = ufc_RolesDeUsuarios__Operador
					EXEC @RolDeUsuario_OperadorAvanzado = ufc_RolesDeUsuarios__OperadorAvanzado
					EXEC @RolDeUsuario_Administrador = ufc_RolesDeUsuarios__Administrador
					EXEC @RolDeUsuario_MasterAdmin = ufc_RolesDeUsuarios__MasterAdmin
					EXEC @RolDeUsuario_PedirSoportes = ufc_RolesDeUsuarios__PedirSoportes
					EXEC @RolDeUsuario_AdministrarSoportes = ufc_RolesDeUsuarios__AdministrarSoportes
					EXEC @RolDeUsuario_RecibeNotifPorModifInformes = ufc_RolesDeUsuarios__RecibeNotifPorModifInformes
					EXEC @RolDeUsuario_RecibeNotifPorModifUsuarios = ufc_RolesDeUsuarios__RecibeNotifPorModifUsuarios
					
					DECLARE @UsuarioQueEjecutaId	INT = '1' -- OJO, q si va UsuarioId=1 -- > Va En ContextoId=1 --> no logueable
						,@FechaDeEjecucion			DATETIME = GetDate()
						,@Token                     VARCHAR(40) = 'OperacionDeCore'
 						--,@Seccion					VARCHAR(30) = @Seccion_Administracion -- Las páginas que se crearán deben ir es esta sección.
						,@CodigoDelContexto			VARCHAR(40) = NULL
						
						,@sResSQL VARCHAR(1000)		= '' -- Si no se llenó con "vacío" y la usamos, salta error.
						,@id INT
						
						,@TablaId INT
						,@FuncionDePaginaId INT
						,@PaginaId INT
						,@RolDeUsuarioId INT
						
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
						,@TablaDeCore BIT = '1'
						,@Nombre VARCHAR(100)
						,@Mensaje VARCHAR(MAX)
						,@TablaDelExec VARCHAR(80)
				-- Variable que utilizamos en los insert - FIN


-- INSERT VALUES: Tablas y sus páginas - INICIO
	PRINT 'Insertando Tablas y sus Páginas'
	
	--1ero va la de sistema, p q tenga id=1
	SET @TablaDelExec = 'Tablas'
	PRINT 'Insertando sobre la tabla: ' + @TablaDelExec
	
	SET @Nombre = 'SinTabla'
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre  
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste 
		,@NombreAMostrar = 'Sin Tabla'
		,@Nomenclatura = 'SinTabla'
		,@Observaciones	= 'Para registrar los errores y registros no asociados con tablas.'
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '0'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = ''
		,@SeGeneranAutoSusSPsDeABM = '0'
		,@SeGeneranAutoSusSPsDeRegistros = '0'
		,@SeGeneranAutoSusSPsDeListados = '0'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
		IF @id <> '1'
			BEGIN
				RAISERROR ('La Tabla "SinTabla" se insertó con un id<>1 !!!', 16, 1)
			END

		PRINT 'Insertando Pagina DE SISTEMA'
		SET IDENTITY_INSERT Paginas ON
		INSERT INTO Paginas (
								id
								,TablaId
								,FuncionDePaginaId
								,Nombre
								,Titulo
								,Observaciones
								,SeMuestraEnAsignacionDePermisos
							)
					VALUES 
							(
								'1' -- id = '1' -- Si no puede insertarse así --> Saltará Error.
								,'1' -- TablaId = '1'
								,'1'
								,'Sin Página'
								,'Sin Página'
								,'Para los errores y opciones sin páginas'
								,'0'
							)
		SET IDENTITY_INSERT Paginas OFF
		-- El resto de Páginas las agregan automáticamente las TABLAS

	
	--2da va la de "Tablas" q la necesito p/ los LogRegistros, y LogErrores
	SET @Nombre = 'Tablas'
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste 
		,@NombreAMostrar = 'Tablas del sitio'
		,@Nomenclatura = 'T'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '0'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = ''
		,@SeGeneranAutoSusSPsDeABM = '0'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '0'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	-- 3ro va la de Paginas, por q la necesitamos p los LogRegistros, y LogErrores
	SET @Nombre = 'Paginas'
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoWebpageCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Páginas del sitio'
		,@Nomenclatura = 'P'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = '' --'SeMuestraEnAsignacionDePermisos' no les permitiremos ver las = 0 // Solo para los masteradmins.
		,@SeGeneranAutoSusSPsDeABM = '0'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	-- YA EXISTE EN LA INTRA:
	SET @Nombre = 'Actores'				
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoActoresCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Actores'
		,@Nomenclatura = 'ACT'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = ''
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	SET @Nombre = 'Archivos'	
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Archivos'
		,@Nomenclatura = 'ARCH'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '1'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_Operador
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_Operador
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_Administrador
		,@CampoAMostrarEnFK	= 'NombreAMostrar'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = ''
		,@SeGeneranAutoSusSPsDeABM = '0'
		,@SeGeneranAutoSusSPsDeRegistros = '0'
		,@SeGeneranAutoSusSPsDeListados = '0'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
		
	
	SET @Nombre = 'CategoriasDeInformes' 
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Categorías de Informes'
		,@Nomenclatura = 'CDI'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_OperadorAvanzado
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_OperadorAvanzado
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_OperadorAvanzado
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_OperadorAvanzado
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
 		
	
	
	SET @Nombre = 'Contactos' 
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Intranet		-- INTRANET !!!
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Contactos'
		,@Nomenclatura = 'CTOS'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '1'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_Operador
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_Operador
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_Operador
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_Operador
		,@CampoAMostrarEnFK	= 'NombreCompleto'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = ''
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '0'
		,@SeGeneranAutoSusSPsDeListados = '0'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
				

	SET @Nombre = 'Contextos' 
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Contextos'
		,@Nomenclatura = 'CX'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@SeGeneranAutoSusSPsDeABM = '0'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
			
	
	SET @Nombre = 'CuentasDeEnvios' 
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Cuentas de envíos de correos'
		,@Nomenclatura = 'CDE'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '1'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
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
 		
	
	
	SET @Nombre = 'Dispositivos' 
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Dispositivos'
		,@Nomenclatura = 'DISP'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'UserMachineName'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = ''
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'EnviosDeCorreos' 
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Envíos de correos'
		,@Nomenclatura = 'EDC'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '1'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_OperadorAvanzado
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Asunto'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = ''
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'EstadosDeLogErrores'
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Estados de los logs de errores'
		,@Nomenclatura = 'EDLE'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '0'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = ''
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
		

	SET @Nombre = 'EstadosDeSoportes' 
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Estados de soportes'
		,@Nomenclatura = 'EDS'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = ''
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'EstadosDeTareas' 
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Estados de las tareas'
		,@Nomenclatura = 'EDT'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = ''
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'ExtensionesDeArchivos' 
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Extensiones de archivos'
		,@Nomenclatura = 'EDA'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = ''
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'FuncionesDePaginas'
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Funciones de las páginas'
		,@Nomenclatura = 'FDP'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = ''
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'GruposDeContactos' 
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Intranet		-- INTRANET !!!
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Grupos de contactos'
		,@Nomenclatura = 'GDCTOS'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '1'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_Operador
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_Operador
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_Operador
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_Operador
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = ''
		,@CamposAIncluirEnFiltrosDeListado = ''
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '0'
		,@SeGeneranAutoSusSPsDeListados = '0'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
		
	
	SET @Nombre = 'Iconos'
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Iconos'
		,@Nomenclatura = 'IC'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = ''
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'IconosCSS'
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Iconos css'
		,@Nomenclatura = 'ICSS'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '1'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'CSS'
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
 		
	
	
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = 'Importaciones'
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Importaciones'
		,@Nomenclatura = 'IMT'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '0'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '1'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = ''
		,@SeGeneranAutoSusSPsDeABM = '0'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '0'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
		
		
	SET @Nombre = 'ImportanciasDeTareas'	
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Importancias de tareas'
		,@Nomenclatura = 'IDT'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '0'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = ''
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
		
	SET @Nombre = 'Informes' 	
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Intranet		-- INTRANET !!!
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Informes'
		,@Nomenclatura = 'INF'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_OperadorAvanzado
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_OperadorAvanzado
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_OperadorAvanzado
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_OperadorAvanzado
		,@CampoAMostrarEnFK	= 'FechaDeInforme'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = 'UsuarioId, FechaDeInforme'
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = ''
		,@SeGeneranAutoSusSPsDeABM = '0'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '0'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'LogEnviosDeCorreos'  
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Seguimiento de los envíos de correos'
		,@Nomenclatura = 'LEDC'  
		,@Observaciones	= 'Registra todos los envíos, tanto satisfactorios como fallidos que se produzcan.'
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_Operador
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Fecha'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = 'ObservacionesDeRevision'
		,@CamposAExcluirEnElUpdate = 'EnvioDeCorreoId, Satisfactorio, Fecha, Observaciones'
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = 'Fecha'
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '0'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'LogErrores'  
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoWarningCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Seguimiento de errores'
		,@Nomenclatura = 'LE'  
		,@Observaciones	= 'Registra todos los errores que se produzcan'
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'FechaDeEjecucion'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = 'FechaDeEjecucion'
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '0'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '0'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'LogErroresApp'  
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoSupportCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Logs de Errores en la App'
		,@Nomenclatura = 'LEAPP'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '0'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'FechaDeEjecucion'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = 'FechaDeEjecucion'
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
		
	SET @Nombre = 'LogLogins'  
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoSupportCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Logs de Logins'
		,@Nomenclatura = 'LL'
		,@Observaciones	= 'Seguimiento de inicios de sesión'
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'FechaDeEjecucion'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = 'FechaDeEjecucion'
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'LogLoginsDeDispositivos'  
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoSupportCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Logs de Logins de los dispositivos'
		,@Nomenclatura = 'LLDD'
		,@Observaciones	= 'Seguimiento de inicios de sesión de los dispositivos'
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'FechaDeEjecucion'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = 'FechaDeEjecucion'
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
			
	
	SET @Nombre = 'LogLoginsDeDispositivosRechazados'  
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoSupportCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Logs de logins de dispositivos rechazados'
		,@Nomenclatura = 'LLDDR'
		,@Observaciones	= 'Seguimiento de inicios de sesión de dispositivos rechazados'
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'FechaDeEjecucion'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = 'FechaDeEjecucion'
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
				

	SET @Nombre = 'LogRegistros'
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Historia de los registros de todas las tablas'
		,@Nomenclatura = 'LR'
		,@Observaciones	= 'Registra los cambios efectuados en cada modificacion de todos los registros de todas las tablas.'
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '0'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'FechaDeEjecucion'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = 'FechaDeEjecucion'
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '0'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'Notas'
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Intranet		-- INTRANET !!!
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Notas'
		,@Nomenclatura = 'NOTAS'
		,@Observaciones	= 'Registra notas de los usuarios.'
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '1'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_Operador
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_Operador
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_Administrador
		,@CampoAMostrarEnFK	= 'Fecha'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = ''
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '0'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
			
		
	SET @Nombre = 'Notificaciones'		
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Intranet		-- INTRANET !!!
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Notificaciones de los registros de todas las tablas'
		,@Nomenclatura = 'NOTIF'
		,@Observaciones	= 'Registra las notificaciones a mostrar a los usuarios ante ciertos eventos.'
		,@SeDebenEvaluarPermisos = '0'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Numero'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = 'Leida'
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '0'
		,@SeGeneranAutoSusSPsDeRegistros = '0'
		,@SeGeneranAutoSusSPsDeListados = '0'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
			
		
	SET @Nombre = 'ParametrosDelSistema' 	
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Parametros del sistema'
		,@Nomenclatura = 'PDS'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'ContextoId'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
		

	SET @Nombre = 'PrioridadesDeSoportes' 
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Prioridades de soportes'
		,@Nomenclatura = 'PDSop'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '0'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'Publicaciones' 
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Publicaciones'
		,@Nomenclatura = 'PUB'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Fecha'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = 'Fecha'
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '0'
		,@SeGeneranAutoSusSPsDeListados = '0'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
		
	
	SET @Nombre = 'RecorridosDeDispositivos' 
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Recorridos de dispositivos'
		,@Nomenclatura = 'RDD'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'FechaDeEjecucion'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = ''
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
		
	
	SET @Nombre = 'Recursos' 
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Recursos'
		,@Nomenclatura = 'RECU'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '1'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_Operador
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_Operador
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_OperadorAvanzado
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_OperadorAvanzado
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = ''
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '0'
		,@SeGeneranAutoSusSPsDeListados = '0'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'RelAsig_Contactos_A_GruposDeContactos' 
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Asignación de contactos a grupos'
		,@Nomenclatura = 'ACAG'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '1'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_Operador
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_Operador
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_Operador
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_Operador
		,@CampoAMostrarEnFK	= 'GrupoDeContactoId'
		,@CamposQuePuedenSerIdsString = 'ContactoId, GrupoDeContactoId'
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = ''
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'RelAsig_Contactos_A_TiposDeContactos' 
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Asignación de contactos a tipos de contactos'
		,@Nomenclatura = 'ACAT'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '1'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_Operador
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_Operador
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_Operador
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_Operador
		,@CampoAMostrarEnFK	= 'TipoDeContactoId'
		,@CamposQuePuedenSerIdsString = 'ContactoId, TipoDeContactoId'
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = ''
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
		
	SET @Nombre = 'RelAsig_CuentasDeEnvios_A_Tablas'
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Asignación de cuentas de email a las tablas'
		,@Nomenclatura = 'RCAT'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'CuentaDeEnvioId'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = ''
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '0'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
		

	SET @Nombre = 'RelAsig_RolesDeUsuarios_A_Paginas'
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoBasicWebpageCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Asignación de permisos de roles de usuarios a páginas del sitio'
		,@Nomenclatura = 'RDUAP'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'PaginaId'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = ''
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '0'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '0'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'RelAsig_RolesDeUsuarios_A_Usuarios'
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGrupoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Asignación de roles de usuarios a usuarios'
		,@Nomenclatura = 'RDUAU'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'UsuarioId'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = ''
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '0'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '0'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'RelAsig_Subsistemas_A_Publicaciones' 
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Asignación de subsistemas a publicaciones'
		,@Nomenclatura = 'ASAP'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'PublicacionId'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'RelAsig_TiposDeContactos_A_Contextos' 
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Asignación de tipos de contactos a contextos'
		,@Nomenclatura = 'ATCAC'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '1'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'TipoDeContactoId'
		,@CamposQuePuedenSerIdsString = '' -- ContactoId, TipoDeContactoId // Da error, por que el generador "saltea" a @ContextoId (Se crea en Particulares).
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = ''
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '0'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'RelAsig_Usuarios_A_Recursos' 
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Asignación de usuarios (responsables de aprobación de reservas) a recursos'
		,@Nomenclatura = 'AURAR'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '1'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_Operador
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_Operador
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_Administrador
		,@CampoAMostrarEnFK	= 'UsuarioId'
		,@CamposQuePuedenSerIdsString = 'UsuarioId' -- ContactoId, TipoDeContactoId // Da error, por que el generador "saltea" a @ContextoId (Se crea en Particulares).
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = ''
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'ReservasDeRecursos' 
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Intranet		-- INTRANET !!!
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Reservas'
		,@Nomenclatura = 'RESDR'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '1'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_SoloLogin -- Cualquiera puede "pedir/Tiene una reserva"
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_SoloLogin -- Los que operan están dados por asignaciones en los recursos --> es dinámico. Asi que permitimos a todos y luego se restringe puntualmente.
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_OperadorAvanzado
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_OperadorAvanzado
		,@CampoAMostrarEnFK	= 'FechaDeInicio'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'ObservacionesDelOriginante, ObservacionesDelAprobador'
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '0'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
		

	SET @Nombre = 'RolesDeUsuarios' 
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Roles de usuarios'
		,@Nomenclatura = 'RDU'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = ''
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '0'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '0'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'Secciones' 
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Secciones'
		,@Nomenclatura = 'Secc'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END 
 		
 		
 	SET @Nombre = 'Soportes'
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Intranet		-- INTRANET !!!
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoSupportCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Pedidos de soportes'
		,@Nomenclatura = 'SOP'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_PedirSoportes
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_AdministrarSoportes
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_AdministrarSoportes
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_AdministrarSoportes
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '0'
		,@SeGeneranAutoSusSPsDeRegistros = '0'
		,@SeGeneranAutoSusSPsDeListados = '0'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
		
	SET @Nombre = 'SPs' 
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Stored Procedures'
		,@Nomenclatura = 'SPs'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '0'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = ''
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
			
	SET @Nombre = 'Subsistemas'
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Subsistemas'
		,@Nomenclatura = 'SUBS'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '0'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = ''
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
		
	SET @Nombre = 'TablasYFuncionesDePaginas' 
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Tablas y Funciones de Páginas'
		,@Nomenclatura = 'TyFDP'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '0'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'TablaId'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = ''
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
 		
	SET @Nombre = 'Tareas'
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Intranet		-- INTRANET !!!
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoPencilCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Tareas'
		,@Nomenclatura = 'TA'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '1'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_OperadorAvanzado
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '0'
		,@SeGeneranAutoSusSPsDeRegistros = '0'
		,@SeGeneranAutoSusSPsDeListados = '0'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
		

	SET @Nombre = 'TiposDeActores'
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Tipos de actores'
		,@Nomenclatura = 'TDA'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = ''
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'TiposDeArchivos'
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Tipos de archivos'
		,@Nomenclatura = 'TDARCH'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = ''
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'TiposDeContactos'
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Tipos de contactos'
		,@Nomenclatura = 'TDC'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = ''
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'TiposDeLogLogins'
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Tipos de logs de los logins'
		,@Nomenclatura = 'TDLL'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '0'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = ''
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'TiposDeOperaciones'
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Tipos de operaciones'
		,@Nomenclatura = 'TDO'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '0'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = ''
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'TiposDeTareas'
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Tipos de tareas'
		,@Nomenclatura = 'TDT'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = ''
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'Ubicaciones'
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Ubicaciones'
		,@Nomenclatura = 'UB'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '0'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = ''
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '0'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'Unidades'
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Unidades'
		,@Nomenclatura = 'UD'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = ''
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	
	SET @Nombre = 'Usuarios'
	EXEC usp_Tablas__Insert
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
		,@FechaDeEjecucion = @FechaDeEjecucion 
		,@Token = @Token 
		,@Seccion = @Seccion_Administracion 
		,@CodigoDelContexto = @CodigoDelContexto 
		,@IconoCSSId = @IconoGrupoCSSId
		,@Nombre = @Nombre
		,@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Usuarios'
		,@Nomenclatura = 'U'
		,@Observaciones	= ''
		,@SeDebenEvaluarPermisos = '1'
		,@PermiteEliminarSusRegistros = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '1'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_Administrador
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_Administrador
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@CamposAExcluirEnElListado = 'Observaciones'
		,@CamposAIncluirEnFiltrosDeListado = ''
		--,@PermiteInsertAnonimamente	= '0' // No se usa más
		--,@PermiteListarDDLAnonimamente	= '0' // No se utiliza más, ya que en los ListadosDDLs no se valida permisos
		,@SeGeneranAutoSusSPsDeABM = '0'
		,@SeGeneranAutoSusSPsDeRegistros = '0'
		,@SeGeneranAutoSusSPsDeListados = '0'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
		
		
	SELECT * FROM Tablas
	SELECT * FROM Paginas
	SELECT * FROM RelAsig_RolesDeUsuarios_A_Paginas
-- INSERT VALUES: Tablas y sus páginas - FIN		
				
-- ---------------------------
-- Script: DB_ParticularCore__19b_Core__Insert Values del Sistema_Prioritarios 2 - Tablas y Paginas.sql - FIN
-- =====================================================
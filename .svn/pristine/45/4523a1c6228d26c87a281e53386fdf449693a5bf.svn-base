-- =====================================================
-- Descripción: Insertamos valor prioritarios, sin los cuales el sistema no funciona.
-- Script: DB_ParticularCore__C19c_Insert Values del Sistema_Prioritarios 3 - Paginas Específicas.sql - INICIO
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
						
						,@TablaId INT
						,@FuncionDePaginaId INT
				-- Variable que utilizamos en los insert - FIN




-- INSERT VALUES: Paginas - INICIO
	PRINT 'Insertando Paginas:'
	
	SET @TablaDelExec = 'Paginas'
	
	-- Usuarios: INICIO			
		SET @Nombre = '#Usuarios-CambiarPassword#'
		SET @TablaId = (SELECT id FROM Tablas WHERE Nombre = 'Usuarios')
		SET @FuncionDePaginaId = (SELECT id FROM FuncionesDePaginas WHERE Nombre = 'CambiarPassword')
		EXEC usp_Paginas__InsertSegunPrioridadRoles  
				@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
				,@FechaDeEjecucion = @FechaDeEjecucion 
				,@Token = @Token 
				,@Seccion = @Seccion_PrivadaDelUsuario 
				,@CodigoDelContexto = @CodigoDelContexto
				,@TablaId = @TablaId
				,@FuncionDePaginaId = @FuncionDePaginaId
				,@RolMenosPrioritarioQueCarga = @RolDeUsuario_SoloLogin
				,@RolMenosPrioritarioQueOpera = @RolDeUsuario_SoloLogin
				,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
				,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
				,@SeMuestraEnAsignacionDePermisos = '0'
				,@sResSQL = @sResSQL OUTPUT
				,@id = @id OUTPUT
				--SELECT 'Pagina insertada id = ' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
				SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
				IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
		 		
	 		
		SET @Nombre = '#Usuarios-ResetPassword#'
		SET @TablaId = (SELECT id FROM Tablas WHERE Nombre = 'Usuarios')
		SET @FuncionDePaginaId = (SELECT id FROM FuncionesDePaginas WHERE Nombre = 'ResetPassword')
		EXEC usp_Paginas__InsertSegunPrioridadRoles  
				@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
				,@FechaDeEjecucion = @FechaDeEjecucion 
				,@Token = @Token 
				,@Seccion = @Seccion_Administracion 
				,@CodigoDelContexto = @CodigoDelContexto
				,@TablaId = @TablaId
				,@FuncionDePaginaId = @FuncionDePaginaId
				,@RolMenosPrioritarioQueCarga = @RolDeUsuario_Administrador
				,@RolMenosPrioritarioQueOpera = @RolDeUsuario_Administrador
				,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_Administrador
				,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_Administrador
				,@SeMuestraEnAsignacionDePermisos = '0'
				,@sResSQL = @sResSQL OUTPUT
				,@id = @id OUTPUT
				--SELECT 'Pagina insertada id = ' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')	
				SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
				IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END
	-- Usuarios: FIN


-- =====================================================
-- Script: DB_ParticularCore__C19c_Insert Values del Sistema_Prioritarios 3 - Paginas Específicas.sql - FIN
-- -------------------------
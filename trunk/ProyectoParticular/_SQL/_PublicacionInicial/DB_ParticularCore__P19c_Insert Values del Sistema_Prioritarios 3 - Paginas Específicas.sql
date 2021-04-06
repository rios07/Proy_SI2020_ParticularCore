-- =====================================================
-- Descripción: Insertamos valor prioritarios, sin los cuales el sistema no funciona.
-- Script: DB_ParticularCore__P19c_Insert Values del Sistema_Prioritarios 3 - Paginas Específicas.sql - INICIO
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
					
					DECLARE	@Seccion_AdministracionId INT
						,@Seccion_IntranetId INT
						,@Seccion_WebId INT
						,@Seccion_PrivadaDelUsuarioId INT
		
					EXEC @Seccion_AdministracionId = ufc_Secciones__AdministracionId
					EXEC @Seccion_IntranetId = ufc_Secciones__IntranetId
					EXEC @Seccion_WebId = ufc_Secciones__WebId
					EXEC @Seccion_PrivadaDelUsuarioId = ufc_Secciones__PrivadaDelUsuarioId
					
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
						
						,@RolDeUsuario_TablaXXX VARCHAR(80) = 'TablaXXX'
						
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


---- INSERT VALUES: Paginas - INICIO
--	PRINT 'Insertando Paginas:'
	
--	SET @TablaDelExec = 'Paginas'
	
--	--Web/TablaXXX - Inicio:		
--		SET @Nombre = '# Web/TablaXXX/Insert #'
--		SET @TablaId = (SELECT id FROM Tablas WHERE Nombre = 'TablaXXX')
--		SET @FuncionDePaginaId = (SELECT id FROM FuncionesDePaginas WHERE Nombre = 'Insert')
--		EXEC usp_Paginas__InsertSegunPrioridadRoles  
--				@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
--				,@FechaDeEjecucion = @FechaDeEjecucion
--				,@Token = @Token 
--				,@Seccion = @Seccion_Web
--				,@CodigoDelContexto = @CodigoDelContexto 
--				,@TablaId = @TablaId
--				,@FuncionDePaginaId = @FuncionDePaginaId
--				,@RolMenosPrioritarioQueCarga = @RolDeUsuario_Administrador -- Es web, debería usar el Admin Anónimo
--				,@RolMenosPrioritarioQueOpera = @RolDeUsuario_Administrador -- Es web, debería usar el Admin Anónimo
--				,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_Administrador -- Es web, debería usar el Admin Anónimo
--				,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_Administrador -- Es web, debería usar el Admin Anónimo
--				,@sResSQL = @sResSQL OUTPUT
--				,@id = @id OUTPUT
--				--SELECT 'Pagina insertada id = ' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
--				SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
--				IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
		 		
	 		
--		SET @Nombre = '# Web/TablaXXX/Listado #'
--		SET @TablaId = (SELECT id FROM Tablas WHERE Nombre = 'TablaXXX')
--		SET @FuncionDePaginaId = (SELECT id FROM FuncionesDePaginas WHERE Nombre = 'Listado')
--		EXEC usp_Paginas__InsertSegunPrioridadRoles  
--				@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
--				,@FechaDeEjecucion = @FechaDeEjecucion
--				,@Token = @Token 
--				,@Seccion = @Seccion_Web
--				,@CodigoDelContexto = @CodigoDelContexto 
--				,@TablaId = @TablaId
--				,@FuncionDePaginaId = @FuncionDePaginaId
--				,@RolMenosPrioritarioQueCarga = @RolDeUsuario_Administrador -- Es web, debería usar el Admin Anónimo
--				,@RolMenosPrioritarioQueOpera = @RolDeUsuario_Administrador -- Es web, debería usar el Admin Anónimo
--				,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_Administrador -- Es web, debería usar el Admin Anónimo
--				,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_Administrador -- Es web, debería usar el Admin Anónimo
--				,@sResSQL = @sResSQL OUTPUT
--				,@id = @id OUTPUT
--				--SELECT 'Pagina insertada id = ' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
--				SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
--				IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
		 	

--		SET @Nombre = '# Web/TablaXXX/Registro #'
--		SET @TablaId = (SELECT id FROM Tablas WHERE Nombre = 'TablaXXX')
--		SET @FuncionDePaginaId = (SELECT id FROM FuncionesDePaginas WHERE Nombre = 'Registro')
--		EXEC usp_Paginas__InsertSegunPrioridadRoles  
--				@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
--				,@FechaDeEjecucion = @FechaDeEjecucion
--				,@Token = @Token 
--				,@Seccion = @Seccion_Web
--				,@CodigoDelContexto = @CodigoDelContexto 
--				,@TablaId = @TablaId
--				,@FuncionDePaginaId = @FuncionDePaginaId
--				,@RolMenosPrioritarioQueCarga = @RolDeUsuario_Administrador -- Es web, debería usar el Admin Anónimo
--				,@RolMenosPrioritarioQueOpera = @RolDeUsuario_Administrador -- Es web, debería usar el Admin Anónimo
--				,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_Administrador -- Es web, debería usar el Admin Anónimo
--				,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_Administrador -- Es web, debería usar el Admin Anónimo
--				,@sResSQL = @sResSQL OUTPUT
--				,@id = @id OUTPUT
--				--SELECT 'Pagina insertada id = ' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
--				SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
--				IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
		
		
--		-- Se usa para revisar permisos al actualizar los datos de archivos sobre los matriculados:
--		SET @Nombre = '# Web/TablaXXX/Update #'
--		SET @TablaId = (SELECT id FROM Tablas WHERE Nombre = 'TablaXXX')
--		SET @FuncionDePaginaId = (SELECT id FROM FuncionesDePaginas WHERE Nombre = 'Update')
--		EXEC usp_Paginas__InsertSegunPrioridadRoles  
--				@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
--				,@FechaDeEjecucion = @FechaDeEjecucion
--				,@Token = @Token 
--				,@Seccion = @Seccion_Web
--				,@CodigoDelContexto = @CodigoDelContexto 
--				,@TablaId = @TablaId
--				,@FuncionDePaginaId = @FuncionDePaginaId
--				,@RolMenosPrioritarioQueCarga = @RolDeUsuario_Administrador -- Es web, debería usar el Admin Anónimo
--				,@RolMenosPrioritarioQueOpera = @RolDeUsuario_Administrador -- Es web, debería usar el Admin Anónimo
--				,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_Administrador -- Es web, debería usar el Admin Anónimo
--				,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_Administrador -- Es web, debería usar el Admin Anónimo
--				,@sResSQL = @sResSQL OUTPUT
--				,@id = @id OUTPUT
--				--SELECT 'Pagina insertada id = ' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
--				SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
--				IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
--	--Web/TablaXXX - FIN
---- INSERT VALUES: Paginas - FIN


-- =====================================================
-- Script: DB_ParticularCore__P19c_Insert Values del Sistema_Prioritarios 3 - Paginas Específicas.sql - FIN
-- -------------------------
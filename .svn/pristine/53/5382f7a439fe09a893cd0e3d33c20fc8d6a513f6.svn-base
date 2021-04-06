-- =====================================================
-- Descripción: Agregamos el contexto
-- Script: DB_XXX__P20a_Add Contexto XXX.sql - INICIO
-- =====================================================

USE DB_XXX
GO

				--- Variable que utilizamos en los insert - INICIO
					DECLARE	@Seccion_Administracion VARCHAR(30)
						,@Seccion_Intranet VARCHAR(30)
						,@Seccion_Web VARCHAR(30)
						,@Seccion_PrivadaDelUsuario VARCHAR(30)
		
					EXEC @Seccion_Administracion = ufc_Secciones__Administracion
					EXEC @Seccion_Intranet = ufc_Secciones__Intranet
					EXEC @Seccion_Web = ufc_Secciones__Web
					EXEC @Seccion_PrivadaDelUsuario = ufc_Secciones__PrivadaDelUsuario
					
					
					DECLARE @UsuarioQueEjecutaId	INT = '1' -- OJO, q si va UsuarioId=1 -- > Va En ContextoId=1 --> no logueable
						,@FechaDeEjecucion			DATETIME = GetDate()
						
						,@Token                     VARCHAR(40) = 'OperacionDeCore'
 						
 						--,@Seccion					VARCHAR(30) = @Seccion_Administracion -- Las páginas que se crearán deben ir es esta sección.
						,@CodigoDelContexto			VARCHAR(40) = NULL -- 'XXX'
						
						,@sResSQL VARCHAR(1000)	
						,@id INT
						
						,@IconoGenericoCSSId	INT = 1
						,@ActorId INT
						,@UltimoLoginSesionId INT
						,@Nombre VARCHAR(100)
						,@Mensaje VARCHAR(MAX)
						,@TablaDelExec VARCHAR(80)
				-- Variable que utilizamos en los insert - FIN
				
				
	SET @TablaDelExec = 'Contextos'
	PRINT 'Insertando sobre la tabla: ' + @TablaDelExec
	
	SET @Nombre = 'XXX'
	EXEC usp_Contextos__InsertConAdicionales
			@UsuarioQueEjecutaId = @UsuarioQueEjecutaId 
			,@FechaDeEjecucion = @FechaDeEjecucion 
			,@Token = @Token 
			,@Seccion = @Seccion_Administracion
			,@CodigoDelContexto = @CodigoDelContexto 
 			,@Nombre = @Nombre
			,@Codigo = 'XXX'
			,@CarpetaDeContenidos = 'CarpetaDeXXX'
			,@Observaciones = ''
			,@PassDeUsuarios = '15b60a029e0653c24725d5d625b2d571a0db202d' -- 3ntr0p1A
			,@sResSQL = @sResSQL OUTPUT
			,@id = @id OUTPUT
			SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
			IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END 
		
	SELECT '@ContextoId= ' + CAST(@id AS VARCHAR(MAX))	
	
	
			--Creará los usuarios del contexto @Codigo:
				-- masteradmin@ // masteradmin del sistema, para nosotros. // También tendrá el rol "Pedir Soportes".
				-- anonimo@ // anónimo del sistema, para realizar las operaciones cuando no tenemos un usuario logueado o realizar operaciones "secundarias" "sin permisos".
				-- administrador@ // administrador del sistema, se lo damos al cliente. // También tendrá el rol "Pedir Soportes".
				-- soporte@ // Para administrar los soportes solicitados en el sistema.
				-- testoperador@ // Para testear
				-- testoperadoravanzado@ // Para testear
				-- testadministrador@ // Para testear
				-- testmasteradmin@ // Para testear
			-- (Todos con el mismo pwd indicado)


	DECLARE @administrador INT = (SELECT id FROM Usuarios WHERE UserName = 'administrador' AND ContextoId = @id)


	-- LE ASIGNAMOS EL ROL DE RECIBIR NOTIFICACIONES DE NUEVAS SOLICITUDES DE MATRICULACIÓN AL OPERADOR DE TEST:
	DECLARE @RecibeNotifDeSolicitudesId INT
		,@testoperador INT = (SELECT id FROM Usuarios WHERE UserName = 'testoperador' AND ContextoId = @id)
	
	EXEC @RecibeNotifDeSolicitudesId = ufc_RolesDeUsuariosP__RecibeNotifDeSolicitudesId
	
	INSERT INTO RelAsig_RolesDeUsuarios_A_Usuarios (RolDeUsuarioId, UsuarioId, FechaDesde) 
					VALUES (@RecibeNotifDeSolicitudesId, @testoperador, @FechaDeEjecucion)
		
		-- También se lo asigno al administrador:
		INSERT INTO RelAsig_RolesDeUsuarios_A_Usuarios (RolDeUsuarioId, UsuarioId, FechaDesde) 
					VALUES (@RecibeNotifDeSolicitudesId, @administrador, @FechaDeEjecucion)
					
					
	-- LE ASIGNAMOS EL ROL DE RECIBIR NOTIFICACIONES DE CADA CAMBIO REALIZADO POR UN MATRICULADO AL OPERADOR AVANZADO DE TEST:
	DECLARE @RecibeNotifPorCambiosDeMatriculadosId INT
		,@testoperadoravanzado INT = (SELECT id FROM Usuarios WHERE UserName = 'testoperadoravanzado' AND ContextoId = @id)
	
	EXEC @RecibeNotifPorCambiosDeMatriculadosId = ufc_RolesDeUsuariosP__RecibeNotifPorCambiosDeMatriculadosId
	
	INSERT INTO RelAsig_RolesDeUsuarios_A_Usuarios (RolDeUsuarioId, UsuarioId, FechaDesde) 
					VALUES (@RecibeNotifPorCambiosDeMatriculadosId, @testoperadoravanzado, @FechaDeEjecucion)
		
		-- También se lo asigno al administrador:		
		INSERT INTO RelAsig_RolesDeUsuarios_A_Usuarios (RolDeUsuarioId, UsuarioId, FechaDesde) 
					VALUES (@RecibeNotifPorCambiosDeMatriculadosId, @administrador, @FechaDeEjecucion)
					
					
	SELECT * FROM Contextos
	SELECT * FROM Usuarios
	SELECT * FROM RelAsig_RolesDeUsuarios_A_Usuarios


-- ---------------------------
-- Script: DB_XXX__P20a_Add Contexto XXX.sql - FIN
-- =====================================================
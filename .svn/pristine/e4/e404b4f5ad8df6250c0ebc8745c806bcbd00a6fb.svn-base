-- =====================================================
-- Descripción: SPs Prioritarios de 2do orden (B)
-- Script: DB_ParticularCore__C09b_ABMs PrioritariosB_Contextos, Paginas, Tablas y Usuarios.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO

		-- ABMs que involucran a las Tablas: - INICIO
				-- Contextos
				-- Paginas
				-- RelAsig_RolesDeUsuarios_A_Paginas
				-- RelAsig_RolesDeUsuarios_A_Usuarios
				-- Tablas
				-- Usuarios
		-- ABMs que involucran a las Tablas: - FIN

		-- IGNORAR LOS MENSAJES: (Saltan solo por el orden en que están los SPs)
			-- The module 'usp_RelAsig_RolesDeUsuarios_A_Paginas__InsertSegunPrioridadRoles' depends on the missing object 'usp_RelAsig_RolesDeUsuarios_A_Paginas__Update_by_@RolesIdsString'. The module will still be created; however, it cannot run successfully until the object exists.
			-- The module 'usp_RelAsig_RolesDeUsuarios_A_Paginas__InsertSegunRoles' depends on the missing object 'usp_RelAsig_RolesDeUsuarios_A_Paginas__Update_by_@RolesIdsString'. The module will still be created; however, it cannot run successfully until the object exists.


-- SP-TABLA: Contextos /ABMs/ - INICIO
IF (OBJECT_ID('usp_Contextos__InsertConAdicionales') IS NOT NULL) DROP PROCEDURE usp_Contextos__InsertConAdicionales
GO
CREATE PROCEDURE usp_Contextos__InsertConAdicionales
-- Agrega el contexto, y luego 5 usuarios. El "administrador" + 4 de testeo: testoperador, testoperadoravanzado, testadministrador, testmasteradmin (con sus respectivos roles); Todos con el Pass = @PassDeUsuarios.
	 @UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@Nombre                                        VARCHAR(100)
	,@Codigo                                        VARCHAR(40)
	,@CarpetaDeContenidos                           VARCHAR(16)
	,@Observaciones                                 VARCHAR(1000)
	
	,@AgregarUsuarios								BIT = '1'
	,@PassDeUsuarios								VARCHAR(40)
	
	,@sResSQL                                       VARCHAR(1000)	OUTPUT
	,@id                                            INT		OUTPUT
AS
BEGIN TRY
BEGIN TRAN -- El Try va primero, si no, luego recibimos errores del tipo "The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION"
	DECLARE @Tabla VARCHAR(80) = 'Contextos'
		,@FuncionDePagina VARCHAR(30) = 'Insert'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)

	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
				, @RegistroId = @id 
				--, @UsuarioId = @UsuarioId OUTPUT 
				, @sResSQL = @sResSQL OUTPUT
	
	-- 1ero Creamos el Contexto
	IF @sResSQL = ''
		BEGIN
			EXEC usp_Contextos__Insert  
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					,@FechaDeEjecucion = @FechaDeEjecucion
					,@Token = @Token
					,@Seccion = @Seccion
					,@CodigoDelContexto = @CodigoDelContexto
					,@Nombre = @Nombre
					,@Codigo = @Codigo
					,@CarpetaDeContenidos = @CarpetaDeContenidos
					,@Observaciones = @Observaciones
					,@sResSQL = @sResSQL OUTPUT
					,@id = @id OUTPUT
			
			DECLARE @ContextoId INT = @id -- Para guardarlo y devolverlo al final
		END
	
	-- 2do Creamos los usuarios para testeo de este contexto
	IF @sResSQL = ''
		BEGIN
			DECLARE @UltimoLoginSesionId INT
				,@RolDeUsuario_Operador_Id INT
				,@RolDeUsuario_OperadorAvanzado_Id INT
				,@RolDeUsuario_Administrador_Id INT
				,@RolDeUsuario_MasterAdmin_Id INT
				,@RolDeUsuario_PedirSoportes_Id INT
				,@RolDeUsuario_AdministrarSoportes_Id INT
				,@RolDeUsuario_RecibeNotifPorModifInformes_Id INT
				,@RolDeUsuario_RecibeNotifPorModifUsuarios_Id INT
			
			EXEC @RolDeUsuario_Operador_Id = ufc_RolesDeUsuarios__OperadorId
			EXEC @RolDeUsuario_OperadorAvanzado_Id = ufc_RolesDeUsuarios__OperadorAvanzadoId
			EXEC @RolDeUsuario_Administrador_Id = ufc_RolesDeUsuarios__AdministradorId
			EXEC @RolDeUsuario_MasterAdmin_Id = ufc_RolesDeUsuarios__MasterAdminId
			EXEC @RolDeUsuario_PedirSoportes_Id = ufc_RolesDeUsuarios__PedirSoportesId
			EXEC @RolDeUsuario_AdministrarSoportes_Id = ufc_RolesDeUsuarios__AdministrarSoportesId
			EXEC @RolDeUsuario_RecibeNotifPorModifInformes_Id = ufc_RolesDeUsuarios__RecibeNotifPorModifInformesId
			EXEC @RolDeUsuario_RecibeNotifPorModifUsuarios_Id = ufc_RolesDeUsuarios__RecibeNotifPorModifUsuariosId
			
			DECLARE @Usuario_MasterAdmin VARCHAR(40)
				,@Usuario_Anonimo VARCHAR(40)
				,@Usuario_Administrador VARCHAR(40)
				,@Usuario_AdministradorDeSoportes VARCHAR(40)
				
			EXEC @Usuario_MasterAdmin = ufc_Usuarios__MasterAdmin
			EXEC @Usuario_Anonimo = ufc_Usuarios__Anonimo
			EXEC @Usuario_Administrador = ufc_Usuarios__Administrador
			EXEC @Usuario_AdministradorDeSoportes = ufc_Usuarios__AdministradorDeSoportes
			
				
			--"Agregado Diciembre 2019": Ahora creamos un masteradmin
			-- 1ero insertamos al administrador del dominio
			SET @UltimoLoginSesionId = RAND()*100000000 -- 8 digitos
			INSERT INTO Usuarios (ContextoId, UserName, Pass, Nombre, Apellido, UltimoLoginSesionId, SeMuestraEnAsignacionDeRoles) 
							VALUES (@id, @Usuario_MasterAdmin, @PassDeUsuarios, @Usuario_MasterAdmin, @Codigo, @UltimoLoginSesionId, '0')
			
			DECLARE @Usuario_Master_DelContexto_Id INT = (SELECT id FROM Usuarios WHERE ContextoId = @id AND UserName = @Usuario_MasterAdmin)
				-- Ahora le asignamos el rol de masteradmin
				INSERT INTO RelAsig_RolesDeUsuarios_A_Usuarios (RolDeUsuarioId, UsuarioId, FechaDesde) 
								VALUES (@RolDeUsuario_MasterAdmin_Id, @Usuario_Master_DelContexto_Id, @FechaDeEjecucion)
				-- También le asignamos el rol de Pedir Soportes
				INSERT INTO RelAsig_RolesDeUsuarios_A_Usuarios (RolDeUsuarioId, UsuarioId, FechaDesde) 
								VALUES (@RolDeUsuario_PedirSoportes_Id, @Usuario_Master_DelContexto_Id, @FechaDeEjecucion)
			
			
			-- 2do insertamos al "anonimo" del dominio
			SET @UltimoLoginSesionId = RAND()*100000000 -- 8 digitos
			INSERT INTO Usuarios (ContextoId, UserName, Pass, Nombre, Apellido, UltimoLoginSesionId, SeMuestraEnAsignacionDeRoles) 
							VALUES (@id, @Usuario_Anonimo, ' q n0 S3 PUEDA log1n ' , @Usuario_Anonimo, @Codigo, @UltimoLoginSesionId, '0')
			
			DECLARE @Usuario_Anonimo_DelContexto_Id INT = (SELECT id FROM Usuarios WHERE ContextoId = @id AND UserName = @Usuario_Anonimo)
				-- Ahora le asignamos el rol de Administrador
				INSERT INTO RelAsig_RolesDeUsuarios_A_Usuarios (RolDeUsuarioId, UsuarioId, FechaDesde) 
								VALUES (@RolDeUsuario_Administrador_Id, @Usuario_Anonimo_DelContexto_Id, @FechaDeEjecucion)
				-- También le asignamos el rol de Pedir Soportes
				INSERT INTO RelAsig_RolesDeUsuarios_A_Usuarios (RolDeUsuarioId, UsuarioId, FechaDesde) 
								VALUES (@RolDeUsuario_PedirSoportes_Id, @Usuario_Anonimo_DelContexto_Id, @FechaDeEjecucion)
							
							
			-- 3ro insertamos al administrador del dominio
			SET @UltimoLoginSesionId = RAND()*100000000 -- 8 digitos
			INSERT INTO Usuarios (ContextoId, UserName, Pass, Nombre, Apellido, UltimoLoginSesionId, SeMuestraEnAsignacionDeRoles) 
							VALUES (@id, @Usuario_Administrador, @PassDeUsuarios, @Usuario_Administrador, @Codigo, @UltimoLoginSesionId, '0')
			
			DECLARE @Usuario_Admin_DelContexto_Id INT = (SELECT id FROM Usuarios WHERE ContextoId = @id AND UserName = @Usuario_Administrador)
				-- Ahora le asignamos el rol de Administrador
				INSERT INTO RelAsig_RolesDeUsuarios_A_Usuarios (RolDeUsuarioId, UsuarioId, FechaDesde) 
								VALUES (@RolDeUsuario_Administrador_Id, @Usuario_Admin_DelContexto_Id, @FechaDeEjecucion)
				-- También le asignamos el rol de Pedir Soportes
				INSERT INTO RelAsig_RolesDeUsuarios_A_Usuarios (RolDeUsuarioId, UsuarioId, FechaDesde) 
								VALUES (@RolDeUsuario_PedirSoportes_Id, @Usuario_Admin_DelContexto_Id, @FechaDeEjecucion)
				-- También le asignamos el rol de ser notificado por informes
				INSERT INTO RelAsig_RolesDeUsuarios_A_Usuarios (RolDeUsuarioId, UsuarioId, FechaDesde) 
							VALUES (@RolDeUsuario_RecibeNotifPorModifInformes_Id, @Usuario_Admin_DelContexto_Id, @FechaDeEjecucion)
				-- También le asignamos el rol de ser notificado por usuarios
				INSERT INTO RelAsig_RolesDeUsuarios_A_Usuarios (RolDeUsuarioId, UsuarioId, FechaDesde) 
							VALUES (@RolDeUsuario_RecibeNotifPorModifUsuarios_Id, @Usuario_Admin_DelContexto_Id, @FechaDeEjecucion)
							
							
			IF @Usuario_Master_DelContexto_Id IS NULL OR @Usuario_Admin_DelContexto_Id IS NULL
				BEGIN
					SET @sResSQL = 'El Contexto se creó correctamente, pero no se pudo crear el Administrador, ni ningún usuario.'
				END
			
			
			IF @sResSQL = '' -- Agrego el usuario que dará soporte en el sistema. 1ero lo agregamos como 'Master Admin', luego le damos el rol.
				BEGIN
					SET @UltimoLoginSesionId = RAND()*100000000 -- 8 digitos
					EXEC usp_Usuarios__Insert  
							@UsuarioQueEjecutaId = @Usuario_Master_DelContexto_Id -- Va con el MASTERADMIN, para que tome ese contexto. y pueda tomar el rol de Admin Soportes.
							,@FechaDeEjecucion = @FechaDeEjecucion
							,@Token = @Token
							,@Seccion = @Seccion
							,@CodigoDelContexto = @CodigoDelContexto
							,@UserName = @Usuario_AdministradorDeSoportes
							,@Pass = @PassDeUsuarios
							,@Nombre = 'Administrador de Soportes'
							,@Apellido = @Codigo
							,@Email = ''
							,@Email2 = ''
							,@Telefono = ''
							,@Telefono2 = ''
							,@Direccion = ''
							,@Observaciones = ''
							,@RolDeUsuarioId = @RolDeUsuario_AdministrarSoportes_Id -- Con el que inicia
							,@SeMuestraEnAsignacionDeRoles = '0'
							,@Activo = '1'
							,@sResSQL = @sResSQL OUTPUT
							,@id = @id OUTPUT
				END
			
			-- Ahora lo agregamos con MASTERADMIN --> verificar que funciona
			--IF @sResSQL = '' -- Acá le agregamos a soporte@ el rol de Administrar Soportes. LO TENEMOS QUE AGREGAR SIN EXEC, POR QUE SOLO UN MASTER ADMIN PUEDE CONCEDER ESTE ROL.
			--	BEGIN
			--		INSERT INTO RelAsig_RolesDeUsuarios_A_Usuarios (RolDeUsuarioId, UsuarioId, FechaDesde) 
			--				VALUES (@RolDeUsuario_PedirSoportes_Id, @id, @FechaDeEjecucion)
			--	END
			
			
			IF @sResSQL = '' -- Agregamos al usuario test@ para que se vea en las operaciones, en los DDLUsuarios cuando testeamos
				BEGIN
					SET @UltimoLoginSesionId = RAND()*100000000 -- 8 digitos
					EXEC usp_Usuarios__Insert  
							@UsuarioQueEjecutaId = @Usuario_Admin_DelContexto_Id -- Se lo ponemos con el admin por que este usuario si se ve.
							,@FechaDeEjecucion = @FechaDeEjecucion
							,@Token = @Token
							,@Seccion = @Seccion
							,@CodigoDelContexto = @CodigoDelContexto
							,@UserName = 'test'
							,@Pass = @PassDeUsuarios
							,@Nombre = 'De Test'
							,@Apellido = @Codigo
							,@Email = ''
							,@Email2 = ''
							,@Telefono = ''
							,@Telefono2 = ''
							,@Direccion = ''
							,@Observaciones = ''
							,@RolDeUsuarioId = @RolDeUsuario_Operador_Id -- Con el que inicia
							,@SeMuestraEnAsignacionDeRoles = '1' -- Este si se muestra para que salga en los DDLUsuarios cuando testeamos
							,@Activo = '1'
							,@sResSQL = @sResSQL OUTPUT
							,@id = @id OUTPUT
				END
				
			
			IF @sResSQL = '' -- Agregamos al usuario testoperador@ para testear con ese rol
				BEGIN
					SET @UltimoLoginSesionId = RAND()*100000000 -- 8 digitos
					EXEC usp_Usuarios__Insert  
							@UsuarioQueEjecutaId = @Usuario_Master_DelContexto_Id --@Usuario_Admin_DelContexto_Id --   /aca/ @Usuario_Master_DelContexto_Id -- Va con el Master por que es un usuario reservado, si no, con el Administrador le da error de permisos por ser reservado (@SeMuestraEnAsignacionDeRoles = '0'). Y con el master tambien toma su contexto.
							,@FechaDeEjecucion = @FechaDeEjecucion
							,@Token = @Token
							,@Seccion = @Seccion
							,@CodigoDelContexto = @CodigoDelContexto
							,@UserName = 'testoperador'
							,@Pass = @PassDeUsuarios
							,@Nombre = 'Test operador'
							,@Apellido = @Codigo
							,@Email = ''
							,@Email2 = ''
							,@Telefono = ''
							,@Telefono2 = ''
							,@Direccion = ''
							,@Observaciones = ''
							,@RolDeUsuarioId = @RolDeUsuario_Operador_Id -- Con el que inicia
							,@SeMuestraEnAsignacionDeRoles = '0'
							,@Activo = '1'
							,@sResSQL = @sResSQL OUTPUT
							,@id = @id OUTPUT
				END
			
			IF @sResSQL = '' -- Agregamos al usuario testoperadoravanzado@ para testear con ese rol
				BEGIN
					SET @UltimoLoginSesionId = RAND()*100000000 -- 8 digitos
					EXEC usp_Usuarios__Insert  
							@UsuarioQueEjecutaId = @Usuario_Master_DelContexto_Id -- Va con el Master por que es un usuario reservado, si no, con el Administrador le da error de permisos por ser reservado (@SeMuestraEnAsignacionDeRoles = '0'). Y con el master tambien toma su contexto.
							,@FechaDeEjecucion = @FechaDeEjecucion
							,@Token = @Token
							,@Seccion = @Seccion
							,@CodigoDelContexto = @CodigoDelContexto
							,@UserName = 'testoperadoravanzado'
							,@Pass = @PassDeUsuarios
							,@Nombre = 'Test operador avanzado'
							,@Apellido = @Codigo
							,@Email = ''
							,@Email2 = ''
							,@Telefono = ''
							,@Telefono2 = ''
							,@Direccion = ''
							,@Observaciones = ''
							,@RolDeUsuarioId = @RolDeUsuario_OperadorAvanzado_Id -- Con el que inicia
							,@SeMuestraEnAsignacionDeRoles = '0'
							,@Activo = '1'
							,@sResSQL = @sResSQL OUTPUT
							,@id = @id OUTPUT
				END
				
			IF @sResSQL = '' -- Agregamos al usuario testadministrador@ para testear con ese rol
				BEGIN	
					SET @UltimoLoginSesionId = RAND()*100000000 -- 8 digitos
					EXEC usp_Usuarios__Insert  
							@UsuarioQueEjecutaId = @Usuario_Master_DelContexto_Id -- Va con el Master por que es un usuario reservado, si no, con el Administrador le da error de permisos por ser reservado (@SeMuestraEnAsignacionDeRoles = '0'). Y con el master tambien toma su contexto.
							,@FechaDeEjecucion = @FechaDeEjecucion
							,@Token = @Token
							,@Seccion = @Seccion
							,@CodigoDelContexto = @CodigoDelContexto
							,@UserName = 'testadministrador'
							,@Pass = @PassDeUsuarios
							,@Nombre = 'Test administrador'
							,@Apellido = @Codigo
							,@Email = ''
							,@Email2 = ''
							,@Telefono = ''
							,@Telefono2 = ''
							,@Direccion = ''
							,@Observaciones = ''
							,@RolDeUsuarioId = @RolDeUsuario_Administrador_Id -- Con el que inicia
							,@SeMuestraEnAsignacionDeRoles = '0'
							,@Activo = '1'
							,@sResSQL = @sResSQL OUTPUT
							,@id = @id OUTPUT
				END
				
			IF @sResSQL = '' -- Agregamos al usuario testmasteradmin@ para testear con ese rol
				BEGIN	
					SET @UltimoLoginSesionId = RAND()*100000000 -- 8 digitos
					EXEC usp_Usuarios__Insert  
							@UsuarioQueEjecutaId = @Usuario_Master_DelContexto_Id -- Va con el Master por que es un usuario reservado, si no, con el Administrador le da error de permisos por ser reservado (@SeMuestraEnAsignacionDeRoles = '0'). Y con el master tambien toma su contexto.
							,@FechaDeEjecucion = @FechaDeEjecucion
							,@Token = @Token
							,@Seccion = @Seccion
							,@CodigoDelContexto = @CodigoDelContexto
							,@UserName = 'testmasteradmin'
							,@Pass = @PassDeUsuarios
							,@Nombre = 'Test master admin'
							,@Apellido = @Codigo
							,@Email = ''
							,@Email2 = ''
							,@Telefono = ''
							,@Telefono2 = ''
							,@Direccion = ''
							,@Observaciones = ''
							,@RolDeUsuarioId = @RolDeUsuario_MasterAdmin_Id -- Con el que inicia
							,@SeMuestraEnAsignacionDeRoles = '0'
							,@Activo = '1'
							,@sResSQL = @sResSQL OUTPUT
							,@id = @id OUTPUT
				END
		END
		
	-- Insertamos una categoría de informes de ejemplo (para que tenga un "default")
	IF @sResSQL = ''
		BEGIN
			EXEC  usp_CategoriasDeInformes__Insert  
						@UsuarioQueEjecutaId = @Usuario_Admin_DelContexto_Id -- Va con el Administrador, para que tome ese contexto.
						,@FechaDeEjecucion = @FechaDeEjecucion
						,@Token = @Token
						,@Seccion = @Seccion
						,@CodigoDelContexto = @CodigoDelContexto
						,@Nombre = '-De ejemplo- "editar!"'
						,@Observaciones	= ''
						,@sResSQL = @sResSQL OUTPUT
						,@id = @id OUTPUT
		END
		
	-- Insertamos un tipo de tarea de ejemplo (para que tenga un "default")
	IF @sResSQL = ''
		BEGIN
			EXEC  usp_TiposDeTareas__Insert  
						@UsuarioQueEjecutaId = @Usuario_Admin_DelContexto_Id -- Va con el Administrador, para que tome ese contexto.
						,@FechaDeEjecucion = @FechaDeEjecucion
						,@Token = @Token
						,@Seccion = @Seccion
						,@CodigoDelContexto = @CodigoDelContexto
						,@Nombre = '-De ejemplo- "editar!"'
						,@Observaciones	= ''
						,@sResSQL = @sResSQL OUTPUT
						,@id = @id OUTPUT
		END
	
	-- Insertamos un grupo de contactos de ejemplo (para que tenga un "default")
	IF @sResSQL = ''
		BEGIN
			EXEC  usp_GruposDeContactos__Insert  
						@UsuarioQueEjecutaId = @Usuario_Admin_DelContexto_Id -- Va con el Administrador, para que tome ese contexto.
						,@FechaDeEjecucion = @FechaDeEjecucion
						,@Token = @Token
						,@Seccion = @Seccion
						,@CodigoDelContexto = @CodigoDelContexto
						,@Nombre = '-De ejemplo- "editar!"'
						,@Observaciones	= ''
						,@sResSQL = @sResSQL OUTPUT
						,@id = @id OUTPUT
		END
			
	-- Insertamos una Asignación de Tipos de Contactos al Contexto tipo de tarea de ejemplo (para que tenga un "default")
	IF @sResSQL = ''
		BEGIN
			DECLARE @TipoDeContactoId INT = (SELECT id FROM TiposDeContactos WHERE Nombre = ' -Sin indicar-')
			EXEC  usp_RelAsig_TiposDeContactos_A_Contextos__Insert  
						@UsuarioQueEjecutaId = @Usuario_Admin_DelContexto_Id -- Va con el Administrador, para que tome ese contexto.
						,@FechaDeEjecucion = @FechaDeEjecucion
						,@Token = @Token
						,@Seccion = @Seccion
						,@CodigoDelContexto = @CodigoDelContexto
						,@TipoDeContactoId = @TipoDeContactoId
						,@sResSQL = @sResSQL OUTPUT
						,@id = @id OUTPUT
				
				
			SET @TipoDeContactoId = (SELECT id FROM TiposDeContactos WHERE Nombre = 'Clientes')
			EXEC  usp_RelAsig_TiposDeContactos_A_Contextos__Insert  
						@UsuarioQueEjecutaId = @Usuario_Admin_DelContexto_Id -- Va con el Administrador, para que tome ese contexto.
						,@FechaDeEjecucion = @FechaDeEjecucion
						,@Token = @Token
						,@Seccion = @Seccion
						,@CodigoDelContexto = @CodigoDelContexto
						,@TipoDeContactoId = @TipoDeContactoId
						,@sResSQL = @sResSQL OUTPUT
						,@id = @id OUTPUT
				
				
			SET @TipoDeContactoId = (SELECT id FROM TiposDeContactos WHERE Nombre = 'Proveedores')
			EXEC  usp_RelAsig_TiposDeContactos_A_Contextos__Insert  
						@UsuarioQueEjecutaId = @Usuario_Admin_DelContexto_Id -- Va con el Administrador, para que tome ese contexto.
						,@FechaDeEjecucion = @FechaDeEjecucion
						,@Token = @Token
						,@Seccion = @Seccion
						,@CodigoDelContexto = @CodigoDelContexto
						,@TipoDeContactoId = @TipoDeContactoId
						,@sResSQL = @sResSQL OUTPUT
						,@id = @id OUTPUT
				
				
			SET @TipoDeContactoId = (SELECT id FROM TiposDeContactos WHERE Nombre = 'Transportistas')
			EXEC  usp_RelAsig_TiposDeContactos_A_Contextos__Insert  
						@UsuarioQueEjecutaId = @Usuario_Admin_DelContexto_Id -- Va con el Administrador, para que tome ese contexto.
						,@FechaDeEjecucion = @FechaDeEjecucion
						,@Token = @Token
						,@Seccion = @Seccion
						,@CodigoDelContexto = @CodigoDelContexto
						,@TipoDeContactoId = @TipoDeContactoId
						,@sResSQL = @sResSQL OUTPUT
						,@id = @id OUTPUT
		END
		
		SET @id = @ContextoId -- Recupero el @id
		
	IF @sResSQL = ''
		BEGIN
			COMMIT TRAN
		END
	ELSE
		BEGIN
			SET @sResSQL = COALESCE(@sResSQL, '-NULL-')
			RAISERROR (@sResSQL, 16, 1) --> ROLLBACK TRAN // RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState) // De esta forma, se hace el ROLLBACK, pero queda registrado el error en LogErrores.
		END		
END TRY
BEGIN CATCH
	ROLLBACK TRAN -- // IF @@TRANCOUNT > 0 ROLLBACK TRAN -- TR_CX_InstCAdicionales; // IF EXISTS (SELECT name FROM sys.dm_tran_active_transactions WHERE name = 'TR_CX_InstCAdicionales') ROLLBACK TRAN -- TR_CX_InstCAdicionales; -- El IF EXIST es para q no tire error de q no existe la TRAN --  a Rollbackear y me enmascare el verdadero error q tengo.
	
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			, @RegistroId = @id 
 			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO




IF (OBJECT_ID('usp_Contextos__Insert') IS NOT NULL) DROP PROCEDURE usp_Contextos__Insert
GO
CREATE PROCEDURE usp_Contextos__Insert
	 @UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@Nombre                                        VARCHAR(100)
	,@Codigo                                        VARCHAR(40)
	,@CarpetaDeContenidos                           VARCHAR(16)
	,@Observaciones                                 VARCHAR(1000)
 
	,@sResSQL                                       VARCHAR(1000)	OUTPUT
	,@id                                            INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Contextos'
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
			DECLARE @Numero INT
			EXEC @Numero = ufc_Registros__ValorSiguiente @Tabla = @Tabla, @Campo = 'Numero'
 
			SET NOCOUNT ON
			INSERT INTO Contextos
			(
				Numero
				,Nombre
				,Codigo
				,CarpetaDeContenidos
				,Observaciones
			)
			VALUES
			(
				@Numero
				,@Nombre
				,LOWER(@Codigo) -- Para que no se repita con Mayúsculas
				,@CarpetaDeContenidos
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
 
 
 
 
IF (OBJECT_ID('usp_Contextos__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_Contextos__Update_by_@id
GO
CREATE PROCEDURE usp_Contextos__Update_by_@id
	 @id                                            INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@Nombre                                        VARCHAR(100)
	,@Codigo                                        VARCHAR(40)
	,@CarpetaDeContenidos                           VARCHAR(16)
	,@Observaciones                                 VARCHAR(1000)
 
	,@sResSQL                                       VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Contextos'
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
			UPDATE Contextos
			SET
				Nombre = @Nombre
				,Codigo = LOWER(@Codigo) -- Para que no se repita con Mayúsculas
				,CarpetaDeContenidos = @CarpetaDeContenidos
				,Observaciones = @Observaciones
			FROM Contextos
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
-- SP-TABLA: Contextos /ABMs/ - FIN




-- SP-TABLA: Paginas /ABMs/ - INICIO
IF (OBJECT_ID('usp_Paginas__Insert') IS NOT NULL) DROP PROCEDURE usp_Paginas__Insert -- NO HAY UN SP "usp_Paginas__Insert" (Si existía previamente lo eliminamos).
GO
IF (OBJECT_ID('usp_Paginas__InsertSegunPrioridadRoles') IS NOT NULL) DROP PROCEDURE usp_Paginas__InsertSegunPrioridadRoles
GO
CREATE PROCEDURE usp_Paginas__InsertSegunPrioridadRoles
	-- Validaciones:
		-- 1) Si @SaltarRegistrosExistentes = '1' --> No intenta insertar la Página, guarda ese id y continúa intentando insertar las relaciones a los roles correspondientes (También pasándoles el parámetro: @SaltarRegistrosExistentes).
	-------------
	-- Acotaciones:
		-- Este SP SE UTILIZA EN EL PASO 2 del procedimiento que se describe a continuación, como parte del proceso automático de creación de las Páginas (asociadas), al crear una Tabla.
		-- El Insert de las tablas tiene un encadenamiento de 3 niveles:
		-- 1: Genera la tabla en cuestion --> Llama (EXECUTE) al SP "usp_Paginas__Insert" n veces (donde n son las FuncionesDePaginas existentes).
		-- 2: CADA EXECUTE indicado en 1 va generando TODAS las Páginas q incluyen la tabla Insertada, y dentro de c/u llama (EXECUTE) al SP: "usp_RelAsig_RolesDeUsuarios_A_Paginas__InsertSegunPrioridadRoles" 
		-- 3: EL EXECUTE INDICADO EN 2 va Insertando TODOS los RolesDeusuarios con permisos a esa Página.
	-------------
	@UsuarioQueEjecutaId        INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
				
	,@SaltarRegistrosExistentes					BIT = '0' --  Si = '1' --> Busca si existe la relación y omite insertarla por duplicado (lo cual produciría un error).
	
	,@TablaId									INT	
	,@FuncionDePaginaId							INT	
	,@RolMenosPrioritarioQueCarga				VARCHAR(50)
	,@RolMenosPrioritarioQueOpera				VARCHAR(50)
	,@RolMenosPrioritarioQueVerRegAnulados		VARCHAR(50)
	,@RolMenosPrioritarioQueAccionesEspeciales	VARCHAR(50)
	,@Nombre									VARCHAR(100) = ''
	,@Titulo									VARCHAR(100) = ''
	,@Tips										VARCHAR(2000) = ''		
	,@Observaciones								VARCHAR(2000) = ''	
	,@SeMuestraEnAsignacionDePermisos			BIT	= '1'
	
	,@sResSQL									VARCHAR(1000)	OUTPUT
	,@id										INT		OUTPUT
AS
BEGIN TRY
BEGIN TRAN -- El Try va primero, si no, luego recibimos errores del tipo "The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION"
	DECLARE @Tabla VARCHAR(80) = 'Paginas'
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
			-- 1ero Busco a ver si exíste la Página:
			SET @id = (SELECT id FROM Paginas WHERE Nombre = @Nombre)
			
			-- Luego, Si @SaltarRegistrosExistentes = '0' pero @id NO es NULO --> igualmente tiene q intentar insertar (y que se produzca el error por "registro duplicado" devolviendo el mensaje acorde).
			-- Solo en el caso de @SaltarRegistrosExistentes = '1' y @id NO es NULO,  NO se ejecuta lo siguiente. Se avanza con el @id anterior y se prosigue con los roles.
			IF @SaltarRegistrosExistentes = '0' OR @id IS NULL 
				BEGIN
					DECLARE @Funcion VARCHAR(100) = (SELECT NombreAMostrar FROM FuncionesDePaginas WHERE id = @FuncionDePaginaId)
					DECLARE @SeccionId INT = (SELECT id FROM Secciones WHERE Nombre = @Seccion)
					
					IF @Nombre = ''
						BEGIN
							-- Antes: SELECT @Nombre = Nombre + @Funcion FROM Tablas WHERE id = @TablaId
							
							-- Ahora que tenemos seccion, decidimos poner el nombre by default, respetando como queda la url:
							-- {HOST}/{seccion}/{Controller}/{Action}/{param}
							-- Ej: http://localhost:56958/intranet/AmbitosGeograficos/Registro/2
							SELECT @Nombre = @Seccion + '/' + Nombre + '/' + @Funcion FROM Tablas WHERE id = @TablaId
						END
					
					IF @Titulo = ''
						BEGIN
							SELECT @Titulo = NombreAMostrar + ' - ' + @Funcion FROM Tablas WHERE id = @TablaId
						END
					
					IF @RolMenosPrioritarioQueCarga = dbo.ufc_RolesDeUsuarios__MasterAdmin()
						BEGIN
							SET @SeMuestraEnAsignacionDePermisos = '0' -- Si solo las puede operar el Master Admin --> no dejamos que se muestren en los permisos y q tales asignaciones puedan ser cambiadas a posteriori.
						END
					
					SET NOCOUNT ON
					INSERT INTO Paginas
					(
						SeccionId
						,TablaId
						,FuncionDePaginaId
						,Nombre
						,Titulo
						,Tips
						,Observaciones
						,SeMuestraEnAsignacionDePermisos
					)
					VALUES
					(
						@SeccionId
						,@TablaId
						,@FuncionDePaginaId
						,@Nombre
						,@Titulo
						,@Tips
						,@Observaciones
						,@SeMuestraEnAsignacionDePermisos
					)
					
					SET @id = SCOPE_IDENTITY()
			
					-- Revisamos el resultado, si OK --> registra el LogRegistros, si falla --> Resgistra el LogError y devuelve el mensaje correcto.
					EXEC usp_ControlYLogRegistros__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
							, @Tabla = @Tabla , @RegistroId = @id, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @RegistrosAfectados = @@ROWCOUNT
							, @NumeroDeError = @@ERROR, @sResSQL = @sResSQL OUTPUT
				END
			ELSE
				BEGIN
					DECLARE @PongoCualquierCosaParaQueNoDeErrorElBEGIN AS BIT
					PRINT 'Ya existe la Página; con id = ' + CAST(@id AS VARCHAR) + '. El procedimiento continúa intentando la asignación de roles a la misma.'
				END
				
				
			IF @sResSQL = ''
				BEGIN	
					-- INSERTO LOS PERMISOS DE ROLES DE USUARIO A LAS PÁGINAS.
					-- Al llamar al siguiente SP va a generar para la página TODOS los RolesDeusuarios con permisos a esa Página
					-- , EN FUNCION DE LA PRIORIDAD DEL ROL INDICADO.
					-- Asignándole a cada Página todos los roles con una Prioridad Mayor o igual (Menor número) al Rol q se le pasa.
					EXEC usp_RelAsig_RolesDeUsuarios_A_Paginas__InsertSegunPrioridadRoles 
							@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
							,@FechaDeEjecucion = @FechaDeEjecucion
							,@Token = @Token
							,@CodigoDelContexto = @CodigoDelContexto
							,@Seccion = @Seccion
							,@SaltarRegistrosExistentes = @SaltarRegistrosExistentes
							,@PaginaId = @id
							,@RolMenosPrioritarioQueCarga = @RolMenosPrioritarioQueCarga
							,@RolMenosPrioritarioQueOpera = @RolMenosPrioritarioQueOpera
							,@RolMenosPrioritarioQueVerRegAnulados = @RolMenosPrioritarioQueVerRegAnulados
							,@RolMenosPrioritarioQueAccionesEspeciales = @RolMenosPrioritarioQueAccionesEspeciales
							,@sResSQL = @sResSQL OUTPUT
				END
		END

	IF @sResSQL = ''
		BEGIN
			COMMIT TRAN
		END
	ELSE
		BEGIN
			SET @sResSQL = COALESCE(@sResSQL, '-NULL-')
			RAISERROR (@sResSQL, 16, 1) --> ROLLBACK TRAN // RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState) // De esta forma, se hace el ROLLBACK, pero queda registrado el error en LogErrores.
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
	
	
	
	
IF (OBJECT_ID('usp_Paginas__InsertSegunRoles') IS NOT NULL) DROP PROCEDURE usp_Paginas__InsertSegunRoles
GO
CREATE PROCEDURE usp_Paginas__InsertSegunRoles
	-- Validaciones:
		-- 1) Si @SaltarRegistrosExistentes = '1' --> No intenta insertar la Página, guarda ese id y continúa intentando insertar las relaciones a los roles correspondientes (También pasándoles el parámetro: @SaltarRegistrosExistentes).
	-------------
	-- Acotaciones:
		-- ESTE SP SE UTILIZA PARA DIRECTAMENTE CREAR UNA PÁGINA, Y ENCADENADAMENTE, ASIGNARLE LOS ROLES INDICADOS EN LOS "@RolesIdsString_..."
	-------------
	@UsuarioQueEjecutaId        INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
		
	,@SaltarRegistrosExistentes				BIT = '0' --  Si = '1' --> Busca si existe la relación y omite insertarla por duplicado (lo cual produciría un error).
	
	,@TablaId								INT	
	,@FuncionDePaginaId						INT	
	,@RolesIdsString_CargarLaPagina			VARCHAR(MAX)
	,@RolesIdsString_OperarLaPagina			VARCHAR(MAX)
	,@RolesIdsString_VerRegAnulados			VARCHAR(MAX)
	,@RolesIdsString_AccionesEspeciales		VARCHAR(MAX)	
	,@Nombre								VARCHAR(100) = ''
	,@Titulo								VARCHAR(100) = ''
	,@Tips									VARCHAR(2000) = ''		
	,@Observaciones							VARCHAR(2000) = ''	
	,@SeMuestraEnAsignacionDePermisos		BIT	= '1'
	
	,@sResSQL								VARCHAR(1000)	OUTPUT
	,@id									INT		OUTPUT
AS
BEGIN TRY
BEGIN TRAN -- El Try va primero, si no, luego recibimos errores del tipo "The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION"
	DECLARE @Tabla VARCHAR(80) = 'Paginas'
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
			-- 1ero Busco a ver si exíste la Página:
			SET @id = (SELECT id FROM Paginas WHERE Nombre = @Nombre)
			
			-- Luego, Si @SaltarRegistrosExistentes = '0' pero @id NO es NULO --> igualmente tiene q intentar insertar (y que se produzca el error por "registro duplicado" devolviendo el mensaje acorde).
			-- Solo en el caso de @SaltarRegistrosExistentes = '1' y @id NO es NULO,  NO se ejecuta lo siguiente. Se avanza con el @id anterior y se prosigue con los roles.
			IF @SaltarRegistrosExistentes = '0' OR @id IS NULL 
				BEGIN
					DECLARE @Funcion VARCHAR(100) = (SELECT NombreAMostrar FROM FuncionesDePaginas WHERE id = @FuncionDePaginaId)
					DECLARE @SeccionId INT = (SELECT id FROM Secciones WHERE Nombre = @Seccion)
					
					IF @Nombre = ''
						BEGIN
							-- Antes: SELECT @Nombre = Nombre + @Funcion FROM Tablas WHERE id = @TablaId
							
							-- Ahora que tenemos seccion, decidimos poner el nombre by default, respetando como queda la url:
							-- {HOST}/{seccion}/{Controller}/{Action}/{param}
							-- Ej: http://localhost:56958/intranet/AmbitosGeograficos/Registro/2
							SELECT @Nombre = @Seccion + '/' + Nombre + '/' + @Funcion FROM Tablas WHERE id = @TablaId
						END
					
					IF @Titulo = ''
						BEGIN
							SELECT @Titulo = NombreAMostrar + ' - ' + @Funcion FROM Tablas WHERE id = @TablaId
						END
						
					SET NOCOUNT ON
					INSERT INTO Paginas
					(
						SeccionId
						,TablaId
						,FuncionDePaginaId
						,Nombre
						,Titulo
						,Tips
						,Observaciones
						,SeMuestraEnAsignacionDePermisos
					)
					VALUES
					(
						@SeccionId
						,@TablaId
						,@FuncionDePaginaId
						,@Nombre
						,@Titulo
						,@Tips
						,@Observaciones
						,@SeMuestraEnAsignacionDePermisos
					)
					
					SET @id = SCOPE_IDENTITY()
			
					---- Revisamos el resultado, si OK --> registra el LogRegistros, si falla --> Resgistra el LogError y devuelve el mensaje correcto.
					EXEC usp_ControlYLogRegistros__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
							, @Tabla = @Tabla , @RegistroId = @id, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @RegistrosAfectados = @@ROWCOUNT
							, @NumeroDeError = @@ERROR, @sResSQL = @sResSQL OUTPUT
				END
			ELSE
				BEGIN
					DECLARE @PongoCualquierCosaParaQueNoDeErrorElBEGIN AS BIT
					PRINT 'Ya existe la Página; con id = ' + CAST(@id AS VARCHAR) + '. El procedimiento continúa intentando la asignación de roles a la misma.'
				END
			
			IF @sResSQL = ''
				BEGIN	
					-- Al llamar al siguiente SP y pasarle los strings de ids de Roles, va a generar para cada página
					-- TODOS los RolesDeusuarios con permisos a esa Página.
					EXEC usp_RelAsig_RolesDeUsuarios_A_Paginas__InsertSegunRoles 
							@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
							,@FechaDeEjecucion = @FechaDeEjecucion
							,@Token = @Token
							,@Seccion = @Seccion
							,@CodigoDelContexto = @CodigoDelContexto
							,@SaltarRegistrosExistentes = @SaltarRegistrosExistentes
							,@PaginaId = @id
							,@RolesIdsString_CargarLaPagina = @RolesIdsString_CargarLaPagina
							,@RolesIdsString_OperarLaPagina = @RolesIdsString_OperarLaPagina
							,@RolesIdsString_VerRegAnulados = @RolesIdsString_VerRegAnulados
							,@RolesIdsString_AccionesEspeciales = @RolesIdsString_AccionesEspeciales
							,@sResSQL = @sResSQL OUTPUT
				END
		END

	IF @sResSQL = ''
		BEGIN
			COMMIT TRAN
		END
	ELSE
		BEGIN
			SET @sResSQL = COALESCE(@sResSQL, '-NULL-')
			RAISERROR (@sResSQL, 16, 1) --> ROLLBACK TRAN // RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState) // De esta forma, se hace el ROLLBACK, pero queda registrado el error en LogErrores.
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




--IF (OBJECT_ID('usp_Paginas__Update_@Seccion_by_@id') IS NOT NULL) DROP PROCEDURE usp_Paginas__Update_by_@id
--GO
--CREATE PROCEDURE usp_Paginas__Update_by_@id
--	@id								INT	
	
--	,@UsuarioQueEjecutaId		INT
--	,@FechaDeEjecucion			DATETIME
--	,@Token                     VARCHAR(40) 
--	,@Seccion					VARCHAR(30) 
--	,@CodigoDelContexto			VARCHAR(40) 
	
--	--,@TablaId						INT	
--	--,@FuncionDePaginaId			INT	
--	,@Nombre						VARCHAR(100)
--	,@Titulo						VARCHAR(100)
--	,@Tips							VARCHAR(2000)
--	,@Observaciones					VARCHAR(2000)
--	,@SeMuestraEnAsignacionDePermisos	BIT	
	
--	,@sResSQL						VARCHAR(1000)	OUTPUT
--AS
--BEGIN TRY
--	DECLARE @Tabla VARCHAR(80) = 'Paginas'
--		,@FuncionDePagina VARCHAR(30) = 'Update'
--		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
--		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
--	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
--			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
--			, @RegistroId = @id 
--			--, @UsuarioId = @UsuarioId OUTPUT 
--			, @sResSQL = @sResSQL OUTPUT
	
--	IF @sResSQL = ''
--		BEGIN
--			UPDATE Paginas
--			SET
--				--@SeccionId = @SeccionId
--				--,TablaId = @TablaId
--				--,FuncionDePaginaId = @FuncionDePaginaId
--				Nombre = @Nombre
--				,Titulo = @Titulo
--				,Tips = @Tips
--				,Observaciones = @Observaciones
--				,SeMuestraEnAsignacionDePermisos = @SeMuestraEnAsignacionDePermisos
--			FROM Paginas
--			WHERE id = @id

--			-- Revisamos el resultado, si OK --> registra el LogRegistros, si falla --> Resgistra el LogError y devuelve el mensaje correcto.
--			EXEC usp_ControlYLogRegistros__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
--					, @Tabla = @Tabla , @RegistroId = @id, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @RegistrosAfectados = @@ROWCOUNT
--					, @NumeroDeError = @@ERROR, @sResSQL = @sResSQL OUTPUT
--		END
--END TRY
--BEGIN CATCH
--	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
--	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
--			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
--			, @RegistroId = @id 
-- 			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
--END CATCH
--GO




IF (OBJECT_ID('usp_Paginas__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_Paginas__Update_by_@id
GO
CREATE PROCEDURE usp_Paginas__Update_by_@id
	@id								INT	
	
	,@UsuarioQueEjecutaId		INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	--,@TablaId						INT	
	--,@FuncionDePaginaId			INT	
	,@Nombre						VARCHAR(100)
	,@Titulo						VARCHAR(100)
	,@Tips							VARCHAR(2000)
	,@Observaciones					VARCHAR(2000)
	,@SeMuestraEnAsignacionDePermisos	BIT	
	
	,@sResSQL						VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Paginas'
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
			UPDATE Paginas
			SET
				--@SeccionId = @SeccionId
				--,TablaId = @TablaId
				--,FuncionDePaginaId = @FuncionDePaginaId
				Nombre = @Nombre
				,Titulo = @Titulo
				,Tips = @Tips
				,Observaciones = @Observaciones
				,SeMuestraEnAsignacionDePermisos = @SeMuestraEnAsignacionDePermisos
			FROM Paginas
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
-- SP-TABLA: Paginas /ABMs/ - FIN




-- SP-TABLA: RelAsig_RolesDeUsuarios_A_Paginas /ABMs/ - INICIO // Las Necesito 1ero que a Tablas y Paginas:
IF (OBJECT_ID('usp_RelAsig_RolesDeUsuarios_A_Paginas__InsertSegunPrioridadRoles') IS NOT NULL) DROP PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Paginas__InsertSegunPrioridadRoles
GO
CREATE PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Paginas__InsertSegunPrioridadRoles
	-- Validaciones:
		-- 1) Si @SaltarRegistrosExistentes = '1' --> No intenta insertar dicha relación existente. "La salta" y continúa con el procedimiento.
	-------------
	-- Acotaciones:
		-- 1ero inserta todas las relaciones de la @PaginaId a todos los roles existentes en '0'; o sea, sin permiso.
		-- 2do updatea las relaciones seteando en '1' las que corresponden a los roles ingresados en los IdsString correspondientes.
	-------------
	@UsuarioQueEjecutaId        INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
			
	,@SaltarRegistrosExistentes					BIT = '0' --  Si = '1' --> Busca si existe la relación y omite insertarla por duplicado (lo cual produciría un error).
	
	,@PaginaId									INT	
	
	,@RolMenosPrioritarioQueCarga				VARCHAR(50) -- Nombre del rol
	,@RolMenosPrioritarioQueOpera				VARCHAR(50) -- Nombre del rol
	,@RolMenosPrioritarioQueVerRegAnulados		VARCHAR(50) -- Nombre del rol
	,@RolMenosPrioritarioQueAccionesEspeciales	VARCHAR(50) -- Nombre del rol
	
	,@sResSQL									VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
BEGIN TRAN -- El Try va primero, si no, luego recibimos errores del tipo "The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION"
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_RolesDeUsuarios_A_Paginas'
		,@FuncionDePagina VARCHAR(30) = 'Insert'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
		--,@id INT = @PaginaId -- Solo por compatibilidad, adentro no lo utiliza por q no tiene ContextoId
		
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			--, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
	
	IF @sResSQL = ''
		BEGIN
			DECLARE @RolesIdsONombresString VARCHAR(MAX) = @RolMenosPrioritarioQueCarga
															+ ',' + @RolMenosPrioritarioQueOpera
															+ ',' + @RolMenosPrioritarioQueVerRegAnulados
															+ ',' + @RolMenosPrioritarioQueAccionesEspeciales
			
			EXEC usp_VAL_Usuarios__PuedeModificarLosRolesAsigALaPagina
						@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
						, @FechaDeEjecucion = @FechaDeEjecucion
						, @PaginaId = @PaginaId
						, @RolesIdsONombresString = @RolesIdsONombresString
						, @sResSQL = @sResSQL OUTPUT
		END
		
	IF @sResSQL = ''
		BEGIN
			DECLARE @RolDeUsuarioId		INT
				,@RolesIdsString_ConRelacionExisteALaPagina VARCHAR(MAX) = ''
			
			IF @SaltarRegistrosExistentes = '1'	-- Buscamos las realciones existentes:
				BEGIN
					SET @RolesIdsString_ConRelacionExisteALaPagina = (COALESCE(STUFF((SELECT ', ' + CAST(RolDeUsuarioId AS VARCHAR(MAX))
																				FROM RelAsig_RolesDeUsuarios_A_Paginas
																				WHERE (PaginaId = @PaginaId)
																				FOR XML PATH('')),1,1,''), '')
																			)
				END
				
				
			-- 1ero, SETEO TODOS LOS ROLES A LA PÁGINA, EN CERO (Todos los que no existen ya en la tabla de rel)
			INSERT INTO RelAsig_RolesDeUsuarios_A_Paginas 
			(
				RolDeUsuarioId
				,PaginaId
				,AutorizadoA_CargarLaPagina
				,AutorizadoA_OperarLaPagina
				,AutorizadoA_VerRegAnulados 
				,AutorizadoA_AccionesEspeciales
			) 
			SELECT	id			
				,@PaginaId		
				,'0'						
				,'0'					
				,'0'
				,'0'
			FROM RolesDeUsuarios  -- <-- TODOS LOS ROLES
			WHERE id NOT IN (SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@RolesIdsString_ConRelacionExisteALaPagina)) -- <-- Evito las relaciones existentes. (id=RolDeUsuarioId). 
			
			
			DECLARE @Prioridad INT
			
			--AND (RDU.SeMuestraEnAsignacionDePermisos = '1') <-- NO VA. Acá asignamos todos, no importa si se muestran o nó.
			
			-- A) Carga:
			SELECT @Prioridad = Prioridad FROM RolesDeUsuarios WHERE Nombre = @RolMenosPrioritarioQueCarga
			DECLARE @RolesIdsString_CargarLaPagina	VARCHAR(1000)
			IF (@Prioridad < 0)  -- Las prioridades negativas las utilizamos para aplicar roles puntuales
				BEGIN -- Es 1 solo rol en particular
					SELECT @RolesIdsString_CargarLaPagina = CAST(id AS VARCHAR(MAX)) 
					FROM RolesDeUsuarios RDU
					WHERE RDU.Prioridad = @Prioridad
						--AND (RDU.SeMuestraEnAsignacionDePermisos = '1')
						AND RDU.id NOT IN (SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@RolesIdsString_ConRelacionExisteALaPagina)) -- <-- Evito las relaciones existentes. (id=RolDeUsuarioId). 
				END
			ELSE
				BEGIN -- Es una asignación de 1 o más roles que hay q concatenar
					SELECT @RolesIdsString_CargarLaPagina = COALESCE(@RolesIdsString_CargarLaPagina + ', ', '') + CAST(id AS VARCHAR(MAX)) 
					FROM RolesDeUsuarios RDU
					WHERE (RDU.Prioridad > 0) AND (RDU.Prioridad <= @Prioridad)
						--AND (RDU.SeMuestraEnAsignacionDePermisos = '1')
						AND RDU.id NOT IN (SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@RolesIdsString_ConRelacionExisteALaPagina)) -- <-- Evito las relaciones existentes. (id=RolDeUsuarioId). 
				END
			
			-- B) Opera:
			SELECT @Prioridad = Prioridad FROM RolesDeUsuarios WHERE Nombre = @RolMenosPrioritarioQueOpera
			DECLARE @RolesIdsString_OperarLaPagina	VARCHAR(1000)
			IF (@Prioridad < 0)  -- Las prioridades negativas las utilizamos para aplicar roles puntuales
				BEGIN -- Es 1 solo rol en particular
					SELECT @RolesIdsString_OperarLaPagina = CAST(id AS VARCHAR(MAX)) 
					FROM RolesDeUsuarios RDU
					WHERE RDU.Prioridad = @Prioridad
						--AND (RDU.SeMuestraEnAsignacionDePermisos = '1')
						AND RDU.id NOT IN (SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@RolesIdsString_ConRelacionExisteALaPagina)) -- <-- Evito las relaciones existentes. (id=RolDeUsuarioId). 
				END
			ELSE
				BEGIN -- Es una asignación de 1 o más roles que hay q concatenar
					SELECT @RolesIdsString_OperarLaPagina = COALESCE(@RolesIdsString_OperarLaPagina + ', ', '') + CAST(id AS VARCHAR(MAX)) 
					FROM RolesDeUsuarios RDU
					WHERE (RDU.Prioridad > 0) AND (RDU.Prioridad <= @Prioridad)
						--AND (RDU.SeMuestraEnAsignacionDePermisos = '1')
						AND RDU.id NOT IN (SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@RolesIdsString_ConRelacionExisteALaPagina)) -- <-- Evito las relaciones existentes. (id=RolDeUsuarioId). 
				END
				
			-- C) VerRegAnulados:
			SELECT @Prioridad = Prioridad FROM RolesDeUsuarios WHERE Nombre = @RolMenosPrioritarioQueVerRegAnulados
			DECLARE @RolesIdsString_VerRegAnulados	VARCHAR(1000)
			IF (@Prioridad < 0)  -- Las prioridades negativas las utilizamos para aplicar roles puntuales
				BEGIN -- Es 1 solo rol en particular
					SELECT @RolesIdsString_VerRegAnulados = CAST(id AS VARCHAR(MAX)) 
					FROM RolesDeUsuarios RDU
					WHERE RDU.Prioridad = @Prioridad
						--AND (RDU.SeMuestraEnAsignacionDePermisos = '1')
						AND RDU.id NOT IN (SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@RolesIdsString_ConRelacionExisteALaPagina)) -- <-- Evito las relaciones existentes. (id=RolDeUsuarioId). 
				END
			ELSE
				BEGIN -- Es una asignación de 1 o más roles que hay q concatenar
					SELECT @RolesIdsString_VerRegAnulados = COALESCE(@RolesIdsString_VerRegAnulados + ', ', '') + CAST(id AS VARCHAR(MAX)) 
					FROM RolesDeUsuarios RDU
					WHERE (RDU.Prioridad > 0) AND (RDU.Prioridad <= @Prioridad)
						--AND (RDU.SeMuestraEnAsignacionDePermisos = '1')
						AND RDU.id NOT IN (SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@RolesIdsString_ConRelacionExisteALaPagina)) -- <-- Evito las relaciones existentes. (id=RolDeUsuarioId). 
				END
				
			-- D) AccionesEspeciales:
			SELECT @Prioridad = Prioridad FROM RolesDeUsuarios WHERE Nombre = @RolMenosPrioritarioQueAccionesEspeciales
			DECLARE @RolesIdsString_AccionesEspeciales	VARCHAR(1000)
			IF (@Prioridad < 0)  -- Las prioridades negativas las utilizamos para aplicar roles puntuales
				BEGIN -- Es 1 solo rol en particular
					SELECT @RolesIdsString_AccionesEspeciales = CAST(id AS VARCHAR(MAX)) 
					FROM RolesDeUsuarios RDU
					WHERE RDU.Prioridad = @Prioridad
						--AND (RDU.SeMuestraEnAsignacionDePermisos = '1')
						AND RDU.id NOT IN (SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@RolesIdsString_ConRelacionExisteALaPagina)) -- <-- Evito las relaciones existentes. (id=RolDeUsuarioId). 
				END
			ELSE
				BEGIN -- Es una asignación de 1 o más roles que hay q concatenar
					SELECT @RolesIdsString_AccionesEspeciales = COALESCE(@RolesIdsString_AccionesEspeciales + ', ', '') + CAST(id AS VARCHAR(MAX)) 
					FROM RolesDeUsuarios RDU
					WHERE (RDU.Prioridad > 0) AND (RDU.Prioridad <= @Prioridad)
						--AND (RDU.SeMuestraEnAsignacionDePermisos = '1')
						AND RDU.id NOT IN (SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@RolesIdsString_ConRelacionExisteALaPagina)) -- <-- Evito las relaciones existentes. (id=RolDeUsuarioId). 
				END
				
			
			-- Ahora Asignamos todos esos roles a la Pagina
			EXEC usp_RelAsig_RolesDeUsuarios_A_Paginas__Update_by_@RolesIdsString 
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					,@FechaDeEjecucion = @FechaDeEjecucion
					,@Token = @Token
					,@Seccion = @Seccion
					,@CodigoDelContexto = @CodigoDelContexto
					--,@SaltarRegistrosExistentes = @SaltarRegistrosExistentes // No va, ya que los registros existen todos --> al ser Update saltaría TODOS. 
					,@PaginaId = @PaginaId
					,@RolesIdsString_CargarLaPagina = @RolesIdsString_CargarLaPagina
					,@RolesIdsString_OperarLaPagina = @RolesIdsString_OperarLaPagina
					,@RolesIdsString_VerRegAnulados = @RolesIdsString_VerRegAnulados
					,@RolesIdsString_AccionesEspeciales = @RolesIdsString_AccionesEspeciales
					,@sResSQL = @sResSQL OUTPUT
		END
	
	IF @sResSQL = ''
		BEGIN
			COMMIT TRAN
		END
	ELSE
		BEGIN
			SET @sResSQL = COALESCE(@sResSQL, '-NULL-')
			RAISERROR (@sResSQL, 16, 1) --> ROLLBACK TRAN // RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState) // De esta forma, se hace el ROLLBACK, pero queda registrado el error en LogErrores.
		END		
END TRY
BEGIN CATCH
	ROLLBACK TRAN
	
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id 
 			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO




IF (OBJECT_ID('usp_RelAsig_RolesDeUsuarios_A_Paginas__InsertSegunRoles') IS NOT NULL) DROP PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Paginas__InsertSegunRoles
GO
CREATE PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Paginas__InsertSegunRoles
	-- Validaciones:
		-- 1) Si @SaltarRegistrosExistentes = '1' --> No intenta insertar dicha relación existente. "La salta" y continúa con el procedimiento.
	-------------
	-- Acotaciones:
		-- 1ero inserta todas las relaciones de la @PaginaId a todos los roles existentes en '0'; o sea, sin permiso.
		-- 2do updatea las relaciones seteando en '1' las que corresponden a los roles ingresados en los IdsString correspondientes.
	-------------
	@UsuarioQueEjecutaId        INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
	
	,@SaltarRegistrosExistentes				BIT = '0' --  Si = '1' --> Busca si existe la relación y omite insertarla por duplicado (lo cual produciría un error).
	
	,@PaginaId								INT	
	
	,@RolesIdsString_CargarLaPagina			VARCHAR(MAX)
	,@RolesIdsString_OperarLaPagina			VARCHAR(MAX)
	,@RolesIdsString_VerRegAnulados			VARCHAR(MAX)
	,@RolesIdsString_AccionesEspeciales		VARCHAR(MAX)	
	
	,@sResSQL								VARCHAR(1000)	OUTPUT
AS 
BEGIN TRY
BEGIN TRAN -- El Try va primero, si no, luego recibimos errores del tipo "The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION"
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_RolesDeUsuarios_A_Paginas'
		,@FuncionDePagina VARCHAR(30) = 'Insert'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
		--,@id INT = @PaginaId -- Solo por compatibilidad, adentro no lo utiliza por q no tiene ContextoId
		
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			--, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
	
	IF @sResSQL = ''
		BEGIN
			DECLARE @RolesIdsONombresString VARCHAR(MAX) = @RolesIdsString_CargarLaPagina
															+ ',' + @RolesIdsString_OperarLaPagina
															+ ',' + @RolesIdsString_VerRegAnulados
															+ ',' + @RolesIdsString_AccionesEspeciales
			
			EXEC usp_VAL_Usuarios__PuedeModificarLosRolesAsigALaPagina
						@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
						, @FechaDeEjecucion = @FechaDeEjecucion
						, @PaginaId = @PaginaId
						, @RolesIdsONombresString = @RolesIdsONombresString
						, @sResSQL = @sResSQL OUTPUT
		END
		
	IF @sResSQL = ''
		BEGIN
			DECLARE @RolesIdsString_ConRelacionExisteALaPagina VARCHAR(MAX) = ''
			
			IF @SaltarRegistrosExistentes = '1'	-- Buscamos las realciones existentes:
				BEGIN
					SET @RolesIdsString_ConRelacionExisteALaPagina = (COALESCE(STUFF((SELECT ', ' + CAST(RolDeUsuarioId AS VARCHAR(MAX))
																				FROM RelAsig_RolesDeUsuarios_A_Paginas
																				WHERE (PaginaId = @PaginaId)
																				FOR XML PATH('')),1,1,''), '')
																			)
				END
				
				
			-- 1ero, SETEO TODOS LOS ROLES A LA PÁGINA, EN CERO (Todos los que no existen ya en la tabla de rel)
			INSERT INTO RelAsig_RolesDeUsuarios_A_Paginas 
			(
				RolDeUsuarioId
				,PaginaId
				,AutorizadoA_CargarLaPagina
				,AutorizadoA_OperarLaPagina
				,AutorizadoA_VerRegAnulados 
				,AutorizadoA_AccionesEspeciales
			) 
			SELECT	id			
				,@PaginaId		
				,'0'						
				,'0'					
				,'0'
				,'0'
			FROM RolesDeUsuarios  -- <-- TODOS LOS ROLES
			WHERE id NOT IN (SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@RolesIdsString_ConRelacionExisteALaPagina)) -- <-- Evito las relaciones existentes. (id=RolDeUsuarioId). 
			
			
			-- Ahora Asignamos todos esos roles a la Pagina
			EXEC usp_RelAsig_RolesDeUsuarios_A_Paginas__Update_by_@RolesIdsString 
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					,@FechaDeEjecucion = @FechaDeEjecucion
					,@Token = @Token
					,@Seccion = @Seccion
					,@CodigoDelContexto = @CodigoDelContexto
					--,@SaltarRegistrosExistentes = @SaltarRegistrosExistentes // No va, ya que los registros existen todos --> al ser Update saltaría TODOS. 
					,@PaginaId = @PaginaId
					,@RolesIdsString_CargarLaPagina = @RolesIdsString_CargarLaPagina
					,@RolesIdsString_OperarLaPagina = @RolesIdsString_OperarLaPagina
					,@RolesIdsString_VerRegAnulados = @RolesIdsString_VerRegAnulados
					,@RolesIdsString_AccionesEspeciales = @RolesIdsString_AccionesEspeciales
					,@sResSQL = @sResSQL OUTPUT
		END
			
	IF @sResSQL = ''
		BEGIN
			COMMIT TRAN
		END
	ELSE
		BEGIN
			SET @sResSQL = COALESCE(@sResSQL, '-NULL-')
			RAISERROR (@sResSQL, 16, 1) --> ROLLBACK TRAN // RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState) // De esta forma, se hace el ROLLBACK, pero queda registrado el error en LogErrores.
		END		
END TRY
BEGIN CATCH
	ROLLBACK TRAN
	
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id 
 			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO




IF (OBJECT_ID('usp_RelAsig_RolesDeUsuarios_A_Paginas__Insert') IS NOT NULL) DROP PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Paginas__Insert
GO
CREATE PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Paginas__Insert
	@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
			
	,@RolDeUsuarioId					INT	
	,@PaginaId							INT	
	,@AutorizadoA_CargarLaPagina		BIT	
	,@AutorizadoA_OperarLaPagina		BIT
	,@AutorizadoA_VerRegAnulados		BIT		
	,@AutorizadoA_AccionesEspeciales	BIT	
	
	,@sResSQL							VARCHAR(1000)	OUTPUT
	,@id								INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_RolesDeUsuarios_A_Paginas'
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
			EXEC usp_VAL_Usuarios__PuedeModificarElRolAsigALaPagina -- Validamos si tiene permiso segun el usuario y el rol
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					, @FechaDeEjecucion = @FechaDeEjecucion
					, @RolDeUsuarioId = @RolDeUsuarioId
					, @PaginaId = @PaginaId
					, @sResSQL = @sResSQL OUTPUT
		END
	
		IF @sResSQL = ''
		BEGIN
			SET NOCOUNT ON
			INSERT INTO RelAsig_RolesDeUsuarios_A_Paginas
			(
				RolDeUsuarioId
				,PaginaId
				,AutorizadoA_CargarLaPagina	
				,AutorizadoA_OperarLaPagina	
				,AutorizadoA_VerRegAnulados
				,AutorizadoA_AccionesEspeciales
			)
			VALUES
			(
				@RolDeUsuarioId
				,@PaginaId
				,@AutorizadoA_CargarLaPagina	
				,@AutorizadoA_OperarLaPagina	
				,@AutorizadoA_VerRegAnulados
				,@AutorizadoA_AccionesEspeciales
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




IF (OBJECT_ID('usp_RelAsig_RolesDeUsuarios_A_Paginas__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Paginas__Update_by_@id
GO
CREATE PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Paginas__Update_by_@id
	@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@id								INT	
	
	,@AutorizadoA_CargarLaPagina		BIT	
	,@AutorizadoA_OperarLaPagina		BIT
	,@AutorizadoA_VerRegAnulados		BIT
	,@AutorizadoA_AccionesEspeciales	BIT
	
	,@sResSQL							VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_RolesDeUsuarios_A_Paginas'
		,@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	-- No se mira el RegistroId para una Rel
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
			
	IF @sResSQL = ''
		BEGIN
			SET NOCOUNT ON
			UPDATE RelAsig_RolesDeUsuarios_A_Paginas
			SET
				AutorizadoA_CargarLaPagina	= @AutorizadoA_CargarLaPagina
				,AutorizadoA_OperarLaPagina	= @AutorizadoA_OperarLaPagina
				,AutorizadoA_VerRegAnulados = @AutorizadoA_VerRegAnulados
				,AutorizadoA_AccionesEspeciales = @AutorizadoA_AccionesEspeciales
			FROM RelAsig_RolesDeUsuarios_A_Paginas
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




IF (OBJECT_ID('usp_RelAsig_RolesDeUsuarios_A_Paginas__Update_by_@RolesIdsString') IS NOT NULL) DROP PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Paginas__Update_by_@RolesIdsString
GO
CREATE PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Paginas__Update_by_@RolesIdsString
	-- Validaciones:
		-- 1) Si @RolesIdsString_CargarLaPagina = '0' --> Asigna a todos los roles un 1, eso quiere decir que TODOS tendran "permiso".
		-- 2) Si @RolesIdsString_OperarLaPagina = '0' --> Asigna a todos los roles un 1, eso quiere decir que TODOS tendran "permiso".
		-- 3) Si @RolesIdsString_VerRegAnulados = '0' --> Asigna a todos los roles un 1, eso quiere decir que TODOS tendran "permiso".
		-- 4) Si @RolesIdsString_AccionesEspeciales = '0' --> Asigna a todos los roles un 1, eso quiere decir que TODOS tendran "permiso".
	-------------
	-- Acotaciones:
		-- Updatea las relaciones seteando en '1' las que corresponden a los roles ingresados en los IdsString correspondientes.
	-------------
	@UsuarioQueEjecutaId        INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
		
	--	,@SaltarRegistrosExistentes				BIT = '0' --  Si = '1' --> Busca si existe la relación y omite insertarla por duplicado (lo cual produciría un error). // Al ser un Update, no va el "saltar" por que Ya existe todos --> nunca haría Update.
	
	,@PaginaId								INT
	
	,@RolesIdsString_CargarLaPagina			VARCHAR(MAX) = '0' -- Si es = 0 --> Asigna a todos los roles un 1, eso quiere decir que TODOS tendran "permiso".
	,@RolesIdsString_OperarLaPagina			VARCHAR(MAX) = '0' -- Si es = 0 --> Asigna a todos los roles un 1, eso quiere decir que TODOS tendran "permiso".
	,@RolesIdsString_VerRegAnulados			VARCHAR(MAX) = '0' -- Si es = 0 --> Asigna a todos los roles un 1, eso quiere decir que TODOS tendran "permiso".
	,@RolesIdsString_AccionesEspeciales		VARCHAR(MAX) = '0' -- Si es = 0 --> Asigna a todos los roles un 1, eso quiere decir que TODOS tendran "permiso".
	
	,@sResSQL								VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
BEGIN TRAN -- El Try va primero, si no, luego recibimos errores del tipo "The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION"
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_RolesDeUsuarios_A_Paginas'
		,@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
		--,@id INT = @PaginaId -- Solo por compatibilidad, adentro no lo utiliza por q no tiene ContextoId
		
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			--, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
	
	IF @sResSQL = ''
		BEGIN
			--A)  CargarLaPagina
			UPDATE RelAsig_RolesDeUsuarios_A_Paginas 
			SET AutorizadoA_CargarLaPagina = '1'
			WHERE (PaginaId = @PaginaId)
				AND (
						(RolDeUsuarioId IN (SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@RolesIdsString_CargarLaPagina)))
						OR (@RolesIdsString_CargarLaPagina = '0') -- o sea, todos los roles
					)
				
			--B)  OperarLaPagina
			UPDATE RelAsig_RolesDeUsuarios_A_Paginas 
			SET AutorizadoA_OperarLaPagina = '1'
			WHERE (PaginaId = @PaginaId)
				AND (
						(RolDeUsuarioId IN (SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@RolesIdsString_OperarLaPagina)))
						OR (@RolesIdsString_OperarLaPagina = '0') -- o sea, todos los roles
					)
				
			--C)  VerRegAnulados
			UPDATE RelAsig_RolesDeUsuarios_A_Paginas 
			SET AutorizadoA_VerRegAnulados = '1'
			WHERE (PaginaId = @PaginaId)
				AND (
						(RolDeUsuarioId IN (SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@RolesIdsString_VerRegAnulados)))
						OR (@RolesIdsString_VerRegAnulados = '0') -- o sea, todos los roles
					)
				
			--D)  AccionesEspeciales
			UPDATE RelAsig_RolesDeUsuarios_A_Paginas 
			SET AutorizadoA_AccionesEspeciales = '1'
			WHERE (PaginaId = @PaginaId)
				AND (
						(RolDeUsuarioId IN (SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@RolesIdsString_AccionesEspeciales)))
						OR (@RolesIdsString_AccionesEspeciales = '0') -- o sea, todos los roles
					)
			
			
			--SET @id = SCOPE_IDENTITY()
	
			-- Revisamos el resultado, si OK --> registra el LogRegistros, si falla --> Resgistra el LogError y devuelve el mensaje correcto.
			--EXEC usp_ControlYLogRegistros__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			--		, @Tabla = @Tabla , @RegistroId = @id, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @RegistrosAfectados = @@ROWCOUNT
			--		, @NumeroDeError = @@ERROR, @sResSQL = @sResSQL OUTPUT
			
		END
	
	IF @sResSQL = ''
		BEGIN
			COMMIT TRAN
		END
	ELSE
		BEGIN
			SET @sResSQL = COALESCE(@sResSQL, '-NULL-')
			RAISERROR (@sResSQL, 16, 1) --> ROLLBACK TRAN // RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState) // De esta forma, se hace el ROLLBACK, pero queda registrado el error en LogErrores.
		END		
END TRY
BEGIN CATCH
	ROLLBACK TRAN
	
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id 
 			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: RelAsig_RolesDeUsuarios_A_Paginas /ABMs/ - FIN




-- SP-TABLA: RelAsig_RolesDeUsuarios_A_Usuarios /ABMs/ - INICIO
IF (OBJECT_ID('usp_RelAsig_RolesDeUsuarios_A_Usuarios__Delete_by_@UsuarioId') IS NOT NULL) DROP PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Usuarios__Delete_by_@UsuarioId
GO
CREATE PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Usuarios__Delete_by_@UsuarioId
	@UsuarioQueEjecutaId		INT						
	,@FechaDeEjecucion			DATETIME				
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@UsuarioId						INT	
	
	,@sResSQL						VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
BEGIN TRAN -- El Try va primero, si no, luego recibimos errores del tipo "The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION"
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_RolesDeUsuarios_A_Usuarios'
	-- Operar en Registro --> Permiso de DELETE o Activo/Anulado
		,@FuncionDePagina VARCHAR(30) = 'Registro' 
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	-- Acá se tiene que validar si pertenece al contexto del registro contra otra tabla:
	DECLARE @TablaDeValidacionAlContexto VARCHAR(80) = 'Usuarios' -- Esta es diferente, la valido con Usuarios
	DECLARE @id INT = @UsuarioId
	
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			, @RegistroId = @id 
			, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
		
	IF @sResSQL = ''
		BEGIN
			EXEC usp_VAL_Usuarios__PuedeModificarAlUsuario -- Validamos si tiene permiso de modificar a este usuario
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					, @FechaDeEjecucion = @FechaDeEjecucion
					, @UsuarioId = @id
					, @sResSQL = @sResSQL OUTPUT
		END
	
	IF @sResSQL = ''
		BEGIN
			SET NOCOUNT ON
			
			DECLARE @RegistrosQueDeberianEliminarse INT -- Guardo acá, cuantos debería eliminar
			SELECT @RegistrosQueDeberianEliminarse = COUNT(RARU.id) FROM RelAsig_RolesDeUsuarios_A_Usuarios RARU
																INNER JOIN RolesDeUsuarios RDU ON RARU.RolDeUsuarioId = RDU.id
															WHERE RARU.UsuarioId = @UsuarioId -- AND RDU.SeMuestraEnAsignacionDePermisos = '1' // Si tiene permiso podrá eliminar con SeMuestraEnAsignacionDePermisos = '1'
			
			DELETE RelAsig_RolesDeUsuarios_A_Usuarios 
			FROM RelAsig_RolesDeUsuarios_A_Usuarios RARU
				INNER JOIN RolesDeUsuarios RDU ON RARU.RolDeUsuarioId = RDU.id
			WHERE RARU.UsuarioId = @UsuarioId -- AND RDU.SeMuestraEnAsignacionDePermisos = '1' // Si tiene permiso podrá eliminar con SeMuestraEnAsignacionDePermisos = '1'
			
			EXEC @sResSQL = [dbo].ufc_Respuesta__ResultadoDeOperacionDelete 
										@RegistrosQueDeberianEliminarse = @RegistrosQueDeberianEliminarse
										,@RegistrosAfectados = @@ROWCOUNT
			
			--IF @sResSQL = ''
			--	BEGIN -- Registro el Log
			--		EXEC usp_LogRegistros__Insert @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @Tabla = @Tabla
			--		, @RegistroId = @id, @TipoDeOperacionId = '3', @FechaDeEjecucion = @FechaDeEjecucion
			--	END
		END
	
	IF @sResSQL = ''
		BEGIN
			COMMIT TRAN
		END
	ELSE
		BEGIN
			SET @sResSQL = COALESCE(@sResSQL, '-NULL-')
			RAISERROR (@sResSQL, 16, 1) --> ROLLBACK TRAN // RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState) // De esta forma, se hace el ROLLBACK, pero queda registrado el error en LogErrores.
		END		
END TRY
BEGIN CATCH
	ROLLBACK TRAN
	
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id 
 			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO



IF (OBJECT_ID('usp_RelAsig_RolesDeUsuarios_A_Usuarios__Insert') IS NOT NULL) DROP PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Usuarios__Insert
GO
CREATE PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Usuarios__Insert
	@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
			
	,@RolDeUsuarioId					INT	
	,@UsuarioId							INT	
	,@FechaDesde						DATE
	,@FechaHasta						DATE = NULL
	
	,@sResSQL							VARCHAR(1000)	OUTPUT
	,@id								INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_RolesDeUsuarios_A_Usuarios' 
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
			EXEC usp_VAL_Usuarios__PuedeModificarElRolDelUsuario -- Validamos si tiene permiso segun el usuario y el rol
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					, @FechaDeEjecucion = @FechaDeEjecucion
					, @RolDeUsuarioId = @RolDeUsuarioId
					, @UsuarioId = @UsuarioId
					, @sResSQL = @sResSQL OUTPUT
		END
	
	IF @sResSQL = ''
		BEGIN
			SET NOCOUNT ON
			INSERT INTO RelAsig_RolesDeUsuarios_A_Usuarios
			(
				RolDeUsuarioId
				,UsuarioId
				,FechaDesde
				,FechaHasta
			)
			VALUES
			(
				@RolDeUsuarioId
				,@UsuarioId
				,@FechaDesde
				,@FechaHasta
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




IF (OBJECT_ID('usp_RelAsig_RolesDeUsuarios_A_Usuarios__Update_by_@UsuarioId') IS NOT NULL) DROP PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Usuarios__Update_by_@UsuarioId
GO
CREATE PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Usuarios__Update_by_@UsuarioId
	@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@UsuarioId							INT
	,@RolesIdsStringA_Agregar			VARCHAR(MAX)	
	--,@RolesIdsStringA_Eliminar			VARCHAR(1000)	
	
	,@sResSQL							VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
BEGIN TRAN -- El Try va primero, si no, luego recibimos errores del tipo "The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION"
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_RolesDeUsuarios_A_Usuarios' 
		,@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			--, @RegistroId = @id 
			, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
	
	IF @sResSQL = ''
		BEGIN
			EXEC usp_VAL_Usuarios__PuedeModificarLosRolesDelUsuario -- Validamos si tiene permiso segun el usuario y el rol
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					, @FechaDeEjecucion = @FechaDeEjecucion
					, @UsuarioId = @UsuarioId
					, @RolesIdsONombresString = @RolesIdsStringA_Agregar
					, @sResSQL = @sResSQL OUTPUT
		END
	
	IF @sResSQL = '' 
		BEGIN
			SET NOCOUNT ON
			-- 1ero elimino todos
			DELETE RelAsig_RolesDeUsuarios_A_Usuarios 
			FROM RelAsig_RolesDeUsuarios_A_Usuarios 
			WHERE 
				(UsuarioId = @UsuarioId)
				
			-- 1ERO EVALUAR SI HABÍA PARA ELIMINAR, Y LUEGO NO ELIMINÓ. EXEC @sResSQL = [dbo].ufc_Respuesta__ResultadoDeOperacionDelete  @RegistrosAfectados = @@ROWCOUNT
			
				--AND
				--(RolDeUsuarioId IN (SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@RolesIdsStringA_Eliminar)))
		
			-- LO SIGUIENTE NO APLICA EN ESTA FUNCION
			--EXEC @sResSQL = [dbo].ufc_ResultadoOperacion__Update  @RegistrosAfectados = @@ROWCOUNT

			--IF @sResSQL = ''
			--	BEGIN
			
			-- 2do, agrego
					INSERT INTO RelAsig_RolesDeUsuarios_A_Usuarios (RolDeUsuarioId, UsuarioId)
						SELECT id, @UsuarioId  FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@RolesIdsStringA_Agregar)
				--END		
			
			--EXEC usp_LogRegistros__Insert @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @Tabla = @Tabla
			--, @RegistroId = @id, @TipoDeOperacionId = '2', @FechaDeEjecucion = @FechaDeEjecucion
		END
		
	IF @sResSQL = ''
		BEGIN
			COMMIT TRAN
		END
	ELSE
		BEGIN
			SET @sResSQL = COALESCE(@sResSQL, '-NULL-')
			RAISERROR (@sResSQL, 16, 1) --> ROLLBACK TRAN // RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState) // De esta forma, se hace el ROLLBACK, pero queda registrado el error en LogErrores.
		END		
END TRY
BEGIN CATCH
	ROLLBACK TRAN
	
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id 
 			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: RelAsig_RolesDeUsuarios_A_Usuarios /ABMs/ - FIN




-- SP-TABLA: Tablas /ABMs/ - INICIO
IF (OBJECT_ID('usp_Tablas__Insert') IS NOT NULL) DROP PROCEDURE usp_Tablas__Insert
GO
CREATE PROCEDURE usp_Tablas__Insert
	-- Validaciones:
		-- 1) Si @SaltarRegistrosExistentes = '1' --> No intenta insertar la tabla. "La salta" y continúa con el procedimiento.
		-- 2) Si @RealizarUpdateSiElRegistroExiste = '1' y tambien @SaltarRegistrosExistentes = '1' --> Updatea los datos del registro.
	-------------
	-- Acotaciones:
		-- El Insert de las tablas tiene un encadenamiento de 3 niveles:
		-- 1: Genera la tabla en cuestion --> Llama (EXECUTE) al SP "usp_Paginas__Insert" n veces (donde n son las FuncionesDePaginas existentes).
		-- 2: CADA EXECUTE indicado en 1 va generando TODAS las Páginas q incluyen la tabla insertada, y dentro de c/u llama (EXECUTE) al SP: "usp_RelAsig_RolesDeUsuarios_A_Paginas__InsertSegunPrioridadRoles" 
		-- 3: EL EXECUTE INDICADO EN 2 va insertando TODOS los RolesDeusuarios con permisos a esa Página.
	-------------
	@UsuarioQueEjecutaId        INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
	
	,@SaltarRegistrosExistentes					BIT = '0' --  Si = '1' --> Busca si existe la relación y omite insertarla por duplicado (lo cual produciría un error).
	,@RealizarUpdateSiElRegistroExiste			BIT = '0' --  Si = '1' y tambien @SaltarRegistrosExistentes = '1' --> Updatea los datos del registro.
	
	,@IconoCSSId								INT
	,@Nombre									VARCHAR(80)
	,@NombreAMostrar							VARCHAR(100)
	,@Nomenclatura								VARCHAR(12)	
	,@Observaciones								VARCHAR(1000)
	,@SeDebenEvaluarPermisos					BIT
	,@PermiteEliminarSusRegistros							BIT
	,@TablaDeCore								BIT
	,@SeCreanPaginas							BIT
	,@TieneArchivos								BIT
	
	-- Los siguientes son para asignarles a las páginas de las tablas
	,@RolMenosPrioritarioQueCarga				VARCHAR(50)
	,@RolMenosPrioritarioQueOpera				VARCHAR(50)
	,@RolMenosPrioritarioQueVerRegAnulados		VARCHAR(50)
	,@RolMenosPrioritarioQueAccionesEspeciales	VARCHAR(50)
	
	-- Los siguientes son enfocados en los parámetros de desición en la Generación de SPs Automáticos:
	,@CampoAMostrarEnFK							VARCHAR(100) = 'Nombre' -- Es el campo (de la propia tabla) que se muestra, por ejemplo, en un listado DDL cuando es FK de otra tabla.
	,@CamposQuePuedenSerIdsString				VARCHAR(100) = '' -- Es el campo (de la propia tabla) que puede ser entrada IdsString --> genera un SP #NombreTabla@__Insert_by_@#NombreCampo#IdsString.
	,@CamposAExcluirEnElInsert					VARCHAR(1000) = '' -- Separados por comas. Por Ejemplo: 'Nombre, Apellido' (id y Numero se excluyen siempre). Sirve para Generador de SPs.
	,@CamposAExcluirEnElUpdate					VARCHAR(1000) = '' -- Separados por comas. Por Ejemplo: 'Nombre, Apellido' (id, Activo y Numero se excluyen siempre). Sirve para Generador de SPs.
	,@CamposAExcluirEnElListado					VARCHAR(1000) = '' -- Separados por comas. Por Ejemplo: 'Nombre, Apellido'.
	,@CamposAIncluirEnFiltrosDeListado			VARCHAR(1000) = '' -- Separados por comas. Por Ejemplo: 'Nombre, Apellido'.
	--,@PermiteInsertAnonimamente					BIT = '0' -- Con un usuario que no está logueado.
	--,@PermiteListarDDLAnonimamente				BIT = '0' -- Con un usuario que no está logueado.
	,@SeGeneranAutoSusSPsDeABM					BIT = '1' -- Con el Generador de SPs.
	,@SeGeneranAutoSusSPsDeRegistros			BIT = '1' -- Con el Generador de SPs.
	,@SeGeneranAutoSusSPsDeListados				BIT = '1' -- Con el Generador de SPs.

	,@sResSQL									VARCHAR(1000)	OUTPUT
	,@id										INT		OUTPUT							
AS
BEGIN TRY
BEGIN TRAN -- El Try va primero, si no, luego recibimos errores del tipo "The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION"
	DECLARE @Tabla VARCHAR(80) = 'Tablas'
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
			-- 1ero Busco a ver si exíste la Tabla:
			SET @id = (SELECT id FROM Tablas WHERE Nombre = @Nombre)
			
			-- Luego, Si @SaltarRegistrosExistentes = '0' pero @id NO es NULO --> igualmente tiene q intentar insertar (y que se produzca el error por "registro duplicado" devolviendo el mensaje acorde).
			-- Solo en el caso de @SaltarRegistrosExistentes = '1' y @id NO es NULO,  NO se ejecuta lo siguiente. Se avanza con el @id anterior y se prosigue con los roles.
			IF @SaltarRegistrosExistentes = '0' OR @id IS NULL 
				BEGIN
					SET NOCOUNT ON
					INSERT INTO Tablas
					(
						IconoCSSId
						,Nombre
						,NombreAMostrar
						,Nomenclatura
						,Observaciones
						,SeDebenEvaluarPermisos
						,PermiteEliminarSusRegistros
						,TablaDeCore
						,SeCreanPaginas
						,TieneArchivos
						,CampoAMostrarEnFK
						,CamposQuePuedenSerIdsString
						,CamposAExcluirEnElInsert
						,CamposAExcluirEnElUpdate
						,CamposAExcluirEnElListado
						,CamposAIncluirEnFiltrosDeListado
						--,PermiteInsertAnonimamente
						--,PermiteListarDDLAnonimamente
						,SeGeneranAutoSusSPsDeABM
						,SeGeneranAutoSusSPsDeRegistros
						,SeGeneranAutoSusSPsDeListados
					)
					VALUES
					(
						@IconoCSSId
						,@Nombre
						,@NombreAMostrar
						,@Nomenclatura
						,@Observaciones
						,@SeDebenEvaluarPermisos
						,@PermiteEliminarSusRegistros
						,@TablaDeCore
						,@SeCreanPaginas
						,@TieneArchivos
						,@CampoAMostrarEnFK
						,@CamposQuePuedenSerIdsString
						,@CamposAExcluirEnElInsert
						,@CamposAExcluirEnElUpdate
						,@CamposAExcluirEnElListado
						,@CamposAIncluirEnFiltrosDeListado
						--,@PermiteInsertAnonimamente
						--,@PermiteListarDDLAnonimamente
						,@SeGeneranAutoSusSPsDeABM
						,@SeGeneranAutoSusSPsDeRegistros
						,@SeGeneranAutoSusSPsDeListados
					)
			
					SET @id = SCOPE_IDENTITY()
							
					DECLARE @RegistrosAfectados INT = @@ROWCOUNT, @NumeroDeError2 INT = @@ERROR -- POR EXCEPCION LAS DECLARAMOS ACÁ AFUERA, POR Q AL EJECUTARSE EL "if" SIGUIENTE, SE PIERDE EL VALOR

					IF @id > 1 -- No registro en LogRegistros la 1era, q es la de Sistemas, por que todavía no Inserté la Tablas "Tablas" q es necesaria. La 2da es "Tablas" y ya va OK.
						BEGIN
							-- Revisamos el resultado, si OK --> registra el LogRegistros, si falla --> Resgistra el LogError y devuelve el mensaje correcto.
							--EXEC usp_ControlYLogRegistros__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
							--		, @Tabla = @Tabla , @RegistroId = @id, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @RegistrosAfectados = @@ROWCOUNT
							--		, @NumeroDeError = @@ERROR, @sResSQL = @sResSQL OUTPUT
							-- EN ESTE CASO ESPECIALMENTE, UTILIZAMOS LA FCION SIGUIENTE POR EXCEPCION, por lo explicado más arriba en la definicion de los parametros  @RegistrosAfectados y @NumeroDeError2
							
							EXEC usp_ControlYLogRegistros__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
									, @Tabla = @Tabla , @RegistroId = @id, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @RegistrosAfectados = @RegistrosAfectados
									, @NumeroDeError = @NumeroDeError2, @sResSQL = @sResSQL OUTPUT
						END
				END
			ELSE
				BEGIN
					IF @RealizarUpdateSiElRegistroExiste = '1'
						BEGIN
							EXEC usp_Tablas__Update_by_@id	 
									@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
									,@FechaDeEjecucion = @FechaDeEjecucion
									,@Token = @Token
									,@Seccion = @Seccion
									,@CodigoDelContexto = @CodigoDelContexto
									,@id = @id
									,@IconoCSSId = @IconoCSSId
									--,@Nombre  // No permitimos modificarlo, tiene consecuencias en todo.
									,@NombreAMostrar = @NombreAMostrar
									,@Nomenclatura = @Nomenclatura
									,@Observaciones = @Observaciones
									,@SeDebenEvaluarPermisos = @SeDebenEvaluarPermisos
									,@PermiteEliminarSusRegistros = @PermiteEliminarSusRegistros
									,@TablaDeCore = @TablaDeCore
									,@SeCreanPaginas = @SeCreanPaginas
									,@TieneArchivos = @TieneArchivos
									,@CampoAMostrarEnFK = @CampoAMostrarEnFK
									,@CamposQuePuedenSerIdsString = @CamposQuePuedenSerIdsString
									,@CamposAExcluirEnElInsert = @CamposAExcluirEnElInsert
									,@CamposAExcluirEnElUpdate = @CamposAExcluirEnElUpdate
									,@CamposAExcluirEnElListado = @CamposAExcluirEnElListado
									,@CamposAIncluirEnFiltrosDeListado = @CamposAIncluirEnFiltrosDeListado
									--,@PermiteInsertAnonimamente = @PermiteInsertAnonimamente
									--,@PermiteListarDDLAnonimamente = @PermiteListarDDLAnonimamente
									,@SeGeneranAutoSusSPsDeABM = @SeGeneranAutoSusSPsDeABM
									,@SeGeneranAutoSusSPsDeRegistros = @SeGeneranAutoSusSPsDeRegistros
									,@SeGeneranAutoSusSPsDeListados = @SeGeneranAutoSusSPsDeListados
									,@sResSQL = @sResSQL OUTPUT
						END
				END
					
			IF (@id IS NOT NULL) AND (@SeCreanPaginas = 'True') AND (@sResSQL = '')
				BEGIN -- Ingreso todas sus páginas asociadas
					DECLARE @Fila INT = '1'
						,@NumeroDeFilas  INT 
						,@SeccionId	INT
						,@FuncionDePaginaId INT = '1'
						,@PaginaId INT
						,@SeMuestraEnAsignacionDePermisos BIT = '1'
						,@RolDeUsuario_MasterAdmin VARCHAR(80)
						
					EXEC @RolDeUsuario_MasterAdmin = ufc_RolesDeUsuarios__MasterAdmin
						
					-- Voy a ingresar una Página por cada FuncionDePagina Existente, que tenga seteado: GeneraPagina = '1'
					SELECT @NumeroDeFilas = COUNT(0) FROM FuncionesDePaginas WHERE GeneraPagina = '1'
					
					IF @NumeroDeFilas > 0 
						WHILE @Fila <= @NumeroDeFilas
							BEGIN
								SET @SeccionId = (SELECT id FROM Secciones WHERE Nombre = @Seccion)
								
								SELECT @FuncionDePaginaId = MIN(id) FROM FuncionesDePaginas WHERE (id > @FuncionDePaginaId) AND (GeneraPagina = '1') -- Tomo el id siguiente
								
								SET @PaginaId = (SELECT id FROM Paginas WHERE SeccionId = @SeccionId
																			AND TablaId = @id
																			AND FuncionDePaginaId = @FuncionDePaginaId)
																			
								
								-- Si @SaltarRegistrosExistentes = '0' pero @PaginaId NO es NULO --> igualmente tiene q intentar insertar (y que se produzca el error por "registro duplicado" devolviendo el mensaje acorde).
								IF @SaltarRegistrosExistentes = '0' OR @PaginaId IS NULL -- (@PaginaId IS NULL --> La página no existe)
									BEGIN
										-- Inserto la página en cuestión
										-- Ver explicación al inicion de creación del SP:
											-- (CADA EXECUTE siguiente va generando 1 Página q incluye la tabla insertada, y la FuncionDePagina en cuestión
											-- , y dentro de c/u llama (EXECUTE) al SP: "usp_RelAsig_RolesDeUsuarios_A_Paginas__InsertSegunPrioridadRoles" 
											-- (Luego en el paso posterior, dentro del SP q se ejecuta a continuación: se va insertando TODOS los RolesDeusuarios con permisos a esa Página.
										
										IF @RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
											AND	@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
											AND @RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
											AND @RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin -- Si para las 4 operaciones el rol menos prioritario que se indica es el del MasterAdmin --> NO PERMITIMOS CAMBIAR PERMISOS.
											BEGIN
												SET @SeMuestraEnAsignacionDePermisos = '0'
											END
												
												
										EXEC usp_Paginas__InsertSegunPrioridadRoles  
												@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
												,@FechaDeEjecucion = @FechaDeEjecucion
												,@Token = @Token
												,@Seccion = @Seccion
												,@CodigoDelContexto = @CodigoDelContexto
												,@SaltarRegistrosExistentes = @SaltarRegistrosExistentes
												,@TablaId = @id
												,@FuncionDePaginaId = @FuncionDePaginaId
												,@RolMenosPrioritarioQueCarga = @RolMenosPrioritarioQueCarga
												,@RolMenosPrioritarioQueOpera = @RolMenosPrioritarioQueOpera
												,@RolMenosPrioritarioQueVerRegAnulados = @RolMenosPrioritarioQueVerRegAnulados
												,@RolMenosPrioritarioQueAccionesEspeciales = @RolMenosPrioritarioQueAccionesEspeciales
												,@SeMuestraEnAsignacionDePermisos = @SeMuestraEnAsignacionDePermisos
												,@sResSQL = @sResSQL OUTPUT
												,@id = @PaginaId OUTPUT
											
											--SELECT 'Página id = ' +  CAST(@PaginaId AS VARCHAR(MAX))
									END
							SET @Fila = @Fila + 1
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
			RAISERROR (@sResSQL, 16, 1) --> ROLLBACK TRAN // RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState) // De esta forma, se hace el ROLLBACK, pero queda registrado el error en LogErrores.
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
 
 
 
 
IF (OBJECT_ID('usp_Tablas__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_Tablas__Update_by_@id
GO
CREATE PROCEDURE usp_Tablas__Update_by_@id
	 @id                        INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
 
	,@IconoCSSId                                               INT
	--,@Nombre                                                   VARCHAR(80) // No permitimos modificarlo, tiene consecuencias en todo.
	,@NombreAMostrar                                           VARCHAR(100)
	,@Nomenclatura                                             VARCHAR(12)
	,@Observaciones                                            VARCHAR(1000)
	,@SeDebenEvaluarPermisos                                   BIT
	,@PermiteEliminarSusRegistros                                          BIT
	,@TablaDeCore                                              BIT
	,@SeCreanPaginas                                           BIT
	,@TieneArchivos                                            BIT
	,@CampoAMostrarEnFK                                        VARCHAR(100)
	,@CamposQuePuedenSerIdsString                              VARCHAR(1000)
	,@CamposAExcluirEnElInsert                                 VARCHAR(1000)
	,@CamposAExcluirEnElUpdate                                 VARCHAR(1000)
	,@CamposAExcluirEnElListado                                VARCHAR(1000)
	,@CamposAIncluirEnFiltrosDeListado                         VARCHAR(1000)
	--,@PermiteInsertAnonimamente                                BIT
	--,@PermiteListarDDLAnonimamente                             BIT
	,@SeGeneranAutoSusSPsDeABM                                 BIT
	,@SeGeneranAutoSusSPsDeRegistros                           BIT
	,@SeGeneranAutoSusSPsDeListados                            BIT
 
	,@sResSQL                                                  VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Tablas'
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
			UPDATE Tablas
			SET
				IconoCSSId = @IconoCSSId
				--,Nombre = @Nombre
				,NombreAMostrar = @NombreAMostrar
				,Nomenclatura = @Nomenclatura
				,Observaciones = @Observaciones
				,SeDebenEvaluarPermisos = @SeDebenEvaluarPermisos
				,PermiteEliminarSusRegistros = @PermiteEliminarSusRegistros
				,TablaDeCore = @TablaDeCore
				,SeCreanPaginas = @SeCreanPaginas
				,TieneArchivos = @TieneArchivos
				,CampoAMostrarEnFK = @CampoAMostrarEnFK
				,CamposQuePuedenSerIdsString = @CamposQuePuedenSerIdsString
				,CamposAExcluirEnElInsert = @CamposAExcluirEnElInsert
				,CamposAExcluirEnElUpdate = @CamposAExcluirEnElUpdate
				,CamposAExcluirEnElListado = @CamposAExcluirEnElListado
				,CamposAIncluirEnFiltrosDeListado = @CamposAIncluirEnFiltrosDeListado
				--,PermiteInsertAnonimamente = @PermiteInsertAnonimamente
				--,PermiteListarDDLAnonimamente = @PermiteListarDDLAnonimamente
				,SeGeneranAutoSusSPsDeABM = @SeGeneranAutoSusSPsDeABM
				,SeGeneranAutoSusSPsDeRegistros = @SeGeneranAutoSusSPsDeRegistros
				,SeGeneranAutoSusSPsDeListados = @SeGeneranAutoSusSPsDeListados
			FROM Tablas
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
-- SP-TABLA: Tablas /ABMs/ - FIN




-- SP-TABLA: Usuarios /ABMs/ - INICIO
IF (OBJECT_ID('usp_Usuarios__Insert') IS NOT NULL) DROP PROCEDURE usp_Usuarios__Insert
GO
CREATE PROCEDURE usp_Usuarios__Insert
	@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
			
	,@UserName							VARCHAR(40)	
	,@Pass								VARCHAR(40)	
	,@Nombre							VARCHAR(40)
	,@Apellido							VARCHAR(40)
	,@Email								VARCHAR(60)							
	,@Email2							VARCHAR(60)							
	,@Telefono							VARCHAR(40)							
	,@Telefono2							VARCHAR(40)							
	,@Direccion							VARCHAR(1000)						
	,@Observaciones						VARCHAR(1000)
	--,@ActorId							INT
	,@RolDeUsuarioId					INT -- Con el que inicia
	,@SeMuestraEnAsignacionDeRoles		BIT = '1'
	
	,@Activo							BIT = '1'
	
	,@sResSQL							VARCHAR(1000)	OUTPUT
	,@id								INT		OUTPUT
AS
BEGIN TRY
BEGIN TRAN -- TR_U_Inst
	DECLARE @Tabla VARCHAR(80) = 'Usuarios'
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
			
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
 			DECLARE @UltimoLoginSesionId VARCHAR(24) = RAND()*100000000 -- 8 digitos
							
			INSERT INTO Usuarios
			(
				ContextoId
				--,ActorId
				,UserName
				,Pass	
				,Nombre
				,Apellido
				,Email	
				,Email2
				,Telefono
				,Telefono2
				,Direccion	
				,Observaciones
				,UltimoLoginSesionId
				,SeMuestraEnAsignacionDeRoles
				,Activo
			)
			VALUES
			(
				@ContextoId
				--,@ActorId
				,LOWER(@UserName) -- Para que no se repita con Mayúsculas
				,@Pass	
				,@Nombre
				,@Apellido
				,LOWER(@Email)	
				,LOWER(@Email2)
				,@Telefono
				,@Telefono2
				,@Direccion	
				,@Observaciones
				,@UltimoLoginSesionId
				,@SeMuestraEnAsignacionDeRoles
				,@Activo
			)

			SET @id = SCOPE_IDENTITY()
			
			-- Revisamos el resultado, si OK --> registra el LogRegistros, si falla --> Resgistra el LogError y devuelve el mensaje correcto.
			EXEC usp_ControlYLogRegistros__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
					, @Tabla = @Tabla , @RegistroId = @id, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @RegistrosAfectados = @@ROWCOUNT
					, @NumeroDeError = @@ERROR, @sResSQL = @sResSQL OUTPUT
		END
	
	-- Ahora le asignamos el Rol de Usuario:	// OJO ACÁ, VOY A REEMPLAZAR EL VALOR DE @id, por eso lo guardo		
	IF @sResSQL = ''
		BEGIN
			DECLARE @Guardo_id INT = @id -- Guardo el @id del usuario
			
			-- INSERT INTO RelAsig_RolesDeUsuarios_A_Usuarios (RolDeUsuarioId, UsuarioId, FechaDesde ) VALUES (@RolDeUsuarioId, @id, @FechaDeEjecucion)
			EXEC usp_RelAsig_RolesDeUsuarios_A_Usuarios__Insert  
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					,@FechaDeEjecucion = @FechaDeEjecucion
					,@Token = @Token
					,@Seccion = @Seccion
					,@CodigoDelContexto = @CodigoDelContexto
					,@RolDeUsuarioId = @RolDeUsuarioId
					,@UsuarioId = @id
					,@FechaDesde = @FechaDeEjecucion
					,@sResSQL = @sResSQL OUTPUT
					,@id = @id OUTPUT
			
			SET @id = @Guardo_id -- Se lo devuelvo, para que a la salilda, devolvemos el id del usuario.
		END
	
	-- Agregamos las notificaciones 
	IF @sResSQL = ''
		BEGIN
			DECLARE @NotificacionId INT
				,@Cuerpo VARCHAR(1000) = 'Nuevo usuario: ' + @Username
				,@IconoCSSId INT = COALESCE((SELECT id FROM IconosCSS WHERE Nombre = 'Life Ring Gray'), 1) -- Si no la encuentra id=1 (Default)
				,@RolReceptorId INT
			
			EXEC @RolReceptorId = ufc_RolesDeUsuarios__RecibeNotifPorModifUsuariosId
			
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
				
					-- Tablas_A_Sincronizar_Con_Dispositivos :			
					--IF @sResSQL = ''
					--	BEGIN
					--		----  sincronizar con dispositivos -------
					--		update Tablas_A_Sincronizar_Con_Dispositivos 
					--		set Sincronizar = '1'
					--		from Tablas_A_Sincronizar_Con_Dispositivos 				  
					--		where TablaId = 32
					--		  --'Usuarios'
					--		------ fin sincronizar con dispositivos-----
					--	END
	
	IF @sResSQL = ''
		BEGIN
			COMMIT TRAN
		END
	ELSE
		BEGIN
			SET @sResSQL = COALESCE(@sResSQL, '-NULL-')
			RAISERROR (@sResSQL, 16, 1) --> ROLLBACK TRAN // RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState) // De esta forma, se hace el ROLLBACK, pero queda registrado el error en LogErrores.
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




IF (OBJECT_ID('usp_Usuarios__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_Usuarios__Update_by_@id
GO
CREATE PROCEDURE usp_Usuarios__Update_by_@id
	@id									INT	
	
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	--,@ActorId							INT
	--,@UserName							VARCHAR(40)	// NO SE PUEDE MODIFICAR EL USERNAME, PUEDE TRAER MUCHOS PROBLEMAS O HASTA TEMAS DE SUSTITUCIÓN DE IDENTIDADES.
	--,@Pass								VARCHAR(40)	
	,@Nombre							VARCHAR(40)
	,@Apellido							VARCHAR(40)
	,@Email								VARCHAR(60)							
	,@Email2							VARCHAR(60)							
	,@Telefono							VARCHAR(60)							
	,@Telefono2							VARCHAR(60)							
	,@Direccion							VARCHAR(1000)						
	,@Observaciones						VARCHAR(1000)
	
	,@sResSQL							VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Usuarios'
		,@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT

	--IF (SELECT ContextoId FROM Actores WHERE id = @ActorId) <> @ContextoId -- Valido que el Actor sea del mismo contexto
	--	BEGIN
	--		SET @sResSQL = 'La operación no puede realizarse. El Actor idicado no pertenece al mismo contexto.'
	--	END
	
	IF @sResSQL = ''
		BEGIN
			EXEC usp_VAL_Usuarios__PuedeModificarAlUsuario -- Validamos si tiene permiso de modificar a este usuario
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					, @FechaDeEjecucion = @FechaDeEjecucion
					, @UsuarioId = @id
					, @sResSQL = @sResSQL OUTPUT
		END
		
	IF @sResSQL = ''
		BEGIN
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
		
			UPDATE Usuarios
			SET
				--ActorId = @ActorId
				--UserName = LOWER(@UserName) -- Para que no se repita con Mayúsculas
				Nombre = @Nombre
				,Apellido = @Apellido
				,Email = LOWER(@Email)
				,Email2 = LOWER(@Email2)
				,Telefono = @Telefono
				,Telefono2 = @Telefono2
				,Direccion = @Direccion
				,Observaciones = @Observaciones
			FROM Usuarios
			WHERE id = @id

			-- Revisamos el resultado, si OK --> registra el LogRegistros, si falla --> Resgistra el LogError y devuelve el mensaje correcto.
			EXEC usp_ControlYLogRegistros__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
					, @Tabla = @Tabla , @RegistroId = @id, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @RegistrosAfectados = @@ROWCOUNT
					, @NumeroDeError = @@ERROR, @sResSQL = @sResSQL OUTPUT
		
			
							-- Tablas_A_Sincronizar_Con_Dispositivos :			
							--IF @sResSQL = ''
							--	BEGIN
									------  sincronizar con dispositivos -------
									--update Tablas_A_Sincronizar_Con_Dispositivos 
									--set Sincronizar = '1'
									--from Tablas_A_Sincronizar_Con_Dispositivos 				  
									--where TablaId = 32
								   --'Usuarios'
									------ fin sincronizar con dispositivos-----
							--	END
		
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




IF (OBJECT_ID('usp_Usuarios__Update_Campos_Cambiar_Pass') IS NOT NULL) DROP PROCEDURE usp_Usuarios__Update_Campos_Cambiar_Pass
GO
CREATE PROCEDURE usp_Usuarios__Update_Campos_Cambiar_Pass
	@id								INT									
	
	,@UsuarioQueEjecutaId		INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@PassActual					VARCHAR(40)	 						
	,@PassNuevo						VARCHAR(40)	
	
	,@sResSQL						VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Usuarios'
		,@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
	
	
	-- Solo valido que sea él mismo el q ejecuta
	IF NOT @id = @UsuarioQueEjecutaId
		BEGIN
			EXEC @sResSQL = [dbo].ufc_Respuesta__NoTienePermiso -- Solo puede actualizar la contraseña el propio usuario.
		END
	ELSE
		BEGIN
			IF (SELECT COUNT(*) FROM Usuarios WHERE (id = @id) AND (Pass = @PassActual)) = '1' 
				BEGIN
					SET @sResSQL = '' 
					UPDATE Usuarios
					SET	Pass = @PassNuevo
					FROM Usuarios
					WHERE id = @id
					
					-- Revisamos el resultado, si OK --> registra el LogRegistros, si falla --> Resgistra el LogError y devuelve el mensaje correcto.
					EXEC usp_ControlYLogRegistros__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
							, @Tabla = @Tabla , @RegistroId = @id, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @RegistrosAfectados = @@ROWCOUNT
							, @NumeroDeError = @@ERROR, @sResSQL = @sResSQL OUTPUT
				END
			ELSE
				BEGIN
					SET @sResSQL = 'La contraseña ingresada no coincide con la anterior. No se puede realizar la actualización.'
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




IF (OBJECT_ID('usp_Usuarios__Update_Campos_Reset_Pass') IS NOT NULL) DROP PROCEDURE usp_Usuarios__Update_Campos_Reset_Pass
GO
CREATE PROCEDURE usp_Usuarios__Update_Campos_Reset_Pass
	@id									INT									
	
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 

	,@PassNuevo							VARCHAR(40)	
	
	,@sResSQL							VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Usuarios'
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
			EXEC usp_VAL_Usuarios__PuedeModificarAlUsuario -- Validamos si tiene permiso de modificar a este usuario
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					, @FechaDeEjecucion = @FechaDeEjecucion
					, @UsuarioId = @id
					, @sResSQL = @sResSQL OUTPUT
		END
		
	IF @sResSQL = ''
		BEGIN
			UPDATE Usuarios
			SET	Pass = @PassNuevo
			FROM Usuarios
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
---- SP-TABLA: Usuarios /ABMs/ - FIN


-- ---------------------------------
-- Script: DB_ParticularCore__C09b_ABMs PrioritariosB_Contextos, Paginas, Tablas y Usuarios.sql - FIN
-- =====================================================
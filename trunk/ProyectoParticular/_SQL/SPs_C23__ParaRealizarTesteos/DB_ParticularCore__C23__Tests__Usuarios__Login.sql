-- =====================================================
-- Descripción: Testing
-- Script: DB_ParticularCore__C23__Tests__Usuarios__Login.sql - INICIO
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
					
					DECLARE @UsuarioQueEjecutaId INT = '1'
						
						
			-- Tener en cuenta de 1ero tener en la BD seteada la cookie yla fecha de expiracion
						
						
						,@FechaDeEjecucion DATETIME = GetDate()
						,@Token                     VARCHAR(40) = NULL
						,@Seccion					VARCHAR(30) = NULL
						,@CodigoDelContexto			VARCHAR(40) = NULL
					 
						,@sResSQL VARCHAR(1000)
				-- Variable que utilizamos en los insert - FIN
				

EXEC	[dbo].[usp_Usuarios__Login]
			@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
			,@FechaDeEjecucion = @FechaDeEjecucion
			,@Token = @Token
			,@Seccion = @Seccion
			,@CodigoDelContexto = @CodigoDelContexto
		
		-- Parametros del SP Particular:
		--,@UserName  = 'testmasteradmin@testing' -- Usuario.UserName			
		-----,@Contexto					VARCHAR(40) = '' -- Contexto.Codigo
		--,@Pass 	= ''
		,@AuthCookie = '494FE62218C65863C6BDE0D29D9BD9E20376836B1BD6EFE7D9559D6D9690D34AA0AA16128F1CAB13B9B7377D114D3ED4A6181BEFA95E3A2698C79AF68D29AF53F8E3CC6A8595F9B6414D02798D3E97AED303B7F1917EA23435628A32DD4D1AE790E39DCBE058E69B7167BA56F2FB22D4'	
	
		,@sResSQL = @sResSQL OUTPUT
		
SELECT	'sResSQL=' + @sResSQL



EXEC	[dbo].[usp_Usuarios__Login]
		@UsuarioQueEjecutaId = @UsuarioQueEjecutaId,
		@FechaDeEjecucion = @FechaDeEjecucion,
		@Token = @Token,
		@Seccion = @Seccion,
		@CodigoDelContexto = @CodigoDelContexto
		
		-- Parametros del SP Particular:
		,@UserName  = 'testmasteradmin@testing' -- Usuario.UserName			
		-----,@Contexto					VARCHAR(40) = '' -- Contexto.Codigo
		,@Pass 	= ''
		--,@AuthCookie = '53BB573F014685C72F7FEC8C6E1EFBE8125DD13626CAF0465A4059F8BD1C873A85E5EEC31971E23FE71678E2ECF583D686B005E6F53A93971C7B1220D7C21BB16152C6F4FD2D3DF6CE725EE386FC872E0F24CF890AE1DA88409DDF9B344EDDEABA24020186D52FBAD688B0AB26818BAC'	
	
		,@sResSQL = @sResSQL OUTPUT
		
SELECT	'sResSQL=' + @sResSQL
GO
-- ---------------------------
-- Script: DB_ParticularCore__C23__Tests__Usuarios__Login.sql - FIN
-- =====================================================
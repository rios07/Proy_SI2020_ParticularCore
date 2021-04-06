	-- =====================================================
-- Descripci�n: Registros Particulares.sql
-- Script: DB_ParticularCore__C13b_Registros Particulares.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO

		-- Tablas Involucradas: - INICIO
			-- Archivos
			-- Contactos
			-- GruposDeContactos
			-- Notificaciones
			-- Publicaciones
			-- Registros
			-- Soportes
			-- Tareas
			-- Usuarios
		-- Tablas Involucradas: - FIN


-- SP-TABLA: Archivos /Registros Particulares/ - INICIO
IF (OBJECT_ID('usp_Archivos__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_Archivos__Registro_by_@id
GO
CREATE PROCEDURE usp_Archivos__Registro_by_@id
	@UsuarioQueEjecutaId		INT
	,@FechaDeEjecucion			DATETIME 
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@id							INT	
	
	,@sResSQL						VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = (SELECT Nombre FROM Tablas T INNER JOIN Archivos A ON T.id = A.TablaId WHERE A.id = @id) -- No la indicamos directamente, si no que se busca del registro que se pasa.
		,@FuncionDePagina VARCHAR(30) = 'Registro' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	-- Los permisos no se eval�an contra la tabla "Archivos", si no contra la tabla: @Tabla --> Contra el Registro "Padre"
	DECLARE @RegistroPadreId INT = (SELECT RegistroId FROM Archivos WHERE id = @id)
		,@RegistroInicial INT = @id -- Lo guardo
	
	SET @id = @RegistroPadreId
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
	
	SET @id = @RegistroInicial -- Lo recupero
	SET @Tabla = 'Archivos' -- Hago esto para mantener compatibilidad con las funciones genericas q se utilizan a continuaci�n con @Tabla.
	
	IF @sResSQL = ''
		BEGIN
			DECLARE @Historia	VARCHAR(1000) -- VER SI VA
			EXEC usp_LogRegistros__Listado_HistoriaDeUnRegistro  @RegistroId = @id, @Tabla = @Tabla, @Seccion = @Seccion, @Historia = @Historia OUTPUT
							
			DECLARE @TablaId INT = (SELECT TablaId FROM Archivos WHERE id = @id)
			
			DECLARE @UbicacionRelativaCompleta VARCHAR(100)
			EXEC @UbicacionRelativaCompleta = ufc_Ubicaciones__RelativaCompletaDeConenidosDeTabla
													@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
													,@TablaId = @TablaId
													,@Seccion = @Seccion
													,@CodigoDelContexto = @CodigoDelContexto
													
			DECLARE @UbicacionDeIconos VARCHAR(100)
			EXEC @UbicacionDeIconos = ufc_Ubicaciones__RelativaDeIconos
    
    		SELECT 	A.id
					,T.Nombre AS Tabla
					,@UbicacionRelativaCompleta + '/' + A.NombreFisicoCompleto AS srcArchivo -- Source completo del archivo.
					,A.NombreAMostrar
					,@UbicacionRelativaCompleta AS UbicacionRelativaCompleta
					,A.ExtensionDeArchivoId
					,A.Orden -- Si un registro tiene + de 1 Archivo --> Este campo los "ordena".
					--,Codigo
					,@UbicacionDeIconos + '/' + ICO.Imagen AS srcIcono -- Source completo del �cono.
					,A.Observaciones
					--,A.Activo
					,@Historia AS Historia
			FROM Archivos A
				INNER JOIN ExtensionesDeArchivos EXTDA ON EXTDA.id = A.ExtensionDeArchivoId
				INNER JOIN Iconos ICO ON ICO.id = EXTDA.IconoId
				INNER JOIN Tablas T ON T.id = A.TablaId
			WHERE A.id = @id
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
-- SP-TABLA: Archivos /Registros Particulares/ - FIN


 
 
-- SP-TABLA: Contactos /Registros Particulares/ - INICIO
IF (OBJECT_ID('usp_Contactos__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_Contactos__Registro_by_@id
GO
CREATE PROCEDURE usp_Contactos__Registro_by_@id
	 @UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion			DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@id								INT
	
	,@sResSQL							VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Contactos'
		,@FuncionDePagina VARCHAR(30) = 'Registro' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN
			DECLARE @Historia	VARCHAR(1000)
			EXEC usp_LogRegistros__Listado_HistoriaDeUnRegistro  @RegistroId = @id, @Tabla = @Tabla, @Seccion = @Seccion, @Historia = @Historia OUTPUT
 
			SELECT CTOS.id
				,CTOS.ContextoId
				,CTOS.EsUnaOrganizacion
				,CTOS.NombreCompleto
				,CTOS.Alias
				,CTOS.Organizacion
				,CTOS.RelacionConElContacto
				,CTOS.Email
				,CTOS.Email2
				,CTOS.Telefono
				,CTOS.Telefono2
				,CTOS.Direccion
				,CTOS.Url
				,CTOS.Observaciones
				--,CTOS.Activo
				,@Historia AS Historia
				,CAST(CX.Nombre AS VARCHAR(MAX)) AS Contexto
				-- IdsString:
				,COALESCE(STUFF((SELECT ', ' + CAST(RACATDC.TipoDeContactoId AS VARCHAR(MAX))
					FROM RelAsig_Contactos_A_TiposDeContactos AS RACATDC
					WHERE (RACATDC.ContactoId = @id)
					FOR XML PATH('')),1,1,''), '') AS TipoDeContactoIdsString
				,COALESCE(STUFF((SELECT ', ' + CAST(RACAGDC.GrupoDeContactoId AS VARCHAR(MAX))
					FROM RelAsig_Contactos_A_GruposDeContactos AS RACAGDC
					WHERE (RACAGDC.ContactoId = @id)
					FOR XML PATH('')),1,1,''), '') AS GrupoDeContactoIdsString
				-- Nombres String:
				,COALESCE(STUFF((SELECT ', ' + TDC.Nombre
					FROM RelAsig_Contactos_A_TiposDeContactos AS RACATDC
						INNER JOIN TiposDeContactos TDC ON TDC.id = RACATDC.TipoDeContactoId
					WHERE (RACATDC.ContactoId = @id)
					FOR XML PATH('')),1,1,''), '') AS TiposDeContacto -- No usar "TiposDeContactos" (plural) por que lo usan para las "listas".
				,COALESCE(STUFF((SELECT ', ' + GDC.Nombre
					FROM RelAsig_Contactos_A_GruposDeContactos AS RACAGDC
						INNER JOIN GruposDeContactos GDC ON GDC.id = RACAGDC.GrupoDeContactoId
					WHERE (RACAGDC.ContactoId = @id)
					FOR XML PATH('')),1,1,''), '') AS GruposDeContacto -- No usar "GruposDeContactos" (plural) por que lo usan para las "listas".
			FROM Contactos AS CTOS
				INNER JOIN Contextos CX ON CX.id = CTOS.ContextoId
			WHERE CTOS.id = @id
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
-- SP-TABLA: Contactos /Registros Particulares/ - FIN

 
 
 
-- SP-TABLA: GruposDeContactos /Registros Particulares/ - INICIO
IF (OBJECT_ID('usp_GruposDeContactos__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_GruposDeContactos__Registro_by_@id
GO
CREATE PROCEDURE usp_GruposDeContactos__Registro_by_@id
	 @UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
		
	,@id                                            INT
	
	,@sResSQL                                       VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'GruposDeContactos'
		,@FuncionDePagina VARCHAR(30) = 'Registro' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN
			DECLARE @Historia	VARCHAR(1000)
			EXEC usp_LogRegistros__Listado_HistoriaDeUnRegistro  @RegistroId = @id, @Tabla = @Tabla, @Seccion = @Seccion, @Historia = @Historia OUTPUT
 
			SELECT GDCTOS.id
				,GDCTOS.ContextoId
				,GDCTOS.Nombre
				,GDCTOS.Observaciones
				,@Historia AS Historia
				,CAST(CX.Nombre AS VARCHAR(MAX)) AS Contexto
				-- IdsString:
				,COALESCE(STUFF((SELECT ', ' + CAST(RACAGDC.ContactoId AS VARCHAR(MAX))
					FROM RelAsig_Contactos_A_GruposDeContactos AS RACAGDC
					WHERE (RACAGDC.GrupoDeContactoId = @id)
					FOR XML PATH('')),1,1,''), '') AS ContactoIdsString
				-- Nombres String:
				,COALESCE(STUFF((SELECT ', ' + CON.NombreCompleto
					FROM RelAsig_Contactos_A_GruposDeContactos AS RACAGDC
						INNER JOIN Contactos CON ON CON.id = RACAGDC.ContactoId
					WHERE (RACAGDC.GrupoDeContactoId = @id)
					FOR XML PATH('')),1,1,''), '') AS Contacto -- No usar "Contactos" (plural) por que lo usan para las "listas".
			FROM GruposDeContactos AS GDCTOS
				INNER JOIN Contextos CX ON CX.id = GDCTOS.ContextoId
			WHERE GDCTOS.id = @id
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
-- SP-TABLA: GruposDeContactos /Registros Particulares/ - FIN
 
 
 
 
-- SP-TABLA: Notificaciones /Registros Particulares/ - INICIO
IF (OBJECT_ID('usp_Notificaciones__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_Notificaciones__Registro_by_@id
GO
CREATE PROCEDURE usp_Notificaciones__Registro_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@id						INT
 
	,@sResSQL					VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Notificaciones'
		,@FuncionDePagina VARCHAR(30) = 'Registro' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN
			DECLARE @Historia	VARCHAR(1000)
			EXEC usp_LogRegistros__Listado_HistoriaDeUnRegistro  @RegistroId = @id, @Tabla = @Tabla, @Seccion = @Seccion, @Historia = @Historia OUTPUT
 
			SELECT NOTIF.id
				,NOTIF.ContextoId
				,NOTIF.Fecha
				,NOTIF.Numero
				,NOTIF.UsuarioDestinatarioId
				,NOTIF.TablaId
				,NOTIF.RegistroId
				,NOTIF.IconoCSSId
				,NOTIF.Cuerpo
				,NOTIF.Leida
				,NOTIF.Activo
				,@Historia AS Historia
				,CX.Nombre AS Contexto
				,Sec.Nombre AS Seccion
				,ICSS.CSS AS IconoCSS
				--,'<i class="' + ICSS.CSS + '"></i>' AS Icono
				,T.Nombre AS Tabla
				,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS UsuarioDestinatario
				,CASE WHEN DATEDIFF(MINUTE, NOTIF.Fecha, @FechaDeEjecucion) < 60 THEN CAST(DATEDIFF(MINUTE, NOTIF.Fecha, @FechaDeEjecucion) AS VARCHAR(MAX)) + 'm' 
					  WHEN DATEDIFF(HOUR, NOTIF.Fecha, @FechaDeEjecucion) < 24 THEN CAST(DATEDIFF(HOUR, NOTIF.Fecha, @FechaDeEjecucion) AS VARCHAR(MAX)) + 'h' 
					  ELSE CAST(DATEDIFF(DAY, NOTIF.Fecha, @FechaDeEjecucion) AS VARCHAR(MAX)) + 'd' 
					END AS Antiguedad
			FROM Notificaciones AS NOTIF
				INNER JOIN Contextos CX ON CX.id = NOTIF.ContextoId
				INNER JOIN IconosCSS ICSS ON ICSS.id = NOTIF.IconoCSSId
				INNER JOIN Tablas T ON T.id = NOTIF.TablaId
				INNER JOIN Secciones Sec ON Sec.id = NOTIF.SeccionId
				INNER JOIN Usuarios U ON U.id = NOTIF.UsuarioDestinatarioId
			WHERE NOTIF.id = @id
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
-- SP-TABLA: Notificaciones /Registros Particulares/ - FIN




-- SP-TABLA: Publicaciones /Registros Particulares/ - INICIO
IF (OBJECT_ID('usp_Publicaciones__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_Publicaciones__Registro_by_@id
GO
CREATE PROCEDURE usp_Publicaciones__Registro_by_@id
	@UsuarioQueEjecutaId		INT
	,@FechaDeEjecucion			DATETIME 
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@id							INT	
	
	,@sResSQL						VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Publicaciones'
		,@FuncionDePagina VARCHAR(30) = 'Registro' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT

	IF @sResSQL = ''
		BEGIN
			DECLARE @Historia	VARCHAR(1000)
			EXEC usp_LogRegistros__Listado_HistoriaDeUnRegistro  @RegistroId = @id, @Tabla = @Tabla, @Seccion = @Seccion, @Historia = @Historia OUTPUT
			
			SELECT 	PUB.id
				,PUB.Fecha
				--,CAST(PUB.Hora AS CHAR(5)) AS Hora
				,PUB.Hora
				,PUB.Titulo
				,PUB.NumeroDeVersion
				,PUB.Realizada
				,PUB.Observaciones
				,COALESCE(STUFF((SELECT ', ' + 'N� ' + CAST(SOP.Numero AS VARCHAR(MAX))
					FROM Soportes SOP
					WHERE SOP.PublicacionId = PUB.id FOR XML PATH('')),1,1,''), '-') AS Soportess
				,COALESCE(STUFF((SELECT ', ' + SS.Nombre
					FROM RelAsig_Subsistemas_A_Publicaciones RASaP
						INNER JOIN SubSistemas SS ON RASaP.SubsistemaId = SS.id
					WHERE RASaP.PublicacionId = PUB.id FOR XML PATH('')),1,1,''), '-') AS SubSistemas
				--,PUB.ContextoId
				--,CONT.Nombre AS Contexto
				,@Historia AS Historia
			FROM Publicaciones PUB
			WHERE PUB.id = @id
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
-- SP-TABLA: Publicaciones /Registros Particulares/ - FIN
 
 
 
 
-- SP-TABLA: Recursos /Registros Particulares/ - INICIO
IF (OBJECT_ID('usp_Recursos__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_Recursos__Registro_by_@id
GO
CREATE PROCEDURE usp_Recursos__Registro_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@id						INT
 
	,@sResSQL					VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Recursos'
		,@FuncionDePagina VARCHAR(30) = 'Registro' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
			, @RegistroId = @id
			--, @UsuarioId = @UsuarioId OUTPUT
			, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN
			DECLARE @Historia	VARCHAR(1000)
			EXEC usp_LogRegistros__Listado_HistoriaDeUnRegistro  @RegistroId = @id, @Tabla = @Tabla, @Seccion = @Seccion, @Historia = @Historia OUTPUT
			
			SELECT RECU.id
				,RECU.ContextoId
				,RECU.Nombre
				,RECU.Observaciones
				,RECU.Activo
				,@Historia AS Historia
				,COALESCE(STUFF((SELECT ', ' + U.Nombre + ' ' + U.Apellido
									FROM RelAsig_Usuarios_A_Recursos REL
										INNER JOIN Usuarios U ON U.id = REL.UsuarioId
									WHERE (REL.RecursoId = RECU.id)
									FOR XML PATH('')),1,1,''), '')AS UsuariosResponsables
				,CAST(CX.Nombre AS VARCHAR(MAX)) AS Contexto
			FROM Recursos AS RECU
				INNER JOIN Contextos CX ON CX.id = RECU.ContextoId
			WHERE RECU.id = @id
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
-- SP-TABLA: Recursos /Registros Particulares/ - FIN




-- SP-TABLA: Soportes /Registros Particulares/ - INICIO
IF (OBJECT_ID('usp_Soportes__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_Soportes__Registro_by_@id
GO
CREATE PROCEDURE usp_Soportes__Registro_by_@id
	@UsuarioQueEjecutaId		INT
	,@FechaDeEjecucion			DATETIME 
	,@Token                     VARCHAR(40)
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@id							INT	
	
	,@sResSQL						VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Soportes'
		,@FuncionDePagina VARCHAR(30) = 'Registro' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT

	IF @sResSQL = ''
		BEGIN
			DECLARE @Historia	VARCHAR(1000)
			EXEC usp_LogRegistros__Listado_HistoriaDeUnRegistro  @RegistroId = @id, @Tabla = @Tabla, @Seccion = @Seccion, @Historia = @Historia OUTPUT
			
			DECLARE @TablaId INT =(SELECT id FROM Tablas WHERE Nombre = @Tabla)
											
			SELECT 	SOP.id
				,UCREO.UserName AS UsuarioQueEjecuta
				,UCREO.Email AS EmailUsuarioQueCreo
				,USOL.Id AS UsuarioQueSolicitaId
				,USOL.UserName AS UsuarioQueSolicita
				,USOL.Email AS EmailUsuarioQueSolicito
				,SOP.FechaDeEjecucion
				,UCERRO.Id AS UsuarioQueCerroId
				,UCERRO.UserName AS UsuarioQueCerro
				,SOP.Numero
				,SOP.FechaDeCierre
				,SOP.Texto
				,SOP.EstadoDeSoportesId AS EstadoDeSoporteId
				,EDS.Nombre AS EstadoDeSoporte
				,EDS.Observaciones AS ObservacionesDeEstadoDeSoporte
				,SOP.PrioridadDeSoporteId
				,PRIO.Nombre AS Prioridad
				,SOP.Observaciones
				,SOP.ObservacionesPrivadas
				,SOP.Cerrado
				,SOP.Activo
				,LREG.FechaDeEjecucion
				--,N'images/cbx/imgRealizado_' + CONVERT(VARCHAR(5), SOP.Cerrado) + N'.png' AS img_Cerrado
				,REPLACE(REPLACE(SOP.Cerrado, '1', 'Pedido Cerrado'), '0', 'Pedido Pendiente') AS TextoCerrado
				,@Historia AS Historia
			FROM Soportes SOP
				INNER JOIN LogRegistros LREG ON LREG.TablaId = @TablaId AND LREG.RegistroId = SOP.id AND LREG.TipoDeOperacionId = 2 -- 2:CREADO
				INNER JOIN Usuarios UCREO ON LREG.UsuarioQueEjecutaId = UCREO.id
				INNER JOIN Usuarios USOL ON SOP.UsuarioQueSolicitaId = USOL.id
				LEFT JOIN Usuarios UCERRO ON SOP.UsuarioQueCerroId = UCERRO.id -- Por NULLs
				INNER JOIN PrioridadesDeSoportes PRIO ON SOP.PrioridadDeSoporteId = PRIO.id
				INNER JOIN EstadosDeSoportes EDS ON SOP.EstadoDeSoportesId = EDS.id
			WHERE (SOP.id = @id) --AND (SOP.FechaDeCierre IS NOT NULL)
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
-- SP-TABLA: Soportes /Registros Particulares/ - FIN




-- SP-TABLA: Tareas /Registros Particulares/ - INICIO
IF (OBJECT_ID('usp_Tareas__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_Tareas__Registro_by_@id
GO
CREATE PROCEDURE usp_Tareas__Registro_by_@id
	@UsuarioQueEjecutaId		INT
	,@FechaDeEjecucion			DATETIME 
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@id							INT	
    
    ,@sResSQL						VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Tareas'
		,@FuncionDePagina VARCHAR(30) = 'Registro' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
		
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT

	IF @sResSQL = ''
		BEGIN
			DECLARE @Historia	VARCHAR(1000)
			EXEC usp_LogRegistros__Listado_HistoriaDeUnRegistro  @RegistroId = @id, @Tabla = @Tabla, @Seccion = @Seccion, @Historia = @Historia OUTPUT
			
			SELECT TA.id
				,TA.ContextoId
				,dbo.ufc_Usuarios__NombreCompletoFormateado(UO.id) AS UsuarioOriginante
				,TA.UsuarioOriginanteId
				,dbo.ufc_Usuarios__NombreCompletoFormateado(UD.id) AS UsuarioDestinatario
				,TA.UsuarioDestinatarioId
				,TA.FechaDeInicio
				,TA.FechaLimite
				,TA.Numero
				,TDT.Nombre AS TipoDeTarea
				,TA.TipoDeTareaId
				,EDT.Nombre AS EstadoDeTarea
				,TA.EstadoDeTareaId
				,TA.Titulo
				,IDT.Nombre AS ImportanciaDeTarea
				,TA.ImportanciaDeTareaId
				,CASE	WHEN T.id = 1 THEN 'La tarea no hace referencia a ning�n registro.'
						ELSE 'La tarea hace referencia al registro del m�dulo "' + T.NombreAMostrar + '" - id=' + CAST(RegistroId AS VARCHAR(MAX)) + '.  '
						END AS RegistroDeReferencia
				,T.Nombre AS TablaDeReferencia
				,TA.RegistroId
				,TA.Observaciones
				,TA.Activo
				,@Historia AS Historia
			FROM Tareas TA
				INNER JOIN Usuarios UO ON TA.UsuarioOriginanteId = UO.id
				INNER JOIN Usuarios UD ON TA.UsuarioDestinatarioId = UD.id
				INNER JOIN TiposDeTareas TDT ON TA.TipoDeTareaId = TDT.id
				INNER JOIN EstadosDeTareas EDT ON TA.EstadoDeTareaId = EDT.id
				INNER JOIN ImportanciasDeTareas IDT ON TA.ImportanciaDeTareaId = IDT.id
				INNER JOIN Tablas T ON TA.TablaId = T.id
			WHERE TA.id = @id
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
-- SP-TABLA: Tareas /Registros Particulares/ - FIN

 
 
 
-- SP-TABLA: Usuarios /Registros Particulares/ - INICIO
IF (OBJECT_ID('usp_Usuarios__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_Usuarios__Registro_by_@id
GO
CREATE PROCEDURE usp_Usuarios__Registro_by_@id
	 @UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40) 
	
	,@id                                            INT
	
	,@sResSQL                                       VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Usuarios'
		,@FuncionDePagina VARCHAR(30) = 'Registro' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
	
	IF @sResSQL = ''
		BEGIN
			DECLARE @Historia	VARCHAR(1000)
			EXEC usp_LogRegistros__Listado_HistoriaDeUnRegistro  @RegistroId = @id, @Tabla = @Tabla, @Seccion = @Seccion, @Historia = @Historia OUTPUT

			DECLARE @TextoPrivado VARCHAR(10)
			EXEC usp_VAL_Secciones__CorrespondeATextosPrivados @Seccion = @Seccion, @TextoPrivado = @TextoPrivado OUTPUT
			
			DECLARE @SeMuestraEnAsignacionDeRoles BIT		-- Roles A Usuarios	
			EXEC usp_VAL_Usuarios__SeMuestraEnAsignacionDeRoles  -- Validamos si puede ver los roles o no.
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					, @FechaDeEjecucion = @FechaDeEjecucion
					, @SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OUTPUT
			
			SELECT U.id
				,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS NombreCompleto
				--,U.ActorId
				,U.ContextoId
				,U.UserName
				--,U.Pass
				,U.Nombre
				,U.Apellido
				,U.Email
				,U.Email2
				,U.Telefono
				,U.Telefono2
				,CASE WHEN @TextoPrivado = '' THEN U.Direccion ELSE @TextoPrivado END AS Direccion
				,CASE WHEN @TextoPrivado = '' THEN U.Observaciones ELSE @TextoPrivado END AS Observaciones
				,U.Activo
				,CASE WHEN @TextoPrivado = '' THEN U.UltimoLoginSesionId ELSE @TextoPrivado END AS UltimoLoginSesionId
				,CASE WHEN @TextoPrivado = '' THEN U.UltimoLoginFecha ELSE NULL END AS UltimoLoginFecha
				,CASE WHEN @TextoPrivado = '' THEN U.AuthCookie ELSE @TextoPrivado END AS AuthCookie
				,CASE WHEN @TextoPrivado = '' THEN U.FechaDeExpiracionCookie ELSE NULL END AS FechaDeExpiracionCookie
				,@Historia AS Historia
				--,CAST(ACT.Nombre AS VARCHAR(MAX)) AS Actor
				,CAST(CX.Nombre AS VARCHAR(MAX)) AS Contexto
				,CASE WHEN @TextoPrivado = '' THEN COALESCE(STUFF((SELECT ', ' + RDU.Nombre
													FROM dbo.RelAsig_RolesDeUsuarios_A_Usuarios AS RDUAU
														INNER JOIN RolesDeUsuarios RDU ON RDU.id = RDUAU.RolDeUsuarioId
													WHERE (RDUAU.UsuarioId = U.id AND (RDU.SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OR @SeMuestraEnAsignacionDeRoles IS NULL))
													FOR XML PATH('')),1,1,''), '') 
											 ELSE @TextoPrivado 
											 END AS RolesDeUsuario -- Va sin la "s" x q si no, se pisa con el campo del DDL en .Net
			FROM Usuarios AS U
				--INNER JOIN Actores ACT ON ACT.id = U.ActorId
				INNER JOIN Contextos CX ON CX.id = U.ContextoId
			WHERE U.id = @id
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
-- SP-TABLA: Usuarios /Registros Particulares/ - FIN


-- ---------------------------------
-- Script: DB_ParticularCore__C13b_Registros Particulares.sql - FIN
-- =====================================================
﻿-- ==========================================================================================================
-- Descripción: SPs de Registros generados automáticamente en función de los parámetros seteados en cada tabla.
-- Script: DB_ParticularCore__C13a_Registros Generados Automaticamente - v10.8 - INICIO
-- ---------------------------
 
USE DB_ParticularCore
GO
 
		-- Tablas Involucradas: - INICIO
			-- Actores
			-- CategoriasDeInformes
			-- Contextos
			-- CuentasDeEnvios
			-- Dispositivos
			-- EnviosDeCorreos
			-- EstadosDeLogErrores
			-- EstadosDeSoportes
			-- EstadosDeTareas
			-- ExtensionesDeArchivos
			-- FuncionesDePaginas
			-- Iconos
			-- IconosCSS
			-- Importaciones
			-- ImportanciasDeTareas
			-- Informes
			-- LogEnviosDeCorreos
			-- LogErrores
			-- LogErroresApp
			-- LogLogins
			-- LogLoginsDeDispositivos
			-- LogLoginsDeDispositivosRechazados
			-- LogRegistros
			-- Notas
			-- Paginas
			-- ParametrosDelSistema
			-- PrioridadesDeSoportes
			-- RecorridosDeDispositivos
			-- RelAsig_Contactos_A_GruposDeContactos
			-- RelAsig_Contactos_A_TiposDeContactos
			-- RelAsig_CuentasDeEnvios_A_Tablas
			-- RelAsig_RolesDeUsuarios_A_Paginas
			-- RelAsig_RolesDeUsuarios_A_Usuarios
			-- RelAsig_Subsistemas_A_Publicaciones
			-- RelAsig_TiposDeContactos_A_Contextos
			-- RelAsig_Usuarios_A_Recursos
			-- ReservasDeRecursos
			-- RolesDeUsuarios
			-- Secciones
			-- SPs
			-- Subsistemas
			-- Tablas
			-- TablasYFuncionesDePaginas
			-- TiposDeActores
			-- TiposDeArchivos
			-- TiposDeContactos
			-- TiposDeLogLogins
			-- TiposDeOperaciones
			-- TiposDeTareas
			-- Ubicaciones
			-- Unidades
		-- Tablas Involucradas: - FIN
 
 
-- SP-TABLA: Actores /Registro/ - INICIO
IF (OBJECT_ID('usp_Actores__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_Actores__Registro_by_@id
GO
CREATE PROCEDURE usp_Actores__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'Actores'
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
 
			SELECT ACT.id
				,ACT.ContextoId
				,ACT.TipoDeActorId
				,ACT.Codigo
				,ACT.Nombre
				,ACT.Email
				,ACT.Email2
				,ACT.Telefono
				,ACT.Telefono2
				,ACT.Direccion
				,ACT.Observaciones
				,ACT.Activo
				,@Historia AS Historia
				,COALESCE(CAST(CX.Nombre AS VARCHAR(MAX)), '') AS Contexto
				,COALESCE(CAST(TDA.Nombre AS VARCHAR(MAX)), '') AS TipoDeActor
			FROM Actores AS ACT
				INNER JOIN Contextos CX ON CX.id = ACT.ContextoId
				INNER JOIN TiposDeActores TDA ON TDA.id = ACT.TipoDeActorId
			WHERE ACT.id = @id
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
-- SP-TABLA: Actores /Registro/ - FIN
 
 
 
 
-- SP-TABLA: CategoriasDeInformes /Registro/ - INICIO
IF (OBJECT_ID('usp_CategoriasDeInformes__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_CategoriasDeInformes__Registro_by_@id
GO
CREATE PROCEDURE usp_CategoriasDeInformes__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'CategoriasDeInformes'
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
 
			SELECT CDI.id
				,CDI.ContextoId
				,CDI.Nombre
				,CDI.Observaciones
				,CDI.Activo
				,@Historia AS Historia
				,COALESCE(CAST(CX.Nombre AS VARCHAR(MAX)), '') AS Contexto
			FROM CategoriasDeInformes AS CDI
				INNER JOIN Contextos CX ON CX.id = CDI.ContextoId
			WHERE CDI.id = @id
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
-- SP-TABLA: CategoriasDeInformes /Registro/ - FIN
 
 
 
 
-- SP-TABLA: Contextos /Registro/ - INICIO
IF (OBJECT_ID('usp_Contextos__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_Contextos__Registro_by_@id
GO
CREATE PROCEDURE usp_Contextos__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'Contextos'
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
 
			SELECT CX.id
				,CX.Numero
				,CX.Nombre
				,CX.Codigo
				,CX.CarpetaDeContenidos
				,CX.Observaciones
				,@Historia AS Historia
			FROM Contextos AS CX
			WHERE CX.id = @id
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
-- SP-TABLA: Contextos /Registro/ - FIN
 
 
 
 
-- SP-TABLA: CuentasDeEnvios /Registro/ - INICIO
IF (OBJECT_ID('usp_CuentasDeEnvios__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_CuentasDeEnvios__Registro_by_@id
GO
CREATE PROCEDURE usp_CuentasDeEnvios__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'CuentasDeEnvios'
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
 
			SELECT CDE.id
				,CDE.Nombre
				,CDE.CuentaDeEmail
				,CDE.PwdDeEmail
				,CDE.Smtp
				,CDE.Puerto
				,CDE.Observaciones
				,@Historia AS Historia
			FROM CuentasDeEnvios AS CDE
			WHERE CDE.id = @id
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
-- SP-TABLA: CuentasDeEnvios /Registro/ - FIN
 
 
 
 
-- SP-TABLA: Dispositivos /Registro/ - INICIO
IF (OBJECT_ID('usp_Dispositivos__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_Dispositivos__Registro_by_@id
GO
CREATE PROCEDURE usp_Dispositivos__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'Dispositivos'
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
 
			SELECT DISP.id
				,DISP.AsignadoAUsuarioId
				,DISP.MachineName
				,DISP.OSVersion
				,DISP.UserMachineName
				,DISP.ClavePrivada
				,DISP.ClavePrivadaEntregada
				,DISP.ClavePrivadaFechaEntrega
				,DISP.Observaciones
				,DISP.Activo
				,@Historia AS Historia
				,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS AsignadoAUsuario
			FROM Dispositivos AS DISP
				INNER JOIN Usuarios U ON U.id = DISP.AsignadoAUsuarioId
			WHERE DISP.id = @id
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
-- SP-TABLA: Dispositivos /Registro/ - FIN
 
 
 
 
-- SP-TABLA: EnviosDeCorreos /Registro/ - INICIO
IF (OBJECT_ID('usp_EnviosDeCorreos__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_EnviosDeCorreos__Registro_by_@id
GO
CREATE PROCEDURE usp_EnviosDeCorreos__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'EnviosDeCorreos'
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
 
			SELECT EDC.id
				,EDC.UsuarioOriginanteId
				,EDC.UsuarioDestinatarioId
				,EDC.TablaId
				,EDC.RegistroId
				,EDC.EmailDeDestino
				,EDC.Asunto
				,EDC.Contenido
				,EDC.FechaPactadaDeEnvio
				,EDC.Activo
				,@Historia AS Historia
				,COALESCE(CAST(T.Nombre AS VARCHAR(MAX)), '') AS Tabla
				,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS UsuarioOriginante
				,dbo.ufc_Usuarios__NombreCompletoFormateado(U3.id) AS UsuarioDestinatario
			FROM EnviosDeCorreos AS EDC
				INNER JOIN Tablas T ON T.id = EDC.TablaId
				INNER JOIN Usuarios U ON U.id = EDC.UsuarioOriginanteId
				INNER JOIN Usuarios U3 ON U3.id = EDC.UsuarioDestinatarioId
			WHERE EDC.id = @id
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
-- SP-TABLA: EnviosDeCorreos /Registro/ - FIN
 
 
 
 
-- SP-TABLA: EstadosDeLogErrores /Registro/ - INICIO
IF (OBJECT_ID('usp_EstadosDeLogErrores__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_EstadosDeLogErrores__Registro_by_@id
GO
CREATE PROCEDURE usp_EstadosDeLogErrores__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'EstadosDeLogErrores'
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
 
			SELECT EDLE.id
				,EDLE.Nombre
				,EDLE.Nomenclatura
				,EDLE.Orden
				,EDLE.Observaciones
				,@Historia AS Historia
			FROM EstadosDeLogErrores AS EDLE
			WHERE EDLE.id = @id
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
-- SP-TABLA: EstadosDeLogErrores /Registro/ - FIN
 
 
 
 
-- SP-TABLA: EstadosDeSoportes /Registro/ - INICIO
IF (OBJECT_ID('usp_EstadosDeSoportes__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_EstadosDeSoportes__Registro_by_@id
GO
CREATE PROCEDURE usp_EstadosDeSoportes__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'EstadosDeSoportes'
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
 
			SELECT EDS.id
				,EDS.Nombre
				,EDS.Nomenclatura
				,EDS.Orden
				,EDS.Observaciones
				,EDS.CierraSoporte
				,EDS.Activo
				,@Historia AS Historia
			FROM EstadosDeSoportes AS EDS
			WHERE EDS.id = @id
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
-- SP-TABLA: EstadosDeSoportes /Registro/ - FIN
 
 
 
 
-- SP-TABLA: EstadosDeTareas /Registro/ - INICIO
IF (OBJECT_ID('usp_EstadosDeTareas__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_EstadosDeTareas__Registro_by_@id
GO
CREATE PROCEDURE usp_EstadosDeTareas__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'EstadosDeTareas'
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
 
			SELECT EDT.id
				,EDT.Nombre
				,EDT.Nomenclatura
				,EDT.Orden
				,EDT.Observaciones
				,EDT.Activo
				,@Historia AS Historia
			FROM EstadosDeTareas AS EDT
			WHERE EDT.id = @id
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
-- SP-TABLA: EstadosDeTareas /Registro/ - FIN
 
 
 
 
-- SP-TABLA: ExtensionesDeArchivos /Registro/ - INICIO
IF (OBJECT_ID('usp_ExtensionesDeArchivos__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_ExtensionesDeArchivos__Registro_by_@id
GO
CREATE PROCEDURE usp_ExtensionesDeArchivos__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'ExtensionesDeArchivos'
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
 
			SELECT EDA.id
				,EDA.Nombre
				,EDA.IconoId
				,EDA.TipoDeArchivoId
				,EDA.ProgramaAsociado
				,EDA.Observaciones
				,@Historia AS Historia
				,COALESCE(CAST(IC.Nombre AS VARCHAR(MAX)), '') AS Icono
				,COALESCE(CAST(TDARCH.Nombre AS VARCHAR(MAX)), '') AS TipoDeArchivo
			FROM ExtensionesDeArchivos AS EDA
				INNER JOIN Iconos IC ON IC.id = EDA.IconoId
				INNER JOIN TiposDeArchivos TDARCH ON TDARCH.id = EDA.TipoDeArchivoId
			WHERE EDA.id = @id
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
-- SP-TABLA: ExtensionesDeArchivos /Registro/ - FIN
 
 
 
 
-- SP-TABLA: FuncionesDePaginas /Registro/ - INICIO
IF (OBJECT_ID('usp_FuncionesDePaginas__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_FuncionesDePaginas__Registro_by_@id
GO
CREATE PROCEDURE usp_FuncionesDePaginas__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'FuncionesDePaginas'
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
 
			SELECT FDP.id
				,FDP.Nombre
				,FDP.NombreAMostrar
				,FDP.Observaciones
				,FDP.GeneraPagina
				,FDP.SeDebenEvaluarPermisos
				,FDP.EsUnaConRegistro
				,@Historia AS Historia
			FROM FuncionesDePaginas AS FDP
			WHERE FDP.id = @id
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
-- SP-TABLA: FuncionesDePaginas /Registro/ - FIN
 
 
 
 
-- SP-TABLA: Iconos /Registro/ - INICIO
IF (OBJECT_ID('usp_Iconos__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_Iconos__Registro_by_@id
GO
CREATE PROCEDURE usp_Iconos__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'Iconos'
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
 
			SELECT IC.id
				,IC.Nombre
				,IC.Imagen
				,IC.Altura
				,IC.Ancho
				,IC.OffsetX
				,IC.OffsetY
				,IC.Observaciones
				,IC.Activo
				,@Historia AS Historia
			FROM Iconos AS IC
			WHERE IC.id = @id
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
-- SP-TABLA: Iconos /Registro/ - FIN
 
 
 
 
-- SP-TABLA: IconosCSS /Registro/ - INICIO
IF (OBJECT_ID('usp_IconosCSS__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_IconosCSS__Registro_by_@id
GO
CREATE PROCEDURE usp_IconosCSS__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'IconosCSS'
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
 
			SELECT ICSS.id
				,ICSS.Nombre
				,ICSS.CSS
				,ICSS.Observaciones
				,@Historia AS Historia
			FROM IconosCSS AS ICSS
			WHERE ICSS.id = @id
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
-- SP-TABLA: IconosCSS /Registro/ - FIN
 
 
 
 
-- SP-TABLA: Importaciones /Registro/ - INICIO
IF (OBJECT_ID('usp_Importaciones__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_Importaciones__Registro_by_@id
GO
CREATE PROCEDURE usp_Importaciones__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'Importaciones'
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
 
			SELECT IMT.id
				,IMT.ContextoId
				,IMT.UsuarioQueImportaId
				,IMT.TablaId
				,IMT.Numero
				,IMT.Fecha
				,IMT.Observaciones
				,IMT.ObservacionesPosteriores
				,IMT.Activo
				,@Historia AS Historia
				,COALESCE(CAST(CX.Nombre AS VARCHAR(MAX)), '') AS Contexto
				,COALESCE(CAST(T.Nombre AS VARCHAR(MAX)), '') AS Tabla
				,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS UsuarioQueImporta
			FROM Importaciones AS IMT
				INNER JOIN Contextos CX ON CX.id = IMT.ContextoId
				INNER JOIN Tablas T ON T.id = IMT.TablaId
				INNER JOIN Usuarios U ON U.id = IMT.UsuarioQueImportaId
			WHERE IMT.id = @id
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
-- SP-TABLA: Importaciones /Registro/ - FIN
 
 
 
 
-- SP-TABLA: ImportanciasDeTareas /Registro/ - INICIO
IF (OBJECT_ID('usp_ImportanciasDeTareas__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_ImportanciasDeTareas__Registro_by_@id
GO
CREATE PROCEDURE usp_ImportanciasDeTareas__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'ImportanciasDeTareas'
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
 
			SELECT IDT.id
				,IDT.Nombre
				,IDT.Nomenclatura
				,IDT.Orden
				,IDT.Observaciones
				,@Historia AS Historia
			FROM ImportanciasDeTareas AS IDT
			WHERE IDT.id = @id
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
-- SP-TABLA: ImportanciasDeTareas /Registro/ - FIN
 
 
 
 
-- SP-TABLA: Informes /Registro/ - INICIO
IF (OBJECT_ID('usp_Informes__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_Informes__Registro_by_@id
GO
CREATE PROCEDURE usp_Informes__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'Informes'
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
 
			SELECT INF.id
				,INF.ContextoId
				,INF.UsuarioId
				,INF.CategoriaDeInformeId
				,INF.Titulo
				,INF.Texto
				,INF.FechaDeInforme
				,INF.Activo
				,INF.Observaciones
				,@Historia AS Historia
				,COALESCE(CAST(CDI.Nombre AS VARCHAR(MAX)), '') AS CategoriaDeInforme
				,COALESCE(CAST(CX.Nombre AS VARCHAR(MAX)), '') AS Contexto
				,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS Usuario
			FROM Informes AS INF
				INNER JOIN CategoriasDeInformes CDI ON CDI.id = INF.CategoriaDeInformeId
				INNER JOIN Contextos CX ON CX.id = INF.ContextoId
				INNER JOIN Usuarios U ON U.id = INF.UsuarioId
			WHERE INF.id = @id
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
-- SP-TABLA: Informes /Registro/ - FIN
 
 
 
 
-- SP-TABLA: LogEnviosDeCorreos /Registro/ - INICIO
IF (OBJECT_ID('usp_LogEnviosDeCorreos__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_LogEnviosDeCorreos__Registro_by_@id
GO
CREATE PROCEDURE usp_LogEnviosDeCorreos__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'LogEnviosDeCorreos'
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
 
			SELECT LEDC.id
				,LEDC.EnvioDeCorreoId
				,LEDC.Satisfactorio
				,LEDC.Fecha
				,LEDC.Observaciones
				,LEDC.ObservacionesDeRevision
				,@Historia AS Historia
				,COALESCE(CAST(EDC.Asunto AS VARCHAR(MAX)), '') AS EnvioDeCorreo
			FROM LogEnviosDeCorreos AS LEDC
				INNER JOIN EnviosDeCorreos EDC ON EDC.id = LEDC.EnvioDeCorreoId
			WHERE LEDC.id = @id
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
-- SP-TABLA: LogEnviosDeCorreos /Registro/ - FIN
 
 
 
 
-- SP-TABLA: LogErrores /Registro/ - INICIO
IF (OBJECT_ID('usp_LogErrores__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_LogErrores__Registro_by_@id
GO
CREATE PROCEDURE usp_LogErrores__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'LogErrores'
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
 
			SELECT LE.id
				,LE.UsuarioQueEjecutaId
				,LE.FechaDeEjecucion
				,LE.Token
				,LE.Seccion
				,LE.CodigoDelContexto
				,LE.UsuarioQueEjecutaPersisteEnLaBD
				,LE.TablaId
				,LE.TipoDeOperacionId
				,LE.SP
				,LE.NumeroDeError
				,LE.LineaDeError
				,LE.ErrorEnAmbienteSQL
				,LE.Mensaje
				,LE.sResSQLDeEntrada
				,LE.PaginaId
				,LE.Accion
				,LE.Capa
				,LE.Metodo
				,LE.MachineName
				,LE.EstadoDeLogErrorId
				,LE.Observaciones
				,@Historia AS Historia
				,COALESCE(CAST(EDLE.Nombre AS VARCHAR(MAX)), '') AS EstadoDeLogError
				,COALESCE(CAST(P.Nombre AS VARCHAR(MAX)), '') AS Pagina
				,COALESCE(CAST(T.Nombre AS VARCHAR(MAX)), '') AS Tabla
				,COALESCE(CAST(TDO.Nombre AS VARCHAR(MAX)), '') AS TipoDeOperacion
			FROM LogErrores AS LE
				INNER JOIN EstadosDeLogErrores EDLE ON EDLE.id = LE.EstadoDeLogErrorId
				INNER JOIN Paginas P ON P.id = LE.PaginaId
				INNER JOIN Tablas T ON T.id = LE.TablaId
				INNER JOIN TiposDeOperaciones TDO ON TDO.id = LE.TipoDeOperacionId
			WHERE LE.id = @id
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
-- SP-TABLA: LogErrores /Registro/ - FIN
 
 
 
 
-- SP-TABLA: LogErroresApp /Registro/ - INICIO
IF (OBJECT_ID('usp_LogErroresApp__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_LogErroresApp__Registro_by_@id
GO
CREATE PROCEDURE usp_LogErroresApp__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'LogErroresApp'
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
 
			SELECT LEAPP.id
				,LEAPP.FechaDeEjecucion
				,LEAPP.TokenId
				,LEAPP.DispositivoMachineName
				,LEAPP.UsuarioId
				,LEAPP.Metodo
				,LEAPP.Clase
				,LEAPP.Linea
				,LEAPP.Texto
				,@Historia AS Historia
				,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS Usuario
			FROM LogErroresApp AS LEAPP
				LEFT JOIN Usuarios U ON U.id = LEAPP.UsuarioId -- OJO VA LEFT JOIN x que el campo puede ser NULL
			WHERE LEAPP.id = @id
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
-- SP-TABLA: LogErroresApp /Registro/ - FIN
 
 
 
 
-- SP-TABLA: LogLogins /Registro/ - INICIO
IF (OBJECT_ID('usp_LogLogins__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_LogLogins__Registro_by_@id
GO
CREATE PROCEDURE usp_LogLogins__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'LogLogins'
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
 
			SELECT LL.id
				,LL.UsuarioId
				,LL.FechaDeEjecucion
				,LL.UsuarioIngresado
				,LL.TipoDeLogLoginId
				,LL.DispositivoId
				,@Historia AS Historia
				,COALESCE(CAST(DISP.UserMachineName AS VARCHAR(MAX)), '') AS Dispositivo
				,COALESCE(CAST(TDLL.Nombre AS VARCHAR(MAX)), '') AS TipoDeLogLogin
				,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS Usuario
			FROM LogLogins AS LL
				INNER JOIN Dispositivos DISP ON DISP.id = LL.DispositivoId
				INNER JOIN TiposDeLogLogins TDLL ON TDLL.id = LL.TipoDeLogLoginId
				INNER JOIN Usuarios U ON U.id = LL.UsuarioId
			WHERE LL.id = @id
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
-- SP-TABLA: LogLogins /Registro/ - FIN
 
 
 
 
-- SP-TABLA: LogLoginsDeDispositivos /Registro/ - INICIO
IF (OBJECT_ID('usp_LogLoginsDeDispositivos__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_LogLoginsDeDispositivos__Registro_by_@id
GO
CREATE PROCEDURE usp_LogLoginsDeDispositivos__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'LogLoginsDeDispositivos'
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
 
			SELECT LLDD.id
				,LLDD.DispositivoId
				,LLDD.UsuarioId
				,LLDD.Token
				,LLDD.FechaDeEjecucion
				,LLDD.InicioValides
				,LLDD.FinValidez
				,@Historia AS Historia
				,COALESCE(CAST(DISP.UserMachineName AS VARCHAR(MAX)), '') AS Dispositivo
				,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS Usuario
			FROM LogLoginsDeDispositivos AS LLDD
				INNER JOIN Dispositivos DISP ON DISP.id = LLDD.DispositivoId
				INNER JOIN Usuarios U ON U.id = LLDD.UsuarioId
			WHERE LLDD.id = @id
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
-- SP-TABLA: LogLoginsDeDispositivos /Registro/ - FIN
 
 
 
 
-- SP-TABLA: LogLoginsDeDispositivosRechazados /Registro/ - INICIO
IF (OBJECT_ID('usp_LogLoginsDeDispositivosRechazados__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_LogLoginsDeDispositivosRechazados__Registro_by_@id
GO
CREATE PROCEDURE usp_LogLoginsDeDispositivosRechazados__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'LogLoginsDeDispositivosRechazados'
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
 
			SELECT LLDDR.id
				,LLDDR.DispositivoId
				,LLDDR.UsuarioId
				,LLDDR.FechaDeEjecucion
				,LLDDR.JSON
				,LLDDR.UsuarioIngresado
				,LLDDR.MachineName
				,LLDDR.MotivoDeRechazo
				,@Historia AS Historia
				,COALESCE(CAST(DISP.UserMachineName AS VARCHAR(MAX)), '') AS Dispositivo
				,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS Usuario
			FROM LogLoginsDeDispositivosRechazados AS LLDDR
				INNER JOIN Dispositivos DISP ON DISP.id = LLDDR.DispositivoId
				INNER JOIN Usuarios U ON U.id = LLDDR.UsuarioId
			WHERE LLDDR.id = @id
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
-- SP-TABLA: LogLoginsDeDispositivosRechazados /Registro/ - FIN
 
 
 
 
-- SP-TABLA: LogRegistros /Registro/ - INICIO
IF (OBJECT_ID('usp_LogRegistros__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_LogRegistros__Registro_by_@id
GO
CREATE PROCEDURE usp_LogRegistros__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'LogRegistros'
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
 
			SELECT LR.id
				,LR.UsuarioQueEjecutaId
				,LR.FechaDeEjecucion
				,LR.TablaId
				,LR.RegistroId
				,LR.LogLoginDeDispositivoId
				,LR.TipoDeOperacionId
				,@Historia AS Historia
				,COALESCE(CAST(LLDD.FechaDeEjecucion AS VARCHAR(MAX)), '') AS LogLoginDeDispositivo
				,COALESCE(CAST(T.Nombre AS VARCHAR(MAX)), '') AS Tabla
				,COALESCE(CAST(TDO.Nombre AS VARCHAR(MAX)), '') AS TipoDeOperacion
				,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS UsuarioQueEjecuta
			FROM LogRegistros AS LR
				INNER JOIN LogLoginsDeDispositivos LLDD ON LLDD.id = LR.LogLoginDeDispositivoId
				INNER JOIN Tablas T ON T.id = LR.TablaId
				INNER JOIN TiposDeOperaciones TDO ON TDO.id = LR.TipoDeOperacionId
				INNER JOIN Usuarios U ON U.id = LR.UsuarioQueEjecutaId
			WHERE LR.id = @id
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
-- SP-TABLA: LogRegistros /Registro/ - FIN
 
 
 
 
-- SP-TABLA: Notas /Registro/ - INICIO
IF (OBJECT_ID('usp_Notas__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_Notas__Registro_by_@id
GO
CREATE PROCEDURE usp_Notas__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'Notas'
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
 
			SELECT NOTAS.id
				,NOTAS.ContextoId
				,NOTAS.UsuarioId
				,NOTAS.IconoCSSId
				,NOTAS.Fecha
				,NOTAS.FechaDeVencimiento
				,NOTAS.Titulo
				,NOTAS.Cuerpo
				,NOTAS.CompartirConTodos
				,@Historia AS Historia
				,COALESCE(CAST(CX.Nombre AS VARCHAR(MAX)), '') AS Contexto
				,COALESCE(CAST(ICSS.Nombre AS VARCHAR(MAX)), '') AS IconoCSS
				,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS Usuario
			FROM Notas AS NOTAS
				INNER JOIN Contextos CX ON CX.id = NOTAS.ContextoId
				INNER JOIN IconosCSS ICSS ON ICSS.id = NOTAS.IconoCSSId
				INNER JOIN Usuarios U ON U.id = NOTAS.UsuarioId
			WHERE NOTAS.id = @id
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
-- SP-TABLA: Notas /Registro/ - FIN
 
 
 
 
-- SP-TABLA: Paginas /Registro/ - INICIO
IF (OBJECT_ID('usp_Paginas__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_Paginas__Registro_by_@id
GO
CREATE PROCEDURE usp_Paginas__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'Paginas'
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
 
			SELECT P.id
				,P.SeccionId
				,P.TablaId
				,P.FuncionDePaginaId
				,P.Nombre
				,P.Titulo
				,P.Tips
				,P.Observaciones
				,P.SeMuestraEnAsignacionDePermisos
				,@Historia AS Historia
				,COALESCE(CAST(FDP.Nombre AS VARCHAR(MAX)), '') AS FuncionDePagina
				,COALESCE(CAST(Secc.Nombre AS VARCHAR(MAX)), '') AS Seccion
				,COALESCE(CAST(T.Nombre AS VARCHAR(MAX)), '') AS Tabla
			FROM Paginas AS P
				INNER JOIN FuncionesDePaginas FDP ON FDP.id = P.FuncionDePaginaId
				INNER JOIN Secciones Secc ON Secc.id = P.SeccionId
				INNER JOIN Tablas T ON T.id = P.TablaId
			WHERE P.id = @id
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
-- SP-TABLA: Paginas /Registro/ - FIN
 
 
 
 
-- SP-TABLA: ParametrosDelSistema /Registro/ - INICIO
IF (OBJECT_ID('usp_ParametrosDelSistema__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_ParametrosDelSistema__Registro_by_@id
GO
CREATE PROCEDURE usp_ParametrosDelSistema__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'ParametrosDelSistema'
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
 
			SELECT PDS.id
				,PDS.ContextoId
				,PDS.Contextohabilitadi
				,PDS.IntentosFallidosDeLoginPermitidos
				,PDS.IntervaloDeIntentosFallidoLogin
				,PDS.MinDeBloqueoTrasIntentosFallidoLogin
				,PDS.PermitidasLasModificaciones
				,PDS.PermitidasLasConsultas
				,PDS.PermitidasLasExportaciones
				,PDS.PermitidosLosEnviosDeCorreo
				,PDS.DiferenciaHorariaDelServidor
				,PDS.Observaciones
				,@Historia AS Historia
			FROM ParametrosDelSistema AS PDS
			WHERE PDS.id = @id
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
-- SP-TABLA: ParametrosDelSistema /Registro/ - FIN
 
 
 
 
-- SP-TABLA: PrioridadesDeSoportes /Registro/ - INICIO
IF (OBJECT_ID('usp_PrioridadesDeSoportes__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_PrioridadesDeSoportes__Registro_by_@id
GO
CREATE PROCEDURE usp_PrioridadesDeSoportes__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'PrioridadesDeSoportes'
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
 
			SELECT PDSop.id
				,PDSop.Nombre
				,PDSop.Orden
				,PDSop.Observaciones
				,PDSop.Activo
				,@Historia AS Historia
			FROM PrioridadesDeSoportes AS PDSop
			WHERE PDSop.id = @id
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
-- SP-TABLA: PrioridadesDeSoportes /Registro/ - FIN
 
 
 
 
-- SP-TABLA: RecorridosDeDispositivos /Registro/ - INICIO
IF (OBJECT_ID('usp_RecorridosDeDispositivos__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_RecorridosDeDispositivos__Registro_by_@id
GO
CREATE PROCEDURE usp_RecorridosDeDispositivos__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'RecorridosDeDispositivos'
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
 
			SELECT RDD.id
				,RDD.ContextoId
				,RDD.DispositivoId
				,RDD.UsuarioId
				,RDD.Token
				,RDD.FechaDeEjecucion
				,RDD.Latitud
				,RDD.Longitud
				,@Historia AS Historia
				,COALESCE(CAST(CX.Nombre AS VARCHAR(MAX)), '') AS Contexto
				,COALESCE(CAST(DISP.UserMachineName AS VARCHAR(MAX)), '') AS Dispositivo
				,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS Usuario
			FROM RecorridosDeDispositivos AS RDD
				INNER JOIN Contextos CX ON CX.id = RDD.ContextoId
				INNER JOIN Dispositivos DISP ON DISP.id = RDD.DispositivoId
				INNER JOIN Usuarios U ON U.id = RDD.UsuarioId
			WHERE RDD.id = @id
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
-- SP-TABLA: RecorridosDeDispositivos /Registro/ - FIN
 
 
 
 
-- SP-TABLA: RelAsig_Contactos_A_GruposDeContactos /Registro/ - INICIO
IF (OBJECT_ID('usp_RelAsig_Contactos_A_GruposDeContactos__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Contactos_A_GruposDeContactos__Registro_by_@id
GO
CREATE PROCEDURE usp_RelAsig_Contactos_A_GruposDeContactos__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Contactos_A_GruposDeContactos'
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
 
			SELECT ACAG.id
				,ACAG.ContactoId
				,ACAG.GrupoDeContactoId
				,@Historia AS Historia
				,COALESCE(CAST(CTOS.NombreCompleto AS VARCHAR(MAX)), '') AS Contacto
				,COALESCE(CAST(GDCTOS.Nombre AS VARCHAR(MAX)), '') AS GrupoDeContacto
			FROM RelAsig_Contactos_A_GruposDeContactos AS ACAG
				INNER JOIN Contactos CTOS ON CTOS.id = ACAG.ContactoId
				INNER JOIN GruposDeContactos GDCTOS ON GDCTOS.id = ACAG.GrupoDeContactoId
			WHERE ACAG.id = @id
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
-- SP-TABLA: RelAsig_Contactos_A_GruposDeContactos /Registro/ - FIN
 
 
 
 
-- SP-TABLA: RelAsig_Contactos_A_TiposDeContactos /Registro/ - INICIO
IF (OBJECT_ID('usp_RelAsig_Contactos_A_TiposDeContactos__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Contactos_A_TiposDeContactos__Registro_by_@id
GO
CREATE PROCEDURE usp_RelAsig_Contactos_A_TiposDeContactos__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Contactos_A_TiposDeContactos'
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
 
			SELECT ACAT.id
				,ACAT.ContactoId
				,ACAT.TipoDeContactoId
				,@Historia AS Historia
				,COALESCE(CAST(CTOS.NombreCompleto AS VARCHAR(MAX)), '') AS Contacto
				,COALESCE(CAST(TDC.Nombre AS VARCHAR(MAX)), '') AS TipoDeContacto
			FROM RelAsig_Contactos_A_TiposDeContactos AS ACAT
				INNER JOIN Contactos CTOS ON CTOS.id = ACAT.ContactoId
				INNER JOIN TiposDeContactos TDC ON TDC.id = ACAT.TipoDeContactoId
			WHERE ACAT.id = @id
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
-- SP-TABLA: RelAsig_Contactos_A_TiposDeContactos /Registro/ - FIN
 
 
 
 
-- SP-TABLA: RelAsig_CuentasDeEnvios_A_Tablas /Registro/ - INICIO
IF (OBJECT_ID('usp_RelAsig_CuentasDeEnvios_A_Tablas__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_RelAsig_CuentasDeEnvios_A_Tablas__Registro_by_@id
GO
CREATE PROCEDURE usp_RelAsig_CuentasDeEnvios_A_Tablas__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_CuentasDeEnvios_A_Tablas'
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
 
			SELECT RCAT.id
				,RCAT.ContextoId
				,RCAT.CuentaDeEnvioId
				,RCAT.TablaId
				,@Historia AS Historia
				,COALESCE(CAST(CX.Nombre AS VARCHAR(MAX)), '') AS Contexto
				,COALESCE(CAST(CDE.Nombre AS VARCHAR(MAX)), '') AS CuentaDeEnvio
				,COALESCE(CAST(T.Nombre AS VARCHAR(MAX)), '') AS Tabla
			FROM RelAsig_CuentasDeEnvios_A_Tablas AS RCAT
				INNER JOIN Contextos CX ON CX.id = RCAT.ContextoId
				INNER JOIN CuentasDeEnvios CDE ON CDE.id = RCAT.CuentaDeEnvioId
				INNER JOIN Tablas T ON T.id = RCAT.TablaId
			WHERE RCAT.id = @id
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
-- SP-TABLA: RelAsig_CuentasDeEnvios_A_Tablas /Registro/ - FIN
 
 
 
 
-- SP-TABLA: RelAsig_RolesDeUsuarios_A_Paginas /Registro/ - INICIO
IF (OBJECT_ID('usp_RelAsig_RolesDeUsuarios_A_Paginas__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Paginas__Registro_by_@id
GO
CREATE PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Paginas__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_RolesDeUsuarios_A_Paginas'
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
 
			SELECT RDUAP.id
				,RDUAP.RolDeUsuarioId
				,RDUAP.PaginaId
				,RDUAP.AutorizadoA_CargarLaPagina
				,RDUAP.AutorizadoA_OperarLaPagina
				,RDUAP.AutorizadoA_VerRegAnulados
				,RDUAP.AutorizadoA_AccionesEspeciales
				,@Historia AS Historia
				,COALESCE(CAST(P.Nombre AS VARCHAR(MAX)), '') AS Pagina
				,COALESCE(CAST(RDU.Nombre AS VARCHAR(MAX)), '') AS RolDeUsuario
			FROM RelAsig_RolesDeUsuarios_A_Paginas AS RDUAP
				INNER JOIN Paginas P ON P.id = RDUAP.PaginaId
				INNER JOIN RolesDeUsuarios RDU ON RDU.id = RDUAP.RolDeUsuarioId
			WHERE RDUAP.id = @id
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
-- SP-TABLA: RelAsig_RolesDeUsuarios_A_Paginas /Registro/ - FIN
 
 
 
 
-- SP-TABLA: RelAsig_RolesDeUsuarios_A_Usuarios /Registro/ - INICIO
IF (OBJECT_ID('usp_RelAsig_RolesDeUsuarios_A_Usuarios__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Usuarios__Registro_by_@id
GO
CREATE PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Usuarios__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_RolesDeUsuarios_A_Usuarios'
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
 
			SELECT RDUAU.id
				,RDUAU.RolDeUsuarioId
				,RDUAU.UsuarioId
				,RDUAU.FechaDesde
				,RDUAU.FechaHasta
				,@Historia AS Historia
				,COALESCE(CAST(RDU.Nombre AS VARCHAR(MAX)), '') AS RolDeUsuario
				,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS Usuario
			FROM RelAsig_RolesDeUsuarios_A_Usuarios AS RDUAU
				INNER JOIN RolesDeUsuarios RDU ON RDU.id = RDUAU.RolDeUsuarioId
				INNER JOIN Usuarios U ON U.id = RDUAU.UsuarioId
			WHERE RDUAU.id = @id
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
-- SP-TABLA: RelAsig_RolesDeUsuarios_A_Usuarios /Registro/ - FIN
 
 
 
 
-- SP-TABLA: RelAsig_Subsistemas_A_Publicaciones /Registro/ - INICIO
IF (OBJECT_ID('usp_RelAsig_Subsistemas_A_Publicaciones__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Subsistemas_A_Publicaciones__Registro_by_@id
GO
CREATE PROCEDURE usp_RelAsig_Subsistemas_A_Publicaciones__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Subsistemas_A_Publicaciones'
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
 
			SELECT ASAP.id
				,ASAP.SubsistemaId
				,ASAP.PublicacionId
				,ASAP.UsuarioId
				,ASAP.NumeroDeVersion
				,ASAP.SVN
				,ASAP.Ubicacion
				,ASAP.Observaciones
				,@Historia AS Historia
				,COALESCE(CAST(PUB.Fecha AS VARCHAR(MAX)), '') AS Publicacion
				,COALESCE(CAST(SUBS.Nombre AS VARCHAR(MAX)), '') AS Subsistema
				,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS Usuario
			FROM RelAsig_Subsistemas_A_Publicaciones AS ASAP
				INNER JOIN Publicaciones PUB ON PUB.id = ASAP.PublicacionId
				INNER JOIN Subsistemas SUBS ON SUBS.id = ASAP.SubsistemaId
				INNER JOIN Usuarios U ON U.id = ASAP.UsuarioId
			WHERE ASAP.id = @id
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
-- SP-TABLA: RelAsig_Subsistemas_A_Publicaciones /Registro/ - FIN
 
 
 
 
-- SP-TABLA: RelAsig_TiposDeContactos_A_Contextos /Registro/ - INICIO
IF (OBJECT_ID('usp_RelAsig_TiposDeContactos_A_Contextos__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_RelAsig_TiposDeContactos_A_Contextos__Registro_by_@id
GO
CREATE PROCEDURE usp_RelAsig_TiposDeContactos_A_Contextos__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_TiposDeContactos_A_Contextos'
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
 
			SELECT ATCAC.id
				,ATCAC.TipoDeContactoId
				,ATCAC.ContextoId
				,@Historia AS Historia
				,COALESCE(CAST(CX.Nombre AS VARCHAR(MAX)), '') AS Contexto
				,COALESCE(CAST(TDC.Nombre AS VARCHAR(MAX)), '') AS TipoDeContacto
			FROM RelAsig_TiposDeContactos_A_Contextos AS ATCAC
				INNER JOIN Contextos CX ON CX.id = ATCAC.ContextoId
				INNER JOIN TiposDeContactos TDC ON TDC.id = ATCAC.TipoDeContactoId
			WHERE ATCAC.id = @id
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
-- SP-TABLA: RelAsig_TiposDeContactos_A_Contextos /Registro/ - FIN
 
 
 
 
-- SP-TABLA: RelAsig_Usuarios_A_Recursos /Registro/ - INICIO
IF (OBJECT_ID('usp_RelAsig_Usuarios_A_Recursos__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Usuarios_A_Recursos__Registro_by_@id
GO
CREATE PROCEDURE usp_RelAsig_Usuarios_A_Recursos__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Usuarios_A_Recursos'
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
 
			SELECT AURAR.id
				,AURAR.UsuarioId
				,AURAR.RecursoId
				,@Historia AS Historia
				,COALESCE(CAST(RECU.Nombre AS VARCHAR(MAX)), '') AS Recurso
				,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS Usuario
			FROM RelAsig_Usuarios_A_Recursos AS AURAR
				INNER JOIN Recursos RECU ON RECU.id = AURAR.RecursoId
				INNER JOIN Usuarios U ON U.id = AURAR.UsuarioId
			WHERE AURAR.id = @id
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
-- SP-TABLA: RelAsig_Usuarios_A_Recursos /Registro/ - FIN
 
 
 
 
-- SP-TABLA: ReservasDeRecursos /Registro/ - INICIO
IF (OBJECT_ID('usp_ReservasDeRecursos__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_ReservasDeRecursos__Registro_by_@id
GO
CREATE PROCEDURE usp_ReservasDeRecursos__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'ReservasDeRecursos'
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
 
			SELECT RESDR.id
				,RESDR.ContextoId
				,RESDR.UsuarioOriginanteId
				,RESDR.UsuarioDestinatarioId
				,RESDR.RecursoId
				,RESDR.FechaDePedido
				,RESDR.FechaDeAprobacion
				,RESDR.ReservaAprobada
				,RESDR.FechaDeInicio
				,RESDR.FechaLimite
				,RESDR.Numero
				,RESDR.ObservacionesDelOriginante
				,RESDR.ObservacionesDelAprobador
				,@Historia AS Historia
				,COALESCE(CAST(CX.Nombre AS VARCHAR(MAX)), '') AS Contexto
				,COALESCE(CAST(RECU.Nombre AS VARCHAR(MAX)), '') AS Recurso
				,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS UsuarioOriginante
				,dbo.ufc_Usuarios__NombreCompletoFormateado(U4.id) AS UsuarioDestinatario
			FROM ReservasDeRecursos AS RESDR
				INNER JOIN Contextos CX ON CX.id = RESDR.ContextoId
				INNER JOIN Recursos RECU ON RECU.id = RESDR.RecursoId
				INNER JOIN Usuarios U ON U.id = RESDR.UsuarioOriginanteId
				INNER JOIN Usuarios U4 ON U4.id = RESDR.UsuarioDestinatarioId
			WHERE RESDR.id = @id
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
-- SP-TABLA: ReservasDeRecursos /Registro/ - FIN
 
 
 
 
-- SP-TABLA: RolesDeUsuarios /Registro/ - INICIO
IF (OBJECT_ID('usp_RolesDeUsuarios__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_RolesDeUsuarios__Registro_by_@id
GO
CREATE PROCEDURE usp_RolesDeUsuarios__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'RolesDeUsuarios'
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
 
			SELECT RDU.id
				,RDU.Nombre
				,RDU.Observaciones
				,RDU.Prioridad
				,RDU.SeMuestraEnAsignacionDePermisos
				,RDU.SeMuestraEnAsignacionDeRoles
				,RDU.Activo
				,RDU.NombreAMostrar
				,RDU.DeCore
				,@Historia AS Historia
			FROM RolesDeUsuarios AS RDU
			WHERE RDU.id = @id
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
-- SP-TABLA: RolesDeUsuarios /Registro/ - FIN
 
 
 
 
-- SP-TABLA: Secciones /Registro/ - INICIO
IF (OBJECT_ID('usp_Secciones__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_Secciones__Registro_by_@id
GO
CREATE PROCEDURE usp_Secciones__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'Secciones'
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
 
			SELECT Secc.id
				,Secc.Nombre
				,Secc.NombreAMostrar
				,Secc.Observaciones
				,@Historia AS Historia
			FROM Secciones AS Secc
			WHERE Secc.id = @id
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
-- SP-TABLA: Secciones /Registro/ - FIN
 
 
 
 
-- SP-TABLA: SPs /Registro/ - INICIO
IF (OBJECT_ID('usp_SPs__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_SPs__Registro_by_@id
GO
CREATE PROCEDURE usp_SPs__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'SPs'
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
 
			SELECT SPs.id
				,SPs.Nombre
				,SPs.SeDebenEvaluarPermisos
				,SPs.Observaciones
				,SPs.GeneracionDeEmailHabilitada
				,SPs.GeneracionDeNotificacionesHabilitada
				,@Historia AS Historia
			FROM SPs AS SPs
			WHERE SPs.id = @id
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
-- SP-TABLA: SPs /Registro/ - FIN
 
 
 
 
-- SP-TABLA: Subsistemas /Registro/ - INICIO
IF (OBJECT_ID('usp_Subsistemas__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_Subsistemas__Registro_by_@id
GO
CREATE PROCEDURE usp_Subsistemas__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'Subsistemas'
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
 
			SELECT SUBS.id
				,SUBS.Nombre
				,SUBS.Observaciones
				,SUBS.Activo
				,@Historia AS Historia
			FROM Subsistemas AS SUBS
			WHERE SUBS.id = @id
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
-- SP-TABLA: Subsistemas /Registro/ - FIN
 
 
 
 
-- SP-TABLA: Tablas /Registro/ - INICIO
IF (OBJECT_ID('usp_Tablas__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_Tablas__Registro_by_@id
GO
CREATE PROCEDURE usp_Tablas__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'Tablas'
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
 
			SELECT T.id
				,T.IconoCSSId
				,T.Nombre
				,T.NombreAMostrar
				,T.Nomenclatura
				,T.Observaciones
				,T.SeDebenEvaluarPermisos
				,T.PermiteEliminarSusRegistros
				,T.TablaDeCore
				,T.SeCreanPaginas
				,T.TieneArchivos
				,T.CampoAMostrarEnFK
				,T.CamposQuePuedenSerIdsString
				,T.CamposAExcluirEnElInsert
				,T.CamposAExcluirEnElUpdate
				,T.CamposAExcluirEnElListado
				,T.CamposAIncluirEnFiltrosDeListado
				,T.SeGeneranAutoSusSPsDeABM
				,T.SeGeneranAutoSusSPsDeRegistros
				,T.SeGeneranAutoSusSPsDeListados
				,@Historia AS Historia
				,COALESCE(CAST(ICSS.Nombre AS VARCHAR(MAX)), '') AS IconoCSS
			FROM Tablas AS T
				INNER JOIN IconosCSS ICSS ON ICSS.id = T.IconoCSSId
			WHERE T.id = @id
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
-- SP-TABLA: Tablas /Registro/ - FIN
 
 
 
 
-- SP-TABLA: TablasYFuncionesDePaginas /Registro/ - INICIO
IF (OBJECT_ID('usp_TablasYFuncionesDePaginas__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_TablasYFuncionesDePaginas__Registro_by_@id
GO
CREATE PROCEDURE usp_TablasYFuncionesDePaginas__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'TablasYFuncionesDePaginas'
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
 
			SELECT TyFDP.id
				,TyFDP.TablaId
				,TyFDP.FuncionDePaginaId
				,TyFDP.SeDebenEvaluarPermisos
				,TyFDP.Observaciones
				,@Historia AS Historia
				,COALESCE(CAST(FDP.Nombre AS VARCHAR(MAX)), '') AS FuncionDePagina
				,COALESCE(CAST(T.Nombre AS VARCHAR(MAX)), '') AS Tabla
			FROM TablasYFuncionesDePaginas AS TyFDP
				INNER JOIN FuncionesDePaginas FDP ON FDP.id = TyFDP.FuncionDePaginaId
				INNER JOIN Tablas T ON T.id = TyFDP.TablaId
			WHERE TyFDP.id = @id
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
-- SP-TABLA: TablasYFuncionesDePaginas /Registro/ - FIN
 
 
 
 
-- SP-TABLA: TiposDeActores /Registro/ - INICIO
IF (OBJECT_ID('usp_TiposDeActores__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_TiposDeActores__Registro_by_@id
GO
CREATE PROCEDURE usp_TiposDeActores__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'TiposDeActores'
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
 
			SELECT TDA.id
				,TDA.Nombre
				,TDA.Observaciones
				,@Historia AS Historia
			FROM TiposDeActores AS TDA
			WHERE TDA.id = @id
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
-- SP-TABLA: TiposDeActores /Registro/ - FIN
 
 
 
 
-- SP-TABLA: TiposDeArchivos /Registro/ - INICIO
IF (OBJECT_ID('usp_TiposDeArchivos__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_TiposDeArchivos__Registro_by_@id
GO
CREATE PROCEDURE usp_TiposDeArchivos__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'TiposDeArchivos'
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
 
			SELECT TDARCH.id
				,TDARCH.Nombre
				,TDARCH.Observaciones
				,@Historia AS Historia
			FROM TiposDeArchivos AS TDARCH
			WHERE TDARCH.id = @id
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
-- SP-TABLA: TiposDeArchivos /Registro/ - FIN
 
 
 
 
-- SP-TABLA: TiposDeContactos /Registro/ - INICIO
IF (OBJECT_ID('usp_TiposDeContactos__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_TiposDeContactos__Registro_by_@id
GO
CREATE PROCEDURE usp_TiposDeContactos__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'TiposDeContactos'
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
 
			SELECT TDC.id
				,TDC.Nombre
				,TDC.Observaciones
				,@Historia AS Historia
			FROM TiposDeContactos AS TDC
			WHERE TDC.id = @id
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
-- SP-TABLA: TiposDeContactos /Registro/ - FIN
 
 
 
 
-- SP-TABLA: TiposDeLogLogins /Registro/ - INICIO
IF (OBJECT_ID('usp_TiposDeLogLogins__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_TiposDeLogLogins__Registro_by_@id
GO
CREATE PROCEDURE usp_TiposDeLogLogins__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'TiposDeLogLogins'
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
 
			SELECT TDLL.id
				,TDLL.ConCookie
				,TDLL.Nombre
				,TDLL.MensajeDeError
				,TDLL.Observaciones
				,@Historia AS Historia
			FROM TiposDeLogLogins AS TDLL
			WHERE TDLL.id = @id
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
-- SP-TABLA: TiposDeLogLogins /Registro/ - FIN
 
 
 
 
-- SP-TABLA: TiposDeOperaciones /Registro/ - INICIO
IF (OBJECT_ID('usp_TiposDeOperaciones__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_TiposDeOperaciones__Registro_by_@id
GO
CREATE PROCEDURE usp_TiposDeOperaciones__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'TiposDeOperaciones'
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
 
			SELECT TDO.id
				,TDO.Nombre
				,TDO.Texto
				,TDO.Observaciones
				,@Historia AS Historia
			FROM TiposDeOperaciones AS TDO
			WHERE TDO.id = @id
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
-- SP-TABLA: TiposDeOperaciones /Registro/ - FIN
 
 
 
 
-- SP-TABLA: TiposDeTareas /Registro/ - INICIO
IF (OBJECT_ID('usp_TiposDeTareas__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_TiposDeTareas__Registro_by_@id
GO
CREATE PROCEDURE usp_TiposDeTareas__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'TiposDeTareas'
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
 
			SELECT TDT.id
				,TDT.ContextoId
				,TDT.Nombre
				,TDT.Observaciones
				,TDT.Activo
				,@Historia AS Historia
				,COALESCE(CAST(CX.Nombre AS VARCHAR(MAX)), '') AS Contexto
			FROM TiposDeTareas AS TDT
				INNER JOIN Contextos CX ON CX.id = TDT.ContextoId
			WHERE TDT.id = @id
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
-- SP-TABLA: TiposDeTareas /Registro/ - FIN
 
 
 
 
-- SP-TABLA: Ubicaciones /Registro/ - INICIO
IF (OBJECT_ID('usp_Ubicaciones__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_Ubicaciones__Registro_by_@id
GO
CREATE PROCEDURE usp_Ubicaciones__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'Ubicaciones'
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
 
			SELECT UB.id
				,UB.Nombre
				,UB.Observaciones
				,UB.UbicacionAbsoluta
				,@Historia AS Historia
			FROM Ubicaciones AS UB
			WHERE UB.id = @id
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
-- SP-TABLA: Ubicaciones /Registro/ - FIN
 
 
 
 
-- SP-TABLA: Unidades /Registro/ - INICIO
IF (OBJECT_ID('usp_Unidades__Registro_by_@id') IS NOT NULL) DROP PROCEDURE usp_Unidades__Registro_by_@id
GO
CREATE PROCEDURE usp_Unidades__Registro_by_@id
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
	DECLARE @Tabla VARCHAR(80) = 'Unidades'
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
 
			SELECT UD.id
				,UD.Codigo
				,UD.Nombre
				,UD.Observaciones
				,@Historia AS Historia
			FROM Unidades AS UD
			WHERE UD.id = @id
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
-- SP-TABLA: Unidades /Registro/ - FIN
 
 
 
 
-- ---------------------------
-- Script: DB_ParticularCore__C13a_Registros Generados Automaticamente - v10.8 - FIN
-- ==========================================================================================================
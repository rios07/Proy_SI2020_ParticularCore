﻿-- ==========================================================================================================
-- Descripción: SPs de ABMs generados automáticamente en función de los parámetros seteados en cada tabla.
-- Script: DB_ParticularCore__C11a_ABMs Generados Automaticamente - v10.7 - INICIO
-- ---------------------------
 
USE DB_ParticularCore
GO
 
		-- Tablas Involucradas: - INICIO
			-- Actores
			-- CategoriasDeInformes
			-- Contactos
			-- CuentasDeEnvios
			-- Dispositivos
			-- EnviosDeCorreos
			-- EstadosDeLogErrores
			-- EstadosDeSoportes
			-- EstadosDeTareas
			-- ExtensionesDeArchivos
			-- FuncionesDePaginas
			-- GruposDeContactos
			-- Iconos
			-- IconosCSS
			-- ImportanciasDeTareas
			-- LogEnviosDeCorreos
			-- LogErroresApp
			-- LogLogins
			-- LogLoginsDeDispositivos
			-- LogLoginsDeDispositivosRechazados
			-- Notas
			-- ParametrosDelSistema
			-- PrioridadesDeSoportes
			-- Publicaciones
			-- RecorridosDeDispositivos
			-- Recursos
			-- RelAsig_Contactos_A_GruposDeContactos
			-- RelAsig_Contactos_A_TiposDeContactos
			-- RelAsig_CuentasDeEnvios_A_Tablas
			-- RelAsig_Subsistemas_A_Publicaciones
			-- RelAsig_TiposDeContactos_A_Contextos
			-- RelAsig_Usuarios_A_Recursos
			-- Secciones
			-- SPs
			-- Subsistemas
			-- TablasYFuncionesDePaginas
			-- TiposDeActores
			-- TiposDeArchivos
			-- TiposDeContactos
			-- TiposDeLogLogins
			-- TiposDeOperaciones
			-- TiposDeTareas
			-- Unidades
		-- Tablas Involucradas: - FIN
 
 
-- SP-TABLA: Actores /ABMs/ - INICIO
IF (OBJECT_ID('usp_Actores__Insert') IS NOT NULL) DROP PROCEDURE usp_Actores__Insert
GO
CREATE PROCEDURE usp_Actores__Insert
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
 
	,@TipoDeActorId                                            INT
	,@Codigo                                                   VARCHAR(16)
	,@Nombre                                                   VARCHAR(50)
	,@Email                                                    VARCHAR(60) = NULL
	,@Email2                                                   VARCHAR(60) = NULL
	,@Telefono                                                 VARCHAR(60) = NULL
	,@Telefono2                                                VARCHAR(60) = NULL
	,@Direccion                                                VARCHAR(1000) = NULL
	,@Observaciones                                            VARCHAR(1000) = NULL
	,@Activo                                                   BIT = '1'
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Actores'
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
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SET NOCOUNT ON
			INSERT INTO Actores
			(
				ContextoId
				,TipoDeActorId
				,Codigo
				,Nombre
				,Email
				,Email2
				,Telefono
				,Telefono2
				,Direccion
				,Observaciones
				,Activo
			)
			VALUES
			(
				@ContextoId
				,@TipoDeActorId
				,@Codigo
				,@Nombre
				,@Email
				,@Email2
				,@Telefono
				,@Telefono2
				,@Direccion
				,@Observaciones
				,@Activo
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
 
 
 
 
IF (OBJECT_ID('usp_Actores__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_Actores__Update_by_@id
GO
CREATE PROCEDURE usp_Actores__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@TipoDeActorId                                            INT
	,@Codigo                                                   VARCHAR(16)
	,@Nombre                                                   VARCHAR(50)
	,@Email                                                    VARCHAR(60)
	,@Email2                                                   VARCHAR(60)
	,@Telefono                                                 VARCHAR(60)
	,@Telefono2                                                VARCHAR(60)
	,@Direccion                                                VARCHAR(1000)
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Actores'
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
			UPDATE Actores
			SET
				TipoDeActorId = @TipoDeActorId
				,Codigo = @Codigo
				,Nombre = @Nombre
				,Email = @Email
				,Email2 = @Email2
				,Telefono = @Telefono
				,Telefono2 = @Telefono2
				,Direccion = @Direccion
				,Observaciones = @Observaciones
			FROM Actores
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
-- SP-TABLA: Actores /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: CategoriasDeInformes /ABMs/ - INICIO
IF (OBJECT_ID('usp_CategoriasDeInformes__Insert') IS NOT NULL) DROP PROCEDURE usp_CategoriasDeInformes__Insert
GO
CREATE PROCEDURE usp_CategoriasDeInformes__Insert
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
 
	,@Nombre                                                   VARCHAR(50)
	,@Observaciones                                            VARCHAR(1000) = NULL
	,@Activo                                                   BIT = '1'
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'CategoriasDeInformes'
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
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SET NOCOUNT ON
			INSERT INTO CategoriasDeInformes
			(
				ContextoId
				,Nombre
				,Observaciones
				,Activo
			)
			VALUES
			(
				@ContextoId
				,@Nombre
				,@Observaciones
				,@Activo
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
 
 
 
 
IF (OBJECT_ID('usp_CategoriasDeInformes__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_CategoriasDeInformes__Update_by_@id
GO
CREATE PROCEDURE usp_CategoriasDeInformes__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@Nombre                                                   VARCHAR(50)
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'CategoriasDeInformes'
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
			UPDATE CategoriasDeInformes
			SET
				Nombre = @Nombre
				,Observaciones = @Observaciones
			FROM CategoriasDeInformes
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
-- SP-TABLA: CategoriasDeInformes /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: Contactos /ABMs/ - INICIO
IF (OBJECT_ID('usp_Contactos__Insert') IS NOT NULL) DROP PROCEDURE usp_Contactos__Insert
GO
CREATE PROCEDURE usp_Contactos__Insert
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
 
	,@EsUnaOrganizacion                                        BIT
	,@NombreCompleto                                           VARCHAR(150)
	,@Alias                                                    VARCHAR(50) = NULL
	,@Organizacion                                             VARCHAR(100) = NULL
	,@RelacionConElContacto                                    VARCHAR(50) = NULL
	,@Email                                                    VARCHAR(60) = NULL
	,@Email2                                                   VARCHAR(60) = NULL
	,@Telefono                                                 VARCHAR(60) = NULL
	,@Telefono2                                                VARCHAR(60) = NULL
	,@Direccion                                                VARCHAR(1000) = NULL
	,@Url                                                      VARCHAR(255) = NULL
	,@Observaciones                                            VARCHAR(1000) = NULL
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Contactos'
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
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SET NOCOUNT ON
			INSERT INTO Contactos
			(
				ContextoId
				,EsUnaOrganizacion
				,NombreCompleto
				,Alias
				,Organizacion
				,RelacionConElContacto
				,Email
				,Email2
				,Telefono
				,Telefono2
				,Direccion
				,Url
				,Observaciones
			)
			VALUES
			(
				@ContextoId
				,@EsUnaOrganizacion
				,@NombreCompleto
				,@Alias
				,@Organizacion
				,@RelacionConElContacto
				,@Email
				,@Email2
				,@Telefono
				,@Telefono2
				,@Direccion
				,@Url
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
 
 
 
 
IF (OBJECT_ID('usp_Contactos__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_Contactos__Update_by_@id
GO
CREATE PROCEDURE usp_Contactos__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@EsUnaOrganizacion                                        BIT
	,@NombreCompleto                                           VARCHAR(150)
	,@Alias                                                    VARCHAR(50)
	,@Organizacion                                             VARCHAR(100)
	,@RelacionConElContacto                                    VARCHAR(50)
	,@Email                                                    VARCHAR(60)
	,@Email2                                                   VARCHAR(60)
	,@Telefono                                                 VARCHAR(60)
	,@Telefono2                                                VARCHAR(60)
	,@Direccion                                                VARCHAR(1000)
	,@Url                                                      VARCHAR(255)
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Contactos'
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
			UPDATE Contactos
			SET
				EsUnaOrganizacion = @EsUnaOrganizacion
				,NombreCompleto = @NombreCompleto
				,Alias = @Alias
				,Organizacion = @Organizacion
				,RelacionConElContacto = @RelacionConElContacto
				,Email = @Email
				,Email2 = @Email2
				,Telefono = @Telefono
				,Telefono2 = @Telefono2
				,Direccion = @Direccion
				,Url = @Url
				,Observaciones = @Observaciones
			FROM Contactos
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
-- SP-TABLA: Contactos /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: CuentasDeEnvios /ABMs/ - INICIO
IF (OBJECT_ID('usp_CuentasDeEnvios__Insert') IS NOT NULL) DROP PROCEDURE usp_CuentasDeEnvios__Insert
GO
CREATE PROCEDURE usp_CuentasDeEnvios__Insert
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
 
	,@Nombre                                                   VARCHAR(40)
	,@CuentaDeEmail                                            VARCHAR(60)
	,@PwdDeEmail                                               VARCHAR(40)
	,@Smtp                                                     VARCHAR(60)
	,@Puerto                                                   INT
	,@Observaciones                                            VARCHAR(1000) = NULL
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'CuentasDeEnvios'
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
			INSERT INTO CuentasDeEnvios
			(
				Nombre
				,CuentaDeEmail
				,PwdDeEmail
				,Smtp
				,Puerto
				,Observaciones
			)
			VALUES
			(
				@Nombre
				,@CuentaDeEmail
				,@PwdDeEmail
				,@Smtp
				,@Puerto
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
 
 
 
 
IF (OBJECT_ID('usp_CuentasDeEnvios__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_CuentasDeEnvios__Update_by_@id
GO
CREATE PROCEDURE usp_CuentasDeEnvios__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@Nombre                                                   VARCHAR(40)
	,@CuentaDeEmail                                            VARCHAR(60)
	,@PwdDeEmail                                               VARCHAR(40)
	,@Smtp                                                     VARCHAR(60)
	,@Puerto                                                   INT
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'CuentasDeEnvios'
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
			UPDATE CuentasDeEnvios
			SET
				Nombre = @Nombre
				,CuentaDeEmail = @CuentaDeEmail
				,PwdDeEmail = @PwdDeEmail
				,Smtp = @Smtp
				,Puerto = @Puerto
				,Observaciones = @Observaciones
			FROM CuentasDeEnvios
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
-- SP-TABLA: CuentasDeEnvios /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: Dispositivos /ABMs/ - INICIO
IF (OBJECT_ID('usp_Dispositivos__Insert') IS NOT NULL) DROP PROCEDURE usp_Dispositivos__Insert
GO
CREATE PROCEDURE usp_Dispositivos__Insert
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
 
	,@AsignadoAUsuarioId                                       INT
	,@MachineName                                              VARCHAR(50)
	,@OSVersion                                                VARCHAR(100)
	,@UserMachineName                                          VARCHAR(50)
	,@ClavePrivada                                             VARCHAR(40) = ''''
	,@ClavePrivadaEntregada                                    BIT = '0'
	,@ClavePrivadaFechaEntrega                                 DATETIME = NULL
	,@Observaciones                                            VARCHAR(1000) = NULL
	,@Activo                                                   BIT = '1'
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Dispositivos'
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
			INSERT INTO Dispositivos
			(
				AsignadoAUsuarioId
				,MachineName
				,OSVersion
				,UserMachineName
				,ClavePrivada
				,ClavePrivadaEntregada
				,ClavePrivadaFechaEntrega
				,Observaciones
				,Activo
			)
			VALUES
			(
				@AsignadoAUsuarioId
				,@MachineName
				,@OSVersion
				,@UserMachineName
				,@ClavePrivada
				,@ClavePrivadaEntregada
				,@ClavePrivadaFechaEntrega
				,@Observaciones
				,@Activo
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
 
 
 
 
IF (OBJECT_ID('usp_Dispositivos__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_Dispositivos__Update_by_@id
GO
CREATE PROCEDURE usp_Dispositivos__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@AsignadoAUsuarioId                                       INT
	,@MachineName                                              VARCHAR(50)
	,@OSVersion                                                VARCHAR(100)
	,@UserMachineName                                          VARCHAR(50)
	,@ClavePrivada                                             VARCHAR(40)
	,@ClavePrivadaEntregada                                    BIT
	,@ClavePrivadaFechaEntrega                                 DATETIME
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Dispositivos'
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
			UPDATE Dispositivos
			SET
				AsignadoAUsuarioId = @AsignadoAUsuarioId
				,MachineName = @MachineName
				,OSVersion = @OSVersion
				,UserMachineName = @UserMachineName
				,ClavePrivada = @ClavePrivada
				,ClavePrivadaEntregada = @ClavePrivadaEntregada
				,ClavePrivadaFechaEntrega = @ClavePrivadaFechaEntrega
				,Observaciones = @Observaciones
			FROM Dispositivos
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
-- SP-TABLA: Dispositivos /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: EnviosDeCorreos /ABMs/ - INICIO
IF (OBJECT_ID('usp_EnviosDeCorreos__Insert') IS NOT NULL) DROP PROCEDURE usp_EnviosDeCorreos__Insert
GO
CREATE PROCEDURE usp_EnviosDeCorreos__Insert
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
 
	,@UsuarioOriginanteId                                      INT = '1'
	,@UsuarioDestinatarioId                                    INT = '1'
	,@TablaId                                                  INT = '1'
	,@RegistroId                                               INT = 'NULL'
	,@EmailDeDestino                                           VARCHAR(60)
	,@Asunto                                                   VARCHAR(200)
	,@Contenido                                                VARCHAR(MAX)
	,@FechaPactadaDeEnvio                                      DATETIME
	,@Activo                                                   BIT = '1'
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'EnviosDeCorreos'
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
			INSERT INTO EnviosDeCorreos
			(
				UsuarioOriginanteId
				,UsuarioDestinatarioId
				,TablaId
				,RegistroId
				,EmailDeDestino
				,Asunto
				,Contenido
				,FechaPactadaDeEnvio
				,Activo
			)
			VALUES
			(
				@UsuarioOriginanteId
				,@UsuarioDestinatarioId
				,@TablaId
				,@RegistroId
				,@EmailDeDestino
				,@Asunto
				,@Contenido
				,@FechaPactadaDeEnvio
				,@Activo
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
 
 
 
 
IF (OBJECT_ID('usp_EnviosDeCorreos__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_EnviosDeCorreos__Update_by_@id
GO
CREATE PROCEDURE usp_EnviosDeCorreos__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@UsuarioOriginanteId                                      INT
	,@UsuarioDestinatarioId                                    INT
	,@TablaId                                                  INT
	,@RegistroId                                               INT
	,@EmailDeDestino                                           VARCHAR(60)
	,@Asunto                                                   VARCHAR(200)
	,@Contenido                                                VARCHAR(MAX)
	,@FechaPactadaDeEnvio                                      DATETIME
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'EnviosDeCorreos'
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
			UPDATE EnviosDeCorreos
			SET
				UsuarioOriginanteId = @UsuarioOriginanteId
				,UsuarioDestinatarioId = @UsuarioDestinatarioId
				,TablaId = @TablaId
				,RegistroId = @RegistroId
				,EmailDeDestino = @EmailDeDestino
				,Asunto = @Asunto
				,Contenido = @Contenido
				,FechaPactadaDeEnvio = @FechaPactadaDeEnvio
			FROM EnviosDeCorreos
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
-- SP-TABLA: EnviosDeCorreos /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: EstadosDeLogErrores /ABMs/ - INICIO
IF (OBJECT_ID('usp_EstadosDeLogErrores__Insert') IS NOT NULL) DROP PROCEDURE usp_EstadosDeLogErrores__Insert
GO
CREATE PROCEDURE usp_EstadosDeLogErrores__Insert
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
 
	,@Nombre                                                   VARCHAR(30)
	,@Nomenclatura                                             VARCHAR(12)
	,@Orden                                                    INT
	,@Observaciones                                            VARCHAR(1000) = NULL
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'EstadosDeLogErrores'
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
			INSERT INTO EstadosDeLogErrores
			(
				Nombre
				,Nomenclatura
				,Orden
				,Observaciones
			)
			VALUES
			(
				@Nombre
				,@Nomenclatura
				,@Orden
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
 
 
 
 
IF (OBJECT_ID('usp_EstadosDeLogErrores__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_EstadosDeLogErrores__Update_by_@id
GO
CREATE PROCEDURE usp_EstadosDeLogErrores__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@Nombre                                                   VARCHAR(30)
	,@Nomenclatura                                             VARCHAR(12)
	,@Orden                                                    INT
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'EstadosDeLogErrores'
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
			UPDATE EstadosDeLogErrores
			SET
				Nombre = @Nombre
				,Nomenclatura = @Nomenclatura
				,Orden = @Orden
				,Observaciones = @Observaciones
			FROM EstadosDeLogErrores
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
-- SP-TABLA: EstadosDeLogErrores /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: EstadosDeSoportes /ABMs/ - INICIO
IF (OBJECT_ID('usp_EstadosDeSoportes__Insert') IS NOT NULL) DROP PROCEDURE usp_EstadosDeSoportes__Insert
GO
CREATE PROCEDURE usp_EstadosDeSoportes__Insert
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
 
	,@Nombre                                                   VARCHAR(30)
	,@Nomenclatura                                             VARCHAR(12)
	,@Orden                                                    INT
	,@Observaciones                                            VARCHAR(1000) = NULL
	,@CierraSoporte                                            BIT = '0'
	,@Activo                                                   BIT = '1'
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'EstadosDeSoportes'
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
			INSERT INTO EstadosDeSoportes
			(
				Nombre
				,Nomenclatura
				,Orden
				,Observaciones
				,CierraSoporte
				,Activo
			)
			VALUES
			(
				@Nombre
				,@Nomenclatura
				,@Orden
				,@Observaciones
				,@CierraSoporte
				,@Activo
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
 
 
 
 
IF (OBJECT_ID('usp_EstadosDeSoportes__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_EstadosDeSoportes__Update_by_@id
GO
CREATE PROCEDURE usp_EstadosDeSoportes__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@Nombre                                                   VARCHAR(30)
	,@Nomenclatura                                             VARCHAR(12)
	,@Orden                                                    INT
	,@Observaciones                                            VARCHAR(1000)
	,@CierraSoporte                                            BIT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'EstadosDeSoportes'
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
			UPDATE EstadosDeSoportes
			SET
				Nombre = @Nombre
				,Nomenclatura = @Nomenclatura
				,Orden = @Orden
				,Observaciones = @Observaciones
				,CierraSoporte = @CierraSoporte
			FROM EstadosDeSoportes
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
-- SP-TABLA: EstadosDeSoportes /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: EstadosDeTareas /ABMs/ - INICIO
IF (OBJECT_ID('usp_EstadosDeTareas__Insert') IS NOT NULL) DROP PROCEDURE usp_EstadosDeTareas__Insert
GO
CREATE PROCEDURE usp_EstadosDeTareas__Insert
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
 
	,@Nombre                                                   VARCHAR(30)
	,@Nomenclatura                                             VARCHAR(12)
	,@Orden                                                    INT
	,@Observaciones                                            VARCHAR(1000) = NULL
	,@Activo                                                   BIT = '1'
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'EstadosDeTareas'
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
			INSERT INTO EstadosDeTareas
			(
				Nombre
				,Nomenclatura
				,Orden
				,Observaciones
				,Activo
			)
			VALUES
			(
				@Nombre
				,@Nomenclatura
				,@Orden
				,@Observaciones
				,@Activo
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
 
 
 
 
IF (OBJECT_ID('usp_EstadosDeTareas__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_EstadosDeTareas__Update_by_@id
GO
CREATE PROCEDURE usp_EstadosDeTareas__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@Nombre                                                   VARCHAR(30)
	,@Nomenclatura                                             VARCHAR(12)
	,@Orden                                                    INT
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'EstadosDeTareas'
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
			UPDATE EstadosDeTareas
			SET
				Nombre = @Nombre
				,Nomenclatura = @Nomenclatura
				,Orden = @Orden
				,Observaciones = @Observaciones
			FROM EstadosDeTareas
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
-- SP-TABLA: EstadosDeTareas /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: ExtensionesDeArchivos /ABMs/ - INICIO
IF (OBJECT_ID('usp_ExtensionesDeArchivos__Insert') IS NOT NULL) DROP PROCEDURE usp_ExtensionesDeArchivos__Insert
GO
CREATE PROCEDURE usp_ExtensionesDeArchivos__Insert
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
 
	,@Nombre                                                   VARCHAR(8)
	,@IconoId                                                  INT
	,@TipoDeArchivoId                                          INT
	,@ProgramaAsociado                                         VARCHAR(40)
	,@Observaciones                                            VARCHAR(1000) = NULL
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'ExtensionesDeArchivos'
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
			INSERT INTO ExtensionesDeArchivos
			(
				Nombre
				,IconoId
				,TipoDeArchivoId
				,ProgramaAsociado
				,Observaciones
			)
			VALUES
			(
				@Nombre
				,@IconoId
				,@TipoDeArchivoId
				,@ProgramaAsociado
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
 
 
 
 
IF (OBJECT_ID('usp_ExtensionesDeArchivos__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_ExtensionesDeArchivos__Update_by_@id
GO
CREATE PROCEDURE usp_ExtensionesDeArchivos__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@Nombre                                                   VARCHAR(8)
	,@IconoId                                                  INT
	,@TipoDeArchivoId                                          INT
	,@ProgramaAsociado                                         VARCHAR(40)
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'ExtensionesDeArchivos'
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
			UPDATE ExtensionesDeArchivos
			SET
				Nombre = @Nombre
				,IconoId = @IconoId
				,TipoDeArchivoId = @TipoDeArchivoId
				,ProgramaAsociado = @ProgramaAsociado
				,Observaciones = @Observaciones
			FROM ExtensionesDeArchivos
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
-- SP-TABLA: ExtensionesDeArchivos /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: FuncionesDePaginas /ABMs/ - INICIO
IF (OBJECT_ID('usp_FuncionesDePaginas__Insert') IS NOT NULL) DROP PROCEDURE usp_FuncionesDePaginas__Insert
GO
CREATE PROCEDURE usp_FuncionesDePaginas__Insert
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
 
	,@Nombre                                                   VARCHAR(30)
	,@NombreAMostrar                                           VARCHAR(50)
	,@Observaciones                                            VARCHAR(1000) = NULL
	,@GeneraPagina                                             BIT = '0'
	,@SeDebenEvaluarPermisos                                   BIT = '1'
	,@EsUnaConRegistro                                         BIT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'FuncionesDePaginas'
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
			INSERT INTO FuncionesDePaginas
			(
				Nombre
				,NombreAMostrar
				,Observaciones
				,GeneraPagina
				,SeDebenEvaluarPermisos
				,EsUnaConRegistro
			)
			VALUES
			(
				@Nombre
				,@NombreAMostrar
				,@Observaciones
				,@GeneraPagina
				,@SeDebenEvaluarPermisos
				,@EsUnaConRegistro
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
 
 
 
 
IF (OBJECT_ID('usp_FuncionesDePaginas__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_FuncionesDePaginas__Update_by_@id
GO
CREATE PROCEDURE usp_FuncionesDePaginas__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@Nombre                                                   VARCHAR(30)
	,@NombreAMostrar                                           VARCHAR(50)
	,@Observaciones                                            VARCHAR(1000)
	,@GeneraPagina                                             BIT
	,@SeDebenEvaluarPermisos                                   BIT
	,@EsUnaConRegistro                                         BIT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'FuncionesDePaginas'
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
			UPDATE FuncionesDePaginas
			SET
				Nombre = @Nombre
				,NombreAMostrar = @NombreAMostrar
				,Observaciones = @Observaciones
				,GeneraPagina = @GeneraPagina
				,SeDebenEvaluarPermisos = @SeDebenEvaluarPermisos
				,EsUnaConRegistro = @EsUnaConRegistro
			FROM FuncionesDePaginas
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
-- SP-TABLA: FuncionesDePaginas /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: GruposDeContactos /ABMs/ - INICIO
IF (OBJECT_ID('usp_GruposDeContactos__Insert') IS NOT NULL) DROP PROCEDURE usp_GruposDeContactos__Insert
GO
CREATE PROCEDURE usp_GruposDeContactos__Insert
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
 
	,@Nombre                                                   VARCHAR(30)
	,@Observaciones                                            VARCHAR(1000) = NULL
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'GruposDeContactos'
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
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SET NOCOUNT ON
			INSERT INTO GruposDeContactos
			(
				ContextoId
				,Nombre
				,Observaciones
			)
			VALUES
			(
				@ContextoId
				,@Nombre
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
 
 
 
 
IF (OBJECT_ID('usp_GruposDeContactos__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_GruposDeContactos__Update_by_@id
GO
CREATE PROCEDURE usp_GruposDeContactos__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@Nombre                                                   VARCHAR(30)
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'GruposDeContactos'
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
			UPDATE GruposDeContactos
			SET
				Nombre = @Nombre
				,Observaciones = @Observaciones
			FROM GruposDeContactos
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
-- SP-TABLA: GruposDeContactos /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: Iconos /ABMs/ - INICIO
IF (OBJECT_ID('usp_Iconos__Insert') IS NOT NULL) DROP PROCEDURE usp_Iconos__Insert
GO
CREATE PROCEDURE usp_Iconos__Insert
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
 
	,@Nombre                                                   VARCHAR(50)
	,@Imagen                                                   VARCHAR(50)
	,@Altura                                                   INT
	,@Ancho                                                    INT
	,@OffsetX                                                  INT = '0'
	,@OffsetY                                                  INT = '0'
	,@Observaciones                                            VARCHAR(1000) = NULL
	,@Activo                                                   BIT = '1'
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Iconos'
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
			INSERT INTO Iconos
			(
				Nombre
				,Imagen
				,Altura
				,Ancho
				,OffsetX
				,OffsetY
				,Observaciones
				,Activo
			)
			VALUES
			(
				@Nombre
				,@Imagen
				,@Altura
				,@Ancho
				,@OffsetX
				,@OffsetY
				,@Observaciones
				,@Activo
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
 
 
 
 
IF (OBJECT_ID('usp_Iconos__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_Iconos__Update_by_@id
GO
CREATE PROCEDURE usp_Iconos__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@Nombre                                                   VARCHAR(50)
	,@Imagen                                                   VARCHAR(50)
	,@Altura                                                   INT
	,@Ancho                                                    INT
	,@OffsetX                                                  INT
	,@OffsetY                                                  INT
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Iconos'
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
			UPDATE Iconos
			SET
				Nombre = @Nombre
				,Imagen = @Imagen
				,Altura = @Altura
				,Ancho = @Ancho
				,OffsetX = @OffsetX
				,OffsetY = @OffsetY
				,Observaciones = @Observaciones
			FROM Iconos
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
-- SP-TABLA: Iconos /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: IconosCSS /ABMs/ - INICIO
IF (OBJECT_ID('usp_IconosCSS__Insert') IS NOT NULL) DROP PROCEDURE usp_IconosCSS__Insert
GO
CREATE PROCEDURE usp_IconosCSS__Insert
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
 
	,@Nombre                                                   VARCHAR(50)
	,@CSS                                                      VARCHAR(100)
	,@Observaciones                                            VARCHAR(1000) = NULL
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'IconosCSS'
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
			INSERT INTO IconosCSS
			(
				Nombre
				,CSS
				,Observaciones
			)
			VALUES
			(
				@Nombre
				,@CSS
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
 
 
 
 
IF (OBJECT_ID('usp_IconosCSS__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_IconosCSS__Update_by_@id
GO
CREATE PROCEDURE usp_IconosCSS__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@Nombre                                                   VARCHAR(50)
	,@CSS                                                      VARCHAR(100)
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'IconosCSS'
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
			UPDATE IconosCSS
			SET
				Nombre = @Nombre
				,CSS = @CSS
				,Observaciones = @Observaciones
			FROM IconosCSS
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
-- SP-TABLA: IconosCSS /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: ImportanciasDeTareas /ABMs/ - INICIO
IF (OBJECT_ID('usp_ImportanciasDeTareas__Insert') IS NOT NULL) DROP PROCEDURE usp_ImportanciasDeTareas__Insert
GO
CREATE PROCEDURE usp_ImportanciasDeTareas__Insert
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
 
	,@Nombre                                                   VARCHAR(30)
	,@Nomenclatura                                             VARCHAR(12)
	,@Orden                                                    INT
	,@Observaciones                                            VARCHAR(1000) = NULL
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'ImportanciasDeTareas'
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
			INSERT INTO ImportanciasDeTareas
			(
				Nombre
				,Nomenclatura
				,Orden
				,Observaciones
			)
			VALUES
			(
				@Nombre
				,@Nomenclatura
				,@Orden
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
 
 
 
 
IF (OBJECT_ID('usp_ImportanciasDeTareas__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_ImportanciasDeTareas__Update_by_@id
GO
CREATE PROCEDURE usp_ImportanciasDeTareas__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@Nombre                                                   VARCHAR(30)
	,@Nomenclatura                                             VARCHAR(12)
	,@Orden                                                    INT
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'ImportanciasDeTareas'
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
			UPDATE ImportanciasDeTareas
			SET
				Nombre = @Nombre
				,Nomenclatura = @Nomenclatura
				,Orden = @Orden
				,Observaciones = @Observaciones
			FROM ImportanciasDeTareas
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
-- SP-TABLA: ImportanciasDeTareas /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: LogEnviosDeCorreos /ABMs/ - INICIO
IF (OBJECT_ID('usp_LogEnviosDeCorreos__Insert') IS NOT NULL) DROP PROCEDURE usp_LogEnviosDeCorreos__Insert
GO
CREATE PROCEDURE usp_LogEnviosDeCorreos__Insert
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
 
	,@EnvioDeCorreoId                                          INT
	,@Satisfactorio                                            BIT
	,@Fecha                                                    DATETIME
	,@Observaciones                                            VARCHAR(1000) = NULL
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogEnviosDeCorreos'
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
			INSERT INTO LogEnviosDeCorreos
			(
				EnvioDeCorreoId
				,Satisfactorio
				,Fecha
				,Observaciones
			)
			VALUES
			(
				@EnvioDeCorreoId
				,@Satisfactorio
				,@Fecha
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
 
 
 
 
IF (OBJECT_ID('usp_LogEnviosDeCorreos__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_LogEnviosDeCorreos__Update_by_@id
GO
CREATE PROCEDURE usp_LogEnviosDeCorreos__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@ObservacionesDeRevision                                  VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogEnviosDeCorreos'
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
			UPDATE LogEnviosDeCorreos
			SET
				ObservacionesDeRevision = @ObservacionesDeRevision
			FROM LogEnviosDeCorreos
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
-- SP-TABLA: LogEnviosDeCorreos /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: LogErroresApp /ABMs/ - INICIO
IF (OBJECT_ID('usp_LogErroresApp__Insert') IS NOT NULL) DROP PROCEDURE usp_LogErroresApp__Insert
GO
CREATE PROCEDURE usp_LogErroresApp__Insert
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
 
	,@TokenId                                                  VARCHAR(40) = NULL
	,@DispositivoMachineName                                   VARCHAR(50) = NULL
	,@UsuarioId                                                INT = '-2' -- Agrego un valor por default = '-2' y más adelante, si es = '-2' --> le asigno el @UsuarioQueEjecutaId
	,@Metodo                                                   VARCHAR(255)
	,@Clase                                                    VARCHAR(255)
	,@Linea                                                    INT
	,@Texto                                                    VARCHAR(255)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogErroresApp'
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
			SET NOCOUNT ON
			INSERT INTO LogErroresApp
			(
				FechaDeEjecucion
				,TokenId
				,DispositivoMachineName
				,UsuarioId
				,Metodo
				,Clase
				,Linea
				,Texto
			)
			VALUES
			(
				@FechaDeEjecucion
				,@TokenId
				,@DispositivoMachineName
				,@UsuarioId
				,@Metodo
				,@Clase
				,@Linea
				,@Texto
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
 
 
 
 
IF (OBJECT_ID('usp_LogErroresApp__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_LogErroresApp__Update_by_@id
GO
CREATE PROCEDURE usp_LogErroresApp__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@TokenId                                                  VARCHAR(40)
	,@DispositivoMachineName                                   VARCHAR(50)
	,@UsuarioId                                                INT
	,@Metodo                                                   VARCHAR(255)
	,@Clase                                                    VARCHAR(255)
	,@Linea                                                    INT
	,@Texto                                                    VARCHAR(255)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogErroresApp'
		,@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				, @RegistroId = @id
				, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			UPDATE LogErroresApp
			SET
				FechaDeEjecucion = @FechaDeEjecucion
				,TokenId = @TokenId
				,DispositivoMachineName = @DispositivoMachineName
				,UsuarioId = @UsuarioId
				,Metodo = @Metodo
				,Clase = @Clase
				,Linea = @Linea
				,Texto = @Texto
			FROM LogErroresApp
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
-- SP-TABLA: LogErroresApp /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: LogLogins /ABMs/ - INICIO
IF (OBJECT_ID('usp_LogLogins__Insert') IS NOT NULL) DROP PROCEDURE usp_LogLogins__Insert
GO
CREATE PROCEDURE usp_LogLogins__Insert
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
 
	,@UsuarioId                                                INT = '-2' -- Agrego un valor por default = '-2' y más adelante, si es = '-2' --> le asigno el @UsuarioQueEjecutaId
	,@UsuarioIngresado                                         VARCHAR(81)
	,@TipoDeLogLoginId                                         INT
	,@DispositivoId                                            INT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogLogins'
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
			SET NOCOUNT ON
			INSERT INTO LogLogins
			(
				UsuarioId
				,FechaDeEjecucion
				,UsuarioIngresado
				,TipoDeLogLoginId
				,DispositivoId
			)
			VALUES
			(
				@UsuarioId
				,@FechaDeEjecucion
				,@UsuarioIngresado
				,@TipoDeLogLoginId
				,@DispositivoId
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
 
 
 
 
IF (OBJECT_ID('usp_LogLogins__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_LogLogins__Update_by_@id
GO
CREATE PROCEDURE usp_LogLogins__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@UsuarioId                                                INT
	,@UsuarioIngresado                                         VARCHAR(81)
	,@TipoDeLogLoginId                                         INT
	,@DispositivoId                                            INT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogLogins'
		,@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				, @RegistroId = @id
				, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			UPDATE LogLogins
			SET
				UsuarioId = @UsuarioId
				,FechaDeEjecucion = @FechaDeEjecucion
				,UsuarioIngresado = @UsuarioIngresado
				,TipoDeLogLoginId = @TipoDeLogLoginId
				,DispositivoId = @DispositivoId
			FROM LogLogins
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
-- SP-TABLA: LogLogins /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: LogLoginsDeDispositivos /ABMs/ - INICIO
IF (OBJECT_ID('usp_LogLoginsDeDispositivos__Insert') IS NOT NULL) DROP PROCEDURE usp_LogLoginsDeDispositivos__Insert
GO
CREATE PROCEDURE usp_LogLoginsDeDispositivos__Insert
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
 
	,@DispositivoId                                            INT
	,@UsuarioId                                                INT = '-2' -- Agrego un valor por default = '-2' y más adelante, si es = '-2' --> le asigno el @UsuarioQueEjecutaId
	,@InicioValides                                            DATETIME
	,@FinValidez                                               DATETIME
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogLoginsDeDispositivos'
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
			SET NOCOUNT ON
			INSERT INTO LogLoginsDeDispositivos
			(
				DispositivoId
				,UsuarioId
				,Token
				,FechaDeEjecucion
				,InicioValides
				,FinValidez
			)
			VALUES
			(
				@DispositivoId
				,@UsuarioId
				,@Token
				,@FechaDeEjecucion
				,@InicioValides
				,@FinValidez
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
 
 
 
 
IF (OBJECT_ID('usp_LogLoginsDeDispositivos__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_LogLoginsDeDispositivos__Update_by_@id
GO
CREATE PROCEDURE usp_LogLoginsDeDispositivos__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@DispositivoId                                            INT
	,@UsuarioId                                                INT
	,@InicioValides                                            DATETIME
	,@FinValidez                                               DATETIME
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogLoginsDeDispositivos'
		,@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				, @RegistroId = @id
				, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			UPDATE LogLoginsDeDispositivos
			SET
				DispositivoId = @DispositivoId
				,UsuarioId = @UsuarioId
				,Token = @Token
				,FechaDeEjecucion = @FechaDeEjecucion
				,InicioValides = @InicioValides
				,FinValidez = @FinValidez
			FROM LogLoginsDeDispositivos
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
-- SP-TABLA: LogLoginsDeDispositivos /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: LogLoginsDeDispositivosRechazados /ABMs/ - INICIO
IF (OBJECT_ID('usp_LogLoginsDeDispositivosRechazados__Insert') IS NOT NULL) DROP PROCEDURE usp_LogLoginsDeDispositivosRechazados__Insert
GO
CREATE PROCEDURE usp_LogLoginsDeDispositivosRechazados__Insert
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
 
	,@DispositivoId                                            INT
	,@UsuarioId                                                INT = '-2' -- Agrego un valor por default = '-2' y más adelante, si es = '-2' --> le asigno el @UsuarioQueEjecutaId
	,@JSON                                                     VARCHAR(5000)
	,@UsuarioIngresado                                         VARCHAR(81)
	,@MachineName                                              VARCHAR(50)
	,@MotivoDeRechazo                                          VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogLoginsDeDispositivosRechazados'
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
			SET NOCOUNT ON
			INSERT INTO LogLoginsDeDispositivosRechazados
			(
				DispositivoId
				,UsuarioId
				,FechaDeEjecucion
				,JSON
				,UsuarioIngresado
				,MachineName
				,MotivoDeRechazo
			)
			VALUES
			(
				@DispositivoId
				,@UsuarioId
				,@FechaDeEjecucion
				,@JSON
				,@UsuarioIngresado
				,@MachineName
				,@MotivoDeRechazo
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
 
 
 
 
IF (OBJECT_ID('usp_LogLoginsDeDispositivosRechazados__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_LogLoginsDeDispositivosRechazados__Update_by_@id
GO
CREATE PROCEDURE usp_LogLoginsDeDispositivosRechazados__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@DispositivoId                                            INT
	,@UsuarioId                                                INT
	,@JSON                                                     VARCHAR(5000)
	,@UsuarioIngresado                                         VARCHAR(81)
	,@MachineName                                              VARCHAR(50)
	,@MotivoDeRechazo                                          VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogLoginsDeDispositivosRechazados'
		,@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				, @RegistroId = @id
				, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			UPDATE LogLoginsDeDispositivosRechazados
			SET
				DispositivoId = @DispositivoId
				,UsuarioId = @UsuarioId
				,FechaDeEjecucion = @FechaDeEjecucion
				,JSON = @JSON
				,UsuarioIngresado = @UsuarioIngresado
				,MachineName = @MachineName
				,MotivoDeRechazo = @MotivoDeRechazo
			FROM LogLoginsDeDispositivosRechazados
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
-- SP-TABLA: LogLoginsDeDispositivosRechazados /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: Notas /ABMs/ - INICIO
IF (OBJECT_ID('usp_Notas__Insert') IS NOT NULL) DROP PROCEDURE usp_Notas__Insert
GO
CREATE PROCEDURE usp_Notas__Insert
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
 
	,@UsuarioId                                                INT = '-2' -- Agrego un valor por default = '-2' y más adelante, si es = '-2' --> le asigno el @UsuarioQueEjecutaId
	,@IconoCSSId                                               INT
	,@Fecha                                                    DATETIME
	,@FechaDeVencimiento                                       DATETIME = NULL
	,@Titulo                                                   VARCHAR(100)
	,@Cuerpo                                                   VARCHAR(MAX)
	,@CompartirConTodos                                        BIT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Notas'
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
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SET NOCOUNT ON
			INSERT INTO Notas
			(
				ContextoId
				,UsuarioId
				,IconoCSSId
				,Fecha
				,FechaDeVencimiento
				,Titulo
				,Cuerpo
				,CompartirConTodos
			)
			VALUES
			(
				@ContextoId
				,@UsuarioId
				,@IconoCSSId
				,@Fecha
				,@FechaDeVencimiento
				,@Titulo
				,@Cuerpo
				,@CompartirConTodos
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
 
 
 
 
IF (OBJECT_ID('usp_Notas__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_Notas__Update_by_@id
GO
CREATE PROCEDURE usp_Notas__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@UsuarioId                                                INT
	,@IconoCSSId                                               INT
	,@Fecha                                                    DATETIME
	,@FechaDeVencimiento                                       DATETIME
	,@Titulo                                                   VARCHAR(100)
	,@Cuerpo                                                   VARCHAR(MAX)
	,@CompartirConTodos                                        BIT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Notas'
		,@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				, @RegistroId = @id
				, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			UPDATE Notas
			SET
				UsuarioId = @UsuarioId
				,IconoCSSId = @IconoCSSId
				,Fecha = @Fecha
				,FechaDeVencimiento = @FechaDeVencimiento
				,Titulo = @Titulo
				,Cuerpo = @Cuerpo
				,CompartirConTodos = @CompartirConTodos
			FROM Notas
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
-- SP-TABLA: Notas /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: ParametrosDelSistema /ABMs/ - INICIO
IF (OBJECT_ID('usp_ParametrosDelSistema__Insert') IS NOT NULL) DROP PROCEDURE usp_ParametrosDelSistema__Insert
GO
CREATE PROCEDURE usp_ParametrosDelSistema__Insert
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
 
	,@Contextohabilitadi                                       BIT = '1'
	,@IntentosFallidosDeLoginPermitidos                        INT = NULL
	,@IntervaloDeIntentosFallidoLogin                          INT = NULL
	,@MinDeBloqueoTrasIntentosFallidoLogin                     INT = NULL
	,@PermitidasLasModificaciones                              INT = NULL
	,@PermitidasLasConsultas                                   INT = NULL
	,@PermitidasLasExportaciones                               INT = NULL
	,@PermitidosLosEnviosDeCorreo                              INT = NULL
	,@DiferenciaHorariaDelServidor                             INT = NULL
	,@Observaciones                                            VARCHAR(1000) = NULL
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'ParametrosDelSistema'
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
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SET NOCOUNT ON
			INSERT INTO ParametrosDelSistema
			(
				ContextoId
				,Contextohabilitadi
				,IntentosFallidosDeLoginPermitidos
				,IntervaloDeIntentosFallidoLogin
				,MinDeBloqueoTrasIntentosFallidoLogin
				,PermitidasLasModificaciones
				,PermitidasLasConsultas
				,PermitidasLasExportaciones
				,PermitidosLosEnviosDeCorreo
				,DiferenciaHorariaDelServidor
				,Observaciones
			)
			VALUES
			(
				@ContextoId
				,@Contextohabilitadi
				,@IntentosFallidosDeLoginPermitidos
				,@IntervaloDeIntentosFallidoLogin
				,@MinDeBloqueoTrasIntentosFallidoLogin
				,@PermitidasLasModificaciones
				,@PermitidasLasConsultas
				,@PermitidasLasExportaciones
				,@PermitidosLosEnviosDeCorreo
				,@DiferenciaHorariaDelServidor
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
 
 
 
 
IF (OBJECT_ID('usp_ParametrosDelSistema__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_ParametrosDelSistema__Update_by_@id
GO
CREATE PROCEDURE usp_ParametrosDelSistema__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@Contextohabilitadi                                       BIT
	,@IntentosFallidosDeLoginPermitidos                        INT
	,@IntervaloDeIntentosFallidoLogin                          INT
	,@MinDeBloqueoTrasIntentosFallidoLogin                     INT
	,@PermitidasLasModificaciones                              INT
	,@PermitidasLasConsultas                                   INT
	,@PermitidasLasExportaciones                               INT
	,@PermitidosLosEnviosDeCorreo                              INT
	,@DiferenciaHorariaDelServidor                             INT
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'ParametrosDelSistema'
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
			UPDATE ParametrosDelSistema
			SET
				Contextohabilitadi = @Contextohabilitadi
				,IntentosFallidosDeLoginPermitidos = @IntentosFallidosDeLoginPermitidos
				,IntervaloDeIntentosFallidoLogin = @IntervaloDeIntentosFallidoLogin
				,MinDeBloqueoTrasIntentosFallidoLogin = @MinDeBloqueoTrasIntentosFallidoLogin
				,PermitidasLasModificaciones = @PermitidasLasModificaciones
				,PermitidasLasConsultas = @PermitidasLasConsultas
				,PermitidasLasExportaciones = @PermitidasLasExportaciones
				,PermitidosLosEnviosDeCorreo = @PermitidosLosEnviosDeCorreo
				,DiferenciaHorariaDelServidor = @DiferenciaHorariaDelServidor
				,Observaciones = @Observaciones
			FROM ParametrosDelSistema
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
-- SP-TABLA: ParametrosDelSistema /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: PrioridadesDeSoportes /ABMs/ - INICIO
IF (OBJECT_ID('usp_PrioridadesDeSoportes__Insert') IS NOT NULL) DROP PROCEDURE usp_PrioridadesDeSoportes__Insert
GO
CREATE PROCEDURE usp_PrioridadesDeSoportes__Insert
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
 
	,@Nombre                                                   VARCHAR(12)
	,@Orden                                                    INT
	,@Observaciones                                            VARCHAR(1000) = NULL
	,@Activo                                                   BIT = '1'
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'PrioridadesDeSoportes'
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
			INSERT INTO PrioridadesDeSoportes
			(
				Nombre
				,Orden
				,Observaciones
				,Activo
			)
			VALUES
			(
				@Nombre
				,@Orden
				,@Observaciones
				,@Activo
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
 
 
 
 
IF (OBJECT_ID('usp_PrioridadesDeSoportes__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_PrioridadesDeSoportes__Update_by_@id
GO
CREATE PROCEDURE usp_PrioridadesDeSoportes__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@Nombre                                                   VARCHAR(12)
	,@Orden                                                    INT
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'PrioridadesDeSoportes'
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
			UPDATE PrioridadesDeSoportes
			SET
				Nombre = @Nombre
				,Orden = @Orden
				,Observaciones = @Observaciones
			FROM PrioridadesDeSoportes
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
-- SP-TABLA: PrioridadesDeSoportes /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: Publicaciones /ABMs/ - INICIO
IF (OBJECT_ID('usp_Publicaciones__Insert') IS NOT NULL) DROP PROCEDURE usp_Publicaciones__Insert
GO
CREATE PROCEDURE usp_Publicaciones__Insert
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
 
	,@Fecha                                                    DATE
	,@Titulo                                                   VARCHAR(40)
	,@NumeroDeVersion                                          VARCHAR(30) = NULL
	,@Realizada                                                BIT
	,@Observaciones                                            VARCHAR(8000) = NULL
	,@Hora                                                     TIME
	,@Activo                                                   BIT = '1'
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Publicaciones'
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
			INSERT INTO Publicaciones
			(
				Fecha
				,Titulo
				,NumeroDeVersion
				,Realizada
				,Observaciones
				,Hora
				,Activo
			)
			VALUES
			(
				@Fecha
				,@Titulo
				,@NumeroDeVersion
				,@Realizada
				,@Observaciones
				,@Hora
				,@Activo
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
 
 
 
 
IF (OBJECT_ID('usp_Publicaciones__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_Publicaciones__Update_by_@id
GO
CREATE PROCEDURE usp_Publicaciones__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@Fecha                                                    DATE
	,@Titulo                                                   VARCHAR(40)
	,@NumeroDeVersion                                          VARCHAR(30)
	,@Realizada                                                BIT
	,@Observaciones                                            VARCHAR(8000)
	,@Hora                                                     TIME
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Publicaciones'
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
			UPDATE Publicaciones
			SET
				Fecha = @Fecha
				,Titulo = @Titulo
				,NumeroDeVersion = @NumeroDeVersion
				,Realizada = @Realizada
				,Observaciones = @Observaciones
				,Hora = @Hora
			FROM Publicaciones
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
-- SP-TABLA: Publicaciones /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: RecorridosDeDispositivos /ABMs/ - INICIO
IF (OBJECT_ID('usp_RecorridosDeDispositivos__Insert') IS NOT NULL) DROP PROCEDURE usp_RecorridosDeDispositivos__Insert
GO
CREATE PROCEDURE usp_RecorridosDeDispositivos__Insert
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
 
	,@DispositivoId                                            INT
	,@UsuarioId                                                INT = '-2' -- Agrego un valor por default = '-2' y más adelante, si es = '-2' --> le asigno el @UsuarioQueEjecutaId
	,@Latitud                                                  VARCHAR(19)
	,@Longitud                                                 VARCHAR(19)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RecorridosDeDispositivos'
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
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SET NOCOUNT ON
			INSERT INTO RecorridosDeDispositivos
			(
				ContextoId
				,DispositivoId
				,UsuarioId
				,Token
				,FechaDeEjecucion
				,Latitud
				,Longitud
			)
			VALUES
			(
				@ContextoId
				,@DispositivoId
				,@UsuarioId
				,@Token
				,@FechaDeEjecucion
				,@Latitud
				,@Longitud
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
 
 
 
 
IF (OBJECT_ID('usp_RecorridosDeDispositivos__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_RecorridosDeDispositivos__Update_by_@id
GO
CREATE PROCEDURE usp_RecorridosDeDispositivos__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@DispositivoId                                            INT
	,@UsuarioId                                                INT
	,@Latitud                                                  VARCHAR(19)
	,@Longitud                                                 VARCHAR(19)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RecorridosDeDispositivos'
		,@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				, @RegistroId = @id
				, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			UPDATE RecorridosDeDispositivos
			SET
				DispositivoId = @DispositivoId
				,UsuarioId = @UsuarioId
				,Token = @Token
				,FechaDeEjecucion = @FechaDeEjecucion
				,Latitud = @Latitud
				,Longitud = @Longitud
			FROM RecorridosDeDispositivos
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
-- SP-TABLA: RecorridosDeDispositivos /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: Recursos /ABMs/ - INICIO
IF (OBJECT_ID('usp_Recursos__Insert') IS NOT NULL) DROP PROCEDURE usp_Recursos__Insert
GO
CREATE PROCEDURE usp_Recursos__Insert
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
 
	,@Nombre                                                   VARCHAR(100)
	,@Observaciones                                            VARCHAR(1000) = NULL
	,@Activo                                                   BIT = '1'
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Recursos'
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
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SET NOCOUNT ON
			INSERT INTO Recursos
			(
				ContextoId
				,Nombre
				,Observaciones
				,Activo
			)
			VALUES
			(
				@ContextoId
				,@Nombre
				,@Observaciones
				,@Activo
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
 
 
 
 
IF (OBJECT_ID('usp_Recursos__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_Recursos__Update_by_@id
GO
CREATE PROCEDURE usp_Recursos__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@Nombre                                                   VARCHAR(100)
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Recursos'
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
			UPDATE Recursos
			SET
				Nombre = @Nombre
				,Observaciones = @Observaciones
			FROM Recursos
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
-- SP-TABLA: Recursos /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: RelAsig_Contactos_A_GruposDeContactos /ABMs/ - INICIO
IF (OBJECT_ID('usp_RelAsig_Contactos_A_GruposDeContactos__Insert') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Contactos_A_GruposDeContactos__Insert
GO
CREATE PROCEDURE usp_RelAsig_Contactos_A_GruposDeContactos__Insert
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
 
	,@ContactoId                                               INT
	,@GrupoDeContactoId                                        INT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Contactos_A_GruposDeContactos'
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
			INSERT INTO RelAsig_Contactos_A_GruposDeContactos
			(
				ContactoId
				,GrupoDeContactoId
			)
			VALUES
			(
				@ContactoId
				,@GrupoDeContactoId
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
 
 
 
 
IF (OBJECT_ID('usp_RelAsig_Contactos_A_GruposDeContactos__Insert_by_@ContactoIdsString') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Contactos_A_GruposDeContactos__Insert_by_@ContactoIdsString
GO
CREATE PROCEDURE usp_RelAsig_Contactos_A_GruposDeContactos__Insert_by_@ContactoIdsString
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
 
	,@ContactoIdsString                                        VARCHAR(MAX)
 
	,@GrupoDeContactoId                                        INT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
BEGIN TRAN -- El Try va primero, si no, luego recibimos errores del tipo "The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION"
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Contactos_A_GruposDeContactos'
		,@FuncionDePagina VARCHAR(30) = 'Insert'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	SET @sResSQL = '' -- NO MIRO NINGÚN PERMISO POR QUE LOS MIRARÁ EL SP QUE EJECUTO "__Insert":
 
	CREATE TABLE #TablaDeIds (Indice INT IDENTITY(1,1), id INT)		-- DROP TABLE #TablaDeIds (Lo dejo acá para cuando corre con errores y queda creada en memoria).
	INSERT INTO #TablaDeIds SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@ContactoIdsString)
 
	DECLARE @ContactoId INT
	DECLARE @x INT = 0 -- indice para recorrer
	DECLARE @FilasDeLaTablaFK INT = (SELECT COUNT(*) FROM #TablaDeIds)
	WHILE (@x < @FilasDeLaTablaFK AND @sResSQL = '')
		BEGIN
			SET @x = @x + 1
			SET @ContactoId = (SELECT id FROM #TablaDeIds WHERE Indice = @x)
			-- En cada "vuelta" ejecuta un insert standard
			EXEC usp_RelAsig_Contactos_A_GruposDeContactos__Insert	
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					,@FechaDeEjecucion = @FechaDeEjecucion
					,@Token = @Token
					,@Seccion = @Seccion
					,@CodigoDelContexto = @CodigoDelContexto
					,@ContactoId = @ContactoId
					,@GrupoDeContactoId = @GrupoDeContactoId
					,@sResSQL = @sResSQL OUTPUT
					,@id = @id OUTPUT
		END
 
	DROP TABLE #TablaDeIds
 
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
	IF OBJECT_ID('tempdb..#TablaDeIds') IS NOT NULL DROP TABLE #TablaDeIds; --// Si saltó al CATCH pesiste la Tabla creada
 
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_RelAsig_Contactos_A_GruposDeContactos__Insert_by_@GrupoDeContactoIdsString') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Contactos_A_GruposDeContactos__Insert_by_@GrupoDeContactoIdsString
GO
CREATE PROCEDURE usp_RelAsig_Contactos_A_GruposDeContactos__Insert_by_@GrupoDeContactoIdsString
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
 
	,@GrupoDeContactoIdsString                                 VARCHAR(MAX)
 
	,@ContactoId                                               INT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
BEGIN TRAN -- El Try va primero, si no, luego recibimos errores del tipo "The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION"
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Contactos_A_GruposDeContactos'
		,@FuncionDePagina VARCHAR(30) = 'Insert'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	SET @sResSQL = '' -- NO MIRO NINGÚN PERMISO POR QUE LOS MIRARÁ EL SP QUE EJECUTO "__Insert":
 
	CREATE TABLE #TablaDeIds (Indice INT IDENTITY(1,1), id INT)		-- DROP TABLE #TablaDeIds (Lo dejo acá para cuando corre con errores y queda creada en memoria).
	INSERT INTO #TablaDeIds SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@GrupoDeContactoIdsString)
 
	DECLARE @GrupoDeContactoId INT
	DECLARE @x INT = 0 -- indice para recorrer
	DECLARE @FilasDeLaTablaFK INT = (SELECT COUNT(*) FROM #TablaDeIds)
	WHILE (@x < @FilasDeLaTablaFK AND @sResSQL = '')
		BEGIN
			SET @x = @x + 1
			SET @GrupoDeContactoId = (SELECT id FROM #TablaDeIds WHERE Indice = @x)
			-- En cada "vuelta" ejecuta un insert standard
			EXEC usp_RelAsig_Contactos_A_GruposDeContactos__Insert	
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					,@FechaDeEjecucion = @FechaDeEjecucion
					,@Token = @Token
					,@Seccion = @Seccion
					,@CodigoDelContexto = @CodigoDelContexto
					,@ContactoId = @ContactoId
					,@GrupoDeContactoId = @GrupoDeContactoId
					,@sResSQL = @sResSQL OUTPUT
					,@id = @id OUTPUT
		END
 
	DROP TABLE #TablaDeIds
 
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
	IF OBJECT_ID('tempdb..#TablaDeIds') IS NOT NULL DROP TABLE #TablaDeIds; --// Si saltó al CATCH pesiste la Tabla creada
 
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_RelAsig_Contactos_A_GruposDeContactos__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Contactos_A_GruposDeContactos__Update_by_@id
GO
CREATE PROCEDURE usp_RelAsig_Contactos_A_GruposDeContactos__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@ContactoId                                               INT
	,@GrupoDeContactoId                                        INT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Contactos_A_GruposDeContactos'
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
			UPDATE RelAsig_Contactos_A_GruposDeContactos
			SET
				ContactoId = @ContactoId
				,GrupoDeContactoId = @GrupoDeContactoId
			FROM RelAsig_Contactos_A_GruposDeContactos
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
 
 
 
 
IF (OBJECT_ID('usp_RelAsig_Contactos_A_GruposDeContactos__Update_by_@ContactoIdsString') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Contactos_A_GruposDeContactos__Update_by_@ContactoIdsString
GO
CREATE PROCEDURE usp_RelAsig_Contactos_A_GruposDeContactos__Update_by_@ContactoIdsString
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT -- Lo tenemos que recibir igual por que es parte del modelo; Aunque en este caso de Update by IdsString, no se toma en cuenta el @id
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@ContactoIdsString                                        VARCHAR(MAX)
 
	,@GrupoDeContactoId                                        INT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
BEGIN TRAN -- El Try va primero, si no, luego recibimos errores del tipo "The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION"
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Contactos_A_GruposDeContactos'
		,@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	SET @sResSQL = '' -- NO MIRO NINGÚN PERMISO POR QUE LOS MIRARÁ CADA SP QUE SE EJECUTAN:
 
	IF @sResSQL = ''
		BEGIN
			-- PARA PODER REALIZAR EL PROCEDIMIENTO SIGUIENTE ES NECESARIO QUE LA TABLA PERMITA ELIMINAR REGISTROS (PermiteEliminar = '1'), CASO CONTRARIO DARÁ ERROR LA EJECUCIÓN DEL SP.
 
			-- El procediomiento es hacer 2 recorridas, 1ero ver si de los Ids que HAY en la BD, no está aca en el IdsString --> Eliminamos ese registro.
													-- 2do, recorrer el IdsString, y si NO HAY alguno de ellos en la BD --> Lo Inserto.
 
			-- Acá guardo en Tabla los Ids que ya están en la BD. OJO, No guardo el id del Registro, guardo la FK Ids String
			CREATE TABLE #TablaDeRegistrosExistentes (Indice INT IDENTITY(1,1), ContactoId INT)		-- DROP TABLE #TablaDeIds (Lo dejo acá para cuando corre con errores y queda creada en memoria).
			INSERT INTO #TablaDeRegistrosExistentes SELECT ContactoId FROM RelAsig_Contactos_A_GruposDeContactos WHERE (
				GrupoDeContactoId = @GrupoDeContactoId
			)
 
			-- Acá guardo en Tabla los IdsString:
			CREATE TABLE #TablaDeIds (Indice INT IDENTITY(1,1), id INT)		-- DROP TABLE #TablaDeIds (Lo dejo acá para cuando corre con errores y queda creada en memoria).
			INSERT INTO #TablaDeIds SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@ContactoIdsString)
 
			DECLARE @Registro_Existente INT
				,@Registro_DelString INT
 
			DECLARE @xRegs INT = 0 -- indice para recorrer
			DECLARE @FilasDeTablaDeRegs INT = (SELECT COUNT(*) FROM #TablaDeRegistrosExistentes)
 
			DECLARE @xIds INT = 0 -- indice para recorrer
			DECLARE @FilasDeTablaDeIds INT = (SELECT COUNT(*) FROM #TablaDeIds)
 
			-- Procedimiento 1: Deletes --> Recorro la Tabla: #TablaDeRegistrosExistentes, Si hay algun id que NO está en la #TablaDeIds --> lo elimino.
			WHILE (@xRegs < @FilasDeTablaDeRegs AND @sResSQL = '')
				BEGIN
					SET @xRegs = @xRegs + 1
					SET @Registro_Existente = (SELECT ContactoId FROM #TablaDeRegistrosExistentes WHERE Indice = @xRegs)
 
					IF (SELECT id FROM #TablaDeIds WHERE id = @Registro_Existente) IS NULL
						BEGIN -- La elimino:
							-- 1ero busco el id correspondiente de la tabla Rel:
							SET @id = (SELECT id FROM RelAsig_Contactos_A_GruposDeContactos WHERE ContactoId = @Registro_Existente
											AND GrupoDeContactoId = @GrupoDeContactoId
										)
 
							EXEC usp_TablaDinamica__DeleteOActivo_by_@id
									@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
									,@FechaDeEjecucion = @FechaDeEjecucion
									,@Token = @Token
									,@Seccion = @Seccion
									,@CodigoDelContexto = @CodigoDelContexto
									,@id = @id
									,@Tabla = @Tabla
									,@sResSQL = @sResSQL OUTPUT
						END
				END
 
			-- Procedimeinto 2: Inserts --> Recorro la Tabla: #TablaDeIds, Si hay algun id que NO está en la #TablaDeRegistrosExistentes --> lo inserto.
			WHILE (@xIds < @FilasDeTablaDeIds AND @sResSQL = '')
				BEGIN
					SET @xIds = @xIds + 1
					SET @Registro_DelString = (SELECT id FROM #TablaDeIds WHERE Indice = @xIds)
 
					IF (SELECT ContactoId FROM #TablaDeRegistrosExistentes WHERE ContactoId = @Registro_DelString) IS NULL
						BEGIN -- La inserto:
							EXEC usp_RelAsig_Contactos_A_GruposDeContactos__Insert
									@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
									,@FechaDeEjecucion = @FechaDeEjecucion
									,@Token = @Token
									,@Seccion = @Seccion
									,@CodigoDelContexto = @CodigoDelContexto
									,@GrupoDeContactoId = @GrupoDeContactoId
									,@ContactoId = @Registro_DelString
									,@sResSQL = @sResSQL OUTPUT
									,@id = @id OUTPUT
						END
				END
 
			DROP TABLE #TablaDeRegistrosExistentes
			DROP TABLE #TablaDeIds
 
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
	IF OBJECT_ID('tempdb..#TablaDeIds') IS NOT NULL DROP TABLE #TablaDeIds; --// Si saltó al CATCH pesiste la Tabla creada
	IF OBJECT_ID('tempdb..#TablaDeRegistrosExistentes') IS NOT NULL DROP TABLE #TablaDeRegistrosExistentes; --// Si saltó al CATCH pesiste la Tabla creada
 
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_RelAsig_Contactos_A_GruposDeContactos__Update_by_@GrupoDeContactoIdsString') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Contactos_A_GruposDeContactos__Update_by_@GrupoDeContactoIdsString
GO
CREATE PROCEDURE usp_RelAsig_Contactos_A_GruposDeContactos__Update_by_@GrupoDeContactoIdsString
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT -- Lo tenemos que recibir igual por que es parte del modelo; Aunque en este caso de Update by IdsString, no se toma en cuenta el @id
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@GrupoDeContactoIdsString                                 VARCHAR(MAX)
 
	,@ContactoId                                               INT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
BEGIN TRAN -- El Try va primero, si no, luego recibimos errores del tipo "The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION"
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Contactos_A_GruposDeContactos'
		,@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	SET @sResSQL = '' -- NO MIRO NINGÚN PERMISO POR QUE LOS MIRARÁ CADA SP QUE SE EJECUTAN:
 
	IF @sResSQL = ''
		BEGIN
			-- PARA PODER REALIZAR EL PROCEDIMIENTO SIGUIENTE ES NECESARIO QUE LA TABLA PERMITA ELIMINAR REGISTROS (PermiteEliminar = '1'), CASO CONTRARIO DARÁ ERROR LA EJECUCIÓN DEL SP.
 
			-- El procediomiento es hacer 2 recorridas, 1ero ver si de los Ids que HAY en la BD, no está aca en el IdsString --> Eliminamos ese registro.
													-- 2do, recorrer el IdsString, y si NO HAY alguno de ellos en la BD --> Lo Inserto.
 
			-- Acá guardo en Tabla los Ids que ya están en la BD. OJO, No guardo el id del Registro, guardo la FK Ids String
			CREATE TABLE #TablaDeRegistrosExistentes (Indice INT IDENTITY(1,1), GrupoDeContactoId INT)		-- DROP TABLE #TablaDeIds (Lo dejo acá para cuando corre con errores y queda creada en memoria).
			INSERT INTO #TablaDeRegistrosExistentes SELECT GrupoDeContactoId FROM RelAsig_Contactos_A_GruposDeContactos WHERE (
				ContactoId = @ContactoId
			)
 
			-- Acá guardo en Tabla los IdsString:
			CREATE TABLE #TablaDeIds (Indice INT IDENTITY(1,1), id INT)		-- DROP TABLE #TablaDeIds (Lo dejo acá para cuando corre con errores y queda creada en memoria).
			INSERT INTO #TablaDeIds SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@GrupoDeContactoIdsString)
 
			DECLARE @Registro_Existente INT
				,@Registro_DelString INT
 
			DECLARE @xRegs INT = 0 -- indice para recorrer
			DECLARE @FilasDeTablaDeRegs INT = (SELECT COUNT(*) FROM #TablaDeRegistrosExistentes)
 
			DECLARE @xIds INT = 0 -- indice para recorrer
			DECLARE @FilasDeTablaDeIds INT = (SELECT COUNT(*) FROM #TablaDeIds)
 
			-- Procedimiento 1: Deletes --> Recorro la Tabla: #TablaDeRegistrosExistentes, Si hay algun id que NO está en la #TablaDeIds --> lo elimino.
			WHILE (@xRegs < @FilasDeTablaDeRegs AND @sResSQL = '')
				BEGIN
					SET @xRegs = @xRegs + 1
					SET @Registro_Existente = (SELECT GrupoDeContactoId FROM #TablaDeRegistrosExistentes WHERE Indice = @xRegs)
 
					IF (SELECT id FROM #TablaDeIds WHERE id = @Registro_Existente) IS NULL
						BEGIN -- La elimino:
							-- 1ero busco el id correspondiente de la tabla Rel:
							SET @id = (SELECT id FROM RelAsig_Contactos_A_GruposDeContactos WHERE GrupoDeContactoId = @Registro_Existente
											AND ContactoId = @ContactoId
										)
 
							EXEC usp_TablaDinamica__DeleteOActivo_by_@id
									@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
									,@FechaDeEjecucion = @FechaDeEjecucion
									,@Token = @Token
									,@Seccion = @Seccion
									,@CodigoDelContexto = @CodigoDelContexto
									,@id = @id
									,@Tabla = @Tabla
									,@sResSQL = @sResSQL OUTPUT
						END
				END
 
			-- Procedimeinto 2: Inserts --> Recorro la Tabla: #TablaDeIds, Si hay algun id que NO está en la #TablaDeRegistrosExistentes --> lo inserto.
			WHILE (@xIds < @FilasDeTablaDeIds AND @sResSQL = '')
				BEGIN
					SET @xIds = @xIds + 1
					SET @Registro_DelString = (SELECT id FROM #TablaDeIds WHERE Indice = @xIds)
 
					IF (SELECT GrupoDeContactoId FROM #TablaDeRegistrosExistentes WHERE GrupoDeContactoId = @Registro_DelString) IS NULL
						BEGIN -- La inserto:
							EXEC usp_RelAsig_Contactos_A_GruposDeContactos__Insert
									@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
									,@FechaDeEjecucion = @FechaDeEjecucion
									,@Token = @Token
									,@Seccion = @Seccion
									,@CodigoDelContexto = @CodigoDelContexto
									,@ContactoId = @ContactoId
									,@GrupoDeContactoId = @Registro_DelString
									,@sResSQL = @sResSQL OUTPUT
									,@id = @id OUTPUT
						END
				END
 
			DROP TABLE #TablaDeRegistrosExistentes
			DROP TABLE #TablaDeIds
 
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
	IF OBJECT_ID('tempdb..#TablaDeIds') IS NOT NULL DROP TABLE #TablaDeIds; --// Si saltó al CATCH pesiste la Tabla creada
	IF OBJECT_ID('tempdb..#TablaDeRegistrosExistentes') IS NOT NULL DROP TABLE #TablaDeRegistrosExistentes; --// Si saltó al CATCH pesiste la Tabla creada
 
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: RelAsig_Contactos_A_GruposDeContactos /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: RelAsig_Contactos_A_TiposDeContactos /ABMs/ - INICIO
IF (OBJECT_ID('usp_RelAsig_Contactos_A_TiposDeContactos__Insert') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Contactos_A_TiposDeContactos__Insert
GO
CREATE PROCEDURE usp_RelAsig_Contactos_A_TiposDeContactos__Insert
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
 
	,@ContactoId                                               INT
	,@TipoDeContactoId                                         INT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Contactos_A_TiposDeContactos'
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
			INSERT INTO RelAsig_Contactos_A_TiposDeContactos
			(
				ContactoId
				,TipoDeContactoId
			)
			VALUES
			(
				@ContactoId
				,@TipoDeContactoId
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
 
 
 
 
IF (OBJECT_ID('usp_RelAsig_Contactos_A_TiposDeContactos__Insert_by_@ContactoIdsString') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Contactos_A_TiposDeContactos__Insert_by_@ContactoIdsString
GO
CREATE PROCEDURE usp_RelAsig_Contactos_A_TiposDeContactos__Insert_by_@ContactoIdsString
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
 
	,@ContactoIdsString                                        VARCHAR(MAX)
 
	,@TipoDeContactoId                                         INT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
BEGIN TRAN -- El Try va primero, si no, luego recibimos errores del tipo "The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION"
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Contactos_A_TiposDeContactos'
		,@FuncionDePagina VARCHAR(30) = 'Insert'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	SET @sResSQL = '' -- NO MIRO NINGÚN PERMISO POR QUE LOS MIRARÁ EL SP QUE EJECUTO "__Insert":
 
	CREATE TABLE #TablaDeIds (Indice INT IDENTITY(1,1), id INT)		-- DROP TABLE #TablaDeIds (Lo dejo acá para cuando corre con errores y queda creada en memoria).
	INSERT INTO #TablaDeIds SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@ContactoIdsString)
 
	DECLARE @ContactoId INT
	DECLARE @x INT = 0 -- indice para recorrer
	DECLARE @FilasDeLaTablaFK INT = (SELECT COUNT(*) FROM #TablaDeIds)
	WHILE (@x < @FilasDeLaTablaFK AND @sResSQL = '')
		BEGIN
			SET @x = @x + 1
			SET @ContactoId = (SELECT id FROM #TablaDeIds WHERE Indice = @x)
			-- En cada "vuelta" ejecuta un insert standard
			EXEC usp_RelAsig_Contactos_A_TiposDeContactos__Insert	
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					,@FechaDeEjecucion = @FechaDeEjecucion
					,@Token = @Token
					,@Seccion = @Seccion
					,@CodigoDelContexto = @CodigoDelContexto
					,@ContactoId = @ContactoId
					,@TipoDeContactoId = @TipoDeContactoId
					,@sResSQL = @sResSQL OUTPUT
					,@id = @id OUTPUT
		END
 
	DROP TABLE #TablaDeIds
 
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
	IF OBJECT_ID('tempdb..#TablaDeIds') IS NOT NULL DROP TABLE #TablaDeIds; --// Si saltó al CATCH pesiste la Tabla creada
 
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_RelAsig_Contactos_A_TiposDeContactos__Insert_by_@TipoDeContactoIdsString') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Contactos_A_TiposDeContactos__Insert_by_@TipoDeContactoIdsString
GO
CREATE PROCEDURE usp_RelAsig_Contactos_A_TiposDeContactos__Insert_by_@TipoDeContactoIdsString
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
 
	,@TipoDeContactoIdsString                                  VARCHAR(MAX)
 
	,@ContactoId                                               INT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
BEGIN TRAN -- El Try va primero, si no, luego recibimos errores del tipo "The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION"
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Contactos_A_TiposDeContactos'
		,@FuncionDePagina VARCHAR(30) = 'Insert'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	SET @sResSQL = '' -- NO MIRO NINGÚN PERMISO POR QUE LOS MIRARÁ EL SP QUE EJECUTO "__Insert":
 
	CREATE TABLE #TablaDeIds (Indice INT IDENTITY(1,1), id INT)		-- DROP TABLE #TablaDeIds (Lo dejo acá para cuando corre con errores y queda creada en memoria).
	INSERT INTO #TablaDeIds SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@TipoDeContactoIdsString)
 
	DECLARE @TipoDeContactoId INT
	DECLARE @x INT = 0 -- indice para recorrer
	DECLARE @FilasDeLaTablaFK INT = (SELECT COUNT(*) FROM #TablaDeIds)
	WHILE (@x < @FilasDeLaTablaFK AND @sResSQL = '')
		BEGIN
			SET @x = @x + 1
			SET @TipoDeContactoId = (SELECT id FROM #TablaDeIds WHERE Indice = @x)
			-- En cada "vuelta" ejecuta un insert standard
			EXEC usp_RelAsig_Contactos_A_TiposDeContactos__Insert	
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					,@FechaDeEjecucion = @FechaDeEjecucion
					,@Token = @Token
					,@Seccion = @Seccion
					,@CodigoDelContexto = @CodigoDelContexto
					,@ContactoId = @ContactoId
					,@TipoDeContactoId = @TipoDeContactoId
					,@sResSQL = @sResSQL OUTPUT
					,@id = @id OUTPUT
		END
 
	DROP TABLE #TablaDeIds
 
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
	IF OBJECT_ID('tempdb..#TablaDeIds') IS NOT NULL DROP TABLE #TablaDeIds; --// Si saltó al CATCH pesiste la Tabla creada
 
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_RelAsig_Contactos_A_TiposDeContactos__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Contactos_A_TiposDeContactos__Update_by_@id
GO
CREATE PROCEDURE usp_RelAsig_Contactos_A_TiposDeContactos__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@ContactoId                                               INT
	,@TipoDeContactoId                                         INT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Contactos_A_TiposDeContactos'
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
			UPDATE RelAsig_Contactos_A_TiposDeContactos
			SET
				ContactoId = @ContactoId
				,TipoDeContactoId = @TipoDeContactoId
			FROM RelAsig_Contactos_A_TiposDeContactos
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
 
 
 
 
IF (OBJECT_ID('usp_RelAsig_Contactos_A_TiposDeContactos__Update_by_@ContactoIdsString') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Contactos_A_TiposDeContactos__Update_by_@ContactoIdsString
GO
CREATE PROCEDURE usp_RelAsig_Contactos_A_TiposDeContactos__Update_by_@ContactoIdsString
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT -- Lo tenemos que recibir igual por que es parte del modelo; Aunque en este caso de Update by IdsString, no se toma en cuenta el @id
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@ContactoIdsString                                        VARCHAR(MAX)
 
	,@TipoDeContactoId                                         INT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
BEGIN TRAN -- El Try va primero, si no, luego recibimos errores del tipo "The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION"
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Contactos_A_TiposDeContactos'
		,@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	SET @sResSQL = '' -- NO MIRO NINGÚN PERMISO POR QUE LOS MIRARÁ CADA SP QUE SE EJECUTAN:
 
	IF @sResSQL = ''
		BEGIN
			-- PARA PODER REALIZAR EL PROCEDIMIENTO SIGUIENTE ES NECESARIO QUE LA TABLA PERMITA ELIMINAR REGISTROS (PermiteEliminar = '1'), CASO CONTRARIO DARÁ ERROR LA EJECUCIÓN DEL SP.
 
			-- El procediomiento es hacer 2 recorridas, 1ero ver si de los Ids que HAY en la BD, no está aca en el IdsString --> Eliminamos ese registro.
													-- 2do, recorrer el IdsString, y si NO HAY alguno de ellos en la BD --> Lo Inserto.
 
			-- Acá guardo en Tabla los Ids que ya están en la BD. OJO, No guardo el id del Registro, guardo la FK Ids String
			CREATE TABLE #TablaDeRegistrosExistentes (Indice INT IDENTITY(1,1), ContactoId INT)		-- DROP TABLE #TablaDeIds (Lo dejo acá para cuando corre con errores y queda creada en memoria).
			INSERT INTO #TablaDeRegistrosExistentes SELECT ContactoId FROM RelAsig_Contactos_A_TiposDeContactos WHERE (
				TipoDeContactoId = @TipoDeContactoId
			)
 
			-- Acá guardo en Tabla los IdsString:
			CREATE TABLE #TablaDeIds (Indice INT IDENTITY(1,1), id INT)		-- DROP TABLE #TablaDeIds (Lo dejo acá para cuando corre con errores y queda creada en memoria).
			INSERT INTO #TablaDeIds SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@ContactoIdsString)
 
			DECLARE @Registro_Existente INT
				,@Registro_DelString INT
 
			DECLARE @xRegs INT = 0 -- indice para recorrer
			DECLARE @FilasDeTablaDeRegs INT = (SELECT COUNT(*) FROM #TablaDeRegistrosExistentes)
 
			DECLARE @xIds INT = 0 -- indice para recorrer
			DECLARE @FilasDeTablaDeIds INT = (SELECT COUNT(*) FROM #TablaDeIds)
 
			-- Procedimiento 1: Deletes --> Recorro la Tabla: #TablaDeRegistrosExistentes, Si hay algun id que NO está en la #TablaDeIds --> lo elimino.
			WHILE (@xRegs < @FilasDeTablaDeRegs AND @sResSQL = '')
				BEGIN
					SET @xRegs = @xRegs + 1
					SET @Registro_Existente = (SELECT ContactoId FROM #TablaDeRegistrosExistentes WHERE Indice = @xRegs)
 
					IF (SELECT id FROM #TablaDeIds WHERE id = @Registro_Existente) IS NULL
						BEGIN -- La elimino:
							-- 1ero busco el id correspondiente de la tabla Rel:
							SET @id = (SELECT id FROM RelAsig_Contactos_A_TiposDeContactos WHERE ContactoId = @Registro_Existente
											AND TipoDeContactoId = @TipoDeContactoId
										)
 
							EXEC usp_TablaDinamica__DeleteOActivo_by_@id
									@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
									,@FechaDeEjecucion = @FechaDeEjecucion
									,@Token = @Token
									,@Seccion = @Seccion
									,@CodigoDelContexto = @CodigoDelContexto
									,@id = @id
									,@Tabla = @Tabla
									,@sResSQL = @sResSQL OUTPUT
						END
				END
 
			-- Procedimeinto 2: Inserts --> Recorro la Tabla: #TablaDeIds, Si hay algun id que NO está en la #TablaDeRegistrosExistentes --> lo inserto.
			WHILE (@xIds < @FilasDeTablaDeIds AND @sResSQL = '')
				BEGIN
					SET @xIds = @xIds + 1
					SET @Registro_DelString = (SELECT id FROM #TablaDeIds WHERE Indice = @xIds)
 
					IF (SELECT ContactoId FROM #TablaDeRegistrosExistentes WHERE ContactoId = @Registro_DelString) IS NULL
						BEGIN -- La inserto:
							EXEC usp_RelAsig_Contactos_A_TiposDeContactos__Insert
									@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
									,@FechaDeEjecucion = @FechaDeEjecucion
									,@Token = @Token
									,@Seccion = @Seccion
									,@CodigoDelContexto = @CodigoDelContexto
									,@TipoDeContactoId = @TipoDeContactoId
									,@ContactoId = @Registro_DelString
									,@sResSQL = @sResSQL OUTPUT
									,@id = @id OUTPUT
						END
				END
 
			DROP TABLE #TablaDeRegistrosExistentes
			DROP TABLE #TablaDeIds
 
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
	IF OBJECT_ID('tempdb..#TablaDeIds') IS NOT NULL DROP TABLE #TablaDeIds; --// Si saltó al CATCH pesiste la Tabla creada
	IF OBJECT_ID('tempdb..#TablaDeRegistrosExistentes') IS NOT NULL DROP TABLE #TablaDeRegistrosExistentes; --// Si saltó al CATCH pesiste la Tabla creada
 
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_RelAsig_Contactos_A_TiposDeContactos__Update_by_@TipoDeContactoIdsString') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Contactos_A_TiposDeContactos__Update_by_@TipoDeContactoIdsString
GO
CREATE PROCEDURE usp_RelAsig_Contactos_A_TiposDeContactos__Update_by_@TipoDeContactoIdsString
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT -- Lo tenemos que recibir igual por que es parte del modelo; Aunque en este caso de Update by IdsString, no se toma en cuenta el @id
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@TipoDeContactoIdsString                                  VARCHAR(MAX)
 
	,@ContactoId                                               INT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
BEGIN TRAN -- El Try va primero, si no, luego recibimos errores del tipo "The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION"
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Contactos_A_TiposDeContactos'
		,@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	SET @sResSQL = '' -- NO MIRO NINGÚN PERMISO POR QUE LOS MIRARÁ CADA SP QUE SE EJECUTAN:
 
	IF @sResSQL = ''
		BEGIN
			-- PARA PODER REALIZAR EL PROCEDIMIENTO SIGUIENTE ES NECESARIO QUE LA TABLA PERMITA ELIMINAR REGISTROS (PermiteEliminar = '1'), CASO CONTRARIO DARÁ ERROR LA EJECUCIÓN DEL SP.
 
			-- El procediomiento es hacer 2 recorridas, 1ero ver si de los Ids que HAY en la BD, no está aca en el IdsString --> Eliminamos ese registro.
													-- 2do, recorrer el IdsString, y si NO HAY alguno de ellos en la BD --> Lo Inserto.
 
			-- Acá guardo en Tabla los Ids que ya están en la BD. OJO, No guardo el id del Registro, guardo la FK Ids String
			CREATE TABLE #TablaDeRegistrosExistentes (Indice INT IDENTITY(1,1), TipoDeContactoId INT)		-- DROP TABLE #TablaDeIds (Lo dejo acá para cuando corre con errores y queda creada en memoria).
			INSERT INTO #TablaDeRegistrosExistentes SELECT TipoDeContactoId FROM RelAsig_Contactos_A_TiposDeContactos WHERE (
				ContactoId = @ContactoId
			)
 
			-- Acá guardo en Tabla los IdsString:
			CREATE TABLE #TablaDeIds (Indice INT IDENTITY(1,1), id INT)		-- DROP TABLE #TablaDeIds (Lo dejo acá para cuando corre con errores y queda creada en memoria).
			INSERT INTO #TablaDeIds SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@TipoDeContactoIdsString)
 
			DECLARE @Registro_Existente INT
				,@Registro_DelString INT
 
			DECLARE @xRegs INT = 0 -- indice para recorrer
			DECLARE @FilasDeTablaDeRegs INT = (SELECT COUNT(*) FROM #TablaDeRegistrosExistentes)
 
			DECLARE @xIds INT = 0 -- indice para recorrer
			DECLARE @FilasDeTablaDeIds INT = (SELECT COUNT(*) FROM #TablaDeIds)
 
			-- Procedimiento 1: Deletes --> Recorro la Tabla: #TablaDeRegistrosExistentes, Si hay algun id que NO está en la #TablaDeIds --> lo elimino.
			WHILE (@xRegs < @FilasDeTablaDeRegs AND @sResSQL = '')
				BEGIN
					SET @xRegs = @xRegs + 1
					SET @Registro_Existente = (SELECT TipoDeContactoId FROM #TablaDeRegistrosExistentes WHERE Indice = @xRegs)
 
					IF (SELECT id FROM #TablaDeIds WHERE id = @Registro_Existente) IS NULL
						BEGIN -- La elimino:
							-- 1ero busco el id correspondiente de la tabla Rel:
							SET @id = (SELECT id FROM RelAsig_Contactos_A_TiposDeContactos WHERE TipoDeContactoId = @Registro_Existente
											AND ContactoId = @ContactoId
										)
 
							EXEC usp_TablaDinamica__DeleteOActivo_by_@id
									@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
									,@FechaDeEjecucion = @FechaDeEjecucion
									,@Token = @Token
									,@Seccion = @Seccion
									,@CodigoDelContexto = @CodigoDelContexto
									,@id = @id
									,@Tabla = @Tabla
									,@sResSQL = @sResSQL OUTPUT
						END
				END
 
			-- Procedimeinto 2: Inserts --> Recorro la Tabla: #TablaDeIds, Si hay algun id que NO está en la #TablaDeRegistrosExistentes --> lo inserto.
			WHILE (@xIds < @FilasDeTablaDeIds AND @sResSQL = '')
				BEGIN
					SET @xIds = @xIds + 1
					SET @Registro_DelString = (SELECT id FROM #TablaDeIds WHERE Indice = @xIds)
 
					IF (SELECT TipoDeContactoId FROM #TablaDeRegistrosExistentes WHERE TipoDeContactoId = @Registro_DelString) IS NULL
						BEGIN -- La inserto:
							EXEC usp_RelAsig_Contactos_A_TiposDeContactos__Insert
									@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
									,@FechaDeEjecucion = @FechaDeEjecucion
									,@Token = @Token
									,@Seccion = @Seccion
									,@CodigoDelContexto = @CodigoDelContexto
									,@ContactoId = @ContactoId
									,@TipoDeContactoId = @Registro_DelString
									,@sResSQL = @sResSQL OUTPUT
									,@id = @id OUTPUT
						END
				END
 
			DROP TABLE #TablaDeRegistrosExistentes
			DROP TABLE #TablaDeIds
 
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
	IF OBJECT_ID('tempdb..#TablaDeIds') IS NOT NULL DROP TABLE #TablaDeIds; --// Si saltó al CATCH pesiste la Tabla creada
	IF OBJECT_ID('tempdb..#TablaDeRegistrosExistentes') IS NOT NULL DROP TABLE #TablaDeRegistrosExistentes; --// Si saltó al CATCH pesiste la Tabla creada
 
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: RelAsig_Contactos_A_TiposDeContactos /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: RelAsig_CuentasDeEnvios_A_Tablas /ABMs/ - INICIO
IF (OBJECT_ID('usp_RelAsig_CuentasDeEnvios_A_Tablas__Insert') IS NOT NULL) DROP PROCEDURE usp_RelAsig_CuentasDeEnvios_A_Tablas__Insert
GO
CREATE PROCEDURE usp_RelAsig_CuentasDeEnvios_A_Tablas__Insert
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
 
	,@CuentaDeEnvioId                                          INT
	,@TablaId                                                  INT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_CuentasDeEnvios_A_Tablas'
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
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SET NOCOUNT ON
			INSERT INTO RelAsig_CuentasDeEnvios_A_Tablas
			(
				ContextoId
				,CuentaDeEnvioId
				,TablaId
			)
			VALUES
			(
				@ContextoId
				,@CuentaDeEnvioId
				,@TablaId
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
 
 
 
 
IF (OBJECT_ID('usp_RelAsig_CuentasDeEnvios_A_Tablas__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_RelAsig_CuentasDeEnvios_A_Tablas__Update_by_@id
GO
CREATE PROCEDURE usp_RelAsig_CuentasDeEnvios_A_Tablas__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@CuentaDeEnvioId                                          INT
	,@TablaId                                                  INT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_CuentasDeEnvios_A_Tablas'
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
			UPDATE RelAsig_CuentasDeEnvios_A_Tablas
			SET
				CuentaDeEnvioId = @CuentaDeEnvioId
				,TablaId = @TablaId
			FROM RelAsig_CuentasDeEnvios_A_Tablas
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
-- SP-TABLA: RelAsig_CuentasDeEnvios_A_Tablas /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: RelAsig_Subsistemas_A_Publicaciones /ABMs/ - INICIO
IF (OBJECT_ID('usp_RelAsig_Subsistemas_A_Publicaciones__Insert') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Subsistemas_A_Publicaciones__Insert
GO
CREATE PROCEDURE usp_RelAsig_Subsistemas_A_Publicaciones__Insert
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
 
	,@SubsistemaId                                             INT
	,@PublicacionId                                            INT
	,@UsuarioId                                                INT = '-2' -- Agrego un valor por default = '-2' y más adelante, si es = '-2' --> le asigno el @UsuarioQueEjecutaId
	,@NumeroDeVersion                                          VARCHAR(30) = NULL
	,@SVN                                                      INT = NULL
	,@Ubicacion                                                VARCHAR(150) = NULL
	,@Observaciones                                            VARCHAR(1000) = NULL
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Subsistemas_A_Publicaciones'
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
			SET NOCOUNT ON
			INSERT INTO RelAsig_Subsistemas_A_Publicaciones
			(
				SubsistemaId
				,PublicacionId
				,UsuarioId
				,NumeroDeVersion
				,SVN
				,Ubicacion
				,Observaciones
			)
			VALUES
			(
				@SubsistemaId
				,@PublicacionId
				,@UsuarioId
				,@NumeroDeVersion
				,@SVN
				,@Ubicacion
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
 
 
 
 
IF (OBJECT_ID('usp_RelAsig_Subsistemas_A_Publicaciones__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Subsistemas_A_Publicaciones__Update_by_@id
GO
CREATE PROCEDURE usp_RelAsig_Subsistemas_A_Publicaciones__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@SubsistemaId                                             INT
	,@PublicacionId                                            INT
	,@UsuarioId                                                INT
	,@NumeroDeVersion                                          VARCHAR(30)
	,@SVN                                                      INT
	,@Ubicacion                                                VARCHAR(150)
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Subsistemas_A_Publicaciones'
		,@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				, @RegistroId = @id
				, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			UPDATE RelAsig_Subsistemas_A_Publicaciones
			SET
				SubsistemaId = @SubsistemaId
				,PublicacionId = @PublicacionId
				,UsuarioId = @UsuarioId
				,NumeroDeVersion = @NumeroDeVersion
				,SVN = @SVN
				,Ubicacion = @Ubicacion
				,Observaciones = @Observaciones
			FROM RelAsig_Subsistemas_A_Publicaciones
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
-- SP-TABLA: RelAsig_Subsistemas_A_Publicaciones /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: RelAsig_TiposDeContactos_A_Contextos /ABMs/ - INICIO
IF (OBJECT_ID('usp_RelAsig_TiposDeContactos_A_Contextos__Insert') IS NOT NULL) DROP PROCEDURE usp_RelAsig_TiposDeContactos_A_Contextos__Insert
GO
CREATE PROCEDURE usp_RelAsig_TiposDeContactos_A_Contextos__Insert
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
 
	,@TipoDeContactoId                                         INT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_TiposDeContactos_A_Contextos'
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
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SET NOCOUNT ON
			INSERT INTO RelAsig_TiposDeContactos_A_Contextos
			(
				TipoDeContactoId
				,ContextoId
			)
			VALUES
			(
				@TipoDeContactoId
				,@ContextoId
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
 
 
 
 
IF (OBJECT_ID('usp_RelAsig_TiposDeContactos_A_Contextos__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_RelAsig_TiposDeContactos_A_Contextos__Update_by_@id
GO
CREATE PROCEDURE usp_RelAsig_TiposDeContactos_A_Contextos__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@TipoDeContactoId                                         INT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_TiposDeContactos_A_Contextos'
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
			UPDATE RelAsig_TiposDeContactos_A_Contextos
			SET
				TipoDeContactoId = @TipoDeContactoId
			FROM RelAsig_TiposDeContactos_A_Contextos
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
-- SP-TABLA: RelAsig_TiposDeContactos_A_Contextos /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: RelAsig_Usuarios_A_Recursos /ABMs/ - INICIO
IF (OBJECT_ID('usp_RelAsig_Usuarios_A_Recursos__Insert') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Usuarios_A_Recursos__Insert
GO
CREATE PROCEDURE usp_RelAsig_Usuarios_A_Recursos__Insert
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
 
	,@UsuarioId                                                INT = '-2' -- Agrego un valor por default = '-2' y más adelante, si es = '-2' --> le asigno el @UsuarioQueEjecutaId
	,@RecursoId                                                INT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Usuarios_A_Recursos'
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
			SET NOCOUNT ON
			INSERT INTO RelAsig_Usuarios_A_Recursos
			(
				UsuarioId
				,RecursoId
			)
			VALUES
			(
				@UsuarioId
				,@RecursoId
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
 
 
 
 
IF (OBJECT_ID('usp_RelAsig_Usuarios_A_Recursos__Insert_by_@UsuarioIdsString') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Usuarios_A_Recursos__Insert_by_@UsuarioIdsString
GO
CREATE PROCEDURE usp_RelAsig_Usuarios_A_Recursos__Insert_by_@UsuarioIdsString
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
 
	,@UsuarioIdsString                                         VARCHAR(MAX)
 
	,@RecursoId                                                INT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
BEGIN TRAN -- El Try va primero, si no, luego recibimos errores del tipo "The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION"
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Usuarios_A_Recursos'
		,@FuncionDePagina VARCHAR(30) = 'Insert'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	SET @sResSQL = '' -- NO MIRO NINGÚN PERMISO POR QUE LOS MIRARÁ EL SP QUE EJECUTO "__Insert":
 
	CREATE TABLE #TablaDeIds (Indice INT IDENTITY(1,1), id INT)		-- DROP TABLE #TablaDeIds (Lo dejo acá para cuando corre con errores y queda creada en memoria).
	INSERT INTO #TablaDeIds SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@UsuarioIdsString)
 
	DECLARE @UsuarioId INT
	DECLARE @x INT = 0 -- indice para recorrer
	DECLARE @FilasDeLaTablaFK INT = (SELECT COUNT(*) FROM #TablaDeIds)
	WHILE (@x < @FilasDeLaTablaFK AND @sResSQL = '')
		BEGIN
			SET @x = @x + 1
			SET @UsuarioId = (SELECT id FROM #TablaDeIds WHERE Indice = @x)
			-- En cada "vuelta" ejecuta un insert standard
			EXEC usp_RelAsig_Usuarios_A_Recursos__Insert	
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					,@FechaDeEjecucion = @FechaDeEjecucion
					,@Token = @Token
					,@Seccion = @Seccion
					,@CodigoDelContexto = @CodigoDelContexto
					,@UsuarioId = @UsuarioId
					,@RecursoId = @RecursoId
					,@sResSQL = @sResSQL OUTPUT
					,@id = @id OUTPUT
		END
 
	DROP TABLE #TablaDeIds
 
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
	IF OBJECT_ID('tempdb..#TablaDeIds') IS NOT NULL DROP TABLE #TablaDeIds; --// Si saltó al CATCH pesiste la Tabla creada
 
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_RelAsig_Usuarios_A_Recursos__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Usuarios_A_Recursos__Update_by_@id
GO
CREATE PROCEDURE usp_RelAsig_Usuarios_A_Recursos__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@UsuarioId                                                INT
	,@RecursoId                                                INT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Usuarios_A_Recursos'
		,@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				, @RegistroId = @id
				, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			UPDATE RelAsig_Usuarios_A_Recursos
			SET
				UsuarioId = @UsuarioId
				,RecursoId = @RecursoId
			FROM RelAsig_Usuarios_A_Recursos
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
 
 
 
 
IF (OBJECT_ID('usp_RelAsig_Usuarios_A_Recursos__Update_by_@UsuarioIdsString') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Usuarios_A_Recursos__Update_by_@UsuarioIdsString
GO
CREATE PROCEDURE usp_RelAsig_Usuarios_A_Recursos__Update_by_@UsuarioIdsString
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT -- Lo tenemos que recibir igual por que es parte del modelo; Aunque en este caso de Update by IdsString, no se toma en cuenta el @id
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@UsuarioIdsString                                         VARCHAR(MAX)
 
	,@RecursoId                                                INT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
BEGIN TRAN -- El Try va primero, si no, luego recibimos errores del tipo "The COMMIT TRANSACTION request has no corresponding BEGIN TRANSACTION"
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Usuarios_A_Recursos'
		,@FuncionDePagina VARCHAR(30) = 'Update'
		,@AutorizadoA VARCHAR(30) = 'OperarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	SET @sResSQL = '' -- NO MIRO NINGÚN PERMISO POR QUE LOS MIRARÁ CADA SP QUE SE EJECUTAN:
 
	IF @sResSQL = ''
		BEGIN
			-- PARA PODER REALIZAR EL PROCEDIMIENTO SIGUIENTE ES NECESARIO QUE LA TABLA PERMITA ELIMINAR REGISTROS (PermiteEliminar = '1'), CASO CONTRARIO DARÁ ERROR LA EJECUCIÓN DEL SP.
 
			-- El procediomiento es hacer 2 recorridas, 1ero ver si de los Ids que HAY en la BD, no está aca en el IdsString --> Eliminamos ese registro.
													-- 2do, recorrer el IdsString, y si NO HAY alguno de ellos en la BD --> Lo Inserto.
 
			-- Acá guardo en Tabla los Ids que ya están en la BD. OJO, No guardo el id del Registro, guardo la FK Ids String
			CREATE TABLE #TablaDeRegistrosExistentes (Indice INT IDENTITY(1,1), UsuarioId INT)		-- DROP TABLE #TablaDeIds (Lo dejo acá para cuando corre con errores y queda creada en memoria).
			INSERT INTO #TablaDeRegistrosExistentes SELECT UsuarioId FROM RelAsig_Usuarios_A_Recursos WHERE (
				RecursoId = @RecursoId
			)
 
			-- Acá guardo en Tabla los IdsString:
			CREATE TABLE #TablaDeIds (Indice INT IDENTITY(1,1), id INT)		-- DROP TABLE #TablaDeIds (Lo dejo acá para cuando corre con errores y queda creada en memoria).
			INSERT INTO #TablaDeIds SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@UsuarioIdsString)
 
			DECLARE @Registro_Existente INT
				,@Registro_DelString INT
 
			DECLARE @xRegs INT = 0 -- indice para recorrer
			DECLARE @FilasDeTablaDeRegs INT = (SELECT COUNT(*) FROM #TablaDeRegistrosExistentes)
 
			DECLARE @xIds INT = 0 -- indice para recorrer
			DECLARE @FilasDeTablaDeIds INT = (SELECT COUNT(*) FROM #TablaDeIds)
 
			-- Procedimiento 1: Deletes --> Recorro la Tabla: #TablaDeRegistrosExistentes, Si hay algun id que NO está en la #TablaDeIds --> lo elimino.
			WHILE (@xRegs < @FilasDeTablaDeRegs AND @sResSQL = '')
				BEGIN
					SET @xRegs = @xRegs + 1
					SET @Registro_Existente = (SELECT UsuarioId FROM #TablaDeRegistrosExistentes WHERE Indice = @xRegs)
 
					IF (SELECT id FROM #TablaDeIds WHERE id = @Registro_Existente) IS NULL
						BEGIN -- La elimino:
							-- 1ero busco el id correspondiente de la tabla Rel:
							SET @id = (SELECT id FROM RelAsig_Usuarios_A_Recursos WHERE UsuarioId = @Registro_Existente
											AND RecursoId = @RecursoId
										)
 
							EXEC usp_TablaDinamica__DeleteOActivo_by_@id
									@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
									,@FechaDeEjecucion = @FechaDeEjecucion
									,@Token = @Token
									,@Seccion = @Seccion
									,@CodigoDelContexto = @CodigoDelContexto
									,@id = @id
									,@Tabla = @Tabla
									,@sResSQL = @sResSQL OUTPUT
						END
				END
 
			-- Procedimeinto 2: Inserts --> Recorro la Tabla: #TablaDeIds, Si hay algun id que NO está en la #TablaDeRegistrosExistentes --> lo inserto.
			WHILE (@xIds < @FilasDeTablaDeIds AND @sResSQL = '')
				BEGIN
					SET @xIds = @xIds + 1
					SET @Registro_DelString = (SELECT id FROM #TablaDeIds WHERE Indice = @xIds)
 
					IF (SELECT UsuarioId FROM #TablaDeRegistrosExistentes WHERE UsuarioId = @Registro_DelString) IS NULL
						BEGIN -- La inserto:
							EXEC usp_RelAsig_Usuarios_A_Recursos__Insert
									@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
									,@FechaDeEjecucion = @FechaDeEjecucion
									,@Token = @Token
									,@Seccion = @Seccion
									,@CodigoDelContexto = @CodigoDelContexto
									,@RecursoId = @RecursoId
									,@UsuarioId = @Registro_DelString
									,@sResSQL = @sResSQL OUTPUT
									,@id = @id OUTPUT
						END
				END
 
			DROP TABLE #TablaDeRegistrosExistentes
			DROP TABLE #TablaDeIds
 
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
	IF OBJECT_ID('tempdb..#TablaDeIds') IS NOT NULL DROP TABLE #TablaDeIds; --// Si saltó al CATCH pesiste la Tabla creada
	IF OBJECT_ID('tempdb..#TablaDeRegistrosExistentes') IS NOT NULL DROP TABLE #TablaDeRegistrosExistentes; --// Si saltó al CATCH pesiste la Tabla creada
 
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: RelAsig_Usuarios_A_Recursos /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: Secciones /ABMs/ - INICIO
IF (OBJECT_ID('usp_Secciones__Insert') IS NOT NULL) DROP PROCEDURE usp_Secciones__Insert
GO
CREATE PROCEDURE usp_Secciones__Insert
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
 
	,@Nombre                                                   VARCHAR(30)
	,@NombreAMostrar                                           VARCHAR(40)
	,@Observaciones                                            VARCHAR(1000) = NULL
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Secciones'
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
			INSERT INTO Secciones
			(
				Nombre
				,NombreAMostrar
				,Observaciones
			)
			VALUES
			(
				@Nombre
				,@NombreAMostrar
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
 
 
 
 
IF (OBJECT_ID('usp_Secciones__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_Secciones__Update_by_@id
GO
CREATE PROCEDURE usp_Secciones__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@Nombre                                                   VARCHAR(30)
	,@NombreAMostrar                                           VARCHAR(40)
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Secciones'
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
			UPDATE Secciones
			SET
				Nombre = @Nombre
				,NombreAMostrar = @NombreAMostrar
				,Observaciones = @Observaciones
			FROM Secciones
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
-- SP-TABLA: Secciones /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: SPs /ABMs/ - INICIO
IF (OBJECT_ID('usp_SPs__Insert') IS NOT NULL) DROP PROCEDURE usp_SPs__Insert
GO
CREATE PROCEDURE usp_SPs__Insert
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
 
	,@Nombre                                                   VARCHAR(120)
	,@SeDebenEvaluarPermisos                                   BIT = '1'
	,@GeneracionDeEmailHabilitada                              BIT = '0'
	,@GeneracionDeNotificacionesHabilitada                     BIT = '0'
	,@Observaciones                                            VARCHAR(1000) = NULL
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'SPs'
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
			INSERT INTO SPs
			(
				Nombre
				,SeDebenEvaluarPermisos
				,GeneracionDeEmailHabilitada
				,GeneracionDeNotificacionesHabilitada
				,Observaciones
			)
			VALUES
			(
				@Nombre
				,@SeDebenEvaluarPermisos
				,@GeneracionDeEmailHabilitada
				,@GeneracionDeNotificacionesHabilitada
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
 
 
 
 
IF (OBJECT_ID('usp_SPs__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_SPs__Update_by_@id
GO
CREATE PROCEDURE usp_SPs__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@Nombre                                                   VARCHAR(120)
	,@SeDebenEvaluarPermisos                                   BIT
	,@GeneracionDeEmailHabilitada                              BIT
	,@GeneracionDeNotificacionesHabilitada                     BIT
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'SPs'
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
			UPDATE SPs
			SET
				Nombre = @Nombre
				,SeDebenEvaluarPermisos = @SeDebenEvaluarPermisos
				,GeneracionDeEmailHabilitada = @GeneracionDeEmailHabilitada
				,GeneracionDeNotificacionesHabilitada = @GeneracionDeNotificacionesHabilitada
				,Observaciones = @Observaciones
			FROM SPs
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
-- SP-TABLA: SPs /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: Subsistemas /ABMs/ - INICIO
IF (OBJECT_ID('usp_Subsistemas__Insert') IS NOT NULL) DROP PROCEDURE usp_Subsistemas__Insert
GO
CREATE PROCEDURE usp_Subsistemas__Insert
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
 
	,@Nombre                                                   VARCHAR(40)
	,@Observaciones                                            VARCHAR(1000) = NULL
	,@Activo                                                   BIT = '1'
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Subsistemas'
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
			INSERT INTO Subsistemas
			(
				Nombre
				,Observaciones
				,Activo
			)
			VALUES
			(
				@Nombre
				,@Observaciones
				,@Activo
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
 
 
 
 
IF (OBJECT_ID('usp_Subsistemas__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_Subsistemas__Update_by_@id
GO
CREATE PROCEDURE usp_Subsistemas__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@Nombre                                                   VARCHAR(40)
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Subsistemas'
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
			UPDATE Subsistemas
			SET
				Nombre = @Nombre
				,Observaciones = @Observaciones
			FROM Subsistemas
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
-- SP-TABLA: Subsistemas /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: TablasYFuncionesDePaginas /ABMs/ - INICIO
IF (OBJECT_ID('usp_TablasYFuncionesDePaginas__Insert') IS NOT NULL) DROP PROCEDURE usp_TablasYFuncionesDePaginas__Insert
GO
CREATE PROCEDURE usp_TablasYFuncionesDePaginas__Insert
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
 
	,@TablaId                                                  INT
	,@FuncionDePaginaId                                        INT
	,@SeDebenEvaluarPermisos                                   BIT = '1'
	,@Observaciones                                            VARCHAR(1000) = NULL
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TablasYFuncionesDePaginas'
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
			INSERT INTO TablasYFuncionesDePaginas
			(
				TablaId
				,FuncionDePaginaId
				,SeDebenEvaluarPermisos
				,Observaciones
			)
			VALUES
			(
				@TablaId
				,@FuncionDePaginaId
				,@SeDebenEvaluarPermisos
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
 
 
 
 
IF (OBJECT_ID('usp_TablasYFuncionesDePaginas__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_TablasYFuncionesDePaginas__Update_by_@id
GO
CREATE PROCEDURE usp_TablasYFuncionesDePaginas__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@TablaId                                                  INT
	,@FuncionDePaginaId                                        INT
	,@SeDebenEvaluarPermisos                                   BIT
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TablasYFuncionesDePaginas'
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
			UPDATE TablasYFuncionesDePaginas
			SET
				TablaId = @TablaId
				,FuncionDePaginaId = @FuncionDePaginaId
				,SeDebenEvaluarPermisos = @SeDebenEvaluarPermisos
				,Observaciones = @Observaciones
			FROM TablasYFuncionesDePaginas
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
-- SP-TABLA: TablasYFuncionesDePaginas /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: TiposDeActores /ABMs/ - INICIO
IF (OBJECT_ID('usp_TiposDeActores__Insert') IS NOT NULL) DROP PROCEDURE usp_TiposDeActores__Insert
GO
CREATE PROCEDURE usp_TiposDeActores__Insert
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
 
	,@Nombre                                                   VARCHAR(30)
	,@Observaciones                                            VARCHAR(1000) = NULL
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TiposDeActores'
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
			INSERT INTO TiposDeActores
			(
				Nombre
				,Observaciones
			)
			VALUES
			(
				@Nombre
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
 
 
 
 
IF (OBJECT_ID('usp_TiposDeActores__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_TiposDeActores__Update_by_@id
GO
CREATE PROCEDURE usp_TiposDeActores__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@Nombre                                                   VARCHAR(30)
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TiposDeActores'
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
			UPDATE TiposDeActores
			SET
				Nombre = @Nombre
				,Observaciones = @Observaciones
			FROM TiposDeActores
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
-- SP-TABLA: TiposDeActores /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: TiposDeArchivos /ABMs/ - INICIO
IF (OBJECT_ID('usp_TiposDeArchivos__Insert') IS NOT NULL) DROP PROCEDURE usp_TiposDeArchivos__Insert
GO
CREATE PROCEDURE usp_TiposDeArchivos__Insert
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
 
	,@Nombre                                                   VARCHAR(40)
	,@Observaciones                                            VARCHAR(1000) = NULL
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TiposDeArchivos'
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
			INSERT INTO TiposDeArchivos
			(
				Nombre
				,Observaciones
			)
			VALUES
			(
				@Nombre
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
 
 
 
 
IF (OBJECT_ID('usp_TiposDeArchivos__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_TiposDeArchivos__Update_by_@id
GO
CREATE PROCEDURE usp_TiposDeArchivos__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@Nombre                                                   VARCHAR(40)
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TiposDeArchivos'
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
			UPDATE TiposDeArchivos
			SET
				Nombre = @Nombre
				,Observaciones = @Observaciones
			FROM TiposDeArchivos
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
-- SP-TABLA: TiposDeArchivos /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: TiposDeContactos /ABMs/ - INICIO
IF (OBJECT_ID('usp_TiposDeContactos__Insert') IS NOT NULL) DROP PROCEDURE usp_TiposDeContactos__Insert
GO
CREATE PROCEDURE usp_TiposDeContactos__Insert
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
 
	,@Nombre                                                   VARCHAR(30)
	,@Observaciones                                            VARCHAR(1000) = NULL
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TiposDeContactos'
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
			INSERT INTO TiposDeContactos
			(
				Nombre
				,Observaciones
			)
			VALUES
			(
				@Nombre
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
 
 
 
 
IF (OBJECT_ID('usp_TiposDeContactos__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_TiposDeContactos__Update_by_@id
GO
CREATE PROCEDURE usp_TiposDeContactos__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@Nombre                                                   VARCHAR(30)
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TiposDeContactos'
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
			UPDATE TiposDeContactos
			SET
				Nombre = @Nombre
				,Observaciones = @Observaciones
			FROM TiposDeContactos
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
-- SP-TABLA: TiposDeContactos /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: TiposDeLogLogins /ABMs/ - INICIO
IF (OBJECT_ID('usp_TiposDeLogLogins__Insert') IS NOT NULL) DROP PROCEDURE usp_TiposDeLogLogins__Insert
GO
CREATE PROCEDURE usp_TiposDeLogLogins__Insert
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
 
	,@ConCookie                                                BIT = '0'
	,@Nombre                                                   VARCHAR(50)
	,@MensajeDeError                                           VARCHAR(1000)
	,@Observaciones                                            VARCHAR(1000) = NULL
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TiposDeLogLogins'
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
			INSERT INTO TiposDeLogLogins
			(
				ConCookie
				,Nombre
				,MensajeDeError
				,Observaciones
			)
			VALUES
			(
				@ConCookie
				,@Nombre
				,@MensajeDeError
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
 
 
 
 
IF (OBJECT_ID('usp_TiposDeLogLogins__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_TiposDeLogLogins__Update_by_@id
GO
CREATE PROCEDURE usp_TiposDeLogLogins__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@ConCookie                                                BIT
	,@Nombre                                                   VARCHAR(50)
	,@MensajeDeError                                           VARCHAR(1000)
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TiposDeLogLogins'
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
			UPDATE TiposDeLogLogins
			SET
				ConCookie = @ConCookie
				,Nombre = @Nombre
				,MensajeDeError = @MensajeDeError
				,Observaciones = @Observaciones
			FROM TiposDeLogLogins
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
-- SP-TABLA: TiposDeLogLogins /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: TiposDeOperaciones /ABMs/ - INICIO
IF (OBJECT_ID('usp_TiposDeOperaciones__Insert') IS NOT NULL) DROP PROCEDURE usp_TiposDeOperaciones__Insert
GO
CREATE PROCEDURE usp_TiposDeOperaciones__Insert
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
 
	,@Nombre                                                   VARCHAR(12)
	,@Texto                                                    VARCHAR(20) = NULL
	,@Observaciones                                            VARCHAR(1000) = NULL
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TiposDeOperaciones'
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
			INSERT INTO TiposDeOperaciones
			(
				Nombre
				,Texto
				,Observaciones
			)
			VALUES
			(
				@Nombre
				,@Texto
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
 
 
 
 
IF (OBJECT_ID('usp_TiposDeOperaciones__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_TiposDeOperaciones__Update_by_@id
GO
CREATE PROCEDURE usp_TiposDeOperaciones__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@Nombre                                                   VARCHAR(12)
	,@Texto                                                    VARCHAR(20)
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TiposDeOperaciones'
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
			UPDATE TiposDeOperaciones
			SET
				Nombre = @Nombre
				,Texto = @Texto
				,Observaciones = @Observaciones
			FROM TiposDeOperaciones
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
-- SP-TABLA: TiposDeOperaciones /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: TiposDeTareas /ABMs/ - INICIO
IF (OBJECT_ID('usp_TiposDeTareas__Insert') IS NOT NULL) DROP PROCEDURE usp_TiposDeTareas__Insert
GO
CREATE PROCEDURE usp_TiposDeTareas__Insert
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
 
	,@Nombre                                                   VARCHAR(30)
	,@Observaciones                                            VARCHAR(1000) = NULL
	,@Activo                                                   BIT = '1'
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TiposDeTareas'
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
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SET NOCOUNT ON
			INSERT INTO TiposDeTareas
			(
				ContextoId
				,Nombre
				,Observaciones
				,Activo
			)
			VALUES
			(
				@ContextoId
				,@Nombre
				,@Observaciones
				,@Activo
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
 
 
 
 
IF (OBJECT_ID('usp_TiposDeTareas__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_TiposDeTareas__Update_by_@id
GO
CREATE PROCEDURE usp_TiposDeTareas__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@Nombre                                                   VARCHAR(30)
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TiposDeTareas'
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
			UPDATE TiposDeTareas
			SET
				Nombre = @Nombre
				,Observaciones = @Observaciones
			FROM TiposDeTareas
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
-- SP-TABLA: TiposDeTareas /ABMs/ - FIN
 
 
 
 
-- SP-TABLA: Unidades /ABMs/ - INICIO
IF (OBJECT_ID('usp_Unidades__Insert') IS NOT NULL) DROP PROCEDURE usp_Unidades__Insert
GO
CREATE PROCEDURE usp_Unidades__Insert
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
 
	,@Codigo                                                   VARCHAR(8)
	,@Nombre                                                   VARCHAR(50)
	,@Observaciones                                            VARCHAR(1000) = NULL
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
	,@id						INT		OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Unidades'
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
			INSERT INTO Unidades
			(
				Codigo
				,Nombre
				,Observaciones
			)
			VALUES
			(
				@Codigo
				,@Nombre
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
 
 
 
 
IF (OBJECT_ID('usp_Unidades__Update_by_@id') IS NOT NULL) DROP PROCEDURE usp_Unidades__Update_by_@id
GO
CREATE PROCEDURE usp_Unidades__Update_by_@id
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- 
	 -------------
	 @id						INT
 
	,@UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) = NULL
	,@Seccion					VARCHAR(30) = NULL
	,@CodigoDelContexto			VARCHAR(40) = NULL
 
	,@Codigo                                                   VARCHAR(8)
	,@Nombre                                                   VARCHAR(50)
	,@Observaciones                                            VARCHAR(1000)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Unidades'
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
			UPDATE Unidades
			SET
				Codigo = @Codigo
				,Nombre = @Nombre
				,Observaciones = @Observaciones
			FROM Unidades
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
-- SP-TABLA: Unidades /ABMs/ - FIN
 
 
 
 
-- ---------------------------
-- Script: DB_ParticularCore__C11a_ABMs Generados Automaticamente - v10.7 - FIN
-- ==========================================================================================================
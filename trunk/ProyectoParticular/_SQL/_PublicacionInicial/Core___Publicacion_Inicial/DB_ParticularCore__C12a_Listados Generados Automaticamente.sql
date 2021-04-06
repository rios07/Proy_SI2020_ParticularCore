﻿-- ==========================================================================================================
-- Descripción: SPs de Listados generados automáticamente en función de los parámetros seteados en cada tabla.
-- Script: DB_ParticularCore__C12a_Listados Generados Automaticamente - v10.8 - INICIO
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
			-- ImportanciasDeTareas
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
			-- RelAsig_Subsistemas_A_Publicaciones
			-- RelAsig_Usuarios_A_Recursos
			-- ReservasDeRecursos
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
			-- Ubicaciones
			-- Unidades
		-- Tablas Involucradas: - FIN
 
 
-- SP-TABLA: Actores /Listados/ - INICIO
IF (OBJECT_ID('usp_Actores__Listado') IS NOT NULL) DROP PROCEDURE usp_Actores__Listado
GO
CREATE PROCEDURE usp_Actores__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@Activo                                                   BIT = '1'
	,@TipoDeActorId                                            INT = '-1' -- FiltroDDL (FK)
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Actores'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT ACT.id
						,ACT.TipoDeActorId
						,ACT.Codigo
						,ACT.Nombre
						,ACT.Email
						,ACT.Email2
						,ACT.Telefono
						,ACT.Telefono2
						,ACT.Direccion
						,ACT.Activo
						,TDA.Nombre AS TipoDeActor
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN ACT.Nombre END 
								,CASE WHEN @OrdenarPor = 'Codigo' AND @Sentido = '0' THEN ACT.Codigo END
								,CASE WHEN @OrdenarPor = 'Codigo' AND @Sentido = '1' THEN ACT.Codigo END DESC
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN ACT.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN ACT.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Email' AND @Sentido = '0' THEN ACT.Email END
								,CASE WHEN @OrdenarPor = 'Email' AND @Sentido = '1' THEN ACT.Email END DESC
								,CASE WHEN @OrdenarPor = 'Email2' AND @Sentido = '0' THEN ACT.Email2 END
								,CASE WHEN @OrdenarPor = 'Email2' AND @Sentido = '1' THEN ACT.Email2 END DESC
								,CASE WHEN @OrdenarPor = 'Telefono' AND @Sentido = '0' THEN ACT.Telefono END
								,CASE WHEN @OrdenarPor = 'Telefono' AND @Sentido = '1' THEN ACT.Telefono END DESC
								,CASE WHEN @OrdenarPor = 'Telefono2' AND @Sentido = '0' THEN ACT.Telefono2 END
								,CASE WHEN @OrdenarPor = 'Telefono2' AND @Sentido = '1' THEN ACT.Telefono2 END DESC
								,CASE WHEN @OrdenarPor = 'Direccion' AND @Sentido = '0' THEN ACT.Direccion END
								,CASE WHEN @OrdenarPor = 'Direccion' AND @Sentido = '1' THEN ACT.Direccion END DESC
								,CASE WHEN @OrdenarPor = 'TipoDeActor' AND @Sentido = '0' THEN TDA.Nombre END
								,CASE WHEN @OrdenarPor = 'TipoDeActor' AND @Sentido = '1' THEN TDA.Nombre END DESC
						) AS NumeroDeRegistro
					FROM Actores AS ACT
						INNER JOIN Contextos CX ON CX.id = ACT.ContextoId
						INNER JOIN TiposDeActores TDA ON TDA.id = ACT.TipoDeActorId
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = ACT.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(ACT.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (ACT.ContextoId = @ContextoId OR @ContextoId = '-1')
						AND (ACT.Activo = @Activo OR @Activo IS NULL)
						AND (ACT.TipoDeActorId = @TipoDeActorId OR @TipoDeActorId = '-1') -- FiltroDDL (FK)
						AND
						(
							(@Filtro = '')
							OR (ACT.Codigo LIKE '%' + @Filtro + '%')
							OR (ACT.Nombre LIKE '%' + @Filtro + '%')
							OR (ACT.Email LIKE '%' + @Filtro + '%')
							OR (ACT.Email2 LIKE '%' + @Filtro + '%')
							OR (ACT.Telefono LIKE '%' + @Filtro + '%')
							OR (ACT.Telefono2 LIKE '%' + @Filtro + '%')
							OR (ACT.Direccion LIKE '%' + @Filtro + '%')
							OR (TDA.Nombre LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_Actores__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_Actores__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_Actores__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
	,@Activo                                                   BIT = '1'
 
	,@TipoDeActorId                                            INT = '-1' -- FiltroDDL (FK)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Actores'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SELECT ACT.id
				,CAST(ACT.Nombre AS VARCHAR(MAX)) + ' [' + CAST(ACT.Codigo AS VARCHAR(MAX)) + ']' AS Nombre
			FROM Actores AS ACT
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(ACT.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					AND (ACT.TipoDeActorId = @TipoDeActorId OR @TipoDeActorId = '-1') -- FiltroDDL (FK)
					 AND (ACT.Activo = @Activo OR @Activo IS NULL)
					 AND (ACT.ContextoId = @ContextoId OR @ContextoId = '-1')
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (ACT.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY ACT.Nombre, ACT.Codigo
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: Actores /Listados/ - FIN
 
 
 
 
-- SP-TABLA: CategoriasDeInformes /Listados/ - INICIO
IF (OBJECT_ID('usp_CategoriasDeInformes__Listado') IS NOT NULL) DROP PROCEDURE usp_CategoriasDeInformes__Listado
GO
CREATE PROCEDURE usp_CategoriasDeInformes__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@Activo                                                   BIT = '1'
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'CategoriasDeInformes'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT CDI.id
						,CDI.Nombre
						,CDI.Observaciones
						,CDI.Activo
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN CDI.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN CDI.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN CDI.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '0' THEN CDI.Observaciones END
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '1' THEN CDI.Observaciones END DESC
						) AS NumeroDeRegistro
					FROM CategoriasDeInformes AS CDI
						INNER JOIN Contextos CX ON CX.id = CDI.ContextoId
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = CDI.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(CDI.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (CDI.ContextoId = @ContextoId OR @ContextoId = '-1')
						AND (CDI.Activo = @Activo OR @Activo IS NULL)
						AND
						(
							(@Filtro = '')
							OR (CDI.Nombre LIKE '%' + @Filtro + '%')
							OR (CDI.Observaciones LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_CategoriasDeInformes__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_CategoriasDeInformes__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_CategoriasDeInformes__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
	,@Activo                                                   BIT = '1'
 
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'CategoriasDeInformes'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SELECT CDI.id
				,CAST(CDI.Nombre AS VARCHAR(MAX)) AS Nombre
			FROM CategoriasDeInformes AS CDI
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(CDI.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					 AND (CDI.Activo = @Activo OR @Activo IS NULL)
					 AND (CDI.ContextoId = @ContextoId OR @ContextoId = '-1')
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (CDI.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY CDI.Nombre
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: CategoriasDeInformes /Listados/ - FIN
 
 
 
 
-- SP-TABLA: Contextos /Listados/ - INICIO
IF (OBJECT_ID('usp_Contextos__Listado') IS NOT NULL) DROP PROCEDURE usp_Contextos__Listado
GO
CREATE PROCEDURE usp_Contextos__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Contextos'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT CX.id
						,CX.Numero
						,CX.Nombre
						,CX.Codigo
						,CX.CarpetaDeContenidos
						,CX.Observaciones
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN CX.Nombre END 
								,CASE WHEN @OrdenarPor = 'Numero' AND @Sentido = '0' THEN CX.Numero END
								,CASE WHEN @OrdenarPor = 'Numero' AND @Sentido = '1' THEN CX.Numero END DESC
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN CX.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN CX.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Codigo' AND @Sentido = '0' THEN CX.Codigo END
								,CASE WHEN @OrdenarPor = 'Codigo' AND @Sentido = '1' THEN CX.Codigo END DESC
								,CASE WHEN @OrdenarPor = 'CarpetaDeContenidos' AND @Sentido = '0' THEN CX.CarpetaDeContenidos END
								,CASE WHEN @OrdenarPor = 'CarpetaDeContenidos' AND @Sentido = '1' THEN CX.CarpetaDeContenidos END DESC
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '0' THEN CX.Observaciones END
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '1' THEN CX.Observaciones END DESC
						) AS NumeroDeRegistro
					FROM Contextos AS CX
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = CX.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(CX.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND
						(
							(@Filtro = '')
							OR (CX.Numero LIKE '%' + @Filtro + '%')
							OR (CX.Nombre LIKE '%' + @Filtro + '%')
							OR (CX.Codigo LIKE '%' + @Filtro + '%')
							OR (CX.CarpetaDeContenidos LIKE '%' + @Filtro + '%')
							OR (CX.Observaciones LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_Contextos__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_Contextos__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_Contextos__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Contextos'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT CX.id
				,CAST(CX.Nombre AS VARCHAR(MAX)) + ' [' + CAST(CX.Codigo AS VARCHAR(MAX)) + ']' AS Nombre
			FROM Contextos AS CX
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(CX.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (CX.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY CX.Nombre, CX.Codigo
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: Contextos /Listados/ - FIN
 
 
 
 
-- SP-TABLA: CuentasDeEnvios /Listados/ - INICIO
IF (OBJECT_ID('usp_CuentasDeEnvios__Listado') IS NOT NULL) DROP PROCEDURE usp_CuentasDeEnvios__Listado
GO
CREATE PROCEDURE usp_CuentasDeEnvios__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'CuentasDeEnvios'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT CDE.id
						,CDE.Nombre
						,CDE.CuentaDeEmail
						,CDE.PwdDeEmail
						,CDE.Smtp
						,CDE.Puerto
						,CDE.Observaciones
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN CDE.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN CDE.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN CDE.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'CuentaDeEmail' AND @Sentido = '0' THEN CDE.CuentaDeEmail END
								,CASE WHEN @OrdenarPor = 'CuentaDeEmail' AND @Sentido = '1' THEN CDE.CuentaDeEmail END DESC
								,CASE WHEN @OrdenarPor = 'PwdDeEmail' AND @Sentido = '0' THEN CDE.PwdDeEmail END
								,CASE WHEN @OrdenarPor = 'PwdDeEmail' AND @Sentido = '1' THEN CDE.PwdDeEmail END DESC
								,CASE WHEN @OrdenarPor = 'Smtp' AND @Sentido = '0' THEN CDE.Smtp END
								,CASE WHEN @OrdenarPor = 'Smtp' AND @Sentido = '1' THEN CDE.Smtp END DESC
								,CASE WHEN @OrdenarPor = 'Puerto' AND @Sentido = '0' THEN CDE.Puerto END
								,CASE WHEN @OrdenarPor = 'Puerto' AND @Sentido = '1' THEN CDE.Puerto END DESC
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '0' THEN CDE.Observaciones END
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '1' THEN CDE.Observaciones END DESC
						) AS NumeroDeRegistro
					FROM CuentasDeEnvios AS CDE
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = CDE.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(CDE.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND
						(
							(@Filtro = '')
							OR (CDE.Nombre LIKE '%' + @Filtro + '%')
							OR (CDE.CuentaDeEmail LIKE '%' + @Filtro + '%')
							OR (CDE.PwdDeEmail LIKE '%' + @Filtro + '%')
							OR (CDE.Smtp LIKE '%' + @Filtro + '%')
							OR (CDE.Puerto LIKE '%' + @Filtro + '%')
							OR (CDE.Observaciones LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_CuentasDeEnvios__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_CuentasDeEnvios__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_CuentasDeEnvios__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'CuentasDeEnvios'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT CDE.id
				,CAST(CDE.Nombre AS VARCHAR(MAX)) AS Nombre
			FROM CuentasDeEnvios AS CDE
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(CDE.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (CDE.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY CDE.Nombre
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: CuentasDeEnvios /Listados/ - FIN
 
 
 
 
-- SP-TABLA: Dispositivos /Listados/ - INICIO
IF (OBJECT_ID('usp_Dispositivos__Listado') IS NOT NULL) DROP PROCEDURE usp_Dispositivos__Listado
GO
CREATE PROCEDURE usp_Dispositivos__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@ClavePrivadaEntregada                                    BIT = NULL
	,@ClavePrivadaFechaEntregaDesde                            DATETIME = NULL
	,@ClavePrivadaFechaEntregaHasta                            DATETIME = NULL
	,@Activo                                                   BIT = '1'
	,@AsignadoAUsuarioId                                       INT = '-1' -- FiltroDDL (FK)
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Dispositivos'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT DISP.id
						,DISP.AsignadoAUsuarioId
						,DISP.MachineName
						,DISP.OSVersion
						,DISP.UserMachineName
						,DISP.ClavePrivada
						,DISP.ClavePrivadaEntregada
						,DISP.ClavePrivadaFechaEntrega
						,dbo.ufc_Fechas__FormatoFechaComoTexto(DISP.ClavePrivadaFechaEntrega) AS ClavePrivadaFechaEntregaFormateado
						,DISP.Activo
						,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS AsignadoAUsuario
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN DISP.UserMachineName END 
								,CASE WHEN @OrdenarPor = 'MachineName' AND @Sentido = '0' THEN DISP.MachineName END
								,CASE WHEN @OrdenarPor = 'MachineName' AND @Sentido = '1' THEN DISP.MachineName END DESC
								,CASE WHEN @OrdenarPor = 'OSVersion' AND @Sentido = '0' THEN DISP.OSVersion END
								,CASE WHEN @OrdenarPor = 'OSVersion' AND @Sentido = '1' THEN DISP.OSVersion END DESC
								,CASE WHEN @OrdenarPor = 'UserMachineName' AND @Sentido = '0' THEN DISP.UserMachineName END
								,CASE WHEN @OrdenarPor = 'UserMachineName' AND @Sentido = '1' THEN DISP.UserMachineName END DESC
								,CASE WHEN @OrdenarPor = 'ClavePrivada' AND @Sentido = '0' THEN DISP.ClavePrivada END
								,CASE WHEN @OrdenarPor = 'ClavePrivada' AND @Sentido = '1' THEN DISP.ClavePrivada END DESC
								,CASE WHEN @OrdenarPor = 'ClavePrivadaFechaEntrega' AND @Sentido = '0' THEN DISP.ClavePrivadaFechaEntrega END
								,CASE WHEN @OrdenarPor = 'ClavePrivadaFechaEntrega' AND @Sentido = '1' THEN DISP.ClavePrivadaFechaEntrega END DESC
								,CASE WHEN @OrdenarPor = 'ClavePrivadaFechaEntregaFormateado' AND @Sentido = '0' THEN DISP.ClavePrivadaFechaEntrega END
								,CASE WHEN @OrdenarPor = 'ClavePrivadaFechaEntregaFormateado' AND @Sentido = '1' THEN DISP.ClavePrivadaFechaEntrega END DESC
								,CASE WHEN @OrdenarPor = 'AsignadoAUsuario' AND @Sentido = '0' THEN U.Apellido END
								,CASE WHEN @OrdenarPor = 'AsignadoAUsuario' AND @Sentido = '0' THEN U.Nombre END
								,CASE WHEN @OrdenarPor = 'AsignadoAUsuario' AND @Sentido = '1' THEN U.Apellido END DESC
								,CASE WHEN @OrdenarPor = 'AsignadoAUsuario' AND @Sentido = '1' THEN U.Nombre END DESC
						) AS NumeroDeRegistro
					FROM Dispositivos AS DISP
						INNER JOIN Usuarios U ON U.id = DISP.AsignadoAUsuarioId
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = DISP.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(DISP.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (DISP.ClavePrivadaEntregada = @ClavePrivadaEntregada OR @ClavePrivadaEntregada IS NULL)
						AND (DISP.ClavePrivadaFechaEntrega >= @ClavePrivadaFechaEntregaDesde OR @ClavePrivadaFechaEntregaDesde IS NULL)
						AND (DISP.ClavePrivadaFechaEntrega <= @ClavePrivadaFechaEntregaHasta OR @ClavePrivadaFechaEntregaHasta IS NULL)
						AND (DISP.Activo = @Activo OR @Activo IS NULL)
						AND (DISP.AsignadoAUsuarioId = @AsignadoAUsuarioId OR @AsignadoAUsuarioId = '-1') -- FiltroDDL (FK)
						AND
						(
							(@Filtro = '')
							OR (DISP.MachineName LIKE '%' + @Filtro + '%')
							OR (DISP.OSVersion LIKE '%' + @Filtro + '%')
							OR (DISP.UserMachineName LIKE '%' + @Filtro + '%')
							OR (DISP.ClavePrivada LIKE '%' + @Filtro + '%')
							OR (DISP.ClavePrivadaFechaEntrega LIKE '%' + @Filtro + '%')
							OR (U.Apellido LIKE '%' + @Filtro + '%')
							OR (U.Nombre LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_Dispositivos__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_Dispositivos__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_Dispositivos__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
	,@Activo                                                   BIT = '1'
 
	,@AsignadoAUsuarioId                                       INT = '-1' -- FiltroDDL (FK)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Dispositivos'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT DISP.id
				,CAST(DISP.UserMachineName AS VARCHAR(MAX)) AS UserMachineName
			FROM Dispositivos AS DISP
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(DISP.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					AND (DISP.AsignadoAUsuarioId = @AsignadoAUsuarioId OR @AsignadoAUsuarioId = '-1') -- FiltroDDL (FK)
					 AND (DISP.Activo = @Activo OR @Activo IS NULL)
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (DISP.UserMachineName LIKE '%' + @Filtro + '%')
				)
			ORDER BY DISP.UserMachineName
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: Dispositivos /Listados/ - FIN
 
 
 
 
-- SP-TABLA: EnviosDeCorreos /Listados/ - INICIO
IF (OBJECT_ID('usp_EnviosDeCorreos__Listado') IS NOT NULL) DROP PROCEDURE usp_EnviosDeCorreos__Listado
GO
CREATE PROCEDURE usp_EnviosDeCorreos__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@FechaPactadaDeEnvioDesde                                 DATETIME = NULL
	,@FechaPactadaDeEnvioHasta                                 DATETIME = NULL
	,@Activo                                                   BIT = '1'
	,@TablaId                                                  INT = '-1' -- FiltroDDL (FK)
	,@UsuarioOriginanteId                                      INT = '-1' -- FiltroDDL (FK)
	,@UsuarioDestinatarioId                                    INT = '-1' -- FiltroDDL (FK)
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'EnviosDeCorreos'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT EDC.id
						,EDC.UsuarioOriginanteId
						,EDC.UsuarioDestinatarioId
						,EDC.TablaId
						,EDC.RegistroId
						,EDC.EmailDeDestino
						,EDC.Asunto
						,EDC.Contenido
						,EDC.FechaPactadaDeEnvio
						,dbo.ufc_Fechas__FormatoFechaComoTexto(EDC.FechaPactadaDeEnvio) AS FechaPactadaDeEnvioFormateado
						,EDC.Activo
						,T.Nombre AS Tabla
						,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS UsuarioOriginante
						,dbo.ufc_Usuarios__NombreCompletoFormateado(U3.id) AS UsuarioDestinatario
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN EDC.Asunto END 
								,CASE WHEN @OrdenarPor = 'RegistroId' AND @Sentido = '0' THEN EDC.RegistroId END
								,CASE WHEN @OrdenarPor = 'RegistroId' AND @Sentido = '1' THEN EDC.RegistroId END DESC
								,CASE WHEN @OrdenarPor = 'EmailDeDestino' AND @Sentido = '0' THEN EDC.EmailDeDestino END
								,CASE WHEN @OrdenarPor = 'EmailDeDestino' AND @Sentido = '1' THEN EDC.EmailDeDestino END DESC
								,CASE WHEN @OrdenarPor = 'Asunto' AND @Sentido = '0' THEN EDC.Asunto END
								,CASE WHEN @OrdenarPor = 'Asunto' AND @Sentido = '1' THEN EDC.Asunto END DESC
								,CASE WHEN @OrdenarPor = 'Contenido' AND @Sentido = '0' THEN EDC.Contenido END
								,CASE WHEN @OrdenarPor = 'Contenido' AND @Sentido = '1' THEN EDC.Contenido END DESC
								,CASE WHEN @OrdenarPor = 'FechaPactadaDeEnvio' AND @Sentido = '0' THEN EDC.FechaPactadaDeEnvio END
								,CASE WHEN @OrdenarPor = 'FechaPactadaDeEnvio' AND @Sentido = '1' THEN EDC.FechaPactadaDeEnvio END DESC
								,CASE WHEN @OrdenarPor = 'FechaPactadaDeEnvioFormateado' AND @Sentido = '0' THEN EDC.FechaPactadaDeEnvio END
								,CASE WHEN @OrdenarPor = 'FechaPactadaDeEnvioFormateado' AND @Sentido = '1' THEN EDC.FechaPactadaDeEnvio END DESC
								,CASE WHEN @OrdenarPor = 'Tabla' AND @Sentido = '0' THEN T.Nombre END
								,CASE WHEN @OrdenarPor = 'Tabla' AND @Sentido = '1' THEN T.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'UsuarioOriginante' AND @Sentido = '0' THEN U.Apellido END
								,CASE WHEN @OrdenarPor = 'UsuarioOriginante' AND @Sentido = '0' THEN U.Nombre END
								,CASE WHEN @OrdenarPor = 'UsuarioOriginante' AND @Sentido = '1' THEN U.Apellido END DESC
								,CASE WHEN @OrdenarPor = 'UsuarioOriginante' AND @Sentido = '1' THEN U.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'UsuarioDestinatario' AND @Sentido = '0' THEN U3.Apellido END
								,CASE WHEN @OrdenarPor = 'UsuarioDestinatario' AND @Sentido = '0' THEN U3.Nombre END
								,CASE WHEN @OrdenarPor = 'UsuarioDestinatario' AND @Sentido = '1' THEN U3.Apellido END DESC
								,CASE WHEN @OrdenarPor = 'UsuarioDestinatario' AND @Sentido = '1' THEN U3.Nombre END DESC
						) AS NumeroDeRegistro
					FROM EnviosDeCorreos AS EDC
						INNER JOIN Tablas T ON T.id = EDC.TablaId
						INNER JOIN Usuarios U ON U.id = EDC.UsuarioOriginanteId
						INNER JOIN Usuarios U3 ON U3.id = EDC.UsuarioDestinatarioId
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = EDC.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(EDC.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (EDC.FechaPactadaDeEnvio >= @FechaPactadaDeEnvioDesde OR @FechaPactadaDeEnvioDesde IS NULL)
						AND (EDC.FechaPactadaDeEnvio <= @FechaPactadaDeEnvioHasta OR @FechaPactadaDeEnvioHasta IS NULL)
						AND (EDC.Activo = @Activo OR @Activo IS NULL)
						AND (EDC.TablaId = @TablaId OR @TablaId = '-1') -- FiltroDDL (FK)
						AND (EDC.UsuarioOriginanteId = @UsuarioOriginanteId OR @UsuarioOriginanteId = '-1') -- FiltroDDL (FK)
						AND (EDC.UsuarioDestinatarioId = @UsuarioDestinatarioId OR @UsuarioDestinatarioId = '-1') -- FiltroDDL (FK)
						AND
						(
							(@Filtro = '')
							OR (EDC.RegistroId LIKE '%' + @Filtro + '%')
							OR (EDC.EmailDeDestino LIKE '%' + @Filtro + '%')
							OR (EDC.Asunto LIKE '%' + @Filtro + '%')
							OR (EDC.Contenido LIKE '%' + @Filtro + '%')
							OR (EDC.FechaPactadaDeEnvio LIKE '%' + @Filtro + '%')
							OR (T.Nombre LIKE '%' + @Filtro + '%')
							OR (U.Apellido LIKE '%' + @Filtro + '%')
							OR (U.Nombre LIKE '%' + @Filtro + '%')
							OR (U3.Apellido LIKE '%' + @Filtro + '%')
							OR (U3.Nombre LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_EnviosDeCorreos__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_EnviosDeCorreos__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_EnviosDeCorreos__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
	,@Activo                                                   BIT = '1'
 
	,@TablaId                                                  INT = '-1' -- FiltroDDL (FK)
	,@UsuarioOriginanteId                                      INT = '-1' -- FiltroDDL (FK)
	,@UsuarioDestinatarioId                                    INT = '-1' -- FiltroDDL (FK)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'EnviosDeCorreos'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT EDC.id
				,CAST(EDC.Asunto AS VARCHAR(MAX)) AS Asunto
			FROM EnviosDeCorreos AS EDC
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(EDC.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					AND (EDC.TablaId = @TablaId OR @TablaId = '-1') -- FiltroDDL (FK)
					AND (EDC.UsuarioOriginanteId = @UsuarioOriginanteId OR @UsuarioOriginanteId = '-1') -- FiltroDDL (FK)
					AND (EDC.UsuarioDestinatarioId = @UsuarioDestinatarioId OR @UsuarioDestinatarioId = '-1') -- FiltroDDL (FK)
					 AND (EDC.Activo = @Activo OR @Activo IS NULL)
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (EDC.Asunto LIKE '%' + @Filtro + '%')
				)
			ORDER BY EDC.Asunto
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: EnviosDeCorreos /Listados/ - FIN
 
 
 
 
-- SP-TABLA: EstadosDeLogErrores /Listados/ - INICIO
IF (OBJECT_ID('usp_EstadosDeLogErrores__Listado') IS NOT NULL) DROP PROCEDURE usp_EstadosDeLogErrores__Listado
GO
CREATE PROCEDURE usp_EstadosDeLogErrores__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'EstadosDeLogErrores'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT EDLE.id
						,EDLE.Nombre
						,EDLE.Nomenclatura
						,EDLE.Orden
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN EDLE.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN EDLE.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN EDLE.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Nomenclatura' AND @Sentido = '0' THEN EDLE.Nomenclatura END
								,CASE WHEN @OrdenarPor = 'Nomenclatura' AND @Sentido = '1' THEN EDLE.Nomenclatura END DESC
								,CASE WHEN @OrdenarPor = 'Orden' AND @Sentido = '0' THEN EDLE.Orden END
								,CASE WHEN @OrdenarPor = 'Orden' AND @Sentido = '1' THEN EDLE.Orden END DESC
						) AS NumeroDeRegistro
					FROM EstadosDeLogErrores AS EDLE
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = EDLE.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(EDLE.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND
						(
							(@Filtro = '')
							OR (EDLE.Nombre LIKE '%' + @Filtro + '%')
							OR (EDLE.Nomenclatura LIKE '%' + @Filtro + '%')
							OR (EDLE.Orden LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_EstadosDeLogErrores__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_EstadosDeLogErrores__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_EstadosDeLogErrores__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'EstadosDeLogErrores'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT EDLE.id
				,'[' + EDLE.Nomenclatura + ']: ' + CAST(EDLE.Nombre AS VARCHAR(MAX)) AS Nombre
			FROM EstadosDeLogErrores AS EDLE
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(EDLE.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (EDLE.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY EDLE.Nomenclatura, EDLE.Nombre
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: EstadosDeLogErrores /Listados/ - FIN
 
 
 
 
-- SP-TABLA: EstadosDeSoportes /Listados/ - INICIO
IF (OBJECT_ID('usp_EstadosDeSoportes__Listado') IS NOT NULL) DROP PROCEDURE usp_EstadosDeSoportes__Listado
GO
CREATE PROCEDURE usp_EstadosDeSoportes__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@CierraSoporte                                            BIT = NULL
	,@Activo                                                   BIT = '1'
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'EstadosDeSoportes'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT EDS.id
						,EDS.Nombre
						,EDS.Nomenclatura
						,EDS.Orden
						,EDS.CierraSoporte
						,EDS.Activo
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN EDS.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN EDS.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN EDS.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Nomenclatura' AND @Sentido = '0' THEN EDS.Nomenclatura END
								,CASE WHEN @OrdenarPor = 'Nomenclatura' AND @Sentido = '1' THEN EDS.Nomenclatura END DESC
								,CASE WHEN @OrdenarPor = 'Orden' AND @Sentido = '0' THEN EDS.Orden END
								,CASE WHEN @OrdenarPor = 'Orden' AND @Sentido = '1' THEN EDS.Orden END DESC
						) AS NumeroDeRegistro
					FROM EstadosDeSoportes AS EDS
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = EDS.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(EDS.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (EDS.CierraSoporte = @CierraSoporte OR @CierraSoporte IS NULL)
						AND (EDS.Activo = @Activo OR @Activo IS NULL)
						AND
						(
							(@Filtro = '')
							OR (EDS.Nombre LIKE '%' + @Filtro + '%')
							OR (EDS.Nomenclatura LIKE '%' + @Filtro + '%')
							OR (EDS.Orden LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_EstadosDeSoportes__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_EstadosDeSoportes__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_EstadosDeSoportes__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
	,@Activo                                                   BIT = '1'
 
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'EstadosDeSoportes'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT EDS.id
				,'[' + EDS.Nomenclatura + ']: ' + CAST(EDS.Nombre AS VARCHAR(MAX)) AS Nombre
			FROM EstadosDeSoportes AS EDS
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(EDS.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					 AND (EDS.Activo = @Activo OR @Activo IS NULL)
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (EDS.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY EDS.Nomenclatura, EDS.Nombre
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: EstadosDeSoportes /Listados/ - FIN
 
 
 
 
-- SP-TABLA: EstadosDeTareas /Listados/ - INICIO
IF (OBJECT_ID('usp_EstadosDeTareas__Listado') IS NOT NULL) DROP PROCEDURE usp_EstadosDeTareas__Listado
GO
CREATE PROCEDURE usp_EstadosDeTareas__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@Activo                                                   BIT = '1'
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'EstadosDeTareas'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT EDT.id
						,EDT.Nombre
						,EDT.Nomenclatura
						,EDT.Orden
						,EDT.Activo
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN EDT.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN EDT.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN EDT.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Nomenclatura' AND @Sentido = '0' THEN EDT.Nomenclatura END
								,CASE WHEN @OrdenarPor = 'Nomenclatura' AND @Sentido = '1' THEN EDT.Nomenclatura END DESC
								,CASE WHEN @OrdenarPor = 'Orden' AND @Sentido = '0' THEN EDT.Orden END
								,CASE WHEN @OrdenarPor = 'Orden' AND @Sentido = '1' THEN EDT.Orden END DESC
						) AS NumeroDeRegistro
					FROM EstadosDeTareas AS EDT
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = EDT.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(EDT.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (EDT.Activo = @Activo OR @Activo IS NULL)
						AND
						(
							(@Filtro = '')
							OR (EDT.Nombre LIKE '%' + @Filtro + '%')
							OR (EDT.Nomenclatura LIKE '%' + @Filtro + '%')
							OR (EDT.Orden LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_EstadosDeTareas__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_EstadosDeTareas__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_EstadosDeTareas__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
	,@Activo                                                   BIT = '1'
 
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'EstadosDeTareas'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT EDT.id
				,'[' + EDT.Nomenclatura + ']: ' + CAST(EDT.Nombre AS VARCHAR(MAX)) AS Nombre
			FROM EstadosDeTareas AS EDT
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(EDT.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					 AND (EDT.Activo = @Activo OR @Activo IS NULL)
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (EDT.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY EDT.Nomenclatura, EDT.Nombre
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: EstadosDeTareas /Listados/ - FIN
 
 
 
 
-- SP-TABLA: ExtensionesDeArchivos /Listados/ - INICIO
IF (OBJECT_ID('usp_ExtensionesDeArchivos__Listado') IS NOT NULL) DROP PROCEDURE usp_ExtensionesDeArchivos__Listado
GO
CREATE PROCEDURE usp_ExtensionesDeArchivos__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@IconoId                                                  INT = '-1' -- FiltroDDL (FK)
	,@TipoDeArchivoId                                          INT = '-1' -- FiltroDDL (FK)
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'ExtensionesDeArchivos'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT EDA.id
						,EDA.Nombre
						,EDA.IconoId
						,EDA.TipoDeArchivoId
						,EDA.ProgramaAsociado
						,IC.Nombre AS Icono
						,TDARCH.Nombre AS TipoDeArchivo
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN EDA.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN EDA.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN EDA.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'ProgramaAsociado' AND @Sentido = '0' THEN EDA.ProgramaAsociado END
								,CASE WHEN @OrdenarPor = 'ProgramaAsociado' AND @Sentido = '1' THEN EDA.ProgramaAsociado END DESC
								,CASE WHEN @OrdenarPor = 'Icono' AND @Sentido = '0' THEN IC.Nombre END
								,CASE WHEN @OrdenarPor = 'Icono' AND @Sentido = '1' THEN IC.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'TipoDeArchivo' AND @Sentido = '0' THEN TDARCH.Nombre END
								,CASE WHEN @OrdenarPor = 'TipoDeArchivo' AND @Sentido = '1' THEN TDARCH.Nombre END DESC
						) AS NumeroDeRegistro
					FROM ExtensionesDeArchivos AS EDA
						INNER JOIN Iconos IC ON IC.id = EDA.IconoId
						INNER JOIN TiposDeArchivos TDARCH ON TDARCH.id = EDA.TipoDeArchivoId
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = EDA.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(EDA.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (EDA.IconoId = @IconoId OR @IconoId = '-1') -- FiltroDDL (FK)
						AND (EDA.TipoDeArchivoId = @TipoDeArchivoId OR @TipoDeArchivoId = '-1') -- FiltroDDL (FK)
						AND
						(
							(@Filtro = '')
							OR (EDA.Nombre LIKE '%' + @Filtro + '%')
							OR (EDA.ProgramaAsociado LIKE '%' + @Filtro + '%')
							OR (IC.Nombre LIKE '%' + @Filtro + '%')
							OR (TDARCH.Nombre LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_ExtensionesDeArchivos__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_ExtensionesDeArchivos__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_ExtensionesDeArchivos__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
	,@IconoId                                                  INT = '-1' -- FiltroDDL (FK)
	,@TipoDeArchivoId                                          INT = '-1' -- FiltroDDL (FK)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'ExtensionesDeArchivos'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT EDA.id
				,CAST(EDA.Nombre AS VARCHAR(MAX)) AS Nombre
			FROM ExtensionesDeArchivos AS EDA
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(EDA.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					AND (EDA.IconoId = @IconoId OR @IconoId = '-1') -- FiltroDDL (FK)
					AND (EDA.TipoDeArchivoId = @TipoDeArchivoId OR @TipoDeArchivoId = '-1') -- FiltroDDL (FK)
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (EDA.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY EDA.Nombre
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: ExtensionesDeArchivos /Listados/ - FIN
 
 
 
 
-- SP-TABLA: FuncionesDePaginas /Listados/ - INICIO
IF (OBJECT_ID('usp_FuncionesDePaginas__Listado') IS NOT NULL) DROP PROCEDURE usp_FuncionesDePaginas__Listado
GO
CREATE PROCEDURE usp_FuncionesDePaginas__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@GeneraPagina                                             BIT = NULL
	,@SeDebenEvaluarPermisos                                   BIT = NULL
	,@EsUnaConRegistro                                         BIT = NULL
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'FuncionesDePaginas'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT FDP.id
						,FDP.Nombre
						,FDP.NombreAMostrar
						,FDP.GeneraPagina
						,FDP.SeDebenEvaluarPermisos
						,FDP.EsUnaConRegistro
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN FDP.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN FDP.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN FDP.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'NombreAMostrar' AND @Sentido = '0' THEN FDP.NombreAMostrar END
								,CASE WHEN @OrdenarPor = 'NombreAMostrar' AND @Sentido = '1' THEN FDP.NombreAMostrar END DESC
						) AS NumeroDeRegistro
					FROM FuncionesDePaginas AS FDP
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = FDP.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(FDP.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (FDP.GeneraPagina = @GeneraPagina OR @GeneraPagina IS NULL)
						AND (FDP.SeDebenEvaluarPermisos = @SeDebenEvaluarPermisos OR @SeDebenEvaluarPermisos IS NULL)
						AND (FDP.EsUnaConRegistro = @EsUnaConRegistro OR @EsUnaConRegistro IS NULL)
						AND
						(
							(@Filtro = '')
							OR (FDP.Nombre LIKE '%' + @Filtro + '%')
							OR (FDP.NombreAMostrar LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_FuncionesDePaginas__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_FuncionesDePaginas__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_FuncionesDePaginas__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'FuncionesDePaginas'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT FDP.id
				,CAST(FDP.Nombre AS VARCHAR(MAX)) AS Nombre
			FROM FuncionesDePaginas AS FDP
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(FDP.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (FDP.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY FDP.Nombre
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: FuncionesDePaginas /Listados/ - FIN
 
 
 
 
-- SP-TABLA: Iconos /Listados/ - INICIO
IF (OBJECT_ID('usp_Iconos__Listado') IS NOT NULL) DROP PROCEDURE usp_Iconos__Listado
GO
CREATE PROCEDURE usp_Iconos__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@Activo                                                   BIT = '1'
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Iconos'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT IC.id
						,IC.Nombre
						,IC.Imagen
						,IC.Altura
						,IC.Ancho
						,IC.OffsetX
						,IC.OffsetY
						,IC.Activo
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN IC.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN IC.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN IC.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Imagen' AND @Sentido = '0' THEN IC.Imagen END
								,CASE WHEN @OrdenarPor = 'Imagen' AND @Sentido = '1' THEN IC.Imagen END DESC
								,CASE WHEN @OrdenarPor = 'Altura' AND @Sentido = '0' THEN IC.Altura END
								,CASE WHEN @OrdenarPor = 'Altura' AND @Sentido = '1' THEN IC.Altura END DESC
								,CASE WHEN @OrdenarPor = 'Ancho' AND @Sentido = '0' THEN IC.Ancho END
								,CASE WHEN @OrdenarPor = 'Ancho' AND @Sentido = '1' THEN IC.Ancho END DESC
								,CASE WHEN @OrdenarPor = 'OffsetX' AND @Sentido = '0' THEN IC.OffsetX END
								,CASE WHEN @OrdenarPor = 'OffsetX' AND @Sentido = '1' THEN IC.OffsetX END DESC
								,CASE WHEN @OrdenarPor = 'OffsetY' AND @Sentido = '0' THEN IC.OffsetY END
								,CASE WHEN @OrdenarPor = 'OffsetY' AND @Sentido = '1' THEN IC.OffsetY END DESC
						) AS NumeroDeRegistro
					FROM Iconos AS IC
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = IC.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(IC.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (IC.Activo = @Activo OR @Activo IS NULL)
						AND
						(
							(@Filtro = '')
							OR (IC.Nombre LIKE '%' + @Filtro + '%')
							OR (IC.Imagen LIKE '%' + @Filtro + '%')
							OR (IC.Altura LIKE '%' + @Filtro + '%')
							OR (IC.Ancho LIKE '%' + @Filtro + '%')
							OR (IC.OffsetX LIKE '%' + @Filtro + '%')
							OR (IC.OffsetY LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_Iconos__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_Iconos__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_Iconos__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
	,@Activo                                                   BIT = '1'
 
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Iconos'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT IC.id
				,CAST(IC.Nombre AS VARCHAR(MAX)) AS Nombre
			FROM Iconos AS IC
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(IC.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					 AND (IC.Activo = @Activo OR @Activo IS NULL)
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (IC.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY IC.Nombre
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: Iconos /Listados/ - FIN
 
 
 
 
-- SP-TABLA: IconosCSS /Listados/ - INICIO
IF (OBJECT_ID('usp_IconosCSS__Listado') IS NOT NULL) DROP PROCEDURE usp_IconosCSS__Listado
GO
CREATE PROCEDURE usp_IconosCSS__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'IconosCSS'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT ICSS.id
						,ICSS.Nombre
						,ICSS.CSS
						,ICSS.Observaciones
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN ICSS.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN ICSS.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN ICSS.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'CSS' AND @Sentido = '0' THEN ICSS.CSS END
								,CASE WHEN @OrdenarPor = 'CSS' AND @Sentido = '1' THEN ICSS.CSS END DESC
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '0' THEN ICSS.Observaciones END
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '1' THEN ICSS.Observaciones END DESC
						) AS NumeroDeRegistro
					FROM IconosCSS AS ICSS
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = ICSS.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(ICSS.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND
						(
							(@Filtro = '')
							OR (ICSS.Nombre LIKE '%' + @Filtro + '%')
							OR (ICSS.CSS LIKE '%' + @Filtro + '%')
							OR (ICSS.Observaciones LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_IconosCSS__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_IconosCSS__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_IconosCSS__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'IconosCSS'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT ICSS.id
				,CAST(ICSS.Nombre AS VARCHAR(MAX)) AS Nombre
			FROM IconosCSS AS ICSS
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(ICSS.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (ICSS.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY ICSS.Nombre
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: IconosCSS /Listados/ - FIN
 
 
 
 
-- SP-TABLA: ImportanciasDeTareas /Listados/ - INICIO
IF (OBJECT_ID('usp_ImportanciasDeTareas__Listado') IS NOT NULL) DROP PROCEDURE usp_ImportanciasDeTareas__Listado
GO
CREATE PROCEDURE usp_ImportanciasDeTareas__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'ImportanciasDeTareas'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT IDT.id
						,IDT.Nombre
						,IDT.Nomenclatura
						,IDT.Orden
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN IDT.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN IDT.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN IDT.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Nomenclatura' AND @Sentido = '0' THEN IDT.Nomenclatura END
								,CASE WHEN @OrdenarPor = 'Nomenclatura' AND @Sentido = '1' THEN IDT.Nomenclatura END DESC
								,CASE WHEN @OrdenarPor = 'Orden' AND @Sentido = '0' THEN IDT.Orden END
								,CASE WHEN @OrdenarPor = 'Orden' AND @Sentido = '1' THEN IDT.Orden END DESC
						) AS NumeroDeRegistro
					FROM ImportanciasDeTareas AS IDT
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = IDT.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(IDT.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND
						(
							(@Filtro = '')
							OR (IDT.Nombre LIKE '%' + @Filtro + '%')
							OR (IDT.Nomenclatura LIKE '%' + @Filtro + '%')
							OR (IDT.Orden LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_ImportanciasDeTareas__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_ImportanciasDeTareas__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_ImportanciasDeTareas__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'ImportanciasDeTareas'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT IDT.id
				,'[' + IDT.Nomenclatura + ']: ' + CAST(IDT.Nombre AS VARCHAR(MAX)) AS Nombre
			FROM ImportanciasDeTareas AS IDT
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(IDT.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (IDT.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY IDT.Nomenclatura, IDT.Nombre
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: ImportanciasDeTareas /Listados/ - FIN
 
 
 
 
-- SP-TABLA: LogErroresApp /Listados/ - INICIO
IF (OBJECT_ID('usp_LogErroresApp__Listado') IS NOT NULL) DROP PROCEDURE usp_LogErroresApp__Listado
GO
CREATE PROCEDURE usp_LogErroresApp__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@FechaDeEjecucionDesde                                    DATETIME = NULL
	,@FechaDeEjecucionHasta                                    DATETIME = NULL
	,@UsuarioId                                                INT = '-1' -- FiltroDDL (FK)
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogErroresApp'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT LEAPP.id
						,LEAPP.FechaDeEjecucion
						,dbo.ufc_Fechas__FormatoFechaComoTexto(LEAPP.FechaDeEjecucion) AS FechaDeEjecucionFormateado
						,LEAPP.TokenId
						,LEAPP.DispositivoMachineName
						,LEAPP.UsuarioId
						,LEAPP.Metodo
						,LEAPP.Clase
						,LEAPP.Linea
						,LEAPP.Texto
						,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS Usuario
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN LEAPP.FechaDeEjecucion END DESC
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucion' AND @Sentido = '0' THEN LEAPP.FechaDeEjecucion END
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucion' AND @Sentido = '1' THEN LEAPP.FechaDeEjecucion END DESC
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucionFormateado' AND @Sentido = '0' THEN LEAPP.FechaDeEjecucion END
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucionFormateado' AND @Sentido = '1' THEN LEAPP.FechaDeEjecucion END DESC
								,CASE WHEN @OrdenarPor = 'TokenId' AND @Sentido = '0' THEN LEAPP.TokenId END
								,CASE WHEN @OrdenarPor = 'TokenId' AND @Sentido = '1' THEN LEAPP.TokenId END DESC
								,CASE WHEN @OrdenarPor = 'DispositivoMachineName' AND @Sentido = '0' THEN LEAPP.DispositivoMachineName END
								,CASE WHEN @OrdenarPor = 'DispositivoMachineName' AND @Sentido = '1' THEN LEAPP.DispositivoMachineName END DESC
								,CASE WHEN @OrdenarPor = 'Metodo' AND @Sentido = '0' THEN LEAPP.Metodo END
								,CASE WHEN @OrdenarPor = 'Metodo' AND @Sentido = '1' THEN LEAPP.Metodo END DESC
								,CASE WHEN @OrdenarPor = 'Clase' AND @Sentido = '0' THEN LEAPP.Clase END
								,CASE WHEN @OrdenarPor = 'Clase' AND @Sentido = '1' THEN LEAPP.Clase END DESC
								,CASE WHEN @OrdenarPor = 'Linea' AND @Sentido = '0' THEN LEAPP.Linea END
								,CASE WHEN @OrdenarPor = 'Linea' AND @Sentido = '1' THEN LEAPP.Linea END DESC
								,CASE WHEN @OrdenarPor = 'Texto' AND @Sentido = '0' THEN LEAPP.Texto END
								,CASE WHEN @OrdenarPor = 'Texto' AND @Sentido = '1' THEN LEAPP.Texto END DESC
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '0' THEN U.Apellido END
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '0' THEN U.Nombre END
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '1' THEN U.Apellido END DESC
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '1' THEN U.Nombre END DESC
						) AS NumeroDeRegistro
					FROM LogErroresApp AS LEAPP
						LEFT JOIN Usuarios U ON U.id = LEAPP.UsuarioId -- OJO VA LEFT JOIN x que el campo puede ser NULL
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = LEAPP.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(LEAPP.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (LEAPP.FechaDeEjecucion >= @FechaDeEjecucionDesde OR @FechaDeEjecucionDesde IS NULL)
						AND (LEAPP.FechaDeEjecucion <= @FechaDeEjecucionHasta OR @FechaDeEjecucionHasta IS NULL)
						AND (LEAPP.UsuarioId = @UsuarioId OR @UsuarioId = '-1' OR (LEAPP.UsuarioId IS NULL AND @UsuarioId = '0')) -- FiltroDDL (FK) NULL
						AND
						(
							(@Filtro = '')
							OR (LEAPP.FechaDeEjecucion LIKE '%' + @Filtro + '%')
							OR (LEAPP.TokenId LIKE '%' + @Filtro + '%')
							OR (LEAPP.DispositivoMachineName LIKE '%' + @Filtro + '%')
							OR (LEAPP.Metodo LIKE '%' + @Filtro + '%')
							OR (LEAPP.Clase LIKE '%' + @Filtro + '%')
							OR (LEAPP.Linea LIKE '%' + @Filtro + '%')
							OR (LEAPP.Texto LIKE '%' + @Filtro + '%')
							OR (U.Apellido LIKE '%' + @Filtro + '%')
							OR (U.Nombre LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_LogErroresApp__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_LogErroresApp__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_LogErroresApp__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
	,@UsuarioId                                                INT = '-1' -- FiltroDDL (FK)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogErroresApp'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT LEAPP.id
				,CAST(LEAPP.FechaDeEjecucion AS VARCHAR(MAX)) AS FechaDeEjecucion
			FROM LogErroresApp AS LEAPP
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(LEAPP.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					AND (LEAPP.UsuarioId = @UsuarioId OR @UsuarioId = '-1' OR (LEAPP.UsuarioId IS NULL AND @UsuarioId = '0')) -- FiltroDDL (FK) NULL
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (LEAPP.FechaDeEjecucion LIKE '%' + @Filtro + '%')
				)
			ORDER BY LEAPP.FechaDeEjecucion
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: LogErroresApp /Listados/ - FIN
 
 
 
 
-- SP-TABLA: LogLogins /Listados/ - INICIO
IF (OBJECT_ID('usp_LogLogins__Listado') IS NOT NULL) DROP PROCEDURE usp_LogLogins__Listado
GO
CREATE PROCEDURE usp_LogLogins__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@FechaDeEjecucionDesde                                    DATETIME = NULL
	,@FechaDeEjecucionHasta                                    DATETIME = NULL
	,@DispositivoId                                            INT = '-1' -- FiltroDDL (FK)
	,@TipoDeLogLoginId                                         INT = '-1' -- FiltroDDL (FK)
	,@UsuarioId                                                INT = '-1' -- FiltroDDL (FK)
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogLogins'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT LL.id
						,LL.UsuarioId
						,LL.FechaDeEjecucion
						,dbo.ufc_Fechas__FormatoFechaComoTexto(LL.FechaDeEjecucion) AS FechaDeEjecucionFormateado
						,LL.UsuarioIngresado
						,LL.TipoDeLogLoginId
						,LL.DispositivoId
						,DISP.UserMachineName AS Dispositivo
						,TDLL.Nombre AS TipoDeLogLogin
						,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS Usuario
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN LL.FechaDeEjecucion END DESC
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucion' AND @Sentido = '0' THEN LL.FechaDeEjecucion END
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucion' AND @Sentido = '1' THEN LL.FechaDeEjecucion END DESC
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucionFormateado' AND @Sentido = '0' THEN LL.FechaDeEjecucion END
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucionFormateado' AND @Sentido = '1' THEN LL.FechaDeEjecucion END DESC
								,CASE WHEN @OrdenarPor = 'UsuarioIngresado' AND @Sentido = '0' THEN LL.UsuarioIngresado END
								,CASE WHEN @OrdenarPor = 'UsuarioIngresado' AND @Sentido = '1' THEN LL.UsuarioIngresado END DESC
								,CASE WHEN @OrdenarPor = 'Dispositivo' AND @Sentido = '0' THEN DISP.UserMachineName END
								,CASE WHEN @OrdenarPor = 'Dispositivo' AND @Sentido = '1' THEN DISP.UserMachineName END DESC
								,CASE WHEN @OrdenarPor = 'TipoDeLogLogin' AND @Sentido = '0' THEN TDLL.Nombre END
								,CASE WHEN @OrdenarPor = 'TipoDeLogLogin' AND @Sentido = '1' THEN TDLL.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '0' THEN U.Apellido END
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '0' THEN U.Nombre END
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '1' THEN U.Apellido END DESC
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '1' THEN U.Nombre END DESC
						) AS NumeroDeRegistro
					FROM LogLogins AS LL
						INNER JOIN Dispositivos DISP ON DISP.id = LL.DispositivoId
						INNER JOIN TiposDeLogLogins TDLL ON TDLL.id = LL.TipoDeLogLoginId
						INNER JOIN Usuarios U ON U.id = LL.UsuarioId
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = LL.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(LL.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (LL.FechaDeEjecucion >= @FechaDeEjecucionDesde OR @FechaDeEjecucionDesde IS NULL)
						AND (LL.FechaDeEjecucion <= @FechaDeEjecucionHasta OR @FechaDeEjecucionHasta IS NULL)
						AND (LL.DispositivoId = @DispositivoId OR @DispositivoId = '-1') -- FiltroDDL (FK)
						AND (LL.TipoDeLogLoginId = @TipoDeLogLoginId OR @TipoDeLogLoginId = '-1') -- FiltroDDL (FK)
						AND (LL.UsuarioId = @UsuarioId OR @UsuarioId = '-1') -- FiltroDDL (FK)
						AND
						(
							(@Filtro = '')
							OR (LL.FechaDeEjecucion LIKE '%' + @Filtro + '%')
							OR (LL.UsuarioIngresado LIKE '%' + @Filtro + '%')
							OR (DISP.UserMachineName LIKE '%' + @Filtro + '%')
							OR (TDLL.Nombre LIKE '%' + @Filtro + '%')
							OR (U.Apellido LIKE '%' + @Filtro + '%')
							OR (U.Nombre LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_LogLogins__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_LogLogins__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_LogLogins__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
	,@DispositivoId                                            INT = '-1' -- FiltroDDL (FK)
	,@TipoDeLogLoginId                                         INT = '-1' -- FiltroDDL (FK)
	,@UsuarioId                                                INT = '-1' -- FiltroDDL (FK)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogLogins'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT LL.id
				,CAST(LL.FechaDeEjecucion AS VARCHAR(MAX)) AS FechaDeEjecucion
			FROM LogLogins AS LL
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(LL.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					AND (LL.DispositivoId = @DispositivoId OR @DispositivoId = '-1') -- FiltroDDL (FK)
					AND (LL.TipoDeLogLoginId = @TipoDeLogLoginId OR @TipoDeLogLoginId = '-1') -- FiltroDDL (FK)
					AND (LL.UsuarioId = @UsuarioId OR @UsuarioId = '-1') -- FiltroDDL (FK)
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (LL.FechaDeEjecucion LIKE '%' + @Filtro + '%')
				)
			ORDER BY LL.FechaDeEjecucion
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: LogLogins /Listados/ - FIN
 
 
 
 
-- SP-TABLA: LogLoginsDeDispositivos /Listados/ - INICIO
IF (OBJECT_ID('usp_LogLoginsDeDispositivos__Listado') IS NOT NULL) DROP PROCEDURE usp_LogLoginsDeDispositivos__Listado
GO
CREATE PROCEDURE usp_LogLoginsDeDispositivos__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@FechaDeEjecucionDesde                                    DATETIME = NULL
	,@FechaDeEjecucionHasta                                    DATETIME = NULL
	,@InicioValidesDesde                                       DATETIME = NULL
	,@InicioValidesHasta                                       DATETIME = NULL
	,@FinValidezDesde                                          DATETIME = NULL
	,@FinValidezHasta                                          DATETIME = NULL
	,@DispositivoId                                            INT = '-1' -- FiltroDDL (FK)
	,@UsuarioId                                                INT = '-1' -- FiltroDDL (FK)
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogLoginsDeDispositivos'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT LLDD.id
						,LLDD.DispositivoId
						,LLDD.UsuarioId
						,LLDD.Token
						,LLDD.FechaDeEjecucion
						,dbo.ufc_Fechas__FormatoFechaComoTexto(LLDD.FechaDeEjecucion) AS FechaDeEjecucionFormateado
						,LLDD.InicioValides
						,dbo.ufc_Fechas__FormatoFechaComoTexto(LLDD.InicioValides) AS InicioValidesFormateado
						,LLDD.FinValidez
						,dbo.ufc_Fechas__FormatoFechaComoTexto(LLDD.FinValidez) AS FinValidezFormateado
						,DISP.UserMachineName AS Dispositivo
						,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS Usuario
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN LLDD.FechaDeEjecucion END DESC
								,CASE WHEN @OrdenarPor = 'Token' AND @Sentido = '0' THEN LLDD.Token END
								,CASE WHEN @OrdenarPor = 'Token' AND @Sentido = '1' THEN LLDD.Token END DESC
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucion' AND @Sentido = '0' THEN LLDD.FechaDeEjecucion END
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucion' AND @Sentido = '1' THEN LLDD.FechaDeEjecucion END DESC
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucionFormateado' AND @Sentido = '0' THEN LLDD.FechaDeEjecucion END
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucionFormateado' AND @Sentido = '1' THEN LLDD.FechaDeEjecucion END DESC
								,CASE WHEN @OrdenarPor = 'InicioValides' AND @Sentido = '0' THEN LLDD.InicioValides END
								,CASE WHEN @OrdenarPor = 'InicioValides' AND @Sentido = '1' THEN LLDD.InicioValides END DESC
								,CASE WHEN @OrdenarPor = 'InicioValidesFormateado' AND @Sentido = '0' THEN LLDD.InicioValides END
								,CASE WHEN @OrdenarPor = 'InicioValidesFormateado' AND @Sentido = '1' THEN LLDD.InicioValides END DESC
								,CASE WHEN @OrdenarPor = 'FinValidez' AND @Sentido = '0' THEN LLDD.FinValidez END
								,CASE WHEN @OrdenarPor = 'FinValidez' AND @Sentido = '1' THEN LLDD.FinValidez END DESC
								,CASE WHEN @OrdenarPor = 'FinValidezFormateado' AND @Sentido = '0' THEN LLDD.FinValidez END
								,CASE WHEN @OrdenarPor = 'FinValidezFormateado' AND @Sentido = '1' THEN LLDD.FinValidez END DESC
								,CASE WHEN @OrdenarPor = 'Dispositivo' AND @Sentido = '0' THEN DISP.UserMachineName END
								,CASE WHEN @OrdenarPor = 'Dispositivo' AND @Sentido = '1' THEN DISP.UserMachineName END DESC
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '0' THEN U.Apellido END
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '0' THEN U.Nombre END
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '1' THEN U.Apellido END DESC
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '1' THEN U.Nombre END DESC
						) AS NumeroDeRegistro
					FROM LogLoginsDeDispositivos AS LLDD
						INNER JOIN Dispositivos DISP ON DISP.id = LLDD.DispositivoId
						INNER JOIN Usuarios U ON U.id = LLDD.UsuarioId
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = LLDD.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(LLDD.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (LLDD.FechaDeEjecucion >= @FechaDeEjecucionDesde OR @FechaDeEjecucionDesde IS NULL)
						AND (LLDD.FechaDeEjecucion <= @FechaDeEjecucionHasta OR @FechaDeEjecucionHasta IS NULL)
						AND (LLDD.InicioValides >= @InicioValidesDesde OR @InicioValidesDesde IS NULL)
						AND (LLDD.InicioValides <= @InicioValidesHasta OR @InicioValidesHasta IS NULL)
						AND (LLDD.FinValidez >= @FinValidezDesde OR @FinValidezDesde IS NULL)
						AND (LLDD.FinValidez <= @FinValidezHasta OR @FinValidezHasta IS NULL)
						AND (LLDD.DispositivoId = @DispositivoId OR @DispositivoId = '-1') -- FiltroDDL (FK)
						AND (LLDD.UsuarioId = @UsuarioId OR @UsuarioId = '-1') -- FiltroDDL (FK)
						AND
						(
							(@Filtro = '')
							OR (LLDD.Token LIKE '%' + @Filtro + '%')
							OR (LLDD.FechaDeEjecucion LIKE '%' + @Filtro + '%')
							OR (LLDD.InicioValides LIKE '%' + @Filtro + '%')
							OR (LLDD.FinValidez LIKE '%' + @Filtro + '%')
							OR (DISP.UserMachineName LIKE '%' + @Filtro + '%')
							OR (U.Apellido LIKE '%' + @Filtro + '%')
							OR (U.Nombre LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_LogLoginsDeDispositivos__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_LogLoginsDeDispositivos__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_LogLoginsDeDispositivos__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
	,@DispositivoId                                            INT = '-1' -- FiltroDDL (FK)
	,@UsuarioId                                                INT = '-1' -- FiltroDDL (FK)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogLoginsDeDispositivos'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT LLDD.id
				,CAST(LLDD.FechaDeEjecucion AS VARCHAR(MAX)) AS FechaDeEjecucion
			FROM LogLoginsDeDispositivos AS LLDD
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(LLDD.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					AND (LLDD.DispositivoId = @DispositivoId OR @DispositivoId = '-1') -- FiltroDDL (FK)
					AND (LLDD.UsuarioId = @UsuarioId OR @UsuarioId = '-1') -- FiltroDDL (FK)
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (LLDD.FechaDeEjecucion LIKE '%' + @Filtro + '%')
				)
			ORDER BY LLDD.FechaDeEjecucion
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: LogLoginsDeDispositivos /Listados/ - FIN
 
 
 
 
-- SP-TABLA: LogLoginsDeDispositivosRechazados /Listados/ - INICIO
IF (OBJECT_ID('usp_LogLoginsDeDispositivosRechazados__Listado') IS NOT NULL) DROP PROCEDURE usp_LogLoginsDeDispositivosRechazados__Listado
GO
CREATE PROCEDURE usp_LogLoginsDeDispositivosRechazados__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@FechaDeEjecucionDesde                                    DATETIME = NULL
	,@FechaDeEjecucionHasta                                    DATETIME = NULL
	,@DispositivoId                                            INT = '-1' -- FiltroDDL (FK)
	,@UsuarioId                                                INT = '-1' -- FiltroDDL (FK)
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogLoginsDeDispositivosRechazados'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT LLDDR.id
						,LLDDR.DispositivoId
						,LLDDR.UsuarioId
						,LLDDR.FechaDeEjecucion
						,dbo.ufc_Fechas__FormatoFechaComoTexto(LLDDR.FechaDeEjecucion) AS FechaDeEjecucionFormateado
						,LLDDR.JSON
						,LLDDR.UsuarioIngresado
						,LLDDR.MachineName
						,LLDDR.MotivoDeRechazo
						,DISP.UserMachineName AS Dispositivo
						,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS Usuario
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN LLDDR.FechaDeEjecucion END DESC
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucion' AND @Sentido = '0' THEN LLDDR.FechaDeEjecucion END
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucion' AND @Sentido = '1' THEN LLDDR.FechaDeEjecucion END DESC
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucionFormateado' AND @Sentido = '0' THEN LLDDR.FechaDeEjecucion END
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucionFormateado' AND @Sentido = '1' THEN LLDDR.FechaDeEjecucion END DESC
								,CASE WHEN @OrdenarPor = 'JSON' AND @Sentido = '0' THEN LLDDR.JSON END
								,CASE WHEN @OrdenarPor = 'JSON' AND @Sentido = '1' THEN LLDDR.JSON END DESC
								,CASE WHEN @OrdenarPor = 'UsuarioIngresado' AND @Sentido = '0' THEN LLDDR.UsuarioIngresado END
								,CASE WHEN @OrdenarPor = 'UsuarioIngresado' AND @Sentido = '1' THEN LLDDR.UsuarioIngresado END DESC
								,CASE WHEN @OrdenarPor = 'MachineName' AND @Sentido = '0' THEN LLDDR.MachineName END
								,CASE WHEN @OrdenarPor = 'MachineName' AND @Sentido = '1' THEN LLDDR.MachineName END DESC
								,CASE WHEN @OrdenarPor = 'MotivoDeRechazo' AND @Sentido = '0' THEN LLDDR.MotivoDeRechazo END
								,CASE WHEN @OrdenarPor = 'MotivoDeRechazo' AND @Sentido = '1' THEN LLDDR.MotivoDeRechazo END DESC
								,CASE WHEN @OrdenarPor = 'Dispositivo' AND @Sentido = '0' THEN DISP.UserMachineName END
								,CASE WHEN @OrdenarPor = 'Dispositivo' AND @Sentido = '1' THEN DISP.UserMachineName END DESC
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '0' THEN U.Apellido END
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '0' THEN U.Nombre END
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '1' THEN U.Apellido END DESC
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '1' THEN U.Nombre END DESC
						) AS NumeroDeRegistro
					FROM LogLoginsDeDispositivosRechazados AS LLDDR
						INNER JOIN Dispositivos DISP ON DISP.id = LLDDR.DispositivoId
						INNER JOIN Usuarios U ON U.id = LLDDR.UsuarioId
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = LLDDR.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(LLDDR.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (LLDDR.FechaDeEjecucion >= @FechaDeEjecucionDesde OR @FechaDeEjecucionDesde IS NULL)
						AND (LLDDR.FechaDeEjecucion <= @FechaDeEjecucionHasta OR @FechaDeEjecucionHasta IS NULL)
						AND (LLDDR.DispositivoId = @DispositivoId OR @DispositivoId = '-1') -- FiltroDDL (FK)
						AND (LLDDR.UsuarioId = @UsuarioId OR @UsuarioId = '-1') -- FiltroDDL (FK)
						AND
						(
							(@Filtro = '')
							OR (LLDDR.FechaDeEjecucion LIKE '%' + @Filtro + '%')
							OR (LLDDR.JSON LIKE '%' + @Filtro + '%')
							OR (LLDDR.UsuarioIngresado LIKE '%' + @Filtro + '%')
							OR (LLDDR.MachineName LIKE '%' + @Filtro + '%')
							OR (LLDDR.MotivoDeRechazo LIKE '%' + @Filtro + '%')
							OR (DISP.UserMachineName LIKE '%' + @Filtro + '%')
							OR (U.Apellido LIKE '%' + @Filtro + '%')
							OR (U.Nombre LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_LogLoginsDeDispositivosRechazados__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_LogLoginsDeDispositivosRechazados__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_LogLoginsDeDispositivosRechazados__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
	,@DispositivoId                                            INT = '-1' -- FiltroDDL (FK)
	,@UsuarioId                                                INT = '-1' -- FiltroDDL (FK)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogLoginsDeDispositivosRechazados'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT LLDDR.id
				,CAST(LLDDR.FechaDeEjecucion AS VARCHAR(MAX)) AS FechaDeEjecucion
			FROM LogLoginsDeDispositivosRechazados AS LLDDR
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(LLDDR.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					AND (LLDDR.DispositivoId = @DispositivoId OR @DispositivoId = '-1') -- FiltroDDL (FK)
					AND (LLDDR.UsuarioId = @UsuarioId OR @UsuarioId = '-1') -- FiltroDDL (FK)
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (LLDDR.FechaDeEjecucion LIKE '%' + @Filtro + '%')
				)
			ORDER BY LLDDR.FechaDeEjecucion
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: LogLoginsDeDispositivosRechazados /Listados/ - FIN
 
 
 
 
-- SP-TABLA: LogRegistros /Listados/ - INICIO
IF (OBJECT_ID('usp_LogRegistros__Listado') IS NOT NULL) DROP PROCEDURE usp_LogRegistros__Listado
GO
CREATE PROCEDURE usp_LogRegistros__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@FechaDeEjecucionDesde                                    DATETIME = NULL
	,@FechaDeEjecucionHasta                                    DATETIME = NULL
	,@LogLoginDeDispositivoId                                  INT = '-1' -- FiltroDDL (FK)
	,@TablaId                                                  INT = '-1' -- FiltroDDL (FK)
	,@TipoDeOperacionId                                        INT = '-1' -- FiltroDDL (FK)
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogRegistros'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT LR.id
						,LR.UsuarioQueEjecutaId
						,LR.FechaDeEjecucion
						,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaDeEjecucionFormateado
						,LR.TablaId
						,LR.RegistroId
						,LR.LogLoginDeDispositivoId
						,LR.TipoDeOperacionId
						,LLDD.FechaDeEjecucion AS LogLoginDeDispositivo
						,T.Nombre AS Tabla
						,TDO.Nombre AS TipoDeOperacion
						,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS UsuarioQueEjecuta
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN LR.FechaDeEjecucion END DESC
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucion' AND @Sentido = '0' THEN LR.FechaDeEjecucion END
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucion' AND @Sentido = '1' THEN LR.FechaDeEjecucion END DESC
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucionFormateado' AND @Sentido = '0' THEN LR.FechaDeEjecucion END
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucionFormateado' AND @Sentido = '1' THEN LR.FechaDeEjecucion END DESC
								,CASE WHEN @OrdenarPor = 'RegistroId' AND @Sentido = '0' THEN LR.RegistroId END
								,CASE WHEN @OrdenarPor = 'RegistroId' AND @Sentido = '1' THEN LR.RegistroId END DESC
								,CASE WHEN @OrdenarPor = 'LogLoginDeDispositivo' AND @Sentido = '0' THEN LLDD.FechaDeEjecucion END
								,CASE WHEN @OrdenarPor = 'LogLoginDeDispositivo' AND @Sentido = '1' THEN LLDD.FechaDeEjecucion END DESC
								,CASE WHEN @OrdenarPor = 'Tabla' AND @Sentido = '0' THEN T.Nombre END
								,CASE WHEN @OrdenarPor = 'Tabla' AND @Sentido = '1' THEN T.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'TipoDeOperacion' AND @Sentido = '0' THEN TDO.Nombre END
								,CASE WHEN @OrdenarPor = 'TipoDeOperacion' AND @Sentido = '1' THEN TDO.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'UsuarioQueEjecuta' AND @Sentido = '0' THEN U.Apellido END
								,CASE WHEN @OrdenarPor = 'UsuarioQueEjecuta' AND @Sentido = '0' THEN U.Nombre END
								,CASE WHEN @OrdenarPor = 'UsuarioQueEjecuta' AND @Sentido = '1' THEN U.Apellido END DESC
								,CASE WHEN @OrdenarPor = 'UsuarioQueEjecuta' AND @Sentido = '1' THEN U.Nombre END DESC
						) AS NumeroDeRegistro
					FROM LogRegistros AS LR
						INNER JOIN LogLoginsDeDispositivos LLDD ON LLDD.id = LR.LogLoginDeDispositivoId
						INNER JOIN Tablas T ON T.id = LR.TablaId
						INNER JOIN TiposDeOperaciones TDO ON TDO.id = LR.TipoDeOperacionId
						INNER JOIN Usuarios U ON U.id = LR.UsuarioQueEjecutaId
					WHERE
						(LR.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (LR.FechaDeEjecucion >= @FechaDeEjecucionDesde OR @FechaDeEjecucionDesde IS NULL)
						AND (LR.FechaDeEjecucion <= @FechaDeEjecucionHasta OR @FechaDeEjecucionHasta IS NULL)
						AND (LR.LogLoginDeDispositivoId = @LogLoginDeDispositivoId OR @LogLoginDeDispositivoId = '-1') -- FiltroDDL (FK)
						AND (LR.TablaId = @TablaId OR @TablaId = '-1') -- FiltroDDL (FK)
						AND (LR.TipoDeOperacionId = @TipoDeOperacionId OR @TipoDeOperacionId = '-1') -- FiltroDDL (FK)
						AND (LR.UsuarioQueEjecutaId = @UsuarioQueEjecutaId OR @UsuarioQueEjecutaId = '-1') -- FiltroDDL (FK)
						AND
						(
							(@Filtro = '')
							OR (LR.FechaDeEjecucion LIKE '%' + @Filtro + '%')
							OR (LR.RegistroId LIKE '%' + @Filtro + '%')
							OR (LLDD.FechaDeEjecucion LIKE '%' + @Filtro + '%')
							OR (T.Nombre LIKE '%' + @Filtro + '%')
							OR (TDO.Nombre LIKE '%' + @Filtro + '%')
							OR (U.Apellido LIKE '%' + @Filtro + '%')
							OR (U.Nombre LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_LogRegistros__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_LogRegistros__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_LogRegistros__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
	,@LogLoginDeDispositivoId                                  INT = '-1' -- FiltroDDL (FK)
	,@TablaId                                                  INT = '-1' -- FiltroDDL (FK)
	,@TipoDeOperacionId                                        INT = '-1' -- FiltroDDL (FK)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogRegistros'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT LR.id
				,CAST(LR.FechaDeEjecucion AS VARCHAR(MAX)) AS FechaDeEjecucion
			FROM LogRegistros AS LR
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(LR.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					AND (LR.LogLoginDeDispositivoId = @LogLoginDeDispositivoId OR @LogLoginDeDispositivoId = '-1') -- FiltroDDL (FK)
					AND (LR.TablaId = @TablaId OR @TablaId = '-1') -- FiltroDDL (FK)
					AND (LR.TipoDeOperacionId = @TipoDeOperacionId OR @TipoDeOperacionId = '-1') -- FiltroDDL (FK)
					AND (LR.UsuarioQueEjecutaId = @UsuarioQueEjecutaId OR @UsuarioQueEjecutaId = '-1') -- FiltroDDL (FK)
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (LR.FechaDeEjecucion LIKE '%' + @Filtro + '%')
				)
			ORDER BY LR.FechaDeEjecucion
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: LogRegistros /Listados/ - FIN
 
 
 
 
-- SP-TABLA: Notas /Listados/ - INICIO
IF (OBJECT_ID('usp_Notas__Listado') IS NOT NULL) DROP PROCEDURE usp_Notas__Listado
GO
CREATE PROCEDURE usp_Notas__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@FechaDesde                                               DATETIME = NULL
	,@FechaHasta                                               DATETIME = NULL
	,@FechaDeVencimientoDesde                                  DATETIME = NULL
	,@FechaDeVencimientoHasta                                  DATETIME = NULL
	,@CompartirConTodos                                        BIT = NULL
	,@IconoCSSId                                               INT = '-1' -- FiltroDDL (FK)
	,@UsuarioId                                                INT = '-1' -- FiltroDDL (FK)
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Notas'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT NOTAS.id
						,NOTAS.UsuarioId
						,NOTAS.IconoCSSId
						,NOTAS.Fecha
						,dbo.ufc_Fechas__FormatoFechaComoTexto(NOTAS.Fecha) AS FechaFormateado
						,NOTAS.FechaDeVencimiento
						,dbo.ufc_Fechas__FormatoFechaComoTexto(NOTAS.FechaDeVencimiento) AS FechaDeVencimientoFormateado
						,NOTAS.Titulo
						,NOTAS.Cuerpo
						,NOTAS.CompartirConTodos
						,ICSS.Nombre AS IconoCSS
						,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS Usuario
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN NOTAS.Fecha END DESC
								,CASE WHEN @OrdenarPor = 'Fecha' AND @Sentido = '0' THEN NOTAS.Fecha END
								,CASE WHEN @OrdenarPor = 'Fecha' AND @Sentido = '1' THEN NOTAS.Fecha END DESC
								,CASE WHEN @OrdenarPor = 'FechaFormateado' AND @Sentido = '0' THEN NOTAS.Fecha END
								,CASE WHEN @OrdenarPor = 'FechaFormateado' AND @Sentido = '1' THEN NOTAS.Fecha END DESC
								,CASE WHEN @OrdenarPor = 'FechaDeVencimiento' AND @Sentido = '0' THEN NOTAS.FechaDeVencimiento END
								,CASE WHEN @OrdenarPor = 'FechaDeVencimiento' AND @Sentido = '1' THEN NOTAS.FechaDeVencimiento END DESC
								,CASE WHEN @OrdenarPor = 'FechaDeVencimientoFormateado' AND @Sentido = '0' THEN NOTAS.FechaDeVencimiento END
								,CASE WHEN @OrdenarPor = 'FechaDeVencimientoFormateado' AND @Sentido = '1' THEN NOTAS.FechaDeVencimiento END DESC
								,CASE WHEN @OrdenarPor = 'Titulo' AND @Sentido = '0' THEN NOTAS.Titulo END
								,CASE WHEN @OrdenarPor = 'Titulo' AND @Sentido = '1' THEN NOTAS.Titulo END DESC
								,CASE WHEN @OrdenarPor = 'Cuerpo' AND @Sentido = '0' THEN NOTAS.Cuerpo END
								,CASE WHEN @OrdenarPor = 'Cuerpo' AND @Sentido = '1' THEN NOTAS.Cuerpo END DESC
								,CASE WHEN @OrdenarPor = 'IconoCSS' AND @Sentido = '0' THEN ICSS.Nombre END
								,CASE WHEN @OrdenarPor = 'IconoCSS' AND @Sentido = '1' THEN ICSS.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '0' THEN U.Apellido END
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '0' THEN U.Nombre END
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '1' THEN U.Apellido END DESC
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '1' THEN U.Nombre END DESC
						) AS NumeroDeRegistro
					FROM Notas AS NOTAS
						INNER JOIN Contextos CX ON CX.id = NOTAS.ContextoId
						INNER JOIN IconosCSS ICSS ON ICSS.id = NOTAS.IconoCSSId
						INNER JOIN Usuarios U ON U.id = NOTAS.UsuarioId
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = NOTAS.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(NOTAS.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (NOTAS.ContextoId = @ContextoId OR @ContextoId = '-1')
						AND (NOTAS.Fecha >= @FechaDesde OR @FechaDesde IS NULL)
						AND (NOTAS.Fecha <= @FechaHasta OR @FechaHasta IS NULL)
						AND (NOTAS.FechaDeVencimiento >= @FechaDeVencimientoDesde OR @FechaDeVencimientoDesde IS NULL)
						AND (NOTAS.FechaDeVencimiento <= @FechaDeVencimientoHasta OR @FechaDeVencimientoHasta IS NULL)
						AND (NOTAS.CompartirConTodos = @CompartirConTodos OR @CompartirConTodos IS NULL)
						AND (NOTAS.IconoCSSId = @IconoCSSId OR @IconoCSSId = '-1') -- FiltroDDL (FK)
						AND (NOTAS.UsuarioId = @UsuarioId OR @UsuarioId = '-1') -- FiltroDDL (FK)
						AND
						(
							(@Filtro = '')
							OR (NOTAS.Fecha LIKE '%' + @Filtro + '%')
							OR (NOTAS.FechaDeVencimiento LIKE '%' + @Filtro + '%')
							OR (NOTAS.Titulo LIKE '%' + @Filtro + '%')
							OR (NOTAS.Cuerpo LIKE '%' + @Filtro + '%')
							OR (ICSS.Nombre LIKE '%' + @Filtro + '%')
							OR (U.Apellido LIKE '%' + @Filtro + '%')
							OR (U.Nombre LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_Notas__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_Notas__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_Notas__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
	,@IconoCSSId                                               INT = '-1' -- FiltroDDL (FK)
	,@UsuarioId                                                INT = '-1' -- FiltroDDL (FK)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Notas'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SELECT NOTAS.id
				,CAST(NOTAS.Fecha AS VARCHAR(MAX)) AS Fecha
			FROM Notas AS NOTAS
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(NOTAS.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					AND (NOTAS.IconoCSSId = @IconoCSSId OR @IconoCSSId = '-1') -- FiltroDDL (FK)
					AND (NOTAS.UsuarioId = @UsuarioId OR @UsuarioId = '-1') -- FiltroDDL (FK)
					 AND (NOTAS.ContextoId = @ContextoId OR @ContextoId = '-1')
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (NOTAS.Fecha LIKE '%' + @Filtro + '%')
				)
			ORDER BY NOTAS.Fecha
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: Notas /Listados/ - FIN
 
 
 
 
-- SP-TABLA: Paginas /Listados/ - INICIO
IF (OBJECT_ID('usp_Paginas__Listado') IS NOT NULL) DROP PROCEDURE usp_Paginas__Listado
GO
CREATE PROCEDURE usp_Paginas__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@SeMuestraEnAsignacionDePermisos                          BIT = NULL
	,@FuncionDePaginaId                                        INT = '-1' -- FiltroDDL (FK)
	,@SeccionId                                                INT = '-1' -- FiltroDDL (FK)
	,@TablaId                                                  INT = '-1' -- FiltroDDL (FK)
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Paginas'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT P.id
						,P.SeccionId
						,P.TablaId
						,P.FuncionDePaginaId
						,P.Nombre
						,P.Titulo
						,P.Tips
						,P.SeMuestraEnAsignacionDePermisos
						,FDP.Nombre AS FuncionDePagina
						,Secc.Nombre AS Seccion
						,T.Nombre AS Tabla
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN P.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN P.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN P.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Titulo' AND @Sentido = '0' THEN P.Titulo END
								,CASE WHEN @OrdenarPor = 'Titulo' AND @Sentido = '1' THEN P.Titulo END DESC
								,CASE WHEN @OrdenarPor = 'Tips' AND @Sentido = '0' THEN P.Tips END
								,CASE WHEN @OrdenarPor = 'Tips' AND @Sentido = '1' THEN P.Tips END DESC
								,CASE WHEN @OrdenarPor = 'FuncionDePagina' AND @Sentido = '0' THEN FDP.Nombre END
								,CASE WHEN @OrdenarPor = 'FuncionDePagina' AND @Sentido = '1' THEN FDP.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Seccion' AND @Sentido = '0' THEN Secc.Nombre END
								,CASE WHEN @OrdenarPor = 'Seccion' AND @Sentido = '1' THEN Secc.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Tabla' AND @Sentido = '0' THEN T.Nombre END
								,CASE WHEN @OrdenarPor = 'Tabla' AND @Sentido = '1' THEN T.Nombre END DESC
						) AS NumeroDeRegistro
					FROM Paginas AS P
						INNER JOIN FuncionesDePaginas FDP ON FDP.id = P.FuncionDePaginaId
						INNER JOIN Secciones Secc ON Secc.id = P.SeccionId
						INNER JOIN Tablas T ON T.id = P.TablaId
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = P.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(P.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (P.SeMuestraEnAsignacionDePermisos = @SeMuestraEnAsignacionDePermisos OR @SeMuestraEnAsignacionDePermisos IS NULL)
						AND (P.FuncionDePaginaId = @FuncionDePaginaId OR @FuncionDePaginaId = '-1') -- FiltroDDL (FK)
						AND (P.SeccionId = @SeccionId OR @SeccionId = '-1') -- FiltroDDL (FK)
						AND (P.TablaId = @TablaId OR @TablaId = '-1') -- FiltroDDL (FK)
						AND
						(
							(@Filtro = '')
							OR (P.Nombre LIKE '%' + @Filtro + '%')
							OR (P.Titulo LIKE '%' + @Filtro + '%')
							OR (P.Tips LIKE '%' + @Filtro + '%')
							OR (FDP.Nombre LIKE '%' + @Filtro + '%')
							OR (Secc.Nombre LIKE '%' + @Filtro + '%')
							OR (T.Nombre LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_Paginas__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_Paginas__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_Paginas__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
	,@FuncionDePaginaId                                        INT = '-1' -- FiltroDDL (FK)
	,@SeccionId                                                INT = '-1' -- FiltroDDL (FK)
	,@TablaId                                                  INT = '-1' -- FiltroDDL (FK)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Paginas'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT P.id
				,CAST(P.Nombre AS VARCHAR(MAX)) AS Nombre
			FROM Paginas AS P
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(P.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					AND (P.FuncionDePaginaId = @FuncionDePaginaId OR @FuncionDePaginaId = '-1') -- FiltroDDL (FK)
					AND (P.SeccionId = @SeccionId OR @SeccionId = '-1') -- FiltroDDL (FK)
					AND (P.TablaId = @TablaId OR @TablaId = '-1') -- FiltroDDL (FK)
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (P.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY P.Nombre
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: Paginas /Listados/ - FIN
 
 
 
 
-- SP-TABLA: ParametrosDelSistema /Listados/ - INICIO
IF (OBJECT_ID('usp_ParametrosDelSistema__Listado') IS NOT NULL) DROP PROCEDURE usp_ParametrosDelSistema__Listado
GO
CREATE PROCEDURE usp_ParametrosDelSistema__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@Contextohabilitadi                                       BIT = NULL
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'ParametrosDelSistema'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT PDS.id
						,PDS.Contextohabilitadi
						,PDS.IntentosFallidosDeLoginPermitidos
						,PDS.IntervaloDeIntentosFallidoLogin
						,PDS.MinDeBloqueoTrasIntentosFallidoLogin
						,PDS.PermitidasLasModificaciones
						,PDS.PermitidasLasConsultas
						,PDS.PermitidasLasExportaciones
						,PDS.PermitidosLosEnviosDeCorreo
						,PDS.DiferenciaHorariaDelServidor
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN PDS.ContextoId END 
								,CASE WHEN @OrdenarPor = 'IntentosFallidosDeLoginPermitidos' AND @Sentido = '0' THEN PDS.IntentosFallidosDeLoginPermitidos END
								,CASE WHEN @OrdenarPor = 'IntentosFallidosDeLoginPermitidos' AND @Sentido = '1' THEN PDS.IntentosFallidosDeLoginPermitidos END DESC
								,CASE WHEN @OrdenarPor = 'IntervaloDeIntentosFallidoLogin' AND @Sentido = '0' THEN PDS.IntervaloDeIntentosFallidoLogin END
								,CASE WHEN @OrdenarPor = 'IntervaloDeIntentosFallidoLogin' AND @Sentido = '1' THEN PDS.IntervaloDeIntentosFallidoLogin END DESC
								,CASE WHEN @OrdenarPor = 'MinDeBloqueoTrasIntentosFallidoLogin' AND @Sentido = '0' THEN PDS.MinDeBloqueoTrasIntentosFallidoLogin END
								,CASE WHEN @OrdenarPor = 'MinDeBloqueoTrasIntentosFallidoLogin' AND @Sentido = '1' THEN PDS.MinDeBloqueoTrasIntentosFallidoLogin END DESC
								,CASE WHEN @OrdenarPor = 'PermitidasLasModificaciones' AND @Sentido = '0' THEN PDS.PermitidasLasModificaciones END
								,CASE WHEN @OrdenarPor = 'PermitidasLasModificaciones' AND @Sentido = '1' THEN PDS.PermitidasLasModificaciones END DESC
								,CASE WHEN @OrdenarPor = 'PermitidasLasConsultas' AND @Sentido = '0' THEN PDS.PermitidasLasConsultas END
								,CASE WHEN @OrdenarPor = 'PermitidasLasConsultas' AND @Sentido = '1' THEN PDS.PermitidasLasConsultas END DESC
								,CASE WHEN @OrdenarPor = 'PermitidasLasExportaciones' AND @Sentido = '0' THEN PDS.PermitidasLasExportaciones END
								,CASE WHEN @OrdenarPor = 'PermitidasLasExportaciones' AND @Sentido = '1' THEN PDS.PermitidasLasExportaciones END DESC
								,CASE WHEN @OrdenarPor = 'PermitidosLosEnviosDeCorreo' AND @Sentido = '0' THEN PDS.PermitidosLosEnviosDeCorreo END
								,CASE WHEN @OrdenarPor = 'PermitidosLosEnviosDeCorreo' AND @Sentido = '1' THEN PDS.PermitidosLosEnviosDeCorreo END DESC
								,CASE WHEN @OrdenarPor = 'DiferenciaHorariaDelServidor' AND @Sentido = '0' THEN PDS.DiferenciaHorariaDelServidor END
								,CASE WHEN @OrdenarPor = 'DiferenciaHorariaDelServidor' AND @Sentido = '1' THEN PDS.DiferenciaHorariaDelServidor END DESC
						) AS NumeroDeRegistro
					FROM ParametrosDelSistema AS PDS
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = PDS.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(PDS.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (PDS.ContextoId = @ContextoId OR @ContextoId = '-1')
						AND (PDS.Contextohabilitadi = @Contextohabilitadi OR @Contextohabilitadi IS NULL)
						AND
						(
							(@Filtro = '')
							OR (PDS.IntentosFallidosDeLoginPermitidos LIKE '%' + @Filtro + '%')
							OR (PDS.IntervaloDeIntentosFallidoLogin LIKE '%' + @Filtro + '%')
							OR (PDS.MinDeBloqueoTrasIntentosFallidoLogin LIKE '%' + @Filtro + '%')
							OR (PDS.PermitidasLasModificaciones LIKE '%' + @Filtro + '%')
							OR (PDS.PermitidasLasConsultas LIKE '%' + @Filtro + '%')
							OR (PDS.PermitidasLasExportaciones LIKE '%' + @Filtro + '%')
							OR (PDS.PermitidosLosEnviosDeCorreo LIKE '%' + @Filtro + '%')
							OR (PDS.DiferenciaHorariaDelServidor LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_ParametrosDelSistema__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_ParametrosDelSistema__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_ParametrosDelSistema__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'ParametrosDelSistema'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SELECT PDS.id
				,CAST(PDS.ContextoId AS VARCHAR(MAX)) AS ContextoId
			FROM ParametrosDelSistema AS PDS
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(PDS.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					 AND (PDS.ContextoId = @ContextoId OR @ContextoId = '-1')
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (PDS.ContextoId LIKE '%' + @Filtro + '%')
				)
			ORDER BY PDS.ContextoId
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: ParametrosDelSistema /Listados/ - FIN
 
 
 
 
-- SP-TABLA: PrioridadesDeSoportes /Listados/ - INICIO
IF (OBJECT_ID('usp_PrioridadesDeSoportes__Listado') IS NOT NULL) DROP PROCEDURE usp_PrioridadesDeSoportes__Listado
GO
CREATE PROCEDURE usp_PrioridadesDeSoportes__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@Activo                                                   BIT = '1'
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'PrioridadesDeSoportes'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT PDSop.id
						,PDSop.Nombre
						,PDSop.Orden
						,PDSop.Activo
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN PDSop.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN PDSop.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN PDSop.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Orden' AND @Sentido = '0' THEN PDSop.Orden END
								,CASE WHEN @OrdenarPor = 'Orden' AND @Sentido = '1' THEN PDSop.Orden END DESC
						) AS NumeroDeRegistro
					FROM PrioridadesDeSoportes AS PDSop
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = PDSop.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(PDSop.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (PDSop.Activo = @Activo OR @Activo IS NULL)
						AND
						(
							(@Filtro = '')
							OR (PDSop.Nombre LIKE '%' + @Filtro + '%')
							OR (PDSop.Orden LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_PrioridadesDeSoportes__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_PrioridadesDeSoportes__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_PrioridadesDeSoportes__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
	,@Activo                                                   BIT = '1'
 
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'PrioridadesDeSoportes'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT PDSop.id
				,'[' + PDSop.Orden + ']: ' + CAST(PDSop.Nombre AS VARCHAR(MAX)) AS Nombre
			FROM PrioridadesDeSoportes AS PDSop
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(PDSop.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					 AND (PDSop.Activo = @Activo OR @Activo IS NULL)
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (PDSop.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY PDSop.Orden, PDSop.Nombre
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: PrioridadesDeSoportes /Listados/ - FIN
 
 
 
 
-- SP-TABLA: RecorridosDeDispositivos /Listados/ - INICIO
IF (OBJECT_ID('usp_RecorridosDeDispositivos__Listado') IS NOT NULL) DROP PROCEDURE usp_RecorridosDeDispositivos__Listado
GO
CREATE PROCEDURE usp_RecorridosDeDispositivos__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@FechaDeEjecucionDesde                                    DATETIME = NULL
	,@FechaDeEjecucionHasta                                    DATETIME = NULL
	,@DispositivoId                                            INT = '-1' -- FiltroDDL (FK)
	,@UsuarioId                                                INT = '-1' -- FiltroDDL (FK)
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RecorridosDeDispositivos'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT RDD.id
						,RDD.DispositivoId
						,RDD.UsuarioId
						,RDD.Token
						,RDD.FechaDeEjecucion
						,dbo.ufc_Fechas__FormatoFechaComoTexto(RDD.FechaDeEjecucion) AS FechaDeEjecucionFormateado
						,RDD.Latitud
						,RDD.Longitud
						,DISP.UserMachineName AS Dispositivo
						,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS Usuario
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN RDD.FechaDeEjecucion END DESC
								,CASE WHEN @OrdenarPor = 'Token' AND @Sentido = '0' THEN RDD.Token END
								,CASE WHEN @OrdenarPor = 'Token' AND @Sentido = '1' THEN RDD.Token END DESC
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucion' AND @Sentido = '0' THEN RDD.FechaDeEjecucion END
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucion' AND @Sentido = '1' THEN RDD.FechaDeEjecucion END DESC
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucionFormateado' AND @Sentido = '0' THEN RDD.FechaDeEjecucion END
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucionFormateado' AND @Sentido = '1' THEN RDD.FechaDeEjecucion END DESC
								,CASE WHEN @OrdenarPor = 'Latitud' AND @Sentido = '0' THEN RDD.Latitud END
								,CASE WHEN @OrdenarPor = 'Latitud' AND @Sentido = '1' THEN RDD.Latitud END DESC
								,CASE WHEN @OrdenarPor = 'Longitud' AND @Sentido = '0' THEN RDD.Longitud END
								,CASE WHEN @OrdenarPor = 'Longitud' AND @Sentido = '1' THEN RDD.Longitud END DESC
								,CASE WHEN @OrdenarPor = 'Dispositivo' AND @Sentido = '0' THEN DISP.UserMachineName END
								,CASE WHEN @OrdenarPor = 'Dispositivo' AND @Sentido = '1' THEN DISP.UserMachineName END DESC
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '0' THEN U.Apellido END
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '0' THEN U.Nombre END
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '1' THEN U.Apellido END DESC
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '1' THEN U.Nombre END DESC
						) AS NumeroDeRegistro
					FROM RecorridosDeDispositivos AS RDD
						INNER JOIN Contextos CX ON CX.id = RDD.ContextoId
						INNER JOIN Dispositivos DISP ON DISP.id = RDD.DispositivoId
						INNER JOIN Usuarios U ON U.id = RDD.UsuarioId
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = RDD.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(RDD.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (RDD.ContextoId = @ContextoId OR @ContextoId = '-1')
						AND (RDD.FechaDeEjecucion >= @FechaDeEjecucionDesde OR @FechaDeEjecucionDesde IS NULL)
						AND (RDD.FechaDeEjecucion <= @FechaDeEjecucionHasta OR @FechaDeEjecucionHasta IS NULL)
						AND (RDD.DispositivoId = @DispositivoId OR @DispositivoId = '-1') -- FiltroDDL (FK)
						AND (RDD.UsuarioId = @UsuarioId OR @UsuarioId = '-1') -- FiltroDDL (FK)
						AND
						(
							(@Filtro = '')
							OR (RDD.Token LIKE '%' + @Filtro + '%')
							OR (RDD.FechaDeEjecucion LIKE '%' + @Filtro + '%')
							OR (RDD.Latitud LIKE '%' + @Filtro + '%')
							OR (RDD.Longitud LIKE '%' + @Filtro + '%')
							OR (DISP.UserMachineName LIKE '%' + @Filtro + '%')
							OR (U.Apellido LIKE '%' + @Filtro + '%')
							OR (U.Nombre LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_RecorridosDeDispositivos__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_RecorridosDeDispositivos__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_RecorridosDeDispositivos__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
	,@DispositivoId                                            INT = '-1' -- FiltroDDL (FK)
	,@UsuarioId                                                INT = '-1' -- FiltroDDL (FK)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RecorridosDeDispositivos'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SELECT RDD.id
				,CAST(RDD.FechaDeEjecucion AS VARCHAR(MAX)) AS FechaDeEjecucion
			FROM RecorridosDeDispositivos AS RDD
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(RDD.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					AND (RDD.DispositivoId = @DispositivoId OR @DispositivoId = '-1') -- FiltroDDL (FK)
					AND (RDD.UsuarioId = @UsuarioId OR @UsuarioId = '-1') -- FiltroDDL (FK)
					 AND (RDD.ContextoId = @ContextoId OR @ContextoId = '-1')
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (RDD.FechaDeEjecucion LIKE '%' + @Filtro + '%')
				)
			ORDER BY RDD.FechaDeEjecucion
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: RecorridosDeDispositivos /Listados/ - FIN
 
 
 
 
-- SP-TABLA: RelAsig_Contactos_A_GruposDeContactos /Listados/ - INICIO
IF (OBJECT_ID('usp_RelAsig_Contactos_A_GruposDeContactos__Listado') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Contactos_A_GruposDeContactos__Listado
GO
CREATE PROCEDURE usp_RelAsig_Contactos_A_GruposDeContactos__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@ContactoId                                               INT = '-1' -- FiltroDDL (FK)
	,@GrupoDeContactoId                                        INT = '-1' -- FiltroDDL (FK)
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Contactos_A_GruposDeContactos'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT ACAG.id
						,ACAG.ContactoId
						,ACAG.GrupoDeContactoId
						,CTOS.NombreCompleto AS Contacto
						,GDCTOS.Nombre AS GrupoDeContacto
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN ACAG.GrupoDeContactoId END 
								,CASE WHEN @OrdenarPor = 'Contacto' AND @Sentido = '0' THEN CTOS.NombreCompleto END
								,CASE WHEN @OrdenarPor = 'Contacto' AND @Sentido = '1' THEN CTOS.NombreCompleto END DESC
								,CASE WHEN @OrdenarPor = 'GrupoDeContacto' AND @Sentido = '0' THEN GDCTOS.Nombre END
								,CASE WHEN @OrdenarPor = 'GrupoDeContacto' AND @Sentido = '1' THEN GDCTOS.Nombre END DESC
						) AS NumeroDeRegistro
					FROM RelAsig_Contactos_A_GruposDeContactos AS ACAG
						INNER JOIN Contactos CTOS ON CTOS.id = ACAG.ContactoId
						INNER JOIN GruposDeContactos GDCTOS ON GDCTOS.id = ACAG.GrupoDeContactoId
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = ACAG.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(ACAG.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (ACAG.ContactoId = @ContactoId OR @ContactoId = '-1') -- FiltroDDL (FK)
						AND (ACAG.GrupoDeContactoId = @GrupoDeContactoId OR @GrupoDeContactoId = '-1') -- FiltroDDL (FK)
						AND
						(
							(@Filtro = '')
							OR (CTOS.NombreCompleto LIKE '%' + @Filtro + '%')
							OR (GDCTOS.Nombre LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_RelAsig_Contactos_A_GruposDeContactos__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Contactos_A_GruposDeContactos__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_RelAsig_Contactos_A_GruposDeContactos__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
	,@ContactoId                                               INT = '-1' -- FiltroDDL (FK)
	,@GrupoDeContactoId                                        INT = '-1' -- FiltroDDL (FK)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Contactos_A_GruposDeContactos'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT ACAG.id
				,CAST(GDCTOS.Nombre AS VARCHAR(MAX)) AS GrupoDeContactoId
			FROM RelAsig_Contactos_A_GruposDeContactos AS ACAG
				INNER JOIN Contactos CTOS ON CTOS.id = ACAG.ContactoId
				INNER JOIN GruposDeContactos GDCTOS ON GDCTOS.id = ACAG.GrupoDeContactoId
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(ACAG.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					AND (ACAG.ContactoId = @ContactoId OR @ContactoId = '-1') -- FiltroDDL (FK)
					AND (ACAG.GrupoDeContactoId = @GrupoDeContactoId OR @GrupoDeContactoId = '-1') -- FiltroDDL (FK)
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (GDCTOS.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY GDCTOS.Nombre
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: RelAsig_Contactos_A_GruposDeContactos /Listados/ - FIN
 
 
 
 
-- SP-TABLA: RelAsig_Contactos_A_TiposDeContactos /Listados/ - INICIO
IF (OBJECT_ID('usp_RelAsig_Contactos_A_TiposDeContactos__Listado') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Contactos_A_TiposDeContactos__Listado
GO
CREATE PROCEDURE usp_RelAsig_Contactos_A_TiposDeContactos__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@ContactoId                                               INT = '-1' -- FiltroDDL (FK)
	,@TipoDeContactoId                                         INT = '-1' -- FiltroDDL (FK)
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Contactos_A_TiposDeContactos'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT ACAT.id
						,ACAT.ContactoId
						,ACAT.TipoDeContactoId
						,CTOS.NombreCompleto AS Contacto
						,TDC.Nombre AS TipoDeContacto
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN ACAT.TipoDeContactoId END 
								,CASE WHEN @OrdenarPor = 'Contacto' AND @Sentido = '0' THEN CTOS.NombreCompleto END
								,CASE WHEN @OrdenarPor = 'Contacto' AND @Sentido = '1' THEN CTOS.NombreCompleto END DESC
								,CASE WHEN @OrdenarPor = 'TipoDeContacto' AND @Sentido = '0' THEN TDC.Nombre END
								,CASE WHEN @OrdenarPor = 'TipoDeContacto' AND @Sentido = '1' THEN TDC.Nombre END DESC
						) AS NumeroDeRegistro
					FROM RelAsig_Contactos_A_TiposDeContactos AS ACAT
						INNER JOIN Contactos CTOS ON CTOS.id = ACAT.ContactoId
						INNER JOIN TiposDeContactos TDC ON TDC.id = ACAT.TipoDeContactoId
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = ACAT.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(ACAT.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (ACAT.ContactoId = @ContactoId OR @ContactoId = '-1') -- FiltroDDL (FK)
						AND (ACAT.TipoDeContactoId = @TipoDeContactoId OR @TipoDeContactoId = '-1') -- FiltroDDL (FK)
						AND
						(
							(@Filtro = '')
							OR (CTOS.NombreCompleto LIKE '%' + @Filtro + '%')
							OR (TDC.Nombre LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_RelAsig_Contactos_A_TiposDeContactos__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Contactos_A_TiposDeContactos__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_RelAsig_Contactos_A_TiposDeContactos__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
	,@ContactoId                                               INT = '-1' -- FiltroDDL (FK)
	,@TipoDeContactoId                                         INT = '-1' -- FiltroDDL (FK)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Contactos_A_TiposDeContactos'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT ACAT.id
				,CAST(TDC.Nombre AS VARCHAR(MAX)) AS TipoDeContactoId
			FROM RelAsig_Contactos_A_TiposDeContactos AS ACAT
				INNER JOIN Contactos CTOS ON CTOS.id = ACAT.ContactoId
				INNER JOIN TiposDeContactos TDC ON TDC.id = ACAT.TipoDeContactoId
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(ACAT.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					AND (ACAT.ContactoId = @ContactoId OR @ContactoId = '-1') -- FiltroDDL (FK)
					AND (ACAT.TipoDeContactoId = @TipoDeContactoId OR @TipoDeContactoId = '-1') -- FiltroDDL (FK)
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (TDC.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY TDC.Nombre
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: RelAsig_Contactos_A_TiposDeContactos /Listados/ - FIN
 
 
 
 
-- SP-TABLA: RelAsig_Subsistemas_A_Publicaciones /Listados/ - INICIO
IF (OBJECT_ID('usp_RelAsig_Subsistemas_A_Publicaciones__Listado') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Subsistemas_A_Publicaciones__Listado
GO
CREATE PROCEDURE usp_RelAsig_Subsistemas_A_Publicaciones__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@PublicacionId                                            INT = '-1' -- FiltroDDL (FK)
	,@SubsistemaId                                             INT = '-1' -- FiltroDDL (FK)
	,@UsuarioId                                                INT = '-1' -- FiltroDDL (FK)
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Subsistemas_A_Publicaciones'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT ASAP.id
						,ASAP.SubsistemaId
						,ASAP.PublicacionId
						,ASAP.UsuarioId
						,ASAP.NumeroDeVersion
						,ASAP.SVN
						,ASAP.Ubicacion
						,PUB.Fecha AS Publicacion
						,SUBS.Nombre AS Subsistema
						,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS Usuario
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN ASAP.PublicacionId END 
								,CASE WHEN @OrdenarPor = 'NumeroDeVersion' AND @Sentido = '0' THEN ASAP.NumeroDeVersion END
								,CASE WHEN @OrdenarPor = 'NumeroDeVersion' AND @Sentido = '1' THEN ASAP.NumeroDeVersion END DESC
								,CASE WHEN @OrdenarPor = 'SVN' AND @Sentido = '0' THEN ASAP.SVN END
								,CASE WHEN @OrdenarPor = 'SVN' AND @Sentido = '1' THEN ASAP.SVN END DESC
								,CASE WHEN @OrdenarPor = 'Ubicacion' AND @Sentido = '0' THEN ASAP.Ubicacion END
								,CASE WHEN @OrdenarPor = 'Ubicacion' AND @Sentido = '1' THEN ASAP.Ubicacion END DESC
								,CASE WHEN @OrdenarPor = 'Publicacion' AND @Sentido = '0' THEN PUB.Fecha END
								,CASE WHEN @OrdenarPor = 'Publicacion' AND @Sentido = '1' THEN PUB.Fecha END DESC
								,CASE WHEN @OrdenarPor = 'Subsistema' AND @Sentido = '0' THEN SUBS.Nombre END
								,CASE WHEN @OrdenarPor = 'Subsistema' AND @Sentido = '1' THEN SUBS.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '0' THEN U.Apellido END
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '0' THEN U.Nombre END
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '1' THEN U.Apellido END DESC
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '1' THEN U.Nombre END DESC
						) AS NumeroDeRegistro
					FROM RelAsig_Subsistemas_A_Publicaciones AS ASAP
						INNER JOIN Publicaciones PUB ON PUB.id = ASAP.PublicacionId
						INNER JOIN Subsistemas SUBS ON SUBS.id = ASAP.SubsistemaId
						INNER JOIN Usuarios U ON U.id = ASAP.UsuarioId
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = ASAP.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(ASAP.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (ASAP.PublicacionId = @PublicacionId OR @PublicacionId = '-1') -- FiltroDDL (FK)
						AND (ASAP.SubsistemaId = @SubsistemaId OR @SubsistemaId = '-1') -- FiltroDDL (FK)
						AND (ASAP.UsuarioId = @UsuarioId OR @UsuarioId = '-1') -- FiltroDDL (FK)
						AND
						(
							(@Filtro = '')
							OR (ASAP.NumeroDeVersion LIKE '%' + @Filtro + '%')
							OR (ASAP.SVN LIKE '%' + @Filtro + '%')
							OR (ASAP.Ubicacion LIKE '%' + @Filtro + '%')
							OR (PUB.Fecha LIKE '%' + @Filtro + '%')
							OR (SUBS.Nombre LIKE '%' + @Filtro + '%')
							OR (U.Apellido LIKE '%' + @Filtro + '%')
							OR (U.Nombre LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_RelAsig_Subsistemas_A_Publicaciones__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Subsistemas_A_Publicaciones__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_RelAsig_Subsistemas_A_Publicaciones__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
	,@PublicacionId                                            INT = '-1' -- FiltroDDL (FK)
	,@SubsistemaId                                             INT = '-1' -- FiltroDDL (FK)
	,@UsuarioId                                                INT = '-1' -- FiltroDDL (FK)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Subsistemas_A_Publicaciones'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT ASAP.id
				,CAST(PUB.Fecha AS VARCHAR(MAX)) AS PublicacionId
			FROM RelAsig_Subsistemas_A_Publicaciones AS ASAP
				INNER JOIN Publicaciones PUB ON PUB.id = ASAP.PublicacionId
				INNER JOIN Subsistemas SUBS ON SUBS.id = ASAP.SubsistemaId
				INNER JOIN Usuarios U ON U.id = ASAP.UsuarioId
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(ASAP.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					AND (ASAP.PublicacionId = @PublicacionId OR @PublicacionId = '-1') -- FiltroDDL (FK)
					AND (ASAP.SubsistemaId = @SubsistemaId OR @SubsistemaId = '-1') -- FiltroDDL (FK)
					AND (ASAP.UsuarioId = @UsuarioId OR @UsuarioId = '-1') -- FiltroDDL (FK)
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (PUB.Fecha LIKE '%' + @Filtro + '%')
				)
			ORDER BY PUB.Fecha
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: RelAsig_Subsistemas_A_Publicaciones /Listados/ - FIN
 
 
 
 
-- SP-TABLA: RelAsig_Usuarios_A_Recursos /Listados/ - INICIO
IF (OBJECT_ID('usp_RelAsig_Usuarios_A_Recursos__Listado') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Usuarios_A_Recursos__Listado
GO
CREATE PROCEDURE usp_RelAsig_Usuarios_A_Recursos__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@RecursoId                                                INT = '-1' -- FiltroDDL (FK)
	,@UsuarioId                                                INT = '-1' -- FiltroDDL (FK)
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Usuarios_A_Recursos'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT AURAR.id
						,AURAR.UsuarioId
						,AURAR.RecursoId
						,RECU.Nombre AS Recurso
						,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS Usuario
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN AURAR.UsuarioId END 
								,CASE WHEN @OrdenarPor = 'Recurso' AND @Sentido = '0' THEN RECU.Nombre END
								,CASE WHEN @OrdenarPor = 'Recurso' AND @Sentido = '1' THEN RECU.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '0' THEN U.Apellido END
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '0' THEN U.Nombre END
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '1' THEN U.Apellido END DESC
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '1' THEN U.Nombre END DESC
						) AS NumeroDeRegistro
					FROM RelAsig_Usuarios_A_Recursos AS AURAR
						INNER JOIN Recursos RECU ON RECU.id = AURAR.RecursoId
						INNER JOIN Usuarios U ON U.id = AURAR.UsuarioId
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = AURAR.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(AURAR.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (AURAR.RecursoId = @RecursoId OR @RecursoId = '-1') -- FiltroDDL (FK)
						AND (AURAR.UsuarioId = @UsuarioId OR @UsuarioId = '-1') -- FiltroDDL (FK)
						AND
						(
							(@Filtro = '')
							OR (RECU.Nombre LIKE '%' + @Filtro + '%')
							OR (U.Apellido LIKE '%' + @Filtro + '%')
							OR (U.Nombre LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_RelAsig_Usuarios_A_Recursos__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Usuarios_A_Recursos__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_RelAsig_Usuarios_A_Recursos__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
	,@RecursoId                                                INT = '-1' -- FiltroDDL (FK)
	,@UsuarioId                                                INT = '-1' -- FiltroDDL (FK)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Usuarios_A_Recursos'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT AURAR.id
				,CAST(U.Nombre AS VARCHAR(MAX)) AS UsuarioId
			FROM RelAsig_Usuarios_A_Recursos AS AURAR
				INNER JOIN Recursos RECU ON RECU.id = AURAR.RecursoId
				INNER JOIN Usuarios U ON U.id = AURAR.UsuarioId
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(AURAR.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					AND (AURAR.RecursoId = @RecursoId OR @RecursoId = '-1') -- FiltroDDL (FK)
					AND (AURAR.UsuarioId = @UsuarioId OR @UsuarioId = '-1') -- FiltroDDL (FK)
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (U.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY U.Nombre
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: RelAsig_Usuarios_A_Recursos /Listados/ - FIN
 
 
 
 
-- SP-TABLA: ReservasDeRecursos /Listados/ - INICIO
IF (OBJECT_ID('usp_ReservasDeRecursos__Listado') IS NOT NULL) DROP PROCEDURE usp_ReservasDeRecursos__Listado
GO
CREATE PROCEDURE usp_ReservasDeRecursos__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@FechaDePedidoDesde                                       DATETIME = NULL
	,@FechaDePedidoHasta                                       DATETIME = NULL
	,@FechaDeAprobacionDesde                                   DATETIME = NULL
	,@FechaDeAprobacionHasta                                   DATETIME = NULL
	,@ReservaAprobada                                          BIT = NULL
	,@FechaDeInicioDesde                                       DATETIME = NULL
	,@FechaDeInicioHasta                                       DATETIME = NULL
	,@FechaLimiteDesde                                         DATETIME = NULL
	,@FechaLimiteHasta                                         DATETIME = NULL
	,@RecursoId                                                INT = '-1' -- FiltroDDL (FK)
	,@UsuarioOriginanteId                                      INT = '-1' -- FiltroDDL (FK)
	,@UsuarioDestinatarioId                                    INT = '-1' -- FiltroDDL (FK)
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'ReservasDeRecursos'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT RESDR.id
						,RESDR.UsuarioOriginanteId
						,RESDR.UsuarioDestinatarioId
						,RESDR.RecursoId
						,RESDR.FechaDePedido
						,dbo.ufc_Fechas__FormatoFechaComoTexto(RESDR.FechaDePedido) AS FechaDePedidoFormateado
						,RESDR.FechaDeAprobacion
						,dbo.ufc_Fechas__FormatoFechaComoTexto(RESDR.FechaDeAprobacion) AS FechaDeAprobacionFormateado
						,RESDR.ReservaAprobada
						,RESDR.FechaDeInicio
						,dbo.ufc_Fechas__FormatoFechaComoTexto(RESDR.FechaDeInicio) AS FechaDeInicioFormateado
						,RESDR.FechaLimite
						,dbo.ufc_Fechas__FormatoFechaComoTexto(RESDR.FechaLimite) AS FechaLimiteFormateado
						,RESDR.Numero
						,RECU.Nombre AS Recurso
						,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS UsuarioOriginante
						,dbo.ufc_Usuarios__NombreCompletoFormateado(U4.id) AS UsuarioDestinatario
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN RESDR.FechaDeInicio END DESC
								,CASE WHEN @OrdenarPor = 'FechaDePedido' AND @Sentido = '0' THEN RESDR.FechaDePedido END
								,CASE WHEN @OrdenarPor = 'FechaDePedido' AND @Sentido = '1' THEN RESDR.FechaDePedido END DESC
								,CASE WHEN @OrdenarPor = 'FechaDePedidoFormateado' AND @Sentido = '0' THEN RESDR.FechaDePedido END
								,CASE WHEN @OrdenarPor = 'FechaDePedidoFormateado' AND @Sentido = '1' THEN RESDR.FechaDePedido END DESC
								,CASE WHEN @OrdenarPor = 'FechaDeAprobacion' AND @Sentido = '0' THEN RESDR.FechaDeAprobacion END
								,CASE WHEN @OrdenarPor = 'FechaDeAprobacion' AND @Sentido = '1' THEN RESDR.FechaDeAprobacion END DESC
								,CASE WHEN @OrdenarPor = 'FechaDeAprobacionFormateado' AND @Sentido = '0' THEN RESDR.FechaDeAprobacion END
								,CASE WHEN @OrdenarPor = 'FechaDeAprobacionFormateado' AND @Sentido = '1' THEN RESDR.FechaDeAprobacion END DESC
								,CASE WHEN @OrdenarPor = 'FechaDeInicio' AND @Sentido = '0' THEN RESDR.FechaDeInicio END
								,CASE WHEN @OrdenarPor = 'FechaDeInicio' AND @Sentido = '1' THEN RESDR.FechaDeInicio END DESC
								,CASE WHEN @OrdenarPor = 'FechaDeInicioFormateado' AND @Sentido = '0' THEN RESDR.FechaDeInicio END
								,CASE WHEN @OrdenarPor = 'FechaDeInicioFormateado' AND @Sentido = '1' THEN RESDR.FechaDeInicio END DESC
								,CASE WHEN @OrdenarPor = 'FechaLimite' AND @Sentido = '0' THEN RESDR.FechaLimite END
								,CASE WHEN @OrdenarPor = 'FechaLimite' AND @Sentido = '1' THEN RESDR.FechaLimite END DESC
								,CASE WHEN @OrdenarPor = 'FechaLimiteFormateado' AND @Sentido = '0' THEN RESDR.FechaLimite END
								,CASE WHEN @OrdenarPor = 'FechaLimiteFormateado' AND @Sentido = '1' THEN RESDR.FechaLimite END DESC
								,CASE WHEN @OrdenarPor = 'Numero' AND @Sentido = '0' THEN RESDR.Numero END
								,CASE WHEN @OrdenarPor = 'Numero' AND @Sentido = '1' THEN RESDR.Numero END DESC
								,CASE WHEN @OrdenarPor = 'Recurso' AND @Sentido = '0' THEN RECU.Nombre END
								,CASE WHEN @OrdenarPor = 'Recurso' AND @Sentido = '1' THEN RECU.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'UsuarioOriginante' AND @Sentido = '0' THEN U.Apellido END
								,CASE WHEN @OrdenarPor = 'UsuarioOriginante' AND @Sentido = '0' THEN U.Nombre END
								,CASE WHEN @OrdenarPor = 'UsuarioOriginante' AND @Sentido = '1' THEN U.Apellido END DESC
								,CASE WHEN @OrdenarPor = 'UsuarioOriginante' AND @Sentido = '1' THEN U.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'UsuarioDestinatario' AND @Sentido = '0' THEN U4.Apellido END
								,CASE WHEN @OrdenarPor = 'UsuarioDestinatario' AND @Sentido = '0' THEN U4.Nombre END
								,CASE WHEN @OrdenarPor = 'UsuarioDestinatario' AND @Sentido = '1' THEN U4.Apellido END DESC
								,CASE WHEN @OrdenarPor = 'UsuarioDestinatario' AND @Sentido = '1' THEN U4.Nombre END DESC
						) AS NumeroDeRegistro
					FROM ReservasDeRecursos AS RESDR
						INNER JOIN Contextos CX ON CX.id = RESDR.ContextoId
						INNER JOIN Recursos RECU ON RECU.id = RESDR.RecursoId
						INNER JOIN Usuarios U ON U.id = RESDR.UsuarioOriginanteId
						INNER JOIN Usuarios U4 ON U4.id = RESDR.UsuarioDestinatarioId
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = RESDR.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(RESDR.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (RESDR.ContextoId = @ContextoId OR @ContextoId = '-1')
						AND (RESDR.FechaDePedido >= @FechaDePedidoDesde OR @FechaDePedidoDesde IS NULL)
						AND (RESDR.FechaDePedido <= @FechaDePedidoHasta OR @FechaDePedidoHasta IS NULL)
						AND (RESDR.FechaDeAprobacion >= @FechaDeAprobacionDesde OR @FechaDeAprobacionDesde IS NULL)
						AND (RESDR.FechaDeAprobacion <= @FechaDeAprobacionHasta OR @FechaDeAprobacionHasta IS NULL)
						AND (RESDR.ReservaAprobada = @ReservaAprobada OR @ReservaAprobada IS NULL)
						AND (RESDR.FechaDeInicio >= @FechaDeInicioDesde OR @FechaDeInicioDesde IS NULL)
						AND (RESDR.FechaDeInicio <= @FechaDeInicioHasta OR @FechaDeInicioHasta IS NULL)
						AND (RESDR.FechaLimite >= @FechaLimiteDesde OR @FechaLimiteDesde IS NULL)
						AND (RESDR.FechaLimite <= @FechaLimiteHasta OR @FechaLimiteHasta IS NULL)
						AND (RESDR.RecursoId = @RecursoId OR @RecursoId = '-1') -- FiltroDDL (FK)
						AND (RESDR.UsuarioOriginanteId = @UsuarioOriginanteId OR @UsuarioOriginanteId = '-1') -- FiltroDDL (FK)
						AND (RESDR.UsuarioDestinatarioId = @UsuarioDestinatarioId OR @UsuarioDestinatarioId = '-1') -- FiltroDDL (FK)
						AND
						(
							(@Filtro = '')
							OR (RESDR.FechaDePedido LIKE '%' + @Filtro + '%')
							OR (RESDR.FechaDeAprobacion LIKE '%' + @Filtro + '%')
							OR (RESDR.FechaDeInicio LIKE '%' + @Filtro + '%')
							OR (RESDR.FechaLimite LIKE '%' + @Filtro + '%')
							OR (RESDR.Numero LIKE '%' + @Filtro + '%')
							OR (RECU.Nombre LIKE '%' + @Filtro + '%')
							OR (U.Apellido LIKE '%' + @Filtro + '%')
							OR (U.Nombre LIKE '%' + @Filtro + '%')
							OR (U4.Apellido LIKE '%' + @Filtro + '%')
							OR (U4.Nombre LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_ReservasDeRecursos__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_ReservasDeRecursos__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_ReservasDeRecursos__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
	,@RecursoId                                                INT = '-1' -- FiltroDDL (FK)
	,@UsuarioOriginanteId                                      INT = '-1' -- FiltroDDL (FK)
	,@UsuarioDestinatarioId                                    INT = '-1' -- FiltroDDL (FK)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'ReservasDeRecursos'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SELECT RESDR.id
				,CAST(RESDR.FechaDeInicio AS VARCHAR(MAX)) + ' [Nº ' + CAST(RESDR.Numero AS VARCHAR(MAX)) + ']' AS FechaDeInicio
			FROM ReservasDeRecursos AS RESDR
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(RESDR.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					AND (RESDR.RecursoId = @RecursoId OR @RecursoId = '-1') -- FiltroDDL (FK)
					AND (RESDR.UsuarioOriginanteId = @UsuarioOriginanteId OR @UsuarioOriginanteId = '-1') -- FiltroDDL (FK)
					AND (RESDR.UsuarioDestinatarioId = @UsuarioDestinatarioId OR @UsuarioDestinatarioId = '-1') -- FiltroDDL (FK)
					 AND (RESDR.ContextoId = @ContextoId OR @ContextoId = '-1')
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (RESDR.FechaDeInicio LIKE '%' + @Filtro + '%')
				)
			ORDER BY RESDR.FechaDeInicio, RESDR.Numero
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: ReservasDeRecursos /Listados/ - FIN
 
 
 
 
-- SP-TABLA: Secciones /Listados/ - INICIO
IF (OBJECT_ID('usp_Secciones__Listado') IS NOT NULL) DROP PROCEDURE usp_Secciones__Listado
GO
CREATE PROCEDURE usp_Secciones__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Secciones'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT Secc.id
						,Secc.Nombre
						,Secc.NombreAMostrar
						,Secc.Observaciones
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN Secc.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN Secc.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN Secc.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'NombreAMostrar' AND @Sentido = '0' THEN Secc.NombreAMostrar END
								,CASE WHEN @OrdenarPor = 'NombreAMostrar' AND @Sentido = '1' THEN Secc.NombreAMostrar END DESC
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '0' THEN Secc.Observaciones END
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '1' THEN Secc.Observaciones END DESC
						) AS NumeroDeRegistro
					FROM Secciones AS Secc
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = Secc.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(Secc.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND
						(
							(@Filtro = '')
							OR (Secc.Nombre LIKE '%' + @Filtro + '%')
							OR (Secc.NombreAMostrar LIKE '%' + @Filtro + '%')
							OR (Secc.Observaciones LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_Secciones__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_Secciones__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_Secciones__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Secciones'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT Secc.id
				,CAST(Secc.Nombre AS VARCHAR(MAX)) AS Nombre
			FROM Secciones AS Secc
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(Secc.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (Secc.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY Secc.Nombre
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: Secciones /Listados/ - FIN
 
 
 
 
-- SP-TABLA: SPs /Listados/ - INICIO
IF (OBJECT_ID('usp_SPs__Listado') IS NOT NULL) DROP PROCEDURE usp_SPs__Listado
GO
CREATE PROCEDURE usp_SPs__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@SeDebenEvaluarPermisos                                   BIT = NULL
	,@GeneracionDeEmailHabilitada                              BIT = NULL
	,@GeneracionDeNotificacionesHabilitada                     BIT = NULL
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'SPs'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT SPs.id
						,SPs.Nombre
						,SPs.SeDebenEvaluarPermisos
						,SPs.Observaciones
						,SPs.GeneracionDeEmailHabilitada
						,SPs.GeneracionDeNotificacionesHabilitada
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN SPs.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN SPs.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN SPs.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '0' THEN SPs.Observaciones END
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '1' THEN SPs.Observaciones END DESC
						) AS NumeroDeRegistro
					FROM SPs AS SPs
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = SPs.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(SPs.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (SPs.SeDebenEvaluarPermisos = @SeDebenEvaluarPermisos OR @SeDebenEvaluarPermisos IS NULL)
						AND (SPs.GeneracionDeEmailHabilitada = @GeneracionDeEmailHabilitada OR @GeneracionDeEmailHabilitada IS NULL)
						AND (SPs.GeneracionDeNotificacionesHabilitada = @GeneracionDeNotificacionesHabilitada OR @GeneracionDeNotificacionesHabilitada IS NULL)
						AND
						(
							(@Filtro = '')
							OR (SPs.Nombre LIKE '%' + @Filtro + '%')
							OR (SPs.Observaciones LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_SPs__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_SPs__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_SPs__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'SPs'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT SPs.id
				,CAST(SPs.Nombre AS VARCHAR(MAX)) AS Nombre
			FROM SPs AS SPs
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(SPs.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (SPs.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY SPs.Nombre
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: SPs /Listados/ - FIN
 
 
 
 
-- SP-TABLA: Subsistemas /Listados/ - INICIO
IF (OBJECT_ID('usp_Subsistemas__Listado') IS NOT NULL) DROP PROCEDURE usp_Subsistemas__Listado
GO
CREATE PROCEDURE usp_Subsistemas__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@Activo                                                   BIT = '1'
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Subsistemas'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT SUBS.id
						,SUBS.Nombre
						,SUBS.Observaciones
						,SUBS.Activo
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN SUBS.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN SUBS.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN SUBS.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '0' THEN SUBS.Observaciones END
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '1' THEN SUBS.Observaciones END DESC
						) AS NumeroDeRegistro
					FROM Subsistemas AS SUBS
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = SUBS.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(SUBS.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (SUBS.Activo = @Activo OR @Activo IS NULL)
						AND
						(
							(@Filtro = '')
							OR (SUBS.Nombre LIKE '%' + @Filtro + '%')
							OR (SUBS.Observaciones LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_Subsistemas__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_Subsistemas__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_Subsistemas__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
	,@Activo                                                   BIT = '1'
 
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Subsistemas'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT SUBS.id
				,CAST(SUBS.Nombre AS VARCHAR(MAX)) AS Nombre
			FROM Subsistemas AS SUBS
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(SUBS.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					 AND (SUBS.Activo = @Activo OR @Activo IS NULL)
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (SUBS.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY SUBS.Nombre
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: Subsistemas /Listados/ - FIN
 
 
 
 
-- SP-TABLA: TablasYFuncionesDePaginas /Listados/ - INICIO
IF (OBJECT_ID('usp_TablasYFuncionesDePaginas__Listado') IS NOT NULL) DROP PROCEDURE usp_TablasYFuncionesDePaginas__Listado
GO
CREATE PROCEDURE usp_TablasYFuncionesDePaginas__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@SeDebenEvaluarPermisos                                   BIT = NULL
	,@FuncionDePaginaId                                        INT = '-1' -- FiltroDDL (FK)
	,@TablaId                                                  INT = '-1' -- FiltroDDL (FK)
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TablasYFuncionesDePaginas'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT TyFDP.id
						,TyFDP.TablaId
						,TyFDP.FuncionDePaginaId
						,TyFDP.SeDebenEvaluarPermisos
						,TyFDP.Observaciones
						,FDP.Nombre AS FuncionDePagina
						,T.Nombre AS Tabla
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN TyFDP.TablaId END 
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '0' THEN TyFDP.Observaciones END
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '1' THEN TyFDP.Observaciones END DESC
								,CASE WHEN @OrdenarPor = 'FuncionDePagina' AND @Sentido = '0' THEN FDP.Nombre END
								,CASE WHEN @OrdenarPor = 'FuncionDePagina' AND @Sentido = '1' THEN FDP.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Tabla' AND @Sentido = '0' THEN T.Nombre END
								,CASE WHEN @OrdenarPor = 'Tabla' AND @Sentido = '1' THEN T.Nombre END DESC
						) AS NumeroDeRegistro
					FROM TablasYFuncionesDePaginas AS TyFDP
						INNER JOIN FuncionesDePaginas FDP ON FDP.id = TyFDP.FuncionDePaginaId
						INNER JOIN Tablas T ON T.id = TyFDP.TablaId
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = TyFDP.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(TyFDP.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (TyFDP.SeDebenEvaluarPermisos = @SeDebenEvaluarPermisos OR @SeDebenEvaluarPermisos IS NULL)
						AND (TyFDP.FuncionDePaginaId = @FuncionDePaginaId OR @FuncionDePaginaId = '-1') -- FiltroDDL (FK)
						AND (TyFDP.TablaId = @TablaId OR @TablaId = '-1') -- FiltroDDL (FK)
						AND
						(
							(@Filtro = '')
							OR (TyFDP.Observaciones LIKE '%' + @Filtro + '%')
							OR (FDP.Nombre LIKE '%' + @Filtro + '%')
							OR (T.Nombre LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_TablasYFuncionesDePaginas__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_TablasYFuncionesDePaginas__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_TablasYFuncionesDePaginas__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
	,@FuncionDePaginaId                                        INT = '-1' -- FiltroDDL (FK)
	,@TablaId                                                  INT = '-1' -- FiltroDDL (FK)
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TablasYFuncionesDePaginas'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT TyFDP.id
				,CAST(TyFDP.TablaId AS VARCHAR(MAX)) AS TablaId
			FROM TablasYFuncionesDePaginas AS TyFDP
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(TyFDP.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					AND (TyFDP.FuncionDePaginaId = @FuncionDePaginaId OR @FuncionDePaginaId = '-1') -- FiltroDDL (FK)
					AND (TyFDP.TablaId = @TablaId OR @TablaId = '-1') -- FiltroDDL (FK)
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (TyFDP.TablaId LIKE '%' + @Filtro + '%')
				)
			ORDER BY TyFDP.TablaId
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: TablasYFuncionesDePaginas /Listados/ - FIN
 
 
 
 
-- SP-TABLA: TiposDeActores /Listados/ - INICIO
IF (OBJECT_ID('usp_TiposDeActores__Listado') IS NOT NULL) DROP PROCEDURE usp_TiposDeActores__Listado
GO
CREATE PROCEDURE usp_TiposDeActores__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TiposDeActores'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT TDA.id
						,TDA.Nombre
						,TDA.Observaciones
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN TDA.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN TDA.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN TDA.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '0' THEN TDA.Observaciones END
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '1' THEN TDA.Observaciones END DESC
						) AS NumeroDeRegistro
					FROM TiposDeActores AS TDA
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = TDA.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(TDA.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND
						(
							(@Filtro = '')
							OR (TDA.Nombre LIKE '%' + @Filtro + '%')
							OR (TDA.Observaciones LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_TiposDeActores__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_TiposDeActores__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_TiposDeActores__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TiposDeActores'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT TDA.id
				,CAST(TDA.Nombre AS VARCHAR(MAX)) AS Nombre
			FROM TiposDeActores AS TDA
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(TDA.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (TDA.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY TDA.Nombre
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: TiposDeActores /Listados/ - FIN
 
 
 
 
-- SP-TABLA: TiposDeArchivos /Listados/ - INICIO
IF (OBJECT_ID('usp_TiposDeArchivos__Listado') IS NOT NULL) DROP PROCEDURE usp_TiposDeArchivos__Listado
GO
CREATE PROCEDURE usp_TiposDeArchivos__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TiposDeArchivos'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT TDARCH.id
						,TDARCH.Nombre
						,TDARCH.Observaciones
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN TDARCH.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN TDARCH.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN TDARCH.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '0' THEN TDARCH.Observaciones END
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '1' THEN TDARCH.Observaciones END DESC
						) AS NumeroDeRegistro
					FROM TiposDeArchivos AS TDARCH
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = TDARCH.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(TDARCH.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND
						(
							(@Filtro = '')
							OR (TDARCH.Nombre LIKE '%' + @Filtro + '%')
							OR (TDARCH.Observaciones LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_TiposDeArchivos__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_TiposDeArchivos__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_TiposDeArchivos__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TiposDeArchivos'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT TDARCH.id
				,CAST(TDARCH.Nombre AS VARCHAR(MAX)) AS Nombre
			FROM TiposDeArchivos AS TDARCH
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(TDARCH.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (TDARCH.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY TDARCH.Nombre
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: TiposDeArchivos /Listados/ - FIN
 
 
 
 
-- SP-TABLA: TiposDeContactos /Listados/ - INICIO
IF (OBJECT_ID('usp_TiposDeContactos__Listado') IS NOT NULL) DROP PROCEDURE usp_TiposDeContactos__Listado
GO
CREATE PROCEDURE usp_TiposDeContactos__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TiposDeContactos'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT TDC.id
						,TDC.Nombre
						,TDC.Observaciones
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN TDC.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN TDC.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN TDC.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '0' THEN TDC.Observaciones END
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '1' THEN TDC.Observaciones END DESC
						) AS NumeroDeRegistro
					FROM TiposDeContactos AS TDC
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = TDC.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(TDC.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND
						(
							(@Filtro = '')
							OR (TDC.Nombre LIKE '%' + @Filtro + '%')
							OR (TDC.Observaciones LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_TiposDeContactos__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_TiposDeContactos__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_TiposDeContactos__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TiposDeContactos'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT TDC.id
				,CAST(TDC.Nombre AS VARCHAR(MAX)) AS Nombre
			FROM TiposDeContactos AS TDC
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(TDC.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (TDC.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY TDC.Nombre
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: TiposDeContactos /Listados/ - FIN
 
 
 
 
-- SP-TABLA: TiposDeLogLogins /Listados/ - INICIO
IF (OBJECT_ID('usp_TiposDeLogLogins__Listado') IS NOT NULL) DROP PROCEDURE usp_TiposDeLogLogins__Listado
GO
CREATE PROCEDURE usp_TiposDeLogLogins__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@ConCookie                                                BIT = NULL
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TiposDeLogLogins'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT TDLL.id
						,TDLL.ConCookie
						,TDLL.Nombre
						,TDLL.MensajeDeError
						,TDLL.Observaciones
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN TDLL.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN TDLL.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN TDLL.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'MensajeDeError' AND @Sentido = '0' THEN TDLL.MensajeDeError END
								,CASE WHEN @OrdenarPor = 'MensajeDeError' AND @Sentido = '1' THEN TDLL.MensajeDeError END DESC
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '0' THEN TDLL.Observaciones END
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '1' THEN TDLL.Observaciones END DESC
						) AS NumeroDeRegistro
					FROM TiposDeLogLogins AS TDLL
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = TDLL.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(TDLL.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (TDLL.ConCookie = @ConCookie OR @ConCookie IS NULL)
						AND
						(
							(@Filtro = '')
							OR (TDLL.Nombre LIKE '%' + @Filtro + '%')
							OR (TDLL.MensajeDeError LIKE '%' + @Filtro + '%')
							OR (TDLL.Observaciones LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_TiposDeLogLogins__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_TiposDeLogLogins__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_TiposDeLogLogins__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TiposDeLogLogins'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT TDLL.id
				,CAST(TDLL.Nombre AS VARCHAR(MAX)) AS Nombre
			FROM TiposDeLogLogins AS TDLL
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(TDLL.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (TDLL.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY TDLL.Nombre
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: TiposDeLogLogins /Listados/ - FIN
 
 
 
 
-- SP-TABLA: TiposDeOperaciones /Listados/ - INICIO
IF (OBJECT_ID('usp_TiposDeOperaciones__Listado') IS NOT NULL) DROP PROCEDURE usp_TiposDeOperaciones__Listado
GO
CREATE PROCEDURE usp_TiposDeOperaciones__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TiposDeOperaciones'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT TDO.id
						,TDO.Nombre
						,TDO.Texto
						,TDO.Observaciones
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN TDO.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN TDO.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN TDO.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Texto' AND @Sentido = '0' THEN TDO.Texto END
								,CASE WHEN @OrdenarPor = 'Texto' AND @Sentido = '1' THEN TDO.Texto END DESC
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '0' THEN TDO.Observaciones END
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '1' THEN TDO.Observaciones END DESC
						) AS NumeroDeRegistro
					FROM TiposDeOperaciones AS TDO
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = TDO.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(TDO.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND
						(
							(@Filtro = '')
							OR (TDO.Nombre LIKE '%' + @Filtro + '%')
							OR (TDO.Texto LIKE '%' + @Filtro + '%')
							OR (TDO.Observaciones LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_TiposDeOperaciones__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_TiposDeOperaciones__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_TiposDeOperaciones__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TiposDeOperaciones'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT TDO.id
				,CAST(TDO.Nombre AS VARCHAR(MAX)) AS Nombre
			FROM TiposDeOperaciones AS TDO
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(TDO.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (TDO.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY TDO.Nombre
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: TiposDeOperaciones /Listados/ - FIN
 
 
 
 
-- SP-TABLA: TiposDeTareas /Listados/ - INICIO
IF (OBJECT_ID('usp_TiposDeTareas__Listado') IS NOT NULL) DROP PROCEDURE usp_TiposDeTareas__Listado
GO
CREATE PROCEDURE usp_TiposDeTareas__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@Activo                                                   BIT = '1'
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TiposDeTareas'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT TDT.id
						,TDT.Nombre
						,TDT.Observaciones
						,TDT.Activo
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN TDT.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN TDT.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN TDT.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '0' THEN TDT.Observaciones END
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '1' THEN TDT.Observaciones END DESC
						) AS NumeroDeRegistro
					FROM TiposDeTareas AS TDT
						INNER JOIN Contextos CX ON CX.id = TDT.ContextoId
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = TDT.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(TDT.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (TDT.ContextoId = @ContextoId OR @ContextoId = '-1')
						AND (TDT.Activo = @Activo OR @Activo IS NULL)
						AND
						(
							(@Filtro = '')
							OR (TDT.Nombre LIKE '%' + @Filtro + '%')
							OR (TDT.Observaciones LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_TiposDeTareas__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_TiposDeTareas__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_TiposDeTareas__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
	,@Activo                                                   BIT = '1'
 
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TiposDeTareas'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SELECT TDT.id
				,CAST(TDT.Nombre AS VARCHAR(MAX)) AS Nombre
			FROM TiposDeTareas AS TDT
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(TDT.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					 AND (TDT.Activo = @Activo OR @Activo IS NULL)
					 AND (TDT.ContextoId = @ContextoId OR @ContextoId = '-1')
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (TDT.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY TDT.Nombre
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: TiposDeTareas /Listados/ - FIN
 
 
 
 
-- SP-TABLA: Ubicaciones /Listados/ - INICIO
IF (OBJECT_ID('usp_Ubicaciones__Listado') IS NOT NULL) DROP PROCEDURE usp_Ubicaciones__Listado
GO
CREATE PROCEDURE usp_Ubicaciones__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
	,@UbicacionAbsoluta                                        BIT = NULL
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Ubicaciones'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT UB.id
						,UB.Nombre
						,UB.Observaciones
						,UB.UbicacionAbsoluta
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN UB.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN UB.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN UB.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '0' THEN UB.Observaciones END
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '1' THEN UB.Observaciones END DESC
						) AS NumeroDeRegistro
					FROM Ubicaciones AS UB
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = UB.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(UB.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (UB.UbicacionAbsoluta = @UbicacionAbsoluta OR @UbicacionAbsoluta IS NULL)
						AND
						(
							(@Filtro = '')
							OR (UB.Nombre LIKE '%' + @Filtro + '%')
							OR (UB.Observaciones LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_Ubicaciones__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_Ubicaciones__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_Ubicaciones__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Ubicaciones'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT UB.id
				,CAST(UB.Nombre AS VARCHAR(MAX)) AS Nombre
			FROM Ubicaciones AS UB
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(UB.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (UB.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY UB.Nombre
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: Ubicaciones /Listados/ - FIN
 
 
 
 
-- SP-TABLA: Unidades /Listados/ - INICIO
IF (OBJECT_ID('usp_Unidades__Listado') IS NOT NULL) DROP PROCEDURE usp_Unidades__Listado
GO
CREATE PROCEDURE usp_Unidades__Listado
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
 
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = '0'
	,@Filtro					VARCHAR(50) = ''
 
 
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = '1'
	,@TotalDeRegistros			INT		OUTPUT
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Unidades'
		,@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT UD.id
						,UD.Codigo
						,UD.Nombre
						,UD.Observaciones
					--	,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN UD.Nombre END 
								,CASE WHEN @OrdenarPor = 'Codigo' AND @Sentido = '0' THEN UD.Codigo END
								,CASE WHEN @OrdenarPor = 'Codigo' AND @Sentido = '1' THEN UD.Codigo END DESC
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN UD.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN UD.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '0' THEN UD.Observaciones END
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '1' THEN UD.Observaciones END DESC
						) AS NumeroDeRegistro
					FROM Unidades AS UD
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = UD.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(UD.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND
						(
							(@Filtro = '')
							OR (UD.Codigo LIKE '%' + @Filtro + '%')
							OR (UD.Nombre LIKE '%' + @Filtro + '%')
							OR (UD.Observaciones LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginación
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginación
 
			SET @TotalDeRegistros = (SELECT	COUNT(*) FROM  #TempTable)
			DROP TABLE #TempTable
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
 
 
 
 
IF (OBJECT_ID('usp_Unidades__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_Unidades__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_Unidades__ListadoDDLoCBXL
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
 
	,@id						INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro					VARCHAR(50) = ''
 
 
	,@sResSQL                   VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Unidades'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
 
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP
				--, @RegistroId = @id
				--, @UsuarioId = @UsuarioId OUTPUT
				, @sResSQL = @sResSQL OUTPUT
 
	IF @sResSQL = ''
		BEGIN 
			SELECT UD.id
				,CAST(UD.Nombre AS VARCHAR(MAX)) + ' [' + CAST(UD.Codigo AS VARCHAR(MAX)) + ']' AS Nombre
			FROM Unidades AS UD
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(UD.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que también afecta al registro @id:
				(
					(@Filtro = '')
					OR (UD.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY UD.Nombre, UD.Codigo
		END
END TRY
BEGIN CATCH
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
END CATCH
GO
-- SP-TABLA: Unidades /Listados/ - FIN
 
 
 
 
-- ---------------------------
-- Script: DB_ParticularCore__C12a_Listados Generados Automaticamente - v10.8 - FIN
-- ==========================================================================================================

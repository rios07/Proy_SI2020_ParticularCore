-- =====================================================
-- Descripción: Listados Especiales.sql
-- Script: DB_ParticularCore__C12c_Listados Especiales.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO

		-- Tablas Involucradas: - INICIO
			-- Archivos
			-- RelAsig_RolesDeUsuarios_A_Usuarios
			-- RelAsig_Usuarios_A_Recursos
			-- Soportes
			-- TiposDeContactos
		-- Tablas Involucradas: - FIN


-- SP-TABLA: Archivos /Listados Especiales/ - INICIO
IF (OBJECT_ID('usp_Archivos__Listado_y_SwapOrden') IS NOT NULL) DROP PROCEDURE usp_Archivos__Listado_y_SwapOrden
GO
CREATE PROCEDURE usp_Archivos__Listado_y_SwapOrden
	@UsuarioQueEjecutaId		INT						
	,@FechaDeEjecucion			DATETIME				
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
	
	,@Tabla						VARCHAR(80) -- Es la Tabla de "referencia" del Archivo; EJ: "Informes"
	,@RegistroId				INT -- Es el id del Archivo de referencia, o sea, "el id del Informe"
	
	,@SwapOrdenDelRegistroId	INT -- Es el id del Archivo que queremos "Subir" 1 nivel.
	
	,@sResSQL					VARCHAR(1000)			OUTPUT
AS
BEGIN TRY
	DECLARE --@Tabla VARCHAR(80) = 'Archivos'
		@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	-- Validará contra la tabla: @Tabla
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			--, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
	
	IF @sResSQL = '' -- Ejecuté el cambio de orden, y devuelvo ordenado
		BEGIN
			EXEC usp_Archivos_SwapOrden  
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					,@FechaDeEjecucion = @FechaDeEjecucion
					,@Token = @Token
					,@Seccion = @Seccion
					,@CodigoDelContexto = @CodigoDelContexto
					,@Tabla = @Tabla
					,@RegistroId = @RegistroId
					,@SwapOrdenDelRegistroId = @SwapOrdenDelRegistroId
					,@sResSQL = @sResSQL OUTPUT
				
			IF @sResSQL = '' -- Ejecuté el cambio de orden, y devuelvo ordenado
				BEGIN
					DECLARE @ContextoId INT 
					EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
					
					DECLARE @TablaId INT = (SELECT id FROM Tablas WHERE Nombre = @Tabla)
					
					
					
					DECLARE @UbicacionRelativaCompleta VARCHAR(100)
					EXEC @UbicacionRelativaCompleta = ufc_Ubicaciones__RelativaCompletaDeConenidosDeTabla  
															@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
															,@TablaId = @TablaId
															,@Seccion = @Seccion
															,@CodigoDelContexto = @CodigoDelContexto
													
					DECLARE @UbicacionDeIconos VARCHAR(100)
					EXEC @UbicacionDeIconos = ufc_Ubicaciones__RelativaDeIconos

					SELECT 	A.id
							,@UbicacionRelativaCompleta + '/' + A.NombreFisicoCompleto AS srcArchivo -- Source completo del archivo.
							,A.NombreAMostrar
							,A.Observaciones
							,@UbicacionDeIconos + '/' + ICO.Imagen AS srcIcono -- Source completo del ícono.
							,EXTDA.ProgramaAsociado
							,EXTDA.Nombre AS Extension
					FROM Archivos A
						INNER JOIN ExtensionesDeArchivos EXTDA ON EXTDA.id = A.ExtensionDeArchivoId
						INNER JOIN Iconos ICO ON ICO.id = EXTDA.IconoId
					WHERE A.TablaId = @TablaId AND A.RegistroId = @RegistroId AND A.ContextoId = @ContextoId
					ORDER BY A.Orden
				END
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




IF (OBJECT_ID('usp_Archivos__ListadoDeHuerfanos') IS NOT NULL) DROP PROCEDURE usp_Archivos__ListadoDeHuerfanos
GO
CREATE PROCEDURE usp_Archivos__ListadoDeHuerfanos
	@UsuarioQueEjecutaId		INT						
	,@FechaDeEjecucion			DATETIME				
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
	
	,@Tabla						VARCHAR(80)
	
	,@sResSQL					VARCHAR(1000)			OUTPUT
AS
BEGIN TRY
	DECLARE --@Tabla VARCHAR(80) = 'Archivos'
		@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	---- Validará contra la tabla: @Tabla
	--EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
	--		, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
	--		--, @RegistroId = @id 
	--		--, @UsuarioId = @UsuarioId OUTPUT 
	--		, @sResSQL = @sResSQL OUTPUT
	
	SET @sResSQL = ''
	
	IF @sResSQL = ''
		BEGIN
			DECLARE @TablaId INT = (SELECT id FROM Tablas WHERE Nombre = @Tabla)
	
			CREATE TABLE #RegistrosHuerfanos (id INT
						,RegistroId INT
						,TablaId INT
						,NombreFisicoCompleto VARCHAR(100)
						,NombreAMostrar VARCHAR(100)
					)	
					
			DECLARE @Parametros NVARCHAR(MAX) --Es necesario NVARCHAR
				,@sql NVARCHAR(MAX)
	
			SET @Parametros = N'@Tabla VARCHAR(80)'

			SET  @sql =	('SELECT 	A.id
									,A.RegistroId
									,A.TablaId
									,A.NombreFisicoCompleto
									,A.NombreAMostrar
							FROM Archivos A
							WHERE (SELECT id FROM ' + @Tabla + ' WHERE id = A.RegistroId) IS NULL '
								+ 'AND A.TablaId = ' + CAST(@TablaId AS VARCHAR) 
								+ ' ORDER BY A.RegistroId'
						)
			
			INSERT INTO #RegistrosHuerfanos EXEC sp_executesql @sql, @Parametros, @Tabla = @Tabla

			SELECT * FROM #RegistrosHuerfanos 
			
			DROP TABLE #RegistrosHuerfanos
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
-- SP-TABLA: Archivos /Listados Especiales/ - FIN




-- SP-TABLA: LogRegistros /Listados Especiales/ - INICIO
IF (OBJECT_ID('usp_LogRegistros__Listado_HistoriaDeUnRegistro') IS NOT NULL) DROP PROCEDURE usp_LogRegistros__Listado_HistoriaDeUnRegistro
GO
CREATE PROCEDURE usp_LogRegistros__Listado_HistoriaDeUnRegistro
	@RegistroId					INT
	,@Tabla						VARCHAR(80)	
	
	,@Seccion					VARCHAR(30) 
	
	,@Historia					VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE --@Tabla VARCHAR(80) = ''
		@FuncionDePagina VARCHAR(30) = 'CargarHistoria'
		--,@AutorizadoA VARCHAR(30) = ''
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
		,@TablaId INT = (SELECT id FROM Tablas WHERE Nombre = @Tabla)
	
	CREATE TABLE #LogTemp
	(
		id_Temp	INT		PRIMARY KEY IDENTITY(1, 1)	NOT NULL
		,Dato	VARCHAR(200)
	)
	
	DECLARE @TextoPrivado VARCHAR(10)
	EXEC usp_VAL_Secciones__CorrespondeATextosPrivados @Seccion = @Seccion, @TextoPrivado = @TextoPrivado OUTPUT
			
	IF @TextoPrivado <> '' -- Si es una sección donde no hay que mostrar datosd --> tampoco mostramos la historia.
		BEGIN
			SET @Historia = @TextoPrivado
		END
	ELSE
		BEGIN
			--IF @RegistroCodigo = '-1'
			--	BEGIN
					INSERT INTO #LogTemp (Dato)
					-- La siguiente línea es SIN contexto
					-- SELECT  '<p>' +  TDOp.Texto + N' en la Fecha: ' + CAST(LREG.FechaDeEjecucion AS VARCHAR(MAX)) + N'  Por: ' + U.Apellido + N', ' + U.Nombre + N' (' + U.UserName + N')' + ' ' + '</p>' AS Dato		
					-- La siguiente línea es CON contexto
					SELECT  '<p>' +  TDOp.Texto + N' en la Fecha: ' + CAST(LREG.FechaDeEjecucion AS VARCHAR(MAX)) + N'  Por: ' + U.Apellido + N', ' + U.Nombre + N' (' + U.UserName + N'@' + CON.Codigo + N')</p>' AS Dato		
					FROM LogRegistros LREG
						INNER JOIN Usuarios U ON LREG.UsuarioQueEjecutaId = U.id
						INNER JOIN TiposDeOperaciones TDOp ON LREG.TipoDeOperacionId = TDOp.id
						-- Descomentar la siguiente línea para CON contexto, o comentarla para SIN
						INNER JOIN Contextos CON ON CON.id = U.ContextoId
					WHERE (RegistroId = @RegistroId AND TablaId = @TablaId)
					ORDER BY LREG.FechaDeEjecucion
			--	END
			--ELSE
			--	BEGIN
			--		INSERT INTO #LogTemp (Dato)
			--		-- La siguiente línea es SIN contexto
			--		-- SELECT  '<p>' +  TDOp.Texto + N' en la Fecha: ' + CAST(LREG.FechaDeEjecucion AS VARCHAR(MAX)) + N'  Por: ' + U.Apellido + N', ' + U.Nombre + N' (' + U.UserName + N')</p>' AS Dato		
			--		-- La siguiente línea es CON contexto
			--		SELECT  '<p>' +  TDOp.Texto + N' en la Fecha: ' + CAST(LREG.FechaDeEjecucion AS VARCHAR(MAX)) + N'  Por: ' + U.Apellido + N', ' + U.Nombre + N' (' + U. UserName + N'@' + CON.Codigo + N')</p>' AS Dato		
			--		FROM LogRegistros LREG
			--			INNER JOIN Usuarios U ON LREG.UsuarioQueEjecutaId = U.id
			--			INNER JOIN TiposDeOperaciones TDOp ON LREG.TipoDeOperacionId = TDOp.id
			--			-- Descomentar la siguiente línea para CON contexto, o comentarla para SIN
			--			INNER JOIN Contextos CON ON CON.id = U.ContextoId 
							
			--		WHERE (RegistroCodigo = @RegistroCodigo AND TablaId = @TablaId)
			--		ORDER BY LREG.FechaDeEjecucion
			--	END
			--ENDIF
			
			DECLARE @id_Temp INt = 1
			DECLARE @NumeroDeFilas  INT = (SELECT COUNT(0) FROM #LogTemp)
			
			--DECLARE @Dato AS VARCHAR(100)
			IF @NumeroDeFilas > 0 
				WHILE @id_Temp <= @NumeroDeFilas
					BEGIN
						--SET @Dato = (SELECT Dato FROM #LogTemp WHERE id_Temp = @id_Temp)
						--SET @sResSQL = COALESCE(@sResSQL + ', ', '') + @Dato
						SET @Historia = COALESCE(@Historia + '', '') + (SELECT Dato FROM #LogTemp WHERE id_Temp = @id_Temp)
						SET @id_Temp = @id_Temp + 1
					END
			ELSE
				BEGIN
					SET @Historia = 'El Registro no tiene "historia".'
				END
		END
		
	DROP TABLE #LogTemp
	
END TRY
BEGIN CATCH
	IF OBJECT_ID('tempdb..#LogTemp') IS NOT NULL DROP TABLE #LogTemp; --// Si saltó al CATCH pesiste la Tabla creada
	
	-- ESTE CATCH ES ESPECIAL:
	DECLARE @UsuarioQueEjecutaId INT = 1, @FechaDeEjecucion DATE = GetDate(), @Token VARCHAR(40) = NULL, @CodigoDelContexto VARCHAR(40), @sResSQL VARCHAR(1000)
	
	DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
	EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
			--, @RegistroId = @id 
			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
		
	SET @Historia = 'Se produjo un error, y no se puede mostrar la "historia" del registro.'
END CATCH
GO
-- SP-TABLA: LogRegistros /Listados Especiales/ - FIN




-- SP-TABLA: RelAsig_RolesDeUsuarios_A_Usuarios /Listados Especiales/ - INICIO
IF (OBJECT_ID('usp_RelAsig_RolesDeUsuarios_A_Usuarios__Listado_by_@UsuarioId') IS NOT NULL) DROP PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Usuarios__Listado_by_@UsuarioId
GO
CREATE PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Usuarios__Listado_by_@UsuarioId
	@UsuarioQueEjecutaId		INT						
	,@FechaDeEjecucion			DATETIME				
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
		
	,@sResSQL					VARCHAR(1000)	OUTPUT
	
	,@UsuarioId					INT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_RolesDeUsuarios_A_Usuarios'
		,@FuncionDePagina VARCHAR(30) = 'Listado' +	COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			--, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
	
	IF @sResSQL = ''
		BEGIN
			DECLARE @SeMuestraEnAsignacionDePermisos BIT		-- Roles A Páginas	
				,@SeMuestraEnAsignacionDeRoles BIT		-- Roles A Usuarios	
			
			EXEC usp_VAL_Usuarios__SeMuestraEnAsignacionDeRolesYPermisos  -- Validamos si puede ver los roles o no.
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					, @FechaDeEjecucion = @FechaDeEjecucion
					, @SeMuestraEnAsignacionDePermisos = @SeMuestraEnAsignacionDePermisos OUTPUT
					, @SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OUTPUT
				
			SELECT RARU.id 
				,RDU.id AS RolDeUsuarioId
				,RDU.Nombre AS Rol
				,(CASE WHEN RARU.UsuarioId = @UsuarioId AND (RARU.FechaHasta >= @FechaDeEjecucion OR RARU.FechaHasta IS NULL) THEN 1
					ELSE 0 END) AS Asignado
				,(CASE WHEN RARU.UsuarioId = @UsuarioId AND (RARU.FechaHasta >= @FechaDeEjecucion OR RARU.FechaHasta IS NULL) THEN RARU.FechaDesde
					ELSE NULL END) AS FechaDesde
				,(CASE WHEN RARU.UsuarioId = @UsuarioId AND (RARU.FechaHasta >= @FechaDeEjecucion OR RARU.FechaHasta IS NULL) THEN dbo.ufc_Fechas__FormatoFechaComoTexto(RARU.FechaDesde)
					ELSE '' END) AS FechaDesdeFormateado
				,(CASE WHEN RARU.UsuarioId = @UsuarioId AND (RARU.FechaHasta >= @FechaDeEjecucion OR RARU.FechaHasta IS NULL) THEN RARU.FechaHasta
					ELSE NULL END) AS FechaHasta
				,(CASE WHEN RARU.UsuarioId = @UsuarioId AND (RARU.FechaHasta >= @FechaDeEjecucion OR RARU.FechaHasta IS NULL) THEN dbo.ufc_Fechas__FormatoFechaComoTexto(RARU.FechaHasta)
					ELSE '' END) AS FechaHastaFormateado
				,RDU.SeMuestraEnAsignacionDePermisos AS PermiteEdicion
				,RDU.SeMuestraEnAsignacionDeRoles AS SeMuestraEnAsignacionDeRoles
				--,dbo.ufc_Fechas__FormatoFechaComoTexto(RARU.FechaDesde) AS FechaDesde
				--,dbo.ufc_Fechas__FormatoFechaComoTexto(RARU.FechaHasta) AS FechaHasta
			FROM RolesDeUsuarios RDU 
				LEFT JOIN RelAsig_RolesDeUsuarios_A_Usuarios RARU ON RARU.RolDeUsuarioId = RDU.id AND RARU.UsuarioId = @UsuarioId
				--INNER JOIN Usuarios U ON RARU.UsuarioId = U.id // No va por que hay que mostrar también los roles que NO tiene asignado el usuario para que pueda realizarse la asignación.
			WHERE (RDU.Activo = '1')
				
				AND (RDU.SeMuestraEnAsignacionDePermisos = @SeMuestraEnAsignacionDePermisos OR @SeMuestraEnAsignacionDePermisos IS NULL)
				AND (RDU.SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OR @SeMuestraEnAsignacionDeRoles IS NULL)
				--AND (U.SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OR @SeMuestraEnAsignacionDeRoles IS NULL) // No va por que hay que mostrar también los roles que NO tiene asignado el usuario para que pueda realizarse la asignación.
				
				AND
				(
					--SI ES UN ROL QUE ESTARÁ ACTIVO EN EL FUTURO LO MUESTRO TAMBIEN
					--NO VALIDO QUE LA FECHA DE INICIO SEA MENOR A LA FECHA ACTUAL
						--RARU.FechaDesde <= @FechaDeEjecucion
					--AND 
					(RARU.FechaHasta >= @FechaDeEjecucion OR RARU.FechaHasta IS NULL)
					OR (RARU.id IS NULL)
				)
				--AND
				--(
				--	RDU.id <> dbo.ufc_RolDeUsuario_MasterAdmin() 
				--	OR (SELECT id FROM RelAsig_RolesDeUsuarios_A_Usuarios 
				--		WHERE RolDeUsuarioId = dbo.ufc_RolDeUsuario_MasterAdmin()  
				--			AND UsuarioId = @UsuarioQueEjecutaId
				--		)  IS NOT NULL
				--)	
			--	ORDER BY RDU.Nombre // Si lo ordenamos x nombre, no funca el asignar rol
			ORDER BY RDU.id
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
-- SP-TABLA: RelAsig_RolesDeUsuarios_A_Usuarios /Listados Especiales/ - FIN




-- SP-TABLA: usp_RelAsig_Usuarios_A_Recursos__Listado_by_@RecursoId /Listados Especiales/ - INICIO
IF (OBJECT_ID('usp_RelAsig_Usuarios_A_Recursos__Listado_by_@RecursoId') IS NOT NULL) DROP PROCEDURE usp_RelAsig_Usuarios_A_Recursos__Listado_by_@RecursoId
GO
CREATE PROCEDURE usp_RelAsig_Usuarios_A_Recursos__Listado_by_@RecursoId
	@UsuarioQueEjecutaId		INT						
	,@FechaDeEjecucion			DATETIME				
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
		
	,@RecursoId					INT

	,@sResSQL					VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_Usuarios_A_Recursos'
		,@FuncionDePagina VARCHAR(30) = 'Listado' +	COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			--, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
	
	IF @sResSQL = ''
		BEGIN
			SELECT U.id
				,U.Apellido + ', ' + U.Nombre AS NombreCompleto
				,U.UserName
				,U.Nombre
				,U.Apellido
				,U.Email
				,U.Activo
			FROM Usuarios U 
				INNER JOIN RelAsig_Usuarios_A_Recursos RAUR ON RAUR.RecursoId = @RecursoId AND RAUR.UsuarioId = U.id
			WHERE (U.Activo = 1)
			ORDER BY U.Apellido
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
-- SP-TABLA: usp_RelAsig_Usuarios_A_Recursos__Listado_by_@RecursoId /Listados Especiales/ - FIN
 
 
 
 

-- SP-TABLA: Soportes /Listados Especiales/ - INICIO
--IF (OBJECT_ID('usp_Soportes__ListadoDDLoCBXL_by_@PublicacionId') IS NOT NULL) DROP PROCEDURE usp_Soportes__ListadoDDLoCBXL_by_@PublicacionId
--GO
--CREATE PROCEDURE usp_Soportes__ListadoDDLoCBXL_by_@PublicacionId
--		@UsuarioQueEjecutaId		INT						
--		,@FechaDeEjecucion			DATETIME				
--		,@Token                     VARCHAR(40) 
-- 	,@Seccion					VARCHAR(30) 
--	,@CodigoDelContexto			VARCHAR(40)
		
--		,@CodigoDelContexto					VARCHAR(40) = '' -- Para poder operar "anónimamente".

--		,@id						INT = 0 -- Default, Si pasa un id, lo agregamos al SELECT.
	 
--		,@sResSQL					VARCHAR(1000)	OUTPUT	
--	AS 
--	BEGIN TRY
--		DECLARE @Tabla VARCHAR(80) = 'Soportes'
--			,@FuncionDePagina VARCHAR(30) = 'ListadoDDL'
--			,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
--			,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
			
--		EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
--				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
				--, @RegistroId = @id 
				--, @UsuarioId = @UsuarioId OUTPUT 
				--, @sResSQL = @sResSQL OUTPUT
--
--		IF @sResSQL = ''
--			BEGIN
--				DECLARE @ContextoId	INT
--				EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				
--				-- Listo todas los Soportes Cerrados, TODOS, Pero solo marco chk=1 los que son de esta publicación.
--				SELECT	SOP.id
--						--CASE WHEN SOP.PublicacionId IS NULL THEN 0
--						-- WHEN SOP.PublicacionId = @PublicacionId THEN 1
--						,CASE WHEN NOT SOP.PublicacionId IS NULL AND SOP.PublicacionId = @PublicacionId THEN 1
--								ELSE 0 END AS chk
--						,N'Nº ' + CAST(SOP.Numero AS VARCHAR(MAX)) 
--							+ N' - Pedido: ' + SOP.Texto + N'<br><br>'
--							+ N' - Respuesta: ' + SOP.Observaciones + N'<br><br>' AS Data
--						,SOP.Numero AS Orden
--				FROM Soportes SOP
--				WHERE 
--					(SOP.Cerrado = 1)
--					AND (SOP.ContextoId = @ContextoId)
--					AND
--					(
--						(SOP.PublicacionId IS NULL)
--						OR 
--						(SOP.PublicacionId = @PublicacionId)
--					)
--				ORDER BY chk DESC, SOP.FechaDeCierre
--			END	
--	END TRY
--	BEGIN CATCH
--		DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
--		EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
--				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
--				--, @RegistroId = @id 
-- 				, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
--	END CATCH
--GO



			   
--IF (OBJECT_ID('usp_Soportes__ListadoDDLoCBXL_ParaPublicaciones') IS NOT NULL) DROP PROCEDURE usp_Soportes__ListadoDDLoCBXL_ParaPublicaciones
--GO
--CREATE PROCEDURE usp_Soportes__ListadoDDLoCBXL_ParaPublicaciones
--		@UsuarioQueEjecutaId		INT						
--		,@FechaDeEjecucion			DATETIME				
--		,@Token                     VARCHAR(40) 
 --	,@Seccion					VARCHAR(30) 
	--,@CodigoDelContexto			VARCHAR(40)
		
--		,@CodigoDelContexto					VARCHAR(40) = '' -- Para poder operar "anónimamente".
		
--		,@sResSQL					VARCHAR(1000)	OUTPUT
--	AS
--	BEGIN TRY
--		DECLARE @Tabla VARCHAR(80) = 'Soportes'
--			,@FuncionDePagina VARCHAR(30) = 'ListadoDDL'
--			,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
--			,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
			
--		EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
				--, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
				----, @RegistroId = @id 
				----, @UsuarioId = @UsuarioId OUTPUT 
				--, @sResSQL = @sResSQL OUTPUT
--
--		IF @sResSQL = ''
--			BEGIN
--				DECLARE @ContextoId	INT
--				EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
								
--				SELECT	id
--					,N'Nº ' + CAST(SOP.Numero AS VARCHAR(MAX)) 
--						+ N' - Pedido: ' + SOP.Texto + N'<br><br>'
--						+ N' - Respuesta: ' + SOP.Observaciones + N'<br><br>' AS Data
--					,SOP.Numero AS Orden
--				FROM Soportes SOP
--				WHERE 
--					(SOP.Cerrado = 1)
--					AND (SOP.ContextoId = @ContextoId)
--					AND (SOP.PublicacionId IS NULL)
--				ORDER BY SOP.FechaDeCierre
--			END
--	END TRY
--	BEGIN CATCH
--		DECLARE @_NumeroDeError INT = ERROR_NUMBER(), @_LineaDeError INT = ERROR_LINE(), @_MensajeDeError VARCHAR(1000) = ERROR_MESSAGE()
--		EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto
--				, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
--				--, @RegistroId = @id 
-- 			, @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT
--	END CATCH
--GO
-- SP-TABLA: Soportes /Listados Especiales/ - FIN




-- SP-TABLA: TiposDeContactos /Listados Especiales/ - INICIO
IF (OBJECT_ID('usp_TiposDeContactos__ListadoDDLoCBXL_FiltrandoContexto') IS NOT NULL) DROP PROCEDURE usp_TiposDeContactos__ListadoDDLoCBXL_FiltrandoContexto
GO
CREATE PROCEDURE usp_TiposDeContactos__ListadoDDLoCBXL_FiltrandoContexto
	-- Filtra usando la Rel PARA MOSTRAR SOLO LOS DEL CONTEXTO
	 @UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
		
	,@id                                            INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro                                        VARCHAR(50) = ''
  
	,@sResSQL                                       VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'TiposDeContactos'
		,@FuncionDePagina VARCHAR(30) = 'ListadoDDL'
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
 
			SELECT TDC.id
					,TDC.Nombre
			FROM TiposDeContactos AS TDC
				INNER JOIN RelAsig_TiposDeContactos_A_Contextos ATCAC ON ATCAC.TipoDeContactoId = TDC.id
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con parámetros del modelo se agregan dentro del "OR" en una linea.
				(TDC.id = @id) -- Si pasó un registro particular, lo agregamos al Select (Por ejemplo en un registro que está está seleccionado en el DDL, pero que actualmente está "Anulado".
				OR 
				(	
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no dé error si no hay ninguna FK y además la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con parámetros del modelo se agregan a continuación:
					AND (ATCAC.ContextoId = @ContextoId) -- FILTRAMOS PARA MOSTRAR SOLO LOS DEL CONTEXTO.
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
-- SP-TABLA: TiposDeContactos /Listados Especiales/ - FIN


-- ---------------------------------
-- Script: DB_ParticularCore__C12b_Listados Especiales.sql - FIN
-- =====================================================
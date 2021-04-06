-- =====================================================
-- Descripci�n: Listados Particulares.sql
-- Script: DB_ParticularCore__C12b_Listados Particulares.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO

		-- Tablas Involucradas: - INICIO
			-- Archivos
			-- Contactos
			-- GruposDeContactos
			-- Importaciones
			-- Informes
			-- LogEnviosDeCorreos
			-- LogErrores
			-- Notas
			-- Notificaciones
			-- Publicaciones
			-- Recursos
			-- RelAsig_CuentasDeEnvios_A_Tablas
			-- RelAsig_RolesDeUsuarios_A_Paginas
			-- RelAsig_RolesDeUsuarios_A_Usuarios
			-- RelAsig_TiposDeContactos_A_Contextos
			-- RolesDeUsuarios
			-- Soportes
			-- Tablas
			-- Tareas
			-- Usuarios
		-- Tablas Involucradas: - FIN


-- SP-TABLA: Archivos /Listados Particulares/ - INICIO
IF (OBJECT_ID('usp_Archivos__Listado') IS NOT NULL) DROP PROCEDURE usp_Archivos__Listado
GO
CREATE PROCEDURE usp_Archivos__Listado
	@UsuarioQueEjecutaId		INT						
	,@FechaDeEjecucion			DATETIME				
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
	
	,@Tabla						VARCHAR(80)
	,@RegistroId				INT
	
	,@sResSQL					VARCHAR(1000)			OUTPUT
AS
BEGIN TRY
	DECLARE --@Tabla VARCHAR(80) = 'Archivos'
		@FuncionDePagina VARCHAR(30) = 'Listado' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
	
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			--, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
	
	IF @sResSQL = ''
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
					,@UbicacionDeIconos + '/' + ICO.Imagen AS srcIcono -- Source completo del �cono.
					,EXTDA.ProgramaAsociado
					,EXTDA.Nombre AS Extension
			FROM Archivos A
				INNER JOIN ExtensionesDeArchivos EXTDA ON EXTDA.id = A.ExtensionDeArchivoId
				INNER JOIN Iconos ICO ON ICO.id = EXTDA.IconoId
			WHERE A.TablaId = @TablaId AND A.RegistroId = @RegistroId AND A.ContextoId = @ContextoId
			ORDER BY A.Orden
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
-- SP-TABLA: Archivos /Listados Particulares/ - FIN

 
 
 
-- SP-TABLA: Contactos /Listados Particulares/ - INICIO
IF (OBJECT_ID('usp_Contactos__Listado') IS NOT NULL) DROP PROCEDURE usp_Contactos__Listado
GO
CREATE PROCEDURE usp_Contactos__Listado
	 @UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
		
	,@OrdenarPor                                    VARCHAR(50) = ''
	,@Sentido                                       BIT = 0
	,@Filtro                                        VARCHAR(50) = ''
 
	,@GrupoDeContactoId	                            INT = '-1' -- FiltroDDL (de rel)	
	,@TipoDeContactoId	                            INT = '-1' -- FiltroDDL (de rel)
	
	,@RegistrosPorPagina                            INT = '-1'
	,@NumeroDePagina                                INT = '1'
	,@TotalDeRegistros                              INT		OUTPUT
 
	,@sResSQL                                       VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Contactos'
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
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT CTOS.id
					--,CTOS.ContextoId
					,CTOS.EsUnaOrganizacion
					,CTOS.NombreCompleto
					,CTOS.Alias
					,CTOS.Organizacion
					--,CTOS.RelacionConElContacto
					,CTOS.Email
					--,CTOS.Email2
					,CTOS.Telefono
					--,CTOS.Telefono2
					--,CTOS.Direccion
					--,CTOS.Url
					--,CTOS.Observaciones
					--,CTOS.Activo
					--,CAST(CX.Nombre AS VARCHAR(MAX)) AS Contexto
					-- IdsString:
					,COALESCE(STUFF((SELECT ', ' + GDC.Nombre
						FROM RelAsig_Contactos_A_GruposDeContactos AS RACAGDC
							INNER JOIN GruposDeContactos GDC ON GDC.id = RACAGDC.GrupoDeContactoId
						WHERE (RACAGDC.ContactoId = CTOS.id)
						FOR XML PATH('')),1,1,''), '') AS GruposDeContacto -- Va sin la "s" x q si no, se pisa con el campo del DDL en .Net
					,COALESCE(STUFF((SELECT ', ' + TDC.Nombre
						FROM RelAsig_Contactos_A_TiposDeContactos AS RACATDC
							INNER JOIN TiposDeContactos TDC ON TDC.id = RACATDC.TipoDeContactoId
						WHERE (RACATDC.ContactoId = CTOS.id)
						FOR XML PATH('')),1,1,''), '') AS TiposDeContacto -- Va sin la "s" x q si no, se pisa con el campo del DDL en .Net
					--,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
					,ROW_NUMBER() OVER
					(
						-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
						ORDER BY
							CASE WHEN @OrdenarPor = '' THEN CTOS.NombreCompleto END 
							--CASE WHEN @OrdenarPor = 'id' AND @Sentido = '0' THEN CTOS.id END
							--,CASE WHEN @OrdenarPor = 'id' AND @Sentido = '1' THEN CTOS.id END DESC
							,CASE WHEN @OrdenarPor = 'EsUnaOrganizacion' AND @Sentido = '0' THEN CTOS.EsUnaOrganizacion END
							,CASE WHEN @OrdenarPor = 'EsUnaOrganizacion' AND @Sentido = '1' THEN CTOS.EsUnaOrganizacion END DESC
							,CASE WHEN @OrdenarPor = 'NombreCompleto' AND @Sentido = '0' THEN CTOS.NombreCompleto END
							,CASE WHEN @OrdenarPor = 'NombreCompleto' AND @Sentido = '1' THEN CTOS.NombreCompleto END DESC
							,CASE WHEN @OrdenarPor = 'Alias' AND @Sentido = '0' THEN CTOS.Alias END
							,CASE WHEN @OrdenarPor = 'Alias' AND @Sentido = '1' THEN CTOS.Alias END DESC
							,CASE WHEN @OrdenarPor = 'Organizacion' AND @Sentido = '0' THEN CTOS.Organizacion END
							,CASE WHEN @OrdenarPor = 'Organizacion' AND @Sentido = '1' THEN CTOS.Organizacion END DESC
							--,CASE WHEN @OrdenarPor = 'RelacionConElContacto' AND @Sentido = '0' THEN CTOS.RelacionConElContacto END
							--,CASE WHEN @OrdenarPor = 'RelacionConElContacto' AND @Sentido = '1' THEN CTOS.RelacionConElContacto END DESC
							,CASE WHEN @OrdenarPor = 'Email' AND @Sentido = '0' THEN CTOS.Email END
							,CASE WHEN @OrdenarPor = 'Email' AND @Sentido = '1' THEN CTOS.Email END DESC
							--,CASE WHEN @OrdenarPor = 'Email2' AND @Sentido = '0' THEN CTOS.Email2 END
							--,CASE WHEN @OrdenarPor = 'Email2' AND @Sentido = '1' THEN CTOS.Email2 END DESC
							,CASE WHEN @OrdenarPor = 'Telefono' AND @Sentido = '0' THEN CTOS.Telefono END
							,CASE WHEN @OrdenarPor = 'Telefono' AND @Sentido = '1' THEN CTOS.Telefono END DESC
							--,CASE WHEN @OrdenarPor = 'Telefono2' AND @Sentido = '0' THEN CTOS.Telefono2 END
							--,CASE WHEN @OrdenarPor = 'Telefono2' AND @Sentido = '1' THEN CTOS.Telefono2 END DESC
							--,CASE WHEN @OrdenarPor = 'Direccion' AND @Sentido = '0' THEN CTOS.Direccion END
							--,CASE WHEN @OrdenarPor = 'Direccion' AND @Sentido = '1' THEN CTOS.Direccion END DESC
							--,CASE WHEN @OrdenarPor = 'Url' AND @Sentido = '0' THEN CTOS.Url END
							--,CASE WHEN @OrdenarPor = 'Url' AND @Sentido = '1' THEN CTOS.Url END DESC
							--,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '0' THEN CTOS.Observaciones END
							--,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '1' THEN CTOS.Observaciones END DESC
							--,CASE WHEN @OrdenarPor = 'Contexto' AND @Sentido = '0' THEN CX.Nombre END
							--,CASE WHEN @OrdenarPor = 'Contexto' AND @Sentido = '1' THEN CX.Nombre END DESC
					) AS NumeroDeRegistro
			FROM Contactos AS CTOS
				INNER JOIN Contextos CX ON CX.id = CTOS.ContextoId
				--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = CTOS.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
			WHERE
				(CTOS.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
				--AND (CTOS.Activo = @Activo OR @Activo IS NULL)
				AND (CTOS.ContextoId = @ContextoId OR @ContextoId = '-1')
				AND (@GrupoDeContactoId IN (SELECT GrupoDeContactoId FROM RelAsig_Contactos_A_GruposDeContactos RACAG WHERE RACAG.ContactoId = CTOS.id) OR @GrupoDeContactoId = '-1') -- FiltroDDL (FK)
				AND (@TipoDeContactoId IN (SELECT TipoDeContactoId FROM RelAsig_Contactos_A_TiposDeContactos RACATC WHERE RACATC.ContactoId = CTOS.id) OR @TipoDeContactoId = '-1') -- FiltroDDL (FK)
				AND
				(
					(@Filtro = '')
					OR (CTOS.EsUnaOrganizacion LIKE '%' + @Filtro + '%')
					OR (CTOS.NombreCompleto LIKE '%' + @Filtro + '%')
					OR (CTOS.Alias LIKE '%' + @Filtro + '%')
					OR (CTOS.Organizacion LIKE '%' + @Filtro + '%')
					--OR (CTOS.RelacionConElContacto LIKE '%' + @Filtro + '%')
					OR (CTOS.Email LIKE '%' + @Filtro + '%')
					--OR (CTOS.Email2 LIKE '%' + @Filtro + '%')
					OR (CTOS.Telefono LIKE '%' + @Filtro + '%')
					--OR (CTOS.Telefono2 LIKE '%' + @Filtro + '%')
					--OR (CTOS.Direccion LIKE '%' + @Filtro + '%')
					--OR (CTOS.Url LIKE '%' + @Filtro + '%')
					--OR (CTOS.Observaciones LIKE '%' + @Filtro + '%')
					--OR (CX.Nombre LIKE '%' + @Filtro + '%')
				)
		) Query
 
		SELECT *
		FROM  #TempTable
		WHERE (@RegistrosPorPagina = '-1') -- Sin Paginaci�n
			OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina))-- Con Paginaci�n:

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
 
 
 
 
IF (OBJECT_ID('usp_Contactos__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_Contactos__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_Contactos__ListadoDDLoCBXL
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
	DECLARE @Tabla VARCHAR(80) = 'Contactos'
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
 
			SELECT CTOS.id
					,CTOS.NombreCompleto
			FROM Contactos AS CTOS
			WHERE -- Respetar el formato del WHERE. Los "filtros" que se pasan con par�metros del modelo se agregan dentro del "OR" en una linea.
				(CTOS.id = @id) -- Si pas� un registro particular, lo agregamos al Select (Por ejemplo en un registro que est� est� seleccionado en el DDL, pero que actualmente est� "Anulado".
				OR (	(1 = 1) -- Es un truco para mantener el formato del WHERE y que no d� error si no hay ninguna FK y adem�s la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con par�metros del modelo se agregan a continuaci�n:
					 --AND (CTOS.Activo = @Activo OR @Activo IS NULL)
					 AND (CTOS.ContextoId = @ContextoId OR @ContextoId = '-1')
				)
				-- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que tambi�n afecta al registro @id:
				AND (
					(@Filtro = '')
					OR (CTOS.NombreCompleto LIKE '%' + @Filtro + '%')
				)
			ORDER BY CTOS.NombreCompleto
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
-- SP-TABLA: Contactos /Listados Particulares/ - FIN
 
 
 
 
-- SP-TABLA: GruposDeContactos /Listados Particulares/ - INICIO
IF (OBJECT_ID('usp_GruposDeContactos__Listado') IS NOT NULL) DROP PROCEDURE usp_GruposDeContactos__Listado
GO
CREATE PROCEDURE usp_GruposDeContactos__Listado
	 @UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
		
	,@OrdenarPor                                    VARCHAR(50) = ''
	,@Sentido                                       BIT = '0'
	,@Filtro                                        VARCHAR(50) = ''
 
	,@ContactoId									INT = '-1' -- FiltroDDL (FK)
	
	,@RegistrosPorPagina                            INT = '-1'
	,@NumeroDePagina                                INT = '1'
	,@TotalDeRegistros                              INT		OUTPUT
 
	,@sResSQL                                       VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'GruposDeContactos'
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
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT GDCTOS.id
						,GDCTOS.Nombre
						,GDCTOS.Observaciones
						,COALESCE(STUFF((SELECT ', ' + CON.NombreCompleto
							FROM RelAsig_Contactos_A_GruposDeContactos AS RACAGDC
								INNER JOIN Contactos CON ON CON.id = RACAGDC.ContactoId
							WHERE (RACAGDC.GrupoDeContactoId = GDCTOS.id)
							FOR XML PATH('')),1,1,''), '') AS ContactosDelGrupo
						--,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN GDCTOS.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN GDCTOS.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN GDCTOS.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '0' THEN GDCTOS.Observaciones END
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '1' THEN GDCTOS.Observaciones END DESC
						) AS NumeroDeRegistro
					FROM GruposDeContactos AS GDCTOS
						INNER JOIN Contextos CX ON CX.id = GDCTOS.ContextoId
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = GDCTOS.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(GDCTOS.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (GDCTOS.ContextoId = @ContextoId OR @ContextoId = '-1')
						--AND (RACAG.ContactoId = @ContactoId OR @ContactoId = '-1')
						AND (@ContactoId IN (SELECT ContactoId FROM RelAsig_Contactos_A_GruposDeContactos RACAG WHERE RACAG.GrupoDeContactoId = GDCTOS.id) OR @ContactoId = '-1') -- FiltroDDL (FK)
						AND
						(
							(@Filtro = '')
							OR (GDCTOS.Nombre LIKE '%' + @Filtro + '%')
							OR (GDCTOS.Observaciones LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
		WHERE (@RegistrosPorPagina = '-1') -- Sin Paginaci�n
			OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginaci�n

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
 
 
 
 
IF (OBJECT_ID('usp_GruposDeContactos__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_GruposDeContactos__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_GruposDeContactos__ListadoDDLoCBXL
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
	DECLARE @Tabla VARCHAR(80) = 'GruposDeContactos'
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
 
			SELECT GDCTOS.id
				,GDCTOS.Nombre
			FROM GruposDeContactos AS GDCTOS
			WHERE 
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con par�metros del modelo se agregan dentro del "OR" en una linea.
				(GDCTOS.id = @id) -- Si pas� un registro particular, lo agregamos al Select (Por ejemplo en un registro que est� est� seleccionado en el DDL, pero que actualmente est� "Anulado".
				OR 
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no d� error si no hay ninguna FK y adem�s la tabla no tiene ContextoId ni Activo.
					 -- Los "filtros" que se pasan con par�metros del modelo se agregan a continuaci�n:
					AND (GDCTOS.ContextoId = @ContextoId OR @ContextoId = '-1')
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que tambi�n afecta al registro @id:
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
-- SP-TABLA: GruposDeContactos /Listados Particulares/ - FIN




-- SP-TABLA: Importaciones /Listados Particulares/ - INICIO
IF (OBJECT_ID('usp_Importaciones__Listado') IS NOT NULL) DROP PROCEDURE usp_Importaciones__Listado
GO
CREATE PROCEDURE usp_Importaciones__Listado
	@UsuarioQueEjecutaId		INT						
	,@FechaDeEjecucion			DATETIME				
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
	
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = 0
	,@Filtro					VARCHAR(50) = ''
			
	,@TablaId					INT = '-1' -- FiltroDDL (FK)
	,@Activo					BIT = '1'
	,@FechaDesde				DATE = NULL
	,@FechaHasta				DATE = NULL
	
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = 1
	,@TotalDeRegistros			INT		OUTPUT
			
    ,@sResSQL					VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Importaciones'
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
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			
			DECLARE @UbicacionRelativaCompleta VARCHAR(100)
			EXEC @UbicacionRelativaCompleta = ufc_Ubicaciones__RelativaCompletaDeConenidosDeTabla  
													@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
													,@TablaId = @TablaId
													,@Seccion = @Seccion
													,@CodigoDelContexto	= @CodigoDelContexto
			
			SELECT * INTO #TempTable
			FROM
			(
			   SELECT IMP.id
					--,IMP.ContextoId
					,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS Usuario
					,T.Nombre AS Tabla
					,IMP.Numero
					,IMP.Fecha
					,dbo.ufc_Fechas__FormatoFechaComoTexto(IMP.Fecha) AS FechaFormateado
					,IMP.Observaciones
					,IMP.ObservacionesPosteriores
					--,IMP.Activo
					,N'images/cbx/img_' + CONVERT(VARCHAR(5),IMP.Activo) + N'.jpg' AS imgActivo
					,'/' + @UbicacionRelativaCompleta + '/' + REPLACE(IMG.Imagen, '.', '_th.') AS Imagen
					--,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
					,ROW_NUMBER() OVER 
						(
							ORDER BY 
							CASE WHEN @OrdenarPor = '' THEN IMP.Fecha END DESC --DEFAULT
							,CASE WHEN @OrdenarPor = 'NombreCompleto' AND @Sentido = '0' THEN U.Apellido END
								,CASE WHEN @OrdenarPor = 'NombreCompleto' AND @Sentido = '0' THEN U.Nombre END
							,CASE WHEN @OrdenarPor = 'NombreCompleto' AND @Sentido = '0' THEN U.Apellido END DESC
								,CASE WHEN @OrdenarPor = 'NombreCompleto' AND @Sentido = '0' THEN U.Nombre END DESC
							,CASE WHEN @OrdenarPor = 'Tabla' AND @Sentido = '0' THEN T.Nombre END
							,CASE WHEN @OrdenarPor = 'Tabla' AND @Sentido = '1' THEN T.Nombre END DESC
							,CASE WHEN @OrdenarPor = 'Numero' AND @Sentido = '0' THEN IMP.Numero END
							,CASE WHEN @OrdenarPor = 'Numero' AND @Sentido = '1' THEN IMP.Numero END DESC
							,CASE WHEN @OrdenarPor = 'Fecha' AND @Sentido = '0' THEN IMP.Fecha END
							,CASE WHEN @OrdenarPor = 'Fecha' AND @Sentido = '1' THEN IMP.Fecha END DESC
							,CASE WHEN @OrdenarPor = 'FechaFormateado' AND @Sentido = '0' THEN IMP.Fecha END
							,CASE WHEN @OrdenarPor = 'FechaFormateado' AND @Sentido = '1' THEN IMP.Fecha END DESC
						) 
					AS NumeroDeRegistro
				FROM Importaciones IMP
					INNER JOIN Usuarios U ON IMP.UsuarioQueImportaId = U.id
					INNER JOIN Tablas T ON IMP.TablaId = T.id
					INNER JOIN Contextos CON ON IMP.ContextoId = CON.Id
					--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = IMP.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					OUTER APPLY ( 
						SELECT TOP 1 ARCH.NombreFisicoCompleto AS Imagen
						FROM Archivos ARCH 
						WHERE ARCH.TablaId = @TablaId AND ARCH.RegistroId = IMP.Id AND ARCH.ExtensionDeArchivoId = 6
						ORDER BY ARCH.Orden) IMG
				WHERE 
					(IMP.ContextoId = @ContextoId)
					AND (IMP.Activo = @Activo OR @Activo IS NULL)
					AND (IMP.TablaId = @TablaId OR @TablaId = '-1') -- FiltroDDL (FK)
					--AND (Fecha BETWEEN @FechaDesde AND @FechaHasta) <-- No permite que una fecha de las dos sea NULL
					AND (IMP.Fecha >= @FechaDesde OR @FechaDesde IS NULL)
					AND (IMP.Fecha <= @FechaHasta OR @FechaHasta IS NULL)
					AND
					(
						(@Filtro = '')
						OR (U.Apellido + N', ' + U.Nombre LIKE '%' + @Filtro + '%')
						OR (T.Nombre LIKE '%' + @Filtro + '%')
						OR (IMP.Numero LIKE '%' + @Filtro + '%')
						OR (IMP.Observaciones LIKE '%' + @Filtro + '%')
						OR (IMP.ObservacionesPosteriores LIKE '%' + @Filtro + '%')
					)			
			) Query
	
			SELECT	*
			FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginaci�n
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginaci�n
			
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




IF (OBJECT_ID('usp_Importaciones__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_Importaciones__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_Importaciones__ListadoDDLoCBXL
	@UsuarioQueEjecutaId							INT						
	,@FechaDeEjecucion								DATETIME				
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
	
	,@id                                            INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro                                        VARCHAR(50) = ''
	,@Activo                                        BIT = '1'
	
    ,@sResSQL										VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Importaciones'
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
			
			SELECT	 IMP.id
					,CAST(IMP.Numero AS VARCHAR(MAX)) + ' - ' + SUBSTRING(IMP.Observaciones, 1, 10) + '...' AS Nombre
			FROM Importaciones IMP
			WHERE 
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con par�metros del modelo se agregan dentro del "OR" en una linea. 
				(IMP.id = @id) -- Si pas� un registro particular, lo agregamos al Select (Por ejemplo en un registro que est� est� seleccionado en el DDL, pero que actualmente est� "Anulado".
				OR 
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no d� error si no hay ninguna FK y adem�s la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con par�metros del modelo se agregan a continuaci�n:
	 				AND (IMP.ContextoId = @ContextoId)
					AND	(IMP.Activo = @Activo OR @Activo IS NULL)
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que tambi�n afecta al registro @id:
				(
					(@Filtro = '')
					OR (IMP.Numero LIKE '%' + @Filtro + '%')
					OR (IMP.Observaciones LIKE '%' + @Filtro + '%')
				)
			ORDER BY IMP.Numero
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
-- SP-TABLA: Importaciones /Listados Particulares/ - FIN




-- SP-TABLA: Informes /Listados Particulares/ - INICIO
IF (OBJECT_ID('usp_Informes__Listado') IS NOT NULL) DROP PROCEDURE usp_Informes__Listado
GO
CREATE PROCEDURE usp_Informes__Listado
	@UsuarioQueEjecutaId		INT						
	,@FechaDeEjecucion			DATETIME				
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
	
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = 0
	,@Filtro					VARCHAR(50) = ''
	
	,@UsuarioId					INT = '-1' -- FiltroDDL (FK)
	,@CategoriaDeInformeId		INT = '-1' -- FiltroDDL (FK)
	,@FechaDeInformeDesde		DATE = NULL
	,@FechaDeInformeHasta		DATE = NULL
	,@Activo					BIT = '1'
	
	,@RegistrosPorPagina		INT = -1
	,@NumeroDePagina			INT = 1
	,@TotalDeRegistros			INT		OUTPUT
			
    ,@sResSQL					VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Informes'
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
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			
			DECLARE @TablaId INT = (SELECT id FROM Tablas WHERE Nombre = @Tabla)
			
			SELECT * INTO #TempTable
			FROM
			(
			   SELECT INF.id 
						,dbo.ufc_Usuarios__NombreCompletoFormateado(INF.UsuarioId) AS Usuario
						,INF.FechaDeInforme 
						,dbo.ufc_Fechas__FormatoFechaComoTexto(INF.FechaDeInforme) AS FechaDeInformeFormateado 
						,INF.Titulo
						,CDINF.Nombre AS CategoriaDeInforme
						,INF.Texto
						,INF.Activo
						,(SELECT COUNT(id) FROM Archivos WHERE (TablaId = @TablaId AND RegistroId = INF.id)) AS CantidadDeAdjuntos
						--,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER 
							(
								ORDER BY 
								CASE WHEN @OrdenarPor = '' THEN INF.FechaDeInforme END DESC --DEFAULT
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '0' THEN U.Apellido END
									,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '0' THEN U.Nombre END
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '0' THEN U.Apellido END DESC
									,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '0' THEN U.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'FechaDeInforme' AND @Sentido = '0' THEN INF.FechaDeInforme END
								,CASE WHEN @OrdenarPor = 'FechaDeInforme' AND @Sentido = '1' THEN INF.FechaDeInforme END DESC
								,CASE WHEN @OrdenarPor = 'FechaDeInformeFormateado' AND @Sentido = '0' THEN INF.FechaDeInforme END
								,CASE WHEN @OrdenarPor = 'FechaDeInformeFormateado' AND @Sentido = '1' THEN INF.FechaDeInforme END DESC
								,CASE WHEN @OrdenarPor = 'Titulo' AND @Sentido = '0' THEN INF.Titulo END
								,CASE WHEN @OrdenarPor = 'Titulo' AND @Sentido = '1' THEN INF.Titulo END DESC
								,CASE WHEN @OrdenarPor = 'CategoriaDeInforme' AND @Sentido = '0' THEN CDINF.Nombre END
								,CASE WHEN @OrdenarPor = 'CategoriaDeInforme' AND @Sentido = '1' THEN CDINF.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Texto' AND @Sentido = '0' THEN INF.Texto END
								,CASE WHEN @OrdenarPor = 'Texto' AND @Sentido = '1' THEN INF.Texto END DESC
							) 
						AS NumeroDeRegistro			
				FROM Informes INF
					INNER JOIN Usuarios U ON INF.UsuarioId = U.id
					INNER JOIN CategoriasDeInformes CDINF ON INF.CategoriaDeInformeId = CDINF.id
					--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = INF.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
				WHERE 
					(INF.ContextoId = @ContextoId)
					AND (INF.Activo = @Activo OR @Activo IS NULL)
					AND (INF.UsuarioId = @UsuarioId OR @UsuarioId = '-1') -- FiltroDDL (FK)
					AND (INF.CategoriaDeInformeId = @CategoriaDeInformeId OR @CategoriaDeInformeId = '-1') -- FiltroDDL (FK)
					AND (INF.FechaDeInforme >= @FechaDeInformeDesde OR @FechaDeInformeDesde IS NULL)
					AND (INF.FechaDeInforme <= @FechaDeInformeHasta OR @FechaDeInformeHasta IS NULL)
					AND
					(
						(@Filtro = '')
						OR (U.Apellido + N', ' + U.Nombre LIKE '%' + @Filtro + '%')
						OR (INF.Titulo LIKE '%' + @Filtro + '%')
						OR (CDINF.Nombre LIKE '%' + @Filtro + '%')
						OR (INF.Texto LIKE '%' + @Filtro + '%')
					)
			) Query
	
			SELECT	*
			FROM  #TempTable
			WHERE (@RegistrosPorPagina = -1) -- Sin Paginaci�n
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginaci�n
			
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
-- SP-TABLA: Informes /Listados Particulares/ - FIN
 
 
 
 
-- SP-TABLA: LogEnviosDeCorreos /Listados Particulares/ - INICIO
IF (OBJECT_ID('usp_LogEnviosDeCorreos__Listado') IS NOT NULL) DROP PROCEDURE usp_LogEnviosDeCorreos__Listado
GO
CREATE PROCEDURE usp_LogEnviosDeCorreos__Listado
	 @UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40)
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
	
	,@OrdenarPor                                    VARCHAR(50) = ''
	,@Sentido                                       BIT = '0'
	,@Filtro                                        VARCHAR(50) = ''
 
	,@Satisfactorio                                 BIT = NULL
	,@FechaDesde                                    DATE = NULL
	,@FechaHasta                                    DATE = NULL
	,@EnvioDeCorreoId                               INT = '-1' -- FiltroDDL (FK)
 
	,@RegistrosPorPagina                            INT = '-1'
	,@NumeroDePagina                                INT = '1'
	,@TotalDeRegistros                              INT		OUTPUT
 
	,@sResSQL                                       VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogEnviosDeCorreos'
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
			SELECT * INTO #TempTable
			FROM
				(
					SELECT LEDC.id
						,LEDC.EnvioDeCorreoId
						,LEDC.Satisfactorio
						,LEDC.Fecha
						,dbo.ufc_Fechas__FormatoFechaComoTexto(LEDC.Fecha) AS FechaFormateado
						--,LEDC.ObservacionesDeRevision
						,CAST(EDC.Asunto AS VARCHAR(MAX)) AS Asunto
						--Otros:
						,dbo.ufc_Usuarios__NombreCompletoFormateado(UO.id) AS UsuarioOriginante
						,dbo.ufc_Usuarios__NombreCompletoFormateado(UD.id) AS UsuarioDestinatario
						,EDC.EmailDeDestino
						,T.Nombre AS Tabla
						--,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN LEDC.Fecha END DESC
								,CASE WHEN @OrdenarPor = 'Satisfactorio' AND @Sentido = '0' THEN LEDC.Satisfactorio END
								,CASE WHEN @OrdenarPor = 'Satisfactorio' AND @Sentido = '1' THEN LEDC.Satisfactorio END DESC
								,CASE WHEN @OrdenarPor = 'Fecha' AND @Sentido = '0' THEN LEDC.Fecha END
								,CASE WHEN @OrdenarPor = 'Fecha' AND @Sentido = '1' THEN LEDC.Fecha END DESC
								,CASE WHEN @OrdenarPor = 'FechaFormateado' AND @Sentido = '0' THEN LEDC.Fecha END
								,CASE WHEN @OrdenarPor = 'FechaFormateado' AND @Sentido = '1' THEN LEDC.Fecha END DESC
								--,CASE WHEN @OrdenarPor = 'ObservacionesDeRevision' AND @Sentido = '0' THEN LEDC.ObservacionesDeRevision END
								--,CASE WHEN @OrdenarPor = 'ObservacionesDeRevision' AND @Sentido = '1' THEN LEDC.ObservacionesDeRevision END DESC
								,CASE WHEN @OrdenarPor = 'Asunto' AND @Sentido = '0' THEN EDC.Asunto END
								,CASE WHEN @OrdenarPor = 'Asunto' AND @Sentido = '1' THEN EDC.Asunto END DESC
								,CASE WHEN @OrdenarPor = 'UsuarioOriginante' AND @Sentido = '0' THEN UO.Apellido END
								,CASE WHEN @OrdenarPor = 'UsuarioOriginante' AND @Sentido = '0' THEN UO.Nombre END
								,CASE WHEN @OrdenarPor = 'UsuarioOriginante' AND @Sentido = '1' THEN UO.Apellido END DESC
								,CASE WHEN @OrdenarPor = 'UsuarioOriginante' AND @Sentido = '1' THEN UO.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'UsuarioDestinatario' AND @Sentido = '0' THEN UD.Apellido END
								,CASE WHEN @OrdenarPor = 'UsuarioDestinatario' AND @Sentido = '0' THEN UD.Nombre END
								,CASE WHEN @OrdenarPor = 'UsuarioDestinatario' AND @Sentido = '1' THEN UD.Apellido END DESC
								,CASE WHEN @OrdenarPor = 'UsuarioDestinatario' AND @Sentido = '1' THEN UD.Nombre END DESC
								--,CASE WHEN @OrdenarPor = 'EmailDeDestino' AND @Sentido = '0' THEN EDC.EmailDeDestino END
								--,CASE WHEN @OrdenarPor = 'EmailDeDestino' AND @Sentido = '1' THEN EDC.EmailDeDestino END DESC
								--,CASE WHEN @OrdenarPor = 'Tabla' AND @Sentido = '0' THEN T.Nombre END
								--,CASE WHEN @OrdenarPor = 'Tabla' AND @Sentido = '0' THEN LEDC.Fecha END
								--,CASE WHEN @OrdenarPor = 'Tabla' AND @Sentido = '1' THEN T.Nombre END DESC
								--,CASE WHEN @OrdenarPor = 'Tabla' AND @Sentido = '1' THEN LEDC.Fecha END DESC
						) AS NumeroDeRegistro
					FROM LogEnviosDeCorreos AS LEDC
						INNER JOIN EnviosDeCorreos EDC ON EDC.id = LEDC.EnvioDeCorreoId
						INNER JOIN Tablas T ON EDC.TablaId = T.id
						INNER JOIN Usuarios UO ON EDC.UsuarioOriginanteId = UO.id
						INNER JOIN Usuarios UD ON EDC.UsuarioDestinatarioId = UD.id
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = LEDC.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(LEDC.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (LEDC.Satisfactorio = @Satisfactorio OR @Satisfactorio IS NULL)
						AND (LEDC.Fecha >= @FechaDesde OR @FechaDesde IS NULL)
						AND (LEDC.Fecha <= @FechaHasta OR @FechaHasta IS NULL)
						AND (LEDC.EnvioDeCorreoId = @EnvioDeCorreoId OR @EnvioDeCorreoId = '-1') -- FiltroDDL (FK)
						AND
						(
							(@Filtro = '')
							--OR (LEDC.Satisfactorio LIKE '%' + @Filtro + '%')
							OR (LEDC.Fecha LIKE '%' + @Filtro + '%')
							--OR (LEDC.ObservacionesDeRevision LIKE '%' + @Filtro + '%')
							OR (EDC.Asunto LIKE '%' + @Filtro + '%')
							OR (UO.Apellido LIKE '%' + @Filtro + '%')
							OR (UO.Nombre LIKE '%' + @Filtro + '%')
							OR (UD.Apellido LIKE '%' + @Filtro + '%')
							OR (UD.Nombre LIKE '%' + @Filtro + '%')
							--OR (EDC.EmailDeDestino LIKE '%' + @Filtro + '%')
							--OR (T.Nombre LIKE '%' + @Filtro + '%')
						)
			) Query
 
			SELECT	*
			FROM  #TempTable
			WHERE (@RegistrosPorPagina = -1) -- Sin Paginaci�n
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginaci�n
			
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
 
 
 
 
IF (OBJECT_ID('usp_LogEnviosDeCorreos__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_LogEnviosDeCorreos__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_LogEnviosDeCorreos__ListadoDDLoCBXL
	 @UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
	
	,@id                                            INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro                                        VARCHAR(50) = ''
 
	,@EnvioDeCorreoId                               INT = '-1' -- FiltroDDL (FK)
 
	,@sResSQL                                       VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogEnviosDeCorreos'
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
			SELECT LEDC.id
				,dbo.ufc_Fechas__FormatoFechaComoTexto(LEDC.Fecha) AS Fecha
			FROM LogEnviosDeCorreos AS LEDC
			WHERE 
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con par�metros del modelo se agregan dentro del "OR" en una linea.
				(LEDC.id = @id) -- Si pas� un registro particular, lo agregamos al Select (Por ejemplo en un registro que est� est� seleccionado en el DDL, pero que actualmente est� "Anulado".
				OR 
				(	
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no d� error si no hay ninguna FK y adem�s la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con par�metros del modelo se agregan a continuaci�n:
					AND (LEDC.EnvioDeCorreoId = @EnvioDeCorreoId OR @EnvioDeCorreoId = '-1') -- FiltroDDL (FK)
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que tambi�n afecta al registro @id:
				(
					(@Filtro = '')
					OR (LEDC.Fecha LIKE '%' + @Filtro + '%')
				)
			ORDER BY LEDC.Fecha
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
-- SP-TABLA: LogEnviosDeCorreos /Listados Particulares/ - FIN
 
 
 
 
-- SP-TABLA: LogErrores /Listados Particulares/ - INICIO
IF (OBJECT_ID('usp_LogErrores__Listado') IS NOT NULL) DROP PROCEDURE usp_LogErrores__Listado
GO
CREATE PROCEDURE usp_LogErrores__Listado
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
 
	,@ContextoId											   INT = '-1'
	
	,@UsuarioDeEjecucionEnElErrorId                            INT = '-1' -- FiltroDDL (FK) // En la Tabla es @UsuarioQueEjecutaId pero obviamente no podemos usarlo con ese nombre para el filtro.
	
	,@FechaDeEjecucionDesde                                    DATETIME = NULL
	,@FechaDeEjecucionHasta                                    DATETIME = NULL
	,@ErrorEnAmbienteSQL                                       BIT = NULL
	,@EstadoDeLogErrorId                                       INT = '-1' -- FiltroDDL (FK)
	,@PaginaId                                                 INT = '-1' -- FiltroDDL (FK)
	,@TablaId                                                  INT = '-1' -- FiltroDDL (FK)
	,@TipoDeOperacionId                                        INT = '-1' -- FiltroDDL (FK)
 
	,@RegistrosPorPagina                                       INT = '-1'
	,@NumeroDePagina                                           INT = '1'
	,@TotalDeRegistros                                         INT		OUTPUT
 
	,@sResSQL                                                  VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogErrores'
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
			SELECT * INTO #TempTable
			FROM
				(
					SELECT LE.id
						,LE.UsuarioQueEjecutaId
						,dbo.ufc_Usuarios__NombreCompletoFormateado(LE.UsuarioQueEjecutaId) AS UsuarioQueEjecuta
						,LE.FechaDeEjecucion
						,dbo.ufc_Fechas__FormatoFechaComoTexto(LE.FechaDeEjecucion) AS FechaDeEjecucionFormateado
						,LE.Token
						,LE.Seccion
						,LE.CodigoDelContexto
						,LE.TablaId
						,LE.TipoDeOperacionId
						,LE.SP
						,LE.NumeroDeError
						,LE.LineaDeError
						,LE.ErrorEnAmbienteSQL
						,LE.Mensaje
						,LE.PaginaId
						,LE.Accion
						,LE.Capa
						,LE.Metodo
						,LE.MachineName
						,LE.EstadoDeLogErrorId
						,EDLE.Nombre AS EstadoDeLogError
						,P.Nombre AS Pagina
						,T.Nombre AS Tabla
						,TDO.Nombre AS TipoDeOperacion
						,CX.Nombre AS Contexto
						--,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN LE.FechaDeEjecucion END DESC
								,CASE WHEN @OrdenarPor = 'UsuarioQueEjecuta' AND @Sentido = '0' THEN U.Apellido END
								,CASE WHEN @OrdenarPor = 'UsuarioQueEjecuta' AND @Sentido = '0' THEN U.Nombre END
								,CASE WHEN @OrdenarPor = 'UsuarioQueEjecuta' AND @Sentido = '1' THEN U.Apellido END DESC
								,CASE WHEN @OrdenarPor = 'UsuarioQueEjecuta' AND @Sentido = '1' THEN U.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucion' AND @Sentido = '0' THEN LE.FechaDeEjecucion END
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucion' AND @Sentido = '1' THEN LE.FechaDeEjecucion END DESC
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucionFormateado' AND @Sentido = '0' THEN LE.FechaDeEjecucion END
								,CASE WHEN @OrdenarPor = 'FechaDeEjecucionFormateado' AND @Sentido = '1' THEN LE.FechaDeEjecucion END DESC
								,CASE WHEN @OrdenarPor = 'Token' AND @Sentido = '0' THEN LE.Token END
								,CASE WHEN @OrdenarPor = 'Token' AND @Sentido = '1' THEN LE.Token END DESC
								,CASE WHEN @OrdenarPor = 'Seccion' AND @Sentido = '0' THEN LE.Seccion END
								,CASE WHEN @OrdenarPor = 'Seccion' AND @Sentido = '1' THEN LE.Seccion END DESC
								,CASE WHEN @OrdenarPor = 'CodigoDelContexto' AND @Sentido = '0' THEN LE.CodigoDelContexto END
								,CASE WHEN @OrdenarPor = 'CodigoDelContexto' AND @Sentido = '1' THEN LE.CodigoDelContexto END DESC
								,CASE WHEN @OrdenarPor = 'SP' AND @Sentido = '0' THEN LE.SP END
								,CASE WHEN @OrdenarPor = 'SP' AND @Sentido = '1' THEN LE.SP END DESC
								,CASE WHEN @OrdenarPor = 'NumeroDeError' AND @Sentido = '0' THEN LE.NumeroDeError END
								,CASE WHEN @OrdenarPor = 'NumeroDeError' AND @Sentido = '1' THEN LE.NumeroDeError END DESC
								,CASE WHEN @OrdenarPor = 'LineaDeError' AND @Sentido = '0' THEN LE.LineaDeError END
								,CASE WHEN @OrdenarPor = 'LineaDeError' AND @Sentido = '1' THEN LE.LineaDeError END DESC
								,CASE WHEN @OrdenarPor = 'Mensaje' AND @Sentido = '0' THEN LE.Mensaje END
								,CASE WHEN @OrdenarPor = 'Mensaje' AND @Sentido = '1' THEN LE.Mensaje END DESC
								,CASE WHEN @OrdenarPor = 'Accion' AND @Sentido = '0' THEN LE.Accion END
								,CASE WHEN @OrdenarPor = 'Accion' AND @Sentido = '1' THEN LE.Accion END DESC
								,CASE WHEN @OrdenarPor = 'Capa' AND @Sentido = '0' THEN LE.Capa END
								,CASE WHEN @OrdenarPor = 'Capa' AND @Sentido = '1' THEN LE.Capa END DESC
								,CASE WHEN @OrdenarPor = 'Metodo' AND @Sentido = '0' THEN LE.Metodo END
								,CASE WHEN @OrdenarPor = 'Metodo' AND @Sentido = '1' THEN LE.Metodo END DESC
								,CASE WHEN @OrdenarPor = 'MachineName' AND @Sentido = '0' THEN LE.MachineName END
								,CASE WHEN @OrdenarPor = 'MachineName' AND @Sentido = '1' THEN LE.MachineName END DESC
								,CASE WHEN @OrdenarPor = 'EstadoDeLogError' AND @Sentido = '0' THEN EDLE.Nombre END
								,CASE WHEN @OrdenarPor = 'EstadoDeLogError' AND @Sentido = '1' THEN EDLE.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Pagina' AND @Sentido = '0' THEN P.Nombre END
								,CASE WHEN @OrdenarPor = 'Pagina' AND @Sentido = '1' THEN P.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Tabla' AND @Sentido = '0' THEN T.Nombre END
								,CASE WHEN @OrdenarPor = 'Tabla' AND @Sentido = '1' THEN T.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'TipoDeOperacion' AND @Sentido = '0' THEN TDO.Nombre END
								,CASE WHEN @OrdenarPor = 'TipoDeOperacion' AND @Sentido = '1' THEN TDO.Nombre END DESC
						) AS NumeroDeRegistro
					FROM LogErrores AS LE
						INNER JOIN EstadosDeLogErrores EDLE ON EDLE.id = LE.EstadoDeLogErrorId
						INNER JOIN Paginas P ON P.id = LE.PaginaId
						INNER JOIN Tablas T ON T.id = LE.TablaId
						INNER JOIN TiposDeOperaciones TDO ON TDO.id = LE.TipoDeOperacionId
						INNER JOIN Usuarios U ON U.id = LE.UsuarioQueEjecutaId
						INNER JOIN Contextos CX ON CX.id = U.ContextoId
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = LE.id AND LR.TipoDeOperacionId = '2'
					WHERE
						(LE.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (LE.FechaDeEjecucion >= @FechaDeEjecucionDesde OR @FechaDeEjecucionDesde IS NULL)
						AND (LE.FechaDeEjecucion <= @FechaDeEjecucionHasta OR @FechaDeEjecucionHasta IS NULL)
						AND (LE.ErrorEnAmbienteSQL = @ErrorEnAmbienteSQL OR @ErrorEnAmbienteSQL IS NULL)
						AND (LE.EstadoDeLogErrorId = @EstadoDeLogErrorId OR @EstadoDeLogErrorId = '-1') -- FiltroDDL (FK)
						AND (LE.PaginaId = @PaginaId OR @PaginaId = '-1') -- FiltroDDL (FK)
						AND (LE.TablaId = @TablaId OR @TablaId = '-1') -- FiltroDDL (FK)
						AND (LE.TipoDeOperacionId = @TipoDeOperacionId OR @TipoDeOperacionId = '-1') -- FiltroDDL (FK)
						AND (LE.UsuarioQueEjecutaId = @UsuarioDeEjecucionEnElErrorId OR @UsuarioDeEjecucionEnElErrorId = '-1') -- FiltroDDL (FK) // Ojo ac� va @UsuarioDeEjecucionEnElErrorId en lugar de @UsuarioQueEjecutaId
						AND (CX.id = @ContextoId OR @ContextoId = '-1')
						AND
						(
							(@Filtro = '')
							OR (LE.FechaDeEjecucion LIKE '%' + @Filtro + '%')
							OR (LE.Token LIKE '%' + @Filtro + '%')
							OR (LE.Seccion LIKE '%' + @Filtro + '%')
							OR (LE.CodigoDelContexto LIKE '%' + @Filtro + '%')
							OR (LE.SP LIKE '%' + @Filtro + '%')
							OR (LE.NumeroDeError LIKE '%' + @Filtro + '%')
							OR (LE.LineaDeError LIKE '%' + @Filtro + '%')
							OR (LE.Mensaje LIKE '%' + @Filtro + '%')
							OR (LE.Accion LIKE '%' + @Filtro + '%')
							OR (LE.Capa LIKE '%' + @Filtro + '%')
							OR (LE.Metodo LIKE '%' + @Filtro + '%')
							OR (LE.MachineName LIKE '%' + @Filtro + '%')
							OR (EDLE.Nombre LIKE '%' + @Filtro + '%')
							OR (P.Nombre LIKE '%' + @Filtro + '%')
							OR (T.Nombre LIKE '%' + @Filtro + '%')
							OR (TDO.Nombre LIKE '%' + @Filtro + '%')
							OR (U.Apellido LIKE '%' + @Filtro + '%')
							OR (U.Nombre LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginaci�n
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginaci�n
 
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
 
 
 
 
IF (OBJECT_ID('usp_LogErrores__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_LogErrores__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_LogErrores__ListadoDDLoCBXL
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
	
	,@EstadoDeLogErrorId                                       INT = '-1' -- FiltroDDL (FK)
	,@PaginaId                                                 INT = '-1' -- FiltroDDL (FK)
	,@TablaId                                                  INT = '-1' -- FiltroDDL (FK)
	,@TipoDeOperacionId                                        INT = '-1' -- FiltroDDL (FK)
 
	,@sResSQL                                                  VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogErrores'
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
			SELECT LE.id
				,dbo.ufc_Fechas__FormatoFechaComoTexto(LE.FechaDeEjecucion) + LE.Mensaje AS LogError
			FROM LogErrores AS LE
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con par�metros del modelo se agregan dentro del "OR" en una linea.
				(LE.id = @id) -- Si pas� un registro particular, lo agregamos al Select (Por ejemplo en un registro que est� est� seleccionado en el DDL, pero que actualmente est� "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no d� error si no hay ninguna FK y adem�s la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con par�metros del modelo se agregan a continuaci�n:
					 AND (LE.EstadoDeLogErrorId = @EstadoDeLogErrorId OR @EstadoDeLogErrorId = '-1') -- FiltroDDL (FK)
					 AND (LE.PaginaId = @PaginaId OR @PaginaId = '-1') -- FiltroDDL (FK)
					 AND (LE.TablaId = @TablaId OR @TablaId = '-1') -- FiltroDDL (FK)
					 AND (LE.TipoDeOperacionId = @TipoDeOperacionId OR @TipoDeOperacionId = '-1') -- FiltroDDL (FK)
					 --AND (LE.UsuarioQueEjecutaId = @UsuarioQueEjecutaId OR @UsuarioQueEjecutaId = '-1') -- FiltroDDL (FK) // no va el usuario que ejecuta, si no, muestra solo sus propios errores.
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que tambi�n afecta al registro @id:
				(
					(@Filtro = '')
					OR (LE.FechaDeEjecucion LIKE '%' + @Filtro + '%')
					OR (LE.Mensaje LIKE '%' + @Filtro + '%')
				)
			ORDER BY LE.FechaDeEjecucion
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
-- SP-TABLA: LogErrores /Listados Particulares/ - FIN
 
 
 
 
-- SP-TABLA: Notas /Listados Particulares/ - INICIO
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
 
	,@RegistrosPorPagina                                       INT = '-1'
	,@NumeroDePagina                                           INT = '1'
	,@TotalDeRegistros                                         INT		OUTPUT
 
	,@sResSQL                                                  VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Notas'
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
						,CAST(ICSS.CSS AS VARCHAR(MAX)) AS IconoCSS
						--,'<i class="' + ICSS.CSS + '"></i>' AS Icono
						,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS Usuario
						--,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
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
								--,CASE WHEN @OrdenarPor = 'IconoCSS' AND @Sentido = '0' THEN ICSS.CSS END
								--,CASE WHEN @OrdenarPor = 'IconoCSS' AND @Sentido = '1' THEN ICSS.CSS END DESC
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
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginaci�n
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginaci�n
 
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
 
	,@sResSQL                                                  VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Notas'
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
 
			SELECT NOTAS.id
				,NOTAS.Fecha
			FROM Notas AS NOTAS
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con par�metros del modelo se agregan dentro del "OR" en una linea.
				(NOTAS.id = @id) -- Si pas� un registro particular, lo agregamos al Select (Por ejemplo en un registro que est� est� seleccionado en el DDL, pero que actualmente est� "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no d� error si no hay ninguna FK y adem�s la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con par�metros del modelo se agregan a continuaci�n:
					 AND (NOTAS.IconoCSSId = @IconoCSSId OR @IconoCSSId = '-1') -- FiltroDDL (FK)
					 AND (NOTAS.UsuarioId = @UsuarioId OR @UsuarioId = '-1') -- FiltroDDL (FK)
					 AND (NOTAS.ContextoId = @ContextoId OR @ContextoId = '-1')
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que tambi�n afecta al registro @id:
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
-- SP-TABLA: Notas /Listados Particulares/ - FIN




-- SP-TABLA: Notificaciones /Listados Particulares/ - INICIO
IF (OBJECT_ID('usp_Notificaciones__Listado') IS NOT NULL) DROP PROCEDURE usp_Notificaciones__Listado
GO
CREATE PROCEDURE usp_Notificaciones__Listado
	@UsuarioQueEjecutaId		INT						
	,@FechaDeEjecucion			DATETIME				
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
	
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = 0
	,@Filtro					VARCHAR(50) = ''		
	,@Activo					BIT = '1'
	
	,@Leida						BIT = NULL
	
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = 1
	,@TotalDeRegistros			INT		OUTPUT
	
	,@sResSQL					VARCHAR(1000)			OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Notificaciones'
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
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			
			SELECT * INTO #TempTable
			FROM 
			(
				SELECT 	N.Id
					,N.Fecha
					,dbo.ufc_Fechas__FormatoFechaComoTexto(N.Fecha) AS FechaFormateado 
					,N.Numero
					,N.UsuarioDestinatarioId
					,N.TablaId
					,N.RegistroId
					,Sec.Nombre AS Seccion
					,N.Cuerpo
					,ICSS.CSS AS IconoCSS
					--,'<i class="' + ICSS.CSS + '"></i>' AS Icono
					,CASE WHEN DATEDIFF(MINUTE, N.Fecha, @FechaDeEjecucion) < 60 THEN CAST(DATEDIFF(MINUTE, N.Fecha, @FechaDeEjecucion) AS VARCHAR(MAX)) + 'm' 
						  WHEN DATEDIFF(HOUR, N.Fecha, @FechaDeEjecucion) < 24 THEN CAST(DATEDIFF(HOUR, N.Fecha, @FechaDeEjecucion) AS VARCHAR(MAX)) + 'h' 
						  ELSE CAST(DATEDIFF(DAY, N.Fecha, @FechaDeEjecucion) AS VARCHAR(MAX)) + 'd' 
					END AS Antiguedad
					,N.Leida
					,TAB.Nombre AS Tabla
					,N.Activo
					--,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
					,ROW_NUMBER() OVER 
						(
							ORDER BY 
							CASE WHEN @OrdenarPor = '' THEN N.Leida END DESC --DEFAULT
							,CASE WHEN @OrdenarPor = '' THEN N.Numero END DESC --DEFAULT
							,CASE WHEN @OrdenarPor = 'Numero' AND @Sentido = '0' THEN N.Numero END
							,CASE WHEN @OrdenarPor = 'Numero' AND @Sentido = '1' THEN N.Numero END DESC
							,CASE WHEN @OrdenarPor = 'Fecha' AND @Sentido = '0' THEN N.Fecha END
							,CASE WHEN @OrdenarPor = 'Fecha' AND @Sentido = '1' THEN N.Fecha END DESC
							,CASE WHEN @OrdenarPor = 'FechaFormateado' AND @Sentido = '0' THEN N.Fecha END
							,CASE WHEN @OrdenarPor = 'FechaFormateado' AND @Sentido = '1' THEN N.Fecha END DESC
							,CASE WHEN @OrdenarPor = 'Cuerpo' AND @Sentido = '0' THEN N.Cuerpo END
							,CASE WHEN @OrdenarPor = 'Cuerpo' AND @Sentido = '1' THEN N.Cuerpo END DESC
							,CASE WHEN @OrdenarPor = 'Leida' AND @Sentido = '0' THEN N.Leida END
							,CASE WHEN @OrdenarPor = 'Leida' AND @Sentido = '1' THEN N.Leida END DESC
						) 
					AS NumeroDeRegistro
				FROM Notificaciones N
					INNER JOIN Tablas TAB ON N.TablaId = TAB.id
					INNER JOIN Secciones Sec ON Sec.id = N.SeccionId
					INNER JOIN IconosCSS ICSS ON N.IconoCSSId = ICSS.id
					--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = N.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
				WHERE 
					(N.UsuarioDestinatarioId = @UsuarioQueEjecutaId)
					AND (N.ContextoId = @ContextoId)
					AND (N.Leida = @Leida OR @Leida IS NULL)
					AND (N.Activo = @Activo OR @Activo IS NULL)
					AND
					(
						(@Filtro = '')
						OR (N.Numero LIKE '%' + @Filtro + '%')
						OR (N.Cuerpo LIKE '%' + @Filtro + '%')
					)
				) Query
	
			SELECT	*
			FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginaci�n
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginaci�n

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
-- SP-TABLA: Notificaciones /Listados Particulares/ - FIN




-- SP-TABLA: Publicaciones /Listados Particulares/ - INICIO
IF (OBJECT_ID('usp_Publicaciones__Listado') IS NOT NULL) DROP PROCEDURE usp_Publicaciones__Listado
GO
CREATE PROCEDURE usp_Publicaciones__Listado
	@UsuarioQueEjecutaId		INT						
	,@FechaDeEjecucion			DATETIME				
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
	
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = 0
	,@Filtro					VARCHAR(50) = ''
	,@Activo					BIT = '1'		
	,@Realizada					BIT = NULL
	
    ,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = 1
	,@TotalDeRegistros			INT		OUTPUT
			
    ,@sResSQL					VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Publicaciones'
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
			--DECLARE @ContextoId	INT
			--EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			
			SELECT * INTO #TempTable
			FROM 
			(	
				SELECT	PUB.id
					,PUB.Fecha
					,dbo.ufc_Fechas__FormatoFechaComoTexto(PUB.Fecha) AS FechaFormateado
					,CAST(PUB.Hora AS CHAR(5)) AS Hora
					,PUB.Titulo
					,PUB.NumeroDeVersion
					,COALESCE(STUFF((SELECT ', ' + 'N� ' + CAST(SOP.Numero AS VARCHAR(MAX))
						FROM Soportes SOP
						WHERE SOP.PublicacionId = PUB.id FOR XML PATH('')),1,1,''), '-') AS Soportes
					,COALESCE(STUFF((SELECT ', ' + SS.Nombre
						FROM RelAsig_Subsistemas_A_Publicaciones RASaP
							INNER JOIN SubSistemas SS ON RASaP.SubsistemaId = SS.id
						WHERE RASaP.PublicacionId = PUB.id FOR XML PATH('')),1,1,''), '-') AS SubSistemas
					,PUB.Realizada
					--,N'images/cbx/img_' + CONVERT(VARCHAR(5), PUB.Realizada) + N'.jpg' AS imgRealizada
					--,CAST(PUB.Observaciones AS VARCHAR(80)) + N' ...' AS Observaciones_Cortadas
					,PUB.Observaciones
					,PUB.Activo
					--,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
					,ROW_NUMBER() OVER 
						(
							ORDER BY 
							CASE WHEN @OrdenarPor = '' THEN PUB.Fecha END DESC -- DEFAULT
							,CASE WHEN @OrdenarPor = 'Fecha' AND @Sentido = '0' THEN PUB.Fecha END
							,CASE WHEN @OrdenarPor = 'Fecha' AND @Sentido = '1' THEN PUB.Fecha END DESC
							,CASE WHEN @OrdenarPor = 'FechaFormateado' AND @Sentido = '0' THEN PUB.Fecha END
							,CASE WHEN @OrdenarPor = 'FechaFormateado' AND @Sentido = '1' THEN PUB.Fecha END DESC
							,CASE WHEN @OrdenarPor = 'T�tulo' AND @Sentido = '0' THEN PUB.Titulo END
							,CASE WHEN @OrdenarPor = 'T�tulo' AND @Sentido = '1' THEN PUB.Titulo END DESC
							,CASE WHEN @OrdenarPor = 'NumeroDeVersion' AND @Sentido = '0' THEN PUB.NumeroDeVersion END
							,CASE WHEN @OrdenarPor = 'NumeroDeVersion' AND @Sentido = '1' THEN PUB.NumeroDeVersion END DESC
							--,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '0' THEN PUB.Observaciones END
							--,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '1' THEN PUB.Observaciones END DESC
						) 
					AS NumeroDeRegistro
			FROM Publicaciones PUB
				INNER JOIN RelAsig_Subsistemas_A_Publicaciones RASaP ON RASaP.PublicacionId = PUB.id
				--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = PUB.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
			WHERE 
				(PUB.Realizada = @Realizada OR @Realizada IS NULL)
				AND(PUB.Activo = @Activo OR @Activo IS NULL)
				AND
				(
					(@Filtro = '')
					OR (PUB.Titulo LIKE '%' + @Filtro + '%')
					OR (PUB.NumeroDeVersion LIKE '%' + @Filtro + '%')
					--OR (PUB.Observaciones LIKE '%' + @Filtro + '%')
				)
			) Query
	
			SELECT	*
			FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginaci�n
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginaci�n

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
-- SP-TABLA: Publicaciones /Listados Particulares/ - FIN
 
 
 
 
-- SP-TABLA: Recursos /Listados Particulares/ - INICIO
IF (OBJECT_ID('usp_Recursos__Listado') IS NOT NULL) DROP PROCEDURE usp_Recursos__Listado
GO
CREATE PROCEDURE usp_Recursos__Listado
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
 
	,@UsuarioResponsableId								INT = '-1' -- FiltroDDL (de rel)
	
	,@RegistrosPorPagina                                       INT = '-1'
	,@NumeroDePagina                                           INT = '1'
	,@TotalDeRegistros                                         INT		OUTPUT
 
	,@sResSQL                                                  VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Recursos'
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
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT RECU.id
						,RECU.Nombre
						,RECU.Observaciones
						,RECU.Activo
						,COALESCE(STUFF((SELECT ', ' + U.Nombre + ' ' + U.Apellido
									FROM RelAsig_Usuarios_A_Recursos REL
										INNER JOIN Usuarios U ON U.id = REL.UsuarioId
									WHERE (REL.RecursoId = RECU.id)
									FOR XML PATH('')),1,1,''), '')AS UsuariosResponsables
						--,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN RECU.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN RECU.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN RECU.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '0' THEN RECU.Observaciones END
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '1' THEN RECU.Observaciones END DESC
						) AS NumeroDeRegistro
					FROM Recursos AS RECU
						INNER JOIN Contextos CX ON CX.id = RECU.ContextoId
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = RECU.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(RECU.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (RECU.ContextoId = @ContextoId OR @ContextoId = '-1')
						AND (@UsuarioResponsableId IN (SELECT UsuarioId FROM RelAsig_Usuarios_A_Recursos REL WHERE REL.RecursoId = RECU.id) OR @UsuarioResponsableId = '-1') -- FiltroDDL (FK)
						AND (RECU.Activo = @Activo OR @Activo IS NULL)
						AND
						(
							(@Filtro = '')
							OR (RECU.Nombre LIKE '%' + @Filtro + '%')
							OR (RECU.Observaciones LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginaci�n
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginaci�n
 
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
 
 
 
 
IF (OBJECT_ID('usp_Recursos__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_Recursos__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_Recursos__ListadoDDLoCBXL
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
 
	,@sResSQL                                                  VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Recursos'
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
 
			SELECT RECU.id
				,RECU.Nombre
			FROM Recursos AS RECU
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con par�metros del modelo se agregan dentro del "OR" en una linea.
				(RECU.id = @id) -- Si pas� un registro particular, lo agregamos al Select (Por ejemplo en un registro que est� est� seleccionado en el DDL, pero que actualmente est� "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no d� error si no hay ninguna FK y adem�s la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con par�metros del modelo se agregan a continuaci�n:
					 AND (RECU.Activo = @Activo OR @Activo IS NULL)
					 AND (RECU.ContextoId = @ContextoId OR @ContextoId = '-1')
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que tambi�n afecta al registro @id:
				(
					(@Filtro = '')
					OR (RECU.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY RECU.Nombre
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
-- SP-TABLA: Recursos /Listados Particulares/ - FIN
 
 
 
 
-- SP-TABLA: RelAsig_CuentasDeEnvios_A_Tablas /Listados Particulares/ - INICIO
IF (OBJECT_ID('usp_RelAsig_CuentasDeEnvios_A_Tablas__Listado') IS NOT NULL) DROP PROCEDURE usp_RelAsig_CuentasDeEnvios_A_Tablas__Listado
GO
CREATE PROCEDURE usp_RelAsig_CuentasDeEnvios_A_Tablas__Listado
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
 
	,@CuentaDeEnvioId                                          INT = '-1' -- FiltroDDL (FK)
	,@TablaId                                                  INT = '-1' -- FiltroDDL (FK)
 
	,@RegistrosPorPagina                                       INT = '-1'
	,@NumeroDePagina                                           INT = '1'
	,@TotalDeRegistros                                         INT		OUTPUT
 
	,@sResSQL                                                  VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_CuentasDeEnvios_A_Tablas'
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
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SELECT * INTO #TempTable
			FROM
				(
					SELECT RCAT.id
						,RCAT.CuentaDeEnvioId
						,RCAT.TablaId
						,CDE.CuentaDeEmail
						,CDE.Smtp
						,CDE.Puerto
						,CAST(CDE.Nombre AS VARCHAR(MAX)) AS CuentaDeEnvio
						,CAST(T.Nombre AS VARCHAR(MAX)) AS Tabla
						--,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN RCAT.CuentaDeEnvioId END 
								,CASE WHEN @OrdenarPor = 'CuentaDeEnvio' AND @Sentido = '0' THEN CDE.Nombre END
								,CASE WHEN @OrdenarPor = 'CuentaDeEnvio' AND @Sentido = '1' THEN CDE.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Tabla' AND @Sentido = '0' THEN T.Nombre END
								,CASE WHEN @OrdenarPor = 'Tabla' AND @Sentido = '1' THEN T.Nombre END DESC
						) AS NumeroDeRegistro
					FROM RelAsig_CuentasDeEnvios_A_Tablas AS RCAT
						INNER JOIN Contextos CX ON CX.id = RCAT.ContextoId
						INNER JOIN CuentasDeEnvios CDE ON CDE.id = RCAT.CuentaDeEnvioId
						INNER JOIN Tablas T ON T.id = RCAT.TablaId
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = RCAT.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(RCAT.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (RCAT.ContextoId = @ContextoId OR @ContextoId = '-1')
						AND (RCAT.CuentaDeEnvioId = @CuentaDeEnvioId OR @CuentaDeEnvioId = '-1') -- FiltroDDL (FK)
						AND (RCAT.TablaId = @TablaId OR @TablaId = '-1') -- FiltroDDL (FK)
						AND
						(
							(@Filtro = '')
							OR (CDE.Nombre LIKE '%' + @Filtro + '%')
							OR (T.Nombre LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginaci�n
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginaci�n
 
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
 
 
 
 
IF (OBJECT_ID('usp_RelAsig_CuentasDeEnvios_A_Tablas__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_RelAsig_CuentasDeEnvios_A_Tablas__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_RelAsig_CuentasDeEnvios_A_Tablas__ListadoDDLoCBXL
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
 
	,@CuentaDeEnvioId                                          INT = '-1' -- FiltroDDL (FK)
	,@TablaId                                                  INT = '-1' -- FiltroDDL (FK)
 
	,@sResSQL                                                  VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_CuentasDeEnvios_A_Tablas'
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
 
			SELECT RCAT.id
				,CDE.Nombre + ' - ' + CDE.CuentaDeEmail
			FROM RelAsig_CuentasDeEnvios_A_Tablas AS RCAT
				INNER JOIN Contextos CX ON CX.id = RCAT.ContextoId
				INNER JOIN CuentasDeEnvios CDE ON CDE.id = RCAT.CuentaDeEnvioId
				INNER JOIN Tablas T ON T.id = RCAT.TablaId
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con par�metros del modelo se agregan dentro del "OR" en una linea.
				(RCAT.id = @id) -- Si pas� un registro particular, lo agregamos al Select (Por ejemplo en un registro que est� est� seleccionado en el DDL, pero que actualmente est� "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no d� error si no hay ninguna FK y adem�s la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con par�metros del modelo se agregan a continuaci�n:
					 AND (RCAT.CuentaDeEnvioId = @CuentaDeEnvioId OR @CuentaDeEnvioId = '-1') -- FiltroDDL (FK)
					 AND (RCAT.TablaId = @TablaId OR @TablaId = '-1') -- FiltroDDL (FK)
					 AND (RCAT.ContextoId = @ContextoId OR @ContextoId = '-1')
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que tambi�n afecta al registro @id:
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
-- SP-TABLA: RelAsig_CuentasDeEnvios_A_Tablas /Listados Particulares/ - FIN




-- SP-TABLA: RelAsig_RolesDeUsuarios_A_Paginas /Listados Particulares/ - INICIO
IF (OBJECT_ID('usp_RelAsig_RolesDeUsuarios_A_Paginas__Listado') IS NOT NULL) DROP PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Paginas__Listado
GO
CREATE PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Paginas__Listado
	@UsuarioQueEjecutaId		INT						
	,@FechaDeEjecucion			DATETIME				
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
		
	,@OrdenarPor									VARCHAR(50) = ''
	,@Sentido										BIT = 0
	,@Filtro										VARCHAR(50) = ''		
	
	,@SeccionId										INT = '-1' -- FiltroDDL (FK)
	,@RolDeUsuarioId								INT = '-1' -- FiltroDDL (FK)
	,@PaginaId										INT = '-1' -- FiltroDDL (FK)
	,@AutorizadoA_CargarLaPagina					BIT = NULL
	,@AutorizadoA_OperarLaPagina					BIT = NULL
	,@AutorizadoA_VerRegAnulados					BIT = NULL
	,@AutorizadoA_AccionesEspeciales				BIT = NULL
	,@TablaId										INT = '-1' -- FiltroDDL (FK)
	
	,@RegistrosPorPagina							INT = '-1'
	,@NumeroDePagina								INT = '1'
	,@TotalDeRegistros								INT		OUTPUT
			
    ,@sResSQL										VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_RolesDeUsuarios_A_Paginas'
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
			DECLARE @SeMuestraEnAsignacionDePermisos BIT		-- Roles A P�ginas	
				,@SeMuestraEnAsignacionDeRoles BIT		-- Roles A Usuarios	
			
			EXEC usp_VAL_Usuarios__SeMuestraEnAsignacionDeRolesYPermisos  -- Validamos si puede ver los roles o no.
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					, @FechaDeEjecucion = @FechaDeEjecucion
					, @SeMuestraEnAsignacionDePermisos = @SeMuestraEnAsignacionDePermisos OUTPUT
					, @SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OUTPUT
					
			SELECT * INTO #TempTable
			FROM 
			(
				SELECT RPRP.id 
					,SEC.Nombre AS Seccion
					,RDU.Nombre AS RolDeUsuario
					,PAG.Nombre AS Pagina
					,SUBSTRING(PAG.Nombre, CHARINDEX('/', PAG.Nombre) +1, LEN(PAG.Nombre) ) AS PaginaSinSeccion
					,PAG.Titulo	AS Titulo
					,PAG.SeMuestraEnAsignacionDePermisos
					,RPRP.AutorizadoA_CargarLaPagina AS AutorizadoA_CargarLaPagina
					,RPRP.AutorizadoA_OperarLaPagina AS AutorizadoA_OperarLaPagina
					,RPRP.AutorizadoA_VerRegAnulados AS AutorizadoA_VerRegAnulados
					,RPRP.AutorizadoA_AccionesEspeciales AS AutorizadoA_AccionesEspeciales
					--,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
					,ROW_NUMBER() OVER 
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY  
								CASE WHEN @OrdenarPor = '' THEN RDU.Nombre END --DEFAULT
								,CASE WHEN @OrdenarPor = 'Seccion' AND @Sentido = '0' THEN SEC.Nombre END
								,CASE WHEN @OrdenarPor = 'Seccion' AND @Sentido = '1' THEN SEC.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'RolDeUsuario' AND @Sentido = '0' THEN RDU.Nombre END
								,CASE WHEN @OrdenarPor = 'RolDeUsuario' AND @Sentido = '1' THEN RDU.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Pagina' AND @Sentido = '0' THEN PAG.Nombre END
								,CASE WHEN @OrdenarPor = 'Pagina' AND @Sentido = '1' THEN PAG.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'AutorizadoA_CargarLaPagina' AND @Sentido = '0' THEN RPRP.AutorizadoA_CargarLaPagina END
								,CASE WHEN @OrdenarPor = 'AutorizadoA_CargarLaPagina' AND @Sentido = '1' THEN RPRP.AutorizadoA_CargarLaPagina END DESC
								,CASE WHEN @OrdenarPor = 'AutorizadoA_OperarLaPagina' AND @Sentido = '0' THEN RPRP.AutorizadoA_OperarLaPagina END
								,CASE WHEN @OrdenarPor = 'AutorizadoA_OperarLaPagina' AND @Sentido = '1' THEN RPRP.AutorizadoA_OperarLaPagina END DESC
								,CASE WHEN @OrdenarPor = 'AutorizadoA_VerRegAnulados' AND @Sentido = '0' THEN RPRP.AutorizadoA_VerRegAnulados END
								,CASE WHEN @OrdenarPor = 'AutorizadoA_VerRegAnulados' AND @Sentido = '1' THEN RPRP.AutorizadoA_VerRegAnulados END DESC
								,CASE WHEN @OrdenarPor = 'AutorizadoA_AccionesEspeciales' AND @Sentido = '0' THEN RPRP.AutorizadoA_AccionesEspeciales END
								,CASE WHEN @OrdenarPor = 'AutorizadoA_AccionesEspeciales' AND @Sentido = '1' THEN RPRP.AutorizadoA_AccionesEspeciales END DESC
						) AS NumeroDeRegistro
				FROM RelAsig_RolesDeUsuarios_A_Paginas RPRP
					INNER JOIN RolesDeUsuarios RDU ON RPRP.RolDeUsuarioId = RDU.id
					INNER JOIN Paginas PAG ON RPRP.PaginaId = PAG.id
					INNER JOIN Secciones SEC ON PAG.SeccionId = SEC.id
					--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = RPRP.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
				WHERE 
					--(	RDU.id NOT IN (SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@IdsString_ExclusionesDe_RolesDeUsuarios))) 
					
					(PAG.SeccionId = @SeccionId OR @SeccionId = '-1') -- FiltroDDL (FK)
					AND (RPRP.RolDeUsuarioId = @RolDeUsuarioId OR @RolDeUsuarioId = '-1') -- FiltroDDL (FK)
					AND (RPRP.PaginaId = @PaginaId OR @PaginaId = '-1') -- FiltroDDL (FK)
					AND (RPRP.AutorizadoA_CargarLaPagina = @AutorizadoA_CargarLaPagina OR @AutorizadoA_CargarLaPagina IS NULL)
					AND (RPRP.AutorizadoA_OperarLaPagina = @AutorizadoA_OperarLaPagina OR @AutorizadoA_OperarLaPagina IS NULL)
					AND (RPRP.AutorizadoA_VerRegAnulados = @AutorizadoA_VerRegAnulados OR @AutorizadoA_VerRegAnulados IS NULL)
					AND (RPRP.AutorizadoA_AccionesEspeciales = @AutorizadoA_AccionesEspeciales OR @AutorizadoA_AccionesEspeciales IS NULL)
					AND	(PAG.TablaId = @TablaId OR @TablaId = '-1') -- FiltroDDL (FK)
					
					AND (RDU.SeMuestraEnAsignacionDePermisos = @SeMuestraEnAsignacionDePermisos OR @SeMuestraEnAsignacionDePermisos IS NULL)
					AND (RDU.SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OR @SeMuestraEnAsignacionDeRoles IS NULL)
				
					AND
					(
						(@Filtro = '')
						OR (SEC.Nombre LIKE '%' + @Filtro + '%')
						OR (RDU.Nombre LIKE '%' + @Filtro + '%')
						OR (PAG.Nombre LIKE '%' + @Filtro + '%')
					)
			) Query
			
			SELECT	*
			FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginaci�n
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginaci�n

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
-- SP-TABLA: RelAsig_RolesDeUsuarios_A_Paginas /Listados Particulares/ - FIN




-- SP-TABLA: RelAsig_RolesDeUsuarios_A_Usuarios /Listados Particulares/ - INICIO
IF (OBJECT_ID('usp_RelAsig_RolesDeUsuarios_A_Usuarios__Listado') IS NOT NULL) DROP PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Usuarios__Listado
GO
CREATE PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Usuarios__Listado
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
 
	,@FechaDesdeDesde                                          DATE = NULL
	,@FechaDesdeHasta                                          DATE = NULL
	,@FechaHastaDesde                                          DATE = NULL
	,@FechaHastaHasta                                          DATE = NULL
	,@RolDeUsuarioId                                           INT = '-1' -- FiltroDDL (FK)
	,@UsuarioId                                                INT = '-1' -- FiltroDDL (FK)
 
	,@RegistrosPorPagina                                       INT = '-1'
	,@NumeroDePagina                                           INT = '1'
	,@TotalDeRegistros                                         INT		OUTPUT
 
	,@sResSQL                                                  VARCHAR(1000)	OUTPUT
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
			DECLARE @SeMuestraEnAsignacionDePermisos BIT		-- Roles A P�ginas	
				,@SeMuestraEnAsignacionDeRoles BIT		-- Roles A Usuarios	
			
			EXEC usp_VAL_Usuarios__SeMuestraEnAsignacionDeRolesYPermisos  -- Validamos si puede ver los roles o no.
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					, @FechaDeEjecucion = @FechaDeEjecucion
					, @SeMuestraEnAsignacionDePermisos = @SeMuestraEnAsignacionDePermisos OUTPUT
					, @SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OUTPUT
		
			SELECT * INTO #TempTable
			FROM
				(
					SELECT RDUAU.id
						,RDUAU.RolDeUsuarioId
						,RDUAU.UsuarioId
						,RDUAU.FechaDesde
						,dbo.ufc_Fechas__FormatoFechaComoTexto(RDUAU.FechaDesde) AS FechaDesdeFormateado
						,RDUAU.FechaHasta
						,dbo.ufc_Fechas__FormatoFechaComoTexto(RDUAU.FechaHasta) AS FechaHastaFormateado
						,CAST(RDU.Nombre AS VARCHAR(MAX)) AS RolDeUsuario
						,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS Usuario
						--,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN RDUAU.UsuarioId END 
								,CASE WHEN @OrdenarPor = 'FechaDesde' AND @Sentido = '0' THEN RDUAU.FechaDesde END
								,CASE WHEN @OrdenarPor = 'FechaDesde' AND @Sentido = '1' THEN RDUAU.FechaDesde END DESC
								,CASE WHEN @OrdenarPor = 'FechaDesdeFormateado' AND @Sentido = '0' THEN RDUAU.FechaDesde END
								,CASE WHEN @OrdenarPor = 'FechaDesdeFormateado' AND @Sentido = '1' THEN RDUAU.FechaDesde END DESC
								,CASE WHEN @OrdenarPor = 'FechaHasta' AND @Sentido = '0' THEN RDUAU.FechaHasta END
								,CASE WHEN @OrdenarPor = 'FechaHasta' AND @Sentido = '1' THEN RDUAU.FechaHasta END DESC
								,CASE WHEN @OrdenarPor = 'FechaHastaFormateado' AND @Sentido = '0' THEN RDUAU.FechaHasta END
								,CASE WHEN @OrdenarPor = 'FechaHastaFormateado' AND @Sentido = '1' THEN RDUAU.FechaHasta END DESC
								,CASE WHEN @OrdenarPor = 'RolDeUsuario' AND @Sentido = '0' THEN RDU.Nombre END
								,CASE WHEN @OrdenarPor = 'RolDeUsuario' AND @Sentido = '1' THEN RDU.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '0' THEN U.Apellido END
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '0' THEN U.Nombre END
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '1' THEN U.Apellido END DESC
								,CASE WHEN @OrdenarPor = 'Usuario' AND @Sentido = '1' THEN U.Nombre END DESC
						) AS NumeroDeRegistro
					FROM RelAsig_RolesDeUsuarios_A_Usuarios AS RDUAU
						INNER JOIN RolesDeUsuarios RDU ON RDU.id = RDUAU.RolDeUsuarioId
						INNER JOIN Usuarios U ON U.id = RDUAU.UsuarioId
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = RDUAU.id AND LR.TipoDeOperacionId = '2'
					WHERE
						(RDUAU.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						
						AND (RDU.SeMuestraEnAsignacionDePermisos = @SeMuestraEnAsignacionDePermisos OR @SeMuestraEnAsignacionDePermisos IS NULL)
						AND (RDU.SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OR @SeMuestraEnAsignacionDeRoles IS NULL)
						AND (U.SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OR @SeMuestraEnAsignacionDeRoles IS NULL)
						
						AND (RDUAU.FechaDesde >= @FechaDesdeDesde OR @FechaDesdeDesde IS NULL)
						AND (RDUAU.FechaDesde <= @FechaDesdeHasta OR @FechaDesdeHasta IS NULL)
						AND (RDUAU.FechaHasta >= @FechaHastaDesde OR @FechaHastaDesde IS NULL)
						AND (RDUAU.FechaHasta <= @FechaHastaHasta OR @FechaHastaHasta IS NULL)
						AND (RDUAU.RolDeUsuarioId = @RolDeUsuarioId OR @RolDeUsuarioId = '-1') -- FiltroDDL (FK)
						AND (RDUAU.UsuarioId = @UsuarioId OR @UsuarioId = '-1') -- FiltroDDL (FK)
						AND
						(
							(@Filtro = '')
							OR (RDUAU.FechaDesde LIKE '%' + @Filtro + '%')
							OR (RDUAU.FechaHasta LIKE '%' + @Filtro + '%')
							OR (RDU.Nombre LIKE '%' + @Filtro + '%')
							OR (U.Apellido LIKE '%' + @Filtro + '%')
							OR (U.Nombre LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginaci�n
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginaci�n
 
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
 
 
 
 
IF (OBJECT_ID('usp_RelAsig_RolesDeUsuarios_A_Usuarios__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Usuarios__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_RelAsig_RolesDeUsuarios_A_Usuarios__ListadoDDLoCBXL
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
	
	,@RolDeUsuarioId                                           INT = '-1' -- FiltroDDL (FK)
	,@UsuarioId                                                INT = '-1' -- FiltroDDL (FK)
 
	,@sResSQL                                                  VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_RolesDeUsuarios_A_Usuarios'
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
			DECLARE @SeMuestraEnAsignacionDePermisos BIT		-- Roles A P�ginas	
				,@SeMuestraEnAsignacionDeRoles BIT		-- Roles A Usuarios	
			
			EXEC usp_VAL_Usuarios__SeMuestraEnAsignacionDeRolesYPermisos  -- Validamos si puede ver los roles o no.
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					, @FechaDeEjecucion = @FechaDeEjecucion
					, @SeMuestraEnAsignacionDePermisos = @SeMuestraEnAsignacionDePermisos OUTPUT
					, @SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OUTPUT
					 
			SELECT RDUAU.id
				,U.Nombre
			FROM RelAsig_RolesDeUsuarios_A_Usuarios AS RDUAU
				INNER JOIN RolesDeUsuarios RDU ON RDU.id = RDUAU.RolDeUsuarioId
				INNER JOIN Usuarios U ON U.id = RDUAU.UsuarioId
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con par�metros del modelo se agregan dentro del "OR" en una linea.
				(RDUAU.id = @id) -- Si pas� un registro particular, lo agregamos al Select (Por ejemplo en un registro que est� est� seleccionado en el DDL, pero que actualmente est� "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no d� error si no hay ninguna FK y adem�s la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con par�metros del modelo se agregan a continuaci�n:
					 AND (RDUAU.RolDeUsuarioId = @RolDeUsuarioId OR @RolDeUsuarioId = '-1') -- FiltroDDL (FK)
					 AND (RDUAU.UsuarioId = @UsuarioId OR @UsuarioId = '-1') -- FiltroDDL (FK)
				)
				
				AND (RDU.SeMuestraEnAsignacionDePermisos = @SeMuestraEnAsignacionDePermisos OR @SeMuestraEnAsignacionDePermisos IS NULL)
				AND (RDU.SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OR @SeMuestraEnAsignacionDeRoles IS NULL)
				AND (U.SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OR @SeMuestraEnAsignacionDeRoles IS NULL)
				
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que tambi�n afecta al registro @id:
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
-- SP-TABLA: RelAsig_RolesDeUsuarios_A_Usuarios /Listados Particulares/ - FIN
 
 
 
 
-- SP-TABLA: RelAsig_TiposDeContactos_A_Contextos /Listados Particulares/ - INICIO
IF (OBJECT_ID('usp_RelAsig_TiposDeContactos_A_Contextos__Listado') IS NOT NULL) DROP PROCEDURE usp_RelAsig_TiposDeContactos_A_Contextos__Listado
GO
CREATE PROCEDURE usp_RelAsig_TiposDeContactos_A_Contextos__Listado
	 @UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40)
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
		
	,@OrdenarPor                                    VARCHAR(50) = ''
	,@Sentido                                       BIT = '0'
	,@Filtro                                        VARCHAR(50) = ''
 
	,@TipoDeContactoId                              INT = '-1' -- FiltroDDL (FK)
 
	,@RegistrosPorPagina                            INT = '-1'
	,@NumeroDePagina                                INT = '1'
	,@TotalDeRegistros                              INT		OUTPUT
 
	,@sResSQL                                       VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_TiposDeContactos_A_Contextos'
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
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			SELECT * INTO #TempTable
			FROM
				(
					-- AC� LA LOGICA PARA APLICAR ES DISITNTA, NOS APOYAMOS EN TiposDeontactos y hacemos LEFT JOIN a la Rel
					
					SELECT TDC.id
						,TDC.Nombre
						,(CASE WHEN (SELECT id FROM RelAsig_TiposDeContactos_A_Contextos WHERE TipoDeContactoId = TDC.id AND ContextoId = @ContextoId) IS NULL THEN 0
							ELSE 1 END) AS Asignado
						--,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN TDC.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN TDC.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN TDC.Nombre END DESC
						) AS NumeroDeRegistro
					FROM TiposDeContactos AS TDC
						--LEFT JOIN RelAsig_TiposDeContactos_A_Contextos ATCAC ON ATCAC.TipoDeContactoId = TDC.id
						--INNER JOIN Contextos CX ON CX.id = ATCAC.ContextoId // LISTAMOS LOS DE TODOS LOS CONTEXTOS PARA Q LUEGO PUEDA SELECCIONAR A CUAL SE ASIGNA.
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = TDC.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(TDC.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						--AND (ATCAC.ContextoId = @ContextoId OR @ContextoId = '-1') // LISTAMOS LOS DE TODOS LOS CONTEXTOS PARA Q LUEGO PUEDA SELECCIONAR A CUAL SE ASIGNA.
						AND (TDC.id = @TipoDeContactoId OR @TipoDeContactoId = '-1') -- FiltroDDL (FK)
						AND
						(
							(@Filtro = '')
							OR (TDC.Nombre LIKE '%' + @Filtro + '%')
						)
			) Query
 
			SELECT *
			FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginaci�n
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginaci�n
 
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
 
 
 
 
IF (OBJECT_ID('usp_RelAsig_TiposDeContactos_A_Contextos__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_RelAsig_TiposDeContactos_A_Contextos__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_RelAsig_TiposDeContactos_A_Contextos__ListadoDDLoCBXL
	 @UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
		
	,@id                                            INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro                                        VARCHAR(50) = ''
	
	,@TipoDeContactoId                              INT = '-1' -- FiltroDDL (FK)
 
	,@sResSQL                                       VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RelAsig_TiposDeContactos_A_Contextos'
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
 
			SELECT ATCAC.id
				,TDC.Nombre
			FROM RelAsig_TiposDeContactos_A_Contextos AS ATCAC
				INNER JOIN Contextos CX ON CX.id = ATCAC.ContextoId
				INNER JOIN TiposDeContactos TDC ON TDC.id = ATCAC.TipoDeContactoId
			WHERE 
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con par�metros del modelo se agregan dentro del "OR" en una linea.
				(ATCAC.id = @id) -- Si pas� un registro particular, lo agregamos al Select (Por ejemplo en un registro que est� est� seleccionado en el DDL, pero que actualmente est� "Anulado".
				OR 
				(	
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no d� error si no hay ninguna FK y adem�s la tabla no tiene ContextoId ni Activo.
					 -- Los "filtros" que se pasan con par�metros del modelo se agregan a continuaci�n:
					 AND (ATCAC.TipoDeContactoId = @TipoDeContactoId OR @TipoDeContactoId = '-1') -- FiltroDDL (FK)
					 AND (ATCAC.ContextoId = @ContextoId OR @ContextoId = '-1')
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que tambi�n afecta al registro @id: 
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
-- SP-TABLA: RelAsig_TiposDeContactos_A_Contextos /Listados Particulares/ - FIN
 
 
 
 
-- SP-TABLA: RolesDeUsuarios /Listados Particulares/ - INICIO
IF (OBJECT_ID('usp_RolesDeUsuarios__Listado') IS NOT NULL) DROP PROCEDURE usp_RolesDeUsuarios__Listado
GO
CREATE PROCEDURE usp_RolesDeUsuarios__Listado
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
 
	--,@SeMuestraEnAsignacionDePermisos                          BIT = NULL -- De Roles A P�ginas
	--,@SeMuestraEnAsignacionDeRoles		                       BIT = NULL -- De Roles A Usuarios
	,@Activo                                                   BIT = '1'
 
	,@RegistrosPorPagina                                       INT = '-1'
	,@NumeroDePagina                                           INT = '1'
	,@TotalDeRegistros                                         INT		OUTPUT
 
	,@sResSQL                                                  VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RolesDeUsuarios'
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
			DECLARE @SeMuestraEnAsignacionDePermisos BIT		-- Roles A P�ginas	
				,@SeMuestraEnAsignacionDeRoles BIT		-- Roles A Usuarios	
			
			EXEC usp_VAL_Usuarios__SeMuestraEnAsignacionDeRolesYPermisos  -- Validamos si puede ver los roles o no.
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					, @FechaDeEjecucion = @FechaDeEjecucion
					, @SeMuestraEnAsignacionDePermisos = @SeMuestraEnAsignacionDePermisos OUTPUT
					, @SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OUTPUT
		
			SELECT * INTO #TempTable
			FROM
				(
					SELECT RDU.id
						,RDU.Nombre
						,RDU.Observaciones
						,RDU.Prioridad
						,RDU.SeMuestraEnAsignacionDePermisos
						,RDU.SeMuestraEnAsignacionDeRoles
						,RDU.Activo
						--,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN RDU.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN RDU.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN RDU.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '0' THEN RDU.Observaciones END
								,CASE WHEN @OrdenarPor = 'Observaciones' AND @Sentido = '1' THEN RDU.Observaciones END DESC
								,CASE WHEN @OrdenarPor = 'Prioridad' AND @Sentido = '0' THEN RDU.Prioridad END
								,CASE WHEN @OrdenarPor = 'Prioridad' AND @Sentido = '1' THEN RDU.Prioridad END DESC
						) AS NumeroDeRegistro
					FROM RolesDeUsuarios AS RDU
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = RDU.id AND LR.TipoDeOperacionId = '2'
					WHERE
						(RDU.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						
						AND (RDU.SeMuestraEnAsignacionDePermisos = @SeMuestraEnAsignacionDePermisos OR @SeMuestraEnAsignacionDePermisos IS NULL)
						AND (RDU.SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OR @SeMuestraEnAsignacionDeRoles IS NULL)
						
						AND (RDU.Activo = @Activo OR @Activo IS NULL)
						AND
						(
							(@Filtro = '')
							OR (RDU.Nombre LIKE '%' + @Filtro + '%')
							OR (RDU.Observaciones LIKE '%' + @Filtro + '%')
							OR (RDU.Prioridad LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginaci�n
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginaci�n
 
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
 
 
 
 
IF (OBJECT_ID('usp_RolesDeUsuarios__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_RolesDeUsuarios__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_RolesDeUsuarios__ListadoDDLoCBXL
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
 
 	,@sResSQL                                                  VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'RolesDeUsuarios'
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
			DECLARE @SeMuestraEnAsignacionDePermisos BIT		-- Roles A P�ginas	
				,@SeMuestraEnAsignacionDeRoles BIT		-- Roles A Usuarios	
			
			EXEC usp_VAL_Usuarios__SeMuestraEnAsignacionDeRolesYPermisos  -- Validamos si puede ver los roles o no.
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					, @FechaDeEjecucion = @FechaDeEjecucion
					, @SeMuestraEnAsignacionDePermisos = @SeMuestraEnAsignacionDePermisos OUTPUT
					, @SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OUTPUT
				
			SELECT RDU.id
				,RDU.Nombre
			FROM RolesDeUsuarios AS RDU
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con par�metros del modelo se agregan dentro del "OR" en una linea.
				(RDU.id = @id) -- Si pas� un registro particular, lo agregamos al Select (Por ejemplo en un registro que est� est� seleccionado en el DDL, pero que actualmente est� "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no d� error si no hay ninguna FK y adem�s la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con par�metros del modelo se agregan a continuaci�n:
					 AND (RDU.Activo = @Activo OR @Activo IS NULL)
				)
				
				AND (RDU.SeMuestraEnAsignacionDePermisos = @SeMuestraEnAsignacionDePermisos OR @SeMuestraEnAsignacionDePermisos IS NULL)
				AND (RDU.SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OR @SeMuestraEnAsignacionDeRoles IS NULL)
				
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que tambi�n afecta al registro @id:
				(
					(@Filtro = '')
					OR (RDU.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY RDU.Nombre
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
-- SP-TABLA: RolesDeUsuarios /Listados Particulares/ - FIN




-- SP-TABLA: Soportes /Listados Particulares/ - INICIO
IF (OBJECT_ID('usp_Soportes__Listado') IS NOT NULL) DROP PROCEDURE usp_Soportes__Listado
GO
CREATE PROCEDURE usp_Soportes__Listado
	@UsuarioQueEjecutaId		INT						
	,@FechaDeEjecucion			DATETIME				
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
		
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = 0
	,@Filtro					VARCHAR(50) = ''		
	
	,@Activo					BIT = '1'
	
	,@PublicacionId				INT = '-1' -- FiltroDDL (FK)
	,@EstadoDeSoporteId			INT = '-1' -- FiltroDDL (FK)
	,@PrioridadDeSoporteId		INT = '-1' -- FiltroDDL (FK)
	,@Cerrado					BIT = NULL
	,@FechaDesde				DATETIME = NULL
	,@FechaHasta				DATETIME = NULL
	
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = 1
	,@TotalDeRegistros			INT		OUTPUT	
		
    ,@sResSQL					VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Soportes'
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
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			
			DECLARE @Tabla_SoportesId INT = (SELECT id FROM Tablas WHERE Nombre = 'Soportes')
			
			SELECT * INTO #TempTable
			FROM
			(
			   SELECT  SOP.id 
					,dbo.ufc_Usuarios__NombreCompletoFormateado(U.id) AS  UsuarioQueCreo
					,CASE WHEN SOP.UsuarioQueCerroId = 0 THEN NULL ELSE dbo.ufc_Usuarios__NombreCompletoFormateado(U2.id) END AS UsuarioQueCerro
					,dbo.ufc_Usuarios__NombreCompletoFormateado(U3.id) AS UsuarioQueSolicita
					,SOP.FechaDeEjecucion 
					,dbo.ufc_Fechas__FormatoFechaComoTexto(SOP.FechaDeEjecucion) AS FechaDeEjecucionFormateado
					,SOP.FechaDeCierre 
					,dbo.ufc_Fechas__FormatoFechaComoTexto(SOP.FechaDeCierre) AS FechaDeCierreFormateado
					,SOP.Numero
					,SOP.Texto
					,EDSOP.Nombre AS EstadoDeSoporte
					,PRI.Nombre AS Prioridad
					,SOP.Activo --,N'images/cbx/img_' + CONVERT(VARCHAR(5),SOP.Activo) + N'.jpg' AS imgActivo
					,SOP.Cerrado --,N'images/cbx/imgRealizado_' + CONVERT(VARCHAR(5), SOP.Cerrado) + N'.png' AS img_Cerrado
					,REPLACE(REPLACE(SOP.Cerrado, '1', 'Pedido Cerrado'), '0', 'Pedido Pendiente') AS TextoCerrado  -- Va como Tooltip
					,(CASE WHEN PUBLI.NumeroDeVersion IS NULL THEN '' ELSE PUBLI.NumeroDeVersion END) AS Publicacion
					--,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
					,ROW_NUMBER() OVER 
						(
							ORDER BY 
							CASE WHEN @OrdenarPor = '' THEN SOP.FechaDeEjecucion END DESC --DEFAULT
							,CASE WHEN @OrdenarPor = 'UsuarioQueCreo' AND @Sentido = '0' THEN U.Apellido END
								,CASE WHEN @OrdenarPor = 'UsuarioQueCreo' AND @Sentido = '0' THEN U.Nombre END
							,CASE WHEN @OrdenarPor = 'UsuarioQueCreo' AND @Sentido = '1' THEN U.Apellido END DESC
								,CASE WHEN @OrdenarPor = 'UsuarioQueCreo' AND @Sentido = '1' THEN U.Nombre END DESC
							,CASE WHEN @OrdenarPor = 'UsuarioQueCerro' AND @Sentido = '0' THEN U2.Apellido END
								,CASE WHEN @OrdenarPor = 'UsuarioQueCerro' AND @Sentido = '0' THEN U2.Nombre END
							,CASE WHEN @OrdenarPor = 'UsuarioQueCerro' AND @Sentido = '1' THEN U2.Apellido END DESC
								,CASE WHEN @OrdenarPor = 'UsuarioQueCerro' AND @Sentido = '1' THEN U2.Nombre END DESC
							,CASE WHEN @OrdenarPor = 'UsuarioQueSolicita' AND @Sentido = '0' THEN U3.Apellido END
								,CASE WHEN @OrdenarPor = 'UsuarioQueSolicita' AND @Sentido = '0' THEN U3.Nombre END
							,CASE WHEN @OrdenarPor = 'UsuarioQueSolicita' AND @Sentido = '1' THEN U3.Apellido END DESC
								,CASE WHEN @OrdenarPor = 'UsuarioQueSolicita' AND @Sentido = '1' THEN U3.Nombre END DESC
							,CASE WHEN @OrdenarPor = 'FechaDeEjecucion' AND @Sentido = '0' THEN SOP.FechaDeEjecucion END
							,CASE WHEN @OrdenarPor = 'FechaDeEjecucion' AND @Sentido = '1' THEN SOP.FechaDeEjecucion END DESC
							,CASE WHEN @OrdenarPor = 'FechaDeEjecucionFormateado' AND @Sentido = '0' THEN SOP.FechaDeEjecucion END
							,CASE WHEN @OrdenarPor = 'FechaDeEjecucionFormateado' AND @Sentido = '1' THEN SOP.FechaDeEjecucion END DESC
							,CASE WHEN @OrdenarPor = 'FechaDeCierre' AND @Sentido = '0' THEN SOP.FechaDeCierre END
							,CASE WHEN @OrdenarPor = 'FechaDeCierre' AND @Sentido = '1' THEN SOP.FechaDeCierre END DESC
							,CASE WHEN @OrdenarPor = 'FechaDeCierreFormateado' AND @Sentido = '0' THEN SOP.FechaDeCierre END
							,CASE WHEN @OrdenarPor = 'FechaDeCierreFormateado' AND @Sentido = '1' THEN SOP.FechaDeCierre END DESC
							,CASE WHEN @OrdenarPor = 'Numero' AND @Sentido = '0' THEN SOP.Numero END
							,CASE WHEN @OrdenarPor = 'Numero' AND @Sentido = '1' THEN SOP.Numero END DESC
							,CASE WHEN @OrdenarPor = 'EstadoDeSoporte' AND @Sentido = '0' THEN EDSOP.Nombre END
							,CASE WHEN @OrdenarPor = 'EstadoDeSoporte' AND @Sentido = '1' THEN EDSOP.Nombre END DESC
							,CASE WHEN @OrdenarPor = 'Prioridad' AND @Sentido = '0' THEN PRI.Nombre END
							,CASE WHEN @OrdenarPor = 'Prioridad' AND @Sentido = '1' THEN PRI.Nombre END DESC
						) 
					AS NumeroDeRegistro
				FROM Soportes SOP
					LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = SOP.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					INNER JOIN Usuarios U ON LR.UsuarioQueEjecutaId = U.id
					INNER JOIN Usuarios U2 ON SOP.UsuarioQueCerroId = U2.id
					INNER JOIN Usuarios U3 ON SOP.UsuarioQueSolicitaId = U3.id
					INNER JOIN EstadosDeSoportes EDSOP ON SOP.EstadoDeSoportesId = EDSOP.id
					INNER JOIN PrioridadesDeSoportes PRI ON SOP.PrioridadDeSoporteId = PRI.id
					LEFT JOIN Publicaciones PUBLI ON SOP.PublicacionId = PUBLI.id
				WHERE 
					(SOP.Activo = @Activo OR @Activo IS NULL)
					AND (SOP.ContextoId = @ContextoId)
					AND (SOP.PublicacionId = @PublicacionId OR @PublicacionId = '-1' OR (SOP.PublicacionId IS NULL AND @PublicacionId = '0')) -- FiltroDDL (FK) NULL
					AND (SOP.EstadoDeSoportesId = @EstadoDeSoporteId OR @EstadoDeSoporteId = '-1') -- FiltroDDL (FK)
					AND (SOP.PrioridadDeSoporteId = @PrioridadDeSoporteId OR @PrioridadDeSoporteId = '-1') -- FiltroDDL (FK)
					AND (SOP.Cerrado = @Cerrado OR @Cerrado IS NULL)
					AND (SOP.FechaDeEjecucion > @FechaDesde OR @FechaDesde IS NULL)
					AND (SOP.FechaDeEjecucion < @FechaHasta OR @FechaHasta IS NULL)
					AND
					(
						(@Filtro = '')
						OR (SOP.Numero LIKE '%' + @Filtro + '%')
						OR (U.Apellido + N', ' + U.Nombre LIKE '%' + @Filtro + '%')
						OR (U2.Apellido + N', ' + U2.Nombre LIKE '%' + @Filtro + '%')
						OR (U3.Apellido + N', ' + U3.Nombre LIKE '%' + @Filtro + '%')
						OR (SOP.Texto LIKE '%' + @Filtro + '%')
						OR (SOP.Observaciones LIKE '%' + @Filtro + '%')
						OR (PRI.Nombre LIKE '%' + @Filtro + '%')
					)
			) Query
	
			SELECT	*
			FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginaci�n
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginaci�n
			
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
-- SP-TABLA: Soportes /Listados Particulares/ - FIN
 
 
 
 
-- SP-TABLA: Tablas /Listados Particulares/ - INICIO
IF (OBJECT_ID('usp_Tablas__Listado') IS NOT NULL) DROP PROCEDURE usp_Tablas__Listado
GO
CREATE PROCEDURE usp_Tablas__Listado
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
 
	,@TieneActivo				BIT = NULL
	
	,@SeDebenEvaluarPermisos                                   BIT = NULL
	,@PermiteEliminarSusRegistros                              BIT = NULL
	,@TablaDeCore                                              BIT = NULL
	,@SeCreanPaginas                                           BIT = NULL
	,@TieneArchivos                                            BIT = NULL
	,@SeGeneranAutoSusSPsDeABM                                 BIT = NULL
	,@SeGeneranAutoSusSPsDeRegistros                           BIT = NULL
	,@SeGeneranAutoSusSPsDeListados                            BIT = NULL
	,@IconoCSSId                                               INT = '-1' -- FiltroDDL (FK)
 
	,@RegistrosPorPagina                                       INT = '-1'
	,@NumeroDePagina                                           INT = '1'
	,@TotalDeRegistros                                         INT		OUTPUT
 
	,@sResSQL                                                  VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Tablas'
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
			SELECT * INTO #TempTable
			FROM
				(
					SELECT T.id
						,T.IconoCSSId
						,T.Nombre
						,T.NombreAMostrar
						,T.Nomenclatura
						,T.SeDebenEvaluarPermisos
						,T.PermiteEliminarSusRegistros
						,CASE WHEN COL_LENGTH(T.Nombre, 'Activo') IS NULL THEN '0' ELSE '1' END AS TieneActivo
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
						,CAST(ICSS.CSS AS VARCHAR(MAX)) AS IconoCSS
						--,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN T.Nombre END 
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '0' THEN T.Nombre END
								,CASE WHEN @OrdenarPor = 'Nombre' AND @Sentido = '1' THEN T.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'NombreAMostrar' AND @Sentido = '0' THEN T.NombreAMostrar END
								,CASE WHEN @OrdenarPor = 'NombreAMostrar' AND @Sentido = '1' THEN T.NombreAMostrar END DESC
								,CASE WHEN @OrdenarPor = 'Nomenclatura' AND @Sentido = '0' THEN T.Nomenclatura END
								,CASE WHEN @OrdenarPor = 'Nomenclatura' AND @Sentido = '1' THEN T.Nomenclatura END DESC
								,CASE WHEN @OrdenarPor = 'CampoAMostrarEnFK' AND @Sentido = '0' THEN T.CampoAMostrarEnFK END
								,CASE WHEN @OrdenarPor = 'CampoAMostrarEnFK' AND @Sentido = '1' THEN T.CampoAMostrarEnFK END DESC
								,CASE WHEN @OrdenarPor = 'CamposQuePuedenSerIdsString' AND @Sentido = '0' THEN T.CamposQuePuedenSerIdsString END
								,CASE WHEN @OrdenarPor = 'CamposQuePuedenSerIdsString' AND @Sentido = '1' THEN T.CamposQuePuedenSerIdsString END DESC
								,CASE WHEN @OrdenarPor = 'CamposAExcluirEnElInsert' AND @Sentido = '0' THEN T.CamposAExcluirEnElInsert END
								,CASE WHEN @OrdenarPor = 'CamposAExcluirEnElInsert' AND @Sentido = '1' THEN T.CamposAExcluirEnElInsert END DESC
								,CASE WHEN @OrdenarPor = 'CamposAExcluirEnElUpdate' AND @Sentido = '0' THEN T.CamposAExcluirEnElUpdate END
								,CASE WHEN @OrdenarPor = 'CamposAExcluirEnElUpdate' AND @Sentido = '1' THEN T.CamposAExcluirEnElUpdate END DESC
								,CASE WHEN @OrdenarPor = 'CamposAExcluirEnElListado' AND @Sentido = '0' THEN T.CamposAExcluirEnElListado END
								,CASE WHEN @OrdenarPor = 'CamposAExcluirEnElListado' AND @Sentido = '1' THEN T.CamposAExcluirEnElListado END DESC
								,CASE WHEN @OrdenarPor = 'CamposAIncluirEnFiltrosDeListado' AND @Sentido = '0' THEN T.CamposAIncluirEnFiltrosDeListado END
								,CASE WHEN @OrdenarPor = 'CamposAIncluirEnFiltrosDeListado' AND @Sentido = '1' THEN T.CamposAIncluirEnFiltrosDeListado END DESC
								,CASE WHEN @OrdenarPor = 'IconoCSS' AND @Sentido = '0' THEN ICSS.Nombre END
								,CASE WHEN @OrdenarPor = 'IconoCSS' AND @Sentido = '1' THEN ICSS.Nombre END DESC
						) AS NumeroDeRegistro
					FROM Tablas AS T
						INNER JOIN IconosCSS ICSS ON ICSS.id = T.IconoCSSId
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = T.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(T.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (T.SeDebenEvaluarPermisos = @SeDebenEvaluarPermisos OR @SeDebenEvaluarPermisos IS NULL)
						AND (T.PermiteEliminarSusRegistros = @PermiteEliminarSusRegistros OR @PermiteEliminarSusRegistros IS NULL)
						AND (T.TablaDeCore = @TablaDeCore OR @TablaDeCore IS NULL)
						AND (T.SeCreanPaginas = @SeCreanPaginas OR @SeCreanPaginas IS NULL)
						AND (T.TieneArchivos = @TieneArchivos OR @TieneArchivos IS NULL)
						AND (T.SeGeneranAutoSusSPsDeABM = @SeGeneranAutoSusSPsDeABM OR @SeGeneranAutoSusSPsDeABM IS NULL)
						AND (T.SeGeneranAutoSusSPsDeRegistros = @SeGeneranAutoSusSPsDeRegistros OR @SeGeneranAutoSusSPsDeRegistros IS NULL)
						AND (T.SeGeneranAutoSusSPsDeListados = @SeGeneranAutoSusSPsDeListados OR @SeGeneranAutoSusSPsDeListados IS NULL)
						AND (T.IconoCSSId = @IconoCSSId OR @IconoCSSId = '-1') -- FiltroDDL (FK)
						
						AND (@TieneActivo IS NULL -- puede ser
								OR (COL_LENGTH(T.Nombre, 'Activo') IS NULL AND @TieneActivo = '0')
								OR (COL_LENGTH(T.Nombre, 'Activo') IS NOT NULL AND @TieneActivo = '1')
							)
						
						AND
						(
							(@Filtro = '')
							OR (T.Nombre LIKE '%' + @Filtro + '%')
							OR (T.NombreAMostrar LIKE '%' + @Filtro + '%')
							OR (T.Nomenclatura LIKE '%' + @Filtro + '%')
							OR (T.CampoAMostrarEnFK LIKE '%' + @Filtro + '%')
							OR (T.CamposQuePuedenSerIdsString LIKE '%' + @Filtro + '%')
							OR (T.CamposAExcluirEnElInsert LIKE '%' + @Filtro + '%')
							OR (T.CamposAExcluirEnElUpdate LIKE '%' + @Filtro + '%')
							OR (T.CamposAExcluirEnElListado LIKE '%' + @Filtro + '%')
							OR (T.CamposAIncluirEnFiltrosDeListado LIKE '%' + @Filtro + '%')
							OR (ICSS.Nombre LIKE '%' + @Filtro + '%')
						)
			) Query
 
		SELECT *
		FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginaci�n
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginaci�n
 
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
 
 
 
 
IF (OBJECT_ID('usp_Tablas__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_Tablas__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_Tablas__ListadoDDLoCBXL
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
 
	,@sResSQL                                                  VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Tablas'
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
			SELECT T.id
				,'[' + T.Nomenclatura + ']: ' + T.Nombre AS Nombre
			FROM Tablas AS T
			WHERE
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con par�metros del modelo se agregan dentro del "OR" en una linea.
				(T.id = @id) -- Si pas� un registro particular, lo agregamos al Select (Por ejemplo en un registro que est� est� seleccionado en el DDL, pero que actualmente est� "Anulado".
				OR
				(
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no d� error si no hay ninguna FK y adem�s la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con par�metros del modelo se agregan a continuaci�n:
					 AND (T.IconoCSSId = @IconoCSSId OR @IconoCSSId = '-1') -- FiltroDDL (FK)
				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que tambi�n afecta al registro @id:
				(
					(@Filtro = '')
					OR (T.Nombre LIKE '%' + @Filtro + '%')
				)
			ORDER BY T.Nombre
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
-- SP-TABLA: Tablas /Listados Particulares/ - FIN




-- SP-TABLA: Tareas /Listados Particulares/ - INICIO
IF (OBJECT_ID('usp_Tareas__Listado') IS NOT NULL) DROP PROCEDURE usp_Tareas__Listado
GO
CREATE PROCEDURE usp_Tareas__Listado
	@UsuarioQueEjecutaId		INT						
	,@FechaDeEjecucion			DATETIME				
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
		
	,@OrdenarPor				VARCHAR(50) = ''
	,@Sentido					BIT = 0
	,@Filtro					VARCHAR(50) = ''		
	
	,@Activo					BIT = '1'
	,@TipoDeTareaId				INT = '-1' -- FiltroDDL (FK)
	,@IdsString_EstadosDeTareas VARCHAR(100) = '-1' --@EstadoDeTareaId			INT = '-1' -- FiltroDDL (FK)
	,@ImportanciaDeTareaId		INT = '-1' -- FiltroDDL (FK)
	,@TablaDelRegistro			VARCHAR(80) = ''
	,@FechaInicioDesde			DATE = NULL
	,@FechaInicioHasta			DATE = NULL
	,@FechaLimiteDesde			DATE = NULL
	,@FechaLimiteHasta			DATE = NULL
	
	,@RegistrosPorPagina		INT = '-1'
	,@NumeroDePagina			INT = 1
	,@TotalDeRegistros			INT		OUTPUT	
		
    ,@sResSQL					VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Tareas'
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
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			
			DECLARE @TablaId INT = COALESCE((SELECT id FROM Tablas WHERE Nombre = @TablaDelRegistro), -1)
			
			SELECT * INTO #TempTable
			FROM
			(
			   SELECT  TA.id 
					,dbo.ufc_Usuarios__NombreCompletoFormateado(UI.id) AS UsuarioInteresado
					,dbo.ufc_Usuarios__NombreCompletoFormateado(UD.id) AS UsuarioDestinatario
					--,TA.FechaDeInicio
					--,dbo.ufc_Fechas__FormatoFechaComoTexto(TA.FechaDeInicio) AS FechaDeInicioFormateado
					,TA.FechaLimite
					,dbo.ufc_Fechas__FormatoFechaComoTexto(TA.FechaLimite) AS FechaLimiteFormateado
					--,TA.Numero
					,TDT.Nombre AS TipoDeTarea
					,EDT.Nombre AS EstadoDeTarea
					,TA.Titulo
					,IDT.Nombre AS ImportanciaDeTarea
					--,T.Nombre AS Tabla
					--,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
					,ROW_NUMBER() OVER 
						(
							ORDER BY 
							CASE WHEN @OrdenarPor = '' THEN TA.FechaLimite END DESC --DEFAULT
							--,CASE WHEN @OrdenarPor = 'UsuarioInteresado' AND @Sentido = '0' THEN UI.Apellido END
							--	,CASE WHEN @OrdenarPor = 'UsuarioInteresado' AND @Sentido = '0' THEN UI.Nombre END
							--,CASE WHEN @OrdenarPor = 'UsuarioInteresado' AND @Sentido = '1' THEN UI.Apellido END DESC
							--	,CASE WHEN @OrdenarPor = 'UsuarioInteresado' AND @Sentido = '1' THEN UI.Nombre END DESC
							,CASE WHEN @OrdenarPor = 'UsuarioDestinatario' AND @Sentido = '0' THEN UD.Apellido END
								,CASE WHEN @OrdenarPor = 'UsuarioDestinatario' AND @Sentido = '0' THEN UD.Nombre END
							,CASE WHEN @OrdenarPor = 'UsuarioDestinatario' AND @Sentido = '1' THEN UD.Apellido END DESC
								,CASE WHEN @OrdenarPor = 'UsuarioDestinatario' AND @Sentido = '1' THEN UD.Nombre END DESC
							--,CASE WHEN @OrdenarPor = 'FechaDeInicio' AND @Sentido = '0' THEN TA.FechaDeInicio END
							--,CASE WHEN @OrdenarPor = 'FechaDeInicio' AND @Sentido = '1' THEN TA.FechaDeInicio END DESC
							--,CASE WHEN @OrdenarPor = 'FechaDeInicioFormateado' AND @Sentido = '0' THEN TA.FechaDeInicio END
							--,CASE WHEN @OrdenarPor = 'FechaDeInicioFormateado' AND @Sentido = '1' THEN TA.FechaDeInicio END DESC
							,CASE WHEN @OrdenarPor = 'FechaLimite' AND @Sentido = '0' THEN TA.FechaLimite END
							,CASE WHEN @OrdenarPor = 'FechaLimite' AND @Sentido = '1' THEN TA.FechaLimite END DESC
							,CASE WHEN @OrdenarPor = 'FechaLimiteFormateado' AND @Sentido = '0' THEN TA.FechaLimite END
							,CASE WHEN @OrdenarPor = 'FechaLimiteFormateado' AND @Sentido = '1' THEN TA.FechaLimite END DESC
							--,CASE WHEN @OrdenarPor = 'Numero' AND @Sentido = '0' THEN TA.Numero END
							--,CASE WHEN @OrdenarPor = 'Numero' AND @Sentido = '1' THEN TA.Numero END DESC
							,CASE WHEN @OrdenarPor = 'TipoDeTarea' AND @Sentido = '0' THEN TDT.Nombre END
							,CASE WHEN @OrdenarPor = 'TipoDeTarea' AND @Sentido = '1' THEN TDT.Nombre END DESC
							,CASE WHEN @OrdenarPor = 'EstadoDeTareas' AND @Sentido = '0' THEN EDT.Nombre END
							,CASE WHEN @OrdenarPor = 'EstadoDeTareas' AND @Sentido = '1' THEN EDT.Nombre END DESC
							,CASE WHEN @OrdenarPor = 'Titulo' AND @Sentido = '0' THEN TA.Titulo END
							,CASE WHEN @OrdenarPor = 'Titulo' AND @Sentido = '1' THEN TA.Titulo END DESC
							--,CASE WHEN @OrdenarPor = 'Tabla' AND @Sentido = '0' THEN T.Nombre END
							--,CASE WHEN @OrdenarPor = 'Tabla' AND @Sentido = '1' THEN T.Nombre END DESC
						) 
					AS NumeroDeRegistro
				FROM Tareas TA
					INNER JOIN Usuarios UI ON TA.UsuarioOriginanteId = UI.id
					INNER JOIN Usuarios UD ON TA.UsuarioDestinatarioId = UD.id
					INNER JOIN TiposDeTareas TDT ON TA.TipoDeTareaId = TDT.id
					INNER JOIN EstadosDeTareas EDT ON TA.EstadoDeTareaId = EDT.id
					INNER JOIN ImportanciasDeTareas IDT ON TA.ImportanciaDeTareaId = IDT.id
					INNER JOIN Tablas T ON TA.TablaId = T.id
					--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = TA.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
				WHERE 
					(TA.Activo = @Activo OR @Activo IS NULL)
					AND (TA.ContextoId = @ContextoId)
					AND (TA.TipoDeTareaId = @TipoDeTareaId OR @TipoDeTareaId = '-1') -- FiltroDDL (FK)
					--AND (TA.EstadoDeTareaId = @EstadoDeTareaId OR @EstadoDeTareaId = '-1') -- FiltroDDL (FK)
					AND ((TA.EstadoDeTareaId IN (SELECT id FROM ufc_Strings__ConvertirIdsString_ToTable_INT(@IdsString_EstadosDeTareas))) OR @IdsString_EstadosDeTareas = '-1') -- FiltroDDL (FK)
					AND (TA.ImportanciaDeTareaId = @ImportanciaDeTareaId OR @ImportanciaDeTareaId = '-1') -- FiltroDDL (FK)
					AND (TA.TablaId = @TablaId OR @TablaId = '-1') -- FiltroDDL (FK) pero en este caso se pasa su nombre, y luego adentro busca el id
					AND (TA.FechaDeInicio > @FechaInicioDesde OR @FechaInicioDesde IS NULL)
					AND (TA.FechaDeInicio < @FechaInicioHasta OR @FechaInicioHasta IS NULL)
					AND (TA.FechaLimite > @FechaLimiteDesde OR @FechaLimiteDesde IS NULL)
					AND (TA.FechaLimite < @FechaLimiteHasta OR @FechaLimiteHasta IS NULL)
					AND
					(
						(@Filtro = '')
						OR (TA.Numero LIKE '%' + @Filtro + '%')
						--OR (UI.Apellido + N', ' + UI.Nombre LIKE '%' + @Filtro + '%')
						OR (UD.Apellido + N', ' + UD.Nombre LIKE '%' + @Filtro + '%')
						--OR (TA.Numero LIKE '%' + @Filtro + '%')
						OR (TDT.Nombre LIKE '%' + @Filtro + '%')
						OR (EDT.Nombre LIKE '%' + @Filtro + '%')
						OR (TA.Titulo LIKE '%' + @Filtro + '%')
						OR (IDT.Nombre LIKE '%' + @Filtro + '%')
						--OR (T.Nombre LIKE '%' + @Filtro + '%')
					)
			) Query
	
			SELECT	*
			FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginaci�n
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginaci�n
			
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
-- SP-TABLA: Tareas /Listados Particulares/ - FIN




-- SP-TABLA: Usuarios /Listados Particulares/ - INICIO
IF (OBJECT_ID('usp_Usuarios__Listado') IS NOT NULL) DROP PROCEDURE usp_Usuarios__Listado
GO
CREATE PROCEDURE usp_Usuarios__Listado
	 @UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40)
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
		
	,@OrdenarPor                                    VARCHAR(50) = ''
	,@Sentido                                       BIT = '0'
	,@Filtro                                        VARCHAR(50) = ''
 
	,@Activo                                        BIT = '1'
	,@UltimoLoginFechaDesde                         DATETIME = NULL
	,@UltimoLoginFechaHasta                         DATETIME = NULL
	,@FechaDeExpiracionCookieDesde                  DATETIME = NULL
	,@FechaDeExpiracionCookieHasta                  DATETIME = NULL
	--,@ActorId                                       INT = '-1' -- FiltroDDL (FK)
 
	,@RegistrosPorPagina                            INT = '-1'
	,@NumeroDePagina                                INT = '1'
	,@TotalDeRegistros                              INT		OUTPUT
 
	,@sResSQL                                       VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Usuarios'
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
			DECLARE @ContextoId	INT
			EXEC @ContextoId = ufc_Contextos__ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
 
			DECLARE @SeMuestraEnAsignacionDeRoles BIT		-- Roles A Usuarios	
			EXEC usp_VAL_Usuarios__SeMuestraEnAsignacionDeRoles  -- Validamos si puede ver los roles o no.
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					, @FechaDeEjecucion = @FechaDeEjecucion
					, @SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OUTPUT
		
			SELECT * INTO #TempTable
			FROM
				(
					SELECT U.id
						,U.Apellido + ', ' + U.Nombre AS NombreCompleto
						--,U.ActorId
						,U.UserName + '@' + CX.Codigo AS UserName
						--,U.Pass
						--,U.Nombre
						--,U.Apellido
						,U.Email
						--,U.Email2
						,U.Telefono
						--,U.Telefono2
						--,U.Direccion
						,U.Activo
						--,U.UltimoLoginSesionId
						--,U.UltimoLoginFecha
						--,U.AuthCookie
						--,dbo.ufc_Fechas__FormatoFechaComoTexto(U.FechaDeExpiracionCookie) AS FechaDeExpiracionCookie
						--,CAST(ACT.Nombre AS VARCHAR(MAX)) AS Actor
						,COALESCE(STUFF((SELECT ', ' + RDU.Nombre
										FROM dbo.RelAsig_RolesDeUsuarios_A_Usuarios AS RDUAU
											INNER JOIN RolesDeUsuarios RDU ON RDU.id = RDUAU.RolDeUsuarioId
										WHERE (RDUAU.UsuarioId = U.id AND (RDU.SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OR @SeMuestraEnAsignacionDeRoles IS NULL))
										FOR XML PATH('')),1,1,''), '') AS RolesDeUsuario -- Va sin la "s" x q si no, se pisa con el campo del DDL en .Net
						--,dbo.ufc_Fechas__FormatoFechaComoTexto(LR.FechaDeEjecucion) AS FechaYHoraDeCreacion
						,ROW_NUMBER() OVER
						(
							-- VER QUE PARA PONER VARIOS CAMPOS --> VARIAS LINEAS CON EL MISMO WHEN
							ORDER BY
								CASE WHEN @OrdenarPor = '' THEN U.Apellido END --DEFAULT
								,CASE WHEN @OrdenarPor = '' THEN U.Nombre END --DEFAULT
								,CASE WHEN @OrdenarPor = 'NombreCompleto' AND @Sentido = '0' THEN U.Apellido END
								,CASE WHEN @OrdenarPor = 'NombreCompleto' AND @Sentido = '0' THEN U.Nombre END
								,CASE WHEN @OrdenarPor = 'NombreCompleto' AND @Sentido = '1' THEN U.Apellido END DESC
								,CASE WHEN @OrdenarPor = 'NombreCompleto' AND @Sentido = '1' THEN U.Nombre END DESC
								,CASE WHEN @OrdenarPor = 'UserName' AND @Sentido = '0' THEN U.UserName END
								,CASE WHEN @OrdenarPor = 'UserName' AND @Sentido = '1' THEN U.UserName END DESC
								--,CASE WHEN @OrdenarPor = 'Pass' AND @Sentido = '0' THEN U.Pass END
								--,CASE WHEN @OrdenarPor = 'Pass' AND @Sentido = '1' THEN U.Pass END DESC
								,CASE WHEN @OrdenarPor = 'Email' AND @Sentido = '0' THEN U.Email END
								,CASE WHEN @OrdenarPor = 'Email' AND @Sentido = '1' THEN U.Email END DESC
								--,CASE WHEN @OrdenarPor = 'Email2' AND @Sentido = '0' THEN U.Email2 END
								--,CASE WHEN @OrdenarPor = 'Email2' AND @Sentido = '1' THEN U.Email2 END DESC
								,CASE WHEN @OrdenarPor = 'Telefono' AND @Sentido = '0' THEN U.Telefono END
								,CASE WHEN @OrdenarPor = 'Telefono' AND @Sentido = '1' THEN U.Telefono END DESC
								--,CASE WHEN @OrdenarPor = 'Telefono2' AND @Sentido = '0' THEN U.Telefono2 END
								--,CASE WHEN @OrdenarPor = 'Telefono2' AND @Sentido = '1' THEN U.Telefono2 END DESC
								--,CASE WHEN @OrdenarPor = 'Direccion' AND @Sentido = '0' THEN U.Direccion END
								--,CASE WHEN @OrdenarPor = 'Direccion' AND @Sentido = '1' THEN U.Direccion END DESC
								--,CASE WHEN @OrdenarPor = 'UltimoLoginFecha' AND @Sentido = '0' THEN U.UltimoLoginFecha END
								--,CASE WHEN @OrdenarPor = 'UltimoLoginFecha' AND @Sentido = '1' THEN U.UltimoLoginFecha END DESC
								--,CASE WHEN @OrdenarPor = 'AuthCookie' AND @Sentido = '0' THEN U.AuthCookie END
								--,CASE WHEN @OrdenarPor = 'AuthCookie' AND @Sentido = '1' THEN U.AuthCookie END DESC
								--,CASE WHEN @OrdenarPor = 'FechaDeExpiracionCookie' AND @Sentido = '0' THEN U.FechaDeExpiracionCookie END
								--,CASE WHEN @OrdenarPor = 'FechaDeExpiracionCookie' AND @Sentido = '1' THEN U.FechaDeExpiracionCookie END DESC
								--,CASE WHEN @OrdenarPor = 'Actor' AND @Sentido = '0' THEN ACT.Nombre END
								--,CASE WHEN @OrdenarPor = 'Actor' AND @Sentido = '1' THEN ACT.Nombre END DESC
						) AS NumeroDeRegistro
					FROM Usuarios AS U
						--INNER JOIN Actores ACT ON ACT.id = U.ActorId
						INNER JOIN Contextos CX ON CX.id = U.ContextoId
						--LEFT JOIN LogRegistros LR ON LR.TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla) AND LR.RegistroId = U.id AND LR.TipoDeOperacionId = '2' -- OJO VA LEFT JOIN x que puede no tener Log
					WHERE
						(U.id > '0') -- No es necesario, pero para mantener estructura de los "AND" Siguientes.
						AND (U.ContextoId = @ContextoId OR @ContextoId = '-1')
						AND (U.Activo = @Activo OR @Activo IS NULL)
						AND (U.UltimoLoginFecha >= @UltimoLoginFechaDesde OR @UltimoLoginFechaDesde IS NULL)
						AND (U.UltimoLoginFecha <= @UltimoLoginFechaHasta OR @UltimoLoginFechaHasta IS NULL)
						AND (U.FechaDeExpiracionCookie >= @FechaDeExpiracionCookieDesde OR @FechaDeExpiracionCookieDesde IS NULL)
						AND (U.FechaDeExpiracionCookie <= @FechaDeExpiracionCookieHasta OR @FechaDeExpiracionCookieHasta IS NULL)
						--AND (U.ActorId = @ActorId OR @ActorId = '-1') -- FiltroDDL (FK)
						
						AND (U.SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OR @SeMuestraEnAsignacionDeRoles IS NULL)
				
						AND
						(
							(@Filtro = '')
							OR (U.UserName LIKE '%' + @Filtro + '%')
							--OR (U.Pass LIKE '%' + @Filtro + '%')
							OR (U.Nombre LIKE '%' + @Filtro + '%')
							OR (U.Apellido LIKE '%' + @Filtro + '%')
							OR (U.Email LIKE '%' + @Filtro + '%')
							--OR (U.Email2 LIKE '%' + @Filtro + '%')
							OR (U.Telefono LIKE '%' + @Filtro + '%')
							--OR (U.Telefono2 LIKE '%' + @Filtro + '%')
							--OR (U.Direccion LIKE '%' + @Filtro + '%')
							--OR (U.UltimoLoginFecha LIKE '%' + @Filtro + '%')
							--OR (U.AuthCookie LIKE '%' + @Filtro + '%')
							--OR (U.FechaDeExpiracionCookie LIKE '%' + @Filtro + '%')
							--OR (ACT.Nombre LIKE '%' + @Filtro + '%')
						)
			) Query
 
			SELECT *
			FROM  #TempTable
			WHERE (@RegistrosPorPagina = '-1') -- Sin Paginaci�n
				OR (NumeroDeRegistro BETWEEN ((@NumeroDePagina - 1) * @RegistrosPorPagina) + 1 AND @RegistrosPorPagina * (@NumeroDePagina)) -- Con Paginaci�n
 
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

 
 
 
IF (OBJECT_ID('usp_Usuarios__ListadoDDLoCBXL') IS NOT NULL) DROP PROCEDURE usp_Usuarios__ListadoDDLoCBXL
GO
CREATE PROCEDURE usp_Usuarios__ListadoDDLoCBXL
	 @UsuarioQueEjecutaId       INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) 
 	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
		
	,@id                                            INT = '0'	 -- Default, Si pasa un id, lo agregamos al SELECT.
	,@Filtro                                        VARCHAR(50) = ''
	,@Activo                                        BIT = '1'
 
	,@RolDeUsuarioId								INT = '-1' -- FiltroDDL (FK)
	
	--,@ActorId                                       INT = '-1' -- FiltroDDL (FK)
 
	,@sResSQL                                       VARCHAR(1000)	OUTPUT
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'Usuarios'
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
			
			DECLARE @SeMuestraEnAsignacionDeRoles BIT		-- Roles A Usuarios	
			EXEC usp_VAL_Usuarios__SeMuestraEnAsignacionDeRoles  -- Validamos si puede ver los roles o no.
					@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
					, @FechaDeEjecucion = @FechaDeEjecucion
					, @SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OUTPUT
		
			SELECT U.id
				,U.Apellido  + N', ' + U.Nombre   + N' - (' +  U.UserName + '@' + CX.Codigo + N')' AS Nombre
			FROM Usuarios AS U
				INNER JOIN Contextos CX ON CX.id = U.ContextoId
			WHERE 
				-- Respetar el formato del WHERE. Los "filtros" que se pasan con par�metros del modelo se agregan dentro del "OR" en una linea.
				(U.id = @id) -- Si pas� un registro particular, lo agregamos al Select (Por ejemplo en un registro que est� est� seleccionado en el DDL, pero que actualmente est� "Anulado".
				OR 
				(	
					(1 = 1) -- Es un truco para mantener el formato del WHERE y que no d� error si no hay ninguna FK y adem�s la tabla no tiene ContextoId ni Activo.
					-- Los "filtros" que se pasan con par�metros del modelo se agregan a continuaci�n:
					--AND (U.ActorId = @ActorId OR @ActorId = '-1') -- FiltroDDL (FK)
					AND (U.Activo = @Activo OR @Activo IS NULL)
					AND (U.ContextoId = @ContextoId OR @ContextoId = '-1')
				 	AND (U.id IN (SELECT UsuarioId FROM RelAsig_RolesDeUsuarios_A_Usuarios WHERE (RolDeUsuarioId = @RolDeUsuarioId OR @RolDeUsuarioId = '-1'))) -- FiltroDDL (FK)
				
					AND (U.SeMuestraEnAsignacionDeRoles = @SeMuestraEnAsignacionDeRoles OR @SeMuestraEnAsignacionDeRoles IS NULL)

				)
				AND -- Solo esta parte que involucra a @Filtro (y que corresponde a un filtrado a nivel string) va fuera del OR, ya que tambi�n afecta al registro @id: 
				(
					(@Filtro = '')
					OR (U.Apellido LIKE '%' + @Filtro + '%')
					OR (U.Nombre LIKE '%' + @Filtro + '%')
					OR (U.UserName LIKE '%' + @Filtro + '%')
					--OR (CX.Codigo LIKE '%' + @Filtro + '%')
				)
			ORDER BY U.Apellido, U.Nombre, U.UserName
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
-- SP-TABLA: Usuarios /Listados Particulares/ - FIN


-- ---------------------------------
-- Script: DB_ParticularCore__C12b_Listados Particulares.sql - FIN
-- =====================================================
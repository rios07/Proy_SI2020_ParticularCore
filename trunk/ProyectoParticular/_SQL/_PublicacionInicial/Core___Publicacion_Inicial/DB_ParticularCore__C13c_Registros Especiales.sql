	-- =====================================================
-- Descripción: Registros Especiales.sql
-- Script: DB_ParticularCore__C13c_Registros Especiales.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO

		-- Tablas Involucradas: - INICIO
			-- ExtensionesDeArchivos
			-- LogLoginsDeDispositivos
		-- Tablas Involucradas: - FIN


-- SP-TABLA: ExtensionesDeArchivos /Registros Especiales/ - INICIO
IF (OBJECT_ID('usp_ExtensionesDeArchivos__id_by_@nombre') IS NOT NULL) DROP PROCEDURE usp_ExtensionesDeArchivos__id_by_@nombre
GO
CREATE PROCEDURE usp_ExtensionesDeArchivos__id_by_@nombre
	@UsuarioQueEjecutaId		INT
	,@FechaDeEjecucion			DATETIME 
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
	
	,@Nombre					VARCHAR(8)
	
	,@id						INT	OUTPUT
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
			SELECT @id = id FROM ExtensionesDeArchivos WHERE Nombre = LOWER(@Nombre)
					
			IF @id IS NULL
				BEGIN -- La inserto, y me devuelve el id
					EXEC usp_ExtensionesDeArchivos__Insert  
							@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
							,@FechaDeEjecucion = @FechaDeEjecucion
							,@Token = @Token
							,@Seccion = @Seccion
							,@CodigoDelContexto = @CodigoDelContexto
							,@Nombre = @Nombre
							,@IconoId = '1' -- El q es by default
							,@TipoDeArchivoId = '1' -- Default: "-Sin indicar-"
							,@ProgramaAsociado = ''
							,@Observaciones	= ''
							,@sResSQL = @sResSQL OUTPUT
							,@id = @id OUTPUT
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
-- SP-TABLA: ExtensionesDeArchivos /Registros Especiales/ - FIN




-- SP-TABLA: LogLoginsDeDispositivos /Registros Especiales/ - FIN
IF (OBJECT_ID('usp_LogLoginsDeDispositivos__Campos_by_@Token') IS NOT NULL) DROP PROCEDURE usp_LogLoginsDeDispositivos__Campos_by_@Token
GO
CREATE PROCEDURE usp_LogLoginsDeDispositivos__Campos_by_@Token
	@UsuarioQueEjecutaId        INT
	,@FechaDeEjecucion          DATETIME
	,@Token                     VARCHAR(40) 
	,@Seccion					VARCHAR(30) 
	,@CodigoDelContexto			VARCHAR(40)
							
	
	-- NO SE PERMITE ANÓNIMAMENTE: ,@CodigoDelContexto				VARCHAR(40) = '' -- Es necesario pasarlo para saber donde realizar la operación cuando es Anónima a travéz del Admin "Anonimo".
	
	,@sResSQL					VARCHAR(1000)			OUTPUT 
AS
BEGIN TRY
	DECLARE @Tabla VARCHAR(80) = 'LogLoginsDeDispositivos'
		,@FuncionDePagina VARCHAR(30) = 'Registro' + COALESCE(@Token, '')
		,@AutorizadoA VARCHAR(30) = 'CargarLaPagina'
		,@SP VARCHAR(80) = OBJECT_NAME(@@PROCID)
		
	EXEC usp_Permisos__AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto
			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP 
			--, @RegistroId = @id 
			--, @UsuarioId = @UsuarioId OUTPUT 
			, @sResSQL = @sResSQL OUTPUT
		
	IF @sResSQL = ''
		BEGIN		
			SELECT LD.Token
				,LD.UsuarioId
				,LD.DispositivoId
				,LD.InicioValides
				,LD.FinValidez
				,D.MachineName
			FROM LogLoginsDeDispositivos LD
				INNER JOIN Dispositivos D ON D.id = LD.DispositivoId
			WHERE		
				(LD.Token =  @Token )
			SET @sResSQL = ''
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
-- SP-TABLA: LogLoginsDeDispositivos /Registros Especiales/ - FIN


-- ---------------------------------
-- Script: DB_ParticularCore__C13c_Registros Especiales.sql - FIN
-- =====================================================
-- =====================================================
-- Descripción: Testing
-- Script: DB_ParticularCore__C23__Tests_Recorrerdor.sql - INICIO
-- =====================================================

DECLARE @UsuarioQueEjecutaId		INT
		,@FechaDeEjecucion          DATETIME
		
		,@PaginaId					INT
		
		,@RolesIdsONombresString	VARCHAR(MAX) = '1, 3  ,  315,3'
		--,@RolesIdsONombresString	VARCHAR(MAX) = 'Operador Avanzado,ADMINISTRADOR,Operador,MASTER-ADMIN'
		
	
	, @RolDeUsuarioId INT
		,@VarcharRolDeUsuario VARCHAR(MAX)
		,@lnuPosComa INT

	WHILE LEN(@RolesIdsONombresString) > 0 
	BEGIN

		SET @lnuPosComa = CHARINDEX(',', @RolesIdsONombresString) -- Buscamos el caracter separador
		IF @lnuPosComa = '0'
		BEGIN
			SET @VarcharRolDeUsuario = @RolesIdsONombresString
			SET @RolesIdsONombresString = ''
		END
		ELSE
		BEGIN
			SET @VarcharRolDeUsuario = Substring(@RolesIdsONombresString, 1  ,@lnuPosComa - 1)
			SET @RolesIdsONombresString = Substring(@RolesIdsONombresString , @lnuPosComa + 1 , LEN(@RolesIdsONombresString))
		END
		
		IF ISNUMERIC(@VarcharRolDeUsuario) = '1'
			BEGIN
				SET @RolDeUsuarioId = (SELECT id FROM RolesDeUsuarios WHERE id = @VarcharRolDeUsuario) -- Con esto, además se valida q sea un id q existe // CAST(@VarcharRolDeUsuario AS INT)
			END
		ELSE
			BEGIN
				SET @RolDeUsuarioId = (SELECT id FROM RolesDeUsuarios WHERE Nombre = @VarcharRolDeUsuario)
			END

		PRINT @RolDeUsuarioId
	END
	
	
-- ---------------------------
-- Script: DB_ParticularCore__C23__Tests_Recorrerdor.sql - FIN
-- =====================================================
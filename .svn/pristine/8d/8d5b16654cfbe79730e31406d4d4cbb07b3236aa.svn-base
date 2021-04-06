-- =====================================================
-- Descripción: Funciones
-- Script: DB_ParticularCore__C06a_Funciones.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO

		-- Areas Involucradas: - INICIO
				-- Aritmeticas
				-- Cifrado
				-- Contextos
				-- DDLs
				-- Fechas
				-- HTML
				-- Monedas
				-- Numeros
				-- Registros
				-- Secciones
				-- Strings
				-- SPs
				-- Ubicaciones
		-- Areas Involucradas: - FIN


-- Aritmeticas /Funciones/ - INICIO
IF (OBJECT_ID('ufc_Aritmeticas__GetTRUE_SiEsMayorQueUNO') IS NOT NULL) DROP FUNCTION ufc_Aritmeticas__GetTRUE_SiEsMayorQueUNO
GO
CREATE FUNCTION ufc_Aritmeticas__GetTRUE_SiEsMayorQueUNO
	(@id INT)
	
RETURNS BIT
	
AS
BEGIN
	DECLARE @sResSQL AS BIT
	IF @id > 1
		BEGIN
			SET @sResSQL = 0				
		END
	ELSE
		BEGIN
			SET @sResSQL = 1
		END
	--ENDIF
	
	RETURN @sResSQL
END
GO
-- Aritmeticas /Funciones/ - FIN




-- Cifrado /Funciones/ - INICIO
IF (OBJECT_ID('ufc_Cifrado__GenerarMD5') IS NOT NULL) DROP FUNCTION ufc_Cifrado__GenerarMD5
GO
CREATE FUNCTION ufc_Cifrado__GenerarMD5
	(
		@Pwd		VARCHAR(100)
	)
RETURNS VARCHAR(40)
AS
BEGIN
	RETURN SUBSTRING(master.dbo.fn_varbintohexstr(HashBytes('MD5', @Pwd)), 3, 40)
END
GO




IF (OBJECT_ID('ufc_Cifrado__GenerarSHA') IS NOT NULL) DROP FUNCTION ufc_Cifrado__GenerarSHA
GO
CREATE FUNCTION ufc_Cifrado__GenerarSHA
	(
		@Pwd		VARCHAR(100)
	)
RETURNS VARCHAR(40)
AS
BEGIN
	RETURN SUBSTRING(master.dbo.fn_varbintohexstr(HashBytes('SHA', @Pwd)), 3, 40)
END
GO




IF (OBJECT_ID('ufc_Cifrado__GenerarSHA1') IS NOT NULL) DROP FUNCTION ufc_Cifrado__GenerarSHA1
GO
CREATE FUNCTION ufc_Cifrado__GenerarSHA1
	(
		@Pwd		VARCHAR(100)
	)
RETURNS VARCHAR(40)
AS
BEGIN
	RETURN SUBSTRING(master.dbo.fn_varbintohexstr(HashBytes('SHA1', @Pwd)), 3, 40)
END
GO
-- Cifrado /Funciones/ - FIN




-- Contextos /Funciones/ - INICIO // 1ero va el de Contexto
IF (OBJECT_ID('ufc_Contextos__ContextoId') IS NOT NULL) DROP FUNCTION ufc_Contextos__ContextoId
GO
CREATE FUNCTION ufc_Contextos__ContextoId
	(
		@UsuarioId				INT
		,@Seccion				VARCHAR(30)
		,@CodigoDelContexto		VARCHAR(40)
	)
RETURNS INT
AS
BEGIN
	DECLARE @ContextoId INT 
		,@Seccion_Web VARCHAR(30)
		
	EXEC @Seccion_Web = ufc_Secciones__Web
	
	-- Anteriormente a llamar a esta funcion ya están validados todos los datos en el AutorizadoA (Usuario, Seccion, CodigoDelContexto): --> no es necesario validar nada acá.
	IF @UsuarioId = '1'
		BEGIN
			IF @Seccion = @Seccion_Web -- Para realizar esta consulta el @UsuarioQueEjecutaId debe ser el que no se puede operar Y la Seccion = 'Web'
				BEGIN
					SET @ContextoId = (SELECT id FROM Contextos WHERE Codigo = @CodigoDelContexto)
				END
		END
	ELSE -- Es un usuario válido para operar, solo resta saber cual es su contexto.
		BEGIN
			SET @ContextoId = (SELECT C.id FROM Contextos C
												INNER JOIN Usuarios U ON U.ContextoId = C.id
											WHERE U.id = @UsuarioId)
		END
		
	RETURN COALESCE(@ContextoId,  NULL, 0) -- No puede devolver nulo por que da error el SP.
END
GO




IF (OBJECT_ID('ufc_Contextos__CodigoDelContexto') IS NOT NULL) DROP FUNCTION ufc_Contextos__CodigoDelContexto
GO
CREATE FUNCTION ufc_Contextos__CodigoDelContexto
	(
		@UsuarioId				INT
	)
RETURNS VARCHAR(40)
AS
BEGIN
	DECLARE @Codigo VARCHAR(40) = (SELECT C.Codigo 
									FROM Usuarios U 
										INNER JOIN Contextos C ON U.ContextoId = C.id
									WHERE U.id = @UsuarioId
								)
	RETURN @Codigo
END
GO
-- Contextos /Funciones/ - FIN




-- DDLs /Funciones/ - INICIO
IF (OBJECT_ID('ufc_DDLs__Adds') IS NOT NULL) DROP FUNCTION ufc_DDLs__Adds
GO
CREATE FUNCTION ufc_DDLs__Adds
	--	@Formato_Listado =0	: Rearmar 'Seleccionar'
		--		 =1	: "Tabla Entera"
		--		 =2	: "Sin el 0"
		--		 =-1: Con 'Todos' Sin 'Seleccionar'
		--		 =-2: Rearmar 'Seleccionar' y ADD 'Todos'
		--		 =-3: Rearmar 'Seleccionar' ID=-2
	(@Formato_Listado INT)
	
	RETURNS @IDs TABLE
		(
			id			INT
			,Codigo		VARCHAR(2)
			,Data		VARCHAR(50)
		)
AS
BEGIN
	IF @Formato_Listado = '-2'
		BEGIN
			INSERT @IDs
			SELECT	 '0' AS id
					,'0' AS Codigo
					,' - Seleccionar - ' AS Data
					
			UNION
			
			SELECT	 '-1' AS id
					,'-1' AS Codigo
					,' - Todos - ' AS Data
		END
	ELSE
		IF @Formato_Listado = '-1'
			BEGIN
				INSERT @IDs
				SELECT	 '-1' AS id
						,'-1' AS Codigo
						,' - Todos - ' AS Data
			END
		ELSE
			IF @Formato_Listado = '0'
				BEGIN
					INSERT @IDs
					SELECT	 '0' AS id
							,'0' AS Codigo
							,' - Seleccionar - ' AS Data
				END
			ELSE
				IF @Formato_Listado = '-3'
					BEGIN
						INSERT @IDs
						SELECT	 '-2' AS id
								,'-2' AS Codigo
								,' - Seleccionar - ' AS Data
					END
				ELSE
					IF @Formato_Listado = '3'
						BEGIN
							INSERT @IDs
							SELECT	 '-1' AS id
									,'-1' AS Codigo
									,' - Todos - ' AS Data
						END
					ELSE
						IF @Formato_Listado = '-4'
							BEGIN
								INSERT @IDs
								SELECT	 '-2' AS id
										,'-2' AS Codigo
										,' - Todos - ' AS Data
							END
		--ENDIF
	--ENDIF

	RETURN
END
GO




IF (OBJECT_ID('ufc_DDLs__MinimoId') IS NOT NULL) DROP FUNCTION ufc_DDLs__MinimoId
GO
CREATE FUNCTION ufc_DDLs__MinimoId
	-- 	@Formato_Listado =0	: Rearmar 'Seleccionar'
		--		 =1	: "Tabla Entera"
		--		 =2	: "Sin el 0"
		--		 =-1: Con 'Todos' Sin 'Seleccionar'
		--		 =-2: Add 'Seleccionar' y 'Todos'

	(@Formato_Listado INT)
	RETURNS INT
	AS
	BEGIN
		RETURN CASE
			--WHEN @Formato_Listado = -1 THEN 1
			--WHEN @Formato_Listado = -2 THEN 1
			--WHEN @Formato_Listado = 0 THEN 1
			--WHEN @Formato_Listado = 1 THEN 0
			--WHEN @Formato_Listado = 2 THEN 1
			--ELSE 0
		WHEN @Formato_Listado = 1 OR @Formato_Listado = -3 OR @Formato_Listado = 3  THEN 0
		ELSE	1
		END
	END
GO
-- DDLs /Funciones/ - FIN




-- Fechas /Funciones/ - INICIO
IF (OBJECT_ID('ufc_Fechas__FormatoFechaComoTexto') IS NOT NULL) DROP FUNCTION ufc_Fechas__FormatoFechaComoTexto
GO
CREATE FUNCTION ufc_Fechas__FormatoFechaComoTexto
	(
		@FechaYHora				DATETIME
	)
	RETURNS VARCHAR(30)
	AS
	BEGIN
		DECLARE @FechaComoTexto VARCHAR(30)
			,@Tiempo AS TIME
		--https://www.sqlshack.com/es/funciones-y-formatos-de-sql-convert-date/
		
		--Style 	How it’s displayed
		--101 	mm/dd/yyyy
		--102 	yyyy.mm.dd
		--103 	dd/mm/yyyy
		--104 	dd.mm.yyyy
		--105 	dd-mm-yyyy
		--110 	mm-dd-yyyy
		--111 	yyyy/mm/dd
		--106 	dd mon yyyy
		--107 	Mon dd, yyyy
		
		SET @FechaComoTexto = CONVERT(VARCHAR(10), @FechaYHora, 103) -- Solo DATE
		
		SET @Tiempo = @FechaYHora -- Me quedo solo con el tiempo
		
		IF @Tiempo > '00:00:00.0000000' -- Entonces es Fecha y Hora:
			BEGIN
				SET @FechaComoTexto = @FechaComoTexto + ' - ' + CONVERT(VARCHAR(5), @Tiempo) -- Es DATETIME
			END
			
		RETURN @FechaComoTexto --@FechaComoTexto
	END
GO




--IF (OBJECT_ID('ufc_Fechas__FormatoFechaYHoraComoTexto') IS NOT NULL) DROP FUNCTION ufc_Fechas__FormatoFechaYHoraComoTexto
--GO
--CREATE FUNCTION ufc_Fechas__FormatoFechaYHoraComoTexto
--	(
--		@Fecha				DATETIME
--	)
--	RETURNS VARCHAR(30) --22
--	AS
--	BEGIN
--		--https://www.sqlshack.com/es/funciones-y-formatos-de-sql-convert-date/
		
--		RETURN CONVERT(VARCHAR(10), @Fecha, 103) + ' - ' + RIGHT(CONVERT(VARCHAR(32),@Fecha,108),8)
		
--		--RETURN CONVERT(VARCHAR(10), @Fecha, 103) + ' - ' + RIGHT(CONVERT(VARCHAR(32),@Fecha,108),5)
		
--		--RETURN LEFT(DATENAME(WEEKDAY,@Fecha),3) + ' ' + CONVERT(VARCHAR(10),@Fecha,105)
--	END
--GO
-- Fechas /Funciones/ - FIN




-- HTML /Funciones/ - INICIO
IF (OBJECT_ID('ufc_HTML__ConvertirAVarchar') IS NOT NULL) DROP FUNCTION ufc_HTML__ConvertirAVarchar
GO
CREATE FUNCTION ufc_HTML__ConvertirAVarchar
	(
		@TextoHTML VARCHAR (MAX)
	)
	RETURNS VARCHAR(MAX) AS
	
	BEGIN 
		IF @TextoHTML IS NOT NULL
			BEGIN
				DECLARE @Inicio INT
				DECLARE @Fin INT
				DECLARE @Largo INT
				
				SET @Inicio = CHARINDEX('<',@TextoHTML)
				SET @Fin = CHARINDEX('>',@TextoHTML,CHARINDEX('<',@TextoHTML))
				SET @Largo = (@Fin - @Inicio) + 1
				
				WHILE @Inicio > 0 AND @Fin > 0 AND @Largo > 0
					BEGIN -- SE QUITAN LOS TAGS
						SET @TextoHTML = STUFF(@TextoHTML,@Inicio,@Largo,'')
						SET @Inicio = CHARINDEX('<',@TextoHTML)
						SET @Fin = CHARINDEX('>',@TextoHTML,CHARINDEX('<',@TextoHTML))
						SET @Largo = (@Fin - @Inicio) + 1
					END
			END
	   
	   IF @TextoHTML IS NOT NULL
			BEGIN   -- SE MODIFICAN LETRAS CON ACENTO
				SELECT @TextoHTML =  replace (@TextoHTML, ('&Aacute;' COLLATE Latin1_General_CS_AS) , 'Á')
				SELECT @TextoHTML =  replace (@TextoHTML, ('&aacute;' COLLATE Latin1_General_CS_AS) , 'á')
				SELECT @TextoHTML =  replace (@TextoHTML, ('&Eacute;' COLLATE Latin1_General_CS_AS) , 'É')
				SELECT @TextoHTML =  replace (@TextoHTML, ('&eacute;' COLLATE Latin1_General_CS_AS) , 'é')
				SELECT @TextoHTML =  replace (@TextoHTML, ('&Iacute;' COLLATE Latin1_General_CS_AS) , 'Í')
				SELECT @TextoHTML =  replace (@TextoHTML, ('&iacute;' COLLATE Latin1_General_CS_AS) , 'í')
				SELECT @TextoHTML =  replace (@TextoHTML, ('&Oacute;' COLLATE Latin1_General_CS_AS) , 'Ó')
				SELECT @TextoHTML =  replace (@TextoHTML, ('&oacute;' COLLATE Latin1_General_CS_AS) , 'ó')
				SELECT @TextoHTML =  replace (@TextoHTML, ('&Uacute;' COLLATE Latin1_General_CS_AS) , 'Ú')
				SELECT @TextoHTML =  replace (@TextoHTML, ('&uacute;' COLLATE Latin1_General_CS_AS), 'ú')
				SELECT @TextoHTML =  replace (@TextoHTML, 'o&nbsp;' , '')
				SELECT @TextoHTML =  replace (@TextoHTML, '&nbsp;' , '')
				SELECT @TextoHTML =  replace (@TextoHTML, '&ldquo;' , '"')
				SELECT @TextoHTML =  replace (@TextoHTML, '&rdquo;' , '"')
				SELECT @TextoHTML =  replace (@TextoHTML, '&iquest;' , '¿')
				SELECT @TextoHTML =  replace (@TextoHTML, '&ordm;' , '°')		  
			END	
		RETURN @TextoHTML		      
	END
GO
-- HTML /Funciones/ - FIN




-- Monedas /Funciones/ - INICIO
IF (OBJECT_ID('ufc_Monedas__DecimalADolar') IS NOT NULL) DROP FUNCTION ufc_Monedas__DecimalADolar
GO
CREATE FUNCTION ufc_Monedas__DecimalADolar
	(
		@Valor		DECIMAL(19,2) -- PRESTAR ATENCIÓN QUE LO FORMATEA DE ENTRADA !!!
	)
RETURNS VARCHAR(MAX)
AS
BEGIN
	RETURN 'U$ ' + CONVERT(VARCHAR, CAST(@Valor AS MONEY), 1) 
END
GO




IF (OBJECT_ID('ufc_Monedas__DecimalAPesoArgentino') IS NOT NULL) DROP FUNCTION ufc_Monedas__DecimalAPesoArgentino
GO
CREATE FUNCTION ufc_Monedas__DecimalAPesoArgentino
	(
		@Valor		DECIMAL(19,2) -- PRESTAR ATENCIÓN QUE LO FORMATEA DE ENTRADA !!!
	)
RETURNS VARCHAR(MAX)
AS
BEGIN
	-- El convert entrega el numero en formato Yankee --> Ej:  13,000.50; Pero lo necesitamos en formato Arg --> 13.000,50 (Y tenemos que hacer un replace inicial a "-" para que no queden iguales puntos y comas.
	RETURN '$ ' + REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR, CAST(@Valor AS MONEY), 1) , '.', '-'), ',', '.'), '-', ',')
END
GO
-- Monedas /Funciones/ - FIN




-- Monedas /Funciones/ - INICIO
IF (OBJECT_ID('ufc_Numeros__PorcentajeFormateado') IS NOT NULL) DROP FUNCTION ufc_Numeros__PorcentajeFormateado
GO
CREATE FUNCTION ufc_Numeros__PorcentajeFormateado
	(
		@Valor		DECIMAL(5,4) -- PRESTAR ATENCIÓN QUE LO FORMATEA DE ENTRADA !!!
	)
RETURNS VARCHAR(MAX)
AS
BEGIN
	RETURN REPLACE(CAST(CAST(100 * @Valor AS DECIMAL(5,2)) AS VARCHAR), '.', ',') + '%'
END
GO
-- Monedas /Funciones/ - FIN




-- Registros /Funciones/ - INICIO
IF (OBJECT_ID('ufc_Registros__ValorSiguiente') IS NOT NULL) DROP FUNCTION ufc_Registros__ValorSiguiente
GO
CREATE FUNCTION ufc_Registros__ValorSiguiente
		(
			@Tabla			VARCHAR(100)
			,@Campo			NVARCHAR(100) = 'Numero' -- Opcional, campo por defecto
			,@ContextoId	INT = '-1' -- Opcional, valor por defecto que omite el contexto
		)
		RETURNS INT
	AS
	BEGIN
		DECLARE	@NumAnterior INT
		DECLARE @SQLString NVARCHAR(1000)
		DECLARE @ParmDefinition NVARCHAR(1000)
		DECLARE @MaxOUT INT
		
		IF (@ContextoId	= '-1')
			BEGIN
				SET @SQLString = N'SELECT @MaxOUT = MAX(' + @Campo + ') FROM ' + @Tabla
			END
		ELSE
			BEGIN
				SET @SQLString = N'SELECT @MaxOUT = MAX(' + @Campo + ') FROM ' + @Tabla + ' WHERE ContextoId = ' + CAST(@ContextoId AS VARCHAR(MAX))
			END
		
		SET @ParmDefinition = N'@MaxOUT INT OUTPUT'
		EXECUTE sp_executesql @SQLString, @ParmDefinition, @MaxOUT = @MaxOUT OUTPUT
		
		IF @MaxOUT > 0  -- O sea, no es el 1ero
			BEGIN       
				SET @NumAnterior = @MaxOUT
     		END
		ELSE
			BEGIN 
				SET @NumAnterior = 0 --Es el primero 
			END
		
		RETURN @NumAnterior + 1
	END
GO
-- Registros /Funciones/ - FIN




-- Secciones /Funciones/ - INICIO
IF (OBJECT_ID('ufc_Secciones__SeccionIdCorrespondiente') IS NOT NULL) DROP FUNCTION ufc_Secciones__SeccionIdCorrespondiente
GO
CREATE FUNCTION ufc_Secciones__SeccionIdCorrespondiente
	-- Validaciones:
		-- 
	-------------
	-- Acotaciones:
		-- Devolverá la SeccionId Que le corresponda a la "Página" indicada por @TablaId y la Función de Página corespondiente al Registro (Que es donde linkeará la notificación).
	-------------
	(
		@Tabla	VARCHAR(80)
	)
	RETURNS INT
	AS
	BEGIN
		DECLARE @FuncionDePagina VARCHAR(30) = 'Registro'
			,@SeccionId INT
			,@PaginaId INT
		
		-- 1ero vamos con la Intranet	
		SET @PaginaId  = (SELECT id FROM Paginas WHERE SeccionId = (SELECT id FROM Secciones WHERE Nombre = dbo.ufc_Secciones__Intranet())
														AND TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla)
														AND FuncionDePaginaId = (SELECT id FROM FuncionesDePaginas WHERE Nombre = @FuncionDePagina)
							)
			
		IF @PaginaId IS NOT NULL
			BEGIN	
				EXEC @SeccionId = dbo.ufc_Secciones__IntranetId -- SALGO CON ESTO.
			END
		
		-- 2do Miramos Administracion
		IF @PaginaId IS NULL
			BEGIN
				SET @PaginaId  = (SELECT id FROM Paginas WHERE SeccionId = (SELECT id FROM Secciones WHERE Nombre = dbo.ufc_Secciones__Administracion())
														AND TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla)
														AND FuncionDePaginaId = (SELECT id FROM FuncionesDePaginas WHERE Nombre = @FuncionDePagina)
							)
				
				IF @PaginaId IS NOT NULL
					BEGIN	
						EXEC @SeccionId = dbo.ufc_Secciones__AdministracionId -- SALGO CON ESTO.
					END
			END
		
		-- 3ro Miramos PrivadaDelUsuario
		IF @PaginaId IS NULL
			BEGIN
				SET @PaginaId  = (SELECT id FROM Paginas WHERE SeccionId = (SELECT id FROM Secciones WHERE Nombre = dbo.ufc_Secciones__PrivadaDelUsuario())
														AND TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla)
														AND FuncionDePaginaId = (SELECT id FROM FuncionesDePaginas WHERE Nombre = @FuncionDePagina)
							) 
				
				IF @PaginaId IS NOT NULL
					BEGIN	
						EXEC @SeccionId = dbo.ufc_Secciones__PrivadaDelUsuarioId -- SALGO CON ESTO.
					END
			END
			
		-- 4to Miramos Web
		IF @PaginaId IS NULL
			BEGIN
				SET @PaginaId  = (SELECT id FROM Paginas WHERE SeccionId = (SELECT id FROM Secciones WHERE Nombre = dbo.ufc_Secciones__Web())
														AND TablaId = (SELECT id FROM Tablas WHERE Nombre = @Tabla)
														AND FuncionDePaginaId = (SELECT id FROM FuncionesDePaginas WHERE Nombre = @FuncionDePagina)
							)
				
				IF @PaginaId IS NOT NULL
					BEGIN	
						EXEC @SeccionId = dbo.ufc_Secciones__WebId -- SALGO CON ESTO.
					END
			END	
			
		RETURN @SeccionId -- Si la pagina no existe --> saldra la @SeccionId = NULL
	END
GO
-- Secciones /Funciones/ - FIN




-- Strings /Funciones/ - INICIO
IF (OBJECT_ID('ufc_Strings__CantidadDeElementos') IS NOT NULL) DROP FUNCTION ufc_Strings__CantidadDeElementos
GO
CREATE FUNCTION ufc_Strings__CantidadDeElementos
	(
	   @Lista      NVARCHAR(MAX)
	)
RETURNS INT
	AS
	BEGIN
		DECLARE @Position INT
			,@Cantidad INT = 0
			--,@Strings TABLE		(valor NVARCHAR(255))
			
		SET @Lista = REPLACE(@Lista, ' ', '') -- Primero le quito los espacios
			
		WHILE LEN(@Lista) > 0
		BEGIN
			SET @Position = CHARINDEX(',', @Lista)
			--SET @Position = CHARINDEX(@Delimitador, @Lista)
			IF @Position > 0
				BEGIN
					--INSERT @Strings
					--SELECT LEFT(@Lista, @Position - 1)
					SET @Lista = RIGHT(@Lista, LEN(@Lista) - @Position)
				END --ENDIF
			ELSE
				BEGIN
					--INSERT @Strings
					--SELECT @Lista
					SET @Lista = ''
				END --ENDIF
				
			SET @Cantidad = @Cantidad + 1
		END
		
		RETURN @Cantidad
	END
GO




IF (OBJECT_ID('ufc_Strings__ConvertirATabla') IS NOT NULL) DROP FUNCTION ufc_Strings__ConvertirATabla
GO
CREATE FUNCTION ufc_Strings__ConvertirATabla
	(
	   @Lista      NVARCHAR(MAX)
	   --,@Delimitador NVARCHAR(255) = ','
	)
RETURNS @Strings TABLE
		(valor NVARCHAR(255))
	AS
	BEGIN
		SET @Lista = REPLACE(@Lista, ' ', '') -- Primero le quito los espacios
		DECLARE @Position INT
		WHILE LEN(@Lista) > 0
		BEGIN
			SET @Position = CHARINDEX(',', @Lista)
			--SET @Position = CHARINDEX(@Delimitador, @Lista)
			IF @Position > 0
				BEGIN
					INSERT @Strings
					SELECT LEFT(@Lista, @Position - 1)
					SET @Lista = RIGHT(@Lista, LEN(@Lista) - @Position)
				END --ENDIF
			ELSE
				BEGIN
					INSERT @Strings
					SELECT @Lista
					SET @Lista = ''
				END --ENDIF
		END
		
		RETURN
	END
GO




IF (OBJECT_ID('ufc_Strings__ConvertirIdsString_ToTable_INT') IS NOT NULL) DROP FUNCTION ufc_Strings__ConvertirIdsString_ToTable_INT
GO
CREATE FUNCTION ufc_Strings__ConvertirIdsString_ToTable_INT
		(@IdsString				VARCHAR(MAX))
		
	RETURNS @IDs TABLE
		(id INT)
	AS
	BEGIN
		SET @IdsString = REPLACE(@IdsString, ' ', '') -- Primero le quito los espacios
		DECLARE @Position INT
		WHILE LEN(@IdsString) > 0
		BEGIN
			SET @Position = CHARINDEX(',', @IdsString)
			IF @Position > 0
				BEGIN
					INSERT @IDs
					SELECT CONVERT(INT, LEFT(@IdsString, @Position - 1))
					SET @IdsString = RIGHT(@IdsString, LEN(@IdsString) - @Position)
				END --ENDIF
			ELSE
				BEGIN
					INSERT @IDs
					SELECT CONVERT(INT, @IdsString)
					SET @IdsString = ''
				END --ENDIF
		END
		
		RETURN
	END
GO




IF (OBJECT_ID('ufc_Strings__ConvertirIdsString_ToTable_INT_ConIndice') IS NOT NULL) DROP FUNCTION ufc_Strings__ConvertirIdsString_ToTable_INT_ConIndice
GO
CREATE FUNCTION ufc_Strings__ConvertirIdsString_ToTable_INT_ConIndice
		(@IdsString				VARCHAR(MAX))
		
	RETURNS @IDs TABLE
		(Indice INT IDENTITY(1,1), id INT)
	AS
	BEGIN
		SET @IdsString = REPLACE(@IdsString, ' ', '') -- Primero le quito los espacios
		DECLARE @Position INT
		WHILE LEN(@IdsString) > 0
		BEGIN
			SET @Position = CHARINDEX(',', @IdsString)
			IF @Position > 0
				BEGIN
					INSERT @IDs
					SELECT CONVERT(INT, LEFT(@IdsString, @Position - 1))
					SET @IdsString = RIGHT(@IdsString, LEN(@IdsString) - @Position)
				END --ENDIF
			ELSE
				BEGIN
					INSERT @IDs
					SELECT CONVERT(INT, @IdsString)
					SET @IdsString = ''
				END --ENDIF
		END
		
		RETURN
	END
GO




IF (OBJECT_ID('ufc_Strings__ConvertirIdsString_ToTable_CHAR') IS NOT NULL) DROP FUNCTION ufc_Strings__ConvertirIdsString_ToTable_CHAR
GO
CREATE FUNCTION ufc_Strings__ConvertirIdsString_ToTable_CHAR
		(@IdsString				VARCHAR(MAX))
		
	RETURNS @Codigos TABLE
		(Codigo CHAR(2))
	AS
	BEGIN
		DECLARE @Position INT
		WHILE LEN(@IdsString) > 0
		BEGIN
			SET @Position = CHARINDEX(',', @IdsString)
			IF @Position > 0
				BEGIN
					INSERT @Codigos
					SELECT CONVERT(CHAR(2), left(@IdsString, @Position - 1))
					SET @IdsString = right(@IdsString, len(@IdsString) - @Position)
				END --ENDIF
			ELSE
				BEGIN
					INSERT @Codigos
					SELECT CONVERT(CHAR(2), @IdsString)
					SET @IdsString = ''
				END --ENDIF
		END
		
		RETURN
	END
GO
-- Strings /Funciones/ - FIN



 
-- SPs /Funciones/ - INICIO 
IF (OBJECT_ID('ufc_SPs__GeneracionDeNotificacionesHabilitada') IS NOT NULL) DROP FUNCTION ufc_SPs__GeneracionDeNotificacionesHabilitada
GO
CREATE FUNCTION ufc_SPs__GeneracionDeNotificacionesHabilitada
	(
		@SP VARCHAR(80) -- Si NO existe el registro del SP --> devuelve '0'
	)
	RETURNS BIT
	AS
	BEGIN
		DECLARE @GeneracionDeNotificacionesHabilitada BIT
 
		SET @GeneracionDeNotificacionesHabilitada = (COALESCE((SELECT GeneracionDeNotificacionesHabilitada 
														FROM SPs
														WHERE Nombre = @SP
														), 0)
											)
		RETURN @GeneracionDeNotificacionesHabilitada
	END
GO



 
IF (OBJECT_ID('ufc_SPs__GeneracionDeEmailHabilitada') IS NOT NULL) DROP FUNCTION ufc_SPs__GeneracionDeEmailHabilitada
GO
CREATE FUNCTION ufc_SPs__GeneracionDeEmailHabilitada
	(
		@SP VARCHAR(80) -- Si NO existe el registro del SP --> devuelve '0'
	)
	RETURNS BIT
	AS
	BEGIN
		DECLARE @GeneracionDeEmailHabilitada BIT
 
		SET @GeneracionDeEmailHabilitada = (COALESCE((SELECT GeneracionDeEmailHabilitada 
														FROM SPs
														WHERE Nombre = @SP
														), 0)
											)
		RETURN @GeneracionDeEmailHabilitada
	END
GO
-- SPs /Funciones/ - FIN




-- Ubicaciones /Funciones/ - INICIO
IF (OBJECT_ID('ufc_Ubicaciones__RootDeCarpetasDelSistema') IS NOT NULL) DROP FUNCTION ufc_Ubicaciones__RootDeCarpetasDelSistema
GO				
CREATE FUNCTION ufc_Ubicaciones__RootDeCarpetasDelSistema
	()
	RETURNS VARCHAR(100)
	AS
	BEGIN
		RETURN 'Intranet/__Contenidos/Contextos'
	END
GO




IF (OBJECT_ID('ufc_Ubicaciones__CompletaDeConenidosDeTabla') IS NOT NULL) DROP FUNCTION ufc_Ubicaciones__CompletaDeConenidosDeTabla
GO				
CREATE FUNCTION ufc_Ubicaciones__CompletaDeConenidosDeTabla
	(
		@UsuarioQueEjecutaId		INT -- Para ver su contexto
		--,@Tabla						VARCHAR(80)
		,@TablaId					INT
		
		,@Seccion					VARCHAR(30)
		,@CodigoDelContexto			VARCHAR(40)
	)
	RETURNS VARCHAR(100)
	AS
	BEGIN
		DECLARE @Root VARCHAR(100) 
		EXEC @Root = ufc_Ubicaciones__RootDeCarpetasDelSistema
		
		DECLARE @ContextoId INT
		EXEC @ContextoId = ufc_Contextos__ContextoId  
								@UsuarioId = @UsuarioQueEjecutaId
								,@Seccion = @Seccion
								,@CodigoDelContexto	= @CodigoDelContexto
		
		DECLARE @CarpetaDeContexto VARCHAR(16) = (SELECT CarpetaDeContenidos FROM Contextos WHERE id = @ContextoId)
		
		--DECLARE @CarpetaDeTabla VARCHAR(12) = (SELECT Nomenclatura FROM Tablas WHERE Nombre = @Tabla)
		DECLARE @CarpetaDeTabla VARCHAR(12) = (SELECT Nomenclatura FROM Tablas WHERE id = @TablaId)
		
		DECLARE @PathCompleto VARCHAR(100) = @Root + '/' + @CarpetaDeContexto + '/' + @CarpetaDeTabla
		
		RETURN @PathCompleto
	END
GO




IF (OBJECT_ID('ufc_Ubicaciones__RelativaCompletaDeConenidosDeTabla') IS NOT NULL) DROP FUNCTION ufc_Ubicaciones__RelativaCompletaDeConenidosDeTabla
GO				
CREATE FUNCTION ufc_Ubicaciones__RelativaCompletaDeConenidosDeTabla
	(
		@UsuarioQueEjecutaId		INT -- Para ver su contexto
		--,@Tabla						VARCHAR(80)
		,@TablaId					INT
		
		,@Seccion					VARCHAR(30)
		,@CodigoDelContexto			VARCHAR(40)
	)
	RETURNS VARCHAR(100)
	AS
	BEGIN
		DECLARE @PathCompleto VARCHAR(100)
		--EXEC @PathCompleto = ufc_Ubicaciones__CompletaDeConenidosDeTabla  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @Tabla = @Tabla
		EXEC @PathCompleto = ufc_Ubicaciones__CompletaDeConenidosDeTabla  
								@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
								,@TablaId = @TablaId
								,@Seccion = @Seccion
								,@CodigoDelContexto	= @CodigoDelContexto
		
		RETURN @PathCompleto --'~/' + @PathCompleto
	END
GO




IF (OBJECT_ID('ufc_Ubicaciones__RelativaDeIconos') IS NOT NULL) DROP FUNCTION  ufc_Ubicaciones__RelativaDeIconos
GO				
CREATE FUNCTION  ufc_Ubicaciones__RelativaDeIconos
	()
	RETURNS VARCHAR(100)
	AS
	BEGIN
		DECLARE @Root VARCHAR(100) 
		EXEC @Root = ufc_Ubicaciones__RootDeCarpetasDelSistema
		
		RETURN @Root + '/' + 'images/iconos'
	END
GO
-- Ubicaciones /Funciones/ - FIN




-- Usuarios /Funciones/ - INICIO
IF (OBJECT_ID('ufc_Usuarios__GenerarUserName_ConNApellido') IS NOT NULL) DROP FUNCTION ufc_Usuarios__GenerarUserName_ConNApellido
GO
CREATE FUNCTION ufc_Usuarios__GenerarUserName_ConNApellido
	(
		@Prefijo			VARCHAR(5)
		,@Nombre			VARCHAR(50)
		,@Apellido			VARCHAR(50)
		,@ValorAleatorio	VARCHAR(50)
	)
	RETURNS VARCHAR(40)
	AS
	BEGIN
		-- No deja ejecutar ni RAND() ni NEWID() dentro de funciones --> la paso.
		--DECLARE @Pass VARCHAR(100) = 'CambiarPWD' + CAST(ROUND(((999 - 1) * RAND() + 1), 0) AS VARCHAR(MAX))
		--DECLARE @Aleatorio varchar(50) = CONVERT(varchar(50), NEWID())
		--SET @NumAleatorio = ROUND(((999 - 1) * @NumAleatorio + 1), 0)
		
		RETURN REPLACE(LEFT(@Prefijo + SUBSTRING(@Nombre, 1, 1) + @Apellido + @ValorAleatorio, 40), ' ', '')
	END
GO




IF (OBJECT_ID('ufc_Usuarios__GenerarUserName_ConEmail') IS NOT NULL) DROP FUNCTION ufc_Usuarios__GenerarUserName_ConEmail
GO
CREATE FUNCTION ufc_Usuarios__GenerarUserName_ConEmail
	(
		@Prefijo			VARCHAR(10)
		,@Email				VARCHAR(60)
		,@Sufijo			VARCHAR(10)
	)
	RETURNS VARCHAR(40)
	AS
	BEGIN
		DECLARE @un VARCHAR(40)
		
		SET @Email = SUBSTRING(@Email, 1, charindex('@', @Email)-1)
		SET @un = @Prefijo + @Email + @Sufijo
		
		RETURN LOWER(REPLACE(@un, ' ', ''))
	END
GO




IF (OBJECT_ID('ufc_Usuarios__GenerarUserName_ConNombrePuntoApellido') IS NOT NULL) DROP FUNCTION ufc_Usuarios__GenerarUserName_ConNombrePuntoApellido
GO
CREATE FUNCTION ufc_Usuarios__GenerarUserName_ConNombrePuntoApellido
	(
		@Prefijo			VARCHAR(10)
		,@Nombre			VARCHAR(50)
		,@Apellido			VARCHAR(50)
		,@Sufijo			VARCHAR(10)
	)
	RETURNS VARCHAR(40)
	AS
	BEGIN
		RETURN REPLACE(LEFT(@Prefijo + @Nombre + '.' + @Apellido + @Sufijo, 40), ' ', '')
	END
GO




IF (OBJECT_ID('ufc_Usuarios__NombreCompletoFormateado') IS NOT NULL) DROP FUNCTION ufc_Usuarios__NombreCompletoFormateado
GO
CREATE FUNCTION ufc_Usuarios__NombreCompletoFormateado
	(
		@id		INT
	)
	RETURNS VARCHAR(100)
	AS
	BEGIN
		DECLARE @Nombre	VARCHAR(40)
			,@Apellido VARCHAR(40)
		
		SELECT @Nombre = Nombre, @Apellido = Apellido FROM Usuarios WHERE id = @id
		
		RETURN @Apellido + ', ' + @Nombre -- @Nombre + ' ' + @Apellido // Es mejor que comience co el apellido ya que al ordenar, uno espera ordenar por apellido.
	END
GO




IF (OBJECT_ID('ufc_Usuarios__NombreCompletoConUserNameFormateado') IS NOT NULL) DROP FUNCTION ufc_Usuarios__NombreCompletoConUserNameFormateado
GO
CREATE FUNCTION ufc_Usuarios__NombreCompletoConUserNameFormateado
	(
		@id		INT
	)
	RETURNS VARCHAR(100)
	AS
	BEGIN
		DECLARE @Nombre	VARCHAR(40)
			,@Apellido VARCHAR(40)
			,@UserName VARCHAR(40)
			,@CodigoDelContexto VARCHAR(40)
		
		SELECT @Nombre = U.Nombre, @Apellido = U.Apellido, @UserName = U.UserName, @CodigoDelContexto = C.Codigo
		FROM Usuarios U
			INNER JOIN Contextos C ON U.ContextoId = C.id
		WHERE U.id = @id
		
		RETURN @Apellido + ', ' + @Nombre + ' (' + @UserName + '@' + @CodigoDelContexto + ')' -- @Nombre + ' ' + @Apellido // Es mejor que comience co el apellido ya que al ordenar, uno espera ordenar por apellido.
	END
GO
-- Usuarios /Funciones/ - FIN


-- ---------------------------------
-- Script: DB_ParticularCore__C06a_Funciones.sql - FIN
-- =====================================================
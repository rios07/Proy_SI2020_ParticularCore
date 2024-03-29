-- =====================================================
-- Descripci�n: Inserta valores genericos, que no son los principales, y podr�an cambiar.
-- Script: DB_ParticularCore__C19e_Insert Values del Sistema_Genericos.sql - INICIO
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
					
					DECLARE @UsuarioQueEjecutaId INT = '1' -- OJO, q si va UsuarioId=1 -- > VA EN ContextoId=1 --> no logueable
						,@FechaDeEjecucion DATETIME = GetDate()
						,@Token                     VARCHAR(40) = 'OperacionDeCore'
 						--,@Seccion					VARCHAR(30) = @Seccion_Administracion -- Las p�ginas que se crear�n deben ir es esta secci�n.
						,@CodigoDelContexto			VARCHAR(40) = NULL
						
						,@sResSQL VARCHAR(1000)	
						,@id INT
						,@Nombre VARCHAR(80)
						,@Mensaje VARCHAR(MAX)
						,@TablaDelExec VARCHAR(80)
						--,@ContextoId_SinContexto INT = '1'
				-- Variable que utilizamos en los insert - FIN
				
				
-- INSERT VALUES: CuentasDeEnvios - INICIO
	-- Agrego un par para poder testear
	--PRINT 'Insertando CuentasDeEnvios' 
	-- Id = 1: Ya fu� insertada en Script Predecesor: 	INSERT INTO CuentasDeEnvios (Nombre, CuentaDeEmail, PwdDeEmail, Smtp, Puerto, Observaciones) VALUES ('Email para tareas', 'tareas@sistemas.com', 'XXX', 'smtp.sistemas.com', '25', 'Para los env�o de tareas.')
	--INSERT INTO CuentasDeEnvios (Nombre, CuentaDeEmail, PwdDeEmail, Smtp, Puerto, Observaciones) VALUES ('Email para ??', '??@sistemas.com', 'XXX', 'smtp.sistemas.com', '25', 'Para los env�o de ??.')
	--SELECT * FROM CuentasDeEnvios
-- INSERT VALUES: CuentasDeEnvios - FIN
			
	


-- INSERT VALUES RelAsig_CuentasDeEnvios_A_Tablas: - INICIO  (Necesitaba 1ero las Tablas)
	--PRINT 'Insertando RelAsig_CuentasDeEnvios_A_Tablas'
	--DECLARE @TablaDeTareasId AS INT = (SELECT id FROM Tablas WHERE Nombre = 'Tablas')
	
	--INSERT INTO RelAsig_CuentasDeEnvios_A_Tablas (ContextoId, CuentaDeEnvioId, TablaId) VALUES ('2', '1', @TablaDeTareasId)
	--SELECT * FROM RelAsig_CuentasDeEnvios_A_Tablas
---- INSERT VALUES RelAsig_CuentasDeEnvios_A_Tablas: - FIN




-- INSERT VALUES: TiposDeArchivos - INICIO // El valor DEFAULT ya se ingres� en el Archivo predecesor.
	PRINT 'Insertando TiposDeArchivos'
	-- No se define a nivel de formato (PDF, Excel, Word, etc), si no a nivel de tipo (Cad, office, Im�gen, etc).
	INSERT INTO TiposDeArchivos (Nombre, Observaciones) VALUES ('CAD', 'Archivo de Cad.')
	INSERT INTO TiposDeArchivos (Nombre, Observaciones) VALUES ('Documento Editable', 'Archivo de documentacion.')
	INSERT INTO TiposDeArchivos (Nombre, Observaciones) VALUES ('Documento No Editable', 'Archivo de documentacion.')
	INSERT INTO TiposDeArchivos (Nombre, Observaciones) VALUES ('C�lculo', 'Archivo de Hoja de C�lculo.')
	INSERT INTO TiposDeArchivos (Nombre, Observaciones) VALUES ('Im�gen', 'Archivo de Im�gen.')
	SELECT * FROM TiposDeArchivos
-- INSERT VALUES: TiposDeArchivos - FIN




-- INSERT VALUES: Ubicaciones - INICIO
	--PRINT 'Insertando Ubicaciones'
	--INSERT INTO Ubicaciones (Nombre, Observaciones, UbicacionAbsoluta) VALUES ('Intranet/__Contenidos/Contextos/', 'Es el root de todo', 0) -- id=1: Root del sitio
	--SELECT * FROM Ubicaciones
-- INSERT VALUES: TiposDeLogLogins - FIN




-- INSERT VALUES: Iconos - INICIO
	SET @TablaDelExec = 'Iconos'
	PRINT 'Insertando sobre la tabla: ' + @TablaDelExec
			
	----id=1: // EL DEFAULT YA LO INSERT� EN EL SCRIPT PREDECESOR
	--EXEC usp_Iconos__Insert @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion
	--	,@Nombre = 'Default'
	--	,@Imagen = 'default.png'
	--	,@Altura = '22'
	--	,@Ancho	= '22'
	--	,@OffsetX = '0'
	--	,@OffsetY = '0'
	--	,@Observaciones	= 'Archivo por defecto para todos los no reconocidos o indicados.'
	--	,@sResSQL = @sResSQL OUTPUT
	--	,@id = @id OUTPUT
	--	SELECT 'Tabla Iconos - id = ' + CAST(@id AS VARCHAR(MAX))  -- De la tabla insertada

	
	SET @Nombre = 'Word'
	EXEC usp_Iconos__Insert 
			@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
			,@FechaDeEjecucion = @FechaDeEjecucion
			,@Token = @Token 
			,@Seccion = @Seccion_Administracion 
			,@CodigoDelContexto = @CodigoDelContexto 
			,@Nombre = @Nombre
			,@Imagen = 'doc.png'
			,@Altura = '22'
			,@Ancho	= '22'
			,@OffsetX = '0'
			,@OffsetY = '0'
			,@Observaciones	= 'Archivo de Word.'
			,@sResSQL = @sResSQL OUTPUT
			,@id = @id OUTPUT
			SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
			IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	SET @Nombre = 'Word X'
	EXEC usp_Iconos__Insert 
			@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
			,@FechaDeEjecucion = @FechaDeEjecucion
			,@Token = @Token 
			,@Seccion = @Seccion_Administracion 
			,@CodigoDelContexto = @CodigoDelContexto 
			,@Nombre = @Nombre
			,@Imagen = 'docx.png'
			,@Altura = '22'
			,@Ancho	= '22'
			,@OffsetX = '0'
			,@OffsetY = '0'
			,@Observaciones	= 'Archivo de Word a partir de 2007 inclusive.'
			,@sResSQL = @sResSQL OUTPUT
			,@id = @id OUTPUT
			SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
			IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	SET @Nombre = 'Excel'
	EXEC usp_Iconos__Insert 
			@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
			,@FechaDeEjecucion = @FechaDeEjecucion
			,@Token = @Token 
			,@Seccion = @Seccion_Administracion 
			,@CodigoDelContexto = @CodigoDelContexto 
			,@Nombre = @Nombre
			,@Imagen = 'xls.png'
			,@Altura = '22'
			,@Ancho	= '22'
			,@OffsetX = '0'
			,@OffsetY = '0'
			,@Observaciones	= 'Archivo de Excel.'
			,@sResSQL = @sResSQL OUTPUT
			,@id = @id OUTPUT
			SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
			IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	SET @Nombre = 'Excel X'
	EXEC usp_Iconos__Insert 
			@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
			,@FechaDeEjecucion = @FechaDeEjecucion
			,@Token = @Token 
			,@Seccion = @Seccion_Administracion 
			,@CodigoDelContexto = @CodigoDelContexto 
			,@Nombre = @Nombre
			,@Imagen = 'xlsx.png'
			,@Altura = '22'
			,@Ancho	= '22'
			,@OffsetX = '0'
			,@OffsetY = '0'
			,@Observaciones	= 'Archivo de Excel a partir de 2007 inclusive.'
			,@sResSQL = @sResSQL OUTPUT
			,@id = @id OUTPUT
			SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
			IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	SET @Nombre = 'Pdf'
	EXEC usp_Iconos__Insert 
			@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
			,@FechaDeEjecucion = @FechaDeEjecucion
			,@Token = @Token 
			,@Seccion = @Seccion_Administracion 
			,@CodigoDelContexto = @CodigoDelContexto 
			,@Nombre = @Nombre
			,@Imagen = 'pdf.png'
			,@Altura = '22'
			,@Ancho	= '22'
			,@OffsetX = '0'
			,@OffsetY = '0'
			,@Observaciones	= 'Archivo Adobe Acrobat.'
			,@sResSQL = @sResSQL OUTPUT
			,@id = @id OUTPUT
			SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
			IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
		
	SET @Nombre = 'Jpg'
	EXEC usp_Iconos__Insert 
			@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
			,@FechaDeEjecucion = @FechaDeEjecucion
			,@Token = @Token 
			,@Seccion = @Seccion_Administracion 
			,@CodigoDelContexto = @CodigoDelContexto 
			,@Nombre = @Nombre
			,@Imagen = 'jpg.png'
			,@Altura = '22'
			,@Ancho	= '22'
			,@OffsetX = '0'
			,@OffsetY = '0'
			,@Observaciones	= 'Archivo por Imagen con formato JPG.'
			,@sResSQL = @sResSQL OUTPUT
			,@id = @id OUTPUT
			SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
			IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	SELECT * FROM Iconos 
-- INSERT VALUES: Iconos - FIN




-- INSERT VALUES: ExtensionesDeArchivos - INICIO
	SET @TablaDelExec = 'ExtensionesDeArchivos'
	PRINT 'Insertando sobre la tabla: ' + @TablaDelExec
	
	DECLARE @IconoId INT
		,@TipoDeArchivoId INT

	SET @IconoId = (SELECT id FROM Iconos WHERE Nombre = 'Word')
	SET @TipoDeArchivoId = (SELECT id FROM TiposDeArchivos WHERE Nombre = 'Documento Editable')
	SET @Nombre = 'doc'
	EXEC usp_ExtensionesDeArchivos__Insert  
			@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
			,@FechaDeEjecucion = @FechaDeEjecucion
			,@Token = @Token 
			,@Seccion = @Seccion_Administracion 
			,@CodigoDelContexto = @CodigoDelContexto 
			,@Nombre = @Nombre
			,@IconoId = @IconoId
			,@TipoDeArchivoId = @TipoDeArchivoId
			,@ProgramaAsociado = ''	
			,@Observaciones	= ''
			,@sResSQL = @sResSQL OUTPUT
			,@id = @id OUTPUT
			SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
			IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
		
	SET @IconoId = (SELECT id FROM Iconos WHERE Nombre = 'Word X')
	SET @TipoDeArchivoId = (SELECT id FROM TiposDeArchivos WHERE Nombre = 'Documento Editable')
	SET @Nombre = 'docx'
	EXEC usp_ExtensionesDeArchivos__Insert 
			@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
			,@FechaDeEjecucion = @FechaDeEjecucion
			,@Token = @Token 
			,@Seccion = @Seccion_Administracion 
			,@CodigoDelContexto = @CodigoDelContexto 
			,@Nombre = @Nombre
			,@IconoId = @IconoId
			,@TipoDeArchivoId = @TipoDeArchivoId
			,@ProgramaAsociado = ''	
			,@Observaciones	= ''
			,@sResSQL = @sResSQL OUTPUT
			,@id = @id OUTPUT
			SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
			IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	SET @IconoId = (SELECT id FROM Iconos WHERE Nombre = 'Excel')
	SET @TipoDeArchivoId = (SELECT id FROM TiposDeArchivos WHERE Nombre = 'C�lculo')
	SET @Nombre = 'xls'
	EXEC usp_ExtensionesDeArchivos__Insert 
			@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
			,@FechaDeEjecucion = @FechaDeEjecucion
			,@Token = @Token 
			,@Seccion = @Seccion_Administracion 
			,@CodigoDelContexto = @CodigoDelContexto 
			,@Nombre = @Nombre
			,@IconoId = @IconoId
			,@TipoDeArchivoId = @TipoDeArchivoId
			,@ProgramaAsociado = ''	
			,@Observaciones	= ''
			,@sResSQL = @sResSQL OUTPUT
			,@id = @id OUTPUT
			SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
			IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	SET @IconoId = (SELECT id FROM Iconos WHERE Nombre = 'Excel')
	SET @TipoDeArchivoId = (SELECT id FROM TiposDeArchivos WHERE Nombre = 'C�lculo')
	SET @Nombre = 'xlsx'
	EXEC usp_ExtensionesDeArchivos__Insert 
			@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
			,@FechaDeEjecucion = @FechaDeEjecucion
			,@Token = @Token 
			,@Seccion = @Seccion_Administracion 
			,@CodigoDelContexto = @CodigoDelContexto 
			,@Nombre = @Nombre
			,@IconoId = @IconoId
			,@TipoDeArchivoId = @TipoDeArchivoId
			,@ProgramaAsociado = ''	
			,@Observaciones	= ''
			,@sResSQL = @sResSQL OUTPUT
			,@id = @id OUTPUT
			SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
			IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	SET @IconoId = (SELECT id FROM Iconos WHERE Nombre = 'Pdf')
	SET @TipoDeArchivoId = (SELECT id FROM TiposDeArchivos WHERE Nombre = 'Documento No Editable')
	SET @Nombre = 'pdf'
	EXEC usp_ExtensionesDeArchivos__Insert 
			@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
			,@FechaDeEjecucion = @FechaDeEjecucion
			,@Token = @Token 
			,@Seccion = @Seccion_Administracion 
			,@CodigoDelContexto = @CodigoDelContexto 
			,@Nombre = @Nombre
			,@IconoId = @IconoId
			,@TipoDeArchivoId = @TipoDeArchivoId
			,@ProgramaAsociado = ''	
			,@Observaciones	= ''
			,@sResSQL = @sResSQL OUTPUT
			,@id = @id OUTPUT
			SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
			IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	SET @IconoId = (SELECT id FROM Iconos WHERE Nombre = 'Jpg')
	SET @TipoDeArchivoId = (SELECT id FROM TiposDeArchivos WHERE Nombre = 'Im�gen')
	SET @Nombre = 'Jpg'
	EXEC usp_ExtensionesDeArchivos__Insert  
			@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
			,@FechaDeEjecucion = @FechaDeEjecucion
			,@Token = @Token 
			,@Seccion = @Seccion_Administracion 
			,@CodigoDelContexto = @CodigoDelContexto 
			,@Nombre = @Nombre
			,@IconoId = @IconoId
			,@TipoDeArchivoId = @TipoDeArchivoId
			,@ProgramaAsociado = ''	
			,@Observaciones	= ''
			,@sResSQL = @sResSQL OUTPUT
			,@id = @id OUTPUT
			SELECT @Mensaje = '@sResSQL=' + COALESCE(@sResSQL, '-NULL-') + ' // Tabla=' + COALESCE(@TablaDelExec, '-NULL-') + ' // RegistroNombre=' + COALESCE(@Nombre, '-NULL-') +  ' // id=' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
			IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END  
 		
	
	SELECT * FROM ExtensionesDeArchivos
-- INSERT VALUES: ExtensionesDeArchivos - FIN


-- ---------------------------
-- Script: DB_ParticularCore__C19e_Insert Values del Sistema_Genericos.sql - FIN
-- =====================================================
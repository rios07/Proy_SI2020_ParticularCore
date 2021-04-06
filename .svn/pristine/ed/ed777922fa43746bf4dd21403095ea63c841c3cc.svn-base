-- =====================================================
-- Descripción: SPs que controlan los permisos
-- Script: 201911_____ADD Seccion En los Proyectos Anteriores.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO

				-- Agregando "Seccion" al sistema:---------------------------
					-- La sección "Administracion" (id=1) es para gestionar toda la información, y por lo tanto es una sección "privada" y requiere autenticación.
					-- La seccion "Intranet" (id=2) es una parte "intermedia", donde se permite algunas pocas gestiones, para la gente autenticada.
					-- La seccion "Web" (id=3) es para todo público y entonces, no se requiere autenticación.
					-- La seccion "PrivadaDelUsuario" (id=4) es una parte donde cada usuario puede gestionar SOLO cuestiones de su perfil y ningún dato de otro usuario, y por lo tanto también requiere autenticación.
				-------------------------------------------------------------
				
				
				-- Variable que utilizamos en los insert - INICIO
					DECLARE @RolDeUsuario_SoloLogin VARCHAR(80)
						,@RolDeUsuario_Operador VARCHAR(80)
						,@RolDeUsuario_OperadorAvanzado VARCHAR(80)
						,@RolDeUsuario_Administrador VARCHAR(80)
						,@RolDeUsuario_MasterAdmin VARCHAR(80)
						,@RolDeUsuario_PedirSoportes VARCHAR(80)
						,@RolDeUsuario_AdministrarSoportes VARCHAR(80)
						,@RolDeUsuario_NotificarPorInformes VARCHAR(80)
						,@RolDeUsuario_NotificarPorUsuarios VARCHAR(80)
					
					EXEC @RolDeUsuario_SoloLogin = ufc_RolesDeUsuarios_SoloLogin
					EXEC @RolDeUsuario_Operador = ufc_RolesDeUsuarios_Operador
					EXEC @RolDeUsuario_OperadorAvanzado = ufc_RolesDeUsuarios_OperadorAvanzado
					EXEC @RolDeUsuario_Administrador = ufc_RolesDeUsuarios_Administrador
					EXEC @RolDeUsuario_MasterAdmin = ufc_RolesDeUsuarios_MasterAdmin
					EXEC @RolDeUsuario_PedirSoportes = ufc_RolesDeUsuarios_PedirSoportes
					EXEC @RolDeUsuario_AdministrarSoportes = ufc_RolesDeUsuarios_AdministrarSoportes
					EXEC @RolDeUsuario_NotificarPorInformes = ufc_RolesDeUsuarios_NotificarPorInformes
					EXEC @RolDeUsuario_NotificarPorUsuarios = ufc_RolesDeUsuarios_NotificarPorUsuarios
					
					
					DECLARE @UsuarioQueEjecutaId INT = '1' -- OJO, q si va UsuarioId=1 -- > VA EN ContextoId=1 --> no logueable
						,@FechaDeEjecucion DATETIME = GetDate()
						,@sResSQL VARCHAR(1000)	= ''
						,@id INT
						,@ContextoId_SinContexto INT
						,@TablaId INT
						,@FuncionDePaginaId INT
						,@PaginaId INT
						,@RolDeUsuarioId INT
						,@IconoGenericoCSSId INT = '1'
						--,@SaltarRegistrosExistentes BIT = '1'
						--,@RealizarUpdateSiElRegistroExiste BIT = '1'
						,@TablaDeCore BIT = '1'
						,@Nombre VARCHAR(100)
						,@Mensaje VARCHAR(MAX)
						,@TablaDelExec VARCHAR(80)
				-- Variable que utilizamos en los insert - FIN
				

-- Creamos la Tabla:
	CREATE TABLE Secciones
	(
		id									INT				NOT NULL
		,Nombre								VARCHAR(30)		NOT NULL
		,Observaciones						VARCHAR(1000)
		,CONSTRAINT PK_Secciones_Id			PRIMARY KEY CLUSTERED (id)
		,CONSTRAINT UQ_Secciones_Nombre		UNIQUE NONCLUSTERED (Nombre)
	)




-- Insertamos el registro en la tabla: Tablas
	SET @Nombre = 'Secciones' 
	EXEC [dbo].[usp_Tablas__Insert] @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion
		,@IconoCSSId = @IconoGenericoCSSId
		,@Nombre = @Nombre
		--@SaltarRegistrosExistentes	= @SaltarRegistrosExistentes 
 		--,@RealizarUpdateSiElRegistroExiste = @RealizarUpdateSiElRegistroExiste
		,@NombreAMostrar = 'Secciones'
		,@Nomenclatura = 'Secc'
		,@Observaciones	= ''
		,@LlevaActivo = '0'
		,@PermiteEliminar = '0'
		,@TablaDeCore = @TablaDeCore
		,@SeCreanPaginas = '1'
		,@TieneArchivos = '0'
		,@RolMenosPrioritarioQueCarga = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueOpera = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueVerRegAnulados = @RolDeUsuario_MasterAdmin
		,@RolMenosPrioritarioQueAccionesEspeciales = @RolDeUsuario_MasterAdmin
		,@CampoAMostrarEnFK	= 'Nombre'
		,@CamposQuePuedenSerIdsString = ''
		,@CamposAExcluirEnElInsert = ''
		,@CamposAExcluirEnElUpdate = ''
		,@SeGeneranAutoSusSPsDeABM = '1'
		,@SeGeneranAutoSusSPsDeRegistros = '1'
		,@SeGeneranAutoSusSPsDeListados = '1'
		,@sResSQL = @sResSQL OUTPUT
		,@id = @id OUTPUT
		SELECT @Mensaje = '@sResSQL = ' + @sResSQL + ' // Tabla: ' + @TablaDelExec + ' // RegistroNombre: ' + @Nombre +  ' - id = ' + COALESCE(CAST(@id AS VARCHAR(MAX)), '-NULL-')
		IF @sResSQL = '' BEGIN PRINT @Mensaje END ELSE BEGIN RAISERROR (@Mensaje, 16, 1) END 
 		
 					


-- INSERT VALUES: Secciones - INICIO
	PRINT 'Insertando Secciones'
	INSERT INTO Secciones (id, Nombre, Observaciones) VALUES ('1', 'Administracion', 'Sección de la Intranet, de administración de los datos. Se definen permisos específicos de acceso u operación en cada una de sus páginas.')
	INSERT INTO Secciones (id, Nombre, Observaciones) VALUES ('2', 'Intranet', 'Sección que ven todos los usuarios autenticados; Es una parte "intermedia", donde se realizan las operaciones de todos los días.')
	INSERT INTO Secciones (id, Nombre, Observaciones) VALUES ('3', 'Web', 'Sección pública. Única a la que se puede acceder sin autenticarse. Generalmente SOLO se permiten ingresos de solicitudes, como envíos de Cvs o comentarios.')
	INSERT INTO Secciones (id, Nombre, Observaciones) VALUES ('4', 'PrivadaDelUsuario', 'es una parte donde cada usuario puede gestionar SOLO cuestiones de su perfil y ningún dato de otro usuario.')
	SELECT * FROM Secciones
-- INSERT VALUES: Secciones - FIN




-- Agregamos los campos:
	ALTER TABLE Paginas ADD SeccionId	INT	NOT NULL DEFAULT '1' -- Inicialmente pensamos en setear todas con este defaul. Analizar !.
	ALTER TABLE LogErrores ADD Seccion	VARCHAR(30) -- Va como texto (llega directo de .net), lo cual puede ser más útil así para encontrar errores.
	GO



-- Corregimos las Páginas de la sección Intranet:
	SELECT * FROM Paginas
	UPDATE Paginas
	SET SeccionId = '2'
	WHERE CHARINDEX('ADM_', Nombre) = '0' 
	SELECT * FROM Paginas
-------------------------------------------




-- Ajustamos la Constraint:
	ALTER TABLE Paginas DROP CONSTRAINT UQ_Paginas;
	GO
	ALTER TABLE Paginas ADD CONSTRAINT UQ_Paginas	UNIQUE NONCLUSTERED (SeccionId, TablaId, FuncionDePaginaId)
	GO




-- FK:
	ALTER TABLE Paginas ADD CONSTRAINT FK_Paginas_SeccionId FOREIGN KEY (SeccionId) REFERENCES Secciones (id)
	GO

-- ---------------------------------
-- Script: 201911_____ADD Seccion En los Proyectos Anteriores.sql - FIN
-- =====================================================
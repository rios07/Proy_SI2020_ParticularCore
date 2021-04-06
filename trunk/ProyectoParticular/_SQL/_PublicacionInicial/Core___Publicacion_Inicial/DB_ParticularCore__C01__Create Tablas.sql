-- =====================================================
-- Descripci�n: Creaci�n de las TABLAS
-- Script: DB_ParticularCore__C01__Create Tablas.sql - INICIO
-- =====================================================

--DROP DATABASE DB_ParticularCore
--GO

CREATE DATABASE DB_ParticularCore
GO
ALTER DATABASE DB_ParticularCore SET RECOVERY SIMPLE
USE DB_ParticularCore
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET LANGUAGE 'Spanish';   
--GO  
EXEC sp_configure 'default language', 5 ; -- spanish (0=english).
GO
RECONFIGURE ;  
GO  	
	
------------------------------------------- Aclaraci�n: Identity(1,1) -----------------------------------------------
-- Antes ten�amos id=0 p/ algunas tablas maestras como: Contextos, FuncionesDePaginas, Paginas, Tablas, Usuarios.
-- Se usaban p/ FK de otras tablas en reemplazo de un valor NULL que nos traer�a problemas con todos los JOINs.
-- Para cuando queremos indicar "sin contexto", "sin p�gina", "sin tabla", "sin usuario" (#).
-- Esto qued� atr�s, y a partir de ahora utilizamos TODO COMENZANDO CON id=1.
-- Los casos (#) siguen valiendo, pero con id=1, y nunca se mostrar�n a un usuario de trabajo, ya que son tablas
-- que no son de acceso de los usuarios, o que pertenecen al contexto-id=1, que no ser� de acceso a los usuarios.
-- En definitiva, UTILIZAREMOS TODOS LOS CASOS id=1 PARA TODOS LOS VALORES POR DEFECTO.
---------------------------------------------------------------------------------------------------------------------
 
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
			-- RelAsig_CuentasDeEnvios_A_Tablas
			-- RelAsig_Subsistemas_A_Publicaciones
			-- RelAsig_Usuarios_A_Recursos
			-- ReservasDeRecursos
			-- RolesDeUsuarios
			-- Secciones
			-- SPs
			-- Subsistemas
			-- Tablas
			-- TablasYFuncionesDePaginas
			-- Tareas
			-- TiposDeActores
			-- TiposDeArchivos
			-- TiposDeContactos
			-- TiposDeLogLogins
			-- TiposDeOperaciones
			-- TiposDeTareas
			-- Ubicaciones
			-- Unidades
		-- Tablas Involucradas: - FIN

	
CREATE TABLE Actores
-- Cada usuarios tendr� un ActorId q indica a q grupo pertence:
-- Sistemas, Administraci�n, Compras, Ventas, Proveedores Mayoristas, Proveedores Minoristas, etc.
(
    id									INT   IDENTITY(1,1)	NOT NULL
    ,ContextoId							INT				NOT NULL
    ,TipoDeActorId						INT				NOT NULL
    ,Codigo								VARCHAR(16)		NOT NULL
    ,Nombre								VARCHAR(50)		NOT NULL
	,Email								VARCHAR(60)							
	,Email2								VARCHAR(60)							
	,Telefono							VARCHAR(60)							
	,Telefono2							VARCHAR(60)							
	,Direccion							VARCHAR(1000)						
	,Observaciones						VARCHAR(1000)						
	,Activo								BIT				NOT NULL	DEFAULT 1	
    ,CONSTRAINT PK_Actores_Id			PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_Actores_Codigo		UNIQUE NONCLUSTERED (ContextoId, Codigo)
	,CONSTRAINT UQ_Actores_Nombre		UNIQUE NONCLUSTERED (ContextoId, Nombre)
)
GO




CREATE TABLE Archivos
-- Tabla gen�rica, para ser utilizada por todas las que tengan Archivos, sean de documentos o im�genes.
-- Llevan FK a ExtensionesDeArchivos, tabla q definir� el �cono, el programa q utilizan y el tipo de Archivo (Doc, Cad, im�gen, etc).
-- Se asocian a una tabla con TablaId y RegistroId
-- Ubicacion y Nombre: Formato completo con Path: "root/carpetaDeContexto/carpetaDeTabla/nombre.ext", donde NombreFisicoCompleto = "nombre.ext"
(
    id								INT   IDENTITY(1,1)	NOT NULL
    ,ContextoId						INT				NOT NULL
    ,TablaId						INT				NOT NULL
    ,RegistroId						INT				NOT NULL
    ,NombreFisicoCompleto			VARCHAR(100)	NOT NULL 
    ,NombreAMostrar					VARCHAR(100)	NOT NULL 
	--,UbicacionId					INT				NOT NULL
	,ExtensionDeArchivoId			INT				NOT NULL
	,Orden							INT				NOT NULL -- Si un registro tiene + de 1 Archivo --> Este campo los "ordena".
	--,Codigo							VARCHAR(12)				 -- Lo dejamos q pueda ser null, pero puede ser util p 
	,Observaciones					VARCHAR(1000)
	--,Activo							BIT				NOT NULL	DEFAULT 1	VAMOS A PERMITIR ELIMINAR
    ,CONSTRAINT PK_Archivos_Id		PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_Archivos_Nombre	UNIQUE NONCLUSTERED (ContextoId, TablaId, RegistroId, NombreFisicoCompleto)
	,CONSTRAINT UQ_Archivos_NombreAMostrar	UNIQUE NONCLUSTERED (ContextoId, TablaId, RegistroId, NombreAMostrar)
	--,CONSTRAINT UQ_Archivos_Codigo	UNIQUE NONCLUSTERED (Codigo)
)
GO




CREATE TABLE CategoriasDeInformes
(
    id								INT   IDENTITY(1,1)	NOT NULL
    ,ContextoId						INT				NOT NULL
    ,Nombre							VARCHAR(50)		NOT NULL
	,Observaciones					VARCHAR(1000)	
	,Activo							BIT				NOT NULL	DEFAULT 1
	,CONSTRAINT PK_CategoriasDeInformes_Id		PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_CategoriasDeInformes_Nombre	UNIQUE NONCLUSTERED (ContextoId, Nombre)
)
GO




CREATE TABLE Contactos
(
	id									INT   IDENTITY(1,1)	NOT NULL -- id=1 DEFAULT (Para lo que no involucra Contactos)
	,ContextoId							INT				NOT NULL
	,EsUnaOrganizacion					BIT				NOT NULL
    ,NombreCompleto						VARCHAR(150)	NOT NULL
    ,Alias								VARCHAR(50)
    ,Organizacion						VARCHAR(100) -- Ver si no se repite con la idea de GruposDeContactos (o al confeccionar una Rel, se sugiere la "Organizacion")
    ,RelacionConElContacto				VARCHAR(50)
	,Email								VARCHAR(60)
	,Email2								VARCHAR(60)
	,Telefono							VARCHAR(60)
	,Telefono2							VARCHAR(60)
	,Direccion							VARCHAR(1000)
	,Url								VARCHAR(255)
	,Observaciones						VARCHAR(1000)
	--,Activo								BIT				NOT NULL	DEFAULT 1 // Permitiremos eliminar los registros.
	,CONSTRAINT PK_Contactos_Id			PRIMARY KEY CLUSTERED (id)
    ,CONSTRAINT UQ_Contactos_NoRepetir	UNIQUE NONCLUSTERED (ContextoId, NombreCompleto)
)
GO




CREATE TABLE Contextos
-- Los contextos definen el ambiente de operaci�n. Aislando los datos entre ellos.
-- Todas las tablas que tienen contenido no generico deben llevar un ContratoId para separar su info de otro contrato.
(
    id										INT   IDENTITY(1,1)	NOT NULL  -- id=1 DEFAULT (Para lo que no involucra Contextos)
    ,Numero									INT				NOT NULL
    ,Nombre									VARCHAR(100)	NOT NULL
	,Codigo									VARCHAR(40)		NOT NULL
	,CarpetaDeContenidos					VARCHAR(16)		NOT NULL
	--,ContextoDeSistema						BIT				NOT NULL	DEFAULT 0
    --,ImagenUrl								VARCHAR(255)		NOT NULL
	,Observaciones							VARCHAR(1000)
	,CONSTRAINT PK_Contextos_Id				PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_Contextos_Nombre			UNIQUE NONCLUSTERED (Nombre)
	,CONSTRAINT UQ_Contextos_Numero			UNIQUE NONCLUSTERED (Numero)
	,CONSTRAINT UQ_Contextos_Codigo			UNIQUE NONCLUSTERED (Codigo)
	,CONSTRAINT UQ_Contextos_CarpetaDeContenidos	UNIQUE NONCLUSTERED (CarpetaDeContenidos)
)
GO




CREATE TABLE CuentasDeEnvios
(
    id							INT   IDENTITY(1,1)	NOT NULL
    ,Nombre						VARCHAR(40)		NOT NULL -- Identificaci�n de la cuenta, pudiendo indicar el prop�sito de su uso.
    ,CuentaDeEmail				VARCHAR(60)		NOT NULL
	,PwdDeEmail					VARCHAR(40)		NOT NULL
	,Smtp						VARCHAR(60)		NOT NULL
	,Puerto						INT				NOT NULL
    ,Observaciones				VARCHAR(1000)
	,CONSTRAINT PK_CuentasDeEnvios_Id		PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_CuentasDeEnvios_Nombre	UNIQUE NONCLUSTERED (Nombre)
)
GO




CREATE TABLE Dispositivos
(
    id										INT   IDENTITY(1,1)	NOT NULL -- id=1 DEFAULT "Sin Dispositivo"
    ,AsignadoAUsuarioId						INT				NOT NULL -- id=1 cuando "no est� asignado".
	,MachineName							VARCHAR(50)		NOT NULL -- @Imei
	,OSVersion								VARCHAR(100)	NOT NULL
	,UserMachineName						VARCHAR(50)		NOT NULL
	,ClavePrivada							VARCHAR(40)		NOT NULL	DEFAULT ''
	,ClavePrivadaEntregada					BIT				NOT NULL	DEFAULT 0
	,ClavePrivadaFechaEntrega				DATETIME				
	,Observaciones							VARCHAR(1000)
	,Activo									BIT				NOT NULL	DEFAULT 1	
    ,CONSTRAINT PK_Dispositivos_Id				PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_Dispositivos_MachineName		UNIQUE NONCLUSTERED (MachineName)
)
GO




CREATE TABLE EnviosDeCorreos
-- El env�o se hace al correo del campo "Email", que por defecto se sac� de la Tabla del UsuarioDestinatarioId, el cual es opcional.
-- Adem�s, Utilizaremos como referencia, cuando est�n los valores: TablaId y RegistroId identificamos el registro del cual se toma la info a enviar. Esto ser� opcional.
(
    id								INT   IDENTITY(1,1)	NOT NULL
	,UsuarioOriginanteId			INT				NOT NULL	DEFAULT 1	-- El que "pide" el env�o, que puede ser distinto de quien la carga.
	,UsuarioDestinatarioId			INT				NOT NULL 	DEFAULT 1	-- id=1 cuando "no hay usuario". / Serivr� para corroborar a qui�n se lo quisimois manda. No se usa en el env�o.
	,TablaId						INT				NOT NULL	DEFAULT 1	-- id=1 cuando es "sin tabla".
	,RegistroId						INT				NULL		DEFAULT NULL	-- Va nulo cuando no hay referencia a un registro.
	,EmailDeDestino					VARCHAR(60)		NOT NULL -- Es el unico verdaderamente necesario. Ya que es a donde se env�a el correo.
	,Asunto							VARCHAR(200)	NOT NULL
	,Contenido						VARCHAR(MAX)	NOT NULL
	,FechaPactadaDeEnvio			DATETIME		NOT NULL
	,Activo							BIT				NOT NULL	DEFAULT 1	-- = 0 No se env�a (lo pausamos).		
	,CONSTRAINT PK_EnviosDeCorreos_Id	PRIMARY KEY CLUSTERED (id)
)
GO




CREATE TABLE EstadosDeLogErrores
(
    id								INT				NOT NULL
	,Nombre							VARCHAR(30)		NOT NULL
	,Nomenclatura					VARCHAR(12)		NOT NULL
	,Orden							INT				NOT NULL -- El Orden sireve para ordenar los registro por un "peso"
	,Observaciones					VARCHAR(1000)
	,CONSTRAINT PK_EstadosDeLogErrores_Id			PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_EstadosDeLogErrores_Nombre		UNIQUE NONCLUSTERED (Nombre)
	,CONSTRAINT UQ_EstadosDeLogErrores_Nomenclatura	UNIQUE NONCLUSTERED (Nomenclatura)
	,CONSTRAINT UQ_EstadosDeLogErrores_Orden		UNIQUE NONCLUSTERED (Orden)
)
GO




CREATE TABLE EstadosDeSoportes
(
    id						INT				NOT NULL
	,Nombre					VARCHAR(30)		NOT NULL
	,Nomenclatura			VARCHAR(12)		NOT NULL
	,Orden					INT				NOT NULL -- El Orden sireve para ordenar los registro por un "peso"
	,Observaciones			VARCHAR(1000)
	,CierraSoporte			BIT				NOT NULL	DEFAULT 0
	,Activo					BIT				NOT NULL	DEFAULT 1	
	,CONSTRAINT PK_EstadosDeSoportesId				PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_EstadosDeSoportes_Nombre			UNIQUE NONCLUSTERED (Nombre)
	,CONSTRAINT UQ_EstadosDeSoportes_Nomenclatura	UNIQUE NONCLUSTERED (Nomenclatura)
	,CONSTRAINT UQ_EstadosDeSoportes_Orden			UNIQUE NONCLUSTERED (Orden)
)
GO




CREATE TABLE EstadosDeTareas
(
    id						INT				NOT NULL
	,Nombre					VARCHAR(30)		NOT NULL -- Asignada, Iniciada, Finalizada, Aplazada, Esperando Acci�n, Etc.
	,Nomenclatura			VARCHAR(12)		NOT NULL
	,Orden					INT				NOT NULL -- El Orden sireve para ordenar los registro por un "peso"
	,Observaciones			VARCHAR(1000)
	,Activo					BIT				NOT NULL	DEFAULT 1	
	,CONSTRAINT PK_EstadosDeTareasId			PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_EstadosDeTareas_Nombre		UNIQUE NONCLUSTERED (Nombre)
	,CONSTRAINT UQ_EstadosDeTareas_Nomenclatura	UNIQUE NONCLUSTERED (Nomenclatura)
	,CONSTRAINT UQ_EstadosDeTareas_Orden		UNIQUE NONCLUSTERED (Orden)
)
GO




CREATE TABLE ExtensionesDeArchivos
-- Tabla gen�rica, para ser utilizada por Archivos. Definir� el �cono, el programa q utilizan y el tipo de Archivo (Doc, Cad, im�gen, etc).
(
    id								INT   IDENTITY(1,1)	NOT NULL
    ,Nombre							VARCHAR(8)		NOT NULL -- ES LA EXTENCI�N (exe, doc, png, etc).
	,IconoId						INT				NOT NULL
    ,TipoDeArchivoId				INT				NOT NULL -- Doc, Cad, im�gen, etc
    ,ProgramaAsociado				VARCHAR(40)		NOT NULL -- Utilizado p la exportaci�n saber a q programa llamar
	,Observaciones					VARCHAR(1000)
	,CONSTRAINT PK_ExtensionesDeArchivos_Id		PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_ExtensionesDeArchivos_Nombre	UNIQUE NONCLUSTERED (Nombre)
)
GO




CREATE TABLE FuncionesDePaginas
-- Incluye tanto los "tipos" de p�ginas (Insert, Update, etc.), como las funciones concretas (Delete, etc.).
(
	id						INT				NOT NULL  -- id=1 DEFAULT (Para lo que no involucra funciones de tablas)
	,Nombre					VARCHAR(30)		NOT NULL
	,NombreAMostrar			VARCHAR(50)		NOT NULL
	,Observaciones			VARCHAR(1000)			
	,GeneraPagina			BIT				NOT NULL	DEFAULT 0	
	,SeDebenEvaluarPermisos	BIT 			NOT NULL	DEFAULT 1 -- En la Validaci�n de Autorizado A.
	,EsUnaConRegistro		BIT 			NOT NULL			  -- Para la Validaci�n de Autorizado A.
	,CONSTRAINT PK_FuncionesDePaginas_Id				PRIMARY KEY CLUSTERED (id)
    ,CONSTRAINT UQ_FuncionesDePaginas_Nombre			UNIQUE NONCLUSTERED (Nombre)
    ,CONSTRAINT UQ_FuncionesDePaginas_NombreAMostrar	UNIQUE NONCLUSTERED (NombreAMostrar)
)
GO




CREATE TABLE GruposDeContactos
(
    id										INT   IDENTITY(1,1) NOT NULL
	,ContextoId								INT				NOT NULL
	,Nombre									VARCHAR(30)		NOT NULL
	,Observaciones							VARCHAR(1000)
	,CONSTRAINT PK_GruposDeContactos_Id		PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_GruposDeContactos_Nombre	UNIQUE NONCLUSTERED (ContextoId, Nombre)
)
GO




CREATE TABLE Iconos
-- Nombre, es como se llama el �cono (Ejemplo: 'PDF').
-- La Ruta al archivo del icono queda definida por Ubicacion + Imagen (Ejemplo: \Carpeta1\ + 'pdf.png'.
-- La ubicaci�n ser� la misma para todos, y definida de entrada.
(
    id							INT   IDENTITY(1,1)	NOT NULL  -- id=1 DEFAULT
	,Nombre						VARCHAR(50)		NOT NULL
	,Imagen						VARCHAR(50)		NOT NULL
	--,UbicacionId				INT				NOT NULL
	,Altura						INT				NOT NULL
	,Ancho						INT				NOT NULL
	,OffsetX					INT				NOT NULL	DEFAULT 0
	,OffsetY					INT				NOT NULL	DEFAULT 0
	,Observaciones				VARCHAR(1000)			
	,Activo						BIT				NOT NULL	DEFAULT 1	
	,CONSTRAINT PK_Iconos_Id		PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_Iconos_Nombre	UNIQUE NONCLUSTERED	(Nombre)
)
GO




CREATE TABLE IconosCSS
(
    id								INT   IDENTITY(1,1)	NOT NULL  -- id=1 DEFAULT
	,Nombre							VARCHAR(50)		NOT NULL
	,CSS							VARCHAR(100)	NOT NULL
	,Observaciones					VARCHAR(1000)			
	,CONSTRAINT PK_IconosCSS_Id		PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_IconosCSS_Nombre	UNIQUE NONCLUSTERED	(Nombre)
	,CONSTRAINT UQ_IconosCSS_CSS	UNIQUE NONCLUSTERED	(CSS)
)
GO




CREATE TABLE Importaciones
-- Con el log de registros haremos el tracking de quien la import� y en que fecha.
-- Lleva asociada la Tabla "Archivos" para guardar los archivos importados.
(
    id									INT   IDENTITY(1,1)	NOT NULL
	,ContextoId							INT				NOT NULL
    ,UsuarioQueImportaId				INT				NOT NULL
	,TablaId							INT				NOT NULL -- Tabla principal de destino de los datos, del procedimiento de importaci�n.
	,Numero								INT				NOT NULL -- Para poder referenciarlas, ante inconvenientes.
    ,Fecha								DATETIME		NOT NULL
	,Observaciones						VARCHAR(1000)			
	,ObservacionesPosteriores			VARCHAR(1000)
	,Activo								BIT				NOT NULL	DEFAULT 1	
	,CONSTRAINT PK_Importaciones_Id		PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_Importaciones_Numero	UNIQUE NONCLUSTERED (ContextoId, Numero)
)
GO




CREATE TABLE ImportanciasDeTareas
-- Baja, Media, Alta
(
    id						INT				NOT NULL -- id=1 --> Importancia media
	,Nombre					VARCHAR(30)		NOT NULL -- Baja, Media, Alta.
	,Nomenclatura			VARCHAR(12)		NOT NULL
	,Orden					INT				NOT NULL -- El Orden sireve para ordenar los registro por un "peso"
	,Observaciones			VARCHAR(1000)			
	,CONSTRAINT PK_ImportanciasDeTareas_Id				PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_ImportanciasDeTareas_Nombre			UNIQUE NONCLUSTERED (Nombre)
	,CONSTRAINT UQ_ImportanciasDeTareas_Nomenclatura	UNIQUE NONCLUSTERED (Nomenclatura)
	,CONSTRAINT UQ_ImportanciasDeTareas_Orden			UNIQUE NONCLUSTERED (Orden)
)
GO




CREATE TABLE Informes
(
    id								INT   IDENTITY(1,1)	NOT NULL
	,ContextoId						INT				NOT NULL
    ,UsuarioId						INT				NOT NULL -- Es el que genera el informe.
	,CategoriaDeInformeId			INT				NOT NULL
	,Titulo							VARCHAR(150)	NOT NULL
	,Texto							VARCHAR(MAX)	NOT NULL
	,FechaDeInforme					DATE			NOT NULL
	,Activo							BIT				NOT NULL	DEFAULT 1
	,Observaciones					VARCHAR(1000)	
	,CONSTRAINT PK_Informes_Id		PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_Informes_Unico	UNIQUE NONCLUSTERED (ContextoId, Titulo, FechaDeInforme)
)
GO




CREATE TABLE LogEnviosDeCorreos
-- Registra que pas� con el intento de env�o
(
    id								INT   IDENTITY(1,1) NOT NULL
	,EnvioDeCorreoId				INT				NOT NULL
	,Satisfactorio					BIT 			NOT NULL
	,Fecha							DATETIME		NOT NULL -- De env�o
	,Observaciones					VARCHAR(1000) -- Ac� se indicar� el error
	,ObservacionesDeRevision		VARCHAR(1000) DEFAULT '' -- Ac� se indicar� nuestro comentario al revisar un error.
	,CONSTRAINT PK_LogEnviosDeCorreos_Id		PRIMARY KEY CLUSTERED (id)
)
GO




CREATE TABLE LogErrores
(
	id								INT   IDENTITY(1,1)	NOT NULL
	,UsuarioQueEjecutaId			INT				NOT NULL -- Ya no m�s FK, p/ q cuando se crean Usuarios dentro de una TRAN y luego salta el error en otro lado --> ROLLBACK --> No registraba el Error por que no le dejaba la FK de Usuarios.
	,FechaDeEjecucion				DATETIME		NOT NULL
	,Token							VARCHAR(40)		NULL 
	,Seccion						VARCHAR(30)		NULL -- Administracion / Intranet / Web
	,CodigoDelContexto				VARCHAR(40)		NULL -- Ingresado (Cuando es Seccion = "Web")
	,UsuarioQueEjecutaPersisteEnLaBD	BIT				NOT NULL	DEFAULT 1 -- Si el error se produjo luego de crear al usuario y --> Rollback --> UsuarioQueEjecutaPersisteEnLaBD = '0'
	,TablaId						INT				NOT NULL -- id=1 cuando es "sin tabla".
	,TipoDeOperacionId				INT				NOT NULL
	,SP								VARCHAR(80)		NULL	-- De SQL				
	,NumeroDeError					INT
	,LineaDeError					INT
	,ErrorEnAmbienteSQL				BIT				NOT NULL	DEFAULT 0
	,Mensaje						VARCHAR(1000)		-- Mensaje de Error
	,sResSQLDeEntrada				VARCHAR(1000)	NULL	-- Lo QUE INGRES� EN @sResSQL en el SP de insert del Error.
	,PaginaId						INT				NOT NULL -- id=1 cuando es "sin p�gina".
	,Accion							VARCHAR(80)			-- De .Net
	,Capa							VARCHAR(80)			-- De .Net
	,Metodo							VARCHAR(80)			-- De .Net
	,MachineName					VARCHAR(80)			-- De .Net
	,EstadoDeLogErrorId				INT				NOT NULL
	,Observaciones					VARCHAR(1000)	NULL	-- Obs nuestras, posteriormente, con la soluci�n
	,CONSTRAINT PK_LogErrores_Id	PRIMARY KEY CLUSTERED (id)
)
GO




CREATE TABLE LogErroresApp
(
	id							INT IDENTITY(1,1)	NOT NULL
	,FechaDeEjecucion			DATETIME			NOT NULL
	,TokenId					VARCHAR(40)			NULL
	,DispositivoMachineName		VARCHAR(50)			NULL
	,UsuarioId					INT					NULL
	,Metodo						VARCHAR(255)		NOT NULL
	,Clase						VARCHAR(255)		NOT NULL
	,Linea						INT					NOT NULL
	,Texto						VARCHAR(255)		NOT NULL
	,CONSTRAINT PK_LogErroresApp_Id PRIMARY KEY CLUSTERED (id)
)
GO




CREATE TABLE LogLogins
(
    id								INT   IDENTITY(1,1)	NOT NULL
	,UsuarioId						INT				NOT NULL -- id=1 cuando no se identifica al usuario.
	,FechaDeEjecucion				DATETIME		NOT NULL
	,UsuarioIngresado				VARCHAR(81)		NOT NULL -- Cuando UsuarioId=1 --> guarda el "nombre de usuario ingresado": UserName@Contexto
	,TipoDeLogLoginId				INT				NOT NULL
	,DispositivoId					INT				NOT NULL -- id=1 cuando es "sin dispositivo"
	,CONSTRAINT PK_LogLogins_Id		PRIMARY KEY CLUSTERED (id)
)
GO




CREATE TABLE LogLoginsDeDispositivos
(
	id								INT			IDENTITY(1,1)	NOT NULL
    ,DispositivoId					INT				NOT NULL
	,UsuarioId						INT				NOT NULL
	,Token							VARCHAR(40)		NOT NULL
	,FechaDeEjecucion				DATETIME		NOT NULL
	,InicioValides					DATETIME		NOT NULL
	,FinValidez						DATETIME		NOT NULL
	,CONSTRAINT PK_LogLoginsDeDispositivos_Id		PRIMARY KEY CLUSTERED (id)
	--,CONSTRAINT UQ_LogLoginsDeDispositivos_Token		UNIQUE NONCLUSTERED (Token)
)
GO




CREATE TABLE LogLoginsDeDispositivosRechazados
(
    id								INT			IDENTITY(1,1)	NOT NULL
    ,DispositivoId					INT				NOT NULL -- id=1 cuando es "sin dispositivo".
	,UsuarioId						INT				NOT NULL -- id=1 cuando no se identifica al usuario.
	,FechaDeEjecucion				DATETIME		NOT NULL
	,JSON							VARCHAR(5000)	NOT NULL -- Lo limitamos a 5000, por que si hubiera errores multiples, nos puede crecer la BD sin control si este campo es VARCHAR(MAX).
    ,UsuarioIngresado				VARCHAR(81)		NOT NULL
    ,MachineName					VARCHAR(50)		NOT NULL
    ,MotivoDeRechazo				VARCHAR(1000)	NOT NULL
    ,CONSTRAINT PK_LogLoginsDeDispositivosRechazados_Id		PRIMARY KEY CLUSTERED	(id)
)
GO




CREATE TABLE LogRegistros
(
    id									INT   IDENTITY(1,1)	NOT NULL
	,UsuarioQueEjecutaId				INT				NOT NULL
	,FechaDeEjecucion					DATETIME		NOT NULL
	,TablaId							INT				NOT NULL -- id=1 cuando es "sin tabla".	
	,RegistroId							INT				NOT NULL -- No es FK
	,LogLoginDeDispositivoId			INT				NOT NULL -- id=1 cuando es desde una PC --> "sin dispositivo".	
	,TipoDeOperacionId					INT				NOT NULL
	,CONSTRAINT PK_LogRegistros_Id		PRIMARY KEY CLUSTERED (id)
)
GO




CREATE TABLE Notas
(
    id										INT   IDENTITY(1,1)	NOT NULL
	,ContextoId								INT				NOT NULL
    ,UsuarioId								INT				NOT NULL -- Que genera la nota.
	,IconoCSSId								INT				NOT NULL
	,Fecha									DATETIME		NOT NULL -- De creaci�n de la Nota.
	,FechaDeVencimiento						DATETIME		NULL	 -- Puede no tener.
	,Titulo									VARCHAR(100)	NOT NULL
	,Cuerpo									VARCHAR(MAX)	NOT NULL
	,CompartirConTodos						BIT				NOT NULL
	,CONSTRAINT PK_Notas_Id		PRIMARY KEY CLUSTERED (id)
)
GO




CREATE TABLE Notificaciones
(
    id										INT   IDENTITY(1,1)	NOT NULL
	,ContextoId								INT				NOT NULL -- id=1 cuando es "sin usuario/sin contexto". --> Broadcast a TODOS los contextos.
    ,Fecha									DATETIME		NOT NULL
	,Numero									INT				NOT NULL
    ,UsuarioDestinatarioId					INT				NOT NULL -- id=1 cuando es "sin usuario". --> Broadcast al contexto.
	,TablaId								INT				NOT NULL
	,RegistroId								INT				NOT NULL
	,SeccionId								INT				NOT NULL
	,IconoCSSId								INT				NOT NULL
	,Cuerpo									VARCHAR(1000)	NOT NULL
	,Leida									BIT				NOT NULL	DEFAULT 0
	,Activo									BIT				NOT NULL	DEFAULT 1	
	,CONSTRAINT PK_Notificaciones_Id		PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_Notificaciones_Numero	UNIQUE NONCLUSTERED (ContextoId, Numero)
)
GO




CREATE TABLE Paginas
(
	id									INT   IDENTITY(1,1) NOT NULL -- id=1 DEFAULT (Para lo que no involucra Paginas)
	,SeccionId							INT				NOT NULL	DEFAULT 1
	,TablaId							INT				NOT NULL -- id=1 cuando es "sin tabla".
	,FuncionDePaginaId					INT				NOT NULL
	,Nombre								VARCHAR(100)	NOT NULL
	,Titulo								VARCHAR(100)	
	,Tips								VARCHAR(2000)	
	,Observaciones						VARCHAR(2000)	
	,SeMuestraEnAsignacionDePermisos	BIT				NOT NULL	DEFAULT 1
	,CONSTRAINT PK_Paginas_Id		PRIMARY KEY CLUSTERED (id)
    ,CONSTRAINT UQ_Paginas_Nombre	UNIQUE NONCLUSTERED (Nombre)
    ,CONSTRAINT UQ_Paginas			UNIQUE NONCLUSTERED (SeccionId, TablaId, FuncionDePaginaId)
)
GO




CREATE TABLE ParametrosDelSistema
-- Todav�a no est� implementada su funcionalidad, pero la dejamos ac�, previendo su desarrollo.
(
	id										INT   IDENTITY(1,1) NOT NULL
	,ContextoId								INT			NOT NULL
	,Contextohabilitadi						BIT			NOT NULL DEFAULT 1 -- Habilitado para operar.
    ,IntentosFallidosDeLoginPermitidos		INT	-- Pasado esos intentos en el tiempo:  se bloquea al usaurio.
    ,IntervaloDeIntentosFallidoLogin		INT	-- Intervalo (Ultimos Minutos) en los que se chequea los intentos fallidos.
    ,MinDeBloqueoTrasIntentosFallidoLogin	INT	-- Minutos durante los que se bloquear� el login.
    ,PermitidasLasModificaciones			INT	-- Se permite modificar registros..
    ,PermitidasLasConsultas					INT	-- Se permite consultar informaci�n.
	,PermitidasLasExportaciones				INT	-- Se permite exportar informacion (excel, pdf, etc).
	,PermitidosLosEnviosDeCorreo			INT	-- Se permite el env�o de correos.
    ,DiferenciaHorariaDelServidor			INT -- Para ajustar la hora de las fciones ejecutadas contra el servidor.
    ,Observaciones							VARCHAR(1000)
	,CONSTRAINT PK_ParametrosDelSistema_Id	PRIMARY KEY CLUSTERED (id)
)
GO




CREATE TABLE PrioridadesDeSoportes
(
    id									INT				NOT NULL -- id=1 DEFAULT
	,Nombre								VARCHAR(12)		NOT NULL
	,Orden								INT				NOT NULL
	,Observaciones						VARCHAR(1000)
	,Activo								BIT				NOT NULL	DEFAULT 1	
	,CONSTRAINT PK_PrioridadesDeSoportes_Id		PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_PrioridadesDeSoportes_Nombre	UNIQUE NONCLUSTERED (Nombre)
	,CONSTRAINT UQ_PrioridadesDeSoportes_Orden	UNIQUE NONCLUSTERED (Orden)
)
GO




CREATE TABLE Publicaciones
(
	id								INT   IDENTITY(1,1) NOT NULL
	,Fecha							DATE			NOT NULL
	,Titulo							VARCHAR(40)		NOT NULL
	,NumeroDeVersion				VARCHAR(30)
	,Realizada						BIT				NOT NULL
	,Observaciones					VARCHAR(8000)	
	,Hora							TIME(0)			NOT NULL
	,Activo							BIT				NOT NULL	DEFAULT 1	
	,CONSTRAINT PK_Publicaciones_Id		PRIMARY KEY CLUSTERED (id)
    ,CONSTRAINT UQ_Publicaciones_NumeroDeVersion	UNIQUE NONCLUSTERED (NumeroDeVersion)
)
GO
	



CREATE TABLE RecorridosDeDispositivos
(
	id							INT   IDENTITY(1,1)	NOT NULL
	,ContextoId					INT					NOT NULL
    ,DispositivoId				INT					NOT NULL
	,UsuarioId					INT					NOT NULL -- Se enlaza en el WS
	--,UsuarioIngresado			VARCHAR(40)			NOT NULL -- NO VA, ES EL Ingresado en la App
	,Token						VARCHAR(40)			NOT NULL
	,FechaDeEjecucion			DATETIME			NOT NULL
	,Latitud					VARCHAR(19)			NOT NULL
	,Longitud					VARCHAR(19)			NOT NULL
	,CONSTRAINT PK_RecorridosDeDispositivos_Id PRIMARY KEY CLUSTERED (id)
)
GO




CREATE TABLE Recursos
(
	id								INT   IDENTITY(1,1) NOT NULL
	,ContextoId						INT				NOT NULL
	--,UsuarioResponsableId			INT				NOT NULL -- SE CREA UNA REL PARA TENER MULTIPLES APROBADORES. (ANTES: No necesariamente ser� el que apruebe su reserva.)
	,Nombre							VARCHAR(100)	NOT NULL
	,Observaciones					VARCHAR(1000)	
	,Activo							BIT				NOT NULL	DEFAULT 1	
	,CONSTRAINT PK_Recursos_Id		PRIMARY KEY CLUSTERED (id)
    ,CONSTRAINT UQ_Recursos_Titulo	UNIQUE NONCLUSTERED (ContextoId, Nombre)
)
GO




CREATE TABLE RelAsig_Contactos_A_GruposDeContactos
(
	id									INT   IDENTITY(1,1)	NOT NULL
	,ContactoId							INT				NOT NULL
	,GrupoDeContactoId					INT				NOT NULL
	,CONSTRAINT PK_RelAsig_Contactos_A_GruposDeContactos_Id			PRIMARY KEY CLUSTERED (id)
    ,CONSTRAINT UQ_RelAsig_Contactos_A_GruposDeContactos_NoRepetir	UNIQUE NONCLUSTERED (ContactoId, GrupoDeContactoId)
)
GO




CREATE TABLE RelAsig_Contactos_A_TiposDeContactos -- Para indicar si un contacto es Clientes, Proveedor, etc.
(
	id									INT   IDENTITY(1,1)	NOT NULL
	,ContactoId							INT				NOT NULL
	,TipoDeContactoId					INT				NOT NULL
	,CONSTRAINT PK_RelAsig_Contactos_A_TiposDeContactos_Id			PRIMARY KEY CLUSTERED (id)
    ,CONSTRAINT UQ_RelAsig_Contactos_A_TiposDeContactos_NoRepetir	UNIQUE NONCLUSTERED (ContactoId, TipoDeContactoId)
)
GO




CREATE TABLE RelAsig_CuentasDeEnvios_A_Tablas
(
	id							INT   IDENTITY(1,1)	NOT NULL
	,ContextoId					INT				NOT NULL
	,CuentaDeEnvioId			INT				NOT NULL
	,TablaId					INT				NOT NULL
	,CONSTRAINT PK_RelAsig_CuentasDeEnvios_A_Tablas_Id	PRIMARY KEY CLUSTERED (id)
    ,CONSTRAINT UQ_RelAsig_CuentasDeEnvios_A_Tablas_NoRepetir	UNIQUE NONCLUSTERED (ContextoId, CuentaDeEnvioId, TablaId)
)
GO




CREATE TABLE RelAsig_RolesDeUsuarios_A_Paginas
(
	id										INT   IDENTITY(1,1) NOT NULL
	,RolDeUsuarioId							INT				NOT NULL
	,PaginaId								INT				NOT NULL
	,AutorizadoA_CargarLaPagina				BIT				NOT NULL
	,AutorizadoA_OperarLaPagina				BIT				NOT NULL
	,AutorizadoA_VerRegAnulados				BIT				NOT NULL
	,AutorizadoA_AccionesEspeciales			BIT				NOT NULL	
	,CONSTRAINT PK_RelAsig_RolesDeUsuarios_A_Paginas_Id		PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_RelAsig_RolesDeUsuarios_A_Paginas		UNIQUE NONCLUSTERED (RolDeUsuarioId, PaginaId)
)	
GO




CREATE TABLE RelAsig_RolesDeUsuarios_A_Usuarios
(
	id							INT   IDENTITY(1,1)	NOT NULL
	,RolDeUsuarioId				INT				NOT NULL
	,UsuarioId					INT				NOT NULL
	,FechaDesde					DATE			NOT NULL
	,FechaHasta					DATE
	,CONSTRAINT PK_RelAsig_RolesDeUsuarios_A_Usuarios_Id	PRIMARY KEY CLUSTERED (id)
    ,CONSTRAINT UQ_RelAsig_RolesDeUsuarios_A_Usuarios_NoRepetir		UNIQUE NONCLUSTERED (RolDeUsuarioId, UsuarioId, FechaDesde)
    ,CONSTRAINT UQ_RelAsig_RolesDeUsuarios_A_Usuarios_NoRepetir2	UNIQUE NONCLUSTERED (RolDeUsuarioId, UsuarioId, FechaHasta)
)
GO




CREATE TABLE RelAsig_Subsistemas_A_Publicaciones
(
	id							INT   IDENTITY(1,1)	NOT NULL
	,SubsistemaId				INT				NOT NULL
	,PublicacionId				INT				NOT NULL
	,UsuarioId					INT				NOT NULL
	,NumeroDeVersion			VARCHAR(30)
	,SVN						INT
	,Ubicacion					VARCHAR(150)
	,Observaciones				VARCHAR(1000)
	,CONSTRAINT PK_RelAsig_Subsistemas_A_Publicaciones_Id	PRIMARY KEY CLUSTERED (id)
    ,CONSTRAINT UQ_RelAsig_Subsistemas_A_Publicaciones_SP	UNIQUE NONCLUSTERED (SubsistemaId, PublicacionId)
    ,CONSTRAINT UQ_RelAsig_Subsistemas_A_Publicaciones_Subsistema	UNIQUE NONCLUSTERED	(SubsistemaId, NumeroDeVersion)
)
GO




CREATE TABLE RelAsig_TiposDeContactos_A_Contextos -- Es para "mostrar" el "tipo de contacto" en un Contexto y en otro NO.
(
	id									INT   IDENTITY(1,1)	NOT NULL
	,TipoDeContactoId					INT				NOT NULL
	,ContextoId							INT				NOT NULL
	,CONSTRAINT PK_RelAsig_TiposDeContactos_A_Contextos_Id			PRIMARY KEY CLUSTERED (id)
    ,CONSTRAINT UQ_RelAsig_TiposDeContactos_A_Contextos_NoRepetir	UNIQUE NONCLUSTERED (TipoDeContactoId, ContextoId)
)
GO




CREATE TABLE RelAsig_Usuarios_A_Recursos -- Son los usuarios que pueden "Aprobar" reservas del recurso indicado.
(
	id									INT   IDENTITY(1,1)	NOT NULL
	,UsuarioId							INT				NOT NULL
	,RecursoId							INT				NOT NULL
	,CONSTRAINT PK_RelAsig_Usuarios_A_Recursos_Id			PRIMARY KEY CLUSTERED (id)
    ,CONSTRAINT UQ_RelAsig_Usuarios_A_Recursos_NoRepetir	UNIQUE NONCLUSTERED (UsuarioId, RecursoId)
)
GO




CREATE TABLE ReservasDeRecursos
(
	id								INT   IDENTITY(1,1) NOT NULL
	,ContextoId						INT				NOT NULL -- Depende del contexto.
    ,UsuarioOriginanteId			INT				NOT NULL -- El que "pide" la reserva.
	,UsuarioDestinatarioId			INT				NOT NULL -- Para el destinatario de la reserva.
	,RecursoId						INT				NOT NULL -- Recurso que se reserva.
	,FechaDePedido					DATETIME		NOT NULL -- Fecha en que se pide la reserva.
	,FechaDeAprobacion				DATETIME		NULL	 -- = NULL --> NO APROBADA. Fecha en que se aprueba la reserva.
	,ReservaAprobada		AS CAST(CASE WHEN FechaDeAprobacion IS NULL THEN 0 ELSE 1 END AS BIT) -- "BIT NULL" 
	,FechaDeInicio					DATETIME		NOT NULL -- Es la fecha desde la cual cominza la reserva.
	,FechaLimite					DATETIME		NULL	 -- = NULL --> Reservada indefinidamente. Es la fecha en la que espera que finalice la reserva.
	,Numero							INT				NOT NULL -- De referencia
	,ObservacionesDelOriginante		VARCHAR(1000)
	,ObservacionesDelAprobador		VARCHAR(1000)	
	,CONSTRAINT PK_ReservasDeRecursos_Id		PRIMARY KEY CLUSTERED (id)
    ,CONSTRAINT UQ_ReservasDeRecursos			UNIQUE NONCLUSTERED (ContextoId, FechaDeInicio, RecursoId)
	,CONSTRAINT UQ_ReservasDeRecursos_Numero	UNIQUE NONCLUSTERED (ContextoId, Numero)
)
GO

	


CREATE TABLE RolesDeUsuarios
-- Tabla administrada por el MasterAdmin --> Seteo el id "a Mano".
-- Los ids van desde 1 a 999 para los de core. id > 1000 son para los P.
-- Prioridad: Define la prioridad sobre otro rol, para la asignaci�n de permisos. Prioridades < -1000 son para las particularidades:
(
	id										INT				NOT NULL --NO ES IDENTITY, YA QUE SON HARDCODEADOS
	,Nombre									VARCHAR(80)		NOT NULL
	,NombreAMostrar							VARCHAR(255)	NOT NULL
	,Observaciones							VARCHAR(1000)	NULL	
	,Prioridad								INT				NOT NULL
    ,SeMuestraEnAsignacionDePermisos		BIT				NOT NULL	DEFAULT 1		-- Roles A P�ginas por parte del Administrador
    ,SeMuestraEnAsignacionDeRoles			BIT				NOT NULL	DEFAULT 1		-- Roles A Usuarios	por parte del Administrador
    ,DeCore									BIT				NOT NULL	DEFAULT 0
    ,Activo									BIT				NOT NULL	DEFAULT 1
	,CONSTRAINT PK_RolesDeUsuarios_Id		PRIMARY KEY CLUSTERED (id)
    ,CONSTRAINT UQ_RolesDeUsuarios_Nombre	UNIQUE NONCLUSTERED (Nombre)
    ,CONSTRAINT UQ_RolesDeUsuarios_NombreAMostrar	UNIQUE NONCLUSTERED (NombreAMostrar)
    ,CONSTRAINT UQ_RolesDeUsuarios_Prioridad	UNIQUE NONCLUSTERED (Prioridad)
)
GO

				


CREATE TABLE Secciones
(
	id									INT				NOT NULL
	,Nombre								VARCHAR(30)		NOT NULL
	,NombreAMostrar						VARCHAR(40)		NOT NULL
	,Observaciones						VARCHAR(1000)
	,CONSTRAINT PK_Secciones_Id			PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_Secciones_Nombre		UNIQUE NONCLUSTERED (Nombre)
	,CONSTRAINT UQ_Secciones_NombreAMostrar	UNIQUE NONCLUSTERED (NombreAMostrar)
)
GO




CREATE TABLE Soportes
-- FechaDeCreacion puede ir nulo por que se completar�n al cerrar la comunicacion
-- Observaciones ser� un campo privado para el MasterAdmin
(
	id								INT   IDENTITY(1,1)	NOT NULL
	,ContextoId						INT				NOT NULL
    ,UsuarioQueSolicitaId			INT				NOT NULL
	,PublicacionId					INT				-- No es FK
	,FechaDeEjecucion				DATETIME		NOT NULL
    ,UsuarioQueCerroId				INT				NOT NULL -- id=1 cuando "no est� cerrada".
	,FechaDeCierre					DATETIME
	,Numero							INT				NOT NULL
	,Texto							VARCHAR(MAX)						
	,EstadoDeSoportesId				INT				NOT NULL
	,PrioridadDeSoporteId			INT				NOT NULL			
	,Observaciones					VARCHAR(MAX)
	,ObservacionesPrivadas			VARCHAR(MAX)
	,Cerrado						BIT				NOT NULL	DEFAULT 0
	,Activo							BIT				NOT NULL	DEFAULT 1	
	,CONSTRAINT PK_Soportes_Id		PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_Soportes_Numero	UNIQUE NONCLUSTERED (ContextoId, Numero)
)
GO




CREATE TABLE SPs
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- Se usa para excluir mirar permisos y para controlar la generaci�n de Emails y Notificaciones.
	 -------------
(
    id										INT   IDENTITY(1,1) NOT NULL
	,Nombre									VARCHAR(120)	NOT NULL
	,SeDebenEvaluarPermisos					BIT 			NOT NULL	DEFAULT 1 -- En la Validaci�n de Autorizado A.
	,GeneracionDeEmailHabilitada			BIT 			NOT NULL	DEFAULT 0
	,GeneracionDeNotificacionesHabilitada	BIT				NOT NULL	DEFAULT 0
	,Observaciones							VARCHAR(1000)
	,CONSTRAINT PK_SPs_Id					PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_SPs_Nombre				UNIQUE NONCLUSTERED (Nombre)
)
GO




CREATE TABLE Subsistemas
(
    id									INT   IDENTITY(1,1)	NOT NULL
	,Nombre								VARCHAR(40)		NOT NULL
	,Observaciones						VARCHAR(1000)						
	,Activo								BIT				NOT NULL	DEFAULT 1	
	,CONSTRAINT PK_Subsistemas_Id		PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_Subsistemas_Nombre	UNIQUE NONCLUSTERED (Nombre)
)
GO




CREATE TABLE Tablas
-- Las observaciones son para el MasterWeb.
-- Al cargar un registro, el AutorizadoA_OperarLaPagina indica si tiene permiso para Eliminar o Activar/Anular seg�n el caso.
-- Si una tabla tiene:
	-- TablaDeCore = 1 --> Va en el proyecto de Core.
	-- SeCreanPaginas = 1 --> Se crean las P�ginas asociadas a la tabla en el script de Insert de la tabla.
	-- TieneArchivos = 1 --> Se Adjuntaran Archivos, en la Tabla "Archivos" vinculados a los registro de la tabla en cuesti�n. 
			-- y Se crea la Carpeta @Nomenclatura en el Disco, que los almacenar�.
(
    id										INT   IDENTITY(1,1) NOT NULL -- id=1 DEFAULT (Para lo que no involucra Tablas).
	,IconoCSSId								INT				NOT NULL
	,Nombre									VARCHAR(80)		NOT NULL
	,NombreAMostrar							VARCHAR(100)	NOT NULL
	,Nomenclatura							VARCHAR(12)		NOT NULL -- Y CarpetaDeContenidos.
	,Observaciones							VARCHAR(1000)	NULL
	
	,SeDebenEvaluarPermisos					BIT 			NOT NULL DEFAULT '1' -- En la Validaci�n de Autorizado A.
	,PermiteEliminarSusRegistros			BIT				NOT NULL
	,TablaDeCore							BIT				NOT NULL
	,SeCreanPaginas							BIT				NOT NULL
	,TieneArchivos							BIT				NOT NULL
	-- Los Campos a continuaci�n son para gestionar los SP creados AUTO.
	,CampoAMostrarEnFK						VARCHAR(100)	NOT NULL DEFAULT '' -- Es el campo (de la propia tabla) que se muestra, por ejemplo, en un listado DDL cuando es FK de otra tabla.
	,CamposQuePuedenSerIdsString			VARCHAR(1000)	NOT NULL DEFAULT '' -- Separados por comas. Son Campos (de la propia tabla) que puede ser entrada IdsString --> genera un SP #NombreTabla@__Insert_by_@#NombreCampo#IdsString.
	,CamposAExcluirEnElInsert				VARCHAR(1000)	NOT NULL DEFAULT '' -- Separados por comas. Por Ejemplo: 'Nombre, Apellido' (id y Numero se excluyen siempre). Sirve para Generador de SPs.
	,CamposAExcluirEnElUpdate				VARCHAR(1000)	NOT NULL DEFAULT '' -- Separados por comas. Por Ejemplo: 'Nombre, Apellido' (id, Activo y Numero se excluyen siempre). Sirve para Generador de SPs.
	,CamposAExcluirEnElListado				VARCHAR(1000)	NOT NULL DEFAULT '' -- Separados por comas. Por Ejemplo: 'Nombre, Apellido'.
	,CamposAIncluirEnFiltrosDeListado		VARCHAR(1000)	NOT NULL DEFAULT '' -- Separados por comas. Por Ejemplo: 'Nombre, Apellido'.
	,SeGeneranAutoSusSPsDeABM				BIT 			NOT NULL DEFAULT '1' -- Con el Generador de SPs.
	,SeGeneranAutoSusSPsDeRegistros			BIT 			NOT NULL DEFAULT '1' -- Con el Generador de SPs.
	,SeGeneranAutoSusSPsDeListados			BIT 			NOT NULL DEFAULT '1' -- Con el Generador de SPs.
	,CONSTRAINT PK_Tablas_Id				PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_Tablas_Nombre			UNIQUE NONCLUSTERED (Nombre)
	,CONSTRAINT UQ_Tablas_Nomenclatura		UNIQUE NONCLUSTERED (Nomenclatura)
)
GO




CREATE TABLE TablasYFuncionesDePaginas
	 -- Validaciones:
		-- 
	 -------------
	 -- Acotaciones:
		-- Se usa para excluir mirar permisos.
	 -------------
(
	id									INT   IDENTITY(1,1)	NOT NULL
	,TablaId							INT				NOT NULL
	,FuncionDePaginaId					INT				NOT NULL
	,SeDebenEvaluarPermisos				BIT 			NOT NULL	DEFAULT 1 -- En la Validaci�n de Autorizado A.
	,Observaciones						VARCHAR(1000)	NULL
	,CONSTRAINT PK_TablasYFuncionesDePaginas_Id	PRIMARY KEY CLUSTERED (id)
    ,CONSTRAINT UQ_TablasYFuncionesDePaginas_NoRepetir UNIQUE NONCLUSTERED (TablaId, FuncionDePaginaId)
)
GO




CREATE TABLE Tareas
-- Permitir� tener Archivos enlazados.
(
	id								INT   IDENTITY(1,1) NOT NULL
	,ContextoId						INT				NOT NULL -- Depende del contexto.
    ,UsuarioOriginanteId			INT				NOT NULL -- El que "pide" la tarea, que puede ser distinto de quien la carga.
	,UsuarioDestinatarioId			INT				NOT NULL -- A qui�n se le asigna la tarea para que la realice.
	,FechaDeInicio					DATE			NOT NULL -- Puede ser que la cargue con una fecha posterior de inicio.
	,FechaLimite					DATE			NOT NULL -- Es la fecha en la que espera que est� realizada la tarea. No impolica ninguna otra acci�n.
	,Numero							INT				NOT NULL
	,TipoDeTareaId					INT				NOT NULL -- Es como "Categorizar" o "Clasificar" a la tarea.
	,EstadoDeTareaId				INT				NOT NULL -- Asignada, Iniciada, Finalizada, Aplazada, Esperando Acci�n, Etc.
	,Titulo							VARCHAR(100)	NOT NULL	
	,ImportanciaDeTareaId			INT				NOT NULL -- Baja, Media, Alta
	,TablaId						INT				NOT NULL -- id=1 cuando es "sin tabla".	La tarea puede estar relacionada con un registros particular de cualquier tabla.
	,RegistroId						INT				NULL -- No es FK. La tarea puede estar relacionada con un registros particular de cualquier tabla.
	,Observaciones					VARCHAR(2000)	
	,Activo							BIT				NOT NULL	DEFAULT 1	
	,CONSTRAINT PK_Tareas_Id		PRIMARY KEY CLUSTERED (id)
    ,CONSTRAINT UQ_Tareas			UNIQUE NONCLUSTERED (ContextoId, FechaDeInicio, TipoDeTareaId, Titulo)
	,CONSTRAINT UQ_Tareas_Numero	UNIQUE NONCLUSTERED (ContextoId, Numero)
)
GO



			
CREATE TABLE TiposDeActores
-- Sistemas, Internos, Comitentes, Contratistas, Externos, Clientes, etc.
(
    id										INT   IDENTITY(1,1) NOT NULL
	,Nombre									VARCHAR(30)		NOT NULL
	,Observaciones							VARCHAR(1000)
	--,TiposDeActorDeSistema					BIT				NOT NULL	DEFAULT 0 -- IF=1 --> No se muestra a los usuarios de trabajo
	,CONSTRAINT PK_TiposDeActores_Id		PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_TiposDeActores_Nombre	UNIQUE NONCLUSTERED (Nombre)
)
GO




CREATE TABLE TiposDeArchivos
-- No se define a nivel de formato (PDF, Excel, Word, etc), si no a nivel de tipo (Cad, office, Im�gen, etc).
(
    id											INT   IDENTITY(1,1) NOT NULL
	,Nombre										VARCHAR(40)		NOT NULL
	,Observaciones								VARCHAR(1000)
	,CONSTRAINT PK_TiposDeArchivos_Id			PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_TiposDeArchivos_Nombre		UNIQUE NONCLUSTERED (Nombre)
)
GO




CREATE TABLE TiposDeContactos -- //  VA CON CONTEXTO, SI O NO ? // SI ES "SIN" --> MOSTRAMOS LOS REGISTROS EN TODOS LOS CONTEXTO U OCULTAMOS ALGUNOS SEGUN EL CONTEXTO ?
-- Clientes, Contratistas, Proveedores, etc.
(
    id										INT   IDENTITY(1,1) NOT NULL
	,Nombre									VARCHAR(30)		NOT NULL
	,Observaciones							VARCHAR(1000)
	,CONSTRAINT PK_TiposDeContactos_Id		PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_TiposDeContactos_Nombre	UNIQUE NONCLUSTERED (Nombre)
)
GO




CREATE TABLE TiposDeLogLogins
-- Dejar el Mensaje "vac�o" fara los Login Exitosos, o indicar en �l, el mesaje del Login Fallido.
(
    id											INT				NOT NULL
	,ConCookie									BIT				NOT NULL	DEFAULT 0
	,Nombre										VARCHAR(50)		NOT NULL
	,MensajeDeError								VARCHAR(1000)	NOT NULL -- Mensaje hacia el usaurio del login.
	,Observaciones								VARCHAR(1000)
	,CONSTRAINT PK_TiposDeLogLogins_Id			PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_TiposDeLogLogins_Nombre		UNIQUE NONCLUSTERED (Nombre)
)
GO




CREATE TABLE TiposDeOperaciones
(
    id											INT				NOT NULL
	,Nombre										VARCHAR(12)		NOT NULL
	,Texto										VARCHAR(20)
	,Observaciones								VARCHAR(1000)
	,CONSTRAINT PK_TiposDeOperaciones_Id		PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_TiposDeOperaciones_Nombre	UNIQUE NONCLUSTERED (Nombre)
)
GO




CREATE TABLE TiposDeTareas
-- Es como "Categorizar" o "Clasificar" a la tarea. La operar�n los Administradores.
(
    id									INT   IDENTITY(1,1) NOT NULL
	,ContextoId							INT				NOT NULL
    ,Nombre								VARCHAR(30)		NOT NULL
	,Observaciones						VARCHAR(1000)
	,Activo								BIT				NOT NULL	DEFAULT 1
	,CONSTRAINT PK_TiposDeTareas_Id		PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_TiposDeTareas_Nombre	UNIQUE NONCLUSTERED (ContextoId, Nombre)
)
GO




CREATE TABLE Ubicaciones
-- indica la ubicaci�n de una carpeta (Ruta), la cual es �nica en la BD.
(
    id									INT   IDENTITY(1,1)	NOT NULL
	,Nombre								VARCHAR(150)		NOT NULL
	,Observaciones						VARCHAR(1000)
	,UbicacionAbsoluta					BIT					NOT NULL
	,CONSTRAINT PK_Ubicaciones_Id		PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_Ubicaciones_Nombre	UNIQUE NONCLUSTERED (Nombre)
)
GO




CREATE TABLE Unidades
 -- Inicialmente, la usa cada "Elemento" pero ser� una tabla generica.
(
    id									INT   IDENTITY(1,1)	NOT NULL
	,Codigo								VARCHAR(8)		NOT NULL
    ,Nombre								VARCHAR(50)		NOT NULL
	,Observaciones						VARCHAR(1000)	
	,CONSTRAINT PK_Unidades_Id			PRIMARY KEY CLUSTERED (id)
	,CONSTRAINT UQ_Unidades_Codigo		UNIQUE NONCLUSTERED (Codigo)
	,CONSTRAINT UQ_Unidades_Nombre		UNIQUE NONCLUSTERED (Nombre)
)
GO




CREATE TABLE Usuarios
(
	id									INT   IDENTITY(1,1)	NOT NULL -- id=1 DEFAULT (Para lo que no involucra Usuario)
	--,ActorId							INT				NOT NULL
	,ContextoId							INT				NOT NULL
    ,ArchivoDeFotoId					INT				NULL		DEFAULT NULL -- Link a la tabla Archivos
    ,UserName							VARCHAR(40)		NOT NULL
	,Pass								VARCHAR(40)		NOT NULL
	,Nombre								VARCHAR(40)		NOT NULL
	,Apellido							VARCHAR(40)		NOT NULL
	,Email								VARCHAR(60)
	,Email2								VARCHAR(60)
	,Telefono							VARCHAR(60)
	,Telefono2							VARCHAR(60)
	,Direccion							VARCHAR(1000)
	,Observaciones						VARCHAR(1000)
	,SeMuestraEnAsignacionDeRoles		BIT				NOT NULL	DEFAULT 1		-- Roles A Usuarios
	,Activo								BIT				NOT NULL	DEFAULT 1
	,UltimoLoginSesionId				VARCHAR(24)		NOT NULL -- No es FK
	,UltimoLoginFecha					DATETIME
	,AuthCookie							VARCHAR(255)
	,FechaDeExpiracionCookie			DATETIME
	,CONSTRAINT PK_Usuarios_Id			PRIMARY KEY CLUSTERED (id)
    ,CONSTRAINT UQ_Usuarios_UserName	UNIQUE NONCLUSTERED (ContextoId, UserName)
	--,CONSTRAINT UQ_Usuarios_UltimoLoginSesionId UNIQUE NONCLUSTERED (UltimoLoginSesionId)
	-- Lo sacamos, era para que no se pueda asignar una sesion a otro usuario (mediante hackeo), 
	-- pero si se podr�, para q se pueda cambiar de usuario, ya q el iis asigna misma sesion.
)
GO




-- ---------------------------
-- Script: DB_ParticularCore__C01__Create Tablas.sql - FIN
-- =====================================================
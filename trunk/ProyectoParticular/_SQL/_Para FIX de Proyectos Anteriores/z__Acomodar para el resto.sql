


--las modificaciones las comente:   "Agregado Diciembre 2019"  (Se puede buscar por eso)

1) En Usuarios: (Antes de Activo)
	,SeMuestraEnAsignacionDeRoles		BIT				NOT NULL	DEFAULT 1		-- Roles A Usuarios por parte del administrador	

2) En LogErrores:
	,UsuarioQueEjecutaId			INT				NOT NULL -- Ya no más FK, p/ q cuando se crean Usuarios dentro de una TRAN y luego salta el error en otro lado --> ROLLBACK --> No registraba el Error por que no le dejaba la FK de Usuarios.
	,Token							VARCHAR(40)		NULL 
	,Seccion						VARCHAR(30)		NULL -- Intranet / IntranetPublica / Web
	,CodigoDelContexto				VARCHAR(40)		NULL -- Ingresado (Cuando es Seccion = "Web")
	,SP								VARCHAR(80)		NULL	-- De SQL // Ahora permite NULL (cuando se produjo en .net)
	,UsuarioQueEjecutaPersisteEnLaBD	BIT				NOT NULL	DEFAULT 1 -- Si el error se produjo luego de crear al usuario y --> Rollback --> UsuarioQueEjecutaPersisteEnLaBD = '0'
	,sResSQLDeEntrada				VARCHAR(1000)	NULL	-- Lo QUE INGRESÓ EN @sResSQL en el SP de insert del Error.
	,Observaciones					VARCHAR(1000)	NULL	--  // Ahora permite NULL (cuando se produjo en .net)
	
3) En RolesDeUsuarios:
	,SeMuestraEnAsignacionDeRoles			BIT				NOT NULL	DEFAULT 1		-- Roles A Usuarios por parte del administrador	
	

4) En EnviosDeCorreos:
	,Activo							BIT				NOT NULL	DEFAULT 1	-- = 0 No se envía (lo pausamos).

5) En Tablas:
Comentar:
	--,PermiteInsertAnonimamente				BIT				NOT NULL DEFAULT '0' -- Con un usuario que no está logueado.
	--,PermiteListarDDLAnonimamente			BIT 			NOT NULL DEFAULT '0' -- Con un usuario que no está logueado.

6) FK-TABLA: LogErrores - INICIO:
	-- Ahora vamos a permitir q no haya FK ya que cuando se crean Usuarios dentro de una TRAN y luego salta el error en otro lado --> ROLLBACK --> No registraba el Error por que no le dejaba la FK de Usuarios.
	--ALTER TABLE LogErrores ADD CONSTRAINT FK_LogErrores_UsuarioQueEjecutaId FOREIGN KEY (UsuarioQueEjecutaId) REFERENCES Usuarios (id)

	

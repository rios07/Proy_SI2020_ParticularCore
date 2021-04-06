-- =====================================================
-- Descripción: Creando FKs
-- Script: DB_ParticularCore__C03__Create FK.sql - INICIO
-- =====================================================

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
			-- RelAsig_CuentasDeEnvios_A_Tablas
			-- RelAsig_Subsistemas_A_Publicaciones
			-- RelAsig_Usuarios_A_Recursos
			-- ReservasDeRecursos
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
		
-- FK-TABLA: Actores - INICIO
ALTER TABLE Actores
ADD CONSTRAINT FK_Actores_ContextoId
FOREIGN KEY (ContextoId)
REFERENCES Contextos (id)

ALTER TABLE Actores
ADD CONSTRAINT FK_Actores_TipoDeActorId
FOREIGN KEY (TipoDeActorId)
REFERENCES TiposDeActores (id)
-- FK-TABLA: Actores - FIN




-- FK-TABLA: Archivos - INICIO
ALTER TABLE Archivos
ADD CONSTRAINT FK_Archivos_ContextoId
FOREIGN KEY (ContextoId)
REFERENCES Contextos (id)

ALTER TABLE Archivos
ADD CONSTRAINT FK_Archivos_TablaId
FOREIGN KEY (TablaId)
REFERENCES Tablas (id)

--ALTER TABLE Archivos
--ADD CONSTRAINT FK_Archivos_UbicacionId
--FOREIGN KEY (UbicacionId)
--REFERENCES Ubicaciones (id)

ALTER TABLE Archivos
ADD CONSTRAINT FK_Archivos_ExtensionDeArchivoId
FOREIGN KEY (ExtensionDeArchivoId)
REFERENCES ExtensionesDeArchivos (id)
-- FK-TABLA: Archivos - FIN




-- FK-TABLA: CategoriasDeInformes - INICIO
ALTER TABLE CategoriasDeInformes
ADD CONSTRAINT FK_CategoriasDeInformes_ContextoId
FOREIGN KEY (ContextoId)
REFERENCES Contextos (id)
-- FK-TABLA: CategoriasDeInformes - FIN




-- FK-TABLA: Contactos - INICIO
ALTER TABLE Contactos
ADD CONSTRAINT FK_Contactos_ContextoId
FOREIGN KEY (ContextoId)
REFERENCES Contextos (id)
-- FK-TABLA: Contactos - FIN




-- FK-TABLA: Contextos - INICIO
 --
-- FK-TABLA: Contextos - FIN




-- FK-TABLA: CuentasDeEnvios - INICIO
--
-- FK-TABLA: CuentasDeEnvios - FIN




-- FK-TABLA: Dispositivos - INICIO
ALTER TABLE Dispositivos
ADD CONSTRAINT FK_Dispositivos_AsignadoAUsuarioId
FOREIGN KEY (AsignadoAUsuarioId)
REFERENCES Usuarios (id)
-- FK-TABLA: Dispositivos - FIN




-- FK-TABLA: EnviosDeCorreos - INICIO
ALTER TABLE EnviosDeCorreos
ADD CONSTRAINT FK_EnviosDeCorreos_UsuarioOriginanteId
FOREIGN KEY (UsuarioOriginanteId)
REFERENCES Usuarios (id)

ALTER TABLE EnviosDeCorreos
ADD CONSTRAINT FK_EnviosDeCorreos_UsuarioDestinatarioId
FOREIGN KEY (UsuarioDestinatarioId)
REFERENCES Usuarios (id)

ALTER TABLE EnviosDeCorreos
ADD CONSTRAINT FK_EnviosDeCorreos_TablaId
FOREIGN KEY (TablaId)
REFERENCES Tablas (id)
-- FK-TABLA: EnviosDeCorreos - FIN




-- FK-TABLA: EstadosDeLogErrores - INICIO
	--
-- FK-TABLA: EstadosDeLogErrores - INICIO




-- FK-TABLA: EstadosDeSoportes - INICIO
	--
-- FK-TABLA: EstadosDeSoportes - INICIO




-- FK-TABLA: EstadosDeTareas - INICIO
	--
-- FK-TABLA: EstadosDeTareas - INICIO




-- FK-TABLA: ExtensionesDeArchivos - INICIO
ALTER TABLE ExtensionesDeArchivos
ADD CONSTRAINT FK_ExtensionesDeArchivos_IconoId
FOREIGN KEY (IconoId)
REFERENCES Iconos (id)

ALTER TABLE ExtensionesDeArchivos
ADD CONSTRAINT FK_ExtensionesDeArchivos_TipoDeArchivoId
FOREIGN KEY (TipoDeArchivoId)
REFERENCES TiposDeArchivos (id)
-- FK-TABLA: ExtensionesDeArchivos - FIN




-- FK-TABLA: FuncionesDePaginas - INICIO
	--
-- FK-TABLA: FuncionesDePaginas - FIN




-- FK-TABLA: GruposDeContactos - INICIO
ALTER TABLE GruposDeContactos
ADD CONSTRAINT FK_GruposDeContactos_ContextoId
FOREIGN KEY (ContextoId)
REFERENCES Contextos (id)
-- FK-TABLA: GruposDeContactos - FIN




-- FK-TABLA: Iconos - INICIO
--ALTER TABLE Iconos
--ADD CONSTRAINT FK_Iconos_UbicacionId
--FOREIGN KEY (UbicacionId)
--REFERENCES Ubicaciones (id)
-- FK-TABLA: Iconos - FIN




-- FK-TABLA: IconosCSS - INICIO
	--
-- FK-TABLA: IconosCSS - FIN




-- FK-TABLA: Importaciones - INICIO
ALTER TABLE Importaciones
ADD CONSTRAINT FK_Importaciones_ContextoId
FOREIGN KEY (ContextoId)
REFERENCES Contextos (id)

ALTER TABLE Importaciones
ADD CONSTRAINT FK_Importaciones_UsuarioQueImportaId
FOREIGN KEY (UsuarioQueImportaId)
REFERENCES Usuarios (id)

ALTER TABLE Importaciones
ADD CONSTRAINT FK_Importaciones_TablaId
FOREIGN KEY (TablaId)
REFERENCES Tablas (id)
-- FK-TABLA: Importaciones - FIN




-- FK-TABLA: ImportanciasDeTareas - INICIO
	--
-- FK-TABLA: ImportanciasDeTareas - FIN




-- FK-TABLA: Informes - INICIO
ALTER TABLE Informes
ADD CONSTRAINT FK_Informes_ContextoId
FOREIGN KEY (ContextoId)
REFERENCES Contextos (id)

ALTER TABLE Informes
ADD CONSTRAINT FK_Informes_UsuarioId
FOREIGN KEY (UsuarioId)
REFERENCES Usuarios (id)

ALTER TABLE Informes
ADD CONSTRAINT FK_Informes_CategoriaDeInformeId
FOREIGN KEY (CategoriaDeInformeId)
REFERENCES CategoriasDeInformes (id)
-- FK-TABLA: Informes - FIN




-- FK-TABLA: LogEnviosDeCorreos - INICIO
ALTER TABLE LogEnviosDeCorreos
ADD CONSTRAINT FK_LogEnviosDeCorreos_EnvioDeCorreoId
FOREIGN KEY (EnvioDeCorreoId)
REFERENCES EnviosDeCorreos (id)
-- FK-TABLA: LogEnviosDeCorreos - FIN




-- FK-TABLA: LogErrores - INICIO
	-- Ahora vamos a permitir q no haya FK ya que cuando se crean Usuarios dentro de una TRAN y luego salta el error en otro lado --> ROLLBACK --> No registraba el Error por que no le dejaba la FK de Usuarios.
--ALTER TABLE LogErrores ADD CONSTRAINT FK_LogErrores_UsuarioQueEjecutaId FOREIGN KEY (UsuarioQueEjecutaId) REFERENCES Usuarios (id)

ALTER TABLE LogErrores
ADD CONSTRAINT FK_LogErrores_TablaId
FOREIGN KEY (TablaId)
REFERENCES Tablas (id)

ALTER TABLE LogErrores
ADD CONSTRAINT FK_LogErrores_TipoDeOperacionId
FOREIGN KEY (TipoDeOperacionId)
REFERENCES TiposDeOperaciones (id)

ALTER TABLE LogErrores
ADD CONSTRAINT FK_LogErrores_PaginaId
FOREIGN KEY (PaginaId)
REFERENCES Paginas (id)

ALTER TABLE LogErrores
ADD CONSTRAINT FK_LogErrores_EstadoDeLogErrorId
FOREIGN KEY (EstadoDeLogErrorId)
REFERENCES EstadosDeLogErrores (id)
-- FK-TABLA: LogErrores - FIN




-- FK-TABLA: LogErroresApp - INICIO
ALTER TABLE LogErroresApp
ADD CONSTRAINT FK_LogErroresApp_UsuarioId
FOREIGN KEY (UsuarioId)
REFERENCES Usuarios (id)
-- FK-TABLA: LogErroresApp - FIN




-- FK-TABLA: LogLogins - INICIO
ALTER TABLE LogLogins
ADD CONSTRAINT FK_LogLogins_UsuarioId
FOREIGN KEY (UsuarioId)
REFERENCES Usuarios (id)

ALTER TABLE LogLogins
ADD CONSTRAINT FK_LogLogins_TipoDeLogLoginId
FOREIGN KEY (TipoDeLogLoginId)
REFERENCES TiposDeLogLogins (id)

ALTER TABLE LogLogins
ADD CONSTRAINT FK_LogLogins_DispositivoId
FOREIGN KEY (DispositivoId)
REFERENCES Dispositivos (id)
-- FK-TABLA: LogLogins - FIN




-- FK-TABLA: LogLoginsDeDispositivos - INICIO
ALTER TABLE LogLoginsDeDispositivos
ADD CONSTRAINT FK_LogLoginsDeDispositivos_DispositivoId
FOREIGN KEY (DispositivoId)
REFERENCES Dispositivos (id)

ALTER TABLE LogLoginsDeDispositivos
ADD CONSTRAINT FK_LogLoginsDeDispositivos_UsuarioId
FOREIGN KEY (UsuarioId)
REFERENCES Usuarios (id)
-- FK-TABLA: LogLoginsDeDispositivos - FIN




-- FK-TABLA: LogLoginsDeDispositivosRechazados - INICIO
ALTER TABLE LogLoginsDeDispositivosRechazados
ADD CONSTRAINT FK_LogLoginsDeDispositivosRechazados_DispositivoId
FOREIGN KEY (DispositivoId)
REFERENCES Dispositivos (id)

ALTER TABLE LogLoginsDeDispositivosRechazados
ADD CONSTRAINT FK_LogLoginsDeDispositivosRechazados_UsuarioId
FOREIGN KEY (UsuarioId)
REFERENCES Usuarios (id)
-- FK-TABLA: LogLoginsDeDispositivosRechazados - FIN




-- FK-TABLA: LogRegistros - INICIO
ALTER TABLE LogRegistros
ADD CONSTRAINT FK_LogRegistros_UsuarioQueEjecutaId
FOREIGN KEY (UsuarioQueEjecutaId)
REFERENCES Usuarios (id)

ALTER TABLE LogRegistros
ADD CONSTRAINT FK_LogRegistros_TablaId
FOREIGN KEY (TablaId)
REFERENCES Tablas (id)

ALTER TABLE LogRegistros
ADD CONSTRAINT FK_LogRegistros_LogLoginDeDispositivoId
FOREIGN KEY (LogLoginDeDispositivoId)
REFERENCES LogLoginsDeDispositivos (id)

ALTER TABLE LogRegistros
ADD CONSTRAINT FK_LogRegistros_TipoDeOperacionId
FOREIGN KEY (TipoDeOperacionId)
REFERENCES TiposDeOperaciones (id)
-- FK-TABLA: LogRegistros - FIN




-- FK-TABLA: Notas - INICIO
ALTER TABLE Notas
ADD CONSTRAINT FK_Notas_ContextoId
FOREIGN KEY (ContextoId)
REFERENCES Contextos (id)

ALTER TABLE Notas
ADD CONSTRAINT FK_Notas_UsuarioId
FOREIGN KEY (UsuarioId)
REFERENCES Usuarios (id)

ALTER TABLE Notas
ADD CONSTRAINT FK_Notas_IconoCSSId
FOREIGN KEY (IconoCSSId)
REFERENCES IconosCSS (id)
-- FK-TABLA: Notas - FIN




-- FK-TABLA: Notificaciones - INICIO
ALTER TABLE Notificaciones ADD CONSTRAINT FK_Notificaciones_ContextoId FOREIGN KEY (ContextoId) REFERENCES Contextos (id)
ALTER TABLE Notificaciones ADD CONSTRAINT FK_Notificaciones_UsuarioDestinatarioId FOREIGN KEY (UsuarioDestinatarioId) REFERENCES Usuarios (id)
ALTER TABLE Notificaciones ADD CONSTRAINT FK_Notificaciones_TablaId FOREIGN KEY (TablaId) REFERENCES Tablas (id)
ALTER TABLE Notificaciones ADD CONSTRAINT FK_Notificaciones_SeccionId FOREIGN KEY (SeccionId) REFERENCES Secciones (id)
ALTER TABLE Notificaciones ADD CONSTRAINT FK_Notificaciones_IconoCSSId FOREIGN KEY (IconoCSSId) REFERENCES IconosCSS (id)
-- FK-TABLA: Notificaciones - FIN




-- FK-TABLA: Paginas - INICIO
ALTER TABLE Paginas ADD CONSTRAINT FK_Paginas_SeccionId FOREIGN KEY (SeccionId) REFERENCES Secciones (id)

ALTER TABLE Paginas ADD CONSTRAINT FK_Paginas_TablaId FOREIGN KEY (TablaId) REFERENCES Tablas (id)

ALTER TABLE Paginas ADD CONSTRAINT FK_Paginas_FuncionDePaginaId FOREIGN KEY (FuncionDePaginaId) REFERENCES FuncionesDePaginas (id)
-- FK-TABLA: Paginas - FIN




-- FK-TABLA: ParametrosDelSistema - INICIO
	--
-- FK-TABLA: ParametrosDelSistema - FIN




-- FK-TABLA: PrioridadesDeSoportes - INICIO
	--
-- FK-TABLA: PrioridadesDeSoportes - FIN




-- FK-TABLA: Publicaciones - INICIO
	--
-- FK-TABLA: Publicaciones - FIN




-- FK-TABLA: RecorridosDeDispositivos - INICIO
ALTER TABLE RecorridosDeDispositivos
ADD CONSTRAINT FK_RecorridosDeDispositivos_ContextoId
FOREIGN KEY (ContextoId)
REFERENCES Contextos (id)

ALTER TABLE RecorridosDeDispositivos
ADD CONSTRAINT FK_RecorridosDeDispositivos_DispositivoId
FOREIGN KEY (DispositivoId)
REFERENCES Dispositivos (id)

ALTER TABLE RecorridosDeDispositivos
ADD CONSTRAINT FK_RecorridosDeDispositivos_UsuarioId
FOREIGN KEY (UsuarioId)
REFERENCES Usuarios (id)
-- FK-TABLA: RecorridosDeDispositivos - FIN




-- FK-TABLA: Recursos - INICIO
ALTER TABLE Recursos
ADD CONSTRAINT FK_Recursos_ContextoId
FOREIGN KEY (ContextoId)
REFERENCES Contextos (id)
-- FK-TABLA: Recursos - FIN




-- FK-TABLA: RelAsig_Contactos_A_GruposDeContactos - INICIO
ALTER TABLE RelAsig_Contactos_A_GruposDeContactos
ADD CONSTRAINT FK_RelAsig_Contactos_A_GruposDeContactos_ContactoId
FOREIGN KEY (ContactoId)
REFERENCES Contactos (Id)

ALTER TABLE RelAsig_Contactos_A_GruposDeContactos
ADD CONSTRAINT FK_RelAsig_Contactos_A_GruposDeContactos_GrupoDeContactoId
FOREIGN KEY (GrupoDeContactoId)
REFERENCES GruposDeContactos (Id)
-- FK-TABLA: RelAsig_Contactos_A_GruposDeContactos - FIN




-- FK-TABLA: RelAsig_Contactos_A_TiposDeContactos - INICIO
ALTER TABLE RelAsig_Contactos_A_TiposDeContactos
ADD CONSTRAINT FK_RelAsig_Contactos_A_TiposDeContactos_ContactoId
FOREIGN KEY (ContactoId)
REFERENCES Contactos (Id)

ALTER TABLE RelAsig_Contactos_A_TiposDeContactos
ADD CONSTRAINT FK_RelAsig_Contactos_A_TiposDeContactos_TipoDeContactoId
FOREIGN KEY (TipoDeContactoId)
REFERENCES TiposDeContactos (Id)
-- FK-TABLA: RelAsig_Contactos_A_TiposDeContactos - FIN




-- FK-TABLA: RelAsig_CuentasDeEnvios_A_Tablas - INICIO
ALTER TABLE RelAsig_CuentasDeEnvios_A_Tablas
ADD CONSTRAINT FK_RelAsig_CuentasDeEnvios_A_Tablas_ContextoId
FOREIGN KEY (ContextoId)
REFERENCES Contextos (Id)

ALTER TABLE RelAsig_CuentasDeEnvios_A_Tablas
ADD CONSTRAINT FK_RelAsig_CuentasDeEnvios_A_Tablas_CuentaDeEnvioId
FOREIGN KEY (CuentaDeEnvioId)
REFERENCES CuentasDeEnvios (Id)

ALTER TABLE RelAsig_CuentasDeEnvios_A_Tablas
ADD CONSTRAINT FK_RelAsig_CuentasDeEnvios_A_Tablas_TablaId
FOREIGN KEY (TablaId)
REFERENCES Tablas (Id)
-- FK-TABLA: RelAsig_CuentasDeEnvios_A_Tablas - FIN




-- FK-TABLA: RelAsig_RolesDeUsuarios_A_Paginas - INICIO
ALTER TABLE RelAsig_RolesDeUsuarios_A_Paginas
ADD CONSTRAINT FK_RelAsig_RolesDeUsuarios_A_Paginas_RolDeUsuarioId
FOREIGN KEY (RolDeUsuarioId)
REFERENCES RolesDeUsuarios (id)

ALTER TABLE RelAsig_RolesDeUsuarios_A_Paginas
ADD CONSTRAINT FK_RelAsig_RolesDeUsuarios_A_Paginas_PaginaId
FOREIGN KEY (PaginaId)
REFERENCES Paginas (id)
-- FK-TABLA: RelAsig_RolesDeUsuarios_A_Paginas - FIN




-- FK-TABLA: RelAsig_RolesDeUsuarios_A_Usuarios - INICIO
ALTER TABLE RelAsig_RolesDeUsuarios_A_Usuarios
ADD CONSTRAINT FK_RelAsig_RolesDeUsuarios_A_Usuarios_RolDeUsuarioId
FOREIGN KEY (RolDeUsuarioId)
REFERENCES RolesDeUsuarios (Id)

ALTER TABLE RelAsig_RolesDeUsuarios_A_Usuarios
ADD CONSTRAINT FK_RelAsig_RolesDeUsuarios_A_Usuarios_UsuarioId
FOREIGN KEY (UsuarioId)
REFERENCES Usuarios (Id)
-- FK-TABLA: RelAsig_RolesDeUsuarios_A_Usuarios - FIN




-- FK-TABLA: RelAsig_Subsistemas_A_Publicaciones - INICIO
ALTER TABLE RelAsig_Subsistemas_A_Publicaciones
ADD CONSTRAINT FK_RelAsig_Subsistemas_A_Publicaciones_SubsistemaId
FOREIGN KEY (SubsistemaId)
REFERENCES Subsistemas (Id)

ALTER TABLE RelAsig_Subsistemas_A_Publicaciones
ADD CONSTRAINT FK_RelAsig_Subsistemas_A_Publicaciones_PublicacionId
FOREIGN KEY (PublicacionId)
REFERENCES Publicaciones (Id)

ALTER TABLE RelAsig_Subsistemas_A_Publicaciones
ADD CONSTRAINT FK_RelAsig_Subsistemas_A_Publicaciones_UsuarioId
FOREIGN KEY (UsuarioId)
REFERENCES Usuarios (Id)
-- FK-TABLA: RelAsig_Subsistemas_A_Publicaciones - FIN




-- FK-TABLA: RelAsig_TiposDeContactos_A_Contextos - INICIO
ALTER TABLE RelAsig_TiposDeContactos_A_Contextos
ADD CONSTRAINT FK_RelAsig_TiposDeContactos_A_Contextos_TipoDeContactoId
FOREIGN KEY (TipoDeContactoId)
REFERENCES TiposDeContactos (Id)

ALTER TABLE RelAsig_TiposDeContactos_A_Contextos
ADD CONSTRAINT FK_RelAsig_TiposDeContactos_A_Contextos_ContextoId
FOREIGN KEY (ContextoId)
REFERENCES Contextos (Id)
-- FK-TABLA: RelAsig_TiposDeContactos_A_Contextos - FIN




-- FK-TABLA: RelAsig_Usuarios_A_Recursos - INICIO
ALTER TABLE RelAsig_Usuarios_A_Recursos
ADD CONSTRAINT FK_RelAsig_Usuarios_A_Recursos_UsuarioId
FOREIGN KEY (UsuarioId)
REFERENCES Usuarios (Id)

ALTER TABLE RelAsig_Usuarios_A_Recursos
ADD CONSTRAINT FK_RelAsig_Usuarios_A_Recursos_RecursoId
FOREIGN KEY (RecursoId)
REFERENCES Recursos (Id)
-- FK-TABLA: RelAsig_Usuarios_A_Recursos - FIN




-- FK-TABLA: ReservasDeRecursos - INICIO
ALTER TABLE ReservasDeRecursos
ADD CONSTRAINT FK_ReservasDeRecursos_ContextoId
FOREIGN KEY (ContextoId)
REFERENCES Contextos (id)

ALTER TABLE ReservasDeRecursos
ADD CONSTRAINT FK_ReservasDeRecursos_UsuarioOriginanteId
FOREIGN KEY (UsuarioOriginanteId)
REFERENCES Usuarios (id)

ALTER TABLE ReservasDeRecursos
ADD CONSTRAINT FK_ReservasDeRecursos_UsuarioDestinatarioId
FOREIGN KEY (UsuarioDestinatarioId)
REFERENCES Usuarios (id)

ALTER TABLE ReservasDeRecursos
ADD CONSTRAINT FK_ReservasDeRecursos_RecursoId
FOREIGN KEY (RecursoId)
REFERENCES Recursos (id)
-- FK-TABLA: ReservasDeRecursos - FIN




-- FK-TABLA: RolesDeUsuarios - INICIO
--
-- FK-TABLA: RolesDeUsuarios - FIN




-- FK-TABLA: Secciones - INICIO
--
-- FK-TABLA: Secciones - FIN




-- FK-TABLA: Soportes - INICIO
ALTER TABLE Soportes
ADD CONSTRAINT FK_Soportes_ContextoId
FOREIGN KEY (ContextoId)
REFERENCES Contextos (id)

ALTER TABLE Soportes
ADD CONSTRAINT FK_Soportes_UsuarioQueSolicitaId
FOREIGN KEY (UsuarioQueSolicitaId)
REFERENCES Usuarios (id)

ALTER TABLE Soportes
ADD CONSTRAINT FK_Soportes_UsuarioQueCerroId
FOREIGN KEY (UsuarioQueCerroId)
REFERENCES Usuarios (id)

ALTER TABLE Soportes
ADD CONSTRAINT FK_Soportes_EstadoDeSoportesId
FOREIGN KEY (EstadoDeSoportesId)
REFERENCES EstadosDeSoportes (id)

ALTER TABLE Soportes
ADD CONSTRAINT FK_Soportes_PrioridadDeSoporteId
FOREIGN KEY (PrioridadDeSoporteId)
REFERENCES PrioridadesDeSoportes (id)
-- FK-TABLA: Soportes - FIN




-- FK-TABLA: SPs - INICIO
--
-- FK-TABLA: SPs - FIN




-- FK-TABLA: Subsistemas - INICIO
--
-- FK-TABLA: Subsistemas - FIN




-- FK-TABLA: Tablas - INICIO
ALTER TABLE Tablas
ADD CONSTRAINT FK_Tablas_IconoCSSId
FOREIGN KEY (IconoCSSId)
REFERENCES IconosCSS (id)
-- FK-TABLA: Tablas - FIN




-- FK-TABLA: TablasYFuncionesDePaginas - INICIO
ALTER TABLE TablasYFuncionesDePaginas ADD CONSTRAINT FK_TablasYFuncionesDePaginas_TablaId FOREIGN KEY (TablaId) REFERENCES Tablas (id)
ALTER TABLE TablasYFuncionesDePaginas ADD CONSTRAINT FK_TablasYFuncionesDePaginas_FuncionDePaginaId FOREIGN KEY (FuncionDePaginaId) REFERENCES FuncionesDePaginas (id)
-- FK-TABLA: TablasYFuncionesDePaginas - FIN




-- FK-TABLA: Tareas - INICIO
ALTER TABLE Tareas
ADD CONSTRAINT FK_Tareas_ContextoId
FOREIGN KEY (ContextoId)
REFERENCES Contextos (id)

ALTER TABLE Tareas
ADD CONSTRAINT FK_Tareas_UsuarioOriginanteId
FOREIGN KEY (UsuarioOriginanteId)
REFERENCES Usuarios (id)

ALTER TABLE Tareas
ADD CONSTRAINT FK_Tareas_UsuarioDestinatarioId
FOREIGN KEY (UsuarioDestinatarioId)
REFERENCES Usuarios (id)

ALTER TABLE Tareas
ADD CONSTRAINT FK_Tareas_TipoDeTareaId
FOREIGN KEY (TipoDeTareaId)
REFERENCES TiposDeTareas (id)

ALTER TABLE Tareas
ADD CONSTRAINT FK_Tareas_EstadoDeTareaId
FOREIGN KEY (EstadoDeTareaId)
REFERENCES EstadosDeTareas (id)

ALTER TABLE Tareas
ADD CONSTRAINT FK_Tareas_ImportanciaDeTareaId
FOREIGN KEY (ImportanciaDeTareaId)
REFERENCES ImportanciasDeTareas (id)

ALTER TABLE Tareas
ADD CONSTRAINT FK_Tareas_TablaId
FOREIGN KEY (TablaId)
REFERENCES Tablas (id)
-- FK-TABLA: Tareas - FIN




-- FK-TABLA: TiposDeActores - INICIO
--
-- FK-TABLA: TiposDeActores - FIN




-- FK-TABLA: TiposDeArchivos - INICIO
	--
-- FK-TABLA: TiposDeArchivos - FIN




-- FK-TABLA: TiposDeContactos - INICIO
	--
-- FK-TABLA: TiposDeContactos - FIN




-- FK-TABLA: TiposDeLogLogins - INICIO
--
-- FK-TABLA: TiposDeLogLogins - FIN




-- FK-TABLA: TiposDeOperaciones - INICIO
--
-- FK-TABLA: TiposDeOperaciones - FIN




-- FK-TABLA: TiposDeTareas - INICIO
ALTER TABLE TiposDeTareas
ADD CONSTRAINT FK_TiposDeTareas_ContextoId
FOREIGN KEY (ContextoId)
REFERENCES Contextos (id)
-- FK-TABLA: TiposDeTareas - FIN




-- FK-TABLA: Ubicaciones - INICIO
--
-- FK-TABLA: Ubicaciones - FIN




-- FK-TABLA: Usuarios - INICIO
ALTER TABLE Usuarios ADD CONSTRAINT FK_Usuarios_ContextoId FOREIGN KEY (ContextoId) REFERENCES Contextos (id)
ALTER TABLE Usuarios ADD CONSTRAINT FK_Usuarios_ArchivoDeFotoId FOREIGN KEY (ArchivoDeFotoId) REFERENCES Archivos (id)
--ALTER TABLE Usuarios ADD CONSTRAINT FK_Usuarios_ActorId FOREIGN KEY (ActorId) REFERENCES Actores (id)
-- FK-TABLA: Usuarios - FIN




-- ---------------------------------
-- Script: DB_ParticularCore__C03__Create FK.sql - FIN
-- =====================================================
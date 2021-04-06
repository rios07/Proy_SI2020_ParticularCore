-- =====================================================
-- Descripción: Insertamos valor prioritarios, sin los cuales el sistema no funciona.
-- Script: DB_ParticularCore__19a_Insert Values del Sistema_Prioritarios 1 - Roles y Pre Tablas.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO

				-- Variable que utilizamos en los insert - INICIO
					DECLARE @UsuarioQueEjecutaId INT = '1' -- OJO, q si va UsuarioId=1 -- > VA EN ContextoId=1 --> no logueable
						,@FechaDeEjecucion DATETIME = GetDate()
						,@sResSQL VARCHAR(1000)	
						,@id INT
						,@ContextoId_SinContexto INT
						,@TablaId INT
						,@FuncionDePaginaId INT
						,@PaginaId INT
						,@RolDeUsuarioId INT
						,@Nombre VARCHAR(100)
						,@Mensaje VARCHAR(MAX)
						,@TablaDelExec VARCHAR(80)
				-- Variable que utilizamos en los insert - FIN
				
				
-- INSERT VALUES: Contextos - INICIO
	PRINT 'Insertando Contextos'
	INSERT INTO Contextos (Numero, Nombre, Codigo, CarpetaDeContenidos) VALUES ('1', 'Sin Contexto', 'SinContexto', 'CarpSinContexto')
	SET @ContextoId_SinContexto = (SELECT id FROM Contextos WHERE Codigo = 'SinContexto')
	SELECT * FROM Contextos
-- INSERT VALUES: Contextos - FIN




-- INSERT VALUES: FuncionesDePaginas - INICIO
	PRINT 'Insertando FuncionesDePaginas'
	-- El 'Eliminar' o Activar/Desactivar de un registro no es una página, y el permiso se resuelve con el PermiteOperar de la Pagina 'Registro'
	-- El 'Exportar' de un registro no es una página, y el permiso se resuelve con el PermiteOperar de la Pagina de Listado en cuestión.
	-- El 'Enviar' de un registro no es una página, y el permiso se resuelve con el PermiteOperar de la Pagina de Listado en cuestión.
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('1', 'Sin Página', ' -Sin Página-', 'Para funcionalidades no asociadas a páginas', '0', '1', '0')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('2', 'Inicio', 'Página de Bienvenida', '', '0', '1', '0')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('3', 'Insert', 'Agregar un registro', '', '1', '1', '0')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('4', 'Registro', 'Registro seleccionado', '', '1', '1', '1')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('5', 'Update', 'Actualizar los datos de un registro', '', '1', '1', '1')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('6', 'Listado', 'Listado', '', '1', '1', '0')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('7', 'ListadoAvanzado', 'Listado avanzado', '', '1', '1', '0')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('8', 'ListadoDeControl', 'Listado de control', '', '0', '1', '0')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('9', 'CambiarPassword', 'Cambio de contraseña', '', '0', '1', '1')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('10', 'ResetPassword', 'Reseteo de contraseña', '', '0', '1', '1')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('11', 'Grafico', 'Gráficos', '', '0', '1', '0')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('12', 'Tablero', 'Tablero de resultados', '', '0', '1', '0')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('13', 'Mapa', 'Mapa', '', '0', '1', '0')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('14', 'ListadoDDL', 'Listado DDL', '', '0', '0', '0') -- No se evalúan permisos. 
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('15', 'Login', 'Inicio de Sesion', '', '0', '1', '0')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('16', 'Pendientes', 'Pendientes', 'Por ejemplo para envíos pendientes de correos', '0', '1', '0')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('17', 'TableroGeneral', 'TableroGeneral', '', '0', '1', '0')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('18', 'Enviar', 'Enviar', '', '0', '1', '0')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('19', 'Exportar', 'Exportar', '', '0', '1', '0')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('20', 'Diagrama', 'Diagrama', '', '0', '1', '0')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('21', 'SelectedAvanzado', 'Selected Avanzado', 'Selected con operaciones distintas, como modificar en un mapa, etc.', '0', '1', '0')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('22', 'MapaAvanzado', 'Mapa Avanzado', 'Un mapa con funcionalidades de Filtros u otros.', '0', '1', '0')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('23', 'ListadoDeCostos', 'Listado de Costos', '', '0', '1', '0')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('24', 'Reporte', 'Reporte', '', '0', '1', '0')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('25', 'ReporteSSRS', 'ReporteSSRS', '', '0', '1', '0')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('26', 'Import', 'Importación de datos', '', '0', '1', '0')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('27', 'Delete', 'Eliminar un registro', '', '0', '1', '0')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('28', 'Anular', 'Anula un registro', '', '0', '1', '0')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('29', 'Activar', 'Activa un registro', '', '0', '1', '0')
	INSERT INTO FuncionesDePaginas (id, Nombre, NombreAMostrar, Observaciones, GeneraPagina, SeDebenEvaluarPermisos, EsUnaConRegistro) VALUES ('30', 'CargarHistoria', 'Carga la historia de un registro', '', '0', '0', '0')
	SELECT * FROM FuncionesDePaginas
-- INSERT VALUES: FuncionesDePaginas - FIN




-- ESTO LO CARGAMOS DE INICIO, DEJARLO ACÁ AUNQUE NO ESTÉ POR ABC
	-- ARRANCO CON LOS ROLES p/PODER ARGREGAR USUARIOS
	-- INSERT VALUES: RolesDeUsuarios - INICIO
	-- La prioridad la utilizamos p la asignación de permisos
	PRINT 'Insertando RolesDeUsuarios'
	INSERT INTO RolesDeUsuarios (id, Nombre, NombreAMostrar, Observaciones, Prioridad, SeMuestraEnAsignacionDePermisos, SeMuestraEnAsignacionDeRoles, DeCore) VALUES ('1', 'MasterAdmin', 'Master Admin', 'Solo para los Desarrolladores del Sistema.', '100', 'False', 'False', 'True')
	INSERT INTO RolesDeUsuarios (id, Nombre, NombreAMostrar, Observaciones, Prioridad, SeMuestraEnAsignacionDePermisos, SeMuestraEnAsignacionDeRoles, DeCore) VALUES ('2', 'Administrador', 'Administrador', 'No accede a páginas exclusivas del MasterAdmin; Para el resto: Administración completa de las funcionalidades ofrecidas.', '200', 'False', 'False', 'True')
	INSERT INTO RolesDeUsuarios (id, Nombre, NombreAMostrar, Observaciones, Prioridad, SeMuestraEnAsignacionDePermisos, SeMuestraEnAsignacionDeRoles, DeCore) VALUES ('3', 'Supervisor', 'Supervisor', 'Operador Avanzado, que además permite la planificación y consulta de todo el sitio.', '300', 'True', 'True', 'True')
	INSERT INTO RolesDeUsuarios (id, Nombre, NombreAMostrar, Observaciones, Prioridad, SeMuestraEnAsignacionDePermisos, SeMuestraEnAsignacionDeRoles, DeCore) VALUES ('4', 'OperadorAvanzado', 'Operador Avanzado', 'Operador con algunas atribuciones de administrador.', '400', 'True', 'True', 'True')
	INSERT INTO RolesDeUsuarios (id, Nombre, NombreAMostrar, Observaciones, Prioridad, SeMuestraEnAsignacionDePermisos, SeMuestraEnAsignacionDeRoles, DeCore) VALUES ('5', 'Operador', 'Operador', 'Operador de las funciones cotidianas de trabajo.', '500', 'True', 'True', 'True')
	INSERT INTO RolesDeUsuarios (id, Nombre, NombreAMostrar, Observaciones, Prioridad, SeMuestraEnAsignacionDePermisos, SeMuestraEnAsignacionDeRoles, DeCore) VALUES ('6', 'Consultor', 'Consultor', 'Permite la consulta general de las paginas de acceso del Operador, pero no la operación de las funciones cotidianas de trabajo.', '600', 'True', 'True', 'True')
	INSERT INTO RolesDeUsuarios (id, Nombre, NombreAMostrar, Observaciones, Prioridad, SeMuestraEnAsignacionDePermisos, SeMuestraEnAsignacionDeRoles, DeCore) VALUES ('7', 'Visitante', 'Visitante', 'Solo Podrá Consultar algunas páginas específicas, pero ninguna operación.', '700', 'True', 'True', 'True')
	INSERT INTO RolesDeUsuarios (id, Nombre, NombreAMostrar, Observaciones, Prioridad, SeMuestraEnAsignacionDePermisos, SeMuestraEnAsignacionDeRoles, DeCore) VALUES ('8', 'SoloLogin', 'Solo Login', 'Para C/ Usuario Creado, Para q funque el INNER JOIN.', '800', 'False', 'False', 'True')
	-- Pondremos prioridad negativa a los roles especificos de tareas, como la de pedir soportes.
	INSERT INTO RolesDeUsuarios (id, Nombre, NombreAMostrar, Observaciones, Prioridad, SeMuestraEnAsignacionDePermisos, SeMuestraEnAsignacionDeRoles, DeCore) VALUES ('9', 'PedirSoportes', 'Pedir Soportes', 'Realizar, ver y gestionar pedidos de soporte.', '-100', 'False', 'False', 'True')
	INSERT INTO RolesDeUsuarios (id, Nombre, NombreAMostrar, Observaciones, Prioridad, SeMuestraEnAsignacionDePermisos, SeMuestraEnAsignacionDeRoles, DeCore) VALUES ('10', 'AdministrarSoportes', 'Administrar Soportes', 'Administrar, Realizar, ver y gestionar pedidos de soporte.', '-101', 'False', 'False', 'True')
	-- Prioridades < -1000 son para las particularidades P:
	-- Prioridades entre -100 y -1000 son para las particularidades C:
	INSERT INTO RolesDeUsuarios (id, Nombre, NombreAMostrar, Observaciones, Prioridad, SeMuestraEnAsignacionDePermisos, SeMuestraEnAsignacionDeRoles, DeCore) VALUES ('11', 'RecibeNotifPorModifUsuarios', 'Recibe notificaciones por modificaciones en usuarios', '', '-102', 'False', 'True', 'True')
	INSERT INTO RolesDeUsuarios (id, Nombre, NombreAMostrar, Observaciones, Prioridad, SeMuestraEnAsignacionDePermisos, SeMuestraEnAsignacionDeRoles, DeCore) VALUES ('12', 'RecibeNotifPorModifInformes', 'Recibe notificaciones por modificaciones en informes', '', '-103', 'False', 'True', 'True')
	
	SELECT * FROM RolesDeUsuarios
-- INSERT VALUES: RolesDeUsuarios - FIN




-- INSERT VALUES: TiposDeOperaciones - INICIO // LAS NECESITO ANTES QUE A LOS USUARIOS
	PRINT 'Insertando TiposDeOperaciones'
	INSERT INTO TiposDeOperaciones (id, Nombre, Texto, Observaciones) VALUES ('1', 'Generica', 'Generica', 'Tipo de Operación genérica del sistema')
	INSERT INTO TiposDeOperaciones (id, Nombre, Texto, Observaciones) VALUES ('2', 'Insert', 'Creado', 'Agregando un Registro')
	INSERT INTO TiposDeOperaciones (id, Nombre, Texto, Observaciones) VALUES ('3', 'Update', 'Actualizado', 'Modificando un registro')
	INSERT INTO TiposDeOperaciones (id, Nombre, Texto, Observaciones) VALUES ('4', 'Delete', 'Eliminado', 'Eliminando un registro')
	INSERT INTO TiposDeOperaciones (id, Nombre, Texto, Observaciones) VALUES ('5', 'Anular', 'Anulado', 'Anulando un registro')
	INSERT INTO TiposDeOperaciones (id, Nombre, Texto, Observaciones) VALUES ('6', 'Activar', 'Activado', 'Activando un registro')
	INSERT INTO TiposDeOperaciones (id, Nombre, Texto, Observaciones) VALUES ('7', 'Listado', 'Listado', 'Listando registro')
	INSERT INTO TiposDeOperaciones (id, Nombre, Texto, Observaciones) VALUES ('8', 'Registro', 'Seleccionado', 'Seleccionó un Registro')
	SELECT * FROM TiposDeOperaciones
-- INSERT VALUES: TiposDeOperaciones - FIN




-- INSERT VALUES: Usuarios - INICIO // No los puedo agregar con insert por que necesita las "Tablas" asociadas.
	PRINT 'Insertando Usuarios'
	DECLARE @UltimoLoginSesionId INT = RAND()*100000000 -- 8 digitos
	PRINT 'Insertando Usuario Sistema en Usuarios; id=1' -- Este no lo puedo agregar con SP x q no hay UsuarioQueEjecuta en el Sistema
	INSERT INTO Usuarios (ContextoId, UserName, Pass, Nombre, Apellido, UltimoLoginSesionId, SeMuestraEnAsignacionDeRoles) 
				VALUES (@ContextoId_SinContexto, 'SinUsuario', ' -  Que n0 sE pu3da loguear - !! ', 'Sin', 'Usuario', @UltimoLoginSesionId, '0')
	SELECT * FROM Usuarios
-- INSERT VALUES: Usuarios - FIN
-- INSERT VALUES RelAsig_RolesDeUsuarios_A_Usuarios: - INICIO  //  Los necesito para las tablas
	PRINT 'Insertando RelAsig_RolesDeUsuarios_A_Usuarios'
	-- Al Usuario-id=1 lo seteo como MasterAdmin para q tenga permisos en los SP q ejecutará
	INSERT INTO RelAsig_RolesDeUsuarios_A_Usuarios (RolDeUsuarioId, UsuarioId, FechaDesde) VALUES ('1', '1', @FechaDeEjecucion)
-- INSERT VALUES RelAsig_RolesDeUsuarios_A_Usuarios: - FIN

				
				

-- INSERT VALUES: CuentasDeEnvios - INICIO
	---- Agrego un par para poder testear
	--PRINT 'Insertando CuentasDeEnvios' -- Id = 1:
	--INSERT INTO CuentasDeEnvios (Nombre, CuentaDeEmail, PwdDeEmail, Smtp, Puerto, Observaciones) VALUES ('Email para tareas', 'tareas@sistemas.com', 'XXX', 'smtp.sistemas.com', '25', 'Para los envío de tareas.')
	----INSERT INTO CuentasDeEnvios (Nombre, CuentaDeEmail, PwdDeEmail, Smtp, Puerto, Observaciones) VALUES ('Email para ??', '??@sistemas.com', 'XXX', 'smtp.sistemas.com', '25', 'Para los envío de ??.')
	--SELECT * FROM CuentasDeEnvios
-- INSERT VALUES: CuentasDeEnvios - FIN




-- INSERT VALUES: Dispositivos - INICIO
	PRINT 'Insertando Dispositivos'
	INSERT INTO Dispositivos (MachineName, OSVersion, UserMachineName, AsignadoAUsuarioId) VALUES ('Sin Dispositivo', '', 'Sin Usuario', '1')
	SELECT * FROM Dispositivos
-- INSERT VALUES: Dispositivos - FIN




-- INSERT VALUES: LogLoginsDeDispositivos - INICIO // Lo necesito antes que las tablas
	PRINT 'Insertando LogLoginsDeDispositivos id = 1'
	INSERT INTO LogLoginsDeDispositivos (DispositivoId, UsuarioId, Token, FechaDeEjecucion, InicioValides, FinValidez) VALUES ('1', '1', 'sin token', @FechaDeEjecucion, @FechaDeEjecucion, @FechaDeEjecucion)
	SELECT * FROM LogLoginsDeDispositivos
-- INSERT VALUES: LogLoginsDeDispositivos - FIN




-- INSERT VALUES: EstadosDeLogErrores - INICIO
	PRINT 'Insertando EstadosDeLogErrores'
	INSERT INTO EstadosDeLogErrores (id, Nombre, Nomenclatura, Orden, Observaciones) VALUES ('1', 'Por revisar', 'PREV', '1', '')
	INSERT INTO EstadosDeLogErrores (id, Nombre, Nomenclatura, Orden, Observaciones) VALUES ('2', 'En revision', 'ENREV', '2', '')
	INSERT INTO EstadosDeLogErrores (id, Nombre, Nomenclatura, Orden, Observaciones) VALUES ('3', 'Solucionado', 'SOL', '3', '')
	SELECT * FROM EstadosDeLogErrores
-- INSERT VALUES: EstadosDeLogErrores - FIN




-- INSERT VALUES: EstadosDeSoportes - INICIO
	-- Pedidos Pendientes:
	PRINT 'Insertando EstadosDeSoportes: Pedidos Pendientes'
	INSERT INTO EstadosDeSoportes (id, Nombre, Nomenclatura, Orden, Observaciones) VALUES ('1', '1. Por revisar', 'POR REVISAR' ,'1', 'Pendiente. - El Pedido Continúa Pendiente.')
	INSERT INTO EstadosDeSoportes (id, Nombre, Nomenclatura, Orden, Observaciones) VALUES ('2', '2. En revisión', 'EN REVISION', '2', 'Lo estamos analizando. - El Pedido Continúa Pendiente.')
	INSERT INTO EstadosDeSoportes (id, Nombre, Nomenclatura, Orden, Observaciones) VALUES ('3', '3. Postergado por el Usuario', 'POS Usuario', '3', 'El usuario posterga la solución. El Pedido Continúa Pendiente.')
	INSERT INTO EstadosDeSoportes (id, Nombre, Nomenclatura, Orden, Observaciones) VALUES ('4', '4. Postergado por Soporte', 'POS Soporte', '4', 'Soportes posterga su solución; otras prioridades. El Pedido Continúa Pendiente.')
	INSERT INTO EstadosDeSoportes (id, Nombre, Nomenclatura, Orden, Observaciones) VALUES ('5', '5. Esperando Al Usuario', 'UsuarioAvisa', '5', 'El Usuario avisa cuando aplicar la solución. El Pedido Continúa Pendiente.')
	INSERT INTO EstadosDeSoportes (id, Nombre, Nomenclatura, Orden, Observaciones) VALUES ('6', '6. Solucion Programada', 'SOL PROGRAM', '6', 'Solución determinada; Se aplicará en otro momento. Pedido Continúa Pendiente.')
	-- Pedidos Cerrados:
	PRINT 'Insertando EstadosDeSoportes: Pedidos Cerrados'
	INSERT INTO EstadosDeSoportes (id, Nombre, Nomenclatura, Orden, Observaciones, CierraSoporte) VALUES ('7', '7. Resuelto por el Usuario', 'RESOLV USER', '7', 'El Usuario lo resolvió por su cuenta. - Se Cierra el Pedido.', 1)
	INSERT INTO EstadosDeSoportes (id, Nombre, Nomenclatura, Orden, Observaciones, CierraSoporte) VALUES ('8', '8. Sin Solucionar', 'SIN SOLUCION', '8', 'No tiene Solución. - Se Cierra el Pedido.', 1)
	INSERT INTO EstadosDeSoportes (id, Nombre, Nomenclatura, Orden, Observaciones, CierraSoporte) VALUES ('9', '9. Solucionado', 'SOLUCIONADO', '9', 'Se Cierra el Pedido proveyendo una solución.', 1)
	SELECT * FROM EstadosDeSoportes
-- INSERT VALUES: EstadosDeSoportes - FIN




-- INSERT VALUES: EstadosDeTareas - INICIO
	PRINT 'Insertando EstadosDeTareas'
	-- Asignada, Iniciada, Finalizada, Aplazada, Esperando Acción, Etc.
	INSERT INTO EstadosDeTareas (id, Nombre, Nomenclatura, Orden, Observaciones) VALUES ('1', '1. Asignada', '1-Asig' ,'10', 'La tarea se le ha asignado a un usaurio para que la realice.')
	INSERT INTO EstadosDeTareas (id, Nombre, Nomenclatura, Orden, Observaciones) VALUES ('2', '2. Iniciada', '2-Inic', '20', 'El usuario tomó conocimiento de la tarea, y la comenzó.')
	INSERT INTO EstadosDeTareas (id, Nombre, Nomenclatura, Orden, Observaciones) VALUES ('3', '3. Esperando Acción', '3-E.A.', '30', 'El usuario está esperando la acción de otro, o de algún suceso para poder continuar con la tarea.')
	INSERT INTO EstadosDeTareas (id, Nombre, Nomenclatura, Orden, Observaciones) VALUES ('4', '4. Aplazada', '4-Apl', '-10', 'La tarea ha sido aplazada y no se realizará por el momento.')
	INSERT INTO EstadosDeTareas (id, Nombre, Nomenclatura, Orden, Observaciones) VALUES ('5', '5. Finalizada', '5-Fin', '50', 'La tarea ha finalizado satisfactoriamente.')
	INSERT INTO EstadosDeTareas (id, Nombre, Nomenclatura, Orden, Observaciones) VALUES ('6', '6. Finalizada Sin Cumplir', '5-Fin-X', '100', 'La tarea ha finalizado, pero sin cumplir con el objetivo.')
	SELECT * FROM EstadosDeTareas
-- INSERT VALUES: EstadosDeTareas - FIN




-- INSERT VALUES: Iconos - INICIO
	PRINT 'Insertando Iconos'

	--id=1:
	INSERT INTO Iconos (Nombre, Imagen, Altura, Ancho, OffsetX, OffsetY, Observaciones) 
		VALUES ('Default', 'default.png', '22', '22', '0', '0', 'Archivo por defecto para todos los no reconocidos o indicados.')		
	SELECT * FROM Iconos 
-- INSERT VALUES: Iconos - FIN




-- INSERT VALUES: IconosCSS - INICIO -- Los necsito acá, por que los usan las tablas
	PRINT 'Insertando IconosCSS'
	--id=1: DEFAULT
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('Default-*', 'fa fa-asterisk', 'Archivo por defecto para todos los no reconocidos o indicados.')
				
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('Exclamación !', 'fa fa-exclamation', '')
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('Life Ring Gray', 'fa fa-life-ring color-gray-light', '')
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('Estrella', 'glyphicon glyphicon-star', '')
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('Ojo', 'fa fa-eye', '')
		
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('pencil square', 'fa fa-pencil-square', '')
	
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('Basic Pen', 'l-basic-todolist-pen', '')
		
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('Ojo Abierto', 'glyphicon glyphicon-eye-open', '')
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('Signo +', 'glyphicon glyphicon-plus-sign', '')
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('Lapiz', 'glyphicon glyphicon-pencil', '')
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('Libro', 'glyphicon glyphicon-book', '')
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('Candado Abierto', 'fa fa-unlock', '')
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('Candado Cerrado', 'fa fa-lock', '')
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('Cruz', 'glyphicon glyphicon-remove', '')
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('Persona', 'glyphicon glyphicon-user', '')
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('Grupo', 'fa fa-group', '')
	
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('Fuego', 'glyphicon glyphicon-fire', '')
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('Adjunto', 'glyphicon glyphicon-paperclipn', '')
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('Bloqueo', 'fa fa-ban', '')
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('Editar', 'fa fa-edit', '')
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('Borrar', 'fa fa-eraser', '')
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('Ticket', 'fa fa-ticket', '')
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('Comentario', 'fa fa-commenting', '')
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('software', 'l-software-transform-bezier', '')
	
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('warning', 'glyphicon glyphicon-warning-sign', '')
	
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('basicwarning', 'l l-basic-webpage-multiple', '')
	
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('webpage', 'l-basic-webpage-img-txt', '')
	
	INSERT INTO IconosCSS (Nombre, CSS, Observaciones) VALUES ('Soportes', 'fa fa-support', '')
	
	SELECT * FROM IconosCSS
-- INSERT VALUES: IconosCSS - FIN




-- INSERT VALUES: ImportanciasDeTareas - INICIO
	PRINT 'Insertando ImportanciasDeTareas'
	-- id=1 importancia "media", DEFAULT
	INSERT INTO ImportanciasDeTareas (id, Nombre, Nomenclatura, Orden, Observaciones) VALUES ('1', '2. Media', '2-Media' ,'20', 'Importancia normal, valor por defecto.')
	INSERT INTO ImportanciasDeTareas (id, Nombre, Nomenclatura, Orden, Observaciones) VALUES ('2', '1. Baja', '1-Baja', '10', 'Importancia baja.')
	INSERT INTO ImportanciasDeTareas (id, Nombre, Nomenclatura, Orden, Observaciones) VALUES ('3', '3. Alta', '3-Alta', '50', 'La mayor importancia.')
	SELECT * FROM ImportanciasDeTareas
-- INSERT VALUES: ImportanciasDeTareas - FIN
				



-- INSERT VALUES: PrioridadesDeSoportes - INICIO
	PRINT 'Insertando PrioridadesDeSoportes'
	INSERT INTO PrioridadesDeSoportes (id, Orden, Nombre, Observaciones) VALUES ('1', '100', 'Alta', '')
	INSERT INTO PrioridadesDeSoportes (id, Orden, Nombre, Observaciones) VALUES ('2', '50', 'Media', '')
	INSERT INTO PrioridadesDeSoportes (id, Orden, Nombre, Observaciones) VALUES ('3', '10', 'Baja', '')
	SELECT * FROM PrioridadesDeSoportes
-- INSERT VALUES: PrioridadesDeSoportes - FIN




---- INSERT VALUES RelAsig_CuentasDeEnvios_A_Tablas: - INICIO  (Necesitaba 1ero las Tablas)
--	PRINT 'Insertando RelAsig_CuentasDeEnvios_A_Tablas'
--	DECLARE @TablaDeTareasId AS INT = (SELECT id FROM Tablas WHERE Nombre = 'Tablas')
	
--	INSERT INTO RelAsig_CuentasDeEnvios_A_Tablas (ContextoId, CuentaDeEnvioId, TablaId) VALUES ('2', '1', @TablaDeTareasId)
--	SELECT * FROM RelAsig_CuentasDeEnvios_A_Tablas
------ INSERT VALUES RelAsig_CuentasDeEnvios_A_Tablas: - FIN
		
				


-- INSERT VALUES: Secciones - INICIO
	PRINT 'Insertando Secciones'
	INSERT INTO Secciones (id, Nombre, NombreAMostrar, Observaciones) VALUES ('1', 'Administracion', 'Administración','Sección de la Intranet, de administración de los datos. Se definen permisos específicos de acceso u operación en cada una de sus páginas.')
	INSERT INTO Secciones (id, Nombre, NombreAMostrar, Observaciones) VALUES ('2', 'Intranet', 'Intranet', 'Sección que ven todos los usuarios autenticados; Es una parte "intermedia", donde se realizan las operaciones de todos los días.')
	INSERT INTO Secciones (id, Nombre, NombreAMostrar, Observaciones) VALUES ('3', 'Web', 'Web', 'Sección pública. Única a la que se puede acceder sin autenticarse. Generalmente SOLO se permiten ingresos de solicitudes, como envíos de Cvs o comentarios.')
	INSERT INTO Secciones (id, Nombre, NombreAMostrar, Observaciones) VALUES ('4', 'PrivadaDelUsuario', 'Personal', 'es una parte donde cada usuario puede gestionar SOLO cuestiones de su perfil y ningún dato de otro usuario.')
	SELECT * FROM Secciones
-- INSERT VALUES: Secciones - FIN




-- INSERT VALUES: Subsistemas - INICIO
	PRINT 'Insertando Subsistemas'
	INSERT INTO Subsistemas (Nombre, Observaciones) VALUES ('Sitio Web', '')
	INSERT INTO Subsistemas (Nombre, Observaciones) VALUES ('Base de Datos', '')
	INSERT INTO Subsistemas (Nombre, Observaciones) VALUES ('Servicio Web', '')
	INSERT INTO Subsistemas (Nombre, Observaciones) VALUES ('Aplicación en Teléfonos', '')
	SELECT * FROM Subsistemas
-- INSERT VALUES: Subsistemas - FIN




-- INSERT VALUES: TiposDeArchivos - INICIO
	PRINT 'Insertando TiposDeArchivos' -- ACÁ INSERTAMOS SOLO EL DEFAULT, EL RESTO VA EN SCRIPT POSTERIOR
	-- No se define a nivel de formato (PDF, Excel, Word, etc), si no a nivel de tipo (Cad, office, Imágen, etc).
	INSERT INTO TiposDeArchivos (Nombre, Observaciones) VALUES (' -Sin Indicar-', 'Tipo de archivo no indicado.') --id=1
	SELECT * FROM TiposDeArchivos
-- INSERT VALUES: TiposDeArchivos - FIN




-- INSERT VALUES: TiposDeContactos - INICIO // ojo q se necesitan para el Insert de contextos con adicionales
	PRINT 'Insertando TiposDeContactos'
	INSERT INTO TiposDeContactos (Nombre, Observaciones) VALUES (' -Sin indicar-', '')
	INSERT INTO TiposDeContactos (Nombre, Observaciones) VALUES ('Amigos', '')
	INSERT INTO TiposDeContactos (Nombre, Observaciones) VALUES ('Clientes', '')
	INSERT INTO TiposDeContactos (Nombre, Observaciones) VALUES ('Contratados', '')
	INSERT INTO TiposDeContactos (Nombre, Observaciones) VALUES ('Contratistas', '')
	INSERT INTO TiposDeContactos (Nombre, Observaciones) VALUES ('Empleados', '')
	INSERT INTO TiposDeContactos (Nombre, Observaciones) VALUES ('Proveedores', '')
	INSERT INTO TiposDeContactos (Nombre, Observaciones) VALUES ('Socios', '')
	INSERT INTO TiposDeContactos (Nombre, Observaciones) VALUES ('Transportistas', '')
	INSERT INTO TiposDeContactos (Nombre, Observaciones) VALUES ('Vendedores', '')
	SELECT * FROM TiposDeContactos
-- INSERT VALUES: TiposDeContactos - FIN




-- INSERT VALUES: TiposDeLogLogins - INICIO
	PRINT 'Insertando TiposDeLogLogins'
	-- Dejar el MensajeDeError "vacío" fara los Login Exitosos, o indicar en él, el mesaje del Login Fallido.
	-- Para los fallidos tomo el digito del Exitoso (respecto a con UserName, Con Cookie o con sesion, y le agrego uno atrás, 
	INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, MensajeDeError, Observaciones) VALUES ('10', '0', 'Exitoso: Con UserName@Contexto', '', 'Se logueó con Usuario y Contexto')
	INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, MensajeDeError, Observaciones) VALUES ('11', '0',  'Fallido: @UsuarioQueEjecutaId <> 1', 'Error en el Login: Usuario inválido para realizar esta tarea.', 'El Login se realiza mediante el Usuario de Sistema')
	INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, MensajeDeError, Observaciones) VALUES ('12', '0',  'Fallido: Usuario Erroneo', 'Error en el Login: Revise los datos ingresados e intente nuevamente.', 'Los datos ingresados dan por resultado un SELECT nulo')
	INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, MensajeDeError, Observaciones) VALUES ('13', '0',  'Fallido: Contexto de sistemas', 'Error en el Login: No se permite operar sobre el Contexto indicado.', 'Es el contexto de sistema id=1 que no se puede operar sobre el.')
	INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, MensajeDeError, Observaciones) VALUES ('14', '0',  'Fallido: Usuario NO Activo', 'Error en el Login: El usuario no se encuentra activo. Llame al administrador del sistema.', 'Usuario identificado, pwd correcto, pero Activo = 0')
	INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, MensajeDeError, Observaciones) VALUES ('15', '0',  'Fallido: Pwd incorrecto', 'Error en el Login: Revise los datos ingresados e intente nuevamente.', 'Usuario identificado, pero el pwd es incorrecto, PERO NO LE DAREMOS EL MENSAJE CORRECTO, POR SI ES ALGUIEN QUE QUIERE HACKEAR')
	INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, MensajeDeError, Observaciones) VALUES ('19', '0',  'Usuario Bloqueado x Multiples Fallidos c/U+C', 'Usuario bloqueado x 5 intentos fallidos. Espere 5 minutos para volver a intentarlo.', 'Realizó multiples intentos fallidos de login. Posible intento de Hacking o tratar de averiguar la contraseña de un usuario')
	INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, MensajeDeError, Observaciones) VALUES ('20', '1',  'Exitoso: Con Cookie', '', 'Se logueó con la cookie')
	INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, MensajeDeError, Observaciones) VALUES ('21', '1',  'Fallido: c/Cookie y @UsuarioQueEjecutaId <> 1', 'Error en el Login: Usuario inválido para realizar esta tarea.', 'El Login se realiza mediante el Usuario de Sistema')
	INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, MensajeDeError, Observaciones) VALUES ('22', '1',  'Fallido: Cookie incorrecta', 'Error en el Login: Ingrese los datos nuevamente.', 'La cookie no coincide con ningun usuario, PERO NO LE DAREMOS EL MENSAJE CORRECTO, POR SI ES ALGUIEN QUE QUIERE HACKEAR')
	INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, MensajeDeError, Observaciones) VALUES ('23', '1',  'Fallido: c/Cookie y Contexto de sistemas', 'Error en el Login: No se permite operar sobre el Contexto indicado.', 'Es el contexto de sistema id=1 que no se puede operar sobre el.')
	INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, MensajeDeError, Observaciones) VALUES ('24', '1',  'Fallido: c/Cookie y Usuario NO Activo', 'Error en el Login: El usuario no se encuentra activo. Llame al administrador del sistema.', 'Usuario identificado, Cookie correcta, pero Activo = 0')
	INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, MensajeDeError, Observaciones) VALUES ('29', '1',  'Usuario Bloqueado x Multiples Fallidos c/Cookie', 'Usuario bloqueado x 5 intentos fallidos. Espere 5 minutos para volver a intentarlo.', 'Realizó multiples intentos fallidos de login. Posible intento de Hacking o tratar de averiguar la contraseña de un usuario')
	--INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, MensajeDeError, Observaciones) VALUES ('30', '0',  'Exitoso: Con Sesion', '', 'Se logueó con sesion del IIS')
	--INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, MensajeDeError, Observaciones) VALUES ('31', NULL,  'Fallido: @UsuarioQueEjecutaId <> 1', ' ', 'El Login se realiza mediante el Usuario de Sistema')
	--INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, MensajeDeError, Observaciones) VALUES ('34', NULL,  'Fallido: Usuario NO Activo', 'Usuario identificado, Sesion correcta, pero Activo = 0')
	--INSERT INTO TiposDeLogLogins (id, ConCookie, Nombre, MensajeDeError, Observaciones) VALUES ('35', NULL,  'Fallido: Contexto de sistemas', 'Es el contexto de sistema id=1 que no se puede operar sobre el.')
	SELECT * FROM TiposDeLogLogins
-- INSERT VALUES: TiposDeLogLogins - FIN




-- INSERT VALUES: Ubicaciones - INICIO
	PRINT 'Insertando Ubicaciones'
	INSERT INTO Ubicaciones (Nombre, Observaciones, UbicacionAbsoluta) VALUES ('Intranet/__Contenidos/Contextos/', 'Es el root de todo', 0) -- id=1: Root del sitio
	SELECT * FROM Ubicaciones
-- INSERT VALUES: Ubicaciones - FIN


-- ---------------------------
-- Script: DB_ParticularCore__19a_Insert Values del Sistema_Prioritarios 1 - Roles y Pre Tablas.sql - FIN
-- =====================================================
-- =====================================================
-- Descripción: Inserta valores genericos, que no son los principales, y podrían cambiar.
-- Script: DB_ParticularCore__C19d_Insert Values del Sistema_Prioritarios 4 - Exclusiones de Permisos.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO
 
		-- Tablas Involucradas: - INICIO
			-- SPs
			-- Tablas
			-- TablasYFuncionesDePaginas
		-- Tablas Involucradas: - FIN
				
				
-- INSERT VALUES: SPs - INICIO
	PRINT 'Insertando SPs' -- Sirven para excluirlos de que se mire permisos en ellos
	
	-- Excluimos permisos:
	INSERT INTO SPs (Nombre, SeDebenEvaluarPermisos) VALUES ('usp_TablaDinamica__BuscarLosRegFKsQueLaApuntan', '0')
	INSERT INTO SPs (Nombre, SeDebenEvaluarPermisos) VALUES ('usp_Recursos__EsResponsableDelRecurso', '0')
	
	-- Habilitamos Generación de Notificaciones y/o EnviosDeEmails:
	INSERT INTO SPs (Nombre, GeneracionDeEmailHabilitada, GeneracionDeNotificacionesHabilitada) VALUES ('usp_Tareas__Insert', '1', '1')
	INSERT INTO SPs (Nombre, GeneracionDeEmailHabilitada, GeneracionDeNotificacionesHabilitada) VALUES ('usp_Informes__Insert', '0', '1')
	INSERT INTO SPs (Nombre, GeneracionDeEmailHabilitada, GeneracionDeNotificacionesHabilitada) VALUES ('usp_Soportes__Insert', '0', '1')
	INSERT INTO SPs (Nombre, GeneracionDeEmailHabilitada, GeneracionDeNotificacionesHabilitada) VALUES ('usp_Soportes__Update_by_', '0', '1')
	
	SELECT * FROM SPs
-- INSERT VALUES: SPs - FIN




-- INSERT VALUES: Tablas - INICIO
	-- PRINT 'Actualizando Tablas' -- Sirven para excluirlos de que se mire permisos en ellas
	-- UPDATE Tablas SET SeDebenEvaluarPermisos = '0' FROM Tablas WHERE Nombre = 'DiasNoLaborables'
	-- SELECT * FROM Tablas
-- INSERT VALUES: Tablas - FIN



				
-- INSERT VALUES: TablasYFuncionesDePaginas - INICIO
	PRINT 'Insertando TablasYFuncionesDePaginas' -- Sirven para excluirlos de que se mire permisos en ellos
	
	DECLARE @TablaId INT
		, @FuncionDePaginaId INT
	
	SET @TablaId = (SELECT id FROM Tablas WHERE Nombre = 'ExtensionesDeArchivos')
	SET @FuncionDePaginaId = (SELECT id FROM FuncionesDePaginas WHERE Nombre = 'Registro')
	INSERT INTO TablasYFuncionesDePaginas (TablaId, FuncionDePaginaId, SeDebenEvaluarPermisos) VALUES (@TablaId, @FuncionDePaginaId, '0')
	
	SET @TablaId = (SELECT id FROM Tablas WHERE Nombre = 'ExtensionesDeArchivos')
	SET @FuncionDePaginaId = (SELECT id FROM FuncionesDePaginas WHERE Nombre = 'Insert')
	INSERT INTO TablasYFuncionesDePaginas (TablaId, FuncionDePaginaId, SeDebenEvaluarPermisos) VALUES (@TablaId, @FuncionDePaginaId, '0')
	
	SET @TablaId = (SELECT id FROM Tablas WHERE Nombre = 'IconosCSS')
	SET @FuncionDePaginaId = (SELECT id FROM FuncionesDePaginas WHERE Nombre = 'Registro')
	INSERT INTO TablasYFuncionesDePaginas (TablaId, FuncionDePaginaId, SeDebenEvaluarPermisos) VALUES (@TablaId, @FuncionDePaginaId, '0')
	
	SELECT * FROM TablasYFuncionesDePaginas
-- INSERT VALUES: TablasYFuncionesDePaginas - FIN


-- ---------------------------
-- Script: DB_ParticularCore__C19d_Insert Values del Sistema_Prioritarios 4 - Exclusiones de Permisos.sql - FIN
-- =====================================================
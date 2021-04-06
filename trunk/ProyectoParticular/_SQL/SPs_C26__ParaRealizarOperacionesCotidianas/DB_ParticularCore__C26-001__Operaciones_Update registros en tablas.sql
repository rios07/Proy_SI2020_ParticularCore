-- =====================================================
-- Descripción: Testing
-- Script: DB_ParticularCore__C26-001__Operaciones_Update registros en tablas.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO

				-- Variable que utilizamos en los insert - INICIO
					DECLARE @UsuarioQueEjecutaId INT = '1' -- OJO, q si va UsuarioId=1 -- > VA EN ContextoId=1 --> no logueable
						,@FechaDeEjecucion DATETIME = GetDate()
						,@sResSQL VARCHAR(1000)	
						,@id INT
						,@Nombre varchar(80) = 'IconosCSS'
				-- Variable que utilizamos en los insert - FIN
				
	--PRE:
	SELECT * FROM Tablas WHERE Nombre = @Nombre
	
	UPDATE Tablas
	SET
		CamposAExcluirEnElListado = ''
		--
	FROM Tablas
	WHERE Nombre = @Nombre
	
	--POST:
	SELECT * FROM Tablas WHERE Nombre = @Nombre
	
	
		
-- ---------------------------
-- Script: DB_ParticularCore__C26-001__Operaciones_Update registros en tablas.sql - FIN
-- =====================================================
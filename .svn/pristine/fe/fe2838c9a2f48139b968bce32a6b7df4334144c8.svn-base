-- =====================================================
-- Descripción: Creación de las TABLAS
-- Script: DB_XXX Nombre de Paginas.sql - INICIO
-- =====================================================


USE DB_XXX
GO

	
DECLARE @Tabla VARCHAR(80)
	,@FilasDeLaTabla INT
	,@i INT
			
CREATE TABLE #Tablas (id INT IDENTITY(1,1), Nombre VARCHAR(80))		-- DROP TABLE #Tablas (Lo dejo acá para cuando corre con errores y queda #Tablas creada en memoria).

INSERT INTO #Tablas SELECT 'Asociados'
INSERT INTO #Tablas SELECT 'Comitentes'
INSERT INTO #Tablas SELECT 'Computadoras'
INSERT INTO #Tablas SELECT 'Contratos'
INSERT INTO #Tablas SELECT 'Convocantes'
INSERT INTO #Tablas SELECT 'Monitores'
INSERT INTO #Tablas SELECT 'Oportunidades'
INSERT INTO #Tablas SELECT 'Perifericos'
INSERT INTO #Tablas SELECT 'Propuestas'
INSERT INTO #Tablas SELECT 'Proveedores'
INSERT INTO #Tablas SELECT 'RolesDeUsuarios'
INSERT INTO #Tablas SELECT 'Soportes'
INSERT INTO #Tablas SELECT 'Usuarios'

--SELECT '1) Imprimimos el estado ANTES de ejecutar el Script:'
--SELECT id
--      ,(SELECT Nombre FROM Tablas WHERE id = TablaId) AS Tabla
--      ,SeccionId
--      ,TablaId
--      ,FuncionDePaginaId
--      ,Nombre
--      ,Titulo
--      ,Tips
--      ,Observaciones
--      ,SeMuestraEnAsignacionDePermisos
--  FROM Paginas
--  WHERE (SELECT Nombre FROM Tablas WHERE id = TablaId) IN (SELECT Nombre FROM #Tablas)
--  ORDER BY Tabla

SET @FilasDeLaTabla = (SELECT COUNT(*) FROM #Tablas) -- Ahora lo uso para recorrer tablas
SET @i = 0 -- Cantidad de Tablas
WHILE @i < @FilasDeLaTabla 
	BEGIN
		SET @i = @i + 1
		SELECT @Tabla = Nombre FROM #Tablas WHERE (id = @i)

		--DECLARE @Tabla VARCHAR(80)= 'Propuestas' -- TABLA A LA QUE LE PISAREMOS LOS DATOS DE NOMBRE Y TITULO DE TODAS SUS PÁGINAS !!!!
		DECLARE @TablaId INT = (SELECT id FROM Tablas WHERE Nombre = @Tabla)

		UPDATE Paginas SET Nombre = (SELECT Nombre FROM Secciones WHERE id = SeccionId) 
									+ '/' + @Tabla 
									+ '/' + (SELECT NombreAMostrar FROM FuncionesDePaginas WHERE id = FuncionDePaginaId)
							,Titulo = @Tabla + ' - '  + (SELECT NombreAMostrar FROM FuncionesDePaginas WHERE id = FuncionDePaginaId)
		FROM Paginas
		WHERE TablaId = @TablaId
	END
	
--SELECT '2) Imprimimos el estado DESPUÉS de ejecutar el Script:'
--SELECT id
--      ,(SELECT Nombre FROM Tablas WHERE id = TablaId) AS Tabla
--      ,SeccionId
--      ,TablaId
--      ,FuncionDePaginaId
--      ,Nombre
--      ,Titulo
--      ,Tips
--      ,Observaciones
--      ,SeMuestraEnAsignacionDePermisos
--  FROM Paginas
--  WHERE (SELECT Nombre FROM Tablas WHERE id = TablaId) IN (SELECT Nombre FROM #Tablas)
--  ORDER BY Tabla	
	
	
DROP TABLE #Tablas				
						
-- ---------------------------
-- Script: DB_XXX Nombre de Paginas.sql - FIN
-- =====================================================
-- =====================================================
-- SP: STORE PROCEDURES - CREADOR DE SP "ABMs" - INICIO
-- -------------------------

	--Explicación:
		-- En este Script se generan auto 4 tipos de SP para las tablas indicadas:
			-- SP1: #Tabla#__Insert (Línea 250 aprox)
			-- SP2: #Tabla#__Insert_by_@' + @CampoIdsString + 'sString' (Línea 400 aprox)
			-- SP3: #Tabla#__Update_by_@id (Línea 500 aprox)
			-- SP4: #Tabla#__Update_by_@' + @CampoIdsString + 'sString' (Línea 600 aprox)
	--------------------------------
	

						-- Variables de Entrada - INICIO:
							USE DB_CPT	-- Ajustar esta también !!!!!
							GO

							DECLARE @DescripcionDelScript VARCHAR(100) = 'SPs de ABMs generados automáticamente en función de los parámetros seteados en cada tabla.'
								,@BD VARCHAR(50) = 'DB_CPT' --	Incluir el Nombre de la Base de Datos. OJO HAY QUE CAMBIAR LA DE ARRIBA TAMBIEN EL "USE".
								,@TablaDeCore BIT = '0' --		SI = '1':--> Solo Core, SI = '0':--> Solo P, SI = NULL:--> Tanto tablas de Core como de P.
								,@SoloLaTabla VARCHAR(80) = NULL --		SI = #Nombre de una tabla#:--> Imprime solo para esa, SI = NULL: --> Todas las Tablas.
								-- REGLAS: Si @SoloLaTabla = NULL --> Mira para cada Tabla que SeGeneranAutoSusSPsDeABM = '1' para armarlo.
										-- Si @SoloLaTabla = '#NombreDeTabla# --> Genera el SP sin mirar el BIT SeGeneranAutoSusSPsDeABM.
    					-- Variables de Entrada - FIN:
						
						
						
						
SET NOCOUNT  ON
DECLARE @Tabla VARCHAR(80) = ''
	,@sql nVARCHAR(MAX)
	,@FilasDeLaTabla INT
	,@FilasDeLaTablaFK INT
	,@ColumnasDeLaTabla INT
	,@x INT -- Cursor que recorre los campos (CampoFKs) de una tabla.
	,@i INT -- Cursor que recorre las tablas
	,@Coma VARCHAR(10) = ''
	,@Campo VARCHAR(100) = ''
	,@CampoFK VARCHAR(100) = '' -- Tabla FK
	,@Nomenc VARCHAR(12) = '' -- Nomenclatura
	,@NomencDeLaTablaFK VARCHAR(12) = '' -- Nomenclatura de la tabla FK
	,@TablaFK VARCHAR(80) = '' -- Tabla FK
	,@TablaDeCoreOP VARCHAR(50) = (CASE WHEN @TablaDeCore = '0' THEN 'P'
										WHEN @TablaDeCore = '1' THEN 'C'
									ELSE NULL END
								)
	,@SeGeneranAutoSusSPsDeListados BIT -- Con el Generador de SPs.
					
					
CREATE TABLE #Tablas (id INT IDENTITY(1,1)
						,Nombre VARCHAR(80)
						,Nomenclatura VARCHAR(12)
						,SeGeneranAutoSusSPsDeListados BIT)		-- DROP TABLE #Tablas (Lo dejo acá para cuando corre con errores y queda #Tablas creada en memoria).

DECLARE @Parametros NVARCHAR(MAX) --Es necesario NVARCHAR
SET @Parametros = N'@TablaDeCore BIT, @SoloLaTabla VARCHAR(80)'

SET  @sql =	('SELECT Nombre
					,Nomenclatura
					,SeGeneranAutoSusSPsDeListados 
				FROM Tablas
				WHERE (TablaDeCore = @TablaDeCore OR @TablaDeCore IS NULL)
						AND (Nombre = @SoloLaTabla OR @SoloLaTabla IS NULL)
						AND (SeGeneranAutoSusSPsDeListados = ''0'' OR @SoloLaTabla IS NOT NULL)
				ORDER BY Nombre
				')
		
INSERT INTO #Tablas EXEC sp_executesql @sql, @Parametros, @TablaDeCore = @TablaDeCore, @SoloLaTabla = @SoloLaTabla

	-- SELECT * FROM #Tablas


--SALIDA (Todo lo que va con PRINT es parte de la "salida":
PRINT '		-- Tablas Involucradas: - INICIO'

SET @FilasDeLaTabla = (SELECT COUNT(*) FROM #Tablas) -- Ahora lo uso para recorrer tablas
SET @i = 0 -- Cantidad de Tablas
WHILE @i < @FilasDeLaTabla 
	BEGIN
			-- Para facilitar la "lectura", dejo un "TAB" de separación para todo lo que no sea PRINT
			SET @i = @i + 1
			SELECT @Tabla = Nombre FROM #Tablas WHERE (id = @i)

PRINT '			-- ' + @Tabla

	END
	
PRINT '		-- Tablas Involucradas: - FIN'
PRINT ''
PRINT ''

-- RECORRO TODAS LAS TABLAS:
SET @i = 0 -- Cantidad de Tablas
WHILE @i < @FilasDeLaTabla 
	BEGIN
		-- Para facilitar la "lectura", dejo un "TAB" de separación para todo lo que no sea PRINT
			SET @i = @i + 1
			
			SELECT @Tabla = Nombre
				,@Nomenc = Nomenclatura
			FROM #Tablas WHERE (id = @i)
			
			SELECT t.name AS TABLA
				, c.name AS Columna
				,'Poner LEFT JOIN !!! ' AS LeftJoinEnElFROM
				,'AND (' + @Nomenc + '.' + c.name + ' = @' + c.name + ' OR @' + c.name + ' = ''-1'' OR (' + @Nomenc + '.' + c.name + ' IS NULL AND @' + c.name + ' = ''0'')) -- FiltroDDL (FK) NULL'
			FROM  sys.tables t inner join sys.columns c on c.object_id = t.object_id
			where t.name = @Tabla 
				AND c.is_nullable = '1'
				AND RIGHT(c.name , 2) = 'Id'

	END -- (Del While de cada @Tabla)

PRINT '-- -------------------------'

		
DROP TABLE #Tablas

-- -------------------------
-- SP: STORE PROCEDURES - CREADOR DE SP "ABMs" - FIN
-- =====================================================
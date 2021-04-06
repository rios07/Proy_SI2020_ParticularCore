-- =====================================================
-- Descripción: Creación de las TABLAS
-- Script: DB_XXX Nombre de Paginas.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO

		UPDATE Tablas 
		SET 
			--SeGeneranAutoSusSPsDeABM = '0'
			SeGeneranAutoSusSPsDeRegistros = '0'
			--SeGeneranAutoSusSPsDeListados = '0'
		FROM Tablas
		WHERE Nombre = 'HDTs'
		
						
-- ---------------------------
-- Script: DB_XXX Nombre de Paginas.sql - FIN
-- =====================================================
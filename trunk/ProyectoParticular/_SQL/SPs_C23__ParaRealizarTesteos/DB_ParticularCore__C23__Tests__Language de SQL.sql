-- =====================================================
-- Descripción: Testing
-- Script: DB_ParticularCore__C23__Tests__Language de SQL.sql - INICIO
-- =====================================================

DECLARE @Today DATETIME;  
SET @Today = '12/5/2007';  
  
SET LANGUAGE Italian;  
SELECT DATENAME(month, @Today) AS 'Month Name';  
  
SET LANGUAGE us_english;  
SELECT DATENAME(month, @Today) AS 'Month Name' ;  


SET LANGUAGE 'Spanish';  
SELECT DATENAME(month, @Today) AS 'Month Name' ; 
GO 


-- ---------------------------
-- Script: DB_ParticularCore__C23__Tests__Language de SQL.sql - FIN
-- =====================================================
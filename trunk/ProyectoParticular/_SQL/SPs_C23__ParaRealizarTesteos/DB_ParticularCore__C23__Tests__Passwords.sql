-- =====================================================
-- Descripción: Testing
-- Script: DB_ParticularCore__C23__Tests_Passwords.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO


DECLARE @Pwd	VARCHAR(40)	= '3ntr0p1A'
	,@PwdConSha	VARCHAR(40)	
	,@PwdConSha1	VARCHAR(40)	
	,@PwdConmd5	VARCHAR(40)	

EXEC @PwdConSha = [dbo].ufc_Cifrado__GenerarSHA @Pwd = @Pwd

EXEC @PwdConSha1 = [dbo].ufc_Cifrado__GenerarSHA1 @Pwd = @Pwd

EXEC @PwdConMD5 = [dbo].ufc_Cifrado__GenerarMD5 @Pwd = @Pwd

SELECT 'Pwd con Sha: ' + @PwdConSha

SELECT 'Pwd con Sha1: ' + @PwdConSha1 -- ES EL QUE UTILIZAMOS

SELECT 'Pwd con MD5: ' + @PwdConMD5


-- ---------------------------
-- Script: DB_ParticularCore__C23__Tests_Passwords.sql - FIN
-- =====================================================
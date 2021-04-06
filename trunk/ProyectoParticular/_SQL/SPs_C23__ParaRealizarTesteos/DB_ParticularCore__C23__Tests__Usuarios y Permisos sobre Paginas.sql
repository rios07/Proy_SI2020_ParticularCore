-- =====================================================
-- Descripción: Testing
-- Script: DB_ParticularCore__C23__Tests_Usuarios y Permisos sobre Paginas.sql - INICIO
-- =====================================================

USE DB_ParticularCore
GO

	SELECT  R.id
      ,P.Nombre
      ,RO.Nombre
      ,U.Nombre
      ,R.RolDeUsuarioId
      ,R.PaginaId
      ,R.AutorizadoA_CargarLaPagina
      ,R.AutorizadoA_OperarLaPagina
      ,R.AutorizadoA_VerRegAnulados
      ,R.AutorizadoA_AccionesEspeciales
  FROM RelAsig_RolesDeUsuarios_A_Paginas R
	  inner join RolesDeUsuarios RO ON RO.id = R.RolDeUsuarioId
	  inner join Paginas P ON P.id = R.PaginaId
	  inner join RelAsig_RolesDeUsuarios_A_Usuarios RU ON RU.RolDeUsuarioId = R.RolDeUsuarioId
	  INNER JOIN Usuarios U ON RU.UsuarioId = U.id
  where RO.id = 1


-- ---------------------------
-- Script: DB_ParticularCore__C23__Tests_Usuarios y Permisos sobre Paginas.sql - FIN
-- =====================================================
--Z__Controlando q falta verificar de AutorizadoA
EJEMPLO:
Formato:
EXEC \[dbo\].\[usp_Tablas__Insert\] \@UsuarioQueEjecutaId \= \@UsuarioQueEjecutaId, \@FechaDeEjecucion \= \@FechaDeEjecucion
R:
EXEC usp_Tablas__Insert \n	@UsuarioQueEjecutaId = @UsuarioQueEjecutaId \n 	,@FechaDeEjecucion = @FechaDeEjecucion \n 	,@Seccion = @Seccion

Reemplazar:
,\@Seccion \= \@Seccion
Por:
\@UsuarioQueEjecutaId \= \@UsuarioQueEjecutaId \n  		,\@FechaDeEjecucion \= \@FechaDeEjecucion \n  		,\@Token \= \@Token \n 		,\@Seccion \= \@Seccion \n  		,\@CodigoDelContexto \= \@CodigoDelContexto 


Reemplazar:
--(COn caracteres especiales): (@ --> \@) (= --> \=) ( ) 
EXEC usp_VAL_AutorizadoA_ConReg  \@UsuarioQueEjecutaId \= \@UsuarioQueEjecutaId, \@FechaDeEjecucion \= \@FechaDeEjecucion, \@Seccion \= \@Seccion, \@Tabla \= \@Tabla, \@FuncionDePagina \= \@FuncionDePagina, \@AutorizadoA \= \@AutorizadoA, \@sResSQL \= \@sResSQL OUTPUT
EXEC usp_VAL_AutorizadoA  \@UsuarioQueEjecutaId \= \@UsuarioQueEjecutaId, \@FechaDeEjecucion \= \@FechaDeEjecucion, \@Seccion \= \@Seccion, \@Tabla \= \@Tabla, \@FuncionDePagina \= \@FuncionDePagina, \@AutorizadoA \= \@AutorizadoA, \@sResSQL \= \@sResSQL OUTPUT
EXEC \@UsuarioQueEjecutaId \= usp_VAL_AutorizadoA_ConReg_ConAnonimo  \@UsuarioQueEjecutaId \= \@UsuarioQueEjecutaId, \@FechaDeEjecucion \= \@FechaDeEjecucion, \@Seccion \= \@Seccion OUTPUT, \@CodigoDelContexto \= \@CodigoDelContexto, \@Tabla \= \@Tabla, \@RegistroId \= \@id, \@FuncionDePagina \= \@FuncionDePagina, \@AutorizadoA \= \@AutorizadoA, \@sResSQL = \@sResSQL OUTPUT
EXEC \@UsuarioQueEjecutaId \= usp_VAL_AutorizadoA_ConReg_ConAnonimo  \@UsuarioQueEjecutaId \= \@UsuarioQueEjecutaId, \@FechaDeEjecucion \= \@FechaDeEjecucion, \@Seccion \= \@Seccion OUTPUT, \@CodigoDelContexto \= \@CodigoDelContexto, \@Tabla \= \@Tabla, \@RegistroId \= \@id, \@FuncionDePagina \= \@FuncionDePagina, \@AutorizadoA \= \@AutorizadoA, \@sResSQL \= \@sResSQL OUTPUT
EXEC \@UsuarioQueEjecutaId \= usp_VAL_AutorizadoA_ConAnonimo  \@UsuarioQueEjecutaId \= \@UsuarioQueEjecutaId, \@FechaDeEjecucion \= \@FechaDeEjecucion, \@Seccion \= \@Seccion OUTPUT, \@CodigoDelContexto \= \@CodigoDelContexto, \@Tabla \= \@Tabla, \@FuncionDePagina \= \@FuncionDePagina, \@AutorizadoA \= \@AutorizadoA, \@sResSQL \= \@sResSQL OUTPUT
EXEC usp_VAL_AutorizadoA_ConReg  \@UsuarioQueEjecutaId \= \@UsuarioQueEjecutaId, \@FechaDeEjecucion \= \@FechaDeEjecucion, \@Seccion \= \@Seccion, \@Tabla \= \@Tabla, \@RegistroId \= \@id, \@FuncionDePagina \= \@FuncionDePagina, \@AutorizadoA \= \@AutorizadoA, \@sResSQL \= \@sResSQL OUTPUT
--TODOS Por: (COn caracteres especiales):
EXEC usp_VAL_AutorizadoA  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto \n			, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @AutorizadoA = @AutorizadoA, @SP = @SP \n			, @RegistroId = @id \n			, @UsuarioId = @UsuarioId OUTPUT \n			, @sResSQL = @sResSQL OUTPUT

Reemplazar:
usp_VAL_UsuarioPerteneceAlContextoDelRegistro
Por:
usp_VAL_Contextos__UsuarioPerteneceAlDelRegistro
--C8A: OK
--C8B:
  
@UsuarioQueEjecutaId = @UsuarioQueEjecutaId
,@FechaDeEjecucion = @FechaDeEjecucion
,@Token = @Token
,@Seccion = @Seccion
,@CodigoDelContexto = @CodigoDelContexto
,@sResSQL = @sResSQL  OUTPUT
,@id = @id  OUTPUT -- Aquí el @id es el del trabajo.

 @id                        INT

@UsuarioQueEjecutaId        INT
,@FechaDeEjecucion          DATETIME
,@Token                     VARCHAR(40) 
,@Seccion					VARCHAR(30)
,@CodigoDelContexto			VARCHAR(40)

	
Reemplazar:
EXEC	@ContextoId = ufc_Contextos_ContextoId  @UsuarioId = @UsuarioQueEjecutaId
EXEC @ContextoId = [dbo].[ufc_Contextos_ContextoId] @UsuarioId = @UsuarioQueEjecutaId
EXEC	@ContextoId = [dbo].[ufc_Contextos_ContextoId] @UsuarioId = @UsuarioQueEjecutaId
Por:
EXEC @ContextoId = ufc_Contextos_ContextoId		@UsuarioId = @UsuarioQueEjecutaId, @Seccion = @Seccion, @CodigoDelContexto = @CodigoDelContexto


Reemplazar:
EXEC usp_ControlYLogRegistros__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Seccion = @Seccion, @Tabla = @Tabla
Por:
EXEC usp_ControlYLogRegistros__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto


Reemplazar:
,@RegistroId = @id, @Token = @Token, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @RegistrosAfectados = @@ROWCOUNT
Por:
	, @Tabla = @Tabla , @RegistroId = @id, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @RegistrosAfectados = @@ROWCOUNT


Reemplazar:
,@NumeroDeError = @@ERROR, @sResSQL = @sResSQL OUTPUT
Por:
	, @NumeroDeError = @@ERROR, @sResSQL = @sResSQL OUTPUT 


Reemplazar:
EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Seccion = @Seccion, @Tabla = @Tabla
Por:
EXEC usp_LogErroresSP__Insert  @UsuarioQueEjecutaId = @UsuarioQueEjecutaId, @FechaDeEjecucion = @FechaDeEjecucion, @Token = @Token, @Seccion = @Seccion , @CodigoDelContexto = @CodigoDelContexto

Reemplazar:
,@FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError
Por:
	, @Tabla = @Tabla, @FuncionDePagina = @FuncionDePagina, @SP = @SP, @LineaDeError = @_LineaDeError, @MensajeDeError = @_MensajeDeError

Reemplazar:
,\@NumeroDeError \= \@_NumeroDeError, \@sResSQL \= \@sResSQL OUTPUT
Por:
	, @RegistroId = @id \n , @NumeroDeError = @_NumeroDeError, @sResSQL = @sResSQL OUTPUT	


Reemplazar: (En el insert de tablas)
,\@Seccion \= \@Seccion
Por:
\@UsuarioQueEjecutaId \= \@UsuarioQueEjecutaId \n		,\@FechaDeEjecucion \= \@FechaDeEjecucion \n		,\@Token \= \@Token \n		,\@Seccion \= \@Seccion \n		,\@CodigoDelContexto \= \@CodigoDelContexto
o:
,\@Token \= \@Token \n		,\@Seccion \= \@Seccion \n		,\@CodigoDelContexto \= \@CodigoDelContexto
o:
,\@Token \= \@Token \n			,\@Seccion \= \@Seccion \n			,\@CodigoDelContexto \= \@CodigoDelContexto

	
Reemplazar:
,\@Seccion                           VARCHAR\(30\)
,\@Seccion                                                  VARCHAR\(30\)
,\@Seccion												   VARCHAR\(30\)
,\@Seccion										VARCHAR\(30\)
Por:
,@Token                     VARCHAR(40) = NULL \n 	,@Token                     VARCHAR(40) = NULL 
,@Seccion					VARCHAR(30) = NULL 
,@CodigoDelContexto			VARCHAR(40) = NULL \n	,@CodigoDelContexto			VARCHAR(40) = NULL


Reemplazar:
,@FechaDeEjecucion          		DATETIME
,@FechaDeEjecucion          			DATETIME
,@FechaDeEjecucion          				DATETIME
,@FechaDeEjecucion                              DATETIME
,@FechaDeEjecucion          						DATETIME
,@FechaDeEjecucion          							DATETIME
,@FechaDeEjecucion          								DATETIME

Por:
,@FechaDeEjecucion          DATETIME


@UsuarioQueEjecutaId			INT
@UsuarioQueEjecutaId				INT
@UsuarioQueEjecutaId					INT
@UsuarioQueEjecutaId						INT
@UsuarioQueEjecutaId							INT
@UsuarioQueEjecutaId								INT
@UsuarioQueEjecutaId									INT
@UsuarioQueEjecutaId                                      INT
Por:
@UsuarioQueEjecutaId        INT
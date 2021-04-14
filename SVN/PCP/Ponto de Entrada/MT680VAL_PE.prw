#include 'protheus.ch'
#include 'parmtype.ch'

#define JUMBO			"JUM"


/*{Protheus.Doc} MT680VAL

PE para validar a inclus�o de produ��o

@author Gustavo Luiz
@since 06/03/2018
/*/
user function MT680VAL()

	local lStatus := valid()	

return lStatus

/**
* Realiza a valida��o, se o lote esta preenchido e se � JUMBO
**/
static function valid()

	local lIsJumbo 	:= isJumbo(M->H6_PRODUTO)
	local lValid	:= .T.

	if l681

		if empty(M->H6_LOTECTL) .and. lIsJumbo
			Aviso("Alerta", "N�o � poss�vel salvar sem o preenchimento do lote para um produto JUMBO",{"Ok"}, 1)
			lValid	:= .F.
		endIf

	endIf

return lValid

/**
* Verifica se o produto � JUMBO
**/
static function isJumbo(cProduto)

	local lIsJumbo := .F.
	local cPrefixo := upper(substr(cProduto, 1, 3))

	if cPrefixo == JUMBO
		lIsJumbo := .T.
	endIf	

return lIsJumbo
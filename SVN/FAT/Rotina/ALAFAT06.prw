#Include "Protheus.ch"
#Include "Parmtype.ch"

/*/{Protheus.doc} ALAFAT05

Rotina responsável pelo cálculo do valor Alcar do produto

@author 	Ectore Cecato - Totvs IP Jundiaí
@since 		12/09/2018
@version 	Protheus 12 - Faturamento

@param cCliente, Caracter, Cliente
@param cLoja, Caracter, Loja do cliente
@param cCondPag, Caracter, Condição de pagamento
@param cProduto, Caracter, Produto
@param nCoef, Numérico, Coeficiente 

@return numérico, Valor do produto

/*/

User Function ALAFAT06()
	
	Local cUsrVend		:= AllTrim(GetNewPar("ZZ_VLDVEND", "")) + AllTrim(GetNewPar("ZZ_VLDVEN1", "")) 
	Local lRegraAlcar	:= .F.
	
	If RetCodUsr() $ cUsrVend
		lRegraAlcar := .T.
	EndIf
	
Return lRegraAlcar
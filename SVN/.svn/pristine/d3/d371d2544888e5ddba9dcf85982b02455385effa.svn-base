#Include "Protheus.ch"
#Include "Parmtype.ch"

/*/{Protheus.doc} ALGFAT02

Gatilho para calcular o valor Alcar do produto no pedido de venda

@author 	Ectore Cecato - Totvs IP Jundiaí
@since 		12/09/2018
@version 	Protheus 12 - Faturamento

@param nValor, Numérico, Valor Alcar do produto

/*/

User Function ALGFAT02()
	
	Local cCliente	:= M->C5_CLIENTE
	Local cLoja		:= M->C5_LOJACLI
	Local cCondPag	:= M->C5_CONDPAG
	Local cProduto	:= aCols[n, GdFieldPos("C6_PRODUTO")]
	Local nCoef		:= aCols[n, GdFieldPos("C6_ZZCOEF")]
	Local nValor	:= 0
	
	If U_ALAFAT06()
		nValor := U_ALAFAT05(cCliente, cLoja, cCondPag, cProduto, nCoef) 
	EndIf
	
Return nValor 
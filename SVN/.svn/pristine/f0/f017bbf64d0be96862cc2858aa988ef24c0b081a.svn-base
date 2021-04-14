#INCLUDE "totvs.ch"
#INCLUDE "topconn.ch"

#DEFINE cEOL CHR(13) + CHR(10)

/*	
	Função		:	FATA0001
	Autor		:	Ademar Pereira da Silva Junior
	Data		:	06/04/2015
	Descricao	:	Rotina para validar se o pedido está bloqueado
*/

User Function FATA0001(cPedido)
	
	Local lRet := .T.

	DbSelectArea("SC5")
	
	SC5->(DbSetOrder(1))
	
	If SC5->(DbSeek(xFilial("SC5") + cPedido))
	
		If SC5->C5_ZZBLOQ == "S"
			lRet := .F.
			Aviso("Atenção","O pedido " + AllTrim(cPedido) + " não poderá ser liberado pois está bloqueado",{"OK"})
		EndIf
	
	EndIf 
	
Return lRet
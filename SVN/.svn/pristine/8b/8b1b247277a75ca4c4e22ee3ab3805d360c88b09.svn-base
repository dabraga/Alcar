#INCLUDE "totvs.ch"

#DEFINE cEOL CHR(13) + CHR(10)

/*	
	PE			:	MT440FIL
	Autor		:	Ademar Pereira da Silva Junior
	Data		:	08/04/2015
	Descricao	:	Validacao liberação pedido - MATA440
*/

User Function MT440FIL()

	Local aArea 	:= GetArea()
	Local cAuxRet   := ".T."

	DbSelectArea("SC5")
	
	SC5->(DbSetOrder(1))
	
	If SC5->(DbSeek(xFilial("SC5")+SC6->C6_NUM))
	
		If SC5->C5_ZZBLOQ == "S"
			cAuxRet := ".F."
		EndIf
	
	EndIf
	
	RestArea(aArea)
	
Return cAuxRet
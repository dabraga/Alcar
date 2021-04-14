#INCLUDE "totvs.ch"

#DEFINE cEOL CHR(13) + CHR(10)

/*	
	PE			:	MT440AT
	Autor		:	Ademar Pereira da Silva Junior
	Data		:	07/04/2015
	Descricao	:	Validacao liberação pedidos - MATA440
*/

User Function MT440AT()
Local lRet 	:= .T.    
Local aArea	:= GetArea()

	lRet := U_FATA0001(SC5->C5_NUM)
	
	RestArea(aArea)
Return lRet
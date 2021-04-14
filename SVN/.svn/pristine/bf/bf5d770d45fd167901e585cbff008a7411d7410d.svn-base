#INCLUDE "totvs.ch"

#DEFINE cEOL CHR(13) + CHR(10)

/*	
	PE			:	MTA456P
	Autor		:	Ademar Pereira da Silva Junior
	Data		:	07/04/2015
	Descricao	:	Validacao liberação cred/est - MATA456
*/

User Function MTA456P()
Local lRet 	:= .T.    
Local aArea	:= GetArea()

	lRet := U_FATA0001(SC9->C9_PEDIDO)
	
	RestArea(aArea)
Return lRet
#INCLUDE "totvs.ch"

#DEFINE cEOL CHR(13) + CHR(10)

/*	
	PE			:	FT210OPC
	Autor		:	Ademar Pereira da Silva Junior
	Data		:	07/04/2015
	Descricao	:	Validacao liberação regras - FATA210
*/

User Function FT210OPC()
Local lRet 	:= .T.    
Local aArea	:= GetArea()

	lRet := U_FATA0001(SC5->C5_NUM)
	
	RestArea(aArea)
Return lRet
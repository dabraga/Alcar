#INCLUDE "totvs.ch"

#DEFINE cEOL CHR(13) + CHR(10)

/*	
	PE			:	MT450QRY
	Autor		:	Ademar Pereira da Silva Junior
	Data		:	07/04/2015
	Descricao	:	Filtro query - Ma450Proces()
*/

User Function MT450QRY()

	Local aArea		:= GetArea()
	Local cAuxFil 	:= ParamIxb[1]

	cAuxFil += "AND (C5_ZZBLOQ = 'N' OR C5_ZZBLOQ = ' ') "
	
	RestArea(aArea)	
	
Return cAuxFil
#INCLUDE "protheus.ch"

/**
 * Rotina		:	A650OPI
 * Autor		:	Winston Dellano - Totvs IP
 * Data			:	22/08/2014
 * Descrição	:	Ponto de entrada para gerar ou nao OPs intermediarias.
 * Modulo		:  	PCP
**/

User Function A650OPI()
            
	Local lRetorno   := .T.
	Local aAreaAtual := getArea()
	Local aAreaSB1   := SB1->(getArea())
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SG1->G1_COD)
	if SB1->B1_ZZGEROP == "1"
		lRetorno := .F.
	endif
	
	restArea(aAreaAtual)
	restArea(aAreaSB1)

Return lRetorno
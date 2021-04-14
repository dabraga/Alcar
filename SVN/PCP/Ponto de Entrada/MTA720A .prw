#Include 'Protheus.ch'

/**
 * Rotina		:	MTA720A
 * Autor		:	Ectore Cecato - Totvs Jundiaí
 * Data		:	04/10/2013
 * Descrição	:	Ponto de entrada responável por incluir registro na tabela de histórico de OP de aglutinação (Misturas)
 * Modulo		:  	PCP
**/
 
User Function MTA720A()
	
	RecLock("Z01", .T.)
		Z01->Z01_FILIAL := FWFilial("Z01") 
		Z01->Z01_PRODUT	:= TRB->PRODUTO
		Z01->Z01_OPPAI	:= IIF(!Empty(TRB->SEQPAI), SubStr(TRB->NUMOP, 1, 8)+TRB->SEQPAI, TRB->NUMOP)
		Z01->Z01_OPORIG	:= TRB->NUMOP
		Z01->Z01_OPAGLU	:= TRB->AGLUT
	MsUnlock()
		
Return Nil


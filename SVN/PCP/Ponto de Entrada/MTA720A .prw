#Include 'Protheus.ch'

/**
 * Rotina		:	MTA720A
 * Autor		:	Ectore Cecato - Totvs Jundia�
 * Data		:	04/10/2013
 * Descri��o	:	Ponto de entrada respon�vel por incluir registro na tabela de hist�rico de OP de aglutina��o (Misturas)
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


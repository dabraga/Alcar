#Include "Protheus.ch"
#Include "ParmType.ch"

/*/{Protheus.doc} ALAFAT01

Rotina respons�vel pela defini��o das novas legendas para o pedido de venda

@type function
@author Ectore Cecato - Totvs Jundia�
@since 06/08/2018
@version Protheus 12 - Faturamento

@return Array, Novas legendas [aNewLeg]

/*/

User Function ALAFAT01()
	
	Local aNewLeg := ParamIXB
	
	aAdd(aNewLeg, {"BR_PRETO", "Pedido de Venda com Bloqueio de Regra Alcar"})
	
Return aNewLeg
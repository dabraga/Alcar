#Include "Protheus.ch"
#Include "ParmType.ch"

/*/{Protheus.doc} ALAFAT02

Rotina responsável pela definição das novas cores para o pedido de venda

@type function
@author Ectore Cecato - Totvs Jundiaí
@since 13/04/2017
@version Protheus 12 - Faturamento

@return Array, Novas cores da legenda [aNewColor]

/*/

User Function ALAFAT02()
	
	Local aNewColor := aClone(ParamIXB) 
	Local nColor	:= 0
	
	For nColor := 1 To Len(aNewColor)
		aNewColor[nColor, 1] += " .And. C5_ZZBLOQ <> 'S'"
	Next nColor
	
	aAdd(aNewColor, {"C5_ZZBLOQ == 'S'", "BR_PRETO",  "Pedido de Venda com Bloqueio de Regra Alcar"})
	
Return aNewColor
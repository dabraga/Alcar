#Include "Protheus.ch"
#Include "ParmType.ch"

/*/{Protheus.doc} A410CONS

Ponto de entrada responsável pela atualização dos itens do pedido de venda

@type function
@author Ectore Cecato - Totvs Jundiaí
@since 13/04/2017
@version Protheus 12 - Faturamento

@return Array, Novas cores da legenda [aNewColor]

/*/

User Function A410CONS()

	Local aNewButton 	:= {}
	Local nItem			:= 0
	
	For nItem := 1 To Len(aCols)
				
		If aCols[nItem, GdFieldPos("C6_ZZBLOQ")] == "S"
			aCols[nItem, GdFieldPos("C6_ZZSTATU")] := "BR_VERMELHO"
		EndIf	
				
	Next nItem
	
	GetDRefresh()
	
Return aNewButton
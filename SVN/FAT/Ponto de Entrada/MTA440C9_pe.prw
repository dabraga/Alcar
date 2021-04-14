#Include 'Protheus.ch'

/*/{Protheus.doc} MTA440C9

Ponto de entrada após a gravação dos itens da SC9. Executado item a item.
Tentativa de substituição do PE MTA410T devido a erros.
 
@author Renato Castro
@since 25/02/15

/*/
User Function MTA440C9()

	local aArea := Lj7getArea({"SC6", "SC5", "SA4", "SE4"})
	
	dbSelectArea("SC6")
	dbSetOrder(1)
	if SC6->(dbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO))
		
		Reclock("SC9")
			SC9->C9_ZZNUMPC := SC6->C6_NUMPCOM
			SC9->C9_ZZITEMP := SC6->C6_ITEMPC
			SC9->C9_ZZPEDCL := SC6->C6_PEDCLI
			SC9->C9_ZZPRDCL := SC6->C6_ZZPRDCL
			SC9->C9_ZZDES 	:= SC6->C6_ZZDES
			SC9->C9_ZZREQ 	:= SC6->C6_ZZREQ
			SC9->C9_ZZCST	:= SC6->C6_CLASFIS
			SC9->C9_ZZVEND1 := Posicione("SC5", 1, xFilial("SC5")+SC6->C6_NUM, "SC5->C5_VEND1")
			SC9->C9_ZZFRETE	:= SC5->C5_TPFRETE
			SC9->C9_ZZTRANS	:= Posicione("SA4", 1, xFilial("SA4")+SC5->C5_TRANSP, "SA4->A4_NREDUZ")
			SC9->C9_ZZCONPG	:= Posicione("SE4", 1, xFilial("SE4")+SC5->C5_CONDPAG, "SE4->E4_DESCRI")
			
		SC9->(MsUnlock())
		
	endif
	
	Lj7restArea(aArea)
	
Return


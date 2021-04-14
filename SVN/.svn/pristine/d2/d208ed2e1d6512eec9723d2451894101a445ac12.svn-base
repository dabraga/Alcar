#Include 'Protheus.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} MA650DC6
Força limpeza dos campos C6_OP, C6_NUMOP e C6_ITEMOP quando a OP por
vendas é excluída. (Alcar)

@author João Gustavo Orsi
@since 05/08/2015
@version P11
/*/
//-------------------------------------------------------------------
User Function MA650DC6()

Do Case 
	Case SC6->C6_OP <> '07
		RecLock('SC6',.F.)
		SC6->C6_OP := '07'
		MsUnlock()
	Case !Empty(SC6->C6_NUMOP)
		RecLock('SC6',.F.)
		SC6->C6_NUMOP := Space(6)
		MsUnlock()
	Case !Empty(SC6->C6_ITEMOP)
		RecLock('SC6',.F.)
		SC6->C6_itemOP := Space(2)
		MsUnlock()
EndCase

Return